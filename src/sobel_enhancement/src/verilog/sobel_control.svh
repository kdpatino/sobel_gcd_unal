`ifndef __CONSTANTS_SOBEL__
`define __CONSTANTS_SOBEL__

localparam IMAGE_WIDTH = 320;
localparam IMAGE_HEIGHT = 240;
localparam WIDTH_COUNTER_BITS = $clog2(IMAGE_WIDTH);
localparam HEIGHT_COUNTER_BITS = $clog2(IMAGE_HEIGHT);
localparam PIXEL_WIDTH = 15;
localparam SOBEL_COUNTER_MAX_BITS = 3;                           //Counter for 3x3 matrix of pixels to convolve with kernel
localparam RAM_DEPTH  = 76800;              //RAM depth is the amount of pixels from selected resolution
localparam ADDR_BITS = $clog2(RAM_DEPTH);                       //Amount of bits necesary to represent a address in RAM depth
localparam MAX_GRADIENT_WIDTH = $clog2((1 << PIXEL_WIDTH)*3); //Max value of gradient could be a sum of three max values of 2^(PIXEL WIDTH) bits
localparam SOBEL_THRESHOLD = 200;
localparam MIN_PX_VAL = 0  ;                                      //Binarization min value
localparam MAX_PX_VAL = 1<< PIXEL_WIDTH   ;                  //Binarization max value
localparam INFILE  ="monarch_320x240.txt";


    typedef struct packed {
        logic signed [PIXEL_WIDTH-1:0] pix0;
        logic signed [PIXEL_WIDTH-1:0] pix1;
        logic signed [PIXEL_WIDTH-1:0] pix2;
    } sobel_vector;
    

    typedef struct packed {
        sobel_vector vector0;
        sobel_vector vector1;
        sobel_vector vector2;
    } sobel_matrix;

`endif