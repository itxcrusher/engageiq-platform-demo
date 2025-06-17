from fastapi import APIRouter
from pydantic import BaseModel
from datetime import datetime

router = APIRouter()

# Simulated per-tenant memory (will reset on app restart)
TENANT_MEMORY = {}

class ChatPayload(BaseModel):
    org_id: str
    message: str

@router.post("/chat")
def chat(payload: ChatPayload):
    org = payload.org_id
    msg = payload.message

    if org not in TENANT_MEMORY:
        TENANT_MEMORY[org] = []
    TENANT_MEMORY[org].append({"timestamp": datetime.utcnow().isoformat(), "message": msg})

    # Simulated AI response
    reply = f"Hi {org.upper()}! You asked: '{msg}'. Here's a demo response."

    return {
        "org_id": org,
        "response": reply,
        "message_history": TENANT_MEMORY[org]
    }
