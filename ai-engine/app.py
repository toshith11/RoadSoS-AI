from fastapi import FastAPI, UploadFile, File, Form
from ai.llm_engine import analyze_emergency
import os

from ai.video_analysis import extract_frames, detect_objects
from ai.severity_engine import predict_severity
from ai.recommendation_engine import recommend_services

app = FastAPI()

UPLOAD_FOLDER = "uploads"

os.makedirs(UPLOAD_FOLDER, exist_ok=True)


@app.get("/")
def home():
    return {"message": "AI Engine Running"}


@app.post("/analyze")
async def analyze_incident(
    video: UploadFile = File(...),
    description: str = Form(...)
):

    # Save uploaded video
    file_path = f"{UPLOAD_FOLDER}/{video.filename}"

    with open(file_path, "wb") as buffer:
        buffer.write(await video.read())

    # Extract frames
    total_frames = extract_frames(file_path)

    # Detect objects
    detected_objects = detect_objects()

    # Predict severity
    severity = predict_severity(
        description,
        detected_objects
    )

    # Emergency recommendation
    recommended_services = recommend_services(
        severity,
        detected_objects,
        description
    )

    # Gemini AI Analysis
    llm_analysis = analyze_emergency(
        description,
        detected_objects
    )

    return {
        "message": "Analysis completed",
        "filename": video.filename,
        "description": description,
        "frames_extracted": total_frames,
        "detected_objects": detected_objects,
        "severity": severity,
        "recommended_services": recommended_services,
        "llm_analysis": llm_analysis
    }