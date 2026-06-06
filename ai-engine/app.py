from fastapi import FastAPI, UploadFile, File, Form
import os
from services.video_analysis import extract_frames

from models.clip_classifier import classify_image

from models.severity_engine import calculate_severity

from aggregation_engine import get_final_category
from models.severity_engine import calculate_severity

app = FastAPI()

UPLOAD_FOLDER = "uploads"

os.makedirs(UPLOAD_FOLDER, exist_ok=True)


@app.get("/")
def home():
    return {
        "message": "RoadSOS AI Engine Running"
    }


@app.post("/analyze")
async def analyze(
    video: UploadFile = File(...),
    description: str = Form(...)
):

    # Save uploaded video
    video_path = os.path.join(
        UPLOAD_FOLDER,
        video.filename
    )

    with open(video_path, "wb") as buffer:
        buffer.write(await video.read())

    # Extract frames
    frames = extract_frames(video_path)

    # Analyze frames
    predictions = []

    for frame in frames:

        result = classify_image(frame)

        predictions.append(result)

# Count category scores using confidence
    prediction_scores = {}

    for result in predictions:

        category = result["category"]
        confidence = result["confidence"]

        if category not in prediction_scores:
            prediction_scores[category] = 0

        prediction_scores[category] += confidence

# Get final category
    final_category = max(
        prediction_scores,
        key=prediction_scores.get
        )

# Get severity
    severity = calculate_severity(
        final_category
    )

    return {
        "filename": video.filename,
        "description": description,
        "frames_extracted": len(frames),
        "predictions": predictions,
        "final_category": final_category,
        "prediction_scores": prediction_scores,
        "severity": severity
        }