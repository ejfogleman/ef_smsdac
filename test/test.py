# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
  dut._log.info("Start")
  
  # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 1, units="us")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 10)
  dut.rst_n.value = 1

  # Set the input values, wait one clock cycle, and check the output

  # apply input of 112 (0x70) and check after 3, 4 cycles
  dut._log.info("Test")
  dut.ui_in.value = 112  # 0x70 just below midscale input
  dut.uio_in.value = 0

  await ClockCycles(dut.clk, 3)
  dut._log.info("Clock cycle 3") 
  dut._log.info(f"Input = {dut.ui_in.value}")
  dut._log.info(f"Output = {dut.uo_out.value}")
  # assert dut.uo_out.value == 63   # 0x3F on cycle 3

  await ClockCycles(dut.clk, 1)
  dut._log.info("Clock cycle 4") 
  dut._log.info(f"Input = {dut.ui_in.value}")
  dut._log.info(f"Output = {dut.uo_out.value}")

  # assert dut.uo_out.value == 84   # 0x54 on cycle 4


