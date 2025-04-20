from fastapi import HTTPException, Depends, status, APIRouter
from sqlalchemy.orm import Session, joinedload
from typing import Annotated
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta, date
from pytz import timezone
from jose import JWTError, jwt

from hashlib import sha256

from exceptions import *
from models import *
from schemas import *

from database import get_db

from globalVariables import *

db_dependency = Annotated[Session, Depends(get_db)]

# Authorization definitions
class UserOAuth2PasswordBearer(OAuth2PasswordBearer):
    pass

oauth2_scheme_user = UserOAuth2PasswordBearer(tokenUrl='/usuario/token/')

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
        
def authenticate_usuario(db: db_dependency, username: str, password: str): # type: ignore
    usuario = get_usuario(db, email=username)
    
    if not usuario or not pwd_context.verify(password, usuario.password):
        return False
    
    return usuario
    
def get_current_usuario(db: db_dependency, token: Annotated[str, Depends(oauth2_scheme_user)]): # type: ignore
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
@usuario_router.post("/pedir/")
def put_order(
    pedido: PedidoCreate, 
    usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)], 
    db: Session = Depends(get_db)
):
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
        db_pedido.curcuma_id = pedido.curcuma
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

# Get general info of all pedidos
@usuario_router.get("/pedidos/general/", response_model=list[PedidoInfoGeneralResponse])
def get_general_info_pedidos(
    usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)],
    db: Session = Depends(get_db)
):    
    compras = db.query(Compra).options(
        joinedload(Compra.pedido_rel).joinedload(Pedido.saborizante_rel).joinedload(Saborizante.sabor_rel),
        joinedload(Compra.pedido_rel).joinedload(Pedido.proteina_rel)
    ).filter(
        Pedido.usuario_email == usuario.email
    ).all()
    
    response = []    
    for compra in compras:
        pedido = compra.pedido_rel
        sabor = pedido.saborizante_rel.sabor_rel.sabor
        proteina = pedido.proteina_rel
        
        response.append(PedidoInfoGeneralResponse(
            id_pedido=pedido.id_pedido,
            sabor=sabor,
            nombre_proteina=proteina.nombre,
            tipo_proteina=proteina.tipo_proteina,
            fec_hora_compra=compra.fec_hora_compra
        ))

    return response
    
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
def add_user_allergens(
    alergeno: UsuarioAlergenoCreate, 
    usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)], 
    db: Session = Depends(get_db)
):
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

