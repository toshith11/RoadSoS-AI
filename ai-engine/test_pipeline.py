from services.video_analysis import extract_frames

frames = extract_frames("test.mp4")

print("Frames extracted:", len(frames))
print(frames)