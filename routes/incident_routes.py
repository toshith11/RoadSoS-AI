from fastapi import APIRouter
from models.incident_model import Incident
from data.storage import incidents

router = APIRouter()

@router.post("/uploadIncident")
def upload_incident(incident: Incident):

    incidents.append(incident.dict())

    return {
        "message": "Incident Uploaded Successfully",
        "data": incident
    }

@router.get("/reports")
def get_reports():

    return incidents