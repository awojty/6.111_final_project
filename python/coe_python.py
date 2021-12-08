import sys
from PIL import Image
import math
import numpy as np
import cv2

coe_hdr = '''memory_initialization_radix=2;
memory_initialization_vector=
'''
red = (255, 0, 0)
green = (0, 255,0)
blue = (0, 0,255)
black = (0, 0,0)

black_code = "00"
red_code ="01"
blue_code ="10"
green_code ="11"

im = Image.open('IDLE.png', 'r')
width, height = im.size

print(width*height)#196608
pixel_values = list(im.getdata())

for i, pixel in enumerate(pixel_values):
    if pixel[0] >120: 
        pixel_values[i] = red
    elif pixel[1] >120:
        pixel_values[i] = green
    elif pixel[2] >120:
        pixel_values[i] = blue
    else:
        pixel_values[i] = black
        
        
with open("IDLE_color_map.coe", "w") as f:
    f.write(coe_hdr)
    for i in pixel_values:
        if i ==red:
            f.write(red_code + ",\n")
        elif i == green:
            f.write(green_code + ",\n")
        elif i == blue:
            f.write(blue_code + ",\n")
        else:
            f.write(black_code + ",\n")
            
 