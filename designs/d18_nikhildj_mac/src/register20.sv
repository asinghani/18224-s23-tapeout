module register20(
    input logic [19:0]in,
    input logic add,
    input logic reset,
    output logic [19:0]out

);

logic [19:0] temp_out;

genvar i;

generate
    for (i=0; i<20; i=i+1 ) begin : dff_gen
    DFF d2 (
        .reset(reset),
        .clk(add),
        .D(in[i]),
        .Q(temp_out[i])
    );
    end
    
endgenerate

assign out = temp_out;

endmodule
