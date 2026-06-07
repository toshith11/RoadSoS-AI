from fastapi import APIRouter
from data.storage import incidents

router = APIRouter()

@router.put("/acceptIncident/{incident_id}")
def accept_incident(incident_id: str):

    for incident in incidents:

        if incident["incident_id"] == incident_id:

            incident["status"] = "Accepted"

            return {
                "message": "Incident Accepted"
            }

    return {
        "message": "Incident Not Found"
    }

@router.put("/resolveIncident/{incident_id}")
def resolve_incident(incident_id: str):

    for incident in incidents:

        if incident["incident_id"] == incident_id:

            incident["status"] = "Resolved"

            return {
                "message": "Incident Resolved"
            }

    return {
        "message": "Incident Not Found"
    }