module tb_Conv();
  logic [11:0] io_in;
  logic clock, reset;
  logic [3:0] io_out;

  my_chip DUT (.*);

  initial begin
      clock = '0;
      forever #5 clock = ~clock;
  end

  initial begin
    @(posedge clock);
    reset = 1;
    $monitor ($time,, "A = %b, B = %b, out = %b",
              io_in[11:6], io_in[5:0], io_out);
    io_in = 12'b110110110110;
    @(posedge clock);
    @(posedge clock);
    reset = 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);

    $display("Done. Expect = 4'b0100");
    #1;
    $finish;
  end
endmodule: tb_Conv
