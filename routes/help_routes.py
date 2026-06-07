from fastapi import APIRouter
from pydantic import BaseModel
from datetime import datetime
import uuid
from services.call_service import place_miss_call

from data.help_requests import help_requests

router = APIRouter()


class HelpRequest(BaseModel):
    phone: str
    latitude: float
    longitude: float
    service: str


@router.post("/requestHelp")
def request_help(data: HelpRequest):
    if data.service == "All":

        services = [
            "Ambulance",
            "Police",
            "Fire"
        ]

    else:

        services = [data.service]

    request = {

        "request_id": str(uuid.uuid4()),

        "phone": data.phone,

        "latitude": data.latitude,
        "longitude": data.longitude,

        "service": data.service,

        "status": "Pending",

        "created_at":
            datetime.now().strftime(
                "%Y-%m-%d %H:%M:%S"
            )
    }

    help_requests.append(request)


    print("\n===== HELP REQUEST =====")
    print(request)
    print("========================\n")
    place_miss_call("9353571382")
    return {
        "success": True,
        "message": f"{data.service} notified",
        "request_id": request["request_id"],
        "status": "Pending"
    }

@router.put("/updateHelpStatus/{request_id}")
def update_help_status(
    request_id: str,
    status: str
):

    for request in help_requests:

        if request["request_id"] == request_id:

            request["status"] = status

            return {
                "success": True,
                "message": "Status Updated",
                "data": request
            }

    return {
        "success": False,
        "message": "Request Not Found"
    }