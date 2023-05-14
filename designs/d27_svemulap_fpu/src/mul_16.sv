/*
Floating Point Multiplier: 

*/

`timescale 1ns/1ps
`default_nettype none

module mul(input_a, input_b, mul_out, mul_valid);
  input logic [15:0] input_a, input_b; // INput Ports
  output logic [15:0] mul_out; // Output Port
  output logic mul_valid; // Output Valid Port

// Internal Logic Signals
  logic [4:0] expo_1, expo_2, expo_final;
  logic [4:0] expo_1_temp, expo_2_temp, expo_final_temp; 
  logic [4:0] expo_diff;
  logic [4:0] temp1;
  logic check_1;
  logic [9:0] frac_1, frac_2, frac_final;
  logic [9:0] frac_diff, frac_diff_final;
  logic [20:0] temp_f_1;
  logic [10:0] temp_f_2;
  logic expo_sign;
  logic [6:0] expo_temp1;
  logic [5:0] expo_bias_1, expo_bias_final; 
  logic [11:0] temp_4, temp_4_before; 
  logic [9:0] frac_temp;
  logic [9:0] dummy; 
  logic [21:0] final_value;
  logic [21:0] before_value;
  logic [20:0] temp_value[10:0];
  logic sign_1, sign_2, sign_final; 
  logic is_inf; 
  logic  overflow;
  logic is_zero; 
  logic NaN; 
  logic subnormal_value;


  always @(*) begin 
    if(NaN)
      mul_valid = 0;
      else mul_valid = 1;
  end

  assign check_1 = {1'b0,expo_diff} > expo_bias_final; 
  assign is_zero = (~(|input_a[14:0] & |input_b[14:0])) | ((subnormal_value & (frac_diff == 10'd0)) | (expo_sign & (~|final_value[20:11])));
  assign expo_temp1 = expo_bias_1 - 7'd15;
  assign expo_bias_1 = {1'b0,expo_1} + {1'b0,expo_2};
  assign expo_bias_final = (expo_sign) ? (~expo_temp1[5:0] + 6'd1) : expo_temp1[5:0];
  assign {sign_1, expo_1_temp, frac_1} = input_a;
  assign {sign_2, expo_2_temp, frac_2} = input_b;
  assign expo_1 = expo_1_temp + {4'd0, ~|expo_1_temp};
  assign expo_2 = expo_2_temp + {4'd0, ~|expo_2_temp};
  assign expo_sign = expo_temp1[6];
  assign NaN = (&input_a[14:10] & |input_a[9:0]) | (&input_b[14:10] & |input_b[9:0]);
  assign is_inf = (&input_a[14:10] & ~|input_a[9:0]) | (&input_b[14:10] & ~|input_b[9:0]); 
  assign overflow = is_inf | (~expo_temp1[6] & expo_temp1[5]);
  assign subnormal_value = ~|temp_4[11:10];

  assign mul_out = {sign_final, expo_final, frac_final};
  assign temp_f_1 = {|expo_1_temp, frac_1, 10'd0};
  assign temp_f_2 = {|expo_2_temp, frac_2};
  assign sign_final = (sign_1 ^ sign_2);
  assign expo_final_temp = expo_temp1[4:0] + {4'd0, temp_4[11]} + (~expo_diff & {5{subnormal_value}}) + {4'd0, subnormal_value};
  assign expo_final = (expo_final_temp | {5{overflow}}) & {5{~(is_zero | expo_sign | check_1)}};
  assign frac_final = ((expo_sign) ? final_value[20:11] :((subnormal_value) ? frac_diff_final : frac_temp)) & {10{~(is_zero | overflow)}} ;
  assign frac_temp = (temp_4[11]) ? temp_4[10:1] : temp_4[9:0];
  assign temp_4 = temp_4_before + {10'd0,dummy[9]};
  assign {temp_4_before, dummy} = before_value;
  assign before_value = temp_value[0] + temp_value[1] + temp_value[2] + temp_value[3] + temp_value[4] + temp_value[5] + temp_value[6] + temp_value[7] + temp_value[8] + temp_value[9] + temp_value[10];
  assign temp1 = expo_diff - expo_bias_final[4:0];

  always @(*)
    begin
      if(expo_sign)
        case(expo_bias_final)
          6'h0: final_value = before_value;
          6'h1: final_value = (before_value >> 1);
          6'h2: final_value = (before_value >> 2);
          6'h3: final_value = (before_value >> 3);
          6'h4: final_value = (before_value >> 4);
          6'h5: final_value = (before_value >> 5);
          6'h6: final_value = (before_value >> 6);
          6'h7: final_value = (before_value >> 7);
          6'h8: final_value = (before_value >> 8);
          6'h9: final_value = (before_value >> 9);
          6'ha: final_value = (before_value >> 10);
          6'hb: final_value = (before_value >> 11);
          6'hc: final_value = (before_value >> 12);
          6'hd: final_value = (before_value >> 13);
          6'he: final_value = (before_value >> 14);
          6'hf: final_value = (before_value >> 15);
          default: final_value = (before_value >> 16);
        endcase
      else
        final_value = before_value;
    end
  always @(*)
    begin
      if(check_1)
        case(temp1)
          5'h0: frac_diff_final = frac_diff;
          5'h1: frac_diff_final = (frac_diff >> 1);
          5'h2: frac_diff_final = (frac_diff >> 2);
          5'h3: frac_diff_final = (frac_diff >> 3);
          5'h4: frac_diff_final = (frac_diff >> 4);
          5'h5: frac_diff_final = (frac_diff >> 5);
          5'h6: frac_diff_final = (frac_diff >> 6);
          5'h7: frac_diff_final = (frac_diff >> 7);
          5'h8: frac_diff_final = (frac_diff >> 8);
          5'h9: frac_diff_final = (frac_diff >> 9);
          default: frac_diff_final = 10'h0;
        endcase
      else
        frac_diff_final = frac_diff;
    end

  always @(*)
    begin
      temp_value[0] = (temp_f_1 >> 10) & {21{temp_f_2[0]}};
      temp_value[1] = (temp_f_1 >> 9)  & {21{temp_f_2[1]}};
      temp_value[2] = (temp_f_1 >> 8)  & {21{temp_f_2[2]}};
      temp_value[3] = (temp_f_1 >> 7)  & {21{temp_f_2[3]}};
      temp_value[4] = (temp_f_1 >> 6)  & {21{temp_f_2[4]}};
      temp_value[5] = (temp_f_1 >> 5)  & {21{temp_f_2[5]}};
      temp_value[6] = (temp_f_1 >> 4)  & {21{temp_f_2[6]}};
      temp_value[7] = (temp_f_1 >> 3)  & {21{temp_f_2[7]}};
      temp_value[8] = (temp_f_1 >> 2)  & {21{temp_f_2[8]}};
      temp_value[9] = (temp_f_1 >> 1)  & {21{temp_f_2[9]}};
      temp_value[10] = temp_f_1        & {21{temp_f_2[10]}};
    end

// To determine the fraction coefficient
  always @(*)
    begin
      case(final_value)
        22'b001???????????????????:   frac_diff = final_value[18:9];
        22'b0001??????????????????:   frac_diff = final_value[17:8];
        22'b00001?????????????????:   frac_diff = final_value[16:7];
        22'b000001????????????????:   frac_diff = final_value[15:6];
        22'b0000001???????????????:   frac_diff = final_value[14:5];
        22'b00000001??????????????:   frac_diff = final_value[13:4];
        22'b000000001?????????????:   frac_diff = final_value[12:3];
        22'b0000000001????????????:   frac_diff = final_value[11:2];
        22'b00000000001???????????:   frac_diff = final_value[10:1];
        22'b000000000001??????????:   frac_diff = final_value[9:0];
        22'b0000000000001?????????:   frac_diff = {final_value[8:0], 1'd0};
        22'b00000000000001????????:   frac_diff = {final_value[7:0], 2'd0};
        22'b000000000000001???????:   frac_diff = {final_value[6:0], 3'd0};
        22'b0000000000000001??????:   frac_diff = {final_value[5:0], 4'd0};
        22'b00000000000000001?????:   frac_diff = {final_value[4:0], 5'd0};
        22'b000000000000000001????:   frac_diff = {final_value[3:0], 6'd0};
        22'b0000000000000000001???:   frac_diff = {final_value[2:0], 7'd0};
        22'b00000000000000000001??:   frac_diff = {final_value[1:0], 8'd0};
        22'b000000000000000000001?:   frac_diff = {final_value[0], 9'd0};
        default: frac_diff = 10'd0;
      endcase
    end
