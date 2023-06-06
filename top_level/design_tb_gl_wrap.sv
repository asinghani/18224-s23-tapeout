`timescale 1ns/1ps

module my_chip (
    input logic [11:0] io_in,
    output logic [11:0] io_out,
    input logic clock,
    input logic reset
);

    wire [37:0] tmp;
    assign io_out = tmp[37:26];

    reg pwr = 1;

    initial begin
        //pwr = 0;
        //#100
        //pwr = 1;
    end

    user_project_wrapper upw (
        .vccd1(pwr),
        .vccd2(pwr),
        .vdda1(pwr),
        .vdda2(pwr),
        .vssa1(0),
        .vssa2(0),
        .vssd1(0),
        .vssd2(0),

        .user_clock2(0),
        .wb_clk_i(clock),
        .wb_rst_i(reset),
        .wbs_ack_o(),
        .wbs_cyc_i(0),
        .wbs_stb_i(0),
        .analog_io(),

        .la_data_in(0),
        .la_data_out(),
        .la_oenb(0),
        .user_irq(),
        .wbs_adr_i(0),
        .wbs_dat_i(0),
        .wbs_dat_o(),
        .wbs_sel_i(0),

        .io_in({12'b0, io_in, 6'd`DES_NUM, 
            1'b0, // hold input
            1'b0, // sync input
            reset, 5'b0}),
        .io_oeb(),
        .io_out(tmp)
    );

endmodule
