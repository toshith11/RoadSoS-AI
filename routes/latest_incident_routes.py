from fastapi import APIRouter
from data.storage import incidents

router = APIRouter()

@router.get("/latestIncident")
def latest_incident():

    if not incidents:
        return {"message": "No incidents found"}

    latest = incidents[-1]

    return {
        "severity": latest.get("severity"),
        "recommended_services": latest.get("recommended_services"),
        "nearest_hospital": latest.get("nearest_hospital"),
        "nearest_police_station": latest.get("nearest_police_station"),
        "nearest_ambulance": latest.get("nearest_ambulance")
    }