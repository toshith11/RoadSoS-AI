from transformers import CLIPProcessor
from transformers import CLIPModel

from PIL import Image

import torch

model = CLIPModel.from_pretrained(
    "openai/clip-vit-base-patch32"
)

processor = CLIPProcessor.from_pretrained(
    "openai/clip-vit-base-patch32"
)

labels = [
    "normal traffic",
    "minor vehicle accident",
    "major vehicle accident",
    "vehicle on fire"
]

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

    prediction = labels[
        probs.argmax().item()
    ]

    return prediction