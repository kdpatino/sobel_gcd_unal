
# test_my_design.py (extended)

import cocotb
from cocotb.triggers import FallingEdge, Timer


async def generate_clock(dut):
    #Generate clock pulses.

    for cycle in range(30):
        dut.clk_i.value = 0
        await Timer(1, units="ns")
        dut.clk_i.value = 1
        await Timer(1, units="ns")


@cocotb.test()
async def my_second_test(dut):
    #Try accessing the design.

    await cocotb.start(generate_clock(dut))  # run the clock "in the background"
        
    await Timer(5, units="ns")  # wait a bit
    
    dut.gcd_enable.value = 0;
    dut.nreset_i.value = 1;
    dut.compute_enable.value = 0;
    dut.compare_zero.value = 0;

    dut._log.info("next_state is %s: ", dut.next_state.value)


    await Timer(3, units="ns")

    dut.gcd_enable.value = 1;
    dut.nreset_i.value = 1;
    dut.compute_enable.value = 0;
    dut.compare_zero.value = 0;

    dut._log.info("next_state is %s: ", dut.next_state.value)
    dut._log.info("state is %s: ", dut.state.value)

    await Timer(3, units="ns")


    dut.gcd_enable.value = 0;
    dut.nreset_i.value = 1;
    dut.compute_enable.value = 0;
    dut.compare_zero.value = 0;

    dut._log.info("next_state is %s: ", dut.next_state.value)
    dut._log.info("state is %s: ", dut.state.value)

    await Timer(3, units="ns")

    dut.gcd_enable.value = 0;
    dut.nreset_i.value = 1;
    dut.compute_enable.value = 1;
    dut.compare_zero.value = 0;

    dut._log.info("next_state is %s: ", dut.next_state.value)
    dut._log.info("state is %s: ", dut.state.value)

    await Timer(3, units="ns")
    

    dut.gcd_enable.value = 0;
    dut.nreset_i.value = 1;
    dut.compute_enable.value = 0;
    dut.compare_zero.value = 1;

    dut._log.info("next_state is %s: ", dut.next_state.value)
    dut._log.info("state is %s: ", dut.state.value)

    await Timer(3, units="ns")


    dut.gcd_enable.value = 0;
    dut.nreset_i.value = 1;
    dut.compute_enable.value = 1;
    dut.compare_zero.value = 0;

    dut._log.info("next_state is %s: ", dut.next_state.value)
    dut._log.info("state is %s: ", dut.state.value)

    await Timer(3, units="ns")



    dut.gcd_enable.value = 1;
    dut.nreset_i.value = 0;
    dut.compute_enable.value = 0;
    dut.compare_zero.value = 1;

    dut._log.info("next_state is %s: ", dut.next_state.value)
    dut._log.info("state is %s: ", dut.state.value)

    await Timer(3, units="ns")

