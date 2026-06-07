from fastapi import APIRouter
from data.storage import incidents

router = APIRouter()

@router.get("/dashboard")
def dashboard():

    critical = 0
    high = 0
    medium = 0
    low = 0

    for incident in incidents:

        if incident["severity"] == "Critical":
            critical += 1

        elif incident["severity"] == "High":
            high += 1

        elif incident["severity"] == "Medium":
            medium += 1

        else:
            low += 1

    return {
    "total_incidents": len(incidents),
    "critical_incidents": critical,
    "high_incidents": high,
    "medium_incidents": medium,
    "low_incidents": low
}