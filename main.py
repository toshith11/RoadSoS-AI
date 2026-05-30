from fastapi import FastAPI

from routes.incident_routes import router as incident_router
from routes.reward_routes import router as reward_router
from routes.analysis_routes import router as analysis_router
from routes.upload_routes import router as upload_router
from routes.home_routes import router as home_router
from routes.ai_routes import router as ai_router
from routes.history_routes import router as history_router
from routes.latest_incident_routes import router as latest_incident_router

app = FastAPI(
    title="RoadSoS Backend",
    description="Emergency Accident Response Backend",
    version="1.0"
)

@app.get("/")
def home():
    return {
        "message": "RoadSoS Backend Running Successfully"
    }

app.include_router(incident_router)
app.include_router(reward_router)
app.include_router(analysis_router)
app.include_router(upload_router)
app.include_router(home_router)
app.include_router(ai_router)
app.include_router(history_router)
app.include_router(latest_incident_router)