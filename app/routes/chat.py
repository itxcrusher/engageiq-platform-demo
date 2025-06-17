from fastapi import APIRouter
from pydantic import BaseModel
from datetime import datetime

router = APIRouter()

# In-memory per-tenant chat history (resets on app restart)
TENANT_MEMORY: dict[str, list] = {}

class ChatPayload(BaseModel):
    org_id: str
    user_id: str
    message: str

@router.post("/chat")
def chat(payload: ChatPayload):
    org   = payload.org_id
    user  = payload.user_id
    msg   = payload.message

    # Initialise tenant history if first time
    history = TENANT_MEMORY.setdefault(org, [])

    # Append new entry
    history.append({
        "timestamp": datetime.utcnow().isoformat(),
        "user": user,
        "message": msg
    })

    # Simulated AI reply
    reply = f"Hi {user}! You asked: '{msg}'. Here's a demo response."

    return {
        "org_id": org,
        "user_id": user,
        "response": reply,
        "message_history": history   # now includes user field
    }
