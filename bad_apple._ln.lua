local VIDEO_BIN_PATH = "/SCRIPTS/BADAPPLE/bad_apple_ln.bin"
local AUDIO_WAV_PATH = "/SCRIPTS/BADAPPLE/bad_apple_audio.wav"
local video_bin = nil
local FPS = 15
local start_time = nil
local frame_count = 0

local function init()
    lcd.drawText(64,32,"BAD APPLE!! PV",BOLD+MIDSIZE)
    video_bin = io.open(VIDEO_BIN_PATH, "rb")
    if video_bin then 
        playFile(AUDIO_WAV_PATH)
        start_time = getTime()
    end
  
end

local function run(event)
    
    if not video_bin then
        playTone(2550, 160, 20, 3, -10, 5)
        playHaptic(3,0)
        lcd.drawText(10,10,"No Video File",0)
        return 0
    end
    if not start_time then
        start_time = getTime() 
    end
    local now = getTime()
    local elapsed_ticks = now - start_time
    local expected_frame = math.floor((elapsed_ticks / 100) * FPS)

    if frame_count > expected_frame then
        return 0
    end
    local header = io.read(video_bin, 2)
    if not header or #header < 2 then return 0 end
    local byte1 = string.byte(header, 1)
    local byte2 = string.byte(header, 2)
    local num_lines = (byte1 * 256) + byte2
    lcd.clear()
    for i = 1, num_lines do
        local data = io.read(video_bin, 3)

        if data and #data == 3 then
            local y = string.byte(data, 1)
            local x = string.byte(data, 2)
            local len = string.byte(data, 3) 
            lcd.drawLine(x, y, x + len, y, SOLID, 0)
        end
    end
    frame_count = frame_count + 1
    return 0
end
return {init=init, run=run}