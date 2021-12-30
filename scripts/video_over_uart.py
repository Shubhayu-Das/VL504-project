import imageio as iio   # This is with the FFmpeg backend
import numpy as np
import matplotlib.pyplot as plt

import serial, time

from data import data
from mapping import lookup

COMPORT = '/dev/ttyUSB1'

# Set this to true to see the RGB contents of the final frame sent over UART
PLOT = True

'''
# Vary this mode to send different images
#
# MODE = "image" will send the data stored in data.py and mapping.py
# This is effectively images/vga-over-uart/test-original.jpg
#
# MODE = "test" will send a test pattern, which will show all possible
# colors
#
# MODE = "camera" works only if imageio is installed. This will use your
# laptop's camera and send over the image to the FPGA
'''
# MODE = "image"
# MODE = "test"
MODE = "camera"

# Don't change these
BAUD_RATE = 1843200
RES_X = 320
RES_Y = 240

# This can be varied to see the effect of the number of bits per pixel
BITS_PER_PIXEL = 4
# Creating a mask to select the requisite number of bits
mask = np.uint8(int('1'*BITS_PER_PIXEL+'0'*(8-BITS_PER_PIXEL), 2))

# Open and get access to the camera at specified resolution and FPS
if MODE == "camera":
    camera = iio.get_reader("<video0>", size=(RES_X, RES_Y))

# Open the serial port at specified baud rate
ComPort = serial.Serial(COMPORT)
ComPort.baudrate = BAUD_RATE
ComPort.bytesize = 8    # Number of data bits = 8
ComPort.parity   = 'N'  # No parity
ComPort.stopbits = 1    # Number of Stop bits = 1

if MODE == "camera":
    n_frames = 40
elif MODE == "test":
    n_frames = 32
else:
    n_frames = 2

captured = np.zeros((RES_X, RES_Y, 3), dtype=np.uint8)
buffer = np.zeros((RES_X, RES_Y, 3), dtype=np.uint8)
packed = np.zeros(RES_X * RES_Y, dtype=np.uint16)

if MODE == "image":
    image = lookup[data]

print(f"Starting at {RES_X}x{RES_Y} for {n_frames} frames")

# Iterate for a certain number of frames, set above
for frame_counter in range(n_frames):
    if MODE == "camera":
        # Get the frame from the camera, and reshape
        captured = np.asarray(camera.get_next_data())

        captured = np.rot90(captured, 1, axes=(0, 1))
        captured = captured.reshape(RES_X, RES_Y, 3)

        buffer = np.bitwise_and(captured, mask)

    # Send some test pattern sequences
    elif MODE == "test":
        buffer[frame_counter:frame_counter+48, frame_counter:frame_counter+32, 0] = 255-frame_counter*16
        buffer[frame_counter:frame_counter+48, frame_counter+80:frame_counter+112, 1] = 255-frame_counter*16
        buffer[frame_counter:frame_counter+48, frame_counter+160:frame_counter+192, 2] = 255-frame_counter*16
        
    # Use a test image generated using MATLAB
    elif MODE == "image":
        buffer = np.bitwise_and(image.reshape(RES_X, RES_Y, 3), mask)

    # This array will be sent over UART
    for index, pixel in enumerate(buffer.astype(np.uint16).reshape(-1, 3)[:, :]):
        R, G, B = pixel
        
        R = format(R, "08b")
        G = format(G, "08b")
        B = format(B, "08b")
        packed[index] = int(f"0{R[0:4]}{G[0:2]}00{G[2:4]}{B[0:4]}0", 2)

    byte_stream = packed.astype(np.uint16).tobytes()

    start = time.perf_counter()
    ComPort.write(byte_stream)

    print(f"Frame {frame_counter+1} sent in {round(time.perf_counter() - start, 2)}s")

if MODE == "camera":
    camera.close()

ComPort.close()
print("Done streaming")

if PLOT:
    plot_data = np.rot90(np.flipud(buffer.reshape(RES_X, RES_Y, -1)), 3, axes=(0, 1))
    fig, axis = plt.subplots(2, 2)

    axis[0, 0].imshow(plot_data[:, :, 0], cmap='Reds')
    axis[0, 1].imshow(plot_data[:, :, 1], cmap='Greens')
    axis[1, 0].imshow(plot_data[:, :, 2], cmap='Blues')
    axis[1, 1].imshow(plot_data)
    plt.tight_layout()
    plt.show()
