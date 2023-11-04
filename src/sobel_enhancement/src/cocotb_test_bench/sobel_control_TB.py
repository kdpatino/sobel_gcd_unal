from pathlib import Path
import cocotb
import cv2
import numpy as np
import time

from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, ReadOnly, RisingEdge
from cocotb.triggers import Timer
from matplotlib import pyplot as plt
from matplotlib import image as mpimg


# #-------------------------------Convert RGB image to grayscale------------------------------------------
img_original = cv2.imread('../../monarch_320x240.jpg') 
gray_opencv = cv2.cvtColor(img_original, cv2.COLOR_BGR2GRAY) 

px_array = []
for i in range(320): 
    for j in range(240):
        px_array.append(gray_opencv[j][i])
        

with open('monarch_320x240.txt', 'w') as f:
    for pixel in px_array:
        f.write(f"{pixel}\n")

#Store input grayscale input pixels
RAM_input_image = {}
with open('monarch_320x240.txt', 'r') as file_in:
    for i, line in enumerate(file_in):
        RAM_input_image[i] = line.strip()

    in_ram_address = []
    out_ram_address = []

    counter_sobel = 0
    j_sobel = 0
    i_sobel = 0
    while True:
        if(j_sobel < 317):
            if(counter_sobel <= 8):
                if (counter_sobel == 0 or counter_sobel == 3 or counter_sobel == 6):
                    read_addr = i_sobel + j_sobel*240
                    in_ram_address.append(read_addr)
                elif (counter_sobel == 1 or counter_sobel == 4 or counter_sobel == 7):
                    read_addr = i_sobel + (j_sobel*240) + 320
                    in_ram_address.append(read_addr)
                elif (counter_sobel == 2 or counter_sobel == 5 or counter_sobel == 8):
                    read_addr = i_sobel + j_sobel*240 + 640
                    in_ram_address.append(read_addr)
                    if(i_sobel == 239):
                        j_sobel = (j_sobel + 1) 
                    else:
                        j_sobel = j_sobel
                    i_sobel = (i_sobel+1)%240
                if(counter_sobel == 4):
                    out_ram_address.append(read_addr);		
                counter_sobel = counter_sobel + 1
            else:
                counter_sobel = 0
                if i_sobel >= 2: 
                    i_sobel = i_sobel - 2
                else:
                    i_sobel = i_sobel
        else:
            break

# #----------------------------------------cocotb test bench----------------------------------------------
# Reset
async def reset_dut(dut, duration_ns):
    dut.nreset_i.value = 0
    await Timer(duration_ns, units="ns")
    dut.nreset_i.value = 1
    dut.nreset_i._log.debug("Reset complete")

# Wait until output file is completely written
async def wait_file():
    Path('output_image_sobel.txt').exists()


@cocotb.test()
async def sobel_test_bench(dut):

    # Clock cycle
    clock = Clock(dut.clk_i, 40, units="ns") 
    cocotb.start_soon(clock.start(start_high=False))

    # Inital
    dut.prep_allowed.value = 0
    dut.input_px_gray_i.value = 0
    
    await reset_dut(dut, 30)
    dut.prep_allowed.value = 1
       

    await FallingEdge(dut.clk_i)

    #Store processed pixels
    RAM_output_image = [0]*76800

    # Test_bench
    pix_counter = 0
    while(not int(dut.prep_completed_o.value)): 
        for i in range(76800):
            dut.input_px_gray_i.value = int(RAM_input_image[in_ram_address[i]], 16)
            if i%9 == 0 and i > 0:
                if (pix_counter % 10000 == 0):
                    print('Processed pixels: ', pix_counter)
                await Timer(80, units='ns')
                out_sobel = dut.output_px_sobel_o.value
                try:
                    RAM_output_image[out_ram_address[pix_counter]] = out_sobel # Store processed pixels
                except:
                    pass
                pix_counter = pix_counter+1
            await FallingEdge(dut.clk_i)
 
    
    # Write output RAM into txt file
    with open('output_image_sobel.txt', 'w') as file_out:
        for pixel in RAM_output_image:
            file_out.write(format(int(str(pixel), 2), "x") + '\n')

    # ############### Read test bench output ####################
    await wait_file() # Wait until output file is completely written

    # read file
    with open('output_image_sobel.txt', 'r') as f: 
        out_hw_txt = f.read().splitlines() 

    # Arrange pixels
    arr_out_hw = np.array(out_hw_txt)
    arr_out_hw_317x240 = np.reshape(arr_out_hw, (320, 240))

    arr_out_hw_317x240_int = np.zeros(shape=(240, 320))
    for i in range(320):
        for x in range(240):
            arr_out_hw_317x240_int[x][i] = int(arr_out_hw_317x240[i][x], 16)

    # Output image
    cv2.imwrite('sobel_verilog.jpg', arr_out_hw_317x240_int)
    cv2.imread('sobel_verilog.jpg', 0)

    image = mpimg.imread("sobel_verilog.jpg")
    plt.imshow(image, cmap='Greys_r')
    plt.show()