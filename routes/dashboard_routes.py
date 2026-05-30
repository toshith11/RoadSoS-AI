from fastapi import APIRouter
from data.storage import incidents

router = APIRouter()

@router.get("/dashboard")
def dashboard():

    critical = 0
    moderate = 0
    low = 0

    for incident in incidents:

        if incident["severity"] == "Critical":
            critical += 1

        elif incident["severity"] == "Moderate":
            moderate += 1

        else:
            low += 1

    return {
        "total_incidents": len(incidents),
        "critical_incidents": critical,
        "moderate_incidents": moderate,
        "low_incidents": low
    }