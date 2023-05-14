/*
module I2C_test;
  logic SCL, SDA, clock, reset, SDA_out;
  logic [7:0] data_in;

  I2C m1 (.SCL_in(SCL), .SDA_in(SDA), .clock, .SDA_out, .reset);
  
  task send_byte (input logic [7:0] data);
    for (int i = 7; i >= 0; i--) begin
      SDA <= data[i];
      #5
      SCL <= 1'b1;
      #8
      SCL <= 1'b0;
      #5; 
    end
    SDA = 1'b1;
    $display("\tSent byte: %h", data);
    #5;
  endtask: send_byte

  task receive_byte ();
    SDA <= 1'b1;
    for (int i = 7; i >= 0; i--) begin
      #5
      SCL <= 1'b1;
      data_in[i] <= SDA_out;
      #8
      SCL <= 1'b0;
      #5;
    end
    $display("\tReceived byte: %h", data_in);
    #5;
  endtask: receive_byte

  task send_start ();
    SDA <= 1'b1;
    #4;
    SCL <= 1'b1;
    #6;
    SDA <= 1'b0;
    #6
    SCL <= 1'b0;
    $display("Start sent");
    #5;
  endtask: send_start

  task send_stop ();
    SDA <= 1'b0;
    #4;
    SCL <= 1'b1;
    #4;
    SDA <= 1'b1;
    $display("Stop sent");
    #5;
  endtask: send_stop

  task get_ack ();
    SCL <= 1'b1;
    if (SDA_out == 1'b1) $display("\t\tSlave sent NACK");
    else $display("\t\tSlave sent ACK");
    #8;
    SCL <= 1'b0;
    #5;
  endtask: get_ack

  task send_ack ();
    SDA <= 1'b0;
    #4
    SCL <= 1'b1;
    #8;
    SCL <= 1'b0;
    #4
    SDA <= 1'b1;
    $display("\t\tMaster sent ACK");
    #5;
  endtask: send_ack

  task send_nack ();
    SDA <= 1'b1;
    #4
    SCL <= 1'b1;
    #8;
    SCL <= 1'b0;
    #4
    SDA <= 1'b0;
    $display("\t\tMaster sent NACK");
    #5;
  endtask: send_nack
  
  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end


  initial begin
    //$monitor ($time,, "SCL=%b, SDA=%b, SCL_sync=%b, data_in=%b", SCL, SDA, m1.SCL_sync, m1.M.data_in);
    reset = 1;
    SDA = 1;
    SCL = 1;
    @(posedge clock);
    #4
    @(posedge clock);
    reset = 0;
    @(posedge clock);


    send_start();
    send_byte({7'h20, 1'b0});
    get_ack();
    send_byte(8'h07); //select register
    get_ack();
    send_byte(8'h42); //send data
    get_ack();
    send_byte(8'h85); //send data
    get_ack();
    send_stop();
    #20

    send_start();
    send_byte({7'h20, 1'b0});
    get_ack();
    send_byte(8'h07); //select register
    get_ack();
    send_start();
    send_byte({7'h20, 1'b1});
    get_ack();
    receive_byte(); //receive data
    send_ack();
    receive_byte(); //receive data
    send_ack();
    receive_byte(); //receive data
    send_nack();
    send_stop();
    #40

    $finish;
  end

endmodule: I2C_test
*/