`default_nettype none 

//Detects the start bit on the bus
module start_detect 
 (input  logic SCL, SDA_negedge, clear_start, clock,
  output logic start);
  
  always_ff @(posedge clock, posedge clear_start)
    if (clear_start) start = 1'b0;
    else if (SCL & SDA_negedge) start = 1'b1;

endmodule: start_detect


//Detects the stop bit on the bus
module stop_detect 
 (input  logic SCL, SDA_posedge, clear_stop, clock,
  output logic stop);
  
  always_ff @(posedge clock, posedge clear_stop)
    if (clear_stop) stop = 1'b0;
    else if (SCL & SDA_posedge) stop = 1'b1;

endmodule: stop_detect


//Uses a shift register to read in the data from the I2C line
module data_input
 (input  logic SCL_posedge, SDA, enable, reset, clock,
  output logic [7:0] data_in);

  ShiftRegister_SIPO #(8) SHIFT (.serial(SDA), .clock(clock), .en(enable & SCL_posedge), 
                                 .Q(data_in), .reset);

endmodule: data_input


//Counts the # of bits sent on the bus, and sets a flag when it reaches 8
module count_8
 (input  logic clear, clock, en,
  output logic done,
  output logic [3:0] count);

  assign done = (count == 4'b1000);

  always_ff @(posedge clock, posedge clear)
    if (clear) count <= 4'b0000;
    else if ((count < 4'b1000) & en) count <= count + 4'b1;

endmodule: count_8


//Determines if the address sent is 0x20;
module check_addr
 (input logic [6:0] data_in,
  input logic [1:0] addr_sel,
  output logic addr_valid);

  logic [6:0] addr;

  assign addr_valid = (data_in == addr);

  always_comb
    unique case (addr_sel)
      2'b00: addr = 7'h20;
      2'b01: addr = 7'h21;
      2'b10: addr = 7'h22;
      2'b11: addr = 7'h23;
    endcase

endmodule: check_addr


//Sets the selected register or increments it
module reg_sel
 (input logic [4:0] sel_in,
  input logic inc, en, clock, reset, SCL_negedge,
  output logic [4:0] sel_out);

  always_ff @(posedge clock, posedge reset) begin
    if (reset) sel_out <= 5'b00000;
    else if (en & SCL_negedge) sel_out <= sel_in;
    else if (inc & SCL_negedge & sel_out < `REGCOUNT-1) sel_out <= sel_out + 5'd1;
    else if (inc & SCL_negedge) sel_out <= 5'b00000;
  end

endmodule: reg_sel

//A collection of registers to read/write from
module memory
 (input logic we, clock, reset, SCL_negedge,
  input logic [4:0] sel, 
  input logic [2:0] count,
  input logic [7:0] data_in,
  input logic [7:0] parallel_in,
  output logic data_out,
  output logic [7:0] reg_out,
  output logic [8*`REGCOUNT-1:0] registers_packed);

  logic [7:0] registers [`REGCOUNT-1:0];

  logic [2:0] index;
  logic [7:0] data_out_8, parallel_in_temp;
  
  integer i;
  integer j;

  //Packs the registers into an array so it can be outputted (when converted to verilog)
  always_comb
    for (j = 0; j < `REGCOUNT; j=j+1) registers_packed[(8*(j+1)-1)-:8] = registers[j];

  assign reg_out = registers[1];

  //Gets a bit from the selected register when writing to bus
  assign data_out = data_out_8[3'b111 - index];
  assign data_out_8 = registers[sel];

  //Writes to the selected register, resets, and sets the read only register
  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      for (i = 1; i < 32; i=i+1) registers[i] <= 8'b0; 
    end 
    else begin
      if (we & SCL_negedge & sel != 5'h0) begin
        registers[sel] <= data_in;
      end
      else if (SCL_negedge) index <= count;
    
      registers[0] <= parallel_in_temp;
      parallel_in_temp <= parallel_in;
    end
  end

endmodule: memory


//Determines if the output line should be pulled low or not
module gen_output
 (input logic  send_ack, serial_out, out_en,
  output logic SDA_out);

  always_comb
    if (send_ack) SDA_out = 1'b0;
    else if (out_en && ~serial_out) SDA_out = 1'b0;
    else SDA_out = 1'b1;

endmodule: gen_output

//Determines if an ack is set by master (or any 0 bit for that matter)
module get_ack
  (input logic SCL_posedge, SDA, clock,
   output logic ACK);

  always_ff @(posedge clock)
    if (SCL_posedge) ACK <= ~SDA;

endmodule: get_ack


//Detects the edges of a signal
module edge_detect
  (input logic sig, clock, 
   output logic sig_posedge, sig_negedge, sig_out);

  logic prev;

  assign sig_out = prev;

  always_ff @(posedge clock) begin
    if (sig & ~prev) sig_posedge <= 1'b1;
    else sig_posedge <= 1'b0;

    if (~sig & prev) sig_negedge <= 1'b1;
    else sig_negedge <= 1'b0;

    prev <= sig;
  end
endmodule: edge_detect


//A synchronizer module to synchronize an asynchronous input to a clock, as
//well as to determine clock edges
module synchronizer_edge_detect
  (input  logic async, clock,
   output logic sync, sig_posedge, sig_negedge);

  logic temp;

  DFlipFlop m1 (.D(async), .clock, .Q(temp));

  edge_detect EDGE (.sig(temp), .clock, .sig_posedge, .sig_negedge, .sig_out(sync));

endmodule: synchronizer_edge_detect