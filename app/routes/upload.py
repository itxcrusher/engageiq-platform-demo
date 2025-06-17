from fastapi import APIRouter, File, UploadFile, Depends
from app.auth import get_current_user
from datetime import datetime

router = APIRouter()

@router.post("/upload-file")
async def upload_file(file: UploadFile = File(...), user=Depends(get_current_user)):
    # Simulate storing file and generating URL
    timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S")
    fake_url = f"https://demo-bucket.s3.amazonaws.com/{user['org_id']}/{timestamp}-{file.filename}"
    return {
        "filename": file.filename,
        "url": fake_url,
        "message": f"Mock upload complete for org '{user['org_id']}'"
    }
