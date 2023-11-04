import cv2

img_original = cv2.imread('../../monarch_320x240.jpg') 
gray_opencv = cv2.cvtColor(img_original, cv2.COLOR_BGR2GRAY) 

px_array = []
for i in range(0,320): 
    for j in range(0,240):
        px_array.append(gray_opencv[j][i])

with open('monarch_320x240.txt', 'w') as f:
    for pixel in px_array:
        f.write(f"{pixel}\n")

