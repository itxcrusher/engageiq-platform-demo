from fastapi import APIRouter, Depends
from app.auth import get_current_user
import boto3
import os
from datetime import datetime

router = APIRouter()

dynamo = boto3.resource("dynamodb", region_name=os.getenv("REGION", "eu-west-1"))
table = dynamo.Table(os.getenv("DYNAMODB_TABLE", "engageiq-chat-demo"))

@router.post("/submit-question")
def submit_question(payload: dict, user=Depends(get_current_user)):
    pk = f"ORG#{user['org_id']}#USER#{user['user_id']}"
    sk = f"MSG#{datetime.utcnow().isoformat()}"
    table.put_item(Item={"PK": pk, "SK": sk, "question": payload["question"]})
    return {"status": "saved", "org": user["org_id"], "user": user["user_id"]}
