from fastapi import FastAPI, HTTPException, Depends, status, APIRouter, Request
from fastapi.responses import JSONResponse
from sqlalchemy import func, extract, and_
from sqlalchemy.orm import Session, joinedload
from typing import Annotated, Union, Type, Any
from dotenv import load_dotenv
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta, date
from pytz import timezone
from jose import JWTError, jwt
import os

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from hashlib import sha256

from exceptions import *
from models import *
from schemas import *

from globalVariables import *

from database import get_db

db_dependency = Annotated[Session, Depends(get_db)]

from user_routes import hasPermissionToConsume

class OwnerAuth(OAuth2PasswordBearer):
    pass

class TechnicianAuth(OAuth2PasswordBearer):
    pass

oauth2_scheme_owner = OwnerAuth(tokenUrl='/owner/token/')
oauth2_scheme_technician = TechnicianAuth(tokenUrl='/technician/token/')

def get_owner(db: db_dependency, username: str): # type: ignore
    owner = db.query(Owner).filter(Owner.username == username).first()
    
    if owner is not None:
        return owner

def get_technician(db: db_dependency, username: str): # type: ignore
    technician = db.query(Technician).filter(Technician.username == username).first()
    
    if technician is not None:
        return technician

def authenticate_owner(db: db_dependency, username: str, password: str): # type: ignore
    owner = get_owner(db, username=username)
    
    if not owner or not pwd_context.verify(password, owner.password):
        return False
    
    return owner

def authenticate_technician(db: db_dependency, username: str, password: str): # type: ignore
    technician = get_technician(db, username=username)
    
    if not technician or not pwd_context.verify(password, technician.password):
        return False
    
    return technician

def get_current_owner(db: db_dependency, token: Annotated[str, Depends(oauth2_scheme_owner)]): # type: ignore
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        role: str = payload.get("role")
        
        if role != "owner":
            raise HTTPException(status_code=403, detail="Invalid role for owner route")
        
        if username is None:
            raise CREDENTIALS_EXCEPTION

        token_data = TokenData(username = username)
    
    except JWTError:
        raise CREDENTIALS_EXCEPTION
    
    user = get_owner(db, token_data.username)
    
    if user is None:
        raise CREDENTIALS_EXCEPTION
    
    return user

def get_current_technician(db: db_dependency, token: Annotated[str, Depends(oauth2_scheme_technician)]): # type: ignore
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        role: str = payload.get("role")
        
        if role != "technician":
            raise HTTPException(status_code=403, detail="Invalid role for technician route")
        
        if username is None:
            raise CREDENTIALS_EXCEPTION

        token_data = TokenData(username = username)
    
    except JWTError:
        raise CREDENTIALS_EXCEPTION
    
    user = get_technician(db, token_data.username)
    
    if user is None:
        raise CREDENTIALS_EXCEPTION
    
    return user

def get_current_tech_or_owner(
    token: str = Depends(oauth2_scheme_technician),
    db: Session = Depends(get_db)) -> CurrentTechOrOwner:
    
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        role: str = payload.get("role")

        if role == "owner":
            owner = db.query(Owner).filter(Owner.username == username).first()
            if not owner:
                raise HTTPException(status_code=404, detail="Owner not found")

            return CurrentTechOrOwner(
                username = owner.username, 
                role = "owner", 
                machine = owner.machine, 
                name = owner.name, 
                lastname = owner.lastname
            )

        elif role == "technician":
            tech = db.query(Technician).filter(Technician.username == username).first()
            if not tech:
                raise HTTPException(status_code=404, detail="Technician not found")
            return CurrentTechOrOwner(
                username = tech.username, 
                role = "technician", 
                machine = tech.machine, 
                name = tech.name, 
                lastname = tech.lastname
            )
                

        raise HTTPException(status_code=403, detail="Invalid role")

    except JWTError:
        raise CREDENTIALS_EXCEPTION

owner_router = APIRouter(prefix="/owner", tags=["owner"])
technician_router = APIRouter(prefix="/technician", tags=["technician"])
owner_tech_router = APIRouter(prefix="/owner_or_tech", tags=["owner & technician"])
machine_router = APIRouter(prefix="/machine", tags=["machine"])

@owner_router.post("/token/", response_model=Token)
async def get_owner_token(db: db_dependency, form_data: OAuth2PasswordRequestForm = Depends()): # type: ignore
    owner = authenticate_owner(db, form_data.username, form_data.password)

    if not owner:
        raise CREDENTIALS_EXCEPTION
    
    # If later passed, user and pass are correct
    
    # Generate JWT
    access_token = create_access_token_for_user(
        username = form_data.username,
        role = "owner",
        expires_delta = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }

@technician_router.post("/token/", response_model=Token)
async def get_technician_token(db: db_dependency, form_data: OAuth2PasswordRequestForm = Depends()): # type: ignore
    technician = authenticate_technician(db, form_data.username, form_data.password)

    if not technician:
        raise CREDENTIALS_EXCEPTION
    
    # If later passed, user and pass are correct
    
    # Generate JWT
    access_token = create_access_token_for_user(
        username = form_data.username,
        role = "technician",
        expires_delta = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }

# Get current authentified Owner
@owner_router.get("/yo/", response_model=OwnerResponse)
async def get_my_owner(current_owner: Annotated[OwnerResponse, Depends(get_current_owner)]): return current_owner

