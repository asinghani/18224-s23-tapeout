from abc import ABC, abstractmethod
from dataclasses import dataclass
from functools import partial
from typing import Callable


class LutBits:
    def gen(self) -> list[bool]:
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

    def gen(self) -> list[bool]:
        mask = 1 << self.index
        return [(mask & i) != 0 for i in range(1 << self.lut_width)]


I_0 = Constant(0, 4)
I_1 = Constant(1, 4)
I_2 = Constant(2, 4)
I_3 = Constant(3, 4)


@dataclass
class Not(LutBits):
    b: LutBits

    def gen(self) -> list[bool]:
        return [not i for i in self.b.gen()]


@dataclass
class BinOp(LutBits):
    op: Callable[[bool, bool], bool]
    left: LutBits
    right: LutBits

    def gen(self) -> list[bool]:
        return [
            self.op(lb, rb)
            for lb, rb in zip(self.left.gen(), self.right.gen())
        ]


And = partial(BinOp, lambda a, b: a & b)
Or = partial(BinOp, lambda a, b: a | b)
Xor = partial(BinOp, lambda a, b: a ^ b)
