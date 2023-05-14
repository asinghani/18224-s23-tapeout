// Top module for tapeout: multiplexes BF's bus and connects to final ports
`default_nettype none

// Name and ports are set by build system
module my_chip (
  input logic [11:0] io_in, // Inputs to your chip
  output logic [11:0] io_out, // Outputs from your chip
  input logic clock,
  input logic reset // Important: Reset is ACTIVE-HIGH
);

  // Outputs / inputs
  logic [7:0] bus_out;
  IoOp state, next_state;
  logic halted;
  assign io_out = {halted, state, bus_out};

  logic [7:0] bus_in;
  assign bus_in = io_in[7:0];
  logic op_done;
  assign op_done = io_in[8];
  logic enable;
  assign enable = io_in[9];

  // BF interface
  logic [15:0] addr;
  logic [7:0] val_in, val_out;
  BusOp bus_op;
  logic bf_enable;

  BF bf (
    .addr,
    .val_in,
    .val_out,
    .bus_op,
    .halted,
    .clock,
    .reset,
    .enable(enable && bf_enable)
  );

  BusOp op_cache;
  logic [15:0] addr_cache;
  logic [7:0] val_cache;

  // Control signals
  logic cache_out;
  logic cache_in;

  always_comb begin
    bf_enable = 0;
    cache_out = 0;
    cache_in = 0;
    bus_out = '0;

    case (state)
      IoNone: begin
        bf_enable = 1;
        cache_out = 1;

        if (bus_op != BusNone)
          next_state = IoOpcode;
        else
          next_state = IoNone;
      end
      IoOpcode: begin
        bus_out = {5'b0, op_cache};

        next_state = IoAddrHi;
      end
      IoAddrHi: begin
        bus_out = addr_cache[15:8];

        next_state = IoAddrLo;
      end
      IoAddrLo: begin
        bus_out = addr_cache[7:0];

        next_state = IoReadWrite;
      end
      IoReadWrite: begin
        bus_out = val_cache;
        cache_in = 1;

        if (op_done)
          next_state = IoNone;
        else
          next_state = IoReadWrite;
      end
      default: next_state = IoNone;
    endcase
  end

  always_ff @(posedge clock)
    if (reset) begin
      state <= IoNone;
      op_cache <= BusNone;
      addr_cache <= '0;
      val_cache <= '0;
      val_in <= '0;
    end
    else if (enable) begin
      state <= next_state;
      if (cache_out) begin
        op_cache <= bus_op;
        addr_cache <= addr;
        val_cache <= val_out;
      end
      if (cache_in) val_in <= bus_in;
    end

endmodule