# Get current authentified Technician
@technician_router.get("/yo/", response_model=TechnicianResponse)
async def get_my_technician(current_technician: Annotated[TechnicianResponse, Depends(get_current_technician)]):
    return current_technician

# Get inventory Values
@owner_tech_router.get("/inventario/")
async def getInventory(user: Annotated[CurrentTechOrOwner, Depends(get_current_tech_or_owner)], db: Session = Depends(get_db)):
    machine = db.query(Maquina).filter(Maquina.id_maquina == user.machine).first()
    
    if not machine:
        raise HTTPException(status_code=404, detail="No se encontro la maquina")

    # Fetch inventory items linked to that machine
    proteinas = db.query(InvProteina).filter(InvProteina.maquina == machine.id_maquina).all()
    saborizantes = db.query(InvSaborizante).filter(InvSaborizante.maquina == machine.id_maquina).all()
    curcumas = db.query(InvCurcuma).filter(InvCurcuma.maquina == machine.id_maquina).all()

    # Convert to dicts (or use Pydantic if needed)
    def serialize(model_instance):
        return {column.name: getattr(model_instance, column.name) for column in model_instance.__table__.columns}

    inventory = {
        "Proteina": [serialize(p) for p in proteinas],
        "Saborizante": [serialize(s) for s in saborizantes],
        "Curcuma": [serialize(c) for c in curcumas],
    }

    return inventory

@owner_tech_router.get("/tipos-fallo/", response_model=list[TipoFalloResponse])
def get_failure_types(
    user: Annotated[CurrentTechOrOwner, Depends(get_current_tech_or_owner)],
    db: Session = Depends(get_db)
):
    tipos = db.query(TipoFallo).order_by(TipoFallo.id_tipo_fallo).all()
    return tipos

@owner_tech_router.get("/maquina/fallos/", response_model=list[FalloResponse])
def get_machine_fails(
    user: Annotated[CurrentTechOrOwner, Depends(get_current_tech_or_owner)],
    db: Session = Depends(get_db)
):
    machine = db.query(Maquina).get(user.machine)
    if not machine:
        raise HTTPException(404, "No se encontró la máquina")
    
    failures = (
        db.query(Fallo)
        .filter(Fallo.maquina == machine.id_maquina)
        .order_by(Fallo.fec_hora.desc())
        .all()
    )
   
    return failures

def emailFailure(failure: Fallo, techs: list[Technician], machine: Maquina):
    # List of email addresses
    emails = [tech.email for tech in techs]
    to_field = ", ".join(emails)

    # Greeting names: "Juan (jlopez), María (marias)"
    greeting_names = ", ".join([f"{tech.name} ({tech.username})" for tech in techs])

    # Determine singular or plural phrasing
    plural = len(techs) > 1
    saludo = "Hola a todos" if plural else "Hola"
    pronoun = "ustedes" if plural else "ti"
    verb = "revisen" if plural else "revisa"
    mensaje_equipo = "Su dedicación y experiencia son" if plural else "Tu dedicación y experiencia es"
    mensaje_final = "¡Gracias por ser pilares fundamentales de nuestro equipo!" if plural else "¡Gracias por ser un pilar fundamental de nuestro equipo!"

    msg = MIMEMultipart()
    msg['From'] = NOREPLY_EMAIL
    msg['To'] = to_field
    msg['Subject'] = f"BoostUp - Fallo reportado #{failure.id_fallo}"
    
    html = (
    f"""
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Nuevo fallo registrado</title>
    </head>
    <body style="font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px; text-align: center;">
    <div style="max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">

        <!-- Logo -->
        <img src="https://boostup.life/logo.png" alt="Boost up logo"
            style="max-width: 150px; margin-bottom: 20px; display: block; margin-left: auto; margin-right: auto;">

        <h2>🚨 Nuevo fallo registrado</h2>
        <p>{saludo} {greeting_names},</p>
        <p>Se ha registrado un nuevo fallo en la máquina asignada a {pronoun}. A continuación los detalles:</p>

        <div style="text-align: left; background-color: #f2f2f2; padding: 20px; border-radius: 8px; margin: 20px 0;">
        <p><strong>ID de Fallo:</strong> {failure.id_fallo}</p>
        <p><strong>Fecha y hora:</strong> {failure.fec_hora.strftime("%Y-%m-%d %H:%M:%S")}</p>
        <p><strong>Tipo de fallo:</strong> {failure.tipo_fallo_nombre} (ID {failure.tipo_fallo})</p>
        <p><strong>Descripción:</strong> {failure.descripcion or "— Sin descripción —"}</p>
        <p><strong>Ubicación máquina:</strong> {machine.ubicacion or "— No disponible —"}</p>
        </div>

        <p style="margin-top: 30px;">Por favor, {verb} este incidente a la brevedad.</p>

        <p style="margin-top: 40px; font-size: 12px; color: #666;">
            {mensaje_equipo} el corazón de nuestra operación. {mensaje_final}
        </p>
    </div>
    </body>
    </html>
    """
    )

    part = MIMEText(html, 'html')
    msg.attach(part)

    try:
        with smtplib.SMTP_SSL(SMTP_SERVER, 465) as smtp:
            smtp.login(NOREPLY_EMAIL, NOREPLY_EMAIL_PASSWORD)
            smtp.sendmail(NOREPLY_EMAIL, emails, msg.as_string())
        print("Email sent successfully!")

    except Exception as e:
        print(f"Error sending email: {e}")

        
