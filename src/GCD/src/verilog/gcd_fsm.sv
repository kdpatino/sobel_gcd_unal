
`include "GCD/src/include/gcd.svh"

module gcd_fsm (
  input logic clk_i
  ,input logic nreset_i
  ,input logic gcd_enable_i
  ,input logic compare_zero_i
  ,input logic compute_enable_i
  ,output logic flag_init_o
  ,output logic flag_compute_o
  ,output logic flag_finish_o
);


  typedef enum logic [1:0]{
      S_INIT, //00
      S_COMPUTE, //01
      S_FINISH //10
  } state_e;

  state_e state, next_state;


  always_ff @(posedge clk_i or negedge nreset_i) begin 
    if(!nreset_i) 
    begin
        state <= S_INIT;
    end
    else if(gcd_enable_i) 
    begin 
        state <= next_state;
    end  
  end

  always_comb begin 
        case(state)
        S_INIT : begin
                if(compute_enable_i && gcd_enable_i) begin
                  next_state = S_COMPUTE; 
                end
                else if(compare_zero_i && gcd_enable_i) begin
                  next_state = S_FINISH;
                end
                else begin
                  next_state = S_INIT;
                end
        end        
        S_COMPUTE : begin
                if(compare_zero_i) begin
                  next_state = S_FINISH;
                end
                else
                begin 
                  next_state = S_COMPUTE;
                end

        end
        S_FINISH : next_state = S_FINISH;
        default : next_state = S_INIT;
        endcase
  end



always_ff @(posedge clk_i or negedge nreset_i) begin
    if(!nreset_i) begin
        flag_init_o <= 1'b1;
        flag_compute_o <= 1'b0;
        flag_finish_o <= 1'b0;
    end
    else begin 
      case(next_state)
      S_INIT: begin
        flag_init_o <= 1'b1;
        flag_compute_o <= 1'b0;
        flag_finish_o <= 1'b0;
      end
      S_COMPUTE: begin 
        flag_init_o <= 1'b0;
        flag_compute_o <= 1'b1;
        flag_finish_o <= 1'b0;
      end
      S_FINISH: begin 
        flag_init_o <= 1'b0;
        flag_compute_o <= 1'b0;
        flag_finish_o <= 1'b1;
      end
      endcase
    end 
end

endmodule
