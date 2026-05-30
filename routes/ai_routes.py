from fastapi import APIRouter, UploadFile, File, Form
import requests

router = APIRouter()

AI_ENGINE_URL = "http://127.0.0.1:8001/analyze"

@router.post("/processIncident")

async def process_incident(

    video: UploadFile = File(...),
    description: str = Form(...)

):

    files = {
        "video": (
            video.filename,
            await video.read(),
            video.content_type
        )
    }

    data = {
        "description": description
    }

    response = requests.post(
        AI_ENGINE_URL,
        files=files,
        data=data
    )

    ai_result = response.json()

    return {
        "backend_message": "AI Analysis Completed",
        "ai_response": ai_result
    }