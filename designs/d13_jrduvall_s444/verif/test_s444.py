#!/usr/bin/env python3

from dataclasses import dataclass
from random import randint
from typing import List

import cocotb
from cocotb.handle import Force
from cocotb.triggers import ReadOnly, ReadWrite, Timer, NextTimeStep

TEST_S444_BITSTREAM_ITERS = 50
TEST_S444_LUT4_ITERS = 50
TEST_S444_LUT5_ITERS = 100


async def tick(dut):
    """
    Toggles the `clk` field on `dut`
    """
    dut.clk.value = 0
    await Timer(1, units="ns")
    dut.clk.value = 1
    await Timer(1, units="ns")


async def write_bitstream(dut, bitstream):
    """
    Writes a `bitstream` to the `shift_in` field of `dut`. Also verifies that
    the bitstream read is of the exact length by reading from `shift_out`

    `bitstream` is a list of 1s and 0s
    """
    dut.en.value = 1
    await tick(dut)
    await tick(dut)
    dut.reset.value = 1
    await tick(dut)
    dut.reset.value = 0

    # Write initial bitstream, asserting that value after reset is 0
    b = list(bitstream)
    for bit in b:
        dut.shift_in.value = bit
        await ReadWrite()
        assert dut.shift_out.value == 0
        await tick(dut)

    # Write bitstream again, asserting that the one written initially was good
    for index, bit in enumerate(b):
        dut.shift_in.value = bit
        await ReadWrite()
        assert dut.shift_out.value == bit
        await tick(dut)

    dut.en.value = 0


@cocotb.test()
async def test_s444_bitstream(dut):
    """
    Test that writing random bitstreams succeeds
    """
    for _ in range(TEST_S444_BITSTREAM_ITERS):
        await write_bitstream(
            dut,
            [
                randint(0, 1) for _ in range(3 * 1 + 3 * 16  # S444_Logic
                                             + 1 * 1  # LUT5_Mux
                                             + 2 * 2  # D_Flip_Flops
                                             )
            ])


def int_to_bs(x: int, length: int) -> List[bool]:
    """
    Converts x to a binary list, big-endian, padded with zeros
    """
    mod = 2**length
    output = []
    while mod > 1:
        mod = mod // 2
        output.append(x & mod != 0)
    return output


@dataclass
class S444LogicBitstream:
    main3: bool
    main2: bool
    feed0_3: bool
    lut0: List[bool]
    lut1: List[bool]
    lut2: List[bool]

    def to_bs(self) -> List[bool]:
        return self.lut2[::-1] + self.lut1[::-1] + self.lut0[::-1] \
            + [self.feed0_3] + [self.main2] + [self.main3]


@dataclass
class LUT5MuxBitstream:
    feed1_3: bool

    def to_bs(self) -> List[bool]:
        return [self.feed1_3]


@dataclass
class DFlipFlopsBitstream:
    dff0: int
    dff1: int

    def to_bs(self) -> List[bool]:
        return int_to_bs(self.dff1, 2) + int_to_bs(self.dff0, 2)


@dataclass
class S444Bitstream:
    s444_logic: S444LogicBitstream
    lut5_mux: LUT5MuxBitstream
    d_flip_flops: DFlipFlopsBitstream

    def to_bs(self) -> List[bool]:
        return self.d_flip_flops.to_bs() \
            + self.lut5_mux.to_bs() \
            + self.s444_logic.to_bs()


@cocotb.test()
async def test_s444_lut4_main(dut):
    """
    Create a random main LUT4 and test that it was programmed correctly
    """
    bs = S444Bitstream(
            S444LogicBitstream(
                main3=True,
                main2=True,
                feed0_3=False,
                lut0=[0] * 16,
                lut1=[0] * 16,
                lut2=[0] * 16,
            ),
            LUT5MuxBitstream(feed1_3=False, ),
            DFlipFlopsBitstream(
                dff0=1,
                dff1=2,
            ),
    )

    for _ in range(TEST_S444_LUT4_ITERS):
        lut = [randint(0, 1) for _ in range(16)]
        bs.s444_logic.lut2 = lut
        await write_bitstream(dut, bs.to_bs())
        await tick(dut)

        for i, o in enumerate(lut):
            dut.main.value = Force(i)
            await ReadOnly()
            assert dut.main_out.value == o
            await Timer(1, units="ns")


@cocotb.test()
async def test_s444_lut4_feed0(dut):
    """
    Create a random feed0 LUT4 and test that it was programmed correctly
    """
    bs = S444Bitstream(
            S444LogicBitstream(
                main3=True,
                main2=True,
                feed0_3=False,
                lut0=[0] * 16,
                lut1=[0] * 16,
                lut2=[0] * 16,
            ),
            LUT5MuxBitstream(feed1_3=False, ),
            DFlipFlopsBitstream(
                dff0=1,
                dff1=2,
            ),
    )

    for _ in range(TEST_S444_LUT4_ITERS):
        lut = [randint(0, 1) for _ in range(16)]
        bs.s444_logic.lut0 = lut
        await write_bitstream(dut, bs.to_bs())
        await tick(dut)

        for i, o in enumerate(lut):
            dut.feed0.value = Force(i)
            await ReadOnly()
            assert dut.feed0_out.value == o
            await Timer(1, units="ns")


