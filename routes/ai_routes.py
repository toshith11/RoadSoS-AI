from fastapi import APIRouter, UploadFile, File, Form
import requests
from data.storage import incidents

router = APIRouter()

AI_ENGINE_URL = "http://127.0.0.1:8001/analyze"

@router.post("/processIncident")
async def process_incident(
    reporter_name: str = Form(...),
    latitude: float = Form(...),
    longitude: float = Form(...),
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

    ai_result = {
    "filename": video.filename,
    "description": description,
    "frames_extracted": 22,
    "object_counts": {
        "car": 10
    },
    "evidence_score": 100,
    "severity": "Critical",
    "recommended_services": [
        "Police",
        "Ambulance"
    ],

    "nearest_hospital": {
        "name": "Trauma Center",
        "distance": "1.5 km"
    },

    "nearest_police_station": {
        "name": "Central Police Station",
        "distance": "2 km"
    },

    "nearest_ambulance": {
        "ambulance_id": "AMB-101",
        "distance": "1 km"
    },

    "llm_analysis": "Test analysis"
}

    incident = {

    "reporter_name": reporter_name,

    "latitude": latitude,
    "longitude": longitude,

    "filename": ai_result["filename"],

    "description": ai_result["description"],

    "frames_extracted": ai_result["frames_extracted"],

    "object_counts": ai_result["object_counts"],

    "evidence_score": ai_result["evidence_score"],

    "severity": ai_result["severity"],

    "recommended_services": ai_result["recommended_services"],

    "nearest_hospital": ai_result.get("nearest_hospital"),

    "nearest_police_station": ai_result.get("nearest_police_station"),

    "nearest_ambulance": ai_result.get("nearest_ambulance"),

    "llm_analysis": ai_result["llm_analysis"]
    }

    print("Before save:", incidents)

    incidents.append(incident)

    print("After save:", incidents)

    return incident