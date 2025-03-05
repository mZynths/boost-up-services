# Response models from db to py
from pydantic import BaseModel, EmailStr, validator, Field

from typing import Optional
from enum import Enum
from datetime import date, datetime

# Token response model
class UsuarioToken(BaseModel): # ONLY WORKS WITH MOCK
    access_token: str
    token_type: str

# Data inside token response model
class TokenData(BaseModel):
    username: str | None = None

# Models for Usuario
class SexoEnum(str, Enum):
    masculino = 'Masculino'
    femenino = 'Femenino'

class UsuarioResponse(BaseModel):
    fec_registro: date
    email: EmailStr
    # password: str
    username: str
    nombre: str
    apellido: str
    edad: int
    sexo: SexoEnum
    fec_nacimiento: date
    medidas: Optional[int] = None
    cantidades: Optional[int] = None
    
    class Config:
        from_attributes = True

class UsuarioCreate(BaseModel):
    email: EmailStr
    password: str
    username: str
    nombre: str
    apellido: str
    sexo: SexoEnum
    fec_nacimiento: date
    
    # medidas: Optional[int] = None
    # cantidades: Optional[int] = None
    # fec_registro: date
    # edad: int
    
    @validator('fec_nacimiento')
    def validate_birth_date(cls, value):
        if value > date.today():
            raise ValueError("Birth date cannot be in the future")
        return value

class AlergenoResponse(BaseModel):
    id_tipo_alergeno: int
    alergeno: str
    
    class Config:
        from_attributes = True

class TipoProteina(str, Enum):
    Animal = 'Animal'
    Vegetal = 'Vegetal'

class ProteinaOptionsResponse(BaseModel):
    id_proteina: int
    nombre: str
    tipo_proteina: TipoProteina
    precio: float
    # fec_actualizacion: date
    # cont_nutricional: str
    # densidad_proteica: float
    
    class Config:
        from_attributes = True

class SaborizanteOptionsResponse(BaseModel):
    id_saborizante: int
    sabor: str
    tipo_saborizante: str
    
    class Config:
        from_attributes = True
        populate_by_name = True
        
class ProteinaPrecioResponse(BaseModel):
    precio: float
    
    class Config:
        from_attributes = True

class CurcumaPrecioResponse(BaseModel):
    precio: float
    
    class Config:
        from_attributes = True

class AlergenoProteinaResponse(BaseModel):
    alergeno: str
    tipo_alergeno: int
    
    class Config:
        from_attributes = True