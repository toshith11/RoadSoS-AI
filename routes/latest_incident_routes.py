from fastapi import APIRouter
from data.storage import incidents

router = APIRouter()

@router.get("/latestIncident")
def latest_incident():

    if not incidents:
        return {
            "message": "No incidents found"
        }

    return incidents[-1]