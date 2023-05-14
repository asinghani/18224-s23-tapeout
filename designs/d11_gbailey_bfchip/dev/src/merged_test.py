# Version of `fpga_test.py` with the program merged in, for post-merge testing.

from interface import Chip

IoNone          = 0b000
IoOpcode        = 0b001
IoAddrHi        = 0b010
IoAddrLo        = 0b011
IoReadWrite     = 0b100
BusNone         = 0b000
BusReadProg     = 0b010
BusReadData     = 0b100
BusWriteData    = 0b101
BusReadIo       = 0b110
BusWriteIo      = 0b111

class Inputs:
  def __init__(self, chip):
    self.bus_in = 0
    self.op_done = 0
    self.enable = 0
    self.chip = chip

  def set(self):
    val = (self.enable << 9) | (self.op_done << 8) | self.bus_in
    self.chip.set_all_inputs(val)

  def __repr__(self):
    return f"bus_in={self.bus_in:08b}, " \
           f"op_done={self.op_done:b}, " \
           f"enable={self.enable:b}"

class Outputs:
  def __init__(self, chip):
    self.bus_out = 0
    self.state = 0
    self.halted = 0
    self.chip = chip

  def get(self):
    out = self.chip.get_all_outputs()
    self.bus_out = out & 0x0FF
    self.state = (out & 0x700) >> 8
    self.halted = (out & 0x800) >> 11

  def __repr__(self):
    return f"bus_out={self.bus_out:08b}, " \
           f"state={self.state:03b}, " \
           f"halted={self.halted:b}"

# Modified version of Cristofani's IO test (CC-BY-SA). Includes a loop-forward
# check to make sure we're checking all the states.
prog = bytearray(b"++--[++++++++.]>,>+++++++++,>+++++++++++[<++++++<++++++<+>>>-]<<.>.<<-.>.>.<<.")
stdin = bytearray(b"\n")
input_end = 0
stdout = bytearray(b"LB\nLB\n")

chip = Chip("/dev/ttyUSB1")
inputs = Inputs(chip)
outputs = Outputs(chip)

print("resetting")
chip.set_reset(1)
chip.step_clock()
chip.set_reset(0)

inputs.enable = 1
inputs.set()
outputs.get()

# pseudo-registers
opcode = 0
addr_hi = 0
addr_lo = 0

data = bytearray(65536)
output = bytearray()

cycles = 0

while not outputs.halted:
  outputs.get()
  # print(outputs)
  if outputs.state == IoOpcode:
    opcode = outputs.bus_out
  elif outputs.state == IoAddrHi:
    addr_hi = outputs.bus_out
  elif outputs.state == IoAddrLo:
    addr_lo = outputs.bus_out
  elif outputs.state == IoReadWrite:
    addr = (addr_hi << 8) | addr_lo
    if opcode == BusReadProg:
      if addr >= len(prog):
        inputs.bus_in = 0
      else:
        inputs.bus_in = prog[addr]
      print(f"reading program [{addr:04x}]: {chr(inputs.bus_in)}")
    elif opcode == BusReadData:
      inputs.bus_in = data[addr]
      print(f"reading data    [{addr:04x}]: {inputs.bus_in}")
    elif opcode == BusWriteData:
      data[addr] = outputs.bus_out
      print(f"writing data    [{addr:04x}]: {outputs.bus_out}")
    elif opcode == BusReadIo:
      if len(stdin) > 0:
        inputs.bus_in = stdin.pop(0)
      else:
        inputs.bus_in = input_end
      print(f"reading io            : {chr(inputs.bus_in)}")
    elif opcode == BusWriteIo:
      print(f"writing io            : {chr(outputs.bus_out)}")
      output.append(outputs.bus_out)
    inputs.op_done = 1
    inputs.set()
  # print(inputs)
  chip.step_clock()
  cycles += 1

print(f"halted, ran {cycles} cycles")
if output == stdout:
  print(f"output: {bytes(output)}, success!")
else:
  print(f"output: {bytes(output)}, differs from expected: {bytes(stdout)}")
assert(output == stdout)
