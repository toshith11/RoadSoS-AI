from pydantic import BaseModel

class Incident(BaseModel):
    severity: str
    required_service: str
    location: str