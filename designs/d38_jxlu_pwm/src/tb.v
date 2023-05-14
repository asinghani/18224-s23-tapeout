module tb;

    logic [5:0] io_in;
    logic [7:0] io_out;
    logic clock;
    logic reset;
    poisonninja_top dut(.io_in({io_in, reset, clock}), .io_out(io_out));

    always #1 clock = ~clock;

    initial begin
        clock = 0;
        $monitor("%t: Duty: %d, Output: %d", $time, io_in, io_out[0]);

        io_in = 25;
        reset = 1;
        @(negedge clock);
        reset = 0;
        for (int i = 0; i < 25; i++) begin
            @(negedge clock);
            assert(io_out[0] == 1);
        end
        for (int i = 0; i < 25; i++) begin
            @(negedge clock);
            assert(io_out[0] == 0);
        end

        io_in = 10;
        reset = 1;
        @(negedge clock);
        reset = 0;
        for (int i = 0; i < 10; i++) begin
            @(negedge clock);
            assert(io_out[0] == 1);
        end
        for (int i = 0; i < 40; i++) begin
            @(negedge clock);
            assert(io_out[0] == 0);
        end

        io_in = 50;
        reset = 1;
        @(negedge clock);
        reset = 0;
        for (int i = 0; i < 50; i++) begin
            @(negedge clock);
            assert(io_out[0] == 1);
        end

        io_in = 60;
        reset = 1;
        @(negedge clock);
        reset = 0;
        for (int i = 0; i < 50; i++) begin
            @(negedge clock);
            assert(io_out[0] == 1);
        end

        $finish;
    end

endmodule