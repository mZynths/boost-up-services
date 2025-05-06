from fastapi import FastAPI, HTTPException, Depends, status, APIRouter, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session, joinedload
from typing import Annotated
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

class OwnerOAuth2PasswordBearer(OAuth2PasswordBearer):
    pass

oauth2_scheme_owner = OwnerOAuth2PasswordBearer(tokenUrl='/owner/token/')

def get_owner(db: db_dependency, username: str): # type: ignore
    owner = db.query(Owner).filter(Owner.username == username).first()
    
    if owner is not None:
        return owner

def authenticate_owner(db: db_dependency, username: str, password: str): # type: ignore
    owner = get_owner(db, username=username)
    
    if not owner or not pwd_context.verify(password, owner.password):
        return False
    
    return owner

def get_current_owner(db: db_dependency, token: Annotated[str, Depends(oauth2_scheme_owner)]): # type: ignore
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        
        if username is None:
            raise CREDENTIALS_EXCEPTION

        token_data = TokenData(username = username)
    
    except JWTError:
        raise CREDENTIALS_EXCEPTION
    
    user = get_owner(db, token_data.username)
    
    if user is None:
        raise CREDENTIALS_EXCEPTION
    
    return user

owner_router = APIRouter(prefix="/owner", tags=["owner"])

@owner_router.post("/token/", response_model=Token)
async def get_owner_token(db: db_dependency, form_data: OAuth2PasswordRequestForm = Depends()): # type: ignore
    owner = authenticate_owner(db, form_data.username, form_data.password)

    if not owner:
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

# Get current authentified Owner
@owner_router.get("/yo/", response_model=OwnerResponse)
async def get_my_owner(current_owner: Annotated[OwnerResponse, Depends(get_current_owner)]): return current_owner

# Get inventory Values
@owner_router.get("/inventario/")
async def getInventory(owner: Annotated[OwnerResponse, Depends(get_current_owner)], db: Session = Depends(get_db)):
    machine = db.query(Maquina).filter(Maquina.id_maquina == owner.machine).first()
    
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