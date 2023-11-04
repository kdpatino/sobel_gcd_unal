`include 
`include "async_nreset_synchronizer.sv"

module tt_um_sobel_gcd_unal (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    
    logic nreset_async_i;
    assign nreset_async_i = reset_n;

    logic clk_i;
    assign clk_i = clk;
    
    spi_dep_async_nreset_synchronizer adc_spi_nreset_sync0 (
        .clk_i(clk_i),
        .async_nreset_i(nreset_async_i),
        .tied_value_i(1'b1),
        .nreset_o(nreset_i)
    );
    
    gcd_top gcd0 (
        .operand_a_i(operand_a_i)
        ,.operand_b_i(operand_b_i)
        ,.gcd_enable_i(gcd_enable_i)
        ,.clk_i(clk_i)
        ,.nreset_i(nreset_i)
        ,.gcd_o(gcd_o)
        ,.gcd_done_o(gcd_done_o)
    );

    sobel_control sobel0 (
        .clk_i(clk_i)
        ,.nreset_i(nreset_i)

        ,.prep_allowed(prep_allowed)
        ,.input_px_gray_i(input_px_gray_i)

        ,.output_px_sobel_o(output_px_sobel_o)

        ,.pixel_completed_o(pixel_completed_o)
        ,.prep_completed_o(prep_completed_o)
    );

    sobel_gcd_spi spi0 (
        .clk_i(clk_i)
        ,.nreset_async_i(nreset_async_i)

        ,.spi_sck_i(spi_sck_i)
        ,.spi_sdi_i(spi_sdi_i)
        ,.spi_cs_i(spi_cs_i)
        ,.spi_sdo_o(spi_sdo_o)

        ,.operand_a_o(operand_a)
        ,.operand_b_o(operand_b)
        ,.gcd_enable_o(gcd_enable)
        ,.gcd_i(gcd_o)
        ,.gcd_done_i(gcd_done)

        ,.prep_allowed(prep_allowed)
        ,.input_px_gray_o(input_px_gray)

        ,.output_px_sobel_i(output_px_sobel)

        ,.pixel_completed_o(pixel_completed_o)
        ,.prep_completed_o(prep_completed_o)
    );

endmodule
