import asyncio

from fastapi import HTTPException, Depends, status, APIRouter
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi.responses import HTMLResponse

from sqlalchemy.orm import Session, joinedload
from typing import Annotated
from datetime import datetime, timedelta, date
from pytz import timezone
from jose import JWTError, jwt

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

import secrets
import string

from hashlib import sha256

from exceptions import *
from models import *
from schemas import *

from database import get_db

from globalVariables import *

used_tokens = {}

db_dependency = Annotated[Session, Depends(get_db)]

async def cleanup_task():
    while True:
        await asyncio.sleep(300)
        cutoff = datetime.utcnow() - timedelta(minutes=+1)
        to_delete = [token for token, ts in used_tokens.items() if ts < cutoff]
        for token in to_delete:
            print(f"Deleted: {token}")
            del used_tokens[token]

# Authorization definitions
class UserOAuth2PasswordBearer(OAuth2PasswordBearer):
    pass

oauth2_scheme_user = UserOAuth2PasswordBearer(tokenUrl='/usuario/token/')

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
@usuario_router.post('/token/', response_model=Token, tags=["usuario"])
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

def calculateCantidades(imc, edad, sexo, circ_brazo_cm, cintura_cm, cadera_cm, peso_kg):     
    def miniFunc(lower, upper, val):
        if val < lower: return 'bajo'
        if lower <= val <= upper: return 'normal'
        if circ_brazo_cm > upper: return 'alto'
    
    def getICCRiesgo():
        ICC = cintura_cm/cadera_cm
        
        if sexo == 'Masculino': return miniFunc(0.9, 0.99, ICC)
        else:                   return miniFunc(0.8, 0.84, ICC)
    
    def getCMBLevel():
        if sexo == 'Masculino':
            if   18 <= edad <= 24: return miniFunc(26, 30, circ_brazo_cm)
            elif 25 <= edad <= 34: return miniFunc(26, 31, circ_brazo_cm)
            elif 35 <= edad <= 44: return miniFunc(25, 30, circ_brazo_cm)
            elif 45 <= edad <= 54: return miniFunc(25, 29, circ_brazo_cm)
            elif 55 <= edad <= 64: return miniFunc(24, 28, circ_brazo_cm)
            elif 65 <= edad:       return miniFunc(23, 27, circ_brazo_cm)
        else:
            if   18 <= edad <= 24: return miniFunc(23, 28, circ_brazo_cm)
            elif 25 <= edad <= 34: return miniFunc(23, 28, circ_brazo_cm)
            elif 35 <= edad <= 44: return miniFunc(22, 27, circ_brazo_cm)
            elif 45 <= edad <= 54: return miniFunc(22, 27, circ_brazo_cm)
            elif 55 <= edad <= 64: return miniFunc(21, 26, circ_brazo_cm)
            elif 65 <= edad:       return miniFunc(21, 25, circ_brazo_cm)

    ajusteCMB = 0
    ajusteICC = 0
    nivelCMB = getCMBLevel()
    riesgoICC = getICCRiesgo()
    
    if   nivelCMB == 'bajo':    ajusteCMB = -0.2
    elif nivelCMB == 'normal':  ajusteCMB = 0
    elif nivelCMB == 'alto':    ajusteCMB = 0.2
    
    if   riesgoICC == 'bajo':   ajusteICC = 0
    elif riesgoICC == 'normal': ajusteICC = -0.1
    elif riesgoICC == 'alto':   ajusteICC = -0.2
    
    factorProteico = (2.2 - (imc * 0.05)) + ajusteCMB + ajusteICC
    proteinaPura = (peso_kg * factorProteico)/3
    
    return {
        'proteina_gr': proteinaPura,
        'curcuma_gr': 2,
    }

