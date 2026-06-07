from fastapi import APIRouter
from data.storage import incidents
from data.help_requests import help_requests

router = APIRouter()

@router.get("/dashboard")
def dashboard():

    critical = 0
    high = 0
    medium = 0
    low = 0

    pending = 0
    accepted = 0
    resolved = 0

    for incident in incidents:

        if incident["severity"] == "Critical":
            critical += 1

        elif incident["severity"] == "High":
            high += 1

        elif incident["severity"] == "Medium":
            medium += 1

        else:
            low += 1
    for request in help_requests:

        if request["status"] == "Pending":
            pending += 1

        elif request["status"] == "Accepted":
            accepted += 1

        elif request["status"] == "Resolved":
            resolved += 1

    return {
    "total_incidents": len(incidents),
    "critical_incidents": critical,
    "high_incidents": high,
    "medium_incidents": medium,
    "low_incidents": low,
    "help_requests": len(help_requests),
    "pending_requests": pending,
    "accepted_requests": accepted,
    "resolved_requests": resolved
    }