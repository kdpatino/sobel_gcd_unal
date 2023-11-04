`ifndef __CONSTANTS_GCD__
`define __CONSTANTS_GCD__

localparam DATA_WIDTH = 8;
typedef struct packed{
    logic signed [DATA_WIDTH-1:0] a;
    logic signed [DATA_WIDTH-1:0] b;
} gcd_data; 

`endif