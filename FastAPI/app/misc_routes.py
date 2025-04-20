from fastapi import HTTPException, Depends, APIRouter, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session, joinedload
from datetime import datetime
from pytz import timezone

import json

from exceptions import *
from models import *
from schemas import *

from globalVariables import WEBHOOK_SECRET, stripe

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
@misc_router.get("/pedido/{pedido_id}/", response_model = PedidoResponse)
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
    
    result = PedidoResponse(
        proteina = db_proteina.nombre,
        monto_total = db_compra.monto_total,
        fec_hora_compra = db_compra.fec_hora_compra,
        estado_canje = db_pedido.estado_canje,
        proteina_gr = db_pedido.proteina_gr,
        sabor = db_saborizante.sabor_rel.sabor,
        tipo_saborizante = db_saborizante.tipo_saborizante_rel.tipo_saborizante,
        proteina_marca = db_proteina.marca_rel.marca,
        saborizante_marca = db_saborizante.marca_rel.marca
    )
    
    if db_curcuma:
        result.curcuma_gr = db_pedido.curcuma_gr
        result.curcuma_marca = db_curcuma.marca_rel.marca
        
    return result


# Get opciones de Saborizantes
@misc_router.get("/saborizante/opciones/", response_model=list[SaborizanteOptionsResponse])
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
@misc_router.get("/curcuma/{id_curcuma}/precio/", response_model=CurcumaPrecioResponse)
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