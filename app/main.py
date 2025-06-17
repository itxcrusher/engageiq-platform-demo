from fastapi import FastAPI
from app.routes import chat, history, upload
from app.auth import get_current_user
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="EngageIQ Demo Backend")

# CORS setup (adjust as needed)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Use specific domains in prod
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routes
app.include_router(chat.router, prefix="/api")
app.include_router(history.router, prefix="/api")
app.include_router(upload.router, prefix="/api")

@app.get("/")
def root():
    return {"message": "EngageIQ Demo API is running"}