module Register
# (parameter 
        W = 4)
(
    input logic reset, clock, en,
    input logic [W-1:0] D,
    output logic [W-1:0] Q
);
    always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            Q <= 'd0;
        end else if (en) begin
            Q <= D;
        end else begin
            Q <= Q;
        end
    end

endmodule: Register

module Counter
# (parameter 
        W = 4)
(
    input logic reset, clock, en,
    output logic [W-1:0] Q
);
    always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            Q <= 'd0;
        end else if (en) begin
            Q <= Q + 1'b1;
        end else begin
            Q <= Q;
        end
    end

endmodule: Counter

module CLB (
    input logic [1:0] sel,
    input logic [3:0] LUTConfig,
    input logic memSel_in, clock, reset, set,
    output logic out
);
    logic [3:0] LUTData;
    logic regData, memSel_mem;

    // store configuration of LUT
    Register #(4) data (.clock, .reset, .en(set), .D(LUTConfig), .Q(LUTData));

    // register to store value from LUT
    Register #(1) letVal (.clock, .reset, .en(1'b1), .D(LUTData[sel]), .Q(regData));

    // store whether to use register
    Register #(1) dataSel (.clock, .reset, .en(set), .D(memSel_in), .Q(memSel_mem));

    assign out = memSel_mem ? regData : LUTData[sel];

endmodule: CLB


module SwitchBox(
    input logic [11:0] inputs,
    input logic set, clock, reset, 
    input logic [3:0] selectConfig,
    output logic out
);
    logic [3:0] selectLine;
    // store configuration of select
    Register #(4) data (.clock, .reset, .en(set), .D(selectConfig), .Q(selectLine));
    

    assign out = inputs[11:8];
endmodule: SwitchBox

// configures mux to select inputs for the initial column of CLB
module muxSel
(
    input logic [1:0] selConfig,
    input logic [3:0] userInput,
    input logic clock, reset, set,
    output logic out
);

    logic [1:0] selConfig_mem;
    Register #(2) regInput(.clock, .reset, .en(set), .D(selConfig), .Q(selConfig_mem));

    assign out = userInput[selConfig_mem];

