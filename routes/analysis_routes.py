from fastapi import APIRouter
from models.incident_model import Incident

router = APIRouter()

@router.post("/analyzeSeverity")
def analyze_severity(incident: Incident):

    if incident.severity.lower() == "high":
        response = "Ambulance + Police"

    elif incident.severity.lower() == "medium":
        response = "Nearest Hospital"

    else:
        response = "Minor Assistance"

    return {
        "required_response": response
    }