def emailHumidity(humidity_obj: HistorialHumedad, tech: Technician, machine: Maquina):
    email = tech.email
    
    msg = MIMEMultipart()
    msg['From'] = NOREPLY_EMAIL
    msg['To'] = email
    msg['Subject'] = f"BoostUp - Alta humedad reportada en maquina #{machine.id_maquina}"
    
    html = (
    f"""
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Alta humedad reportada</title>
    </head>
    <body style="font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px; text-align: center;">
    <div style="max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">

        <!-- Logo -->
        <img src="https://boostup.life/logo.png" alt="Boost up logo"
            style="max-width: 150px; margin-bottom: 20px; display: block; margin-left: auto; margin-right: auto;">

        <h2>💦 Alta humedad reportada</h2>
        <p>Hola { tech.name } ({ tech.username }),</p>
        <p>Se ha registrado alta humedad en la máquina asignada a ti. A continuación los detalles:</p>

        <div style="text-align: left; background-color: #f2f2f2; padding: 20px; border-radius: 8px; margin: 20px 0;">
        <p><strong>Fecha y hora:</strong> {humidity_obj.fecha_hora.strftime("%Y-%m-%d %H:%M:%S")}</p>
        <p><strong>Humedad:</strong> {humidity_obj.humedad}% </p>
        <p><strong>Ubicación máquina:</strong> { machine.ubicacion or "— No disponible —" }</p>
        </div>

        <p style="margin-top: 30px;">Por favor, revisa este incidente a la brevedad.</p>

        <p style="margin-top: 40px; font-size: 12px; color: #666;">
            Tu dedicación y experiencia son el corazón de nuestra operación. ¡Gracias por ser un pilar fundamental de nuestro equipo!
        </p>
    </div>
    </body>
    </html>
    """
    )
    
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

@owner_tech_router.post("/maquina/fallos/", response_model=FalloResponse)
def insert_machine_fail(
    user: Annotated[CurrentTechOrOwner, Depends(get_current_tech_or_owner)],
    fallo_in: FalloCreate,
    db: Session = Depends(get_db)
):
    machine = db.query(Maquina).get(user.machine)
    if not machine:
        raise HTTPException(404, "No se encontró la máquina")
    
    tipo = db.get(TipoFallo, fallo_in.tipo_fallo)
    if not tipo:
        raise HTTPException(
            status_code=404,
            detail=f"Tipo de fallo con id={fallo_in.tipo_fallo} no existe"
        )
    
    new_fallo = Fallo(
        maquina=machine.id_maquina,
        tipo_fallo=tipo.id_tipo_fallo,
        fec_hora=fallo_in.fec_hora,
        descripcion=fallo_in.descripcion,
    )
    
    db.add(new_fallo)
    db.commit()
    db.refresh(new_fallo)
    
    techList = db.query(Technician).filter(Technician.machine == machine.id_maquina).all()
    
    if not techList:
        raise HTTPException(
            status_code=404,
            detail=f"El fallo se insertó pero no pudimos encontrar a ningun técnico responsable de la máquina"
        )
        
    emailFailure(new_fallo, techList, machine)

    return new_fallo

def get_machine_for_tech(
    tech: TechnicianResponse = Depends(get_current_technician),
    db: Session = Depends(get_db)
) -> Maquina:
    machine = db.query(Maquina).get(tech.machine)
    if not machine:
        raise HTTPException(404, "No se encontró la máquina")
    return machine

def get_machine_for_owner(
    owner: OwnerResponse = Depends(get_current_owner),
    db: Session = Depends(get_db)
) -> Maquina:
    machine = db.query(Maquina).get(owner.machine)
    if not machine:
        raise HTTPException(404, "No se encontró la máquina")
    return machine

def get_inventory_or_404(
    db: Session,
    model: Type[Any],
    id_field: str,
    obj_id: int,
    machine_id: int
):
    filt = {
        id_field: obj_id,
        "maquina": machine_id
    }
    inv = db.query(model).filter_by(**filt).first()
    if not inv:
        raise HTTPException(404, f"No se encontró el inventario ({model.__tablename__})")
    return inv

def restock_inv(
    inv: Any,
    req: BaseModel,
    *,
    quantity_field: str,
    expiration_field: str,
    ingredient_field: str,
    now: datetime,
    prev_date_attr: str = "fec_prev_abasto",
    last_date_attr: str = "fec_ult_abasto",
    limit_date_field: str = "fec_limite_abasto",
):
    # shift old timestamp → prev
    old_dt = getattr(inv, last_date_attr)
    setattr(inv, prev_date_attr, old_dt.date())

    # set new values
    setattr(inv, ingredient_field, getattr(req, ingredient_field))
    setattr(inv, quantity_field, getattr(req, quantity_field))
    setattr(inv, expiration_field, getattr(req, expiration_field))
    setattr(inv, last_date_attr, now)
    setattr(inv, limit_date_field, getattr(req, limit_date_field, None))

@technician_router.put("/inventario/proteina/",response_model=InvProteinaResponse)
async def restock_protein(
    req: RestockProteinaRequest,
    machine: Maquina = Depends(get_machine_for_tech),
    db: Session = Depends(get_db),
):
    inv = get_inventory_or_404(db, InvProteina, "id_inv_proteina", req.id_inv_proteina, machine.id_maquina)
    
    now = datetime.now(timezone("America/Mexico_City"))
    restock_inv(
        inv, req,
        quantity_field="cantidad_gr",
        expiration_field="fec_caducidad",
        ingredient_field="proteina",
        now=now
    )

    db.commit()
    db.refresh(inv)
    return inv

