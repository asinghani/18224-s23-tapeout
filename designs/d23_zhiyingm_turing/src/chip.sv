`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    logic [6:0] input_data;
    logic Next, Done;

    Synchronizer sync1 (.async(io_in[1]), .sync(Next), .clock);
    Synchronizer sync2 (.async(io_in[0]), .sync(Done), .clock);
    Synchronizer sync3 (.async(io_in[2]), .sync(input_data[0]), .clock);
    Synchronizer sync4 (.async(io_in[3]), .sync(input_data[1]), .clock);
    Synchronizer sync5 (.async(io_in[4]), .sync(input_data[2]), .clock);
    Synchronizer sync6 (.async(io_in[5]), .sync(input_data[3]), .clock);
    Synchronizer sync7 (.async(io_in[6]), .sync(input_data[4]), .clock);
    Synchronizer sync8 (.async(io_in[7]), .sync(input_data[5]), .clock);
    
    TuringMachine #(5, 128) dut (.clock, .reset, .input_data, .Next, .Done,
                                .display_out(io_out[11:1]), .Compute_done(io_out[0]));

endmodule
