`timescale 1ns / 1ns
`include "sobel_enhancement/src/verilog/sobel_control.svh" 
`include "sobel_enhancement/src/verilog/sobel_control.sv"
`include "sobel_enhancement/src/verilog/sobel_core.sv"

`include "GCD/src/verilog/gcd_dp.sv" 
`include "GCD/src/verilog/gcd_fsm.sv"
`include "GCD/src/verilog/gcd_top.sv"
`include "GCD/src/include/gcd.svh"

`include "spi_dep/verilog/spi_dep.sv"
`include "spi_dep/verilog/adc_spi.sv"

`include "tt_um_sobel_gcd_unal.sv"


module sobel_gcd_unal_TB ();
    logic  clk_i;
    logic  nreset_i;

    tt_um_sobel_gcd_unal uut(
        .clk_i(sobel_clk_i),
        .nreset_i(nreset_i) 
    );

    initial begin
        clk_i = 'b0;
        nreset_i = 'b0;
        #30 nreset_i = 'b1;
    end

    always clk_i = #20 ~clk_i;
    
    initial begin: TEST_CASE
        $dumpfile("sobel_gcd_unal_TB.vcd");
        $dumpvars(-1, uut);
        #30720050 $finish;
    end

endmodule