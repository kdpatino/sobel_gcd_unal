 
`include "../include/gcd.svh"

module gcd_dp (
  input logic [DATA_WIDTH-1:0] operand_a_i
  ,input logic [DATA_WIDTH-1:0] operand_b_i
  ,input logic clk_i
  ,input logic nreset_i
  ,input logic gcd_enable_i
  ,input logic flag_init_i
  ,input logic flag_compute_i
  ,input logic flag_finish_i
  ,output logic compute_enable_o
  ,output logic compare_zero_o
  ,output logic [DATA_WIDTH-1:0] gcd_o
  ,output logic gcd_done_o
);
  
  gcd_data gcd_inputs;
  gcd_data gcd_inputs_temp;

  logic signed [DATA_WIDTH:0] sub;
  logic signed [DATA_WIDTH-1:0] gcd_o_temp;
  
  logic compare_zero_temp;

  logic [1:0] complex_sel_a;
  logic [1:0] complex_sel_b;

  assign complex_sel_a[1] = !sub[DATA_WIDTH] && flag_compute_i;
  assign complex_sel_a[0] = flag_init_i && gcd_enable_i; 

  assign complex_sel_b[1] = sub[DATA_WIDTH] && flag_compute_i;
  assign complex_sel_b[0] = flag_init_i && gcd_enable_i; 

  //MUXA
  always_comb begin
    case(complex_sel_a)
      2'b00: gcd_inputs_temp.a = gcd_inputs.a;
      2'b10: gcd_inputs_temp.a = gcd_o_temp;
      default : gcd_inputs_temp.a = operand_a_i;
    endcase
  end

  //MUXB
  always_comb begin
    case(complex_sel_b)
      2'b00: gcd_inputs_temp.b = gcd_inputs.b;
      2'b10: gcd_inputs_temp.b = gcd_o_temp;
      default: gcd_inputs_temp.b = operand_b_i;
    endcase
  end

  always_ff @(posedge clk_i or negedge nreset_i) begin
      if(!nreset_i) begin 
        gcd_inputs.a <= '0;
        gcd_inputs.b <= '0;
      end
      else begin
        gcd_inputs.a <= gcd_inputs_temp.a;
        gcd_inputs.b <= gcd_inputs_temp.b;
      end
  end

  assign compare_zero_temp = ((gcd_inputs_temp.a == '0) | (gcd_inputs_temp.b == '0) ) ;
  assign sub = gcd_inputs.a - gcd_inputs.b;
  assign  compare_zero_o = compare_zero_temp;
  assign  compute_enable_o = !(compare_zero_temp) && gcd_enable_i;

  assign  gcd_o_temp = sub[DATA_WIDTH] ? ((~sub) + 1) : sub;
 
  always @(posedge clk_i or negedge nreset_i) begin 
      if(!nreset_i) begin
        gcd_o <= '0; 
        gcd_done_o <= '0;
      end
      else if(flag_finish_i) //if state is finish
      begin
        gcd_o <= operand_a_i== '0 ? gcd_inputs.a : gcd_inputs.b;
        gcd_done_o <= 1;
      end 
  end


endmodule
