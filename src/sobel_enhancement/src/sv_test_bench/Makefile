TESTBENCH = sobel_control
SRCS = $(TESTBENCH)_TB.sv 
GEN_GRAY = generate_gray.py
READ_OUTPUT = read_sobel.py

all: simulate

simulate: 
	python3 $(GEN_GRAY)
	sleep 2
	iverilog -o $(TESTBENCH)_TB.vvp -g2009 $(SRCS)
	vvp $(TESTBENCH)_TB.vvp
	python3 $(READ_OUTPUT)
	
gtkwave: simulate
	gtkwave $(TESTBENCH).vcd


clean:
	rm -rf *.bin *.jpg *.txt *.blif *.out *.vvp *.vcd *~

.PHONY: all clean