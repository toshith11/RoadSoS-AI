from fastapi import APIRouter
from pydantic import BaseModel
from datetime import datetime
from services.sos_db import save_sos_request

from services.hospital_finder import find_nearest_hospital
from services.police_finder import find_nearest_police
from services.firestation_finder import find_nearest_firestation
from services.trauma_finder import find_nearest_trauma_center
from services.eta_service import calculate_eta

router = APIRouter()


class SOSRequest(BaseModel):
    phone: str
    service: str
    latitude: float
    longitude: float


@router.post("/sos")
def send_sos(data: SOSRequest):

    service = data.service.lower()

    assigned_service = None

    # Find nearest service
    if service == "ambulance":

        assigned_service = find_nearest_hospital(
            data.latitude,
            data.longitude
        )

        message = "Ambulance request created"

    elif service == "police":

        assigned_service = find_nearest_police(
            data.latitude,
            data.longitude
        )

        message = "Police request created"

    elif service == "fire force":

        assigned_service = find_nearest_firestation(
            data.latitude,
            data.longitude
        )

        message = "Fire rescue request created"

    elif service == "trauma":

        assigned_service = find_nearest_trauma_center(
            data.latitude,
            data.longitude
        )

        message = "Trauma support request created"

    else:

        return {
            "success": False,
            "message": "Invalid service selected"
        }

    if assigned_service is None:

        return {
            "success": False,
            "message": "No nearby service found"
        }

    # Calculate ETA
    eta = calculate_eta(
        data.latitude,
        data.longitude,
        assigned_service["lat"],
        assigned_service["lon"]
    )

    save_sos_request({

    "phone": data.phone,

    "service": service,

    "latitude": data.latitude,
    "longitude": data.longitude,

    "assigned_service":
        assigned_service["name"],

    "eta":
        f"{eta} minutes",

    "timestamp":
        datetime.now().strftime(
            "%Y-%m-%d %H:%M:%S"
        )
})
    
    return {
    "success": True,
    "message": message,
    "eta": f"{eta} minutes"
}