`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset); // Important: Reset is ACTIVE-HIGH
   
    perceptron learning(.clk(clock),
                         .reset_l(~reset),
                         .go(io_in[10]),
                         .update(io_in[9]),
                         .correct(io_in[8]),
                         .sel_out(io_in[7:6]),
                         .in_val(io_in[5:0]),
                         .done(io_out[8]),
                         .classification(io_out[7]),
                         .sync(io_out[6]),
                         .out_val(io_out[5:0]));

endmodule