// To shift the exponent value
  always @(*)
    begin
      case(final_value)
        22'b001???????????????????:   expo_diff = 5'd1;
        22'b0001??????????????????:   expo_diff = 5'd2;
        22'b00001?????????????????:   expo_diff = 5'd3;
        22'b000001????????????????:   expo_diff = 5'd4;
        22'b0000001???????????????:   expo_diff = 5'd5;
        22'b00000001??????????????:   expo_diff = 5'd6;
        22'b000000001?????????????:   expo_diff = 5'd7;
        22'b0000000001????????????:   expo_diff = 5'd8;
        22'b00000000001???????????:   expo_diff = 5'd9;
        22'b000000000001??????????:   expo_diff = 5'd10;
        22'b0000000000001?????????:   expo_diff = 5'd11;
        22'b00000000000001????????:   expo_diff = 5'd12;
        22'b000000000000001???????:   expo_diff = 5'd13;
        22'b0000000000000001??????:   expo_diff = 5'd14;
        22'b00000000000000001?????:   expo_diff = 5'd15;
        22'b000000000000000001????:   expo_diff = 5'd16;
        22'b0000000000000000001???:   expo_diff = 5'd17;
        22'b00000000000000000001??:   expo_diff = 5'd18;
        22'b000000000000000000001?:   expo_diff = 5'd19;
        default: expo_diff = 5'd0;
      endcase
    end
endmodule
