import cv2  #import opencv library
import numpy as np

f = open("sample.txt",'w')
img = cv2.imread('monarch_320x240.jpg') 
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) 

sobelx = cv2.Sobel(gray,cv2.CV_64F,1,0,ksize=3)     #x-axis sobel operator 
sobely = cv2.Sobel(gray,cv2.CV_64F,0,1,ksize=3)     #y-axis sobel operator
abs_grad_x = cv2.convertScaleAbs(sobelx)            
abs_grad_y = cv2.convertScaleAbs(sobely)            
grad = abs_grad_x + abs_grad_y
print(len(sobelx))

weight = 0.5
grad = cv2.addWeighted(abs_grad_x, weight, abs_grad_y, weight, 0)

grad1 = np.zeros(shape=(240, 315))
for i in range(0,240):
    for x in range(0,315):
        print
        if(grad[i][x] < 150):
            grad1[i][x] = 0
        else:
            grad1[i][x] = 255
cv2.imwrite('sobel_openCV.jpg', grad1)
img_sobel_sw = cv2.imread('sobel_openCV.jpg', 0)

cv2.imshow("rgb", img)  #Show the real img
cv2.imshow("gray",gray) #Show the grayscale img
cv2.imshow("sobel",img_sobel_sw)#Show the result img
cv2.waitKey(0)          #Stop the img to see it