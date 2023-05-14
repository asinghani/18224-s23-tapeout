//counter
module counter
    #(parameter WIDTH=0)
    (input  logic             clk, reset_l, en, clr,
     output logic [WIDTH-1:0] count);

    always_ff @(posedge clk, negedge reset_l) begin
        if (!reset_l)
            count <= 'b0;
        else if (clr)
            count <= 'b0;
        else if (en)
            count <= count + 1;

    end
endmodule: counter

//register
module register
   #(parameter WIDTH=0)
    (input  logic               clk, en, reset_l,
     input  logic [WIDTH-1:0]   D,
     output logic [WIDTH-1:0]   Q);

    always_ff @(posedge clk, negedge reset_l) begin
        if (!reset_l)
            Q <= 'b0;
        else if (en)
            Q <= D;
    end
endmodule: register

//mux
module mux
    #(parameter INPUTS=0, WIDTH=0)
    (input  logic [INPUTS-1:0][WIDTH-1:0]   in,
     input  logic [$clog2(INPUTS)-1:0]      sel,
     output logic [WIDTH-1:0]               out);

    assign out = in[sel];
endmodule: mux

//6-bit fixed point multplier -- paramatrize this
module mult
    (input  logic [5:0] A, B,
     output logic [5:0] M);

    logic [11:0] tmp;
    assign tmp = A*B;

    //required for fixed point...add documentation to explain
    //want middle 6 bits
    //12 11 10 9 8 7 6 5 4 3 2 1 0
    assign M = tmp[9:3];
endmodule: mult

//adder
module adder
    #(parameter WIDTH=0)
    (input  logic               cin,
     input  logic [WIDTH-1:0]   A, B,
     output logic               cout,
     output logic [WIDTH-1:0]   sum);

    assign {cout, sum} = A + B + cin;
endmodule: adder