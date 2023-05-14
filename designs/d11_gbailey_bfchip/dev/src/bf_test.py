# Runs the test suite in simulation

import cocotb
from cocotb.triggers import Timer
import os
from pathlib import Path
import tomli

def dbg(*args, **kwargs):
  if "BF_DEBUG" in os.environ:
    print(*args, **kwargs)

async def test_program(dut, prog, stdin=b"", stdout=b"", failread=None):
  if isinstance(prog, str):
    prog = prog.encode("ascii")
  if isinstance(stdin, str):
    stdin = stdin.encode("ascii")
  if isinstance(stdout, str):
    stdout = stdout.encode("ascii")
  if isinstance(stdout, str):
    failread = failread.encode("ascii")
  stdin = bytearray(stdin)

  actual_stdout = bytearray()

  memory = bytearray(65536)

  # Reset and initial values
  dut.val_in.value = 0
  dut.clock.value = 0
  dut.reset.value = 1
  await Timer(10, "ns")
  dut.clock.value = 1
  await Timer(10, "ns")
  dut.clock.value = 0
  dut.reset.value = 0
  dut.enable.value = 1
  await Timer(10, "ns")

  entered_loop = False
  while not dut.halted.value.integer:
    entered_loop = True
    dut.clock.value = 1
    # Get values right before they vanish
    bus_op = dut.bus_op.value
    addr = dut.addr.value
    val_out = dut.val_out.value
    await Timer(10, "ns")
    dut.clock.value = 0
    if bus_op == 0b010: # BusReadProg
      if addr.integer < len(prog):
        dut.val_in.value = prog[addr.integer]
      else:
        dut.val_in.value = 0
      dbg("reading program")
    elif bus_op == 0b100: # BusReadData
      dut.val_in.value = memory[addr.integer]
      dbg("reading data")
    elif bus_op == 0b101: # BusWriteData
      memory[addr.integer] = val_out.integer
      dbg("writing data")
    elif bus_op == 0b110: # BusReadIo
      if len(stdin) > 0:
        char = stdin.pop(0)
      elif failread is None:
        raise ValueError("reading on empty input is failure")
      else:
        char = failread
      dut.val_in.value = char
      dbg("reading io")
    elif bus_op == 0b111: # BusWriteIo
      actual_stdout.append(val_out.integer)
      dbg("writing io")

    await Timer(10, "ns")

  assert(entered_loop)
  dbg(stdout, actual_stdout)
  assert(stdout == actual_stdout)

# Construct test cases from files
tests_dir = Path(__file__).parent / "tests"
for test_file in tests_dir.iterdir():
  with open(test_file, "rb") as f:
    test = tomli.load(f)

  async def test_fn(dut, test=test):
    await test_program(
      dut,
      test["program"],
      test.get("input", ""),
      test.get("output", ""),
      failread=test.get("input_end", None)
    )

  test_fn.__name__ = test["name"]
  test_fn.__qualname__ = test["name"]
  vars()[test["name"]] = cocotb.test(
    skip=test.get("slow", False),
    stage=test.get("stage", 0)
  )(test_fn)
