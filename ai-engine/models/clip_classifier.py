from transformers import CLIPProcessor
from transformers import CLIPModel

from PIL import Image

model = CLIPModel.from_pretrained(
    "openai/clip-vit-base-patch32"
)

processor = CLIPProcessor.from_pretrained(
    "openai/clip-vit-base-patch32"
)

NORMAL = [
    "normal traffic",
    "vehicles moving on road",
    "cars driving safely"
]

MINOR = [
    "small vehicle accident",
    "vehicle with dents",
    "minor collision damage"
]

MAJOR = [
    "major road accident",
    "heavily damaged vehicle",
    "serious vehicle collision"
]

FIRE = [
    "car on fire",
    "vehicle burning",
    "road accident with flames"
]

labels = (
    NORMAL +
    MINOR +
    MAJOR +
    FIRE
)


def classify_image(image_path):

    image = Image.open(image_path)

    inputs = processor(
        text=labels,
        images=image,
        return_tensors="pt",
        padding=True
    )

    outputs = model(**inputs)

    logits = outputs.logits_per_image

    probs = logits.softmax(dim=1)

    best_index = probs.argmax().item()

    best_label = labels[best_index]

    confidence = probs[0][best_index].item()

    if best_label in NORMAL:
        category = "normal traffic"

    elif best_label in MINOR:
        category = "minor vehicle accident"

    elif best_label in MAJOR:
        category = "major vehicle accident"

    elif best_label in FIRE:
        category = "vehicle on fire"

    else:
        category = "unknown"

    return {
        "category": category,
        "confidence": confidence
        }