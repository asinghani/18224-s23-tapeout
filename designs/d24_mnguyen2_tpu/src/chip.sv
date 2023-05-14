`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);

  tpu TPU(.clk(clock), .rst(reset),
          .insert_kernal(io_in[0]),
          .write(io_in[1]),
          .write_mode(io_in[2]),
          .ready(io_in[3]),
          .data_in(io_in[11:4]),
          .done(io_out[0]),
          .data_out(io_out[11:4])
         );

endmodule
