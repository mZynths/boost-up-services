from fastapi import FastAPI, HTTPException, Depends, status, APIRouter, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session, joinedload
from typing import Annotated, Union
from dotenv import load_dotenv
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta, date
from pytz import timezone
from jose import JWTError, jwt
import os

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