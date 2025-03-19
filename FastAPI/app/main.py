from fastapi import FastAPI, HTTPException, Depends, status, APIRouter, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session, joinedload
from typing import Annotated
from database import Sessionlocal
from dotenv import load_dotenv
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta, date
from pytz import timezone
from jose import JWTError, jwt
import os

from hashlib import sha256
import stripe
import json

from exceptions import *
from models import *
from schemas import *

load_dotenv()

app = FastAPI()
internal_router = APIRouter()

def get_db():
    db = Sessionlocal()
    
    try:
        yield db
        
    finally:
        db.close()
        
db_dependency = Annotated[Session, Depends(get_db)]

# Stripe configurations

STRIPE_SECRET_KEY = os.getenv('STRIPE_SECRET_KEY')
stripe.api_key = STRIPE_SECRET_KEY
WEBHOOK_SECRET = os.getenv('STRIPE_WEBHOOK_SECRET')

# Security configurations
SECRET_KEY = os.getenv('JWT_KEY')
pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 60*24 # Whole day

# Defines which is the endpoint for authorization
oauth2_scheme = OAuth2PasswordBearer(tokenUrl='/usuario/token/')

def create_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire_dt = datetime.now(timezone('America/Mexico_City')) + expires_delta
    to_encode.update({"exp": expire_dt})
    encoded = jwt.encode(to_encode, SECRET_KEY, algorithm = ALGORITHM)
    return encoded

def get_usuario(db: db_dependency, email: str): # type: ignore
    usuario = db.query(Usuario).filter(Usuario.email == email).first()
    
    if usuario is not None:
        return usuario
    
    # if usuario is None:
    #     raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario not found")
    # return usuario
        
def authenticate_usuario(db: db_dependency, username: str, password: str): # type: ignore
    usuario = get_usuario(db, email=username)
    
    if not usuario or not pwd_context.verify(password, usuario.password):
        return False
    
    return usuario
    
def get_current_usuario(db: db_dependency, token: Annotated[str, Depends(oauth2_scheme)]): # type: ignore
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        
        if username is None:
            raise CREDENTIALS_EXCEPTION

        token_data = TokenData(username = username)
    
    except JWTError:
        raise CREDENTIALS_EXCEPTION
    
    user = get_usuario(db, token_data.username)
    
    if user is None:
        raise CREDENTIALS_EXCEPTION
    
    return user

usuario_router = APIRouter(prefix="/usuario", tags=["usuario"])

# User auth
@usuario_router.post('/token/', response_model=UsuarioToken, tags=["usuario"])
async def get_user_token(db: db_dependency, form_data: OAuth2PasswordRequestForm = Depends()): # type: ignore
    usuario = authenticate_usuario(db, form_data.username, form_data.password)
    
    if not usuario:
        raise CREDENTIALS_EXCEPTION
    
    # If later passed, user and pass are correct
    
    # Generate JWT
    token_expires_time = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data = {'sub': form_data.username},
        expires_delta = token_expires_time
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }

# Get current authentified Usuario
@usuario_router.get("/yo/", response_model=UsuarioResponse, tags=["usuario"])
async def get_my_user(current_usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)]):
    return current_usuario

def calculateIMC(peso, talla):
    return peso/((talla/100)**2)
    
# Register Usuario account
@usuario_router.post("/registrar/", response_model=UsuarioResponse, status_code=status.HTTP_201_CREATED)
def create_user(user: UsuarioCreate, db: Session = Depends(get_db)):

    # Check if email exists
    existing_email = db.query(Usuario).filter(Usuario.email == user.email).first()
    
    if existing_email:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Maybe implement the same as above but for Usernames
    
    def calculate_age(birth_date: date) -> int:
        today = date.today()
        age = today.year - birth_date.year
        
        # Check if birthday hasn't occurred yet this year
        if (today.month, today.day) < (birth_date.month, birth_date.day):
            age -= 1
            
        return age
    
    hashed_pass = pwd_context.hash(user.password)
    calculated_IMC = calculateIMC(user.peso_kg, user.talla_cm)
    
    db_user = Usuario(
        email = user.email,
        password = hashed_pass,
        username = user.username,
        nombre = user.nombre,
        apellido = user.apellido,
        sexo = user.sexo,
        fec_nacimiento = user.fec_nacimiento,
        fec_registro = date.today(),
        edad = calculate_age(user.fec_nacimiento)
    )
    
    db_medidas = Medidas(
        imc = calculated_IMC,
        peso_kg = user.peso_kg,
        talla_cm = user.talla_cm,
        cintura_cm = user.cintura_cm,
        cadera_cm = user.cadera_cm,
        circ_brazo_cm = user.circ_brazo_cm,
        fec_actualizacion = date.today()
    )
    
    db_cantidades = Cantidades(
        proteina_gr = (calculated_IMC/30)*22,
        curcuma_gr = (calculated_IMC/30)*10
    )
    
    db.add(db_cantidades)
    db.add(db_medidas)
    db.commit()
    db.refresh(db_cantidades)
    db.refresh(db_medidas)
    
    db_user.medidas = db_medidas.id_medidas
    db_user.cantidades = db_cantidades.id_cantidades
    
    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    return db_user

