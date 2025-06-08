from fastapi import HTTPException, Depends, APIRouter, Request
from fastapi.responses import JSONResponse
from sqlalchemy import func, desc
from sqlalchemy.orm import Session, joinedload
from datetime import datetime, timedelta
from pytz import timezone

import json

from exceptions import *
from models import *
from schemas import *

from globalVariables import WEBHOOK_SECRET, stripe

from user_routes import hasPermissionToConsume

from database import get_db

misc_router = APIRouter(tags=["miscellaneous"])

# Stripe WebHook that either aknowledges the order or deletes it
@misc_router.post("/stripe_webhook/")
async def stripe_webhook(request: Request, db: Session = Depends(get_db)):
    print(WEBHOOK_SECRET)
    event = None
    payload = await request.body()
    
    try:
        event = json.loads(payload)
        
    except json.decoder.JSONDecodeError as e:
        print('⚠️  Webhook error while parsing basic request.' + str(e))
        return JSONResponse(content={"success": False})
    
    sig_header = request.headers.get('stripe-signature')
    
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, WEBHOOK_SECRET
        )
        
    except stripe.error.SignatureVerificationError as e:
        print(f'⚠️  Webhook signature verification failed. {str(e)}')
        return JSONResponse(content={"success": False})

    if event and event['type'] == 'payment_intent.succeeded':
        payment_intent = event['data']['object']
        id_pedido = payment_intent["metadata"]["id_pedido"]
        amount = payment_intent["amount"]
        
        print(f'Payment for {payment_intent["metadata"]["id_pedido"]} succeeded')
        # print(f'Payment for {payment_intent["amount"]} succeeded')
        
        db_pedido = db.query(Pedido).filter(Pedido.id_pedido == id_pedido).first()
        
        if db_pedido:
            db_compra = Compra(
                pedido_id = id_pedido,
                monto_total = amount/100.0,
                fec_hora_compra = datetime.now(timezone('America/Mexico_City'))
            )
            
            db.add(db_compra)
            db.commit()
            db.refresh(db_compra)
    
    elif event and event['type'] == 'payment_intent.canceled':
        payment_intent = event['data']['object']
        print(f'Payment for {payment_intent["amount"]} canceled')
    
    elif event and event['type'] == 'payment_intent.payment_failed':
        payment_intent = event['data']['object']
        print(f'Payment for {payment_intent["amount"]} failed')
        
    else:
        print(f'Unhandled event type {event["type"]}')

    return JSONResponse(content={"success": True})

# Get detalles of pedido by id
@misc_router.get("/pedido/{pedido_id}/")
def get_detalles_pedido(pedido_id: str, db: Session = Depends(get_db)):
    db_compra: Compra = db.query(Compra).options(
        joinedload(Compra.pedido_rel).joinedload(Pedido.saborizante_rel).joinedload(Saborizante.sabor_rel),
        joinedload(Compra.pedido_rel).joinedload(Pedido.saborizante_rel).joinedload(Saborizante.tipo_saborizante_rel),
        joinedload(Compra.pedido_rel).joinedload(Pedido.proteina_rel),
        joinedload(Compra.pedido_rel).joinedload(Pedido.curcuma_rel),
        joinedload(Compra.pedido_rel).joinedload(Pedido.saborizante_rel).joinedload(Saborizante.marca_rel),
        joinedload(Compra.pedido_rel).joinedload(Pedido.proteina_rel).joinedload(Proteina.marca_rel),
        joinedload(Compra.pedido_rel).joinedload(Pedido.curcuma_rel).joinedload(Curcuma.marca_rel)
    ).filter(
        Compra.pedido_id == pedido_id
    ).first()
    
    if not db_compra:
        raise HTTPException(
            status_code = 404,
            detail = "Pedido not found"
        )
    
    db_pedido: Pedido = db_compra.pedido_rel
    db_proteina: Proteina = db_pedido.proteina_rel
    db_curcuma: Curcuma = db_pedido.curcuma_rel
    db_saborizante: Saborizante = db_pedido.saborizante_rel
    db_usuario = db.query(Usuario).filter(Usuario.email == db_pedido.usuario_email).first()
    db_sabor: Sabor = db_saborizante.sabor_rel
    
    if not db_usuario:
        raise HTTPException(
            status_code = 404,
            detail = "Usuario not found"
        )
    
    result = {
        "proteina": db_proteina.nombre,
        "monto_total": db_compra.monto_total,
        "fec_hora_compra": db_compra.fec_hora_compra,
        "estado_canje": db_pedido.estado_canje,
        "sabor": db_saborizante.sabor_rel.sabor,
        "tipo_saborizante": db_saborizante.tipo_saborizante_rel.tipo_saborizante,
        "proteina_marca": db_proteina.marca_rel.marca,
        "saborizante_marca": db_saborizante.marca_rel.marca,
        "es_consumible": hasPermissionToConsume(db_usuario, db),
        "id_proteina": db_proteina.id_proteina,
        "id_saborizante": db_sabor.id_sabor,
        "saborizante_ml": db_saborizante.porcion,
        "proteina_gr": db_pedido.proteina_gr,
    }
    
    if db_curcuma:
        result["curcuma_gr"] = db_pedido.curcuma_gr
        result["curcuma_marca"] = db_curcuma.marca_rel.marca
        
    return result

