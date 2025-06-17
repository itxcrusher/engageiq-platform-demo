from fastapi import APIRouter, Depends, Request
from app.auth import get_current_user

router = APIRouter()

@router.get("/get-chat-history")
async def get_history(request: Request, _=Depends(get_current_user)):
    # Demo response
    return {"history": [], "org": request.state.org_id, "user": request.state.user_id}