@usuario_router.delete("/deleteMe/", status_code=204)
def deleteCurrentUser(
    user: Annotated[UsuarioResponse, Depends(get_current_usuario)],
    db: Session = Depends(get_db)
):

    # Step 2: Delete related Medidas
    if user.medidas:
        medidas = db.query(Medidas).filter(Medidas.id_medidas == user.medidas).first()
        if medidas:
            db.delete(medidas)

    # Step 3: Delete related Cantidades
    if user.cantidades:
        cantidades = db.query(Cantidades).filter(Cantidades.id_cantidades == user.cantidades).first()
        if cantidades:
            db.delete(cantidades)

    # Step 4: Delete the user
    db.delete(user)
    db.commit()

# Update Usuario info
@usuario_router.put("/updateMe/", status_code=204)
def updateUserInfo(newInfo: UserUpdate, user: Annotated[UsuarioResponse, Depends(get_current_usuario)], db: Session = Depends(get_db)):
    user.nombre = newInfo.nombre
    user.apellido = newInfo.apellido
    user.username = newInfo.username

    # Commit changes
    db.commit()

# Update Usuario medidas
@usuario_router.put("/updateMedidas/", status_code=204)
def updateUserMedidas(medidas: MedidasUpdate, user: Annotated[UsuarioResponse, Depends(get_current_usuario)], db: Session = Depends(get_db)):
    
    medidas_obj = db.query(Medidas).filter(Medidas.id_medidas == user.medidas).first()
    if not medidas_obj:
        raise HTTPException(status_code=404, detail="Medidas no encontradas")
    
    cantidades_obj = db.query(Cantidades).filter(Cantidades.id_cantidades == user.cantidades).first()
    if not cantidades_obj:
        raise HTTPException(status_code=404, detail="Cantidades no encontradas")

    calculated_imc = calculateIMC(medidas.peso_kg, medidas.talla_cm)
    medidas_obj.peso_kg = medidas.peso_kg
    medidas_obj.talla_cm = medidas.talla_cm
    medidas_obj.cintura_cm = medidas.cintura_cm
    medidas_obj.cadera_cm = medidas.cadera_cm
    medidas_obj.circ_brazo_cm = medidas.circ_brazo_cm
    medidas_obj.imc = calculated_imc
    medidas_obj.fec_actualizacion = date.today()
    
    db.commit()
    
    calculated_age = calculate_age(user.fec_nacimiento)
    
    cantidades = calculateCantidades(
        calculated_imc,
        calculated_age,
        user.sexo,
        medidas.circ_brazo_cm,
        medidas.cintura_cm,
        medidas.cadera_cm,
        medidas.peso_kg
    )
    
    cantidades_obj.proteina_gr = cantidades['proteina_gr']
    cantidades_obj.curcuma_gr = cantidades['curcuma_gr']
    
    db.commit()
    
def calculate_age(birth_date: date) -> int:
    today = date.today()
    age = today.year - birth_date.year
    
    # Check if birthday hasn't occurred yet this year
    if (today.month, today.day) < (birth_date.month, birth_date.day):
        age -= 1
        
    return age

