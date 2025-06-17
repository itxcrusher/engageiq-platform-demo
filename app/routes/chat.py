from fastapi import APIRouter, Depends, Request
from app.auth import get_current_user

router = APIRouter()

@router.post("/submit-question")
async def submit_question(payload: dict, request: Request, _=Depends(get_current_user)):
    org = request.state.org_id
    user = request.state.user_id
    # Stub response
    return {"org": org, "user": user, "answer": "This is a stubbed LLM response."}
