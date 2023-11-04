TESTBENCH = sobel_gcd_unal
SRCS = $(TESTBENCH)_TB.sv 
SRC_FOLDER=/home/kevin/unal/OpenLane/designs/sobel_gcd_unal/src

all: simulate


link_src:
	find $(SRC_FOLDER) -name '*.v' -exec ln -s -f {} ';'
	find $(SRC_FOLDER) -name '*.sv' -exec ln -s -f {} ';'
	find $(SRC_FOLDER) -name '*.svh' -exec ln -s -f {} ';'



simulate: 
	iverilog -o $(TESTBENCH)_TB.vvp -g2012 $(SRC)
	vvp $(TESTBENCH)_TB.vvp
		
gtkwave: simulate
	gtkwave $(TESTBENCH).vcd


clean:
	rm -rf *.bin *.jpg *.txt *.blif *.out *.vvp *.vcd *~

.PHONY: all clean