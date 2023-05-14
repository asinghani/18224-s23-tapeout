module register8(
    input logic [7:0]in,
    input logic Load_op,
    input logic reset,
    output logic [7:0]out

);

logic [7:0] temp_out;

genvar i;

generate
    for (i=0; i<8; i=i+1 ) begin : dff_gen
    DFF d1 (
        .reset(reset),
        .clk(Load_op),
        .D(in[i]),
        .Q(temp_out[i])
    );
    end
    
endgenerate

assign out = temp_out;

endmodule
