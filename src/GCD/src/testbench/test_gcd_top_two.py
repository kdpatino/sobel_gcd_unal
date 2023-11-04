
# test_my_design.py (extended)

import cocotb
from cocotb.triggers import FallingEdge, Timer, RisingEdge
from random import randint
import math

async def generate_clock(dut):
    for cycle in range(5000):
        dut.clk_i.value = 0
        await Timer(1, units="ns")
        dut.clk_i.value = 1
        await Timer(1, units="ns")


@cocotb.test()
async def my_second_test(dut):
    #Try accessing the design.

    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
    
    for i in range(100):
        #se coloca en decimal el valor
        opa = randint(1,255)
        opb = randint(1,255)
      
        dut.operand_a_i.value = opa
        dut.operand_b_i.value = opb

        dut.gcd_enable_i.value = 1
        dut.nreset_i.value = 0

        #await Timer(5, units="ns")  # wait a bit
        await RisingEdge(dut.clk_i)  # wait for falling edge/"negedge"
        
        dut.nreset_i.value = 1

        dut._log.info("nreset_i is %s: ", dut.nreset_i.value)
        dut._log.info("operand_a %s: ", dut.operand_a_i.value)
        dut._log.info("operand_b %s: ", dut.operand_b_i.value)
        
        await RisingEdge(dut.gcd_done_o)  # wait for falling edge/"negedge"
        result = dut.gcd_o
        await FallingEdge(dut.clk_i) 

        golden = math.gcd(opa,opb)
        print(golden,result)
        assert golden == result


     