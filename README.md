# Bad Apple!! for OpenTX / EdgeTX

This project pushes the hardware limits of monochrome RC transmitters (running OpenTX or EdgeTX) by playing the iconic "Bad Apple!!" music video on a 128x64 pixel display, complete with synchronized audio.

## 🚀 Features

* **Custom Video Compression:** Instead of storing raw pixel matrices, the Python script uses a Run-Length Encoding (RLE) logic. It scans for continuous white pixels and encodes them into a highly efficient 3-byte command format `(y, start_x, length)`.
* **Audio-Video Synchronization:** The Lua script utilizes a custom frame-pacing algorithm based on `getTime()` to maintain a stable 15 FPS, ensuring the video stays perfectly synced with the `.wav` audio track.
* **Hardware Feedback:** Built-in haptic and audio feedback mechanisms alert the user if the required binary files are missing from the SD card.
* **Optimized for Embedded Systems:** Heavily relies on the native `lcd.drawLine()` function to render frames with minimal CPU and memory overhead.

## 🛠️ Prerequisites

**For the PC (Processing the video):**
* Python 3.x
* OpenCV (`pip install opencv-python`)

**For the Transmitter (Playback):**
* An RC Transmitter running OpenTX or EdgeTX (monochrome 128x64 display is assumed).
* SD Card access.

## ⚙️ How It Works

1. **Python Script (Encoder):** Reads the original video, downsizes it to the target resolution, and drops the framerate to 15 FPS to save memory. It then scans each frame horizontally and generates a custom binary file (`.bin`) containing line-drawing instructions.
2. **Lua Script (Player):** Runs on the transmitter. It reads the `.bin` file frame by frame, decodes the 2-byte headers (number of lines to draw) and the 3-byte line data, and renders it to the LCD while playing the accompanying `.wav` file.

## 📖 Usage Instructions

### 1. Prepare the Files
1. Run the Python conversion script to generate the video binary file.
2. Ensure you have the audio file converted to the correct `.wav` format required by your radio (typically 16kHz or 32kHz, Mono, PCM).

### 2. SD Card Setup
Copy the generated files to your radio's SD Card:
* Place the Lua script in the `SCRIPTS/TOOLS` or `SCRIPTS/TELEMETRY` folder (depending on how you wish to launch it).
* Place the generated `.bin` video file and `.wav` audio file in the designated paths specified in your Lua script (e.g., inside a `SCRIPTS/BADAPPLE/` directory).

### 3. Play
Navigate to the script on your radio, execute it, and enjoy the show!

## 📝 Future Improvements (To-Do)
* Implement buffered I/O reads in Lua (fetching all line data for a frame in a single read operation) to reduce SD card access overhead and prevent micro-stutters in visually busy scenes.