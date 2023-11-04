`include "GCD/src/include/gcd.svh"

module gcd_top (
  input logic [DATA_WIDTH-1:0] operand_a_i 
  ,input logic [DATA_WIDTH-1:0] operand_b_i
  ,input logic gcd_enable_i
  ,input logic clk_i
  ,input logic nreset_i
  ,output logic [DATA_WIDTH-1:0] gcd_o
  ,output logic gcd_done_o
);

logic compute_enable_io;
logic compare_zero_io;

logic flag_init_io;
logic flag_compute_io;
logic flag_finish_io;


gcd_dp dp1 (.operand_a_i(operand_a_i), 
                                       .operand_b_i(operand_b_i), 
                                       .clk_i(clk_i), 
                                       .nreset_i(nreset_i),
                                       .gcd_enable_i(gcd_enable_i), 
                                       .flag_init_i(flag_init_io),
                                       .flag_compute_i(flag_compute_io),
                                       .flag_finish_i(flag_finish_io),
                                       .compute_enable_o(compute_enable_io), 
                                       .compare_zero_o(compare_zero_io), 
                                       .gcd_o(gcd_o),
                                       .gcd_done_o(gcd_done_o));

gcd_fsm fsm1 (.clk_i(clk_i), 
              .nreset_i(nreset_i), 
              .gcd_enable_i(gcd_enable_i), 
              .compare_zero_i(compare_zero_io), 
              .compute_enable_i(compute_enable_io), 
              .flag_init_o(flag_init_io),
              .flag_compute_o(flag_compute_io),
              .flag_finish_o(flag_finish_io) );

endmodule