# Register Usuario account
@usuario_router.post("/registrar/", response_model=UsuarioResponse, status_code=status.HTTP_201_CREATED)
def create_user(user: UsuarioCreate, db: Session = Depends(get_db)):

    # Check if email exists
    existing_email = db.query(Usuario).filter(Usuario.email == user.email).first()
    
    if existing_email:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Maybe implement the same as above but for Usernames
    
    hashed_pass = pwd_context.hash(user.password)
    calculated_IMC = calculateIMC(user.peso_kg, user.talla_cm)
    calculated_age = calculate_age(user.fec_nacimiento)
    
    db_user = Usuario(
        email = user.email,
        password = hashed_pass,
        username = user.username,
        nombre = user.nombre,
        apellido = user.apellido,
        sexo = user.sexo,
        fec_nacimiento = user.fec_nacimiento,
        fec_registro = date.today(),
        edad = calculated_age
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
    
    cantidades = calculateCantidades(
        calculated_IMC,
        calculated_age,
        user.sexo,
        user.circ_brazo_cm,
        user.cintura_cm,
        user.cadera_cm,
        user.peso_kg
    )
    
    # Aqui llamar a la funcion para calcular las cantidades correctas    
    db_cantidades = Cantidades(
        proteina_gr = cantidades['proteina_gr'],
        curcuma_gr = cantidades['curcuma_gr']
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
    compras = (
        db.query(Compra)
        .options(
            joinedload(Compra.pedido_rel).joinedload(Pedido.saborizante_rel).joinedload(Saborizante.sabor_rel),
            joinedload(Compra.pedido_rel).joinedload(Pedido.proteina_rel),
        )
        .join(Compra.pedido_rel)
        .filter(Pedido.usuario_email == usuario.email)
        .all()
    )
        
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

# Send email "Temporary password"
@usuario_router.put("/updatePassword/", status_code=204)
def update_password(
    newpass: UpdatePassword, 
    user: Annotated[UsuarioResponse, Depends(get_current_usuario)],
    db: Session = Depends(get_db)
):
    password = newpass.password
    hashed_pass = pwd_context.hash(password)
    
    user.password = hashed_pass
        
    db.commit()

def mark_token_used(token: str):
    used_tokens[token] = datetime.now(timezone('America/Mexico_City'))
    
def is_token_used(token: str) -> bool:
    return token in used_tokens

# Really confirm the tempPass 
@usuario_router.post("/confirmResetPassword/")
def confirmResetPasswordEmail(resetToken: ResetTokenData, db: Session = Depends(get_db)):
    email = verify_password_reset_token(resetToken.token)
    
    if is_token_used(resetToken.token):
        raise HTTPException(
            status_code = 403,
            detail=f"Este token ya fue usado"
        )
    
    mark_token_used(resetToken.token)
    
    user:Usuario = db.query(Usuario).filter(Usuario.email == email).first()
    
    if not user:
        raise HTTPException(
            status_code = 403,
            detail = f"El usuario {email} no existe"
        )
    
    tempPass = generate_temp_password()
    hashed_pass = pwd_context.hash(tempPass)
    
    user.password = hashed_pass
        
    db.commit()
    
    msg = MIMEMultipart()
    msg['From'] = NOREPLY_EMAIL
    msg['To'] = email
    msg['Subject'] = "BoostUp - Petición de restablecer contraseña"
    
    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Tu contraseña temporal</title>
    </head>
    <body style="font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px; text-align: center;">
    <div style="max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        
        <!-- Logo -->
        <img src="https://boostup.life/logo.png" alt="Boost up logo" style="max-width: 150px; margin-bottom: 20px; display: block; margin-left: auto; margin-right: auto;">

        <h2>Tu contraseña temporal</h2>
        <p>Hola,</p>
        <p>Aquí esta tu contraseña temporal. Utilízala para ingresar y cámbiala de volada!</p>

        <!-- Temporary Password -->
        <p style="font-size: 24px; font-weight: bold; color: #333; margin: 20px 0;">
        {tempPass}
        </p>

        <p style="margin-top: 30px; font-size: 12px; color: #666;">
        Si no solicitaste esto, te recomendamos cambiar tu contraseña lo antes posible. Si tienes dudas, contáctenos.
        </p>
    </div>
    </body>
    </html>
    """
    
    part = MIMEText(html, 'html')
    msg.attach(part)
    
    try:
        with smtplib.SMTP_SSL(SMTP_SERVER, 465) as smtp:
            smtp.login(NOREPLY_EMAIL, NOREPLY_EMAIL_PASSWORD)
            # Send the email
            smtp.sendmail(NOREPLY_EMAIL, email, msg.as_string())
        print("Email sent successfully!")
        
    except Exception as e:
        print(f"Error sending email: {e}")

# Send email "Temporary password"
@usuario_router.get("/resetPassword/{resetToken}")
def sendResetPasswordEmail(resetToken: str, db: Session = Depends(get_db)):
        
    return HTMLResponse(f"""
            <!DOCTYPE html>
            <html>
            <head>
            <script>
                fetch("/usuario/confirmResetPassword/", {{
                    method: "POST",
                    headers: {{ "Content-Type": "application/json" }},
                    body: JSON.stringify({{ token: "{resetToken}" }})
                }}).then(() => {{
                    window.close();
                }});
            </script>
            </head>
            <body>
            <p>Ya te enviamos tu contraseña temporal a tu correo, puedes cerrar esta página.</p>
            </body>
            </html>
        """)

def create_password_reset_token(email: str) -> str:
    token_expires_time = timedelta(minutes=RESET_TOKEN_EXPIRE_MINUTES)
    expire_dt = datetime.now(timezone('America/Mexico_City')) + token_expires_time
    payload = {
        "sub": email,
        "exp": expire_dt,
        "scope": "password_reset"
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return token

def verify_password_reset_token(token: str) -> str:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        if payload.get("scope") != "password_reset":
            raise ValueError("Invalid scope for token")
        return payload.get("sub")  # typically the user's email
    
    except JWTError:
        raise HTTPException(status_code=400, detail="Invalid or expired token")

def generate_temp_password(length: int = 12, use_symbols: bool = True) -> str:
    characters = string.ascii_letters + string.digits
    if use_symbols:
        characters += "!@#$%^&*()-_=+[]{}"
    
    return ''.join(secrets.choice(characters) for _ in range(length))

# Send email "Forgot password"
@usuario_router.post("/forgotPassword/")
def sendForgotPasswordEmail(email_obj: EmailPost, db: Session = Depends(get_db)):
    email = email_obj.email
    
    user = db.query(Usuario).filter(Usuario.email == email).first()
    
    if not user:
        raise HTTPException(
            status_code = 403,
            detail = f"El usuario {email} no existe"
        )
    
    resetToken = create_password_reset_token(email)
    
    msg = MIMEMultipart()
    msg['From'] = NOREPLY_EMAIL
    msg['To'] = email
    msg['Subject'] = "BoostUp - Petición de restablecer contraseña"
    
    html = f"""
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Petición de restablecer contraseña</title>
    </head>
    <body style="font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px; text-align: center;">
    <div style="max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
        
        <!-- Logo -->
        <img src="https://boostup.life/logo.png" alt="Boost up logo" style="max-width: 150px; margin-bottom: 20px; display: block; margin-left: auto; margin-right: auto;">

        <h2>¿Extraviaste tu contraseña?</h2>
        <p>Hola,</p>
        <p>Me parece que haz solicitado restablecer tu contraseña. Haz clic en el botón de abajo y te enviaremos una contraseña temporal de volada!</p>

        <!-- Button -->
        <a href="https://boostup.life/usuario/resetPassword/{resetToken}" style="display: inline-block; padding: 12px 24px; background-color: #7a5af8; color: white; text-decoration: none; border-radius: 6px; margin-top: 20px;">
        Envíame una contraseña temporal
        </a>

        <p style="margin-top: 30px; font-size: 12px; color: #666;">
        Si no solicitaste esto, ignora este mensaje. No se ha realizado ningún cambio en tu cuenta.
        </p>
    </div>
    </body>
    </html>
    """
    
    part = MIMEText(html, 'html')
    msg.attach(part)
    
    try:
        with smtplib.SMTP_SSL(SMTP_SERVER, 465) as smtp:
            smtp.login(NOREPLY_EMAIL, NOREPLY_EMAIL_PASSWORD)
            # Send the email
            smtp.sendmail(NOREPLY_EMAIL, email, msg.as_string())
        print("Email sent successfully!")
        
    except Exception as e:
        print(f"Error sending email: {e}")
    
    
    