endmodule: muxSel

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);

    logic [3:0] userInput;
    logic [5:0] address;
    logic [4:0] setData;

    always_comb begin
    
        if (io_in[0] == 1'b1) begin
            userInput = 4'b0;
            address = io_in[11:6];
            setData = io_in[5:1];
        end else begin
            userInput = io_in[4:1];
            address = 6'b111111;
            setData = 5'b00000;
        end
    end

    FPGA top(.reset, .clock, .address, .userInput, .setData, .out(io_out[3:0]));

endmodule: my_chip

module FPGA (
    input logic reset, clock,
    input logic [5:0] address,
    input logic [3:0] userInput, 
    input logic [4:0] setData,
    output logic [3:0] out
);

    // logic [5:0] address;
    logic [7:0] inputSel;
    logic [15:0] CLBOut;
    logic [1:0] switchOut4, switchOut5, switchOut6;
    logic [1:0] switchOut7, switchOut8, switchOut9, switchOut10, switchOut11, switchOut12, switchOut13;
    logic [1:0] switchOut14, switchOut15;

    assign out = CLBOut[15:12];

    // Counter #(6) addressCount(.reset, .clock, .en(enAddress), .Q(address));
    
    muxSel inputSel0(.clock, 
                     .reset,
                     .userInput,
                     .set(address == 6'd40),
                     .selConfig(setData[1:0]),
                     .out(inputSel[0]));
    
    muxSel inputSel1(.clock, 
                     .reset,
                     .userInput,
                     .set(address == 6'd41),
                     .selConfig(setData[1:0]),
                     .out(inputSel[1]));

    muxSel inputSel2(.clock, 
                     .reset,
                     .userInput,
                     .set(address == 6'd42),
                     .selConfig(setData[1:0]),
                     .out(inputSel[2]));

    muxSel inputSel3(.clock, 
                     .reset,
                     .userInput,
                     .set(address == 6'd43),
                     .selConfig(setData[1:0]),
                     .out(inputSel[3]));

    muxSel inputSel4(.clock, 
                     .reset,
                     .userInput,
                     .set(address == 6'd44),
                     .selConfig(setData[1:0]),
                     .out(inputSel[4]));

    muxSel inputSel5(.clock, 
                     .reset,
                     .userInput,
                     .set(address == 6'd45),
                     .selConfig(setData[1:0]),
                     .out(inputSel[5]));

    muxSel inputSel6(.clock, 
                     .reset,
                     .userInput,
                     .set(address == 6'd46),
                     .selConfig(setData[1:0]),
                     .out(inputSel[6]));

    muxSel inputSel7(.clock, 
                     .reset,
                     .userInput,
                     .set(address == 6'd47),
                     .selConfig(setData[1:0]),
                     .out(inputSel[7]));

    // first column of CLB
    CLB addr0 (.clock, 
               .reset, 
               .sel(inputSel[1:0]), // from inputMuxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd0),
               .out(CLBOut[0]));

    CLB addr1 (.clock, 
               .reset, 
               .sel(inputSel[3:2]), // from inputMuxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd1),
               .out(CLBOut[1]));

    CLB addr2 (.clock, 
               .reset, 
               .sel(inputSel[5:4]), // from inputMuxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd2),
               .out(CLBOut[2]));
    
    CLB addr3 (.clock, 
               .reset, 
               .sel(inputSel[7:6]), // from inputMuxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd3),
               .out(CLBOut[3]));

    // second column of CLB
    CLB addr4 (.clock, 
               .reset, 
               .sel(switchOut4), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd4),
               .out(CLBOut[4]));

    CLB addr5 (.clock, 
               .reset, 
               .sel(switchOut5), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd5),
               .out(CLBOut[5]));
    
    CLB addr6 (.clock, 
               .reset, 
               .sel(switchOut6), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd6),
               .out(CLBOut[6]));

    CLB addr7 (.clock, 
               .reset, 
               .sel(switchOut7), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd7),
               .out(CLBOut[7]));
    
    // third column of CLB
    CLB addr8 (.clock, 
               .reset, 
               .sel(switchOut8), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd8),
               .out(CLBOut[8]));

    CLB addr9 (.clock, 
               .reset, 
               .sel(switchOut9), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd9),
               .out(CLBOut[9]));
    
    CLB addr10 (.clock, 
               .reset, 
               .sel(switchOut10), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd10),
               .out(CLBOut[10]));

    CLB addr11 (.clock, 
               .reset, 
               .sel(switchOut11), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd11),
               .out(CLBOut[11]));

    // fourth column of CLB
    CLB addr12 (.clock, 
               .reset, 
               .sel(switchOut12), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd12),
               .out(CLBOut[12]));

    CLB addr13 (.clock, 
               .reset, 
               .sel(switchOut13), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd13),
               .out(CLBOut[13]));

    CLB addr14 (.clock, 
               .reset, 
               .sel(switchOut14), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd14),
               .out(CLBOut[14]));

    CLB addr15 (.clock, 
               .reset, 
               .sel(switchOut15), // from switchboxes
               .LUTConfig(setData[3:0]), 
               .memSel_in(setData[4]), 
               .set(address == 6'd15),
               .out(CLBOut[15]));


    // each layer have 8 switchboxes, 4 CLB
    // 3 layer of switchboxes, 4 layers of CLB
    SwitchBox switch16 (.clock, 
                       .reset, 
                       .set(address == 6'd16),
                       .inputs(CLBOut[11:0]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut4[0]));
    
    SwitchBox switch17 (.clock, 
                       .reset, 
                       .set(address == 6'd17),
                       .inputs(CLBOut[11:0]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut4[1]));
    
    SwitchBox switch18 (.clock, 
                       .reset, 
                       .set(address == 6'd18),
                       .inputs(CLBOut[11:0]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut5[0]));

    SwitchBox switch19 (.clock, 
                       .reset, 
                       .set(address == 6'd19),
                       .inputs(CLBOut[11:0]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut5[1]));

    SwitchBox switch20 (.clock, 
                       .reset, 
                       .set(address == 6'd20),
                       .inputs(CLBOut[11:0]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut6[0]));

    SwitchBox switch21 (.clock, 
                       .reset, 
                       .set(address == 6'd21),
                       .inputs(CLBOut[11:0]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut6[1]));

    SwitchBox switch22 (.clock, 
                       .reset, 
                       .set(address == 6'd22),
                       .inputs(CLBOut[11:0]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut7[0]));

    SwitchBox switch23 (.clock, 
                       .reset, 
                       .set(address == 6'd23),
                       .inputs(CLBOut[11:0]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut7[1]));

    SwitchBox switch24 (.clock, 
                       .reset, 
                       .set(address == 6'd24),
                       .inputs(CLBOut[15:4]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut8[0]));

    SwitchBox switch25 (.clock, 
                       .reset, 
                       .set(address == 6'd25),
                       .inputs(CLBOut[15:4]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut8[1]));

    SwitchBox switch26 (.clock, 
                       .reset, 
                       .set(address == 6'd26),
                       .inputs(CLBOut[15:4]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut9[0]));

    SwitchBox switch27 (.clock, 
                       .reset, 
                       .set(address == 6'd27),
                       .inputs(CLBOut[15:4]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut9[1]));

    SwitchBox switch28 (.clock, 
                       .reset, 
                       .set(address == 6'd28),
                       .inputs(CLBOut[15:4]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut10[0]));

    SwitchBox switch29 (.clock, 
                       .reset, 
                       .set(address == 6'd29),
                       .inputs(CLBOut[15:4]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut10[1]));

    SwitchBox switch30 (.clock, 
                       .reset, 
                       .set(address == 6'd30),
                       .inputs(CLBOut[15:4]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut11[0]));

    SwitchBox switch31 (.clock, 
                       .reset, 
                       .set(address == 6'd31),
                       .inputs(CLBOut[15:4]),
                       .selectConfig(setData[3:0]),
                       .out(switchOut11[1]));

    SwitchBox switch32 (.clock, 
                       .reset, 
                       .set(address == 6'd32),
                       .inputs({4'b0, CLBOut[15:8]}),
                       .selectConfig(setData[3:0]),
                       .out(switchOut12[0]));
    
    SwitchBox switch33 (.clock, 
                       .reset, 
                       .set(address == 6'd33),
                       .inputs({4'b0, CLBOut[15:8]}),
                       .selectConfig(setData[3:0]),
                       .out(switchOut12[1]));
    
    SwitchBox switch34 (.clock, 
                       .reset, 
                       .set(address == 6'd34),
                       .inputs({4'b0, CLBOut[15:8]}),
                       .selectConfig(setData[3:0]),
                       .out(switchOut13[0]));

    SwitchBox switch35 (.clock, 
                       .reset, 
                       .set(address == 6'd35),
                       .inputs({4'b0, CLBOut[15:8]}),
                       .selectConfig(setData[3:0]),
                       .out(switchOut13[1]));

    SwitchBox switch36 (.clock, 
                       .reset, 
                       .set(address == 6'd36),
                       .inputs({4'b0, CLBOut[15:8]}),
                       .selectConfig(setData[3:0]),
                       .out(switchOut14[0]));

    SwitchBox switch37 (.clock, 
                       .reset, 
                       .set(address == 6'd37),
                       .inputs({4'b0, CLBOut[15:8]}),
                       .selectConfig(setData[3:0]),
                       .out(switchOut14[1]));

    SwitchBox switch38 (.clock, 
                       .reset, 
                       .set(address == 6'd38),
                       .inputs({4'b0, CLBOut[15:8]}),
                       .selectConfig(setData[3:0]),
                       .out(switchOut15[0]));

    SwitchBox switch39 (.clock, 
                       .reset, 
                       .set(address == 6'd39),
                       .inputs({4'b0, CLBOut[15:8]}),
                       .selectConfig(setData[3:0]),
                       .out(switchOut15[1]));


endmodule: FPGA
