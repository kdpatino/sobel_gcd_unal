`timescale 1ns / 1ns

module sobel_gcd_unal_TB ();
    logic  clk_i;
    logic  nreset_i;

    parameter RPI_SPI_CLK = 66/2;
    parameter ADC_SPI_CLK = 50;

    parameter real DUTY_CYCLE = 0.5;

    parameter STREAM_DATA_WIDTH = 16;

    initial begin
        forever
        begin
            clk_i = 1'b0;
            #(ADC_SPI_CLK-(ADC_SPI_CLK*DUTY_CYCLE)) clk_i = 1'b1;
            #(ADC_SPI_CLK*DUTY_CYCLE);
        end
    end

    logic rpi_mosi;
    logic rpi_ss;
    logic rpi_sck;
    logic rpi_miso;


    logic [7:0] uio_in;  // IOs: Bidirectional Input path
    logic [7:0] uio_out;  // IOs: Bidirectional Output path

    logic gcd_en;
    logic sobel_allowed;
    logic sobel_en;
    
    assign uio_in[0] = rpi_sck;
    assign uio_in[1] = rpi_mosi;
    assign uio_in[2] = rpi_ss;
    assign uio_in[4] = gcd_en;
    
    assign uio_in[6] = sobel_allowed;
    assign uio_in[7] = sobel_en;
    
    logic output_ctl;


    tt_um_sobel_gcd_unal uut(
        .clk(clk_i),
        .rst_n(nreset_i),
        .uio_out(uio_out),
        .uio_in(uio_in),
        .ui_in({7'b0,output_ctl})
    );


    initial begin
        rpi_mosi = 0; rpi_ss = 1; rpi_sck = 1;
    end

    logic [15:0] data_tx_rpi;
    logic [15:0] data_rx_rpi;

    integer i;
    task automatic spi_transfer_pi;
        input [STREAM_DATA_WIDTH-1:0] data;
    begin
        #3 rpi_ss = 0;
        rpi_sck = 1;
        data_tx_rpi <= {data[7:0],data[15:8]};

        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;

        for(i=0; i<STREAM_DATA_WIDTH; i=i+1) begin
            rpi_sck = 0;
            rpi_mosi <= data_tx_rpi[STREAM_DATA_WIDTH-1-i];
            #RPI_SPI_CLK;
            rpi_sck = 1;
            data_rx_rpi <= {data_rx_rpi[STREAM_DATA_WIDTH-2:0],rpi_miso};
            #RPI_SPI_CLK;
        end

        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        rpi_ss = 1;
    end
    endtask

    initial begin
        $dumpfile("sobel_gcd_unal_TB.vcd");
        $dumpvars(-1, uut);
        #0 output_ctl = 1'b0;
        #0 gcd_en = 1'b0;
        #0 nreset_i = 1'b0;
        #0 sobel_en = 1'b0;
        #0 sobel_allowed = 1'b0;
        data_rx_rpi = '0;
        #200 @(negedge clk_i) nreset_i = 1'b1;
        #500 spi_transfer_pi(16'h2004); //Enable calibration
        #500 spi_transfer_pi(16'h0008); //Enable calibration
        #100 gcd_en = 1'b1;
        @(posedge uio_out[5]) #500 spi_transfer_pi(16'h0000);
        #1000 gcd_en = 1'b0;
        #0 nreset_i = 1'b0;
        #200 @(negedge clk_i) nreset_i = 1'b1;
        #500 spi_transfer_pi(16'h2044); //Enable calibration
        #500 spi_transfer_pi(16'h0088); //Enable calibration
        #100 gcd_en = 1'b1;
        @(posedge uio_out[5]) #500 spi_transfer_pi(16'h0000);

        #0 output_ctl = 1'b1;
        #0 sobel_allowed = 1'b1;
        #500 spi_transfer_pi({1'b1,15'hAAA0}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;
        
        #500 spi_transfer_pi({1'b1,15'hA0A1}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;

        #500 spi_transfer_pi({1'b1,15'hABAB}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;

        #500 spi_transfer_pi({1'b1,15'hAAAA}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;

        #500 spi_transfer_pi({1'b1,15'hAAAA}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;
        
        #500 spi_transfer_pi({1'b1,15'hAAAA}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;
        #500 spi_transfer_pi({1'b1,15'hAAAA}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;
        #500 spi_transfer_pi({1'b1,15'hAAAA}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;
        #500 spi_transfer_pi({1'b1,15'hAAAA}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;
        
        @(posedge uio_out[5])   
        spi_transfer_pi({1'b1,15'hAAA9}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;

        
        #500 spi_transfer_pi({1'b1,15'hAAAA}); //Enable calibration
        #0 sobel_en = 1'b1;
        #100 sobel_en = 1'b0;
        
        
        
        
        repeat(364000) @(posedge clk_i);
        $finish;
    end


endmodule