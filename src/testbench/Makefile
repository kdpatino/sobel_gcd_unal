
SRC_FOLDER=/home/kevin/unal/OpenLane/designs/sobel_gcd_unal/src
TESTBENCH = sobel_gcd_unal

GCD_SRC=gcd_dp.sv \
		gcd_fsm.sv \
		gcd_top.sv

SOBEL_SRC=sobel_control.sv \
		  sobel_core.sv

SPI_SRC=adc_spi.sv\
		spi_dep.sv

TOP_SRC=async_nreset_synchronizer.sv \
		tt_um_sobel_gcd_unal.sv

SRC=$(GCD_SRC) \
	$(SOBEL_SRC) \
	$(SPI_SRC) \
	$(TOP_SRC) \
	$(TESTBENCH)_TB.sv 


all: simulate


link_src:
	find "$(SRC_FOLDER)" -type d -name 'testbench' -prune -o -type f -name '*.sv' -exec ln -s -f {} ';'
	find "$(SRC_FOLDER)" -type d -name 'testbench' -prune -o -type f -name '*.svh' -exec ln -s -f {} ';'

simulate: 
	iverilog -o $(TESTBENCH)_TB.vvp -g2012 $(SRC)
	vvp $(TESTBENCH)_TB.vvp
		
gtkwave: simulate
	gtkwave $(TESTBENCH).vcd


clean:
	rm -rf *.bin *.jpg *.txt *.blif *.out *.vvp *.vcd *~
	rm $(GCD_SRC) $(SOBEL_SRC) $(SPI_SRC) $(TOP_SRC) *.svh 

.PHONY: all clean