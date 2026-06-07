from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class SOSRequest(BaseModel):
    latitude: float
    longitude: float


@router.post("/sos")
def send_sos(request: SOSRequest):

    return {
        "success": True,
        "message": "Emergency request received",
        "latitude": request.latitude,
        "longitude": request.longitude,
        "status": "Pending"
    }