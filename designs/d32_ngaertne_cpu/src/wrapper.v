
        module toplevel_chip (
            input [13:0] io_in,
            output [13:0] io_out
        );

            // CLOCKED
            noahgaertner_cpu mchip (
                .io_in({io_in[7:1], io_in[12]}),
                .io_out(io_out[7:0])
            );

        endmodule
    