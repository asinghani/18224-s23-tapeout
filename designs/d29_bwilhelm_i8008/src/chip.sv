`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
    i8008_core my_core (
        .clk(clock),
        .rst(reset),

        .D_in(io_in[7:0]),
        .INTR(io_in[8]),
        .READY(io_in[9]),

        .D_out(io_out[7:0]),
        .state(io_out[10:8]),
        .Sync(io_out[11])
    );

endmodule
