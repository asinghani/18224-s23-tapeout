// Top module for running on FPGA: just connects to debug harness.
`default_nettype none

module top (
  input logic clk100, // 100MHz clock

  input logic uart_rx, // UART rx/tx from FTDI chip on FPGA
  output logic uart_tx
);

  logic clock, reset;
  logic [11:0] io_in, io_out;

  debug_harness dbg (
    .uart_rx, .uart_tx,
    .chip_inputs(io_in),
    .chip_outputs(io_out),
    .chip_clock(clock),
    .chip_reset(reset),
    .clk100
  );

  my_chip dut (
    .io_in, .io_out,
    .clock,
    .reset
  );

endmodule
