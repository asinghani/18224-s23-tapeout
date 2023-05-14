`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
   
     logic reset_n;
      logic START;
    logic [7:0] op_a_in;
    logic [7:0] op_b_in;
    logic [19:0] mac_res;
     logic mac_carry_out;
     logic Finish;
    logic End_mul;
    bit input_done = 1'b0;
    bit output_done = 1'b0;

assign reset_n = !reset;
assign START = io_in[11];  
assign  mac_carry_out =  io_out[11];
assign Finish = io_out[10];
    assign input_done = io_in[8];
    assign output_done = io_out[8];
    assign End_mul = io_out[7];
    
    assign io_in[7:0] = 8'd0;
    assign io_out[6:0] = 8'd0;
    

integer i,j;
    
    
    
    always@(posedge clock) begin
        
        for (i=0;i<8;i = i+1) begin
            op_a_in[i] <= io_in[10];
            op_b_in[i] <= io_in[9];
        end
        
        if (i == 8) begin
            input_done <= 1'b1;
        end
        
        else begin 
            input_done <= 1'b0;
        end
        
        if (Finish) begin
            for (j=0;j<20;j=j+1) begin
                io_out[9] <=  mac_res[j];
            end
        end
        else begin
            io_out[9] <= 1'b0;
        end
            
        
        if (j == 20) begin
            output_done <= 1'b1;
        end
        
        else begin 
            output_done <= 1'b0;
        end
        
        
    end
    
    
    
    
      
// MAC_controller
logic control_reset;
logic Begin_mul;
logic add;
logic Load_op;


//Operands 
logic [7:0] op_a_out;
logic [7:0] op_b_out;

//multiplier
logic [15:0] mult_res;


CONTROLLER_MAC control (

    .reset(reset_n),
    .clk(clock),
    .START(START),
    .End_mul(End_mul),
    .Finish(Finish),
    .RESET_cmd(control_reset),
    .Load_op(Load_op),
    .Begin_mul(Begin_mul),
    .add(add)
);

register8 opa (
    .in(op_a_in),
    .Load_op(Load_op),
    
    .reset(control_reset),
    .out(op_a_out)
);

register8 opb (
    .in(op_b_in),
    .Load_op(Load_op),
    
    .reset(control_reset),
    .out(op_b_out)
);

top_multiplier mult (

    .a_in(op_a_out),
    .b_in(op_b_out),
    .reset(control_reset),
    .clk(clock),
    .Begin_mul(Begin_mul),
    .mult_out(mult_res),
    .End_mul(End_mul)
);

add_accumulate aa (

    .mult_res_in(mult_res),
    .add(add),
    
    .reset(control_reset),
    .result(mac_res),
    .result_carry_out(mac_carry_out)
);





endmodule
