from fastapi import FastAPI, HTTPException, Depends, status, APIRouter
from sqlalchemy.orm import Session, joinedload
from typing import Annotated
from database import Sessionlocal
from dotenv import load_dotenv
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from datetime import datetime, timedelta, date
from pytz import timezone
from jose import JWTError, jwt
import os

from exceptions import *
from models import *
from schemas import *

load_dotenv()

app = FastAPI()
internal_router = APIRouter()

def get_db():
    db = Sessionlocal()
    
    try:
        yield db
        
    finally:
        db.close()
        
db_dependency = Annotated[Session, Depends(get_db)]

# Security configurations
SECRET_KEY = os.getenv('JWT_KEY')
pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 60*24 # Whole day

# Defines which is the endpoint for authorization
oauth2_scheme = OAuth2PasswordBearer(tokenUrl='/usuario/token/')

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
    
    # if usuario is None:
    #     raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Usuario not found")
    # return usuario
        
def authenticate_usuario(db: db_dependency, username: str, password: str): # type: ignore
    usuario = get_usuario(db, email=username)
    
    if not usuario or not pwd_context.verify(password, usuario.password):
        return False
    
    return usuario
    
def get_current_usuario(db: db_dependency, token: Annotated[str, Depends(oauth2_scheme)]): # type: ignore
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

# Get current authentified user
@usuario_router.get("/yo/", response_model=UsuarioResponse, tags=["usuario"])
async def get_my_user(current_usuario: Annotated[UsuarioResponse, Depends(get_current_usuario)]):
    return current_usuario

# Register user account
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
    
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    return db_user

# Get all Alergenos 
@internal_router.get("/alergenos/", response_model=list[AlergenoResponse])
def get_all_allergens(db: Session = Depends(get_db)):
    
    db_alergeno = db.query(Alergeno).all()
    
    # If not found:
    if not db_alergeno:
        raise HTTPException(
            status_code = 404,
            detail = "Alergenos not found"
        )
        
    return db_alergeno

# Get opciones de Saborizantes
@internal_router.get("/saborizante/opciones/", response_model=list[SaborizanteOptionsResponse])
def get_flavoring_options(db: Session = Depends(get_db)):
    
    results = db.query(Saborizante).options(
        joinedload(Saborizante.sabor_rel),            # Load Sabor relationship
        joinedload(Saborizante.tipo_saborizante_rel)  # Load TipoSaborizante relationship
    ).all()
    
    if not results:
        raise HTTPException(
            status_code = 404,
            detail = "Opciones de saborizante not found"
        )
    
    return results

# Get Precio of Curcuma by id
@internal_router.get("/curcuma/{id_curcuma}/precio/", response_model=CurcumaPrecioResponse)
def get_curcuma_price(id_curcuma: int, db: Session = Depends(get_db)):
    
    db_curcuma = db.query(Curcuma).filter(
        Curcuma.id_curcuma == id_curcuma
    ).first()
    
    # If not found:
    if not db_curcuma:
        raise HTTPException(
            status_code = 404,
            detail = f'Curcuma with ID {id_curcuma} not found'
        )
        
    return db_curcuma

proteina_router = APIRouter(prefix="/proteina", tags=["proteina"])

# Get opciones de Proteinas
@proteina_router.get("/opciones/", response_model=list[ProteinaOptionsResponse], tags=["proteina"])
def get_protein_options(db: Session = Depends(get_db)):
    results = db.query(Proteina).all()
    
    if not results:
        raise HTTPException(
            status_code = 404,
            detail = "No protein options found"
        )
    
    return results

# Get Precio of Proteina by id
@proteina_router.get("/{id_proteina}/precio/", response_model=ProteinaPrecioResponse, tags=["proteina"])
def get_protein_price(id_proteina: int, db: Session = Depends(get_db)):
    
    db_proteina = db.query(Proteina).filter(
        Proteina.id_proteina == id_proteina
    ).first()
    
    # If not found:
    if not db_proteina:
        raise HTTPException(
            status_code = 404,
            detail = f'Protein with ID {id_proteina} not found'
        )
        
    return db_proteina

# Get Alergenos of Proteina by id
@proteina_router.get("/{id_proteina}/alergenos/", response_model=list[AlergenoProteinaResponse], tags=["proteina"])
def get_protein_allergens(id_proteina: int, db: Session = Depends(get_db)):
    
    results = db.query(AlergenoProteina).filter(
        AlergenoProteina.proteina == id_proteina
    ).options(
        joinedload(AlergenoProteina.alergeno_rel)
    ).all()
    
    if not results:
        raise HTTPException(
            status_code = 404,
            detail=f"No allergens found for protein ID {id_proteina}"
        )
    
    return results

internal_router.include_router(usuario_router)
internal_router.include_router(proteina_router)
app.include_router(internal_router)