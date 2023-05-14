import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


instructionslist = [2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
datalist = [0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,2,0,5,2,11,5,1,0,3,11,11,0,15,15,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

@cocotb.test()
async def test_7seg(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut._log.info("reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 1)
    dut.rst.value = 0

    dut._log.info("iterate through clocks")
    for i in range(67):
        dut.instruction.value = instructionslist[i]
        dut.data.value = datalist[i]
        dut._log.info("check clock {}".format(i))
        await ClockCycles(dut.clk, 1)
    dut.rst.value = 1
    await ClockCycles(dut.clk,2)
    dut.rst.value = 0
