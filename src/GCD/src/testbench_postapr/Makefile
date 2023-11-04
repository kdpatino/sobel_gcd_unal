# Makefile

# defaults #simulador a usar icarus, #lenguaje verilog
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
COCOTB_HDL_TIMEUNIT = "1ns"
COCOTB_HDL_TIMEPRECISION = "10ps"


#Test the fsm:
VERILOG_SOURCES += /home/kevin/unal/OpenLane/designs/GCD/runs/RUN_2023.11.03_13.56.17/results/final/verilog/gl/gcd_top.v
VERILOG_SOURCES += /home/kevin/.volare/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = gcd_top

# MODULE is the basename of the Python test file
MODULE = test_gcd_top_two

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
