`include "internal_defines.vh"
`include "i8008_isa.vh"

`default_nettype none

module top (
    input logic clk100, // 100MHz clock
    input logic reset_n, // Active-low reset

    input logic uart_rx,
    output logic uart_tx,

    output logic [7:0] base_led, // LEDs on the far right side of the board
    output logic [23:0] led, // LEDs in the middle of the board

    input logic [23:0] sw, // The tiny slide-switches

    output logic [3:0] display_sel, // Select between the 4 segments
    output logic [7:0] display // Seven-segment display
);

  logic clk, rst;
  logic [11:0] chip_inputs, chip_outputs;
  logic [7:0] D_in, D_out;
  logic INTR, READY, Sync;
  state_t state;
  logic [1:0] display_cnt;
  logic [3:0] disp_arr [4];

  debug_harness dbg (
      .uart_rx, .uart_tx,

      .chip_inputs,
      .chip_outputs,

      .chip_clock(clk),
      .chip_reset(rst),

      .clk100
  );

  //   // 100MHz -> 25MHz
  // SB_PLL40_CORE #(
  //     .FEEDBACK_PATH("SIMPLE"),
  //     .DIVR(4'b0000),         // DIVR =  0
  //     .DIVF(7'b0000111),      // DIVF =  7
  //     .DIVQ(3'b100),          // DIVQ =  4
  //     .FILTER_RANGE(3'b101)   // FILTER_RANGE = 5
  // ) pll (
  //     .LOCK(),
  //     .RESETB(1'b1),
  //     .BYPASS(1'b0),
  //     .REFERENCECLK(clk100),
  //     .PLLOUTCORE(clk)
  // );

  always_ff @(posedge clk0) begin
    if (rst)
      display_cnt <= 2'd0;
    else
      display_cnt <= display_cnt + 1;
  end

  assign display_sel = ~(1 << display_cnt);

  hex_to_sevenseg convert (.hexdigit(disp_arr[display_cnt]), .seg(display));
  assign disp_arr[0] = chip_inputs[3:0];
  assign disp_arr[1] = chip_inputs[7:4];
  assign disp_arr[2] = chip_outputs[3:0];
  assign disp_arr[3] = chip_outputs[7:4];

  // assign D_in = sw[7:0];
  // assign INTR = sw[8];
  // assign READY = sw[9];
  //assign clk = sw[10];
  //assign rst = ~reset_n;
  //assign rst = sw[11];

  assign chip_outputs[7:0] = D_out;
  assign chip_outputs[10:8] = state;
  assign chip_outputs[11] = Sync; 
  assign D_in = chip_inputs[7:0];
  assign INTR = chip_inputs[8];
  assign READY = chip_inputs[9];


  i8008_core #(.WIDTH(8), .STACK_HEIGHT(8)) DUT (.D_in(D_in), .INTR(INTR), .READY(READY), .clk(clk), .rst(rst), .D_out(D_out), .Sync(Sync), .state(state));

  // Mirror the chip inputs and outputs to the LEDs for debugging convenience
  assign led = {rst, clk, chip_inputs[9:8], chip_outputs[10:0], chip_inputs[7:0]};
endmodule: top

module i8008_core
  #(parameter WIDTH = 8,
              STACK_HEIGHT = 8)
  (input logic [7:0] D_in,
   input logic INTR, READY, clk, rst,
   output logic [7:0] D_out,
   output logic Sync,
   output state_t state);

  logic [7:0] bus;
  logic [7:0] instr;
  logic enable_SP, Ready, tempR, Intr, S_Intr, A_rst, B_rst, IR_rst, SP_rst, IR_en, A_en;
  logic [7:0] A_in, A_out, B_in, B_out, ALU_out, DBR_out, DBR_in, PC_out, rf_out, ACC;
  ctrl_signals_t ctrl_signals;
  flags_t flags;
  logic [2:0] sel_Stack;
  cycle_t cycle;

  always_ff @(posedge clk) begin
    if (rst) begin
      Ready <= 1'b0;
      tempR <= 1'b0;
    end
    else begin
      tempR <= READY;
      Ready <= tempR;
    end

    if (rst) begin
      Intr <= 1'b0;
      S_Intr <= 1'b0;
    end
    else if (state != T1I) begin
      S_Intr <= INTR;
      Intr <= Intr | S_Intr;
    end
    else begin
      Intr <= 1'b0;
      S_Intr <= 1'b0;
    end
  end


  assign Sync = ctrl_signals.DBR.we;

  assign D_out = bus;

  always_comb begin
    if (ctrl_signals.Stack_ctrl.re_Stack) begin
      bus = PC_out | 
            (ctrl_signals.Stack_ctrl.lower ? 8'd0 : (ctrl_signals.Stack_ctrl.cycle_ctrl << 6)); // cycle ctrl should only be set on T2
    end
    else if (ctrl_signals.rf_ctrl.re) begin
      bus = rf_out | (ctrl_signals.Stack_ctrl.cycle_ctrl << 6);
    end
    else if (ctrl_signals.ALU.re) begin
      bus = ALU_out;
    end
    else if (ctrl_signals.flags.re) begin
      bus[7:4] = 4'd0;
      bus[3:0] = flags;
    end
    else if (ctrl_signals.A.re) begin
      bus = A_out;
    end
    else if (ctrl_signals.B.re) begin
      bus = B_out | (ctrl_signals.Stack_ctrl.cycle_ctrl << 6);
    end
    else if (ctrl_signals.DBR.re) begin
      bus = D_in;
    end
    else begin
      bus = 8'd0;
    end
  end

  assign IR_rst = ctrl_signals.IR.clr | rst;
  assign IR_en = ctrl_signals.IR.we | (Ready && cycle == CYCLE1);
  Register #(.WIDTH(WIDTH)) IR (.d(D_in), .Q(instr), .clk, .en(IR_en), .clear(IR_rst));

  assign A_rst = ctrl_signals.A.clr | rst;
  assign B_rst = ctrl_signals.B.clr | rst;
  assign A_en = ctrl_signals.A.we;
  assign A_in = (cycle == CYCLE1 && (state == T1 || state == T1I)) ? ACC : bus;
  Register #(.WIDTH(WIDTH)) regA (.d(A_in), .Q(A_out), .clk, .en(A_en), .clear(A_rst));
  Register #(.WIDTH(WIDTH)) regB (.d(bus), .Q(B_out), .clk, .en(ctrl_signals.B.we), .clear(B_rst));

  ALU Unit (.clk, .rst, .a(A_out), .b(B_out), .ALU_ctrl(ctrl_signals.ALU), .d(ALU_out), .flags);

  reg_file #(.WIDTH(WIDTH), .HEIGHT(7)) rf (.clk, .rst, .bus, .ACC, .rf_out, .rf_ctrl(ctrl_signals.rf_ctrl));

  assign enable_SP = ctrl_signals.SP_ctrl.en_SP &
                     ~((sel_Stack == 3'd0) & ~ctrl_signals.SP_ctrl.inc_SP) &
                     ~((sel_Stack == 3'd7) & ctrl_signals.SP_ctrl.inc_SP);
  assign SP_rst = ctrl_signals.SP_ctrl.clr_SP | rst;
  Counter #(.WIDTH(3)) SP_SEL
    (.load(1'd0), .clk, .d(3'd0), .Q(sel_Stack),
    .en(enable_SP),
    .clear(SP_rst),
    .up(ctrl_signals.SP_ctrl.inc_SP));

  stack #(.WIDTH(14), .HEIGHT(STACK_HEIGHT)) Stack
    (.clk, .rst, .PC_out, .bus, .sel(sel_Stack),
     .Stack_ctrl(ctrl_signals.Stack_ctrl));

  fsm_decoder Brain (.clk, .Ready, .Intr, .rst, .instr(instr_t'(instr)), .flags, .ctrl_signals, .state, .cycle);

endmodule: i8008_core

module ALU
   #(parameter WIDTH = 8)
    (input logic [7:0] a, b,
     input ALU_ctrl_t ALU_ctrl,
     input clk, rst,
     output logic [7:0] d,
     output flags_t flags);

  logic [7:0] add_tmp;
  logic [7:0] art_tmp;
  flags_t flag_in;

  logic [7:0] NA;

  logic Flag_rst;
  assign Flag_rst = rst | ALU_ctrl.clr_Flag;

  FlagRegister #(.WIDTH(4))
    flag_reg (.d(flag_in), .Q(flags), .clk, .en(ALU_ctrl.en_Flag), .clear(Flag_rst));

  always_comb begin
    flag_in[0] = 1'b0;
    NA = 'd0;
    d = 'd0;
    if (ALU_ctrl.ARITH) begin
      unique case (ALU_ctrl.arith_op)
        ADD1_op: begin
          d = a + 1;
          flag_in[0] = flags[0];
        end
        SUB1_op: begin
          d = a - 1;
          flag_in[0] = flags[0];
        end
        RLC_op: begin
          d = {a[6:0], a[7]};
          flag_in[0] = a[7];
        end
        RRC_op: begin
          d = {a[0], a[7:1]};
          flag_in[0] = a[0];
        end
        RAL_op: begin
          d = {a[6:0], flags[0]};
          flag_in[0] = a[7];
        end
        RAR_op: begin
          d = {flags[0], a[7:1]};
          flag_in[0] = a[0];
        end
      endcase
    end
    else begin
      d = 'd0;
      unique case (ALU_ctrl.alu_op)
        ADD_op: begin
          {flag_in[0], d} = a + b;
        end
        ADDC_op: begin
          {flag_in[0], d} = a + b + flags[0];
        end
        SUB_op: begin
          {flag_in[0], d} = a - b;
        end
        SUBC_op: begin
          {flag_in[0], d} = a - b - flags[0];
        end
        AND_op: d = a & b;
        OR_op: d = a | b;
        XOR_op: d = a ^ b;
        CMP_op: begin
          {flag_in[0], NA} = a - b; // Will set borrow bit on some subtractions
          d = a;
        end
        default: d = 'b0;
      endcase
    end

    if (ALU_ctrl.ARITH) begin
      flag_in[1] = (ALU_ctrl.arith_op == ADD1_op || ALU_ctrl.arith_op == SUB1_op) ? 
                   (~(|d)) : flags[1];
      flag_in[2] = (ALU_ctrl.arith_op == ADD1_op || ALU_ctrl.arith_op == SUB1_op) ? 
                   d[7] : flags[2];
      flag_in[3] = (ALU_ctrl.arith_op == ADD1_op || ALU_ctrl.arith_op == SUB1_op) ? 
                   ~(^d) : flags[3];
    end
    else begin
      flag_in[1] = (ALU_ctrl.alu_op != CMP_op) ? (~(|d)) : (~(|NA));
      flag_in[2] = (ALU_ctrl.alu_op != CMP_op) ? d[7] : NA[7];
      flag_in[3] = (ALU_ctrl.alu_op != CMP_op) ? ~(^d) : ~(^NA);
    end

  end
endmodule: ALU

module fsm_decoder
  (input logic clk, Ready, Intr, rst,
   input instr_t instr,
   input flags_t flags,
   output ctrl_signals_t ctrl_signals,
   output state_t state,
   output cycle_t cycle);

  logic [2:0] SSS, DDD;
  logic [2:0] D5_3;

  assign SSS = instr[2:0];
  assign DDD = instr[5:3];
  assign D5_3 = instr[5:3];
  cycle_t next_cycle;
  state_t next_state;

  logic CF;

  // Should flags be one hot, or fully encoded?
  always_comb begin
    unique case (instr[4:3])
      Ca: CF = ~flags[0];
      Ze: CF = ~flags[1];
      Si: CF = ~flags[2];
      Pa: CF = ~flags[3]; // Parity of result is even
      default: CF = 1'b1;
    endcase
  end

  always_comb begin
    next_cycle = cycle;
    ctrl_signals = 'd0; // Should these be initialized to X's? No, apparently doesn't minimize logic
    unique case (cycle)
      CYCLE1: begin
        unique case (state)
          T1, T1I: begin // INCR PC??
            next_state = T2;

            ctrl_signals.DBR.we = 1'b1;
            ctrl_signals.Stack_ctrl.re_Stack = 1'b1;
            ctrl_signals.Stack_ctrl.lower = PC_L;

            ctrl_signals.A.we = 1'b1;
          end
          T2: begin
            next_state = Ready ? T3 : WAIT;

            ctrl_signals.DBR.we = 1'b1;
            ctrl_signals.Stack_ctrl.re_Stack = 1'b1;
            ctrl_signals.Stack_ctrl.lower = PC_H;

            ctrl_signals.Stack_ctrl.cycle_ctrl = PCI;

            ctrl_signals.Stack_ctrl.inc_PC = 1'b1;   // Increment PC here and not T1 so it doesn't affect PC_H
          end
          WAIT: begin
            next_state = Ready ? T3 : WAIT;
          end
          T3, STOPPED: begin
            if (instr == RST) begin // TODO: Replace with anything or is this fine?
              ctrl_signals.B.we = 1'b1;
              ctrl_signals.A.clr = 1'b1;
              ctrl_signals.SP_ctrl.inc_SP = 1'b1;
              ctrl_signals.SP_ctrl.en_SP = 1'b1;
              ctrl_signals.DBR.re = 1'b1;
            end
            else begin
              ctrl_signals.B.we = 1'b1;
              ctrl_signals.DBR.re = 1'b1;
            end

            unique casez (instr)
              HLT0, HLT1, LrM: begin
                if (instr[7] && D5_3 != 3'b111) begin
                  next_cycle = CYCLE2;
                  next_state = T1;
                end
                else begin
                  if (Intr) begin
                    next_state = T1I; // Go to "T1I" next
                    next_cycle = CYCLE1;
                  end
                  else begin
                    next_state = STOPPED; // STOPPED STATE
                  end
                end
              end
              RFc, RTc: begin  // Conditional return only?
                if ((instr[5] & ~CF) | (~instr[5] & CF)) begin
                  next_state =  T4; // WAIT state
                end
                else begin
                  next_cycle = CYCLE1;
                  next_state = T1;
                end
              end
              ALUM, ALUI, INP, OUT, LrI, JMP, JFc, JTc, CAL, CTc, CFc: begin
                next_cycle = CYCLE2;
                next_state = T1;
              end
              default: begin
                next_state = T4;
              end
            endcase
          end
          T4: begin
            unique casez (instr)
              Lr1r2, LMr, ALU_op: begin
                // Deal with LrM case? No, it shouldn't get here
                // Deal with other ALU cases? Nope, shouldn't get here
                // if (SSS != 3'b111) begin
                  ctrl_signals.B.we = 1'b1;
                  ctrl_signals.rf_ctrl.re = 1'b1;
                  ctrl_signals.rf_ctrl.sel = SSS;
                  // ctrl_signals.DBR.we = 1'b1;
                // end
              end
              INr, DCr: begin
                // Deal with HALT case and mem case for INr/DCr? No, shouldn't get here
                ctrl_signals.rf_ctrl.re = 1'b1;
                ctrl_signals.rf_ctrl.sel = DDD;
                ctrl_signals.A.we = 1'b1;
              end
              RLC, RRC, RAL, RAR: begin
                // read Accum into A alu reg
                // TODO: Remove A.we, should already be there
                ctrl_signals.rf_ctrl.re = 1'b1;
                ctrl_signals.rf_ctrl.sel = Acc;
                ctrl_signals.A.we = 1'b1;
              end
              RET, RFc, RTc: begin // Pop stack
                ctrl_signals.SP_ctrl.inc_SP = 1'b0;
                ctrl_signals.SP_ctrl.en_SP = 1'b1;
              end
              RST: begin
                ctrl_signals.A.re = 1'b1;
                ctrl_signals.Stack_ctrl.lower = 1'b0;
                ctrl_signals.Stack_ctrl.we_Stack = 1'b1;
              end
              default: begin
                // Do nothing!
                // if (instr[7:6] == 2'b10) begin
                //   ctrl_signals.B.we = 1'b1;
                //   ctrl_signals.rf_ctrl.re = 1'b1;
                //   ctrl_signals.rf_ctrl.sel = SSS;
                // end
              end
            endcase

            if (instr[7:3] == 5'b11_111) begin // LMr case
              next_state = T1;
              next_cycle = CYCLE2;
            end
            else begin
              next_state = T5;
            end
          end
          T5: begin
            unique casez (instr)
              Lr1r2: begin
                ctrl_signals.B.re = 1'b1;
                ctrl_signals.rf_ctrl.we = 1'b1;
                ctrl_signals.rf_ctrl.sel = DDD;
              end
              RST: begin
                ctrl_signals.B.re = 1'b1;
                ctrl_signals.Stack_ctrl.we_Stack = 1'b1;
                ctrl_signals.Stack_ctrl.lower = 1'b1; // What to do here since only want D5-3?
                ctrl_signals.Stack_ctrl.D5_3 = 1'b1;
              end
              INr, DCr: begin
                ctrl_signals.rf_ctrl.we = 1'b1;
                ctrl_signals.rf_ctrl.sel = DDD;
                ctrl_signals.ALU.arith_op = (instr[2:0] == 3'b000) ? ADD1_op : SUB1_op;
                ctrl_signals.ALU.ARITH = 1'b1;
                ctrl_signals.ALU.re = 1'b1;
                ctrl_signals.ALU.en_Flag = 1'b1;
              end
              ALU_op: begin
                ctrl_signals.rf_ctrl.we = 1'b1;
                ctrl_signals.rf_ctrl.sel = Acc;
                ctrl_signals.ALU.alu_op = alu_op_t'(D5_3); // Enter ops for ALU commands
                //ctrl_signals.ALU.alu_op = D5_3; // Enter ops for ALU commands
                ctrl_signals.ALU.ARITH = 1'b0;
                ctrl_signals.ALU.re = 1'b1;
                ctrl_signals.ALU.en_Flag = 1'b1;
              end
              RLC, RRC, RAL, RAR: begin
                ctrl_signals.rf_ctrl.we = 1'b1;
                ctrl_signals.rf_ctrl.sel = Acc;
                ctrl_signals.ALU.arith_op = arith_op_t'(D5_3); // Enter ops for rotate commands
                //ctrl_signals.ALU.arith_op = D5_3; // Enter ops for rotate commands
                ctrl_signals.ALU.ARITH = 1'b1;
                ctrl_signals.ALU.re = 1'b1;
                ctrl_signals.ALU.en_Flag = 1'b1;
              end
              //RET, RFc, RTc: // do nothing!
              default: begin // do nothing!
              end
            endcase

            next_state = T1;
            next_cycle = CYCLE1;
          end
          default: begin
            next_state = T1;
            next_cycle = CYCLE1;
          end
        endcase
      end
      CYCLE2: begin
        unique case (state)
          T1, T1I: begin
            next_state = T2;

            unique casez (instr)
              LMI, LrI, ALUI, JMP, JFc, JTc, CAL, CTc, CFc: begin
                ctrl_signals.Stack_ctrl.re_Stack = 1'b1;
                ctrl_signals.Stack_ctrl.lower = 1'b1;
                ctrl_signals.DBR.we = 1'b1;
              end
              LrM, LMr, ALUM: begin
                ctrl_signals.rf_ctrl.re = 1'b1;
                ctrl_signals.rf_ctrl.sel = Lo;
                ctrl_signals.DBR.we = 1'b1;
              end
              INP, OUT: begin
                ctrl_signals.A.re = 1'b1;
                ctrl_signals.DBR.we = 1'b1;
              end
              default: begin
              end
            endcase
          end
          T2: begin
            next_state = Ready ? T3 : WAIT;

            unique casez (instr)
              LMI, LrI, ALUI, JMP, JFc, JTc, CAL, CTc, CFc: begin
                ctrl_signals.Stack_ctrl.re_Stack = 1'b1;
                ctrl_signals.DBR.we = 1'b1;
                ctrl_signals.Stack_ctrl.cycle_ctrl = PCR;
                ctrl_signals.Stack_ctrl.lower = 1'b0;
                ctrl_signals.Stack_ctrl.inc_PC = 1'b1;   // Increment PC here and not T1 so it doesn't affect PC_H
              end
              LrM, LMr, ALUM: begin
                ctrl_signals.rf_ctrl.re = 1'b1;
                ctrl_signals.rf_ctrl.sel = Hi;
                ctrl_signals.Stack_ctrl.cycle_ctrl = (instr[7:3] == 5'b11_111) ? PCW : PCR; // LMr case
                ctrl_signals.Stack_ctrl.lower = 1'b0;
                ctrl_signals.DBR.we = 1'b1;
              end
              INP, OUT: begin
                ctrl_signals.Stack_ctrl.cycle_ctrl = PCC;
                ctrl_signals.Stack_ctrl.lower = 1'b0;
                ctrl_signals.B.re = 1'b1;
                ctrl_signals.DBR.we = 1'b1;
              end
              default: begin
              end
            endcase
          end
          WAIT: begin
            next_state = Ready ? T3 : WAIT;
          end
          T3, STOPPED: begin
            unique casez (instr)
              OUT, LMr: begin
                next_cycle = CYCLE1;
                next_state = T1;
              end
              LMI, JMP, JFc, JTc, CAL, CTc, CFc: begin
                next_state = T1;
                next_cycle = CYCLE3;
              end
              default: begin
                next_state = T4; // WAIT state
              end
            endcase

            unique casez (instr)
              INP, ALUM, ALUI, LrM, LMI, LrI, JMP, JFc, JTc, CAL, CTc, CFc: begin
                // For control flow instructions, this is the lower address
                ctrl_signals.DBR.re = 1'b1;
                ctrl_signals.B.we = 1'b1;
              end
              LMr: begin
                ctrl_signals.DBR.we = 1'b1;
                ctrl_signals.B.re = 1'b1;
              end
              // OUT: begin
              //   // do nothing!
              // end
              default: begin // do nothing!
              end
            endcase
          end
          T4: begin
            next_state = T5;

            if (instr[7:4] == 4'b0100 && instr[0]) begin // INP case
              ctrl_signals.DBR.we = 1'b1;
              ctrl_signals.flags.re = 1'b1; // Write flags into output
            end
            // else do nothing!
          end
          T5: begin
            next_state = T1;
            next_cycle = CYCLE1;

            unique casez (instr)
              LrM, LrI, INP: begin
                ctrl_signals.B.re = 1'b1;
                ctrl_signals.rf_ctrl.sel = (instr[7:4] == 4'b0100 && instr[0]) ? Acc : DDD; // INP case
                ctrl_signals.rf_ctrl.we = 1'b1;
              end
              ALUM, ALUI: begin
                // Execute alu op and affect flags
                ctrl_signals.rf_ctrl.sel = Acc;
                ctrl_signals.rf_ctrl.we = 1'b1;
                ctrl_signals.ALU.alu_op = alu_op_t'(D5_3);  // Set alu op based on instruction, add arith op?
                //ctrl_signals.ALU.alu_op = D5_3;  // Set alu op based on instruction, add arith op?
                ctrl_signals.ALU.ARITH = 1'b0;
                ctrl_signals.ALU.re = 1'b1;
                ctrl_signals.ALU.en_Flag = 1'b1;
              end
              default: begin
              end
            endcase
          end
          default: begin
            next_cycle = CYCLE1;
            next_state = T1;
          end
        endcase
      end
      CYCLE3: begin
        unique case (state)
          T1, T1I: begin
            next_state = T2;

            unique casez (instr)
              LMI: begin
                ctrl_signals.rf_ctrl.sel = Lo;
                ctrl_signals.rf_ctrl.re = 1'b1;
                ctrl_signals.DBR.we = 1'b1;
              end
              JMP, JFc, JTc, CAL, CTc, CFc: begin
                ctrl_signals.Stack_ctrl.re_Stack = 1'b1;
                ctrl_signals.Stack_ctrl.lower = 1'b1;
                ctrl_signals.DBR.we = 1'b1;
              end
              default: begin
              end
            endcase
          end
          T2: begin
            next_state = Ready ? T3 : WAIT;

            unique casez (instr)
              LMI: begin
                ctrl_signals.rf_ctrl.sel = Hi;
                ctrl_signals.rf_ctrl.re = 1'b1;
                ctrl_signals.DBR.we = 1'b1;
                ctrl_signals.Stack_ctrl.cycle_ctrl = PCW;
                ctrl_signals.Stack_ctrl.lower = 1'b0;
              end
              JMP, JFc, JTc, CAL, CTc, CFc: begin
                ctrl_signals.Stack_ctrl.re_Stack = 1'b1;
                ctrl_signals.Stack_ctrl.lower = 1'b0;
                ctrl_signals.DBR.we = 1'b1;
                ctrl_signals.Stack_ctrl.cycle_ctrl = PCR;
                ctrl_signals.Stack_ctrl.inc_PC = 1'b1;   // Increment PC here and not T1 so it doesn't affect PC_H
              end
              default: begin
              end
            endcase
          end
          WAIT: begin
            next_state = Ready ? T3 : WAIT;
          end
          T3, STOPPED: begin
            unique casez (instr)
              LMI: begin
                next_state = T1;
                next_cycle = CYCLE1;
              end
              CAL: begin
                ctrl_signals.SP_ctrl.inc_SP = 1'b1;
                ctrl_signals.SP_ctrl.en_SP = 1'b1; 
                next_state = T4; 
              end
              JFc, CFc: begin
                if (~CF) begin
                  next_state = T1;
                  next_cycle = CYCLE1;
                end
                else begin
                  if (instr[7:5] == 3'b010 && instr[2:0] == 3'b010) begin    // CFc case
                    ctrl_signals.SP_ctrl.inc_SP = 1'b1;
                    ctrl_signals.SP_ctrl.en_SP = 1'b1;
                  end
                  next_state = T4; 
                end
              end
              JTc, CTc: begin
                if (CF) begin
                  next_state = T1;
                  next_cycle = CYCLE1;
                end
                else begin
                  if (instr[7:5] == 3'b011 && instr[2:0] == 3'b010) begin    // CTc case
                    ctrl_signals.SP_ctrl.inc_SP = 1'b1;
                    ctrl_signals.SP_ctrl.en_SP = 1'b1;
                  end
                  next_state = T4; 
                end
              end
              default: next_state = T4; 
            endcase

            unique casez (instr)
              LMI: begin
                ctrl_signals.B.re = 1'b1;
                ctrl_signals.DBR.we = 1'b1;
              end
              JMP, JFc, JTc, CAL, CTc, CFc: begin
                ctrl_signals.A.we = 1'b1;
                ctrl_signals.DBR.re = 1'b1;
              end
              default: begin
              end
            endcase
          end
          T4: begin
            next_state = T5;

            unique casez (instr)
              CAL, CTc, CFc: begin // Is there an issue where the stack isn't pushed early enough?
                ctrl_signals.A.re = 1'b1;
                ctrl_signals.Stack_ctrl.we_Stack = 1'b1;
                  // ((instr[7:6] == 2'b01 && instr[2:0] == 3'b110) |          // CAL case
                  // ((instr[7:5] == 3'b011 && instr[2:0] == 3'b010) & ~CF) | // CTc case
                  // ((instr[7:5] == 3'b010 && instr[2:0] == 3'b010) & CF));    // CFc case
                ctrl_signals.Stack_ctrl.lower = 1'b0;

                  // ((instr[7:6] == 2'b01 && instr[2:0] == 3'b110) |          // CAL case
                  // ((instr[7:5] == 3'b011 && instr[2:0] == 3'b010) & ~CF) | // CTc case
                  // ((instr[7:5] == 3'b010 && instr[2:0] == 3'b010) & CF));    // CFc case
              end
              JMP, JFc, JTc: begin
                ctrl_signals.A.re = 1'b1;
                ctrl_signals.Stack_ctrl.we_Stack = 1'b1;
                  // ((instr[7:6] == 2'b01 && instr[2:0] == 3'b100) |          // JMP case
                  // ((instr[7:5] == 3'b011 && instr[2:0] == 3'b000) & ~CF) | // JTc case
                  // ((instr[7:5] == 3'b010 && instr[2:0] == 3'b000) & CF));    // JFc case
                ctrl_signals.Stack_ctrl.lower = 1'b0;
              end
              default: begin
              end
            endcase
          end
          T5: begin
            next_state = T1;
            next_cycle = CYCLE1;

            unique casez (instr)
              CAL, CTc, CFc, JMP, JFc, JTc: begin // Is there an issue where the stack isn't pushed early enough?
                ctrl_signals.B.re = 1'b1;
                ctrl_signals.Stack_ctrl.we_Stack = 1'b1;
                ctrl_signals.Stack_ctrl.lower = 1'b1;
              end
              default: begin
              end
            endcase
          end
          default: begin
            next_state = T1;
            next_cycle = CYCLE1;
          end
        endcase
      end
      default: begin
        next_state = T1;
        next_cycle = CYCLE1;
        ctrl_signals = 'd0;
      end
    endcase
  end


  always_ff @(posedge clk) begin
    if (rst) begin
      cycle <= CYCLE1;
      state <= T1;
    end
    else begin
      cycle <= next_cycle;
      state <= next_state;
    end
  end

endmodule: fsm_decoder

// Module for storing large amounts of information
module reg_file
#(parameter WIDTH = 8,
            HEIGHT = 7,
            SEL = $clog2(HEIGHT))
(input logic [7:0] bus,
 input logic clk, rst,
 input rf_ctrl_t rf_ctrl,
 output logic [7:0] rf_out, ACC);

  logic [7:0] rf[7];
  logic [7:0] rs;

  logic [2:0] sel;
  assign sel = rf_ctrl.sel == 3'b111 ? 3'd0 : rf_ctrl.sel;

  assign rf_out = rs;
  assign ACC = rf[0];

  always_ff @(posedge clk) begin
    if (rst) begin
      rf[3'd0] <= 8'd0;
      rf[3'd1] <= 8'd0;
      rf[3'd2] <= 8'd0;
      rf[3'd3] <= 8'd0;
      rf[3'd4] <= 8'd0;
      rf[3'd5] <= 8'd0;
      rf[3'd6] <= 8'd0;
    end
    else if (rf_ctrl.we && rf_ctrl.sel != 3'b111)
      rf[rf_ctrl.sel] <= bus;
  end

  always_comb
    rs = rf[sel];

endmodule: reg_file

module stack
#(parameter WIDTH = 14,
            BUS_WIDTH = 8,
            HEIGHT = 8,
            SEL = $clog2(HEIGHT))
(input logic [7:0] bus,
 input logic [2:0] sel,
 input logic clk, rst,
 input Stack_ctrl_t Stack_ctrl,
 output logic [7:0] PC_out);

  logic [13:0] rf[8];  // TODO: may have to make 1D array
  logic [13:0] rs;
  logic [7:0] upper, RST_AAA;

  assign upper = {2'd0, rs[13:8]};
  assign PC_out = (Stack_ctrl.lower ? rs[7:0] : upper);

  assign RST_AAA[5:3] = bus[5:3];
  assign RST_AAA[2:0] = 3'd0;
  assign RST_AAA[7:6] = 2'd0;

  always_ff @(posedge clk) begin
    if (rst) begin
      rf[3'd0] <= 14'd0;
      rf[3'd1] <= 14'd0;
      rf[3'd2] <= 14'd0;
      rf[3'd3] <= 14'd0;
      rf[3'd4] <= 14'd0;
      rf[3'd5] <= 14'd0;
      rf[3'd6] <= 14'd0;
      rf[3'd7] <= 14'd0;
    end
    else if (Stack_ctrl.we_Stack && Stack_ctrl.lower)
      rf[sel] <= Stack_ctrl.D5_3 ? {8'd0, RST_AAA} : {rf[sel][13:8], bus};
    else if (Stack_ctrl.we_Stack && ~Stack_ctrl.lower)
      rf[sel] <= {bus[5:0], rf[sel][7:0]};
    else if (Stack_ctrl.inc_PC)
      rf[sel] <= rf[sel] + 1;
  end

  always_comb begin
    rs = rf[sel];
  end

endmodule: stack

module Register
 #(parameter WIDTH = 8)
  (input logic en, clear, clk,
   input logic [7:0] d,
   output logic [7:0] Q);

  always_ff @(posedge clk) begin
    if (clear)
      Q <= 'd0;
    else if (en)
      Q <= d;
  end
endmodule: Register

module FlagRegister
 #(parameter WIDTH = 4)
  (input logic en, clear, clk,
   input logic [3:0] d,
   output logic [3:0] Q);

  always_ff @(posedge clk) begin
    if (clear)
      Q <= 'd0;
    else if (en)
      Q <= d;
  end
endmodule: FlagRegister

module Counter
 #(parameter WIDTH = 3)
  (input logic en, clear, load, up, clk,
   input logic [2:0] d,
   output logic [2:0] Q);

   always_ff @(posedge clk) begin
     if (clear)
       Q <= 'd0;
     else if (load)
       Q <= d;
     else if (en && up)
       Q <= Q + 1;
     else if (en && ~up)
       Q <= Q - 1;
   end
endmodule: Counter

module Stabilizer
  (input logic D, clk,
   output logic Q);
  logic temp;

  always_ff @(posedge clk) begin
    temp <= D;
    Q <= temp;
  end
endmodule: Stabilizer

`default_nettype wire
