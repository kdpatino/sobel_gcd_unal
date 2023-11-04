# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
COCOTB_HDL_TIMEUNIT = "1ns"
COCOTB_HDL_TIMEPRECISION = "10ps"

PWD=$(shell pwd)

VERILOG_SOURCES += $(PWD)/../verilog/sobel_control.svh
VERILOG_SOURCES += $(PWD)/../verilog/sobel_control.sv
VERILOG_SOURCES += $(PWD)/../verilog/sobel_core.sv

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = sobel_control

# MODULE is the basename of the Python test file
MODULE = sobel_control_TB

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

clean_output:
	rm -rf  *.jpg *.txt *~