# Get Usuario medidas and age
@usuario_router.get("/medidas/", response_model=UsuarioMedidasResponse)
def get_my_medidas(usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)], db: Session = Depends(get_db)):
    
    db_result = db.query(Usuario).options(
        joinedload(Usuario.medidas_rel)
    ).filter(Usuario.email == usuario.email).first()
    
    return db_result

# Put an order
@usuario_router.post("/pedido/")
def put_order(pedido: PedidoCreate, usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)], db: Session = Depends(get_db)):
    has_curcuma = pedido.curcuma != -1
    
    db_proteina: Proteina = db.query(Proteina).filter(Proteina.id_proteina == pedido.proteina).first()
    
    if not db_proteina:
        raise HTTPException(
            status_code = 404,
            detail = f"Proteina with id {pedido.proteina} does not exist"
        )
        
    db_saborizante: Saborizante = db.query(Saborizante).filter(Saborizante.id_saborizante == pedido.saborizante).first()
    
    if not db_saborizante:
        raise HTTPException(
            status_code = 404,
            detail = f"Saborizante with id {pedido.saborizante} does not exist"
        )
    
    db_curcuma: Curcuma = db.query(Curcuma).filter(Curcuma.id_curcuma == pedido.curcuma).first()
    
    if has_curcuma and not db_curcuma:
        raise HTTPException(
            status_code = 404,
            detail = f"Curcuma with id {pedido.curcuma} does not exist"
        )
    
    db_cantidades: Cantidades = db.query(Cantidades).filter(Cantidades.id_cantidades == usuario.cantidades).first()
    
    if not db_cantidades:
        raise HTTPException(
            status_code = 404,
            detail = f"User {usuario.email} does not have cantidades"
        )
    
    proteina_gr = db_cantidades.proteina_gr
    
    today = datetime.now(timezone('America/Mexico_City'))
    
    prehash = f"{usuario.email}:{pedido.proteina}:{pedido.saborizante}:{proteina_gr}:{today}"
    
    id_pedido = sha256(prehash.encode("utf-8")).hexdigest()
    
    db_pedido = Pedido(
        id_pedido = id_pedido,
        usuario_email = usuario.email,
        proteina_id = pedido.proteina,
        saborizante_id = pedido.saborizante,
        proteina_gr = proteina_gr,
        estado_canje = "no_canjeado"
    )
    
    precio = db_proteina.precio
    
    if has_curcuma:
        db_pedido.curcuma_gr = db_cantidades.curcuma_gr
        precio += db_curcuma.precio
    
    print(id_pedido)

    precio = precio * 100
    try:
        intent = stripe.PaymentIntent.create(
            amount = int(precio),
            currency='mxn',
            metadata={"id_pedido": id_pedido}
        )
        
        db.add(db_pedido)
        db.commit()
        db.refresh(db_pedido)
        
        return {
            "id_pedido": id_pedido,
            "clientSecret": intent['client_secret']
        }
        
    except Exception as e:
        raise HTTPException(
            status_code = 403,
            detail = str(e)
        )

# Stripe WebHook that either aknowledges the order or deletes it
@app.post("/stripe_webhook/")
async def stripe_webhook(request: Request, db: Session = Depends(get_db)):
    print(WEBHOOK_SECRET)
    event = None
    payload = await request.body()
    
    try:
        event = json.loads(payload)
        
    except json.decoder.JSONDecodeError as e:
        print('⚠️  Webhook error while parsing basic request.' + str(e))
        return JSONResponse(content={"success": False})
    
    sig_header = request.headers.get('stripe-signature')
    
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, WEBHOOK_SECRET
        )
        
    except stripe.error.SignatureVerificationError as e:
        print(f'⚠️  Webhook signature verification failed. {str(e)}')
        return JSONResponse(content={"success": False})

    if event and event['type'] == 'payment_intent.succeeded':
        payment_intent = event['data']['object']
        id_pedido = payment_intent["metadata"]["id_pedido"]
        amount = payment_intent["amount"]
        
        print(f'Payment for {payment_intent["metadata"]["id_pedido"]} succeeded')
        # print(f'Payment for {payment_intent["amount"]} succeeded')
        
        db_pedido = db.query(Pedido).filter(Pedido.id_pedido == id_pedido).first()
        
        if db_pedido:
            db_compra = Compra(
                pedido_id = id_pedido,
                monto_total = amount/100.0,
                fec_hora_compra = datetime.now(timezone('America/Mexico_City'))
            )
            
            db.add(db_compra)
            db.commit()
            db.refresh(db_compra)
    
    elif event and event['type'] == 'payment_intent.canceled':
        payment_intent = event['data']['object']
        print(f'Payment for {payment_intent["amount"]} canceled')
    
    elif event and event['type'] == 'payment_intent.payment_failed':
        payment_intent = event['data']['object']
        print(f'Payment for {payment_intent["amount"]} failed')
        
    else:
        print(f'Unhandled event type {event["type"]}')

    return JSONResponse(content={"success": True})
    
