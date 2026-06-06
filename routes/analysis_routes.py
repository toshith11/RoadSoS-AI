from fastapi import APIRouter
from models.incident_model import Incident

router = APIRouter()

@router.post("/analyzeSeverity")
def analyze_severity(incident: Incident):

    if incident.severity == "Critical":

        response = [
            "Police",
            "Ambulance",
            "Fire Brigade"
            ]

    elif incident.severity == "High":

        response = [
        "Police",
        "Ambulance"
        ]

    elif incident.severity == "Medium":

        response = [
        "Ambulance"
        ]

    else:

        response = []