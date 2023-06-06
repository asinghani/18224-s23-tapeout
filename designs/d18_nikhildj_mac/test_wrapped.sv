`timescale 1ns/1ps

module test;

    logic reset, clock;
    logic mac_carry_out, finish, shiftout, end_mul;
    logic [11:0] io_out;
    logic start, shiftA, shiftB, shift, do_next;

    assign {mac_carry_out, finish, shiftout, end_mul} = io_out[11:8];

    my_chip dut (
        .clock(clock),
        .reset(reset),
        .io_in({start, shiftA, shiftB, shift, do_next, 7'b0}),
        .io_out(io_out)
    );

    initial begin
        clock = 0;
        forever #50000 clock = ~clock;
    end

    task shiftIn (input [7:0] d1, input [7:0] d2);
        begin
            for (int i = 0; i < 8; i += 1) begin
                shiftA = d1[7-i]; shiftB = d2[7-i];
                @(negedge clock);
                @(negedge clock);
                shift = 1; @(negedge clock); @(negedge clock);
                shift = 0; @(negedge clock); @(negedge clock);
            end
            
        end
    endtask

    logic [19:0] dout;
    task shiftOut ();
        begin
            for (int i = 0; i < 20; i += 1) begin
                dout[i] = shiftout;
                @(negedge clock);
                @(negedge clock);
                shift = 1; @(negedge clock); @(negedge clock);
                shift = 0; @(negedge clock); @(negedge clock);
            end
            
        end
    endtask

    initial begin
        reset = 1;
        start = 0;
        shiftA = 0;
        shiftB = 0;
        shift = 0;
        do_next = 0;

        $monitor($time,, "finish=%d, end_mul=%d, shiftout=%d, start=%d, shiftA=%d, shiftB=%d, shift=%d",
            finish, end_mul, shiftout, start, shiftA, shiftB, shift);

        @(negedge clock)
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock)
        reset = 0;
        @(negedge clock)
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock)

        
        start = 1;
        @(negedge clock);
        start = 0;
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        @(negedge clock);

        repeat(100) @(negedge clock);

        for (int i = 0; i < 9; i++) begin
            shiftIn(i+2, i+3);
            repeat(20) @(negedge clock);
            do_next = 1;
            @(negedge clock)
            @(negedge clock)
            @(negedge clock)
            do_next = 0;
            repeat(100) @(negedge clock);
        end

        while (!finish) @(negedge clock);
        @(negedge clock);
        @(negedge clock);
        shiftOut();
        $display("result = %d (exp = 438)", dout);

        $finish;
    end

endmodule
