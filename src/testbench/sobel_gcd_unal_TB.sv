`timescale 1ns / 1ns

module sobel_gcd_unal_TB ();
    logic  clk_i;
    logic  nreset_i;
    logic [7:0] uio_in_reg;
    logic [7:0] uio_out_reg;

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

    tt_um_sobel_gcd_unal uut(
        .clk(clk_i),
        .rst_n(nreset_i),
        .uio_in(uio_in_reg)
    );


    initial begin
        rpi_mosi = 0; rpi_ss = 1; rpi_sck = 1;
        //uio_in_reg[0] = 1;
        // uio_in_reg[1] = rpi_mosi;
        // uio_in_reg[2] = rpi_ss;
        uio_in_reg = 8'b0;
    end

    logic [15:0] data_tx_rpi;
    logic [15:0] data_rx_rpi;

    integer i;
    task automatic spi_transfer_pi;
        input [STREAM_DATA_WIDTH-1:0] data;
    begin
        #3 rpi_ss = 0;
        //uio_in_reg[2] = 0;
        rpi_sck = 1;
        //uio_in_reg[0] = rpi_sck;
        data_tx_rpi <= {data[7:0],data[15:8]};

        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;
        #RPI_SPI_CLK;

        for(i=0; i<STREAM_DATA_WIDTH; i=i+1) begin
            rpi_sck = 0;
            //uio_in_reg[0] = rpi_sck; 
            rpi_mosi <= data_tx_rpi[STREAM_DATA_WIDTH-1-i];
            uio_in_reg[1] = rpi_mosi;
            #RPI_SPI_CLK;
            rpi_sck = 1;
            //uio_in_reg[0] = rpi_sck;
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
        //uio_in_reg[2] = rpi_ss;
    end
    endtask


    initial begin
        #0 nreset_i = 1'b0;
        data_rx_rpi = '0;
        #200 @(negedge clk_i) nreset_i = 1'b1;
        // #500 spi_transfer_pi(16'h1201); //Enable calibration
        // #500 spi_transfer_pi(16'h1200); //Disable Calibration
        // #500 spi_transfer_pi(16'h1307); //Set channel count 8
        // #500 spi_transfer_pi(16'h1300); //Set channel count 0
        // #500 spi_transfer_pi(16'h1101); //Disable ADC
        // #500 spi_transfer_pi(16'h1001); //Enable ADC
        repeat(364000) @(posedge clk_i);
        $finish;
    end


endmodule