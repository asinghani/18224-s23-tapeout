`default_nettype none

module collatz (
  input wire [3:0] n,
  output wire [3:0] out
);
    wire [3:0] b = {n[0], n[0], n[0], n[0]};

    wire [3:0] out_even;
    assign out_even[3] = 0;
    assign out_even[2:0] = n[3:1];

    wire [3:0] out_odd;
    wire [3:0] tmp;
    assign tmp[3:1] = n[2:0];
    assign tmp[0] = 0;
    wire [3:0] tmp2;
    add4 inst2 ( tmp, n, tmp2 );
    add4 inst3 ( tmp2, 4'b0001 , out_odd );

    assign out = (b & out_odd) | (~b & out_even);
endmodule

// 4-bit adder
module add4(input wire [3:0] in1, input wire [3:0] in2, output wire [3:0] out);
    wire [3:0] rem;

    assign out[0] = in1[0] ^ in2[0];
    assign rem[0] = in1[0] & in2[0];

    assign out[1] = in1[1] ^ in2[1] ^ rem[0];
    assign rem[1] = (in1[1] & in2[1]) | (in1[1] & rem[0]) | (in2[1] & rem[0]);

    assign out[2] = in1[2] ^ in2[2] ^ rem[1];
    assign rem[2] = (in1[2] & in2[2]) | (in1[2] & rem[1]) | (in2[2] & rem[1]);

    assign out[3] = in1[3] ^ in2[3] ^ rem[2];
    assign rem[3] = (in1[3] & in2[3]) | (in1[3] & rem[2]) | (in2[3] & rem[2]);
endmodule
