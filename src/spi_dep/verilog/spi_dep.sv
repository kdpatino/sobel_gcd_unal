`include "../../sobel_enhancement/src/verilog/sobel_control.svh"  //Maybe need to chnage this
`include "../../GCD/src/include/sobel_control.svh"  //Maybe need to chnage this

module sobel_gcd_spi #(
    parameter STREAM_DATA_WIDTH = 16
)(
    input logic clk_i
    ,input logic nreset_async_i

    //SPI interface
    ,input logic spi_sck_i
    ,input logic spi_sdi_i
    ,input logic spi_cs_i
    ,output logic spi_sdo_o

    //GCD Interface
    ,output logic [DATA_WIDTH-1:0] operand_a_o 
    ,output logic [DATA_WIDTH-1:0] operand_b_o
    ,input logic [DATA_WIDTH-1:0] gcd_o

    //Sobel Interface
    ,output logic    [PIXEL_WIDTH-1:0] input_px_gray_o
    ,input logic   [PIXEL_WIDTH-1:0] output_px_sobel_i
);
    // nreset synchronization
    logic nreset_i;
    logic [STREAM_DATA_WIDTH-1:0] spi_data_rx;


    logic [STREAM_DATA_WIDTH-1:0] data_rx;
    logic [STREAM_DATA_WIDTH-1:0] data_tx; 

    logic data_tx_sel;

    logic data_rdy;
    logic spi_rxtx_done;
    logic rxtx_done;
    logic rxtx_done_reg;
    logic ncs_signal;

    spi_dep_signal_synchronizer signal_sync1 (
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .async_signal_i(spi_rxtx_done),
        .signal_o(rxtx_done)
    );

    spi_dep_signal_synchronizer signal_sync2 (
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .async_signal_i(~spi_cs_i),
        .signal_o(ncs_signal)
    );

    typedef enum logic [1:0] {
        S_IDLE,
        S_TXRX_INIT,
        S_TXRX
    } state_e;

    state_e state, next_state;
    logic txrx_active;

    always_ff @(posedge clk_i or negedge nreset_i) begin
        if (!nreset_i)
            state <= S_IDLE;
		else
            state <= next_state;
	end

    always_comb begin
        case(state)
            S_IDLE: begin
                if(ncs_signal)
                    next_state = S_TXRX_INIT;
                else
                    next_state = S_IDLE;
            end
            S_TXRX_INIT: begin
                if(rxtx_done)
                    next_state = S_TXRX;
                else
                    next_state = S_TXRX_INIT;
            end
            S_TXRX: begin
                if(~ncs_signal)
                    next_state = S_IDLE;
                else
                    next_state = S_TXRX;
            end
            default:
                next_state = S_IDLE;
        endcase
    end

    always_ff @(posedge clk_i or negedge nreset_i) begin
        if(!nreset_i) begin
            txrx_active <= 1'b0;
        end else begin
            case(next_state)
                S_IDLE: begin
                    txrx_active <= 1'b0;
                end
                S_TXRX_INIT: begin
                    txrx_active <= 1'b1;
                end
                S_TXRX: begin
                    txrx_active <= 1'b0;
                end
                default : begin
                    txrx_active <= 1'b0;
                end
            endcase
        end
    end


    logic rxtx_done_rising;
    assign rxtx_done_rising = rxtx_done & ~rxtx_done_reg;

    always_ff @(posedge clk_i or negedge nreset_i) begin
        if(!nreset_i) begin
            rxtx_done_reg <= '0;
            data_rx <= '0;
        end else begin
            rxtx_done_reg <= rxtx_done;
            if(rxtx_done_rising)
                data_rx <= spi_data_rx;
            else
                data_rx <= data_rx;
        end
    end


    // SPI Slave Core
    spi_dep #(
        .WORD_SIZE(STREAM_DATA_WIDTH)
    ) spi0 (
        .sck_i(spi_sck_i)
        ,.sdi_i(spi_sdi_i)
        ,.cs_i(spi_cs_i)
        ,.sdo_o(spi_sdo_o)

        ,.data_tx_i({data_tx[7:0], data_tx[15:8]})
        ,.data_rx_o({spi_data_rx[7:0], spi_data_rx[15:8]})
        ,.rxtx_done_o(spi_rxtx_done)
    );


    assign data_tx = data_tx_sel ? {1'b0,output_px_sobel_i} : {8'b0,gcd_o};
    //Internal Memory Map
    always_ff @(posedge clk_i or negedge nreset_i) begin
        if(!nreset_i) begin
            operand_a_o <= '0;
            operand_b_o <= '0;
            input_px_gray_o <= '0;
            data_tx_sel <= '0;
        end else begin
            if (data_rx[15]) begin
                input_px_gray_o <= data_rx[PIXEL_WIDTH-1:0];
                data_tx_sel <= 1'b1;
            end
            else begin
                data_tx_sel <= '0;
                case(data_rx[14:13])
                2'b00: operand_a_o <= data_rx[DATA_WIDTH-1:0];
                2'b01: operand_b_o <= data_rx[DATA_WIDTH-1:0];
                default: begin
                    operand_a_o <= operand_a_o;
                    operand_b_o <= operand_b_o;
                end
                endcase
            end
        end
    end

endmodule