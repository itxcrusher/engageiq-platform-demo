import boto3
import os
from fastapi import APIRouter, UploadFile, File, Depends
import uuid

router = APIRouter()

s3 = boto3.client("s3", region_name=os.getenv("REGION", "eu-west-1"))
bucket = os.getenv("S3_BUCKET", "engageiq-demo-bucket-hassaan")

def get_current_user():
    return {"user_id": "demo-user"}

@router.post("/upload-file")
def upload_file(file: UploadFile = File(...), user=Depends(get_current_user)):
    key = f"{user['org_id']}/{uuid.uuid4()}-{file.filename}"
    url = s3.generate_presigned_url(
        ClientMethod="put_object",
        Params={"Bucket": bucket, "Key": key, "ContentType": file.content_type},
        ExpiresIn=300,
    )
    return {"upload_url": url, "key": key}
