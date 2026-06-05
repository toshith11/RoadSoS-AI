from pydantic import BaseModel
from typing import List, Dict

class Incident(BaseModel):

    reporter_name: str

    latitude: float
    longitude: float

    description: str

    filename: str

    frames_extracted: int

    object_counts: Dict[str, int]

    evidence_score: int

    severity: str

    recommended_services: List[str]

    llm_analysis: str