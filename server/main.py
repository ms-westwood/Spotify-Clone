from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routes import auth
from models.base import Base
from database import engine

app = FastAPI()

# Enable CORS for all origins while developing
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allow all origins in dev
    allow_credentials=True,
    allow_methods=["*"],  # <-- important for OPTIONS
    allow_headers=["*"],  # <-- important for Content-Type
)

# Include your auth routes
app.include_router(auth.router, prefix="/auth")

# Create database tables
Base.metadata.create_all(engine)