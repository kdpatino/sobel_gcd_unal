module spi_dep #(
    parameter WORD_SIZE = "mandatory"
)(
    input logic sck_i
    ,input logic sdi_i
    ,input logic cs_i
    ,output logic sdo_o
    ,input logic [WORD_SIZE-1:0] data_tx_i
    ,output logic [WORD_SIZE-1:0] data_rx_o
    ,output logic rxtx_done_o
);

    logic nreset_i;

    logic [WORD_SIZE-1:0] sdo_register;
    logic [$clog2(WORD_SIZE):0] counter;

    assign nreset_i = ~cs_i;
    assign sdo_o = sdo_register[WORD_SIZE-1];

    always_ff @(negedge sck_i or negedge nreset_i) begin
        if (!nreset_i)
            counter <= 0;
        else begin
                counter <= counter + 1;
        end
    end

    always @(posedge sck_i or negedge nreset_i) begin
        if (!nreset_i)
            data_rx_o <= 0;
        else begin
                data_rx_o <= {data_rx_o[WORD_SIZE-2:0],sdi_i};
        end
    end

    always @(negedge sck_i or negedge nreset_i) begin
        if (!nreset_i)
            sdo_register <= 0;
        else begin
            if(counter[$clog2(WORD_SIZE)-1:0] == '0)
                sdo_register <= data_tx_i;
            else
                sdo_register <= {sdo_register[WORD_SIZE-2:0],1'b0};
        end
    end

    always @(posedge sck_i or negedge nreset_i) begin
        if (!nreset_i)
           rxtx_done_o <= 0;
        else begin
            if(counter[$clog2(WORD_SIZE)] == 1'b1)
                rxtx_done_o <= 1'b1;
            else
                rxtx_done_o <= 1'b0;
        end
    end

endmodule