@technician_router.put("/inventario/curcuma/", response_model=InvCurcumaResponse)
async def restock_curcuma(
    req: RestockCurcumaRequest,
    machine: Maquina = Depends(get_machine_for_tech),
    db: Session = Depends(get_db),
):
    inv = get_inventory_or_404(db, InvCurcuma, "id_inv_curcuma", req.id_inv_curcuma, machine.id_maquina)
    now = datetime.now(timezone("America/Mexico_City"))
    restock_inv(
        inv, req, 
        quantity_field="cantidad_gr", 
        expiration_field="fec_caducidad", 
        ingredient_field="curcuma",
        now=now
    )
    db.commit()
    db.refresh(inv)
    return inv

@technician_router.put("/inventario/saborizante/", response_model=InvSaborizanteResponse)
async def restock_saborizante(
    req: RestockSaborizanteRequest,
    machine: Maquina = Depends(get_machine_for_tech),
    db: Session = Depends(get_db),
):
    inv = get_inventory_or_404(
        db, InvSaborizante, "id_inv_sabor", req.id_inv_sabor, machine.id_maquina
    )
    now = datetime.now(timezone("America/Mexico_City"))
    restock_inv(
        inv, req,
        quantity_field="cantidad_ml",
        expiration_field="fec_caducidad",
        ingredient_field="saborizante",
        now=now
    )
    db.commit()
    db.refresh(inv)
    return inv

@technician_router.get("/maquina/info/", response_model=MaquinaResponse)
async def maquina_info(machine: Maquina = Depends(get_machine_for_tech), db: Session = Depends(get_db)):
    return machine

@technician_router.put("/maquina/ubicacion/", response_model=MaquinaResponse)
async def maquina_update_nombre(
    req: MaquinaUbicacionPutRequest,        
    machine: Maquina = Depends(get_machine_for_tech), 
    db: Session = Depends(get_db)
):
    machine.ubicacion = req.ubicacion
    db.commit()
        
    return machine

@owner_router.get("/maquina/reporteMensual/{year}/{month}/")
async def reporteMensual(
    year: int,
    month: int,
    machine: Maquina = Depends(get_machine_for_owner), 
    db: Session = Depends(get_db)
):
    canjes = (
        db.query(
            Pedido.saborizante_id,
            func.count(Pedido.saborizante_id).label("pedidos"),
            func.sum(Compra.monto_total).label("ganancias"),
            Sabor.sabor
        )
        .select_from(Pedido)
        .join(Saborizante, Saborizante.id_saborizante == Pedido.saborizante_id)
        .join(Sabor, Sabor.id_sabor == Saborizante.sabor_id)
        .join(Compra, Compra.pedido_id == Pedido.id_pedido)
        .filter(
            Pedido.maquina_canje_id == machine.id_maquina,
            Pedido.estado_canje == "canjeado",
            extract("year", Pedido.fec_hora_canje) == year,
            extract("month", Pedido.fec_hora_canje) == month
        )
        .group_by(Saborizante.id_saborizante)
        .all()
    )
    
    
    response = {
        "1": {
            "sabor": "Chocolate",
            "ganancias": 0,
            "pedidos": 0
        },
        "2": {
            "sabor": "Vainilla",
            "ganancias": 0,
            "pedidos": 0
        },
        "3": {
            "sabor": "Fresa",
            "ganancias": 0,
            "pedidos": 0
        },
        "total": {
            "ganancias": 0,
            "cantidad": 0
        }
    }
    
    total_ganancias = 0.0
    total_pedidos = 0
    
    for saborizante_id, num_pedidos, ganancias_sabor, sabor in canjes:
        response[saborizante_id] = {
            "sabor": sabor,
            "ganancias": float(ganancias_sabor or 0.0),
            "pedidos": num_pedidos,
        }
        
        total_ganancias += float(ganancias_sabor or 0.0)
        total_pedidos += num_pedidos
        
    response["total"] = {
        "ganancias": total_ganancias,
        "cantidad": total_pedidos,
    }
    
    return response

