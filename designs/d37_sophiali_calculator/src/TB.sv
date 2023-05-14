
module sophialiCMU_math_test();
  logic clock, reset, en;
  logic [2:0] in;           // can input #s 0-7
  logic [1:0] arithOp;
  logic [7:0] out;          // can output #s 0-15

  // instansiate
  sophialiCMU_math dut(.*);

  // Begin clock
  initial begin
    clock = 1'b0;
    forever #10 clock = ~clock;
  end

  initial begin
    #100000

    $display("@%0t: Error timeout!", $time);
    $finish;
  end

  // Testing values
  logic [4:0] i;
  logic [3:0] in_val;
  logic [7:0] total, want_out;
  enum logic [1:0] {ADD = 2'b00, SUB = 2'b01, XOR = 2'b10, LSH = 2'b11} op;

  initial begin
    arithOp = 2'b0;
    in = 3'b0;
    en = 1'b0;

    resetFF();

    // Test add
    $display("====== Start ADD Test ======");
    arithOp = ADD;
    total = 0;
    for (i = 0; i < 4'b1000; i++) begin
      in_val = i[3:0];
      total += in_val;
      sendVal(in_val);
      assert (out == total);
    end
    $display("====== End ADD Test ======");

    // Test sub
    $display("====== Start SUB Test ======");
    arithOp = SUB;
    for (i = 0; i < 4'b1000; i++) begin
      in_val = i[3:0];
      total -= in_val;
      sendVal(in_val);
      assert (out == total);
    end

    // Test sub overflow
    resetFF();
    arithOp = SUB;
    total = 0;
    
    for (i = 0; i < 4'b1000; i++) begin
      in_val = i[3:0];
      total -= in_val;
      sendVal(in_val);
      assert (out == total);
    end
    $display("====== End SUB Test ======");

    // Test button is stuck at en
    // Using a physical button input for enable is slower than 
    //  assigning this enable line. Test for if the FSM works to stop
    //  the math operation happening multiple times if the enable line
    //  is active for multiple clocks.
    $display("====== Start Stuck En Test ======");
    reset = 1'b0;
    reset <= 1'b1;
    reset <= #1 1'b0;
    repeat (3) @(posedge clock);
    arithOp = ADD;
    total = 0;
    for (i = 0; i < 4'b1000; i++) begin
      in_val = i[3:0];
      total += in_val;
      in = in_val;
      en <= 1'b1;
      @(posedge clock);
      @(posedge clock);
      @(posedge clock);
      en <= 1'b0;
      @(posedge clock);
      assert (out == total);
    end
    $display("====== End Stuck En Test ======"); 
    
    // Test some ^
    $display("====== Start XOR and LSH Test ======");
    resetFF();

    // Test 1101_1100 ^ 100 = 1101_1000
    want_out = 8'b1101_1100;
    getGivenOut(want_out);
    assert(out == want_out)
    @(posedge clock);

    $display("====== End XOR and LSH Test ======");   
    

    $display("@%0t: Finished!", $time);
    $finish;
  end

  task sendVal(input logic [2:0] in_val);
    in = in_val;
    en <= 1'b1;
    @(posedge clock);
    en <= 1'b0;
    @(posedge clock);
  endtask: sendVal

  task resetFF();
    reset = 1'b0;
    reset <= 1'b1;
    reset <= #1 1'b0;
    repeat (2) @(posedge clock);
  endtask: resetFF

  task getGivenOut(input logic [7:0] wantOut);
    arithOp <= ADD; 
    sendVal(wantOut[7:5]); // out = 0000_0xxx
    arithOp <= LSH; 
    sendVal(3'd3);   // out = 00xx_x000
    arithOp <= XOR; 
    sendVal(wantOut[4:2]); // out = 00xx_xyyy
    arithOp <= LSH; 
    sendVal(3'd2);   // out = xxxy_yy00
    arithOp <= XOR; 
    sendVal({1'b0, wantOut[1:0]}); // out = xxxy_yyzz
  endtask: getGivenOut

endmodule: Math_test