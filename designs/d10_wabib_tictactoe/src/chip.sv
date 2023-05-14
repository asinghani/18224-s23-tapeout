`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);

    ttt_game_control ttt(.b0(io_in[0]),
                         .b1(io_in[1]),
                         .b2(io_in[2]),
                         .b3(io_in[3]),
                         .b4(io_in[4]),
                         .b5(io_in[5]),
                         .b6(io_in[6]),
                         .b7(io_in[7]),
                         .b8(io_in[8]),
                         .player_sel(io_in[9]),
                         .start(io_in[10]),
                         .led0(io_out[0]),
                         .led1(io_out[1]),
                         .led2(io_out[2]),
                         .led3(io_out[3]),
                         .led4(io_out[4]),
                         .led5(io_out[5]),
                         .led6(io_out[6]),
                         .led7(io_out[7]),
                         .led8(io_out[8]),
                         .clk(clock),
                         .reset(reset));

    assign io_out[11:9] = 3'd0;

endmodule