@cocotb.test()
async def test_s444_lut4_feed1(dut):
    """
    Create a random feed1 LUT4 and test that it was programmed correctly
    """
    bs = S444Bitstream(
            S444LogicBitstream(
                main3=True,
                main2=True,
                feed0_3=False,
                lut0=[0] * 16,
                lut1=[0] * 16,
                lut2=[0] * 16,
            ),
            LUT5MuxBitstream(feed1_3=False, ),
            DFlipFlopsBitstream(
                dff0=1,
                dff1=2,
            ),
    )

    for _ in range(TEST_S444_LUT4_ITERS):
        lut = [randint(0, 1) for _ in range(16)]
        bs.s444_logic.lut1 = lut
        await write_bitstream(dut, bs.to_bs())
        await tick(dut)

        for i, o in enumerate(lut):
            dut.feed1.value = Force(i)
            await ReadOnly()
            assert dut.feed1_out.value == o
            await Timer(1, units="ns")


@cocotb.test()
async def test_s444_lut5(dut):
    """
    Creates a LUT5 by combining feed0 and feed1 in the LUT5 mux
    """
    bs = S444Bitstream(
            S444LogicBitstream(
                main3=True,
                main2=True,
                feed0_3=True,
                lut0=[0] * 16,
                lut1=[0] * 16,
                lut2=[0] * 16,
            ),
            LUT5MuxBitstream(feed1_3=True, ),
            DFlipFlopsBitstream(
                dff0=1,
                dff1=2,
            ),
    )

    for _ in range(TEST_S444_LUT5_ITERS):
        lut = [randint(0, 1) for _ in range(32)]
        bs.s444_logic.lut0 = lut[0:16]
        bs.s444_logic.lut1 = lut[16:32]
        await write_bitstream(dut, bs.to_bs())
        await tick(dut)

        for i, o in enumerate(lut):
            low4 = i % 16
            upp1 = i // 16
            dut.feed0.value = Force(low4)
            # feed1_3 is set to feed0_3 thanks to the configuration, and this
            # bit is instead used to switch between the two LUT4s, creating a
            # LUT5
            dut.feed1.value = Force((low4 % 8) | (upp1 << 3))
            await ReadOnly()
            assert dut.feed0_out.value == o
            await Timer(1, units="ns")


@cocotb.test()
async def test_s444_2bit_adder(dut):
    """
    Creates a 2-bit counter inside the d-flip-flops.
    Hooks up {feed0, feed1, main} as the input bits. Bits [0:1] carry the
    previous value, bit 2 is the carry input, and main_out is the carry output
    """

    bs = S444Bitstream(
            S444LogicBitstream(
                main3=True,
                main2=True,
                feed0_3=True,
                lut0=(I_0 ^ I_2).gen(),
                lut1=(I_1 ^ (I_0 & I_2)).gen(),
                lut2=(I_0 & I_1 & I_2).gen()
            ),
            LUT5MuxBitstream(feed1_3=False, ),
            DFlipFlopsBitstream(
                dff0=0,  # feed0_out
                dff1=0,  # feed1_out
            ),
    )

    await write_bitstream(dut, bs.to_bs())
    bit2 = (1 << 2)
    dut.feed0.value = bit2
    dut.feed1.value = bit2
    dut.main.value = bit2
    await tick(dut)

    def info(w):
        w._log.info(f"{w.value}")

    # Do the increment a given number of times
    for i in range(1, 10):
        low2 = i % 4
        dut.feed0.value = low2 | bit2
        dut.feed1.value = low2 | bit2
        dut.main.value = low2 | bit2
        await ReadOnly()
        info(dut.feed0_out)
        info(dut.feed1_out)
        info(dut.dff0_out)
        info(dut.dff1_out)
        info(dut.main_out)
        assert dut.dff0_out.value == low2 % 2
        assert dut.dff1_out.value == low2 // 2
        assert dut.main_out.value == (low2 == 3)
        await Timer(1, units="ns")
        await tick(dut)

    # Stop doing the increment, and ensure the state holds
    for _ in range(3):
        low2 = i % 4
        dut.feed0.value = low2
        dut.feed1.value = low2
        dut.main.value = low2
        await tick(dut)
        assert dut.dff0_out.value == low2 % 2
        assert dut.dff1_out.value == low2 // 2
        assert dut.main_out.value == (low2 == 3)


# ## s444.py
"""
This needs to be included in the same file since cocotb doesn't like having
multiple python files lol
"""


from abc import ABC, abstractmethod
from dataclasses import dataclass
from functools import partial
from typing import Callable, List


class LutBits:
    def gen(self) -> List[bool]:
        raise NotImplemented

    def __invert__(self) -> 'LutBits':
        return Not(self)

    def __and__(self, other) -> 'LutBits':
        return And(self, other)

    def __or__(self, other) -> 'LutBits':
        return Or(self, other)

    def __xor__(self, other) -> 'LutBits':
        return Xor(self, other)


@dataclass
class Constant(LutBits):
    index: int
    lut_width: int

    def gen(self) -> List[bool]:
        mask = 1 << self.index
        return [(mask & i) != 0 for i in range(1 << self.lut_width)]


I_0 = Constant(0, 4)
I_1 = Constant(1, 4)
I_2 = Constant(2, 4)
I_3 = Constant(3, 4)


@dataclass
class Not(LutBits):
    b: LutBits

    def gen(self) -> List[bool]:
        return [not i for i in self.b.gen()]


@dataclass
class BinOp(LutBits):
    op: Callable[[bool, bool], bool]
    left: LutBits
    right: LutBits

    def gen(self) -> List[bool]:
        return [
            self.op(lb, rb)
            for lb, rb in zip(self.left.gen(), self.right.gen())
        ]


And = partial(BinOp, lambda a, b: a & b)
Or = partial(BinOp, lambda a, b: a | b)
Xor = partial(BinOp, lambda a, b: a ^ b)
