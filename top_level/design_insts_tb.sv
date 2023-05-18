module design_insts_tb;
    logic [11:0] io_in;
    logic [11:0] io_out;
    logic ready;
    logic clock, reset;

    standard_tb tb (.*);

    design_instantiations dut (
        .io_in, .io_out,
        .clock, .reset,
        .des_sel(6'd`DES_NUM), .hold_if_not_sel(1'b0)
    );

    initial forever #5 clock = !clock;

    initial begin
        $dumpfile("build/tb.vcd");
        $dumpvars;

        ready = 0;
        clock = 0;
        reset = 1;
        repeat(5) @(negedge clock);
        reset = 0;
        repeat(5) @(negedge clock);
        ready = 1;
    end

endmodule
