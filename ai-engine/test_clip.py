from models.clip_classifier import classify_image

result = classify_image(
    "frames/frame_0.jpg"
)

print(result)