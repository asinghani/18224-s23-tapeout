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
        #100;
        while (!ready) @(negedge clock);

        $monitor("A=%d, B=%d, O=%d", io_in[11:6], io_in[5:0], io_out);

        io_in = {6'd1, 6'd1}; #1
        `ASSERT(io_out == 2);
        io_in = {6'd1, 6'd4}; #1
        `ASSERT(io_out == 5);
        io_in = {6'd4, 6'd1}; #1
        `ASSERT(io_out == 5);
        io_in = {6'd63, 6'd63}; #1
        `ASSERT(io_out == 126);

        $finish(0); // pass
    end

endmodule
