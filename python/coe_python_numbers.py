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
white = (255, 255,255)

black_code = "0"
white_code = "1"


            
im = Image.open("10.png", 'r')         
for i in range(10,11):
    name = str(i) + ".png"
    name_output = str(i) + "_small.coe"
    im = Image.open(name, 'r')
    width, height = im.size

    print(width*height)#196608
    pixel_values = list(im.getdata())

    for i, pixel in enumerate(pixel_values):
        if pixel[0] >120: 
            pixel_values[i] = black
        else:
            pixel_values[i] = white
    with open(name_output, "w") as f:
        f.write(coe_hdr)
        for i in pixel_values:
            if i ==black:
                f.write(black_code + ",\n")
            elif i == white:
                f.write(white_code + ",\n")
            # elif i == blue:
            #     f.write(blue_code + ",\n")
            # else:
            #     f.write(black_code + ",\n")
            

        
        
