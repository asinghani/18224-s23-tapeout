`default_nettype none

`define ASSERT(x) if (!(x)) begin \
    $display("Assert failed at line %d", `__LINE__); \
    $finish(1); \
end

module standard_tb (
    output logic [11:0] io_in,
    input logic [11:0] io_out,
    input logic ready,
    input logic clock, reset
);

    integer idx, chr;
    assign io_in = {idx[5:0], chr[5:0]};

    initial begin
        #100;
        while (!ready) @(negedge clock);

        for (idx = 0; idx < 64; idx++) begin
            $write("proj_idx=%d msg=", idx);
            repeat(3) @(posedge clock);

            for (chr = 0; chr < 63; chr++) begin
                repeat(3) @(posedge clock);
                if (io_out[7:0] == 0) break;
                $write("%c", io_out[7:0]);
            end

            $write("\n");
        end
        $write("\n");

        $finish;
    end

endmodule
