`include "sobel_control.svh" 

module sobel_core (
    input sobel_matrix matrix_pixels_i,
    output [PIXEL_WIDTH-1:0] out_sobel_core_o                           
);

logic signed [MAX_GRADIENT_WIDTH:0] x_grad; //No substraction of 1 because gradient is signed, so size is MAX_GRADIENT_WIDTH + 1
logic signed [MAX_GRADIENT_WIDTH:0] y_grad;                                     
logic signed [MAX_GRADIENT_WIDTH:0] abs_x_grad;
logic signed [MAX_GRADIENT_WIDTH:0] abs_y_grad;                
logic [MAX_GRADIENT_WIDTH:0] sum_xy_grad;                                      

//Equivalent to convolve 3x3 pixel matrix with sobel 3x3 X kernel
assign x_grad = ((matrix_pixels_i.vector0.pix2 - matrix_pixels_i.vector0.pix0) + ((matrix_pixels_i.vector1.pix2 - matrix_pixels_i.vector1.pix0) << 1) + 
                (matrix_pixels_i.vector2.pix2 - matrix_pixels_i.vector2.pix0));
//Equivalent to convolve 3x3 pixel matrix with sobel 3x3 Y kernel    
assign y_grad = ((matrix_pixels_i.vector0.pix0 - matrix_pixels_i.vector2.pix0) + ((matrix_pixels_i.vector0.pix1 - matrix_pixels_i.vector2.pix1) << 1) + 
                (matrix_pixels_i.vector0.pix2 - matrix_pixels_i.vector2.pix2));  

//Equivalent aprox to calculate magnitud of x,y gradient
assign abs_x_grad = (x_grad[MAX_GRADIENT_WIDTH]? ~x_grad+1 : x_grad);  //Absolute value    
assign abs_y_grad = (y_grad[MAX_GRADIENT_WIDTH]? ~y_grad+1 : y_grad);          
assign sum_xy_grad = (abs_x_grad + abs_y_grad);    

assign out_sobel_core_o = (|sum_xy_grad[MAX_GRADIENT_WIDTH:PIXEL_WIDTH])? 'h7FFF : sum_xy_grad[PIXEL_WIDTH-1:0];  //Overflow

endmodule