def checkInventory(
    maquina: Maquina,
    pedido: Pedido,
    db: Session
):
    # Buscar usuario y sus cantidades
        user = db.query(Usuario).filter(Usuario.email == pedido.usuario_email).first()
        
        if not user:
            raise HTTPException(
                status_code=404,
                detail=f"No se encontro el usuario ({pedido.usuario}) responsable del pedido: {pedido.id_pedido}"
            )
        
        cantidades = db.query(Cantidades).filter(Cantidades.id_cantidades == user.cantidades).first()
        
        if not cantidades:
            raise HTTPException(
                status_code=404,
                detail=f"No se encontraron las cantidades para el usuario el usuario ({pedido.usuario})"
            )

        proteina_gr = pedido.proteina_gr
        curcuma_gr = pedido.curcuma_gr
        
        if not pedido.curcuma_id: curcuma_gr = 0
        
    # Buscar en los inventarios de la maquina, las materias del producto
        invProteina = (
            db.query(InvProteina)
            .filter(
                InvProteina.maquina == maquina.id_maquina,
                InvProteina.proteina == pedido.proteina_id
            )
            .first()
        )
        
        invSaborizante = (
            db.query(InvSaborizante)
            .filter(
                InvSaborizante.maquina == maquina.id_maquina,
                InvSaborizante.saborizante == pedido.saborizante_id,
                
            ).first()
        )
        
        invCurcuma = (
            db.query(InvCurcuma)
            .filter(
                InvCurcuma.maquina == maquina.id_maquina,
                InvCurcuma.curcuma == pedido.curcuma_id
            ).first()
        )
        
        if not invSaborizante:
            raise HTTPException(
                status_code=404,
                detail=f"No se encontro inventario de saborizante para maquina con ID: {maquina.id_maquina}"
            )
            
        if not invProteina:
            raise HTTPException(
                status_code=404,
                detail=f"No se encontro inventario de proteina para maquina con ID: {maquina.id_maquina}"
            )
        
        if not invCurcuma and pedido.curcuma_id:
            raise HTTPException(
                status_code=404,
                detail=f"No se encontro inventario de curcuma para maquina con ID: {maquina.id_maquina}"
            )

        saborizante = db.query(Saborizante).filter(Saborizante.id_saborizante == pedido.saborizante_id).first()
        sabor_ml = saborizante.porcion

    # Validar caducidades
        tz = timezone('America/Mexico_City')
        today = datetime.now(tz).date()

        if today > invProteina.fec_caducidad:
            print("Razon: if today > invProteina.fec_caducidad")
            return False

        if today > invSaborizante.fec_caducidad:
            print("Razon: if today > invSaborizante.fec_caducidad")
            return False

        if pedido.curcuma_id and today > invCurcuma.fec_caducidad:
            print("Razon: if pedido.curcuma_id and today > invCurcuma.fec_caducidad")
            return False
            
    # Validar cantidades
        if proteina_gr + PROTEIN_EXTRA_MARGIN > invProteina.cantidad_gr:
            print("Razon: if proteina_gr > invProteina.cantidad_gr + PROTEIN_EXTRA_MARGIN")
            return False
            
        if sabor_ml + FLAVOR_EXTRA_MARGIN > invSaborizante.cantidad_ml:
            print("Razon: if sabor_ml > invSaborizante.cantidad_ml + FLAVOR_EXTRA_MARGIN")
            return False
        
        if pedido.curcuma_id:
            if curcuma_gr + TUMERIC_EXTRA_MARGIN > invCurcuma.cantidad_gr:
                print("Razon: if curcuma_gr > invCurcuma.cantidad_gr + TUMERIC_EXTRA_MARGIN")
                return False
    
    # Si todos los checks pasaron, entonces pasa la prueba de inventario
        return True

@machine_router.get(
    "/inventario/{machine_id}/disponible/{pedido_id}",
    response_model=bool,
    summary="¿Hay inventario suficiente en la máquina para preparar un pedido?"
)
def check_machine_inventory(
    machine_id: int,
    pedido_id: str,
    db: Session = Depends(get_db),
):  
    # Buscar maquina
    machine = db.query(Maquina).filter(Maquina.id_maquina == machine_id).first()
    
    if not machine:
        raise HTTPException(
            status_code=404,
            detail=f"No se encontro maquina con ID: {machine_id}"
        )

    pedido = db.query(Pedido).filter(Pedido.id_pedido == pedido_id).first()
    
    if not pedido:
        raise HTTPException(
            status_code=404,
            detail=f"No se encontro maquina con ID: {pedido_id}"
        )
        
    response = checkInventory(machine, pedido, db)

    return response

def insertHumidityAndEmail(maquina: Maquina, humedad: int, db: Session):
    today = datetime.now(timezone('America/Mexico_City'))

    db_humedad = HistorialHumedad(
        maquina = maquina.id_maquina,
        humedad = humedad,
        fecha_hora = today,
    )
    
    db.add(db_humedad)
    db.commit()
    db.refresh(db_humedad)
    
    if (humedad > MAX_ACCEPTABLE_HUMIDITY):
        tech = db.query(Technician).filter(Technician.machine == Maquina.id_maquina).first()
        
        emailHumidity(db_humedad, tech, maquina)
        
        raise HTTPException(
            status_code=403,
            detail=f"La maquina {maquina.id_maquina} no paso prueba de humedad"
        )

def checkIfPedidoIsBought(order_id: str, db: Session):
    compra = (
        db.query(Compra)
        .options(
            joinedload(Compra.pedido_rel)
        )
        .filter(Compra.pedido_id == order_id)
        .first()
    )
    
    if not compra:
        raise HTTPException(
            status_code=404,
            detail=f"No se encontro pedido comprado con ID: {order_id}"
        )
        
    return compra.pedido_rel

def checkIfPedidoIsRedeemed(pedido: Pedido):
    if pedido.estado_canje != "no_canjeado":
        raise HTTPException(
            status_code=403,
            detail=f"El pedido {pedido.id_pedido} esta canjeado"
        )

def redeem(machine_id: int, pedido: Pedido, db: Session):
    today = datetime.now(timezone('America/Mexico_City'))
    
    pedido.estado_canje = "canjeado"
    pedido.fec_hora_canje = today
    pedido.maquina_canje_id = machine_id
    
    db.commit()
    db.refresh(pedido)

