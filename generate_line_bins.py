import cv2 as cv
import numpy as np
import struct

INPUT_VIDEO = "./assets/bad_apple.mp4"
OUTPUT_VIDEO = "./bad_apple_ln.bin"
IMAGE_H = 64
IMAGE_W = 128
THRESHOLD = 128
cap = cv.VideoCapture(INPUT_VIDEO)

def convert_to_lines():
    with open(OUTPUT_VIDEO, "wb") as f_out:
        frame_count = 0
        while cap.isOpened():
            ret, frame = cap.read()
            if frame_count % 2 != 0:
                frame_count += 1
                continue
            if not ret:
                print("Could not retrieved the frame...")
                break
            gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
            resized = cv.resize(gray, (IMAGE_W, IMAGE_H))
            _, bin_img = cv.threshold(resized, THRESHOLD, 255, cv.THRESH_BINARY)
            commands = []
            for y in range(IMAGE_H):
                row = bin_img[y]
                x = 0
                while x < IMAGE_W:
                    if row[x] == 255:  # if white
                        start_x = x
                        while x < IMAGE_W and row[x] == 255:
                            x += 1
                        length = x -start_x
                        commands.append(struct.pack("BBB", y, start_x, length))
                    else:
                        x += 1
            num_lines = len(commands)
            f_out.write(struct.pack('>H',num_lines))
            for cmd in commands:
                f_out.write(cmd)
            frame_count += 1
            if frame_count % 100 == 0: print(f"Frame {frame_count}...", end='\r')
        print(f"\nDone! Saved {frame_count} frames.")
if __name__ == "__main__":
    convert_to_lines()
