from fastapi import APIRouter
from data.storage import incidents, rewards

router = APIRouter()

@router.get("/home")

def home_data():

    recent_incidents = incidents[-5:]

    leaderboard_preview = rewards[-5:]

    return {

        "app_name": "RoadSoS",

        "status": "Emergency Response System Active",

        "total_incidents": len(incidents),

        "total_helpers": len(rewards),

        "recent_incidents": recent_incidents,

        "leaderboard_preview": leaderboard_preview
    }