/*
Floating point Adder: 16 - bit:
Algorithm: Add the exponent of the smaller number from the exponent of the larger number, and 
shift the mantissa of the smaller number to align with the larger number. Then Add the mantissas of the aligned numbers together
Check if the result needs to be normalized, if yes, shift correspondingly and calculate the normalized result
*/

`timescale 1ns/1ps
`default_nettype none

module add(input_a, input_b, add_out,add_valid);
  //Ports
  input logic [15:0] input_a, input_b; // Input Ports
  output logic [15:0] add_out; // Output Ports
  output logic add_valid; // Output Valid Signal
 
  // Internal Logic Signals. 
  logic [15:0] value_2, value_1; 
  logic [4:0] exp_2, exp_1; 
  logic [10:0] max_diff, min_diff; 
  logic [10:0] sing_1, shift_1; 
  logic [4:0] diff_expon; 
  logic [9:0] shifted_value; 
  logic [3:0] to_shift;
  logic [9:0] shift_ext;
  logic [9:0] shift_ext_1;
  logic [9:0] dec_2, dec_1; 
  logic [4:0] temp_2, temp_1,temp_3;
  logic sign_2, sign_1;
  logic overflow;
  logic NaN; 
  logic [10:0] sum; 
  logic sum_carry;
  logic sign_equal;
  logic is_zero;
  logic is_inf; 
  logic [4:0] temp_exp, temp_exp_check;
  
  assign NaN = (&input_a[14:10] & |input_a[9:0]) | (&input_b[14:10] & |input_b[9:0]);
  assign is_inf = (&input_a[14:10] & ~|input_a[9:0]) | (&input_b[14:10] & ~|input_b[9:0]);
  assign overflow = ((&exp_2[4:1] & ~exp_2[0]) & sum_carry & sign_equal) | is_inf;
  assign add_out[15] = sign_2; 
  assign temp_exp = exp_2 + {4'd0, (~is_zero & sum_carry & sign_equal)} - {4'd0,({1'b0,add_out[9:0]} == sum)};
  assign temp_exp_check = (temp_3 | (to_shift == 4'd10)) ? 5'd0 : (~to_shift + exp_2 + 5'd1);
  assign add_out[14:10] = ((sign_equal) ? temp_exp : temp_exp_check) | {5{overflow}};
  assign add_out[9:0] = ((is_zero) ? dec_2 : ((sign_equal) ? ((sum_carry) ? sum[10:1] : sum[9:0]) : ((temp_3) ? 10'd0 : shifted_value))) & {10{~overflow}};

  assign {sign_2, temp_2, dec_2} = value_2;
  assign {sign_1, temp_1, dec_1} = value_1;
  assign sign_equal = (sign_2 == sign_1);
  assign is_zero = ~(|exp_1 | |dec_1);
  assign exp_2 = temp_2 + {4'd0, ~|temp_2};
  assign exp_1 = temp_1 + {4'd0, ~|temp_1};

  assign max_diff = {|temp_2, dec_2};
  assign min_diff = {|temp_1, dec_1};
  assign diff_expon = exp_2 - exp_1; 
  assign {sum_carry, sum} = sing_1 + max_diff; 
  assign shift_ext_1 = shift_ext;

  always @(*) begin 
    if(NaN)
      add_valid = 0;
      else add_valid = 1;
  end

// Assigning the input values based of which is greater for further computation.
  always @(*) begin
      if(input_b[14:10] > input_a[14:10])
        begin
          value_2 = input_b;
          value_1 = input_a;
        end
      else if(input_b[14:10] == input_a[14:10])
        begin
          if(input_b[9:0] > input_a[9:0])
            begin
              value_2 = input_b;
              value_1 = input_a;
            end
          else
            begin
              value_2 = input_a;
              value_1 = input_b;
            end
        end
      else
        begin
          value_2 = input_a;
          value_1 = input_b;
        end
    end

  assign temp_3 = (exp_2 < to_shift);

// To determine the value after shifting.
  always @(*) begin
      case (to_shift)
        4'd0: shifted_value =  sum[9:0];
        4'd1: shifted_value = {sum[8:0],shift_ext_1[9]};
        4'd2: shifted_value = {sum[7:0],shift_ext_1[9:8]};
        4'd3: shifted_value = {sum[6:0],shift_ext_1[9:7]};
        4'd4: shifted_value = {sum[5:0],shift_ext_1[9:6]};
        4'd5: shifted_value = {sum[4:0],shift_ext_1[9:5]};
        4'd6: shifted_value = {sum[3:0],shift_ext_1[9:4]};
        4'd7: shifted_value = {sum[2:0],shift_ext_1[9:3]};
        4'd8: shifted_value = {sum[1:0],shift_ext_1[9:2]};
        4'd9: shifted_value = {sum[0],  shift_ext_1[9:1]};
        default: shifted_value = shift_ext_1;
      endcase
    end

  always @(*)  begin
      case (diff_expon)
        5'h0: {shift_1,shift_ext} = {min_diff,10'd0};
        5'h1: {shift_1,shift_ext} = {min_diff,9'd0};
        5'h2: {shift_1,shift_ext} = {min_diff,8'd0};
        5'h3: {shift_1,shift_ext} = {min_diff,7'd0};
        5'h4: {shift_1,shift_ext} = {min_diff,6'd0};
        5'h5: {shift_1,shift_ext} = {min_diff,5'd0};
        5'h6: {shift_1,shift_ext} = {min_diff,4'd0};
        5'h7: {shift_1,shift_ext} = {min_diff,3'd0};
        5'h8: {shift_1,shift_ext} = {min_diff,2'd0};
        5'h9: {shift_1,shift_ext} = {min_diff,1'd0};
        5'ha: {shift_1,shift_ext} = min_diff;
        5'hb: {shift_1,shift_ext} = min_diff[10:1];
        5'hc: {shift_1,shift_ext} = min_diff[10:2];
        5'hd: {shift_1,shift_ext} = min_diff[10:3];
        5'he: {shift_1,shift_ext} = min_diff[10:4];
        5'hf: {shift_1,shift_ext} = min_diff[10:5];
        5'h10: {shift_1,shift_ext} = min_diff[10:5];
        5'h11: {shift_1,shift_ext} = min_diff[10:6];
        5'h12: {shift_1,shift_ext} = min_diff[10:7];
        5'h13: {shift_1,shift_ext} = min_diff[10:8];
        5'h14: {shift_1,shift_ext} = min_diff[10:9];
        5'h15: {shift_1,shift_ext} = min_diff[10];
        5'h16: {shift_1,shift_ext} = 0;
        default: begin shift_1 = 0;
                       shift_ext = 0;
        end
      endcase
    end

assign sing_1 = sign_equal? shift_1 : ~shift_1 + 11'b1;
// To determine how much is to be shifted
    always @(*) begin
      casex(sum)
        11'b1??????????: to_shift = 4'd0;
        11'b01?????????: to_shift = 4'd1;
        11'b001????????: to_shift = 4'd2;
        11'b0001???????: to_shift = 4'd3;
        11'b00001??????: to_shift = 4'd4;
        11'b000001?????: to_shift = 4'd5;
        11'b0000001????: to_shift = 4'd6;
        11'b00000001???: to_shift = 4'd7;
        11'b000000001??: to_shift = 4'd8;
        11'b0000000001?: to_shift = 4'd9;
        default: to_shift = 4'd10;
      endcase
    end

endmodule