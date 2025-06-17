from fastapi import FastAPI

from app.routes import chat, history, upload

app = FastAPI(title="EngageIQ Demo API")

app.include_router(chat.router, prefix="/api")
app.include_router(history.router, prefix="/api")
app.include_router(upload.router, prefix="/api")


@app.get("/health")
async def health():
    return {"status": "ok"}