def consumeInventories(pedido: Pedido, maquina: Maquina, db: Session):
    invProteina = (
        db.query(InvProteina)
        .filter(
            InvProteina.maquina == maquina.id_maquina,
            InvProteina.proteina == pedido.proteina_id
        )
        .first()
    )
    
    invSaborizante = (
        db.query(InvSaborizante)
        .filter(
            InvSaborizante.maquina == maquina.id_maquina,
            InvSaborizante.saborizante == pedido.saborizante_id,
            
        ).first()
    )
      
    saborizante = db.query(Saborizante).filter(Saborizante.id_saborizante == pedido.saborizante_id).first()
    
    proteina_gr = pedido.proteina_gr
    sabor_ml = saborizante.porcion
    
    try:
        invCurcuma = (
            db.query(InvCurcuma)
            .filter(
                InvCurcuma.maquina == maquina.id_maquina,
                InvCurcuma.curcuma == pedido.curcuma_id
            ).first()
        )
        curcuma_gr = pedido.curcuma_gr
        invCurcuma.cantidad_gr -= curcuma_gr
        
        db.commit()
        db.refresh(invCurcuma)
    
    except:
        print("El pedido no tenia curcuma")
    
    
    invProteina.cantidad_gr -= proteina_gr
    invSaborizante.cantidad_ml -= sabor_ml
    
    db.commit()
    db.refresh(invProteina)
    db.refresh(invSaborizante)

def checkUserInCooldown(user: Usuario, db: Session):
    if not hasPermissionToConsume(user, db):
        raise HTTPException(
            status_code=403,
            detail=f"El usuario {user.email} esta en cooldown"
        )

def checkInventoryPass(maquina: Maquina, pedido: Pedido, db: Session):
    if not checkInventory(maquina, pedido, db):
        raise HTTPException(
            status_code=403,
            detail=f"La maquina {maquina.id_maquina} no paso prueba de inventario"
        )

def predictProtein(pedido: Pedido, maquina: Maquina, db: Session):
    """
    Predice fec_limite_abasto y fec_prev_abasto para un InvProteina,
    clamping contra la fecha de caducidad si es necesario.
    """

    # 1) Obtener InvProteina para esta máquina
    inv_proteina: InvProteina = (
        db.query(InvProteina)
        .filter(
            InvProteina.maquina == maquina.id_maquina,
            InvProteina.proteina == pedido.proteina_id,
        )
        .first()
    )

    # 2) Obtener “ahora” en zona CDMX y volverlo naive (sin tzinfo)
    now_tz_aware = datetime.now(timezone("America/Mexico_City"))
    now = now_tz_aware.replace(tzinfo=None)

    # 3) Validar que fec_ult_abasto exista y haya pasado tiempo
    fec_ult = inv_proteina.fec_ult_abasto  # DateTime del último reabasto
    if fec_ult is None:
        print("InvProteina.fec_ult_abasto es NULL; no se puede predecir sin fecha de última recarga.")
        return  # o simplemente salir de la función

    elapsed_seconds = (now - fec_ult).total_seconds()
    if elapsed_seconds <= 0:
        print("La fecha de última recarga (fec_ult_abasto) es igual o posterior a ahora; no hay intervalo para calcular.")
        return  # o simplemente salir de la función

    # 4) Sumar todos los consumos de proteína (proteina_gr) desde fec_ult_abasto hasta ahora
    consumos_proteina = (
        db.query(Pedido)
        .filter(
            Pedido.maquina_canje_id == maquina.id_maquina,
            Pedido.proteina_id == pedido.proteina_id,
            Pedido.fec_hora_canje >= fec_ult,
            Pedido.fec_hora_canje <= now,
        )
        .all()
    )
    
    total_consumido_gr = sum(p.proteina_gr for p in consumos_proteina)

    # 5) Calcular tasa: gramos por día
    elapsed_days = elapsed_seconds / 86400  # 86400 segundos = 1 día
    if elapsed_days <= 0:
        print("No hubo días transcurridos; no se puede calcular la tasa.")
        return

    tasa_gr_por_dia = total_consumido_gr / elapsed_days
    if tasa_gr_por_dia <= 0:
        print("La tasa de consumo es cero o negativa; no se puede predecir.")
        return

    # 6) Calcular cuántos días faltan con la cantidad actual en inv_proteina.cantidad_gr
    if inv_proteina.cantidad_gr <= 0:
        print("No queda proteína en inventario; no se puede predecir fecha de límite.")
        return

    dias_restantes = inv_proteina.cantidad_gr / tasa_gr_por_dia

    # 7) Proyectar fecha límite inicialmente
    fecha_limite_dt = now + timedelta(days=dias_restantes)

    # ===== Aquí incorporamos la comparación con la fecha de caducidad =====
    # inv_proteina.fec_caducidad es un Date (sin hora). 
    # Si la predicción excede ese día, clampa a la caducidad.
    if inv_proteina.fec_caducidad:
        # Convertimos la caducidad a datetime a las 23:59:59 para que incluya todo el día de caducidad:
        exp_datetime = datetime.combine(
            inv_proteina.fec_caducidad, 
            datetime.max.time()
        )
        
        if fecha_limite_dt > exp_datetime:
            # Si la predicción cae más tarde que la caducidad, forzamos fecha_limite_dt = exp_datetime
            fecha_limite_dt = exp_datetime

    # 8) Calcular fecha previa (10 días antes de la fecha límite ajustada)
    fecha_prev_dt = fecha_limite_dt - timedelta(days = DAYS_FOR_PREVISORY_RESTOCK)

    # 9) Actualizar InvProteina y guardar
    inv_proteina.fec_limite_abasto = fecha_limite_dt.date()  # es Column(Date)
    inv_proteina.fec_prev_abasto = fecha_prev_dt            # es Column(DateTime)
    db.add(inv_proteina)
    db.commit()
    db.refresh(inv_proteina)

