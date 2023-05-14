`default_nettype none
`include "defines.vh"

`ifndef TEST_INPUT_DIR
  `define TEST_INPUT_DIR "tb/test_inputs/"
`endif

`define TIME_OUT 10000

module tpu_tb();
  parameter MATRIX_DIM = 16;
  parameter CONV_DIM = 3;
  parameter MATRIX_LENGTH = MATRIX_DIM*MATRIX_DIM;
  parameter CONV_LENGTH = CONV_DIM*CONV_DIM;

  logic clk, rst, insert_kernal, ready, done, write_mode, write;
  data_t data_in, data_out;
  tpu dut(.*);

  data_t kernal_data[CONV_LENGTH-1:0];
  data_t matrix_data[MATRIX_LENGTH-1:0];
  data_t result_data[MATRIX_LENGTH-1:0];
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    for (int i = 0; i < `TIME_OUT; i++) begin
      @(posedge clk);
    end
    $fatal("Timed out");
  end

  initial begin
    init();
    insert_kernal <= 1'b1;
    send_data(kernal_data);
    insert_kernal <= 1'b0;
    @(posedge clk);
    send_data(matrix_data);

    recv_data();
    fini();
  end

  task init();
    $readmemh({`TEST_INPUT_DIR, "16x16.hex"}, matrix_data);
    $readmemh({`TEST_INPUT_DIR, "3x3.hex"}, kernal_data);
    $display({`TEST_INPUT_DIR, "3x3.hex"});
    $display({`TEST_INPUT_DIR, "16x16.hex"});
    insert_kernal <= 1'b0;
    write <= 1'b0;
    write_mode <= 1'b0;
    ready <= 1'b0;
    data_in <= 1'b0;
    rst <= 1'b1;
    @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);
  endtask

  task fini();
    $writememh("out.hex", result_data);
    $finish;
  endtask
  task send_data(data_t data[]);
    write <= 1'b1;
    write_mode <= 1'b1;
    for (int i = 0; i < data.size(); i++) begin
      data_in <= data[i];
      @(posedge clk);
    end
    @(posedge clk);
    write <= 1'b0;
    @(posedge clk);
  endtask

  int idx;
  task recv_data();
    write_mode <= 1'b0;
    ready <= 1'b1;
    idx = 0;
    while (idx < MATRIX_LENGTH) begin
      @(posedge clk);
      if (done) begin
        result_data[idx++] <= data_out;
      end
    end
  endtask
endmodule : tpu_tb
