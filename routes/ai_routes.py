from fastapi import APIRouter, UploadFile, File, Form
import requests

from data.storage import incidents
from services.recommendation_service import get_recommendations
from services.severity_booster import boost_severity

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

    incident = {

        "reporter_name": reporter_name,

        "latitude": latitude,
        "longitude": longitude,

        "filename": ai_result["filename"],

        "description": ai_result["description"],

        "frames_extracted":
            ai_result["frames_extracted"],

        "predictions":
            ai_result["predictions"],

        "final_category":
            ai_result["final_category"],

        "prediction_scores":
            ai_result["prediction_scores"],

        "severity":
            final_severity,

        "recommended_services":
            recommendation_data["recommended_services"],

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
            )
    }

    incidents.append(incident)

    print("\n========== NEW INCIDENT ==========")
    print(incident)
    print("==================================\n")

    return incident