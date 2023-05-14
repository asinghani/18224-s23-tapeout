module jxli_fp8mul_tb;

  logic clock, reset, enable;
  logic [3:0] data;
  logic [7:0] io_in, io_out;

  assign io_in = {1'b0, data, enable, reset, clock};

  jxli_fp8mul dut(.*);

  initial begin

    clock = 1;
    forever #5 clock = ~clock;
  end

  initial begin
    $monitor("in=%b, out=%b, state=%s, a=%b, b=%b, ce=%b, cm=%b", io_in, io_out, dut.state, dut.a, dut.b, dut.ce, dut.cm);

    #10;
    reset = 1;
    #10;
    #10;
    reset = 0;
    enable = 1;
    data = 4'b0111;
    // 0 1110 111 * 0 1110 111
    // 1.111 x 2^(14 - 7) * 1.111 x 2^(14 - 7)
    // = infty
    #10;
    #10;
    #10;
    #10;
    #130;

    #10;
    reset = 1;
    #10;
    #10;
    reset = 0;
    // -20 x 3
    // 1 1010 010 * 0 1000 100
    // 1.010 x 2^(10 - 7) * 1.1 x 2^(8 - 7)
    // = -60
    data = 4'b1101;
    #10;
    data = 4'b0010;
    #10;
    data = 4'b0100;
    #10;
    data = 4'b0100;
    #10;
    #130;
    // out = -60 = 1.11100 x 2^(12 - 7)
    // = 1 1011 111

    #10;
    reset = 1;
    #10;
    #10;
    reset = 0;
    // NaN x Infty
    // 1 1111 010 * 0 1111 000
    // = NaN
    data = 4'b1111;
    #10;
    data = 4'b1010;
    #10;
    data = 4'b0111;
    #10;
    data = 4'b1000;
    #10;
    #130;
    // out = qNaN
    // = 1 1111 111



    $finish;

  end
endmodule