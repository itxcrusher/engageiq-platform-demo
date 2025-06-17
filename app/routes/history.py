from fastapi import APIRouter, Depends
from app.auth import get_current_user

router = APIRouter()

@router.get("/get-chat-history")
def get_chat_history(user=Depends(get_current_user)):
    pk = f"ORG#{user['org_id']}#USER#{user['user_id']}"
    resp = table.query(KeyConditionExpression="PK = :pk", ExpressionAttributeValues={":pk": pk})
    return {"messages": resp.get("Items", [])}
