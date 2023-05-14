`default_nettype none

//A Mealy FSM to control the state of the chip
module FSM
  (output logic clear_stop, clear_start, clear_counter, in_enable, send_ack,
   output logic reg_sel_en, reg_sel_inc, we, out_en,
   input  logic clock, start, stop, reset, counted_8, addr_valid, ACK,
   input  logic SCL_negedge,
   input  logic [7:0] data_in);
 
  //Defines the states of the FSM
  enum logic [3:0] {RESET, INIT, WAIT, ADDR, ADDR_ACK, GET_REG, REG_ACK, WRITE, READ, WRITE_ACK, READ_ACK, READ_DONE} currState, nextState;
  logic read_write;
  assign read_write = data_in[0];
 

  //nextState logic
  always_comb begin
    case (currState)
      RESET: nextState = INIT;
      INIT: nextState = WAIT;
      WAIT: nextState = (start) ? ADDR : WAIT;
      ADDR: begin
              if (counted_8) 
                nextState = (addr_valid) ? ADDR_ACK : INIT;
              else
                nextState = ADDR;
            end
      ADDR_ACK: nextState = (read_write) ? READ : GET_REG;
      GET_REG: nextState = (counted_8) ? REG_ACK : GET_REG;
      REG_ACK: nextState = WRITE;
      WRITE: nextState = (counted_8) ? WRITE_ACK : WRITE;
      WRITE_ACK: nextState = WRITE;
      READ: nextState = (counted_8) ? READ_ACK : READ;
      READ_ACK: nextState = (~ACK) ? READ_DONE : READ;
      READ_DONE: nextState = READ_DONE;
      default: begin
        nextState = INIT;
      end
    endcase
  end
 
  //Determines the output of the FSM given currState
  always_comb begin
    //default values
    clear_stop = 1'b0;
    clear_start = 1'b0;
    clear_counter = 1'b0;
    in_enable = 1'b0;
    send_ack = 1'b0;
    reg_sel_en = 1'b0;
    reg_sel_inc = 1'b0;
    we = 1'b0;
    out_en = 1'b0;
   
    case (currState)
      RESET: ;
      INIT: {clear_stop, clear_start} = 2'b11;
      WAIT: clear_counter = 1'b1;
      ADDR: {clear_start, in_enable} = 2'b11;
      ADDR_ACK: {send_ack, clear_counter} = 2'b11;
      GET_REG: in_enable = 1'b1;
      REG_ACK: {send_ack, clear_counter, reg_sel_en} = 3'b111;
      WRITE: begin
              //handles the repeated start condition used when writing the register
              //to read from, then immediately reading that register
              if (start) clear_counter = 1'b1;
              else in_enable = 1'b1;

              if (counted_8) we = 1'b1;
             end
      WRITE_ACK: {send_ack, clear_counter, reg_sel_inc} = 3'b111;
      READ: out_en = 1'b1;
      READ_ACK: {clear_counter, reg_sel_inc} = 2'b11;
      READ_DONE: ;
      default: ;
    endcase
  end
  
  //State transitions
  always_ff @(posedge clock, posedge reset) begin
    if (reset) currState <= RESET;
    else if (stop) currState <= INIT;
    else if (start) currState <= ADDR;
    else if (currState == RESET || currState == INIT) currState <= nextState;
    else if (SCL_negedge) currState <= nextState;
  end
 
endmodule: FSM
