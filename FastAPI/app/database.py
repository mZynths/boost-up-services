from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from dotenv import load_dotenv

from sqlalchemy.engine.url import URL
import os

load_dotenv()

username = os.getenv('MYSQL_USER')
password = os.getenv('MYSQL_PASSWORD')
hostname = 'mysql'
dbname   = os.getenv('MYSQL_DATABASE')

DATABASE_URL = URL.create(
    drivername="mysql+pymysql",
    username=username,
    password=password,  # URL-encoding is handled automatically
    host="mysql",
    database=dbname,
)

engine = create_engine(DATABASE_URL, pool_size=10, max_overflow=30)

Sessionlocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = Sessionlocal()
    
    try:
        yield db
        
    finally:
        db.close()