
# test_my_design.py (extended)

import cocotb
from cocotb.triggers import FallingEdge, Timer, RisingEdge


async def generate_clock(dut):
    for cycle in range(40):
        dut.clk_i.value = 0
        await Timer(1, units="ns")
        dut.clk_i.value = 1
        await Timer(1, units="ns")


@cocotb.test()
async def my_second_test(dut):
    #Try accessing the design.

    await cocotb.start(generate_clock(dut))  # run the clock "in the background"

    dut.gcd_enable_i.value = 1;
    dut.operand_a_i.value = 60;
    dut.operand_b_i.value = 48;
    dut.nreset_i.value = 0;

    await Timer(5, units="ns")  # wait a bit
    await RisingEdge(dut.clk_i)  # wait for falling edge/"negedge"
    
    dut.nreset_i.value = 1;

    dut._log.info("nreset_i is %s: ", dut.nreset_i.value)
    dut._log.info("operand_a %s: ", dut.operand_a_i.value)
    dut._log.info("operand_b %s: ", dut.operand_b_i.value)

    for algo in range(30):
        #if(FallingEdge(dut.clk_i)):
        dut._log.info("gcd_o  %s: ", dut.gcd_o.value)
        await Timer(1, units="ns")

