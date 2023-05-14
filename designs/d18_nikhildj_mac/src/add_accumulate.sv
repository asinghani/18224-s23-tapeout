module add_accumulate (

    input logic [15:0] mult_res_in,
    input logic add,
    input logic reset,
    output logic [19:0] result,
    output logic result_carry_out

);

logic [19:0] temp_mult_res_in;
logic [19:0] mult_res_out;
logic [19:0] add_out;
logic [19:0] add_in;
logic [19:0] temp_result;
assign temp_result = result;
assign add_in = temp_result;

assign temp_mult_res_in[19:0] = {4'b0000, mult_res_in};
 

register20 i0 ( 
    .in(temp_mult_res_in),
    .add(add),
    .reset(reset),
    .out(mult_res_out)

);

carry_select20 adder (
    .a(mult_res_out),
    .b(add_in),
    .carry_in(1'b0),
    .sum(add_out),
    .carry_out(result_carry_out)


);
register20 accmulate (
    .in(add_out),
    .add(!add),
    .reset(reset),
    .out(result)  

);

endmodule



  

    
