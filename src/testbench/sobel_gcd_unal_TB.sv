`timescale 1ns / 1ns

module sobel_gcd_unal_TB ();
    logic  clk_i;
    logic  nreset_i;

    tt_um_sobel_gcd_unal uut(
        .clk(sobel_clk_i),
        .rst_n(nreset_i) 
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