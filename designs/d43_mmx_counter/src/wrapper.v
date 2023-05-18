
        module toplevel_chip (
            input [13:0] io_in,
            output [13:0] io_out
        );

            mmx_chip mchip (
                .io_in(io_in[7:0]),
                .io_out(io_out[7:0])
            );

        endmodule
    