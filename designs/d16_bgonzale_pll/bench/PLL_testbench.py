# test_my_design.py (simple)

import cocotb
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.clock import Clock

# this testbench lets you set the parameters for the PLL
# such as the input reference clock frequency, loop gain, and frequency step
# note that we assume operation at a 1 kHz global clock
# after runnning, you can inspect the resulting waveforms in GTKWave
@cocotb.test()
async def PLL_test(dut):
    # set PLL parameters
    global_clk = Clock(dut.i_sys_clk, 1, 'ms') # 1 kHz clock
    await cocotb.start(global_clk.start())

    # input reference clock signal
    ref_clk = Clock(dut.i_ref_clk, 100, 'ms') # 10 Hz clock
    await cocotb.start(ref_clk.start())

    dut.i_loop_gain.value = 2 # can toggle for different locking speeds
    dut.i_freq_step.value = 2 # initial guess for frequency step

    # reset DUT
    dut.i_rst.value = 1
    for _ in range(2):
        await RisingEdge(dut.i_sys_clk)
    dut.i_rst.value = 0

     # run the system clock for a while and examine outputs of PLL in gtkwave
     # it would be nice to log the outputs and visualize using Python
    for tick in range(5000):
        await RisingEdge(dut.i_sys_clk)
