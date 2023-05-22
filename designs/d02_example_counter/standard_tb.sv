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

    initial begin
        io_in = 0;

        #100;
        while (!ready) @(negedge clock);

        $monitor("[%d] out=%d, en=%d, ud=%d", $time, io_out, io_in[0], io_in[1]);

        io_in[0] = 1;
        repeat(100) @(negedge clock);
        io_in[0] = 0;
        repeat(100) @(negedge clock);
        io_in[0] = 1;
        io_in[1] = 1;
        repeat(100) @(negedge clock);

        $finish(0); // pass
    end

endmodule
