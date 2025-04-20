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

class TechnicianOAuth2PasswordBearer(OAuth2PasswordBearer):
    pass

oauth2_scheme_technician = TechnicianOAuth2PasswordBearer(tokenUrl='/technician/token/')

def get_technician(db: db_dependency, username: str): # type: ignore
    technician = db.query(Technician).filter(Technician.username == username).first()
    
    if technician is not None:
        return technician

def authenticate_technician(db: db_dependency, username: str, password: str): # type: ignore
    technician = get_technician(db, username=username)
    
    if not technician or not pwd_context.verify(password, technician.password):
        return False
    
    return technician

def get_current_technician(db: db_dependency, token: Annotated[str, Depends(oauth2_scheme_technician)]): # type: ignore
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        
        if username is None:
            raise CREDENTIALS_EXCEPTION

        token_data = TokenData(username = username)
    
    except JWTError:
        raise CREDENTIALS_EXCEPTION
    
    user = get_technician(db, token_data.username)
    
    if user is None:
        raise CREDENTIALS_EXCEPTION
    
    return user

technician_router = APIRouter(prefix="/technician", tags=["technician"])

@technician_router.post("/token/", response_model=Token)
async def get_technician_token(db: db_dependency, form_data: OAuth2PasswordRequestForm = Depends()): # type: ignore
    technician = authenticate_technician(db, form_data.username, form_data.password)

    if not technician:
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

# Get current authentified Technician
@technician_router.get("/yo/", response_model=TechnicianResponse)
async def get_my_technician(current_technician: Annotated[TechnicianResponse, Depends(get_current_technician)]):
    return current_technician