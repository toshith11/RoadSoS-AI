from fastapi import APIRouter
from data.storage import incidents

router = APIRouter()

@router.get("/incidentHistory")
def incident_history():

    return incidents