# Get Usuario alergenos
@usuario_router.get("/alergenos/", response_model=list[UsuarioAlergenoResponse])
def get_user_allergens(usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)], db: Session = Depends(get_db)):
    
    db_result = db.query(AlergenoUsuario).options(
        joinedload(AlergenoUsuario.alergeno_rel),
    ).filter(AlergenoUsuario.usuario_email == usuario.email).all()
    
    if not db_result:
        raise HTTPException(
            status_code = 404,
            detail=f"No allergens found for user {usuario.email}"
        )
    
    return db_result

# Add Alergeno to Usuario
@usuario_router.post("/alergenos/", response_model=list[UsuarioAlergenoResponse])
def add_user_allergens(alergeno: UsuarioAlergenoCreate, usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)], db: Session = Depends(get_db)):
    db_user_allergen = AlergenoUsuario(
        usuario_email = usuario.email,
        tipo_alergeno_id = alergeno.tipo_alergeno
    )
    
    db.add(db_user_allergen)
    db.commit()
    db.refresh(db_user_allergen)
    
    db_result = db.query(AlergenoUsuario).options(
        joinedload(AlergenoUsuario.alergeno_rel),
    ).filter(AlergenoUsuario.usuario_email == usuario.email).all()
    
    return db_result

# Get all Alergenos 
@internal_router.get("/alergenos/", response_model=list[AlergenoResponse])
def get_all_allergens(db: Session = Depends(get_db)):
    
    db_alergeno = db.query(Alergeno).all()
    
    # If not found:
    if not db_alergeno:
        raise HTTPException(
            status_code = 404,
            detail = "Alergenos not found"
        )
        
    return db_alergeno

# Get opciones de Saborizantes
@internal_router.get("/saborizante/opciones/", response_model=list[SaborizanteOptionsResponse])
def get_flavoring_options(db: Session = Depends(get_db)):
    
    results = db.query(Saborizante).options(
        joinedload(Saborizante.sabor_rel),            # Load Sabor relationship
        joinedload(Saborizante.tipo_saborizante_rel)  # Load TipoSaborizante relationship
    ).all()
    
    if not results:
        raise HTTPException(
            status_code = 404,
            detail = "Opciones de saborizante not found"
        )
    
    return results

# Get Precio of Curcuma by id
@internal_router.get("/curcuma/{id_curcuma}/precio/", response_model=CurcumaPrecioResponse)
def get_curcuma_price(id_curcuma: int, db: Session = Depends(get_db)):
    
    db_curcuma = db.query(Curcuma).filter(
        Curcuma.id_curcuma == id_curcuma
    ).first()
    
    # If not found:
    if not db_curcuma:
        raise HTTPException(
            status_code = 404,
            detail = f'Curcuma with ID {id_curcuma} not found'
        )
        
    return db_curcuma

proteina_router = APIRouter(prefix="/proteina", tags=["proteina"])

# Get opciones de Proteinas
@proteina_router.get("/opciones/", response_model=list[ProteinaOptionsResponse], tags=["proteina"])
def get_protein_options(db: Session = Depends(get_db)):
    results = db.query(Proteina).all()
    
    if not results:
        raise HTTPException(
            status_code = 404,
            detail = "No protein options found"
        )
    
    return results

# Get Precio of Proteina by id
@proteina_router.get("/{id_proteina}/precio/", response_model=ProteinaPrecioResponse, tags=["proteina"])
def get_protein_price(id_proteina: int, db: Session = Depends(get_db)):
    
    db_proteina = db.query(Proteina).filter(
        Proteina.id_proteina == id_proteina
    ).first()
    
    # If not found:
    if not db_proteina:
        raise HTTPException(
            status_code = 404,
            detail = f'Protein with ID {id_proteina} not found'
        )
        
    return db_proteina

# Get Alergenos of Proteina by id
@proteina_router.get("/{id_proteina}/alergenos/", response_model=list[AlergenoProteinaResponse], tags=["proteina"])
def get_protein_allergens(id_proteina: int, db: Session = Depends(get_db)):
    
    results = db.query(AlergenoProteina).filter(
        AlergenoProteina.proteina == id_proteina
    ).options(
        joinedload(AlergenoProteina.alergeno_rel)
    ).all()
    
    if not results:
        raise HTTPException(
            status_code = 404,
            detail=f"No allergens found for protein ID {id_proteina}"
        )
    
    return results

internal_router.include_router(usuario_router)
internal_router.include_router(proteina_router)
app.include_router(internal_router)