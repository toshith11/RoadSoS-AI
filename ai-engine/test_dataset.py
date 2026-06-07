import os

from models.clip_classifier import classify_image

DATASET_PATH = "dataset/val"

VALID_EXTENSIONS = (
    ".jpg",
    ".jpeg",
    ".webp",
    ".png"
)

classes = [
    "normal",
    "minor_accident",
    "major_accident",
    "vehicle_fire"
]

total_images = 0
correct_predictions = 0

for class_name in classes:

    folder = os.path.join(
        DATASET_PATH,
        class_name
    )

    class_total = 0
    class_correct = 0

    print("\nTesting:", class_name)

    for image_file in os.listdir(folder):

        if not image_file.lower().endswith(
            VALID_EXTENSIONS
        ):
            continue

        image_path = os.path.join(
            folder,
            image_file
        )

        result = classify_image(
            image_path
        )

        prediction = result["category"]

        print(
            image_file,
            "->",
            prediction
        )

        class_total += 1
        total_images += 1

        if (
            class_name == "normal"
            and prediction == "normal traffic"
        ):
            class_correct += 1
            correct_predictions += 1

        elif (
            class_name == "minor_accident"
            and prediction == "minor vehicle accident"
        ):
            class_correct += 1
            correct_predictions += 1

        elif (
            class_name == "major_accident"
            and prediction == "major vehicle accident"
        ):
            class_correct += 1
            correct_predictions += 1

        elif (
            class_name == "vehicle_fire"
            and prediction == "vehicle on fire"
        ):
            class_correct += 1
            correct_predictions += 1

    accuracy = (
        class_correct / class_total
    ) * 100

    print(
        f"{class_name} Accuracy: {accuracy:.2f}%"
    )

overall_accuracy = (
    correct_predictions / total_images
) * 100

print("\n====================")
print(
    f"Overall Accuracy: {overall_accuracy:.2f}%"
)
print("====================")