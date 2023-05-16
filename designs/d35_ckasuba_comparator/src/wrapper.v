
        module toplevel_chip (
            input [13:0] io_in,
            output [13:0] io_out
        );

            user_module_350155397606146642 mchip (
                .io_in(io_in[7:0]),
                .io_out(io_out[7:0])
            );

        endmodule
    