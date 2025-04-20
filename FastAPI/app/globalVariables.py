import os
from passlib.context import CryptContext
from datetime import datetime, timedelta, date
from pytz import timezone
from jose import JWTError, jwt

import stripe

# Stripe configurations
STRIPE_SECRET_KEY = os.getenv('STRIPE_SECRET_KEY')
WEBHOOK_SECRET = os.getenv('STRIPE_WEBHOOK_SECRET')
stripe.api_key = STRIPE_SECRET_KEY

# Security configurations
SECRET_KEY = os.getenv('JWT_KEY')
pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 60*24 # Whole day

def create_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire_dt = datetime.now(timezone('America/Mexico_City')) + expires_delta
    to_encode.update({"exp": expire_dt})
    encoded = jwt.encode(to_encode, SECRET_KEY, algorithm = ALGORITHM)
    return encoded