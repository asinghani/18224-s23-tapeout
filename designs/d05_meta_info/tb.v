module tb;
    reg [5:0] proj_idx;
    reg [5:0] chr_idx;
    reg clock, reset;

    wire [7:0] chr;

    my_chip chip (
        .reset, .clock,
        .io_in({proj_idx, chr_idx}),
        .io_out(chr)
    );

    initial forever #500 clock = !clock;

    initial begin
        clock = 0;
        reset = 0;

        for (int id = 0; id < 64; id++) begin
            proj_idx = id;
            $write("proj_idx=%d msg=", proj_idx);

            for (chr_idx = 0; chr_idx < 63; chr_idx++) begin
                repeat(8) @(posedge clock);
                if (chr == 0) break;
                $write("%c", chr);
            end

            $write("\n");
        end
        $write("\n");

        $finish;
    end

endmodule
