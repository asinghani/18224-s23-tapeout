`default_nettype none

module my_chip (
    input logic [11:0] io_in, 
    input logic clock, reset,
    output logic [11:0] io_out
);

    assign io_out[11:8] = 4'b0;

    game_wrapper pong (
        .VGA_R3(io_out[7]),
        .VGA_R2(io_out[6]),
        .VGA_R1(),
        .VGA_R0(),

        .VGA_G3(io_out[5]),
        .VGA_G2(io_out[4]),
        .VGA_G1(),
        .VGA_G0(),

        .VGA_B3(io_out[3]),
        .VGA_B2(io_out[2]),
        .VGA_B1(),
        .VGA_B0(),

        .VGA_VS(io_out[1]),
        .VGA_HS(io_out[0]),

        .btn_serve(io_in[5]),
        .btn_rst(io_in[4]),
        .btn0_n(~io_in[3]),
        .btn1_n(~io_in[2]),
        .btn2_n(~io_in[1]),
        .btn3_n(~io_in[0]),

        .cfg1(io_in[7]),
        .cfg2(io_in[6]),

        .clk_25mhz(clock)
    );

endmodule
