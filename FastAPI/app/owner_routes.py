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
import stripe
import json

from exceptions import *
from models import *
from schemas import *

from database import get_db

class OwnerOAuth2PasswordBearer(OAuth2PasswordBearer):
    pass

class TechnicianOAuth2PasswordBearer(OAuth2PasswordBearer):
    pass

oauth2_scheme_owner = OwnerOAuth2PasswordBearer(tokenUrl='/owner/token/')
oauth2_scheme_technician = TechnicianOAuth2PasswordBearer(tokenUrl='/technician/token/')

# Technician auth
technician_router = APIRouter(prefix="/technician", tags=["technician"])
@technician_router.get("/token/")
async def get_technician_token(token: Annotated[str, Depends(oauth2_scheme_technician)]):
    return {"token": "technician_token"}

# Owner auth
owner_router = APIRouter(prefix="/owner", tags=["owner"])
@owner_router.get("/token/")
async def get_owner_token(token: Annotated[str, Depends(oauth2_scheme_owner)]):
    return {"token": "owner_token"}