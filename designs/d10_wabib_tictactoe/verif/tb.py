import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly


async def reset(dut):
    dut.reset.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.reset.value = 0

@cocotb.test()
async def test_ttt_game_control(dut):

    # Automatic clock (timescale is for VCD files)
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Reset DUT
    dut.start.value = 0
    await reset(dut)

    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    dut.b0.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led0 = {dut.led0.value} game_state = {dut.game_state.value}');
    assert(dut.led0.value == 1)
    assert(dut.game_state.value == 1)

    dut.b1.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led1 = {dut.led1.value} game_state = {dut.game_state.value}');
    assert(dut.led1.value == 1)
    assert(dut.game_state.value == 3)

    dut.b2.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led2 = {dut.led2.value} game_state = {dut.game_state.value}');
    assert(dut.led2.value == 1)
    assert(dut.game_state.value == 7)

    dut.b3.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led3 = {dut.led3.value} game_state = {dut.game_state.value}');
    assert(dut.led3.value == 1)
    assert(dut.game_state.value == 15)

    dut.b4.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led4 = {dut.led4.value} game_state = {dut.game_state.value}');
    assert(dut.led4.value == 1)
    assert(dut.game_state.value == 31)

    dut.b5.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led5 = {dut.led5.value} game_state = {dut.game_state.value}');
    assert(dut.led5.value == 1)
    assert(dut.game_state.value == 63)

    dut.b6.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led6 = {dut.led6.value} game_state = {dut.game_state.value}');
    assert(dut.led6.value == 1)
    assert(dut.game_state.value == 127)

    dut.b7.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led7 = {dut.led7.value} game_state = {dut.game_state.value}');
    assert(dut.led7.value == 1)
    assert(dut.game_state.value == 255)

    dut.b8.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    print(f'led8 = {dut.led8.value} game_state = {dut.game_state.value}');
    assert(dut.led8.value == 1)
    assert(dut.game_state.value == 511)
