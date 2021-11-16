import math
import numpy as np
import cv2
 

img = cv2.imread("example.jpg", cv2.IMREAD_COLOR)

for row in img:
    
    for i, el in enumerate(row):
        if 0.25*el[0] + 0.5*el[1] + 0.25*el[2] >130:
            
            row[i] = [255, 255, 255]
        else:
            row[i] = [0, 0, 0]
            
    #img[index] = [el[0], el[0], el[0]]
    
cv2.imshow("Cute Kitens", img)

cv2.waitKey(0)
    

original_img = img
new_h = 30
new_w = 40
	#get dimensions of original image
old_h, old_w, c = original_img.shape
#create an array of the desired shape. 
#We will fill-in the values later.
resized = np.zeros((new_h, new_w, c))

print(old_h, old_w)
#Calculate horizontal and vertical scaling factor
w_scale_factor = (old_w ) / (new_w ) 
h_scale_factor = (old_h ) / (new_h ) 

# w_scale_factor = 6 
# h_scale_factor = 6
print(w_scale_factor)
print(h_scale_factor)




for i in range(new_h):
    for j in range(new_w):
        #map the coordinates back to the original image
        x = i * h_scale_factor
        y = j * w_scale_factor
        #calculate the coordinate values for 4 surrounding pixels.
        # print("xy",x,y)
        x_floor = math.floor(x)
        x_ceil = min( old_h - 1, math.ceil(x))
        y_floor = math.floor(y) #smaller or equal to y so (y-y_floor) is positive or zero
        y_ceil = min(old_w - 1, math.ceil(y))
        
        # print(x_floor,x_ceil,y_floor,y_ceil)

        if (x_ceil == x_floor) and (y_ceil == y_floor):
            q = original_img[int(x), int(y), :]
        elif (x_ceil == x_floor):
            q1 = original_img[int(x), int(y_floor), :]
            q2 = original_img[int(x), int(y_ceil), :]
            q = q1 * (y_ceil - y) + q2 * (y - y_floor)
        elif (y_ceil == y_floor):
            q1 = original_img[int(x_floor), int(y), :]
            q2 = original_img[int(x_ceil), int(y), :]
            q = (q1 * (x_ceil - x)) + (q2	 * (x - x_floor))
        else:
            v1 = original_img[x_floor, y_floor, :]
            v2 = original_img[x_ceil, y_floor, :]
            v3 = original_img[x_floor, y_ceil, :]
            v4 = original_img[x_ceil, y_ceil, :]
            
            q1 = v1 * (x_ceil - x) + v2 * (x - x_floor)
            q2 = v3 * (x_ceil - x) + v4 * (x - x_floor)
            q = q1 * (y_ceil - y) + q2 * (y - y_floor)
    
            
        resized[i,j,:] = q
ans = resized.astype(np.uint8)

print(ans)
print(len(ans))
print(len(ans[0]))
print(ans[0])


# To read image from disk, we use
# cv2.imread function, in below method,

cv2.imshow("Cute Kitens", ans)

cv2.waitKey(0)










