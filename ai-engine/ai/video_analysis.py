import cv2
import os

from ultralytics import YOLO

# Load YOLO model
model = YOLO("yolov8n.pt")


def extract_frames(video_path, output_folder="extracted_frames"):

    # Create folder if not exists
    os.makedirs(output_folder, exist_ok=True)

    # CLEAR OLD FRAMES
    for file in os.listdir(output_folder):

        file_path = os.path.join(output_folder, file)

        if os.path.isfile(file_path):
            os.remove(file_path)

    # Open video
    cap = cv2.VideoCapture(video_path)

    frame_count = 0
    saved_count = 0

    while True:

        success, frame = cap.read()

        if not success:
            break

        # Save every 30th frame
        if frame_count % 30 == 0:

            frame_filename = f"{output_folder}/frame_{saved_count}.jpg"

            cv2.imwrite(frame_filename, frame)

            saved_count += 1

        frame_count += 1

    cap.release()

    return saved_count


def detect_objects(frame_folder="extracted_frames"):

    detected_objects = []

    for frame_file in os.listdir(frame_folder):

        frame_path = os.path.join(frame_folder, frame_file)

        results = model(frame_path)

        for result in results:

            boxes = result.boxes

            for box in boxes:

                class_id = int(box.cls[0])

                class_name = model.names[class_id]

                allowed_objects = [
                    "person",
                    "car",
                    "truck",
                    "bus",
                    "motorcycle",
                    "bicycle"
                ]

                if class_name in allowed_objects:
                    detected_objects.append(class_name)

    return list(set(detected_objects))