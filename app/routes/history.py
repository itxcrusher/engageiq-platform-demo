from fastapi import APIRouter, Depends
from app.auth import get_current_user
from app.routes.chat import TENANT_MEMORY

router = APIRouter()

@router.get("/chat-history")
def get_chat_history(user=Depends(get_current_user)):
    org_id = user["org_id"]
    history = TENANT_MEMORY.get(org_id, [])
    return {
        "org_id": org_id,
        "history_count": len(history),
        "messages": history
    }
