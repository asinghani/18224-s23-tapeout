/* Top Module - 16 - bit Floating Point Unit 
        Sub-Modules - FPU Adder and FPU Multiplier
Description: 
Each Sub Module(Adder and Multiplier) takes in 2 16-bit data input values and 
results in One 16-bit Result and a valid signal. The Sub Modules are Combinational.
The 16-bit inputs takes in 4 cycles to fully obtain. And the 16-bit outputs take in 
2 cycels to be generated out. 
Input Ports: Out of the 12 available ports, we are using 10 of the ports
        io_in[3:0] - Input A
        io_in[7:4] - Input B
        io_in[8]   - Select Signal
        io_in[9]   - Control Signal
Output Ports: 9 of the 12 available ports are used
        io_out[7:0] - Output Result
        io_out[8]   - Valid Signal.
*/
`timescale 1ns/1ps
`default_nettype none

module my_chip (
    input logic [11:0] io_in, 
    output logic [11:0] io_out,
    input logic clock,
    input logic reset    
);

    // Local Declarations 
    reg     [15:0] value_A,value_B; // Inputs to Adder and Multiplier
    reg     [15:0] tmp_input_A, tmp_input_B; // Temporary storage of inputs in each cycle
    reg     [15:0] result; // Final result to be sent out to io_out
    reg     [15:0] temp_result_add; // Results from Add Block
    reg     [15:0] temp_result_mul; // Results from Mul Block
    reg            temp_valid_mul, temp_valid_add; // Valid Output from Mul and Add block
    reg            select; // Select takes the value to io_in[8] port and decides to take in Multiplier or Adder Output
    reg            valid; // Final validity of result goes to io_out[8]
    reg   [3:0] count; // Count is used as a counter to keep a track of each input rounds as inputs are given in 4 cycles.
    reg   [1:0] i; // Used for Iteration
    integer j; // Used to keep a count of input iteration assignment.

// To select between Multiplier and Adder. Input port (io_in[8]) is assigned
assign select = io_in[8];

    always @(posedge clock) begin
        // Input Controls.
        if(reset) begin 
            tmp_input_A <= 0;
            tmp_input_B <= 0;
            count <= 1;
            j <= 0;
            i <= 0;
            io_out[8:0] <= 'h0;
            result <= 'h0;
            valid  <= 'h0;
        end
        // io_in[9] is an input signal which is enabled when the inputs are given. 
        else if (io_in[9]) begin
            // Assigning the stored inputs to the inputs to the adder/multiplier module.
            if(count == 6) begin
                value_A <= tmp_input_A;
                value_B <= tmp_input_B;
            end
            // Iterating till all the inputs are received. 
            else begin 
                tmp_input_A[j-:4] <= io_in[3:0];
                tmp_input_B[j-:4] <= io_in[7:4];
                count <= count +1; 
                j <= (4*count) -1;
            end
        end
        // Output Controls.
        else if(!io_in[9]) begin
            case(i) 
            2'd0:	begin // Decides which result should be taken based on the select signal.
                    result <=  select ? temp_result_add : temp_result_mul;
                    valid <= select ? temp_valid_add : temp_valid_mul;
                    i <= 2'd1;
                end
            2'd1:   begin // Assigns 8 bits starting from LSB to the output port
                    io_out[7:0] <= result[7:0];
                    io_out[8] <= valid;
                    count <=1;
                    i <= 2'd2;
                end
            2'd2:	begin // Assigning the next 8 bits to the output port.
                    io_out[7:0] <= result[15:8];
                    i <= 2'd3;
                end
            2'd3: begin // Idle State
                i <= 2'd0;
                io_out[8] <= 'h0;
                end
            default: begin i <= 2'd0;
                        io_out[8] <= 'h0;
            end
            endcase
        end
    end
  //Adder and Multiplier Modules
    add inst_add(
        .input_a(value_A),
        .input_b(value_B),
        .add_valid(temp_valid_add), 
        .add_out(temp_result_add)
    );

    mul inst_mul(
        .input_a(value_A),
        .input_b(value_B),
        .mul_valid(temp_valid_mul),
        .mul_out(temp_result_mul)
    );

endmodule