def predictSaborizante(pedido: Pedido, maquina: Maquina, db: Session):
    """
    Predice fec_limite_abasto y fec_prev_abasto para un InvSaborizante,
    clamping contra la fecha de caducidad si es necesario.
    """

    # 1) Obtener InvSaborizante para esta máquina + saborizante
    inv_sabor: InvSaborizante = (
        db.query(InvSaborizante)
        .filter(
            InvSaborizante.maquina == maquina.id_maquina,
            InvSaborizante.saborizante == pedido.saborizante_id,
        )
        .first()
    )
    if not inv_sabor:
        print(f"No existe InvSaborizante para máquina={maquina.id_maquina} y saborizante={pedido.saborizante_id}")
        return

    # 2) Obtener el objeto Saborizante para saber la porción en ml
    sabor_obj = (
        db.query(Saborizante)
        .filter(Saborizante.id_saborizante == pedido.saborizante_id)
        .first()
    )
    if not sabor_obj:
        print(f"No existe Saborizante con ID={pedido.saborizante_id}")
        return

    porcion_ml = sabor_obj.porcion
    if porcion_ml is None or porcion_ml <= 0:
        print(f"La porción del saborizante {pedido.saborizante_id} no es válida: {porcion_ml}")
        return

    # 3) Obtener “ahora” en zona CDMX y volverlo naive (sin tzinfo)
    now_tz_aware = datetime.now(timezone("America/Mexico_City"))
    now = now_tz_aware.replace(tzinfo=None)


    # 4) Validar que fec_ult_abasto exista y haya pasado tiempo
    fec_ult = inv_sabor.fec_ult_abasto  # DateTime del último abasto
    if fec_ult is None:
        print("InvSaborizante.fec_ult_abasto es NULL; no se puede predecir sin última recarga.")
        return

    elapsed_seconds = (now - fec_ult).total_seconds()
    if elapsed_seconds <= 0:
        print("La fecha de última recarga (fec_ult_abasto) es igual o posterior a ahora; no hay intervalo para calcular.")
        return

    # 5) Contar cuántos pedidos de este saborizante hubo desde fec_ult hasta ahora
    pedidos_sabor = (
        db.query(Pedido)
        .filter(
            Pedido.maquina_canje_id == maquina.id_maquina,
            Pedido.saborizante_id == pedido.saborizante_id,
            Pedido.fec_hora_canje >= fec_ult,
            Pedido.fec_hora_canje <= now,
        )
        .all()
    )
    num_pedidos = len(pedidos_sabor)
    total_consumido_ml = num_pedidos * porcion_ml

    if total_consumido_ml <= 0:
        print("No se han registrado consumos de saborizante desde la última recarga.")
        return

    # 6) Calcular tasa de consumo en ml/día
    elapsed_days = elapsed_seconds / 86400
    if elapsed_days <= 0:
        print("No hubo días transcurridos; no se puede calcular la tasa.")
        return

    tasa_ml_por_dia = total_consumido_ml / elapsed_days
    if tasa_ml_por_dia <= 0:
        print("La tasa de consumo calculada es cero o negativa; no se puede predecir.")
        return

    # 7) Verificar que quede cantidad en inventario
    if inv_sabor.cantidad_ml <= 0:
        print("No queda saborizante en inventario; no se puede predecir fecha de límite.")
        return

    dias_restantes = inv_sabor.cantidad_ml / tasa_ml_por_dia

    # 8) Proyectar fecha límite inicialmente
    fecha_limite_dt = now + timedelta(days=dias_restantes)

    # 9) Comparar contra la fecha de caducidad
    if inv_sabor.fec_caducidad:
        # Convertir fec_caducidad (Date) a datetime al final del día en CDMX
        exp_datetime = datetime.combine(
            inv_sabor.fec_caducidad, 
            datetime.max.time()
        )
            
        if fecha_limite_dt > exp_datetime:
            fecha_limite_dt = exp_datetime

    # 10) Calcular fecha previa (10 días antes de la fecha límite ajustada)
    fecha_prev_dt = fecha_limite_dt - timedelta(days = DAYS_FOR_PREVISORY_RESTOCK)

    # 11) Actualizar InvSaborizante y guardar
    inv_sabor.fec_limite_abasto = fecha_limite_dt.date()  # Column(Date)
    inv_sabor.fec_prev_abasto = fecha_prev_dt             # Column(DateTime)
    db.add(inv_sabor)
    db.commit()
    db.refresh(inv_sabor)

