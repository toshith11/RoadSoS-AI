from services.video_analysis import extract_frames

from models.clip_classifier import classify_image

from models.severity_engine import calculate_severity

from confidence_engine import average_predictions

frames = extract_frames("test.mp4")

predictions = []

for frame in frames:

    result = classify_image(frame)

    print(result)

    predictions.append(result)

severity = calculate_severity(
    predictions
)

final_prediction = average_predictions(
    predictions
)

print(
    "\nFinal Category:",
    final_prediction
)