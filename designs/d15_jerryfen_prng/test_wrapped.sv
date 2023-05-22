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
        forever #10 clk <= ~clk;
    end

    // prng_test.dut.
    initial begin
        reset = 1;

        $monitor($time, " :rand_num = %b, valid = %b\n", rand_num, valid);

        @(posedge clk)
        reset = 0;
        @(posedge clk)

        en <= 1;
        sel <= 0;
        seed <= 8'b11001100;
        // seed <= 8'b00011000;
        // seed <= 8'b10101010;
        
        @(posedge clk)
        en <= 0;
        
        repeat (50) begin
            en = 1;
            @(posedge clk)
            en = 0;
            repeat (100) @(posedge clk);
        end
        
        $finish;
    end

endmodule: prng_test
