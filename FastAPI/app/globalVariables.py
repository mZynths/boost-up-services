import os
from passlib.context import CryptContext
from datetime import datetime, timedelta, date
from pytz import timezone
from jose import JWTError, jwt

import stripe

# Email secrets
SMTP_SERVER = os.getenv('SMTP_SERVER')
NOREPLY_EMAIL = os.getenv('NOREPLY_EMAIL')
NOREPLY_EMAIL_PASSWORD = os.getenv('NOREPLY_EMAIL_PASSWORD')

# Stripe configurations
STRIPE_SECRET_KEY = os.getenv('STRIPE_SECRET_KEY')
WEBHOOK_SECRET = os.getenv('STRIPE_WEBHOOK_SECRET')
stripe.api_key = STRIPE_SECRET_KEY

# Security configurations
SECRET_KEY = os.getenv('JWT_KEY')
pwd_context = CryptContext(schemes=['bcrypt'], deprecated='auto')
ALGORITHM = 'HS256'
ACCESS_TOKEN_EXPIRE_MINUTES = 60*24 # Whole day

RESET_TOKEN_EXPIRE_MINUTES = 1

def create_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire_dt = datetime.now(timezone('America/Mexico_City')) + expires_delta
    to_encode.update({"exp": expire_dt})
    encoded = jwt.encode(to_encode, SECRET_KEY, algorithm = ALGORITHM)
    return encoded

def create_access_token_for_user(username: str, role: str, expires_delta: timedelta):
    data = {
        "sub": username,
        "role": role
    }
    return create_access_token(data, expires_delta)

# Hardcoded values
CURCUMA_PORTION = 85.575

# Max restock variabbles
PROTEIN_MAX_RESTOCK = 500
SABORIZANTE_MAX_RESTOCK = 50
CURCUMA_MAX_RESTOCK = 100

# Safe margins
PROTEIN_EXTRA_MARGIN = 30
TUMERIC_EXTRA_MARGIN = 5
FLAVOR_EXTRA_MARGIN = 25

REDEEM_COOLDOWN_HR = 0

MAX_ACCEPTABLE_HUMIDITY = 80

DAYS_FOR_PREVISORY_RESTOCK = 10