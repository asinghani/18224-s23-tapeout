module prng_test;

    logic reset, en, sel, clk;
    logic [7:0] seed; 
    logic valid;
    logic [7:0] rand_num;

    my_chip dut (
        .clock(clk), .reset(reset),
        .io_in({seed, sel, en}),
        .io_out({valid, rand_num})
    );

    initial begin
        clk <= 0;
        forever #1000000 clk <= ~clk;
    end

    // prng_test.dut.
    initial begin
        reset = 1;
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        reset = 0;
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        reset = 1;

        $monitor($time, " :rand_num = %b, valid = %b\n", rand_num, valid);

        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        reset = 0;
       // @(negedge clk)
       // @(negedge clk)
       // @(negedge clk)

        en = 1;
        sel = 0;
        seed = 8'b11001100;
        // seed <= 8'b00011000;
        // seed <= 8'b10101010;
        
        @(negedge clk)
        @(negedge clk)
        @(negedge clk)
        en = 0;
        
        repeat (50) begin
            en = 1;
            @(negedge clk)
            @(negedge clk)
            @(negedge clk)
            en = 0;
            repeat (100) @(negedge clk);
        end
        
        $finish;
    end

endmodule: prng_test
