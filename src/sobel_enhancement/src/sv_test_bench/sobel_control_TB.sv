// ============================================================================
// TESTBENCH FOR SOBEL
// ============================================================================
`timescale 1ns / 1ns
`include "../verilog/sobel_control.svh" 
`include "../verilog/sobel_control.sv"
`include "../verilog/sobel_core.sv"

module sobel_control_TB ();
    reg  sobel_clk_i;
    reg  nreset_i;
    reg  prep_allowed_i;
    reg [`PIXEL_WIDTH-1:0] input_px_gray;
    reg [`ADDR_BITS-1:0] read_addr;
    wire  [`PIXEL_WIDTH-1:0] out_px_sobel; 
    wire  pixel_completed;   
    
    reg [`PIXEL_WIDTH-1: 0] image_memory [0: (`RAM_DEPTH-1) ];
    integer i,j;
    integer output_image;
      
    sobel_control uut(
        .clk_i(sobel_clk_i),
        .nreset_i(nreset_i),  
        .prep_allowed(prep_allowed_i),  
        .input_px_gray_i(input_px_gray),
        .output_px_sobel_o(out_px_sobel),
        .pixel_completed_o(pixel_completed),
        .read_addr_o(read_addr)
    );
    
    initial begin
        input_px_gray[1] = 'd0;
        input_px_gray[0] = 'd1;
        $readmemh(`INFILE, image_memory, 0, `RAM_DEPTH-1);
        output_image = $fopen("output_image_sobel.txt","w");
        sobel_clk_i = 0;
        prep_allowed_i = 0;
        nreset_i = 'b0;
        #30 nreset_i = 'b1;
    end

    always sobel_clk_i = #20 ~sobel_clk_i;
    
    always@(posedge sobel_clk_i or negedge nreset_i)begin
        prep_allowed_i = 1;
        for (i=0; i<`RAM_DEPTH; i=i+1)begin
            #60
            input_px_gray =  image_memory[i];
            #340
            $fwrite(output_image, "%x\n", out_px_sobel);
        end
    end   


    initial begin: TEST_CASE
        $dumpfile("sobel_control.vcd");
        $dumpvars(-1, uut);
        #30720050 $finish;
    end

endmodule
