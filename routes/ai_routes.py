from fastapi import APIRouter, UploadFile, File, Form
import requests
from datetime import datetime
from data.storage import incidents
from services.recommendation_service import get_recommendations
from services.severity_booster import boost_severity
import uuid
from services.notification_service import contact_service
from services.incident_db import save_incident



router = APIRouter()

AI_ENGINE_URL = "http://127.0.0.1:8001/analyze"


@router.post("/processIncident")
async def process_incident(
    reporter_name: str = Form(...),
    latitude: float = Form(...),
    longitude: float = Form(...),
    injured_count: int = Form(...),
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


    if response.status_code != 200:
        return {
            "success": False,
            "message": "AI Engine Failed"
        }

    ai_result = response.json()

    if "severity" not in ai_result:
        return {
            "success": False,
            "message": "Invalid AI Engine Response"
            }

    # AI severity
    original_severity = ai_result["severity"]

    # Boost severity using description
    final_severity = boost_severity(
        original_severity,
        description
    )
    
    
    # Get recommendations
    recommendation_data = get_recommendations(
        final_severity,
        latitude,
        longitude
    )

    contacts = []

    for service in recommendation_data[
        "recommended_services"
        ]:
        contacts.append(
        contact_service(service)
        )
    
    if contacts:
        status = "Resolved"
    else:
        status = "Pending"

    incident = {

    "incident_id": str(uuid.uuid4()),

    "timestamp": datetime.now().strftime(
        "%Y-%m-%d %H:%M:%S"
    ),

    "status": status,

    "reporter_name": reporter_name,

    "latitude": latitude,
    "longitude": longitude,

    "filename": ai_result["filename"],

    "victims": injured_count,

    "thumbnail":
        ai_result.get("thumbnail"),

    "description":
        ai_result["description"],

    "frames_extracted":
        ai_result["frames_extracted"],

    "predictions":
        ai_result["predictions"],

    "final_category":
        ai_result["final_category"],

    "prediction_scores":
        ai_result["prediction_scores"],

    "confidence_score":
        max(
            ai_result["prediction_scores"].values()
        ),

    "ai_severity":
        original_severity,

    "severity":
        final_severity,

    "recommended_services":
        recommendation_data[
            "recommended_services"
        ],

    "nearest_hospital":
        recommendation_data.get(
            "nearest_hospital"
        ),

    "nearest_police_station":
        recommendation_data.get(
            "nearest_police_station"
        ),

    "nearest_fire_station":
        recommendation_data.get(
            "nearest_fire_station"
        ),

    "nearest_trauma_center":
        recommendation_data.get(
            "nearest_trauma_center"
        ),
        "contacts_notified": contacts
}
    save_incident(incident)

    print("\n========== NEW INCIDENT ==========")
    print(incident)
    print("==================================\n")

    return {
    "success": True,
    "severity": final_severity,
    "victims_detected": injured_count,
    "required_services":
        recommendation_data["recommended_services"]
}