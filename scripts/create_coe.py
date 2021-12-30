import numpy as np

from mapping import lookup
from data import data

# Read the lookup files created using downscale.m
image = lookup[data]
image = image.astype(np.uint16).reshape(240, 320, 3)

# Pack the bits as per specifications in the report
# This is just another way to do it
packed = np.bitwise_or(np.bitwise_or(
    np.left_shift(image[:, :, 0], 6),
    np.left_shift(image[:, :, 1], 2)),
    np.right_shift(image[:, :, 2], 2)
)

# Zero pad the data
packed = np.right_shift(packed, 2)
packed = packed.reshape(-1)

# print(format(packed[0], "012b"), image[0, 0, :])

# Write to the coefficient file
with open("data.coe", "w") as outFile:
    outFile.write("memory_initialization_radix=2;\n")
    outFile.write("memory_initialization_vector=\n")

    for item in packed:
        outFile.write(format(item, "012b")+",\n")