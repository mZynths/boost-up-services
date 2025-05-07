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

def emailFailure(failure: Fallo, tech: Technician, machine: Maquina):
    email = tech.email
    
    msg = MIMEMultipart()
    msg['From'] = NOREPLY_EMAIL
    msg['To'] = email
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
        <p>Hola { tech.name } ({ tech.username }),</p>
        <p>Se ha registrado un nuevo fallo en la máquina asignada a ti. A continuación los detalles:</p>

        <div style="text-align: left; background-color: #f2f2f2; padding: 20px; border-radius: 8px; margin: 20px 0;">
        <p><strong>ID de Fallo:</strong> {failure.id_fallo}</p>
        <p><strong>Fecha y hora:</strong> {failure.fec_hora.strftime("%Y-%m-%d %H:%M:%S")}</p>
        <p><strong>Tipo de fallo:</strong> {failure.tipo_fallo_nombre} (ID {failure.tipo_fallo})</p>
        <p><strong>Descripción:</strong> {failure.descripcion or "— Sin descripción —"}</p>
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
    
    tech = db.query(Technician).filter(Technician.machine == machine.id_maquina).first()
    
    if not tech:
        raise HTTPException(
            status_code=404,
            detail=f"El fallo se insertó pero no pudimos encontrar a ningun técnico responsable de la máquina"
        )
        
    emailFailure(new_fallo, tech, machine)

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
    now: datetime,
    prev_date_attr: str = "fec_prev_abasto",
    last_date_attr: str = "fec_ult_abasto",
    limit_date_field: str = "fec_limite_abasto",
):
    # shift old timestamp → prev
    old_dt = getattr(inv, last_date_attr)
    setattr(inv, prev_date_attr, old_dt.date())

    # set new values
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
    restock_inv(inv, req, quantity_field="cantidad_gr", expiration_field="fec_caducidad", now=now)
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



@machine_router.get(
    "/inventario/{machine_id}/disponible/{pedido_id}",
    response_model=bool,
    summary="¿Hay inventario suficiente en la máquina para preparar un pedido?"
)
def check_inventory(
    machine_id: int,
    pedido_id: str,
    db: Session = Depends(get_db),
):
    FLAVOR_ML = {
        1: 15,
        2: 20,
        3: 25,
    }
    
    # 1) Cargar el pedido
    pedido = db.query(Pedido).filter(Pedido.id_pedido == pedido_id).first()
    if not pedido:
        raise HTTPException(status_code=404, detail="Pedido no encontrado")

    # 2) Verificar proteína
    inv_prot = (
        db.query(InvProteina)
          .filter(
              InvProteina.maquina == machine_id,
              InvProteina.proteina == pedido.proteina_id
          )
          .first()
    )
    if not inv_prot or inv_prot.cantidad_gr < pedido.proteina_gr:
        return False

    # 3) Verificar cúrcuma (si aplica)
    if pedido.curcuma_id is not None and pedido.curcuma_gr is not None:
        inv_cur = (
            db.query(InvCurcuma)
              .filter(
                  InvCurcuma.maquina == machine_id,
                  InvCurcuma.curcuma == pedido.curcuma_id
              )
              .first()
        )
        if not inv_cur or inv_cur.cantidad_gr < pedido.curcuma_gr:
            return False

    # 4) Verificar saborizante usando el ml hard‑codeado
    needed_ml = FLAVOR_ML.get(pedido.saborizante_id)
    if needed_ml is None:
        raise HTTPException(
            status_code=400,
            detail=f"Saborizante desconocido: {pedido.saborizante_id}"
        )
    inv_sab = (
        db.query(InvSaborizante)
          .filter(
              InvSaborizante.maquina == machine_id,
              InvSaborizante.saborizante == pedido.saborizante_id
          )
          .first()
    )
    if not inv_sab or inv_sab.cantidad_ml < needed_ml:
        return False

    # 5) Si llegamos aquí, ¡hay stock suficiente!
    return True