def predictCurcuma(pedido: Pedido, maquina: Maquina, db: Session):
    """
    Predice fec_limite_abasto y fec_prev_abasto para un InvCurcuma,
    clamping contra la fecha de caducidad si es necesario.
    """

    # 1) Obtener InvCurcuma para esta máquina + curcuma
    inv_curcuma: InvCurcuma = (
        db.query(InvCurcuma)
        .filter(
            InvCurcuma.maquina == maquina.id_maquina,
            InvCurcuma.curcuma == pedido.curcuma_id,
        )
        .first()
    )
    if not inv_curcuma:
        print(f"No existe InvCurcuma para máquina={maquina.id_maquina} y curcuma={pedido.curcuma_id}")
        return

    # 2) Obtener “ahora” en zona CDMX y volverlo naive (sin tzinfo)
    now_tz_aware = datetime.now(timezone("America/Mexico_City"))
    now = now_tz_aware.replace(tzinfo=None)

    # 3) Validar que fec_ult_abasto exista y haya pasado tiempo
    fec_ult = inv_curcuma.fec_ult_abasto  # DateTime del último abasto
    if fec_ult is None:
        print("InvCurcuma.fec_ult_abasto es NULL; no se puede predecir sin última recarga.")
        return

    elapsed_seconds = (now - fec_ult).total_seconds()
    if elapsed_seconds <= 0:
        print("La fecha de última recarga (fec_ult_abasto) es igual o posterior a ahora; no hay intervalo para calcular.")
        return

    # 4) Sumar todos los consumos de curcuma (curcuma_gr) desde fec_ult_abasto hasta ahora
    consumos_curcuma = (
        db.query(Pedido)
        .filter(
            Pedido.maquina_canje_id == maquina.id_maquina,
            Pedido.curcuma_id == pedido.curcuma_id,
            Pedido.fec_hora_canje >= fec_ult,
            Pedido.fec_hora_canje <= now,
        )
        .all()
    )
    total_consumido_gr = sum(p.curcuma_gr for p in consumos_curcuma)
    if total_consumido_gr <= 0:
        print("No se han registrado consumos de curcuma desde la última recarga.")
        return

    # 5) Calcular tasa: gramos por día
    elapsed_days = elapsed_seconds / 86400  # 86400 segundos = 1 día
    if elapsed_days <= 0:
        print("No hubo días transcurridos; no se puede calcular la tasa.")
        return

    tasa_gr_por_dia = total_consumido_gr / elapsed_days
    if tasa_gr_por_dia <= 0:
        print("La tasa de consumo calculada es cero o negativa; no se puede predecir.")
        return

    # 6) Verificar que quede cantidad en inventario
    if inv_curcuma.cantidad_gr <= 0:
        print("No queda curcuma en inventario; no se puede predecir fecha de límite.")
        return

    dias_restantes = inv_curcuma.cantidad_gr / tasa_gr_por_dia

    # 7) Proyectar fecha límite inicialmente
    fecha_limite_dt = now + timedelta(days=dias_restantes)

    # 8) Comparar contra la fecha de caducidad
    if inv_curcuma.fec_caducidad:
        # Convertir fec_caducidad (Date) a datetime al final del día en CDMX
        exp_datetime = datetime.combine(
            inv_curcuma.fec_caducidad, 
            datetime.max.time()
        )
        
        if fecha_limite_dt > exp_datetime:
            fecha_limite_dt = exp_datetime

    # 9) Calcular fecha previa (10 días antes de la fecha límite ajustada)
    fecha_prev_dt = fecha_limite_dt - timedelta(days = DAYS_FOR_PREVISORY_RESTOCK)

    # 10) Actualizar InvCurcuma y guardar
    inv_curcuma.fec_limite_abasto = fecha_limite_dt.date()  # Column(Date)
    inv_curcuma.fec_prev_abasto   = fecha_prev_dt           # Column(DateTime)
    db.add(inv_curcuma)
    db.commit()
    db.refresh(inv_curcuma)

@machine_router.post(
    "/canjearPedido/",
    summary="Determina canjeabilidad y ejecuta si aplica.",
    # response_model=bool
)
def redeem_endpoint(
    req: RedeemRequest,
    db: Session = Depends(get_db),
    response_model = bool
):
    # Consigue la maquina
    maquina = db.query(Maquina).filter(Maquina.id_maquina == req.machine_id).first()
    
    if not maquina:
        raise HTTPException(
            status_code=404,
            detail=f"No se encontro maquina con ID: {req.machine_id}"
        )
    
    # Inserta la humedad y Revisa si la humedad recibida es aceptable (envia emails al tecnico si no)
    insertHumidityAndEmail(maquina, req.current_humidity, db)
        
    # Revisa si el pedido esta comprado y consigue su usuario
    pedido = checkIfPedidoIsBought(req.order_id, db)
    
    user = db.query(Usuario).filter(Usuario.email == pedido.usuario_email).first()

    if not user:
        raise HTTPException(
            status_code=404,
            detail=f"No se encontro al usuario {pedido.usuario_email} responsable del pedido"
        )
        
    checkIfPedidoIsRedeemed(pedido) # Revisa si el pedido esta no canjeado
    checkUserInCooldown(user, db) # Revisa si el usuario puede consumir   
    checkInventoryPass(maquina, pedido, db) # Revisa si la maquina puede preparar el pedido       
    redeem(req.machine_id, pedido, db) # Canjear pedido
    consumeInventories(pedido, maquina, db) # Restar cantidad consumida a los inventarios
    
    # Proyectar consumos para conseguir fechas de reabastecimiento
    predictProtein(pedido, maquina, db)
    predictSaborizante(pedido, maquina, db)
    
    if pedido.curcuma_id:    
        predictCurcuma(pedido, maquina, db)
    
    return True