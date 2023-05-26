`default_nettype none

module my_chip (
    input logic [11:0] io_in, 
    input logic clock, reset,
    output logic [11:0] io_out
);

    assign io_out[11:6] = 4'b0;

    dinogame game2 (
        .jump_in(io_in[0]),
        .halt_in(io_in[1]),
        .debug_in(io_in[2]),

        .vga_hsync(io_out[0]),
        .vga_vsync(io_out[1]),
        .vga_red(io_out[3]),
        .vga_green(io_out[4]),
        .vga_blue(io_out[5]),
        .vga_pixel(io_out[2]),

        .cfg_accel(io_in[11] ? io_in[10:7] : 4),
        .cfg_speed(io_in[11] ? io_in[6:3] : 2),

        .clk(clock),
        .sys_rst(reset)
    );

endmodule
