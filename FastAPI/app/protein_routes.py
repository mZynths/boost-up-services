from fastapi import HTTPException, Depends,APIRouter
from sqlalchemy.orm import Session, joinedload

from exceptions import *
from models import *
from schemas import *

from database import get_db

proteina_router = APIRouter(prefix="/proteina", tags=["proteina"])

# Get detalles of Proteina by id
@proteina_router.get("/{id_proteina}/detalles/", response_model=ProteinaDetailsResponse)
def get_protein_price(id_proteina: int, db: Session = Depends(get_db)):
    db_proteina = (
        db.query(Proteina).options(
            joinedload(Proteina.marca_rel)
        ).filter(Proteina.id_proteina == id_proteina).first()
    )
    
    # If not found:
    if not db_proteina:
        raise HTTPException(
            status_code = 404,
            detail = f'Protein with ID {id_proteina} not found'
        )
    
    response = ProteinaDetailsResponse(
        nombre = db_proteina.nombre,
        tipo_proteina = db_proteina.tipo_proteina,
        precio = db_proteina.precio,
        fec_actualizacion = db_proteina.fec_actualizacion,
        cont_nutricional = db_proteina.cont_nutricional,
        densidad_proteica = db_proteina.densidad_proteica,
        marca = db_proteina.marca_rel.marca
    )
        
    return response

# Get opciones de Proteinas
@proteina_router.get("/opciones/", response_model=list[ProteinaOptionsResponse])
def get_protein_options(db: Session = Depends(get_db)):
    results = db.query(Proteina).all()
    
    if not results:
        raise HTTPException(
            status_code = 404,
            detail = "No protein options found"
        )
    
    return results

# Get Precio of Proteina by id
@proteina_router.get("/{id_proteina}/precio/", response_model=ProteinaPrecioResponse)
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
@proteina_router.get("/{id_proteina}/alergenos/", response_model=list[AlergenoProteinaResponse])
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
