import time
from serial import Serial

CMD_READ_REQ     = 0b0001
CMD_WRITE_REQ    = 0b0010
CMD_SET_ADDR     = 0b0011
CMD_SET_ADDR_INC = 0b0111
CMD_BUS_RESET    = 0b1111

RESP_READ_RESP   = 0b0001
RESP_WRITE_ACK   = 0b0010
RESP_ADDR_ACK    = 0b0011
RESP_BUS_ERROR   = 0b0100
RESP_BUS_RESET   = 0b0101
RESP_INTERRUPT_1 = 0b1000
RESP_INTERRUPT_2 = 0b1001
RESP_INTERRUPT_3 = 0b1010
RESP_INTERRUPT_4 = 0b1011

RESP_INTERRUPT_ALL = [RESP_INTERRUPT_1, RESP_INTERRUPT_2,
                      RESP_INTERRUPT_3, RESP_INTERRUPT_4]

def create_instruction(inst, data):
    return [
        inst,
        (data & 0xff000000) >> 24,
        (data & 0x00ff0000) >> 16,
        (data & 0x0000ff00) >> 8,
        (data & 0x000000ff) >> 0
    ]

def parse_instruction(byte_list):
    data = int("".join(["{0:08b}".format(x) for x in byte_list[1:]]), 2)
    return byte_list[0] & 0x0f, data

class Chip:
    def __init__(self, serial_port, baud=115200):
        self.bus = _DebugBus(serial_port, baud, fifo_size=1, timeout=2)
        self.out_state = 0b00000000000000

    def get_all_outputs(self):
        o = self.bus.read_peripheral(0)[0] & 0xFFF
        return o

    def get_output(self, index):
        assert index >= 0 and index < 12

        o = self.bus.read_peripheral(0)[0] & 0xFFF
        o = o & (1 << index)
        return (o != 0)

    def _push_outputs(self):
        self.bus.write_peripheral(0, self.out_state)

    def set_input(self, index, value, _bp=False):
        if not _bp:
            assert index >= 0 and index < 12

        value_n = int(not (int(value) & 0x1))
        self.out_state |= (1 << index)
        self.out_state ^= (value_n << index)

        self._push_outputs()

    def set_all_inputs(self, value):
        value = value & 0xFFF

        self.out_state &= 0xF000
        self.out_state |= value

        self._push_outputs()

    def set_reset(self, value):
        self.set_input(12, value, _bp=True)

    def step_clock(self):
        self.set_input(13, 1, _bp=True)
        self.set_input(13, 0, _bp=True)