# Get top proteinas
@misc_router.get("/top-proteinas/", response_model=list[TopProteinaResponse], tags=["Stats"])
def get_top_proteinas(db: Session = Depends(get_db)):
    thirty_days_ago = datetime.utcnow() - timedelta(days=30)
    
    results = (
        db.query(
            Proteina.nombre,
            func.count(Proteina.nombre).label("repeticiones")
        )
        .select_from(Compra)
        .join(Pedido, Compra.pedido_id == Pedido.id_pedido)
        .join(Proteina, Pedido.proteina_id == Proteina.id_proteina)
        .filter(Compra.fec_hora_compra >= thirty_days_ago)
        .group_by(Proteina.nombre)
        .order_by(desc("repeticiones"))
        .limit(3)
        .all()
    )
    
    return [
        TopProteinaResponse(nombre=nombre, repeticiones=count)
        for nombre, count in results
    ]

# Get top sabores
@misc_router.get("/top-sabores/", response_model=list[TopSaborResponse], tags=["Stats"])
def get_top_sabores(db: Session = Depends(get_db)):
    # Calculate the date 30 days ago from now
    thirty_days_ago = datetime.utcnow() - timedelta(days=30)
    
    # Execute the query
    results = (
        db.query(
            Sabor.sabor,
            func.count(Sabor.sabor).label("repeticiones")
        )
        .select_from(Compra)
        .join(Pedido, Compra.pedido_id == Pedido.id_pedido)
        .join(Saborizante, Pedido.saborizante_id == Saborizante.id_saborizante)
        .join(Sabor, Saborizante.sabor_id == Sabor.id_sabor)
        .filter(Compra.fec_hora_compra >= thirty_days_ago)
        .group_by(Sabor.sabor)
        .order_by(desc("repeticiones"))
        .limit(3)
        .all()
    )
    
    # Format results into the response model
    return [
        TopSaborResponse(sabor=sabor, repeticiones=count)
        for sabor, count in results
    ]

# Get detalles de Saborizantes by id
@misc_router.get("/saborizante/{id_saborizante}/detalles", response_model=SaborizanteDetailsResponse, tags=["Saborizante"])
def get_flavoring_options(id_saborizante: int, db: Session = Depends(get_db)):
    #
    results = (
        db.query(Saborizante).options(
            joinedload(Saborizante.sabor_rel),             # Load Sabor relationship
            joinedload(Saborizante.tipo_saborizante_rel),  # Load TipoSaborizante relationship
            joinedload(Saborizante.marca_rel),  # Load TipoSaborizante relationship
        ).filter(Saborizante.id_saborizante == id_saborizante).first()
    )
    
    if not results:
        raise HTTPException(
            status_code = 404,
            detail = f'Saborizante with ID {id_saborizante} not found'
        )
    
    response = SaborizanteDetailsResponse(
        sabor_id = results.sabor_id,
        cont_calorico = results.cont_calorico,
        porcion = results.porcion,
        marca_id = results.marca_id,
        id_saborizante = results.id_saborizante,
        fec_actualizacion = results.fec_actualizacion,
        tipo_saborizante = results.tipo_saborizante_rel.tipo_saborizante,
        marca = results.marca_rel.marca,
        sabor = results.sabor_rel.sabor,
    )
    
    return response

# Get opciones de Saborizantes
@misc_router.get("/saborizante/opciones/", response_model=list[SaborizanteOptionsResponse], tags=["Saborizante"])
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

# Get Curcuma options
@misc_router.get("/curcuma/opciones/", response_model=list[CurcumaDetailsResponse], tags=["Curcuma"])
def get_curcuma_price(db: Session = Depends(get_db)):
    
    db_curcuma = db.query(Curcuma).options(
        joinedload(Curcuma.marca_rel)    
    ).all()
    
    # If not found:
    if not db_curcuma:
        raise HTTPException(
            status_code = 404,
            detail = f'No curcuma options where found'
        )
    
    response = []
    
    for curcuma in db_curcuma:
        response.append(
            CurcumaDetailsResponse(
                cont_gingerol = curcuma.cont_gingerol,
                marca_id = curcuma.marca_id,
                fec_actualizacion = curcuma.fec_actualizacion,
                cont_curcuminoide = curcuma.cont_curcuminoide,
                id_curcuma = curcuma.id_curcuma,
                precauciones = curcuma.precauciones,
                precio = curcuma.precio,
                marca = curcuma.marca_rel.marca,
            )
        )
    
    return response

# Get Detalles of Curcuma by id
@misc_router.get("/curcuma/{id_curcuma}/detalles/", response_model=CurcumaDetailsResponse, tags=["Curcuma"])
def get_curcuma_price(id_curcuma: int, db: Session = Depends(get_db)):
    
    db_curcuma = db.query(Curcuma).options(
        joinedload(Curcuma.marca_rel)    
    ).filter(
        Curcuma.id_curcuma == id_curcuma
    ).first()
    
    # If not found:
    if not db_curcuma:
        raise HTTPException(
            status_code = 404,
            detail = f'Curcuma with ID {id_curcuma} not found'
        )
    
    response = CurcumaDetailsResponse(
        cont_gingerol = db_curcuma.cont_gingerol,
        marca_id = db_curcuma.marca_id,
        fec_actualizacion = db_curcuma.fec_actualizacion,
        cont_curcuminoide = db_curcuma.cont_curcuminoide,
        id_curcuma = db_curcuma.id_curcuma,
        precauciones = db_curcuma.precauciones,
        precio = db_curcuma.precio,
        marca = db_curcuma.marca_rel.marca,
    )
    
    return response

# Get Precio of Curcuma by id
@misc_router.get("/curcuma/{id_curcuma}/precio/", response_model=CurcumaPrecioResponse, tags=["Curcuma"])
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

# Get all Alergenos 
@misc_router.get("/alergenos/", response_model=list[AlergenoResponse])
def get_all_allergens(db: Session = Depends(get_db)):
    
    db_alergeno = db.query(Alergeno).all()
    
    # If not found:
    if not db_alergeno:
        raise HTTPException(
            status_code = 404,
            detail = "Alergenos not found"
        )
        
    return db_alergeno