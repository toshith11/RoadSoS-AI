from fastapi import APIRouter
from data.storage import incidents

router = APIRouter()

@router.get("/incidentHistory")
def incident_history():

    history = []

    for incident in incidents:

        history.append({

            "incident_id":
                incident["incident_id"],

            "timestamp":
                incident["timestamp"],

            "severity":
                incident["severity"],

            "status":
                incident["status"],

            "required_services":
                incident["recommended_services"],

            "description":
                incident["description"]

        })

    return history