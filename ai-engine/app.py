from fastapi import FastAPI, UploadFile, File, Form
import os

from video_analysis import extract_frames
from clip_classifier import classify_image
from severity_engine import calculate_severity

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

        prediction = classify_image(frame)

        predictions.append(prediction)

    # Calculate severity
    severity = calculate_severity(predictions)

    # Count prediction occurrences
    prediction_counts = {}

    for prediction in predictions:

        if prediction not in prediction_counts:
            prediction_counts[prediction] = 0

        prediction_counts[prediction] += 1

    return {
        "filename": video.filename,
        "description": description,
        "frames_extracted": len(frames),
        "predictions": predictions,
        "prediction_counts": prediction_counts,
        "severity": severity
    }