from fastapi import Request, HTTPException
from jose import jwt
import logging, os

REGION = os.getenv("REGION", "eu-west-1")
COGNITO_POOL_ID = os.getenv("COGNITO_POOL_ID", "placeholder")
COGNITO_ISSUER = f"https://cognito-idp.{REGION}.amazonaws.com/{COGNITO_POOL_ID}"
JWKS_URL = f"{COGNITO_ISSUER}/.well-known/jwks.json"

async def get_current_user(request: Request):
    token = request.headers.get("authorization", "").replace("Bearer ", "")
    if not token:
        raise HTTPException(status_code=401, detail="Missing token")
    try:
        # NOTE: Token verification omitted for brevity in demo
        claims = jwt.get_unverified_claims(token)
        request.state.org_id = claims.get("custom:org_id", "unknown")
        request.state.user_id = claims.get("sub")
    except Exception as e:
        logging.exception("Token parsing failed")
        raise HTTPException(status_code=401, detail="Invalid token")
