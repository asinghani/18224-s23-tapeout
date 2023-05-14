`default_nettype none

module gray2bin_test;

  logic [3:0] gray, binary_out;
  gray2bin #(4) DUT (.gray, .binary(binary_out));

  initial begin
    for(int i = 0; i < 16; i++) begin
      gray = 4'(i) ^ (4'(i) >> 1);
      #1 test_decode: assert(binary_out == 4'(i)) else
        $display("bin=%b gray=%b, got=%b", i, gray, binary_out);
    end
    #10 $finish;
  end // initial begin
endmodule // gray2bin_test

module async_fifo_test;
  parameter WIDTH=3;
  parameter DEPTH=8;

  logic [WIDTH-1:0] q[$];

  logic rst;
  logic wclk, we;
  logic full;
  logic[WIDTH-1:0] wdata;
  logic rclk, re;
  logic empty;
  logic[WIDTH-1:0] rdata;
  int wval,rval, vals_written, vals_read;
  logic rdone, wdone;

  async_fifo #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT(.*);

  initial begin
    rclk = '0;
    forever #7 rclk = ~rclk;
  end

  initial begin
    wclk = '0;
    rst = '0;
    #1 rst = '1;
    #9 rst = '0;
    forever #5 wclk = ~wclk;
  end

  parameter VALS=32;
  initial begin
    wdone = '0;
    vals_written = 0;
    wval = $urandom(240);
    we = '0;
    @(posedge wclk);
    while(vals_written < VALS) begin
      #1;
      if(~full) begin
        we <= '1;
        wval = vals_written % (2**WIDTH);// $urandom() % (2**WIDTH);
        wdata <= wval;
        q.push_front(wval);
        // vals_written++;
      end else begin
        we <= '0;
      end
      @(posedge wclk);
      if(we) vals_written++;

    end
    @(posedge wclk);
    we <= '0;
    repeat(10) @(posedge wclk);
    wdone <= '1;
  end

  initial begin
    rdone = '0;
    vals_read = 0;
    rval = -1;
    re = '0;
    @(posedge full);
    repeat(5) @(posedge rclk);
    while(vals_read < VALS)begin
      @(posedge rclk) #1;
      if(~empty) begin
        re <= '1;
        rval = q.pop_back();
        #1 assert(rdata == rval);
        vals_read++;
      end
      else begin
        re <= '0;
      end
    end
    rdone <= '1;
  end

  initial begin
    wait(rdone && wdone) $finish;
  end
endmodule
