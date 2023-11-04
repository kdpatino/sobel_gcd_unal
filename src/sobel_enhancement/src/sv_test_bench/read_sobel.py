import numpy as np
import cv2
from matplotlib import pyplot as plt
from matplotlib import image as mpimg


with open('output_image_sobel.txt', 'r') as f:
    out_hw_txt = f.read().splitlines() 

arr_out_hw = np.array(out_hw_txt)
arr_out_hw_317x240 = np.reshape(arr_out_hw, (320, 240))

arr_out_hw_317x240_int = np.zeros(shape=(240, 315))
for i in range(0,315):
    for x in range(0,240):
        arr_out_hw_317x240_int[x][i] = int(arr_out_hw_317x240[i][x], 16)

cv2.imwrite('sobel_verilog.jpg', arr_out_hw_317x240_int)
img_sobel_hw = cv2.imread('sobel_verilog.jpg', 0)

image = mpimg.imread("sobel_verilog.jpg")
plt.imshow(image, cmap='Greys_r')
plt.show()