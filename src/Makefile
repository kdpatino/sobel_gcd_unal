TESTBENCH = sobel_gcd_unal
SRCS = $(TESTBENCH)_TB.sv 

all: simulate

simulate: 
	iverilog -o $(TESTBENCH)_TB.vvp -g2009 $(SRCS)
	vvp $(TESTBENCH)_TB.vvp
		
gtkwave: simulate
	gtkwave $(TESTBENCH).vcd


clean:
	rm -rf *.bin *.jpg *.txt *.blif *.out *.vvp *.vcd *~

.PHONY: all clean