`default_nettype none

module my_chip (
    input logic [11:0] io_in, 
    input logic clock, reset,
    output logic [11:0] io_out
);

    assign io_out = io_in[5:0] + io_in[11:6];

endmodule