class _DebugBus:

    def __init__(self, serial_port, baud, fifo_size, timeout=0):
        # Maximum number of ops that can be in-pipeline at once
        self.max_buf = (fifo_size - 2) if fifo_size > 2 else fifo_size
        assert self.max_buf > 0

        # No timeout for serial port
        # Instead, use unblocking serial port and block internally
        self.port = Serial(serial_port, baud, timeout=0)
        self.timeout = timeout

        self.interrupts = [False, False, False, False]

        self.recv_buffer = []
        self.recv_responses = []

    # Read as much data from the port as is available and store it
    def _read_port(self):
        data = self.port.read(10000) # Read as much data is available
        self.recv_buffer.extend(list(data))

        while len(self.recv_buffer) >= 5:
            instr = parse_instruction(self.recv_buffer[0:5])
            self.recv_buffer = self.recv_buffer[5:]

            # Parse interrupts
            if instr[0] in RESP_INTERRUPT_ALL:
                if instr[0] == RESP_INTERRUPT_1:
                    self.interrupts[0] = True
                if instr[0] == RESP_INTERRUPT_2:
                    self.interrupts[1] = True
                if instr[0] == RESP_INTERRUPT_3:
                    self.interrupts[2] = True
                if instr[0] == RESP_INTERRUPT_4:
                    self.interrupts[3] = True

            elif instr[0] == RESP_BUS_ERROR:
                raise RuntimeError("Bus error received")

            else:
                self.recv_responses.append(instr)

    # Blocking-read `n` instructions from serial port
    # If n = 0, will read 1 instruction in a non-blocking manner
    def _read_data(self, n=0):
        first = True

        start_time = time.time()
        while True:
            self._read_port()

            if n == 0:
                if len(self.recv_responses) >= 1:
                    resp = self.recv_responses[0:1]
                    self.recv_responses = self.recv_responses[1:]
                    return resp
                else:
                    return None

            else:
                if len(self.recv_responses) >= n:
                    resp = self.recv_responses[0:n]
                    self.recv_responses = self.recv_responses[n:]
                    return resp

            first = False
            if (self.timeout != 0) and (time.time() - start_time > self.timeout):
                raise TimeoutError("Remote device not responding")

            time.sleep(0.01)

    def read(self, address, n=1, _increment=True):
        """
            Read `n` contiguous 32-bit words starting at `address`. Blocks execution until finished or timed out. For reading multiple values from the same address (for peripherals which use a single register as a pipe), use read_peripheral(). If `n` = 1, returns a single integer value read from the bus, otherwise returns an array of integer values with length `n`.

            Arguments:
                address (int): The base address to read from.
                n (int): The number of values to read starting at the given address.
        """

        ret = []

        # Set address
        self.port.write(bytearray(create_instruction(
            CMD_SET_ADDR_INC if _increment else CMD_SET_ADDR, address
        )))

        # Include address-set in first-round buffer-count
        first_round = 1

        # One extra readback (for address)
        n = n + 1

        # Send only enough ops at once to avoid overflowing buffer
        while n > 0:
            num_words = min(self.max_buf, n)

            for i in range(num_words - first_round):
                self.port.write(bytearray(create_instruction(
                    CMD_READ_REQ, 0
                )))

            first_round = 0

            ret.extend(self._read_data(num_words))
            n = n - num_words

        # Remove address-acknowledge
        assert ret[0][0] == RESP_ADDR_ACK
        ret = ret[1:]
        for inst, data in ret:
            assert inst == RESP_READ_RESP
        ret = [int(x[1]) for x in ret]

        if n == 1:
            return ret[0]
        else:
            return ret

    def read_peripheral(self, address, n=1):
        """
            Read `n` 32-bit words, all from `address`. Blocks execution until finished or timed out. This should be used for peripherals which use a single register as a pipe. If `n` = 1, returns a single integer value read from the bus, otherwise returns an array of integer values with length `n`.

            Arguments:
                address (int): The singular address to read from.
                n (int): The number of values to read from the given address.
        """

        return self.read(address, n=n, _increment=False)

    def write(self, address, data, verify=False, _increment=True):
        """
            Write `data` into contiguous 32-bit words starting at `address`. Blocks execution until finished or timed out. `None` values in the data array will not be written. For writing multiple values to the same address (for peripherals which use a single register as a pipe), use write_peripheral().

            Arguments:
                address (int): The base address to write to.
                data (list[int] OR int): The data to write.
                verify (bool): Whether to read-back and verify the data after writing it.
        """

        ret = []

        # Set address
        self.port.write(bytearray(create_instruction(
            CMD_SET_ADDR_INC if _increment else CMD_SET_ADDR, address
        )))

        # Include address-set in first-round buffer-count
        first_round = 1

        # Check data format
        if isinstance(data, int):
            data = [data]
        data_buf = data[:]

        n = len(data)

        # One extra readback (for address)
        n = n + 1

        # Send only enough ops at once to avoid overflowing buffer
        while n > 0:
            num_words = min(self.max_buf, n)

            for i in range(num_words - first_round):
                if data_buf[0] is None:
                    assert _increment
                    # Use read req to increment address w/o writing
                    self.port.write(bytearray(create_instruction(
                        CMD_READ_REQ, 0
                    )))
                else:
                    self.port.write(bytearray(create_instruction(
                        CMD_WRITE_REQ, data_buf[0]
                    )))

                data_buf = data_buf[1:]

            first_round = 0

            ret.extend(self._read_data(num_words))
            n = n - num_words

        assert len(data_buf) == 0

        # Remove address-acknowledge
        assert ret[0][0] == RESP_ADDR_ACK
        ret = ret[1:]
        for i, resp in enumerate(ret):
            if data[i] is None:
                assert resp[0] == RESP_READ_RESP
            else:
                assert resp[0] == RESP_WRITE_ACK

        # Verify that correct data was written
        if verify and _increment:
            data_read = self.read(address, n=len(data), _increment=True)

            if len(data) == 1:
                assert (data_read == data[0]) or (data[0] is None)
            else:
                for i in range(len(data)):
                    assert (data_read[i] == data[i]) or (data[i] is None)

    def write_peripheral(self, address, data):
        """
            Write all values in `data` to `address`. Blocks execution until finished or timed out. This should be used for peripherals which use a single register as a pipe.

            Arguments:
                address (int): The singular address to write to.
                data (list[int]): The data to write to the address.
        """

        self.write(address, data, verify=False, _increment=False)

    def reset(self):
        """
            Forcibly reset the bus. Blocks until the bus-reset is acknowledged.
        """
        self.port.write(bytearray(create_instruction(
            CMD_BUS_RESET, 0
        )))

        while True:
            inst, data = self._read_data(1)[0]

            if inst == RESP_BUS_RESET:
                return

    def poll_interrupts(self, reset=False):
        """
            Poll the received interrupts. Returns an array of the 4 interrupts.

            Arguments:
                reset (bool): Whether to reset the interrupts after reading.
        """

        self._read_port()

        ret = self.interrupts[:]
        if reset:
            self.reset_interrupts()

        return ret

    def poll_interrupts(self, reset=False):
        """
            Poll the received interrupts. Returns an array of the 4 interrupts.

            Arguments:
                reset (bool): Whether to reset the interrupts after reading.
        """

        self._read_port()

        ret = self.interrupts[:]
        if reset:
            self.reset_interrupts()

        return ret

    def reset_interrupts(self):
        """
            Reset interrupts regardless of whether they have been polled.
        """
        self.interrupts = [False, False, False, False]

    def close(self):
        self.port.close()

    # Context manager compliance
    def __enter__(self):
        return self

    def __exit__(self, exception_type, exception_value, traceback):
        self.close()


