from fastapi import FastAPI

from user_routes import usuario_router
from technician_routes import technician_router
from owner_routes import owner_router
from protein_routes import proteina_router
from misc_routes import misc_router

app = FastAPI(title = "BoostUp - API Docs")

app.include_router(usuario_router)
app.include_router(proteina_router)
app.include_router(owner_router)
app.include_router(technician_router)
app.include_router(misc_router)