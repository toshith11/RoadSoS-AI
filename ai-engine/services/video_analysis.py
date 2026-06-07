import cv2
import os

def extract_frames(video_path):

    output_folder = "frames"

    os.makedirs(output_folder, exist_ok=True)

    cap = cv2.VideoCapture(video_path)

    frame_paths = []

    count = 0

    while True:

        ret, frame = cap.read()

        if not ret:
            break

        if count % 30 == 0:

            path = f"{output_folder}/frame_{count}.jpg"

            cv2.imwrite(path, frame)

            frame_paths.append(path)

        count += 1

    cap.release()

    return frame_paths