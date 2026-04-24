# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # The RNG should output different values on successive clock cycles
    previous_output = dut.uo_out.value
    
    for i in range(5):
        await ClockCycles(dut.clk, 1)
        current_output = dut.uo_out.value
        dut._log.info(f"Clock cycle {i+1}: output = {current_output}")
        # LFSR should generate different values (with very high probability)
        assert current_output != previous_output or i == 0, f"Output should change, got same value twice"
        previous_output = current_output

    dut._log.info("RNG test passed!")
    cocotb.pass_test()
