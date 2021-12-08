#!/bin/python
import numpy as np
from scipy.misc import  imshow
from scipy import ndimage
import imageio
 
def GetBilinearPixel(imArr, posX, posY):
	out = []
 
	#Get integer and fractional parts of numbers
	modXi = int(posX)
	modYi = int(posY)
	modXf = posX - modXi
	modYf = posY - modYi
	modXiPlusOneLim = min(modXi+1,imArr.shape[1]-1)
	modYiPlusOneLim = min(modYi+1,imArr.shape[0]-1)
 
	#Get pixels in four corners
	for chan in range(imArr.shape[2]):
		bl = imArr[modYi, modXi, chan]
		br = imArr[modYi, modXiPlusOneLim, chan]
		tl = imArr[modYiPlusOneLim, modXi, chan]
		tr = imArr[modYiPlusOneLim, modXiPlusOneLim, chan]
 
		#Calculate interpolation
		b = modXf * br + (1. - modXf) * bl
		t = modXf * tr + (1. - modXf) * tl
		pxf = modYf * t + (1. - modYf) * b
		out.append(int(pxf+0.5))
 
	return out


# import cv2

# #read image
# img_grey = cv2.imread('test_image_dog.png', cv2.IMREAD_GRAYSCALE)

# # define a threshold, 128 is the middle of black and white in grey scale
# thresh = 128

# # threshold the image
# img_binary = cv2.threshold(img_grey, thresh, 255, cv2.THRESH_BINARY)[1]

# #save image
# cv2.imwrite('black-and-white.png',img_binary)
 
if __name__=="__main__":
 
	im = imageio.imread("black-and-white.png")
	enlargedShape = list(map(int, [im.shape[0]*1.6, im.shape[1]*1.6, im.shape[2]]))
	enlargedImg = np.empty(enlargedShape, dtype=np.uint8)
	rowScale = float(im.shape[0]) / float(enlargedImg.shape[0])
	colScale = float(im.shape[1]) / float(enlargedImg.shape[1])
 
	for r in range(enlargedImg.shape[0]):
		for c in range(enlargedImg.shape[1]):
			orir = r * rowScale #Find position in original image
			oric = c * colScale
			enlargedImg[r, c] = GetBilinearPixel(im, oric, orir)
 
	imshow(enlargedImg)