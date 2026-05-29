from fastapi import FastAPI, UploadFile, File, Form
import os

app = FastAPI()

UPLOAD_FOLDER = "uploads"

# Create uploads folder automatically
os.makedirs(UPLOAD_FOLDER, exist_ok=True)


@app.get("/")
def home():
    return {"message": "AI Engine Running"}


@app.post("/analyze")
async def analyze_incident(
    video: UploadFile = File(...),
    description: str = Form(...)
):

    # File path
    file_path = f"{UPLOAD_FOLDER}/{video.filename}"

    # Save uploaded video
    with open(file_path, "wb") as buffer:
        buffer.write(await video.read())

    return {
        "message": "Video uploaded successfully",
        "filename": video.filename,
        "description": description
    }