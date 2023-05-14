`default_nettype none `timescale 1ns / 1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb();
logic clock, reset;
initial begin
  clock = 0;
  forever #5 clock = ~clock;
end
  // this part dumps the trace to a vcd file that can be viewed with GTKWave
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end
  enum logic [1:0] {
    LOADPROG = 2'd0,
    LOADDATA = 2'd1,
    SETRUNPT = 2'd2,
    RUNPROG  = 2'd3
  } instruction;
  logic [3:0] datain;
  // wire up the inputs and output 
  logic [7:0] inputs;
  logic [3:0] data;
  logic [7:0] outputs;
  assign inputs = {data, instruction, reset, clock};

  // instantiate the DUT
  noahgaertner_cpu cpu_dut (
      .io_in (inputs),
      .io_out(outputs)
  );
  logic [3:0] dataList[64:0];
  logic [1:0] instructionList[64:0];
  logic [7:0] icount;
  initial begin
    dataList = {4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd15,4'd11,4'd10,4'd15,4'd15,4'd0,4'd11,4'd11,4'd3,4'd0,4'd1,4'd1,4'd11,4'd2,4'd5,4'd6,4'd2,4'd15,4'd14,4'd13,4'd12,4'd11,4'd10,4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0,4'd0};
    instructionList = {2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd3,2'd2,2'd2,2'd1,2'd1, 2'd1, 2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd1,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd2};
    $display("start");
    data = 0;
    instruction = LOADPROG;
    reset = 0;
    @(posedge clock);
    $display("reset");
    reset = 1;
    @(posedge clock);
    reset = 0;
    $display("iterate through clocks");
    for(int i = 0; i<65; i++) begin
        instruction = instructionList[i];
        icount = i;
        data = dataList[i];
        if(i==57) data[3] = 1; else data[3] = dataList[i][3];
        $display("check clock %d", i);
        @(posedge clock);
    end
    @(posedge clock);
    reset = 1;
    @(posedge clock);
    $finish;
  end
endmodule