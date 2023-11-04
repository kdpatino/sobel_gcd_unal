`include "sobel_enhancement/src/verilog/sobel_control.svh" 

module sobel_control (
        input logic    clk_i,
        input logic    nreset_i,

        input logic    prep_allowed,
        input logic    [PIXEL_WIDTH-1:0] input_px_gray_i,

        output logic   [PIXEL_WIDTH-1:0] output_px_sobel_o,

        output logic   pixel_completed_o,
        output logic   prep_completed_o
    );

    logic [SOBEL_COUNTER_MAX_BITS:0] counter_sobel;
    logic [HEIGHT_COUNTER_BITS-1:0] i_sobel;
    logic [WIDTH_COUNTER_BITS-1:0] j_sobel;
    logic pixel_completed;
    
    sobel_matrix sobel_pixels; // 15 bits width 9 pixel RAM 

    logic [PIXEL_WIDTH-1:0] out_sobel_core;
    logic [PIXEL_WIDTH-1:0]  out_sobel;
    logic prep_completed;


    typedef enum logic [1:0]{
        IDLE, 
        MATRIX_KERNEL, 
        NEXT_MATRIX,
        END_FRAME} state_t;

    state_t fsm_state, next;

    sobel_core sobel(
        .matrix_pixels_i(sobel_pixels),
        .out_sobel_core_o(out_sobel_core)
    );


    always_ff @(posedge clk_i or negedge nreset_i)begin
        if(!nreset_i)begin
            fsm_state <= IDLE;
        end else begin
            fsm_state <= next;
        end
    end

    always_comb begin
        case(fsm_state)
            IDLE: begin
                if(prep_allowed) next = MATRIX_KERNEL;
                else next = IDLE;
            end
            MATRIX_KERNEL: begin 
                if (counter_sobel <= 8) next = MATRIX_KERNEL; 
                else next = NEXT_MATRIX;
            end
            NEXT_MATRIX: begin
                if(j_sobel < IMAGE_WIDTH-3) next = MATRIX_KERNEL;
                else next = END_FRAME;
            end
            END_FRAME: begin
                if (prep_completed) next = IDLE; 
                next = END_FRAME;
            end
        endcase
    end

    always_ff @(posedge clk_i or negedge nreset_i)begin
        if (!nreset_i)begin
            counter_sobel <= 'b0;
            i_sobel <= 'b0;
            j_sobel <= 'b0;
            out_sobel <= 'b0;
            pixel_completed <= 'b0;
            prep_completed <= 'b0;
            sobel_pixels <= 'b0;
        end else begin
            case (next)
                IDLE: begin
                    out_sobel <= 'b0;
                    prep_completed <= 'b0;
                end
                MATRIX_KERNEL: begin
                    pixel_completed <= 'b0;
                    if (counter_sobel == 2 | counter_sobel == 5 | counter_sobel == 8)begin
				        j_sobel <= (i_sobel == IMAGE_HEIGHT-1 ? (j_sobel + 1) : j_sobel);
                        if (i_sobel < IMAGE_HEIGHT-1) begin
                            i_sobel <= (i_sobel+1);
                        end else begin
                            i_sobel = 0;
                        end
                    end

                    case(counter_sobel)
                        0: sobel_pixels.vector0.pix0 <= input_px_gray_i;
                        1: sobel_pixels.vector0.pix1 <= input_px_gray_i;
                        2: sobel_pixels.vector0.pix2 <= input_px_gray_i;
                        3: sobel_pixels.vector1.pix0 <= input_px_gray_i;
                        4: sobel_pixels.vector1.pix1 <= input_px_gray_i;
                        5: sobel_pixels.vector1.pix2 <= input_px_gray_i;
                        6: sobel_pixels.vector2.pix0 <= input_px_gray_i;
                        7: sobel_pixels.vector2.pix1 <= input_px_gray_i;
                        8: sobel_pixels.vector2.pix2 <= input_px_gray_i;
                    endcase
                    counter_sobel <= counter_sobel + 1;
                end
                NEXT_MATRIX: begin
                    counter_sobel <= 'b0;
                    pixel_completed <= 'b1;
                    i_sobel <= (i_sobel >= 2)? (i_sobel - 2) : i_sobel;
                    //out_sobel <= (out_sobel_core < SOBEL_THRESHOLD)? MIN_PX_VAL : MAX_PX_VAL-1;  //Binarization
                    out_sobel <= (out_sobel_core);
                    sobel_pixels <= 'b0;
                end
                END_FRAME: begin
                    i_sobel <= 'b0;
                    j_sobel <= 'b0;
                    prep_completed <= 'b1; 
                end
            endcase
        end
    end

    assign  output_px_sobel_o = out_sobel;
    assign  pixel_completed_o = pixel_completed; 
    assign  prep_completed_o = prep_completed; 

endmodule

