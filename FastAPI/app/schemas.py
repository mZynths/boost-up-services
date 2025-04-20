# Response models from db to py
from pydantic import BaseModel, EmailStr, validator, Field

from typing import Optional
from enum import Enum
from datetime import date, datetime

# Token response model
class Token(BaseModel): # ONLY WORKS WITH MOCK
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
    
    # Medidas table
    peso_kg: int
    talla_cm: int
    cintura_cm: int
    cadera_cm: int
    circ_brazo_cm: int
    
    @validator('fec_nacimiento')
    def validate_birth_date(cls, value):
        if value > date.today():
            raise ValueError("Birth date cannot be in the future")
        return value

    @validator('talla_cm')
    def validate_talla(cls, value):
        if value <= 0:
            raise ValueError("Talla must be a positive nonzero integer")
        return value

class UsuarioMedidasResponse(BaseModel):
    peso_kg: int
    talla_cm: int
    cintura_cm: int
    cadera_cm: int
    circ_brazo_cm: int
    edad: int
    
    class Config:
        from_attributes = True

class MedidasResponse(BaseModel):
    id_medidas: int
    imc: float
    peso_kg: int
    talla_cm: int
    cintura_cm: int
    cadera_cm: int
    circ_brazo_cm: int
    fec_actualizacion: date

    class Config:
        from_attributes = True
    
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

class UsuarioAlergenoResponse(BaseModel):
    alergeno: str
    tipo_alergeno: int
    
    class Config:
        from_attributes = True

class UsuarioAlergenoCreate(BaseModel):
    tipo_alergeno: int

class PedidoCreate(BaseModel):
    proteina: int
    curcuma: int
    saborizante: int

class PedidoInfoGeneralResponse(BaseModel):
    id_pedido: str
    nombre_proteina: str
    tipo_proteina: str
    sabor: str
    fec_hora_compra: datetime
    
    class Config:
        from_attributes = True

class PedidoResponse(BaseModel):
    proteina: str
    monto_total: float
    fec_hora_compra: datetime
    estado_canje: str
    proteina_gr: int 
    curcuma_gr: Optional[int] = None
    sabor: str
    tipo_saborizante: str
    proteina_marca: str
    curcuma_marca: Optional[str] = None
    saborizante_marca: str
    
    class Config:
        from_attributes = True
        
class OwnerResponse(BaseModel):
    username: str
    name: str
    lastname: str
    machine: int
    
    class Config:
        from_attributes = True
        
class TechnicianResponse(BaseModel):
    username: str
    email: EmailStr
    name: str
    lastname: str
    machine: int
    
    class Config:
        from_attributes = True