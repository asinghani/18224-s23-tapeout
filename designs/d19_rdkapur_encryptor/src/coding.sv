`default_nettype none

module mychip_wrapper(
  input logic [1:0] mode_sel,
  input logic [3:0] display_sel,
  input logic in_bit,
  input logic ready,
  input logic clock,
  input logic reset, 

  output logic [7:0] hex_out
);
  
  logic [15:0] key;
  logic [15:0] intxt;
  logic [15:0] outtxt_de, outtxt; 

  logic key_en, intxt_en;
  logic key_load, intxt_load; 

  logic FSMen; 
  //Key Register
  ShiftRegister_SIPO #(16) keyReg(.serial(in_bit), .en(key_en & FSMen), .left(1'b1), .clock(clock), .Q(key));

  //intxt Register
  ShiftRegister_SIPO #(16) intxtReg(.serial(in_bit), .en(intxt_en & FSMen), .left(1'b1), .clock(clock), .Q(intxt));

  decrypt de(.intxt(intxt), .KEY(key), .outputtxt(outtxt));
  encrypt en(.intxt(intxt), .KEY(key), .outputtxt(outtxt_de));

  //take bit FSM
  enum logic {IDLE = 1'b1, TAKE = 1'b0} currState, nextState; 
  //nextState assignment
  always_comb begin
    case(currState)
      IDLE: nextState = ready ? TAKE : IDLE;
      TAKE: nextState = ready ? TAKE : IDLE; 
      default: nextState = IDLE; 
    endcase
  end

  //control point assignment
  always_comb begin
    case(currState)
      IDLE: FSMen = ready;
      TAKE: FSMen = 1'b0; 
    endcase
  end

  always_ff @(posedge clock) begin
    if(reset)
      currState <= IDLE;
    else
      currState <= nextState;
  end

  //mode select
  always_comb begin
    case (mode_sel)
      2'b01: begin
        key_en = 1'b1;
        intxt_en = 1'b0;
      end
      2'b10: begin
        key_en = 1'b0;
        intxt_en = 1'b1;
      end
      default: begin
        key_en = 1'b0;
        intxt_en = 1'b0;
      end
    endcase
  end


  //FSM for inputting
  
  
  logic [7:0] intxt_hex1, intxt_hex2, intxt_hex3, intxt_hex4;
  logic [7:0] key_hex1, key_hex2, key_hex3, key_hex4;
  logic [7:0] outtxt_hex1, outtxt_hex2, outtxt_hex3, outtxt_hex4; 
  logic [7:0] outtxt_de_hex1, outtxt_de_hex2, outtxt_de_hex3, outtxt_de_hex4;

  //hex assignment 
  hex_to_sevenseg i1(intxt[3:0], intxt_hex1),
                    i2(intxt[7:4], intxt_hex2),
                    i3(intxt[11:8], intxt_hex3),
                    i4(intxt[15:12], intxt_hex4),
                    i5(key[3:0], key_hex1),
                    i6(key[7:4], key_hex2),
                    i7(key[11:8], key_hex3),
                    i8(key[15:12], key_hex4),
                    i9(outtxt[3:0], outtxt_hex1),
                    i10(outtxt[7:4], outtxt_hex2),
                    i11(outtxt[11:8], outtxt_hex3),
                    i12(outtxt[15:12], outtxt_hex4),
                    i13(outtxt_de[3:0], outtxt_de_hex1),
                    i14(outtxt_de[7:4], outtxt_de_hex2),
                    i15(outtxt_de[11:8], outtxt_de_hex3),
                    i16(outtxt_de[15:12], outtxt_de_hex4);
                    

  //assign hex output 
  always_comb begin
    case(display_sel)
      //intxt display
      4'b0000: hex_out = intxt_hex1;
      4'b0001: hex_out = intxt_hex2;
      4'b0010: hex_out = intxt_hex3;
      4'b0011: hex_out = intxt_hex4;
      //key display
      4'b0100: hex_out = key_hex1;
      4'b0101: hex_out = key_hex2; 
      4'b0110: hex_out = key_hex3;
      4'b0111: hex_out = key_hex4;
      //outxt display
      4'b1000: hex_out = outtxt_hex1;
      4'b1001: hex_out = outtxt_hex2;
      4'b1010: hex_out = outtxt_hex3;
      4'b1011: hex_out = outtxt_hex4;
      //decrypt out display
      4'b1100: hex_out = outtxt_de_hex1;
      4'b1101: hex_out = outtxt_de_hex2;
      4'b1110: hex_out = outtxt_de_hex3;
      4'b1111: hex_out = outtxt_de_hex4; 
    endcase
  end

endmodule : mychip_wrapper

module hex_to_sevenseg (
    input logic [3:0] hexdigit,
    output logic [7:0] seg
);

    always_comb begin
        seg = '1;
        if (hexdigit == 4'h0) seg = 8'b1100_0000;
        if (hexdigit == 4'h1) seg = 8'b1111_1001;
        if (hexdigit == 4'h2) seg = 8'b1010_0100;
        if (hexdigit == 4'h3) seg = 8'b1011_0000;
        if (hexdigit == 4'h4) seg = 8'b1001_1001;
        if (hexdigit == 4'h5) seg = 8'b1001_0010;
        if (hexdigit == 4'h6) seg = 8'b1000_0010;
        if (hexdigit == 4'h7) seg = 8'b1111_1000;
        if (hexdigit == 4'h8) seg = 8'b1000_0000;
        if (hexdigit == 4'h9) seg = 8'b1001_0000;
        if (hexdigit == 4'hA) seg = 8'b1000_1000;
        if (hexdigit == 4'hB) seg = 8'b1000_0011;
        if (hexdigit == 4'hC) seg = 8'b1100_0110;
        if (hexdigit == 4'hD) seg = 8'b1010_0001;
        if (hexdigit == 4'hE) seg = 8'b1000_0110;
        if (hexdigit == 4'hF) seg = 8'b1000_1110;
    end

endmodule


module encrypt(
  input logic [15:0] intxt,
  input logic [15:0] KEY,
  output logic[15:0] outputtxt
);

  logic [7:0] P1, P2, P3, P4, P5, P6, P7, P8;
  logic [7:0] p1start, p2start, p3start, p4start, p5start, p6start, p7start, p8start; 
 
  assign p1start = 8'b0010_0100;
  assign p2start = 8'b0011_1111;
  assign p3start = 8'b0110_1010;
  assign p4start = 8'b1000_1000;
  assign p5start = 8'b1000_0101;
  assign p6start = 8'b1010_0011; 
  assign p7start = 8'b0000_1000;
  assign p8start = 8'b1101_0011; 
  
  //Set P keys
  always_comb begin
    P1 = p1start ^ KEY [7:0];
    P2 = p2start ^ KEY [15:8] ^ P1;
    P3 = p3start ^ KEY [7:0] ^ P2;
    P4 = p4start ^ KEY [15:8] ^ P3;
    P5 = p5start ^ KEY [7:0] ^ P4;
    P6 = p6start ^ KEY [15:8] ^ P5;
    P7 = p7start ^ KEY [7:0] ^ P6;
    P8 = p8start ^ KEY [15:8] ^ P7;
  end

  logic [7:0] s11, s12, s13, s14, s21, s22, s23, s24, s31, s32, s33, s34, s41, s42, s43, s44;
  //Set S Boxes
  always_comb begin
    s11 = 8'b0001_0011 ^ KEY [7:0];
    s12 = 8'b0001_1001 ^ KEY [15:8] ^ s11;
    s13 = 8'b1000_1010 ^ KEY [7:0] ^ s12;
    s14 = 8'b1000_1010 ^ KEY [15:8] ^ s13; 
    
    s21 = 8'b0000_0011 ^ KEY [7:0] ^ s14; 
    s22 = 8'b0111_0000 ^ KEY [15:8] ^ s21;
    s23 = KEY [7:0] ^ s22 ^ 8'b0111_0011;
    s24 = KEY [15:8] ^ s23 ^ 8'b0100_0100;
    
    s31 = KEY [7:0] ^ s24 ^ 8'b1010_0100;
    s32 = KEY [15:8] ^ s31 ^ 8'b0000_1001;
    s33 = KEY [7:0] ^ s32 ^ 8'b0011_1000;
    s34 = KEY [15:8] ^ s33 ^ 8'b0010_0010;
    
    s41 = KEY [7:0] ^ s34 ^ 8'b0010_1001;
    s42 = KEY [15:8] ^ s41 ^ 8'b1001_1111;
    s43 = KEY [7:0] ^ s42 ^ 8'b0011_0001;
    s44 = KEY [15:8] ^ s43 ^ 8'b1101_0000; 
     
  end

   //Set output
   logic [15:0] temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8;
   

  
   //s box selection
  logic [7:0] sub11, sub12, sub13, sub14, sub21, sub22, sub23, sub24, sub31, sub32, sub33, sub34, sub41, sub42, sub43, sub44, sub51, sub52, sub53, sub54, sub61, sub62, sub63, sub64, sub71, sub72, sub73, sub74, sub81, sub82, sub83, sub84;

  Mux41      sub1(intxt[15:14], s11, s12, s13, s14, sub11),
             sub2(intxt[13:12], s21, s22, s23, s24, sub12),
             sub3(intxt[11:10], s31, s32, s33, s34, sub13),
             sub4(intxt[9:8], s41, s42, s43, s44, sub14),

             sub5(temp1[15:14], s11, s12, s13, s14, sub21),
             sub6(temp1[13:12], s21, s22, s23, s24, sub22),
             sub7(temp1[11:10], s31, s32, s33, s34, sub23),
             sub8(temp1[9:8], s41, s42, s43, s44, sub24),

             sub9(temp2[15:14], s11, s12, s13, s14, sub31),
             sub10(temp2[13:12], s21, s22, s23, s24, sub32),
             sub15(temp2[11:10], s31, s32, s33, s34, sub33),
             sub16(temp2[9:8], s41, s42, s43, s44, sub34),

             sub17(temp3[15:14], s11, s12, s13, s14, sub41),
             sub18(temp3[13:12], s21, s22, s23, s24, sub42),
             sub19(temp3[11:10], s31, s32, s33, s34, sub43),
             sub20(temp3[9:8], s41, s42, s43, s44, sub44),

             sub25(temp4[15:14], s11, s12, s13, s14, sub51),
             sub26(temp4[13:12], s21, s22, s23, s24, sub52),
             sub27(temp4[11:10], s31, s32, s33, s34, sub53),
             sub28(temp4[9:8], s41, s42, s43, s44, sub54),

             sub29(temp5[15:14], s11, s12, s13, s14, sub61),
             sub30(temp5[13:12], s21, s22, s23, s24, sub62),
             sub35(temp5[11:10], s31, s32, s33, s34, sub63),
             sub36(temp5[9:8], s41, s42, s43, s44, sub64),

             sub37(temp6[15:14], s11, s12, s13, s14, sub71),
             sub38(temp6[13:12], s21, s22, s23, s24, sub72),
             sub39(temp6[11:10], s31, s32, s33, s34, sub73),
             sub40(temp6[9:8], s41, s42, s43, s44, sub74),

             sub45(temp7[15:14], s11, s12, s13, s14, sub81),
             sub46(temp7[13:12], s21, s22, s23, s24, sub82),
             sub47(temp7[11:10], s31, s32, s33, s34, sub83),
             sub48(temp7[9:8], s41, s42, s43, s44, sub84);

   always_comb begin
     temp1 = {(sub11^sub12^sub13^sub14)^intxt[7:0], intxt[15:8]} ^ {P1, P2};
     temp2 = {(sub21^sub22^sub23^sub24)^temp1[7:0], temp1[15:8]} ^ {P3, P4};
     temp3 = {(sub31^sub32^sub33^sub34)^temp2[7:0], temp2[15:8]} ^ {P5, P6};
     temp4 = {(sub41^sub42^sub43^sub44)^temp3[7:0], temp3[15:8]} ^ {P7, P8};
     temp5 = {(sub51^sub52^sub53^sub54)^temp4[7:0], temp4[15:8]} ^ {P1, P2};
     temp6 = {(sub61^sub62^sub63^sub64)^temp5[7:0], temp5[15:8]} ^ {P3, P4};
     temp7 = {(sub71^sub72^sub73^sub74)^temp6[7:0], temp6[15:8]} ^ {P5, P6};
     temp8 = {(sub81^sub82^sub83^sub84)^temp7[7:0], temp7[15:8]} ^ {P7, P8};
     outputtxt = temp8;
   end

endmodule : encrypt












module decrypt(
  input logic [15:0] intxt,
  input logic [15:0] KEY,
  output logic[15:0] outputtxt
);

  logic [7:0] P1, P2, P3, P4, P5, P6, P7, P8;
  logic [7:0] p1start, p2start, p3start, p4start, p5start, p6start, p7start, p8start; 
 
  assign p1start = 8'b0010_0100;
  assign p2start = 8'b0011_1111;
  assign p3start = 8'b0110_1010;
  assign p4start = 8'b1000_1000;
  assign p5start = 8'b1000_0101;
  assign p6start = 8'b1010_0011; 
  assign p7start = 8'b0000_1000;
  assign p8start = 8'b1101_0011; 
  
  //Set P keys
  always_comb begin
    P1 = p1start ^ KEY [7:0];
    P2 = p2start ^ KEY [15:8] ^ P1;
    P3 = p3start ^ KEY [7:0] ^ P2;
    P4 = p4start ^ KEY [15:8] ^ P3;
    P5 = p5start ^ KEY [7:0] ^ P4;
    P6 = p6start ^ KEY [15:8] ^ P5;
    P7 = p7start ^ KEY [7:0] ^ P6;
    P8 = p8start ^ KEY [15:8] ^ P7;
  end

  logic [7:0] s11, s12, s13, s14, s21, s22, s23, s24, s31, s32, s33, s34, s41, s42, s43, s44;
  //Set S Boxes
  always_comb begin
    s11 = 8'b0001_0011 ^ KEY [7:0];
    s12 = 8'b0001_1001 ^ KEY [15:8] ^ s11;
    s13 = 8'b1000_1010 ^ KEY [7:0] ^ s12;
    s14 = 8'b1000_1010 ^ KEY [15:8] ^ s13; 
    
    s21 = 8'b0000_0011 ^ KEY [7:0] ^ s14; 
    s22 = 8'b0111_0000 ^ KEY [15:8] ^ s21;
    s23 = KEY [7:0] ^ s22 ^ 8'b0111_0011;
    s24 = KEY [15:8] ^ s23 ^ 8'b0100_0100;
    
    s31 = KEY [7:0] ^ s24 ^ 8'b1010_0100;
    s32 = KEY [15:8] ^ s31 ^ 8'b0000_1001;
    s33 = KEY [7:0] ^ s32 ^ 8'b0011_1000;
    s34 = KEY [15:8] ^ s33 ^ 8'b0010_0010;
    
    s41 = KEY [7:0] ^ s34 ^ 8'b0010_1001;
    s42 = KEY [15:8] ^ s41 ^ 8'b1001_1111;
    s43 = KEY [7:0] ^ s42 ^ 8'b0011_0001;
    s44 = KEY [15:8] ^ s43 ^ 8'b1101_0000; 
     
  end

   //Set output
   logic [15:0] temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp11, temp12, temp;
   logic [15:0] temp1int, temp2int, temp3int, temp4int, temp5int, temp6int, temp7int, temp8int;
   logic [15:0] temp1int2, temp2int2, temp3int2, temp4int2, temp5int2, temp6int2, temp7int2, temp8int2;
     
  
   //s box selection
  logic [7:0] sub11, sub12, sub13, sub14, sub21, sub22, sub23, sub24, sub31, sub32, sub33, sub34, sub41, sub42, sub43, sub44, sub51, sub52, sub53, sub54, sub61, sub62, sub63, sub64, sub71, sub72, sub73, sub74, sub81, sub82, sub83, sub84;

  Mux41      sub1(temp1int[7:6], s11, s12, s13, s14, sub11),
             sub2(temp1int[5:4], s21, s22, s23, s24, sub12),
             sub3(temp1int[3:2], s31, s32, s33, s34, sub13),
             sub4(temp1int[1:0], s41, s42, s43, s44, sub14),

             sub5(temp2int[7:6], s11, s12, s13, s14, sub21),
             sub6(temp2int[5:4], s21, s22, s23, s24, sub22),
             sub7(temp2int[3:2], s31, s32, s33, s34, sub23),
             sub8(temp2int[1:0], s41, s42, s43, s44, sub24),

             sub9(temp3int[7:6], s11, s12, s13, s14, sub31),
             sub10(temp3int[5:4], s21, s22, s23, s24, sub32),
             sub15(temp3int[3:2], s31, s32, s33, s34, sub33),
             sub16(temp3int[1:0], s41, s42, s43, s44, sub34),

             sub17(temp4int[7:6], s11, s12, s13, s14, sub41),
             sub18(temp4int[5:4], s21, s22, s23, s24, sub42),
             sub19(temp4int[3:2], s31, s32, s33, s34, sub43),
             sub20(temp4int[1:0], s41, s42, s43, s44, sub44),

             sub25(temp5int[7:6], s11, s12, s13, s14, sub51),
             sub26(temp5int[5:4], s21, s22, s23, s24, sub52),
             sub27(temp5int[3:2], s31, s32, s33, s34, sub53),
             sub28(temp5int[1:0], s41, s42, s43, s44, sub54),

             sub29(temp6int[7:6], s11, s12, s13, s14, sub61),
             sub30(temp6int[5:4], s21, s22, s23, s24, sub62),
             sub35(temp6int[3:2], s31, s32, s33, s34, sub63),
             sub36(temp6int[1:0], s41, s42, s43, s44, sub64),

             sub37(temp7int[7:6], s11, s12, s13, s14, sub71),
             sub38(temp7int[5:4], s21, s22, s23, s24, sub72),
             sub39(temp7int[3:2], s31, s32, s33, s34, sub73),
             sub40(temp7int[1:0], s41, s42, s43, s44, sub74),

             sub45(temp8int[7:6], s11, s12, s13, s14, sub81),
             sub46(temp8int[5:4], s21, s22, s23, s24, sub82),
             sub47(temp8int[3:2], s31, s32, s33, s34, sub83),
             sub48(temp8int[1:0], s41, s42, s43, s44, sub84);

   always_comb begin
     temp8 = intxt;
     temp8int = temp8 ^ {P7,P8};
     temp8int2 = {temp8int[15:8]^sub84^sub83^sub82^sub81, temp8int[7:0]};
     
     temp7 = {temp8int2[7:0], temp8int2[15:8]};
     temp7int = temp7 ^ {P5,P6};
     temp7int2 = {temp7int[15:8]^sub74^sub73^sub72^sub71, temp7int[7:0]};
     
     temp6 = {temp7int2[7:0], temp7int2[15:8]};
     temp6int = temp6 ^ {P3, P4};
     temp6int2 = {temp6int[15:8]^sub64^sub63^sub62^sub61, temp6int[7:0]};

     temp5 = {temp6int2[7:0], temp6int2[15:8]};
     temp5int = temp5 ^ {P1, P2};
     temp5int2 = {temp5int[15:8]^sub54^sub53^sub52^sub51, temp5int[7:0]};


     temp4 = {temp5int2[7:0], temp5int2[15:8]};
     temp4int = temp4 ^ {P7, P8};
     temp4int2 = {temp4int[15:8]^sub44^sub43^sub42^sub41, temp4int[7:0]};


     temp3 = {temp4int2[7:0], temp4int2[15:8]};
     temp3int = temp3 ^ {P5, P6};
     temp3int2 = {temp3int[15:8]^sub34^sub33^sub32^sub31, temp3int[7:0]};


     temp2 = {temp3int2[7:0], temp3int2[15:8]};
     temp2int = temp2 ^ {P3, P4};
     temp2int2 = {temp2int[15:8]^sub24^sub23^sub22^sub21, temp2int[7:0]};


     temp1 = {temp2int2[7:0], temp2int2[15:8]};
     temp1int = temp1 ^ {P1, P2};
     temp1int2 = {temp1int[15:8]^sub14^sub13^sub12^sub11, temp1int[7:0]};

     outputtxt = {temp1int2[7:0], temp1int2[15:8]};

   end

endmodule : decrypt


module Mux41
  (input logic [1:0] sel,
   input logic [7:0] s1,
   input logic [7:0] s2,
   input logic [7:0] s3,
   input logic [7:0] s4,

   output logic [7:0] out);

  always_comb begin
    case(sel)
      2'b00: out = s1;
      2'b01: out = s2;
      2'b10: out = s3;
      2'b11: out = s4;
    endcase
  end
endmodule : Mux41
  
  // A SIPO Shift Register, with controllable shift direction
// Load has priority over shifting.
module ShiftRegister_SIPO
  #(parameter WIDTH=8)
  (input  logic             serial,
   input  logic             en, left, clock,
   output logic [WIDTH-1:0] Q);
   
  always_ff @(posedge clock)
    if (en)
      if (left)
        Q <= {Q[WIDTH-2:0], serial};
      else
        Q <= {serial, Q[WIDTH-1:1]};
        
endmodule : ShiftRegister_SIPO
