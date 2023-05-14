`default_nettype none

// module Register_test ();
//     logic en, clock, reset;
//     logic [3:0] D, Q;

//     Register #(4) DUT(.*);
//     initial begin
//         reset = 1'b1;
//         clock = 1'b1;
//         forever #1 clock = ~clock;
//     end

//     initial begin
//         $monitor($time, , "clock: %b, reset: %b, D: %b, Q: %b", clock, reset, D, Q);
//         @(posedge clock);
//         en  = 1'b1;
//         reset <= 1'b0;
//         D <= 4'b1111;
//         @(posedge clock);
//         D <= 4'b1111;
//         @(posedge clock);
//         D <= 4'b1010;
//         @(posedge clock);
//         D <= 4'b0000;
//         @(posedge clock);
//         D <= 4'b1111;
//         @(posedge clock);
//         #5 $finish;
//     end
// endmodule: Register_test

// module CLB_test ();
//     logic set, clock, reset, memSel_in, out;
//     logic [3:0] LUTConfig;
//     logic [1:0] sel;

//     CLB #(4) DUT(.*);
//     initial begin
//         reset = 1'b1;
//         clock = 1'b1;
//         forever #1 clock = ~clock;
//     end

//     initial begin
//         $monitor($time, , "clock: %b, reset: %b, LUTConfig: %b, sel: %b, out: %b", clock, reset, LUTConfig, sel, out);
//         @(posedge clock);
//         // set an and gate configuration
//         set  = 1'b1;
//         reset <= 1'b0;
//         LUTConfig <= 4'b1000;
//         memSel_in <= 0;
//         @(posedge clock);
//         set  = 1'b0;
//         sel <= 2'b00;
//         @(posedge clock);
//         sel <= 2'b01;
//         @(posedge clock);
//         sel <= 2'b10;
//         @(posedge clock);
//         sel <= 2'b11;

//         // set a xor gate configuration
//         set  <= 1'b1;
//         LUTConfig <= 4'b0110;
//         memSel_in <= 0;
//         @(posedge clock);
//         set  <= 1'b0;
//         sel <= 2'b00;
//         @(posedge clock);
//         sel <= 2'b01;
//         @(posedge clock);
//         sel <= 2'b10;
//         @(posedge clock);
//         sel <= 2'b11;
//         @(posedge clock);

//         // set to memory configuration
//         // set a xor gate configuration
//         set  <= 1'b1;
//         LUTConfig <= 4'b0110;
//         memSel_in <= 1'b1;
//         sel <= 2'b01;
//         @(posedge clock);
//         set  <= 1'b0;
//         @(posedge clock);
//         sel <= 2'b01;
//         @(posedge clock);
//         sel <= 2'b10;
//         @(posedge clock);
//         sel <= 2'b11;

//         #5 $finish;
//     end
// endmodule: CLB_test

// module SweitchBox_test ();
//     logic [11:0] inputs;
//     logic set, clock, reset;
//     logic [3:0] selectConfig;
//     logic out;

//     SwitchBox #(4) DUT(.*);
//     initial begin
//         reset = 1'b1;
//         clock = 1'b1;
//         forever #1 clock = ~clock;
//     end

//     initial begin
//         $monitor($time, , "set: %b, inputs: %b, selectLine %b, selectConfig: %b, out: %b",  set, inputs, DUT.selectLine, selectConfig, out);
//         @(posedge clock);
//         set <= 1'b1;
//         reset <= 1'b0;
//         selectConfig <= 4'b0000;
//         @(posedge clock);
//         inputs <= 12'b000000001111;
//         set <= 1'b0;
//         @(posedge clock);
//         inputs <= 12'b000000001110;
//         @(posedge clock);
//         set <= 1'b1;
//         selectConfig <= 4'b0100;
//         @(posedge clock);
//         inputs <= 12'b000000001111;
//         set <= 1'b0;

//         #5 $finish;
//     end
// endmodule: SweitchBox_test


module FPGA_test ();

    logic enAddress, reset, clock;
    logic [3:0] userInput;
    logic [4:0] setData;
    logic [3:0] out;
    logic [5:0] address;

    FPGA #(4) DUT(.*);
    initial begin
        reset = 1'b1;
        clock = 1'b1;
        forever #1 clock = ~clock;
    end

    initial begin
        $monitor($time, , "userInput: %b, address: %d, setData: %b, clbOut %b, out %b", userInput, address, setData, DUT.CLBOut, out);
        @(posedge clock);
        reset <= 1'b0;
        address <= 6'd40;
        setData <= 5'b00000; // muxselect input[0]
        @(posedge clock);

        address <= 6'd41;
        setData <= 5'b00001; // muxselect input[1]
        @(posedge clock);

        userInput <= 4'b0011; 

        address <= 6'd0;
        setData <= 5'b01000; // and gate
        @(posedge clock);

        address <= 6'd16;
        setData <= 5'b00000; // switchOut4[0] = CLBOut[0]
        @(posedge clock);

        address <= 6'd17;
        setData <= 5'b00001; // switchOut4[0] = CLBOut[0]
        @(posedge clock);

        address <= 6'd4;
        setData <= 5'b01010; // output is the same as select[0]
        @(posedge clock);

        address <= 6'd8;
        setData <= 5'b01010; // output is the same as select[0]
        @(posedge clock);
        address <= 6'd12;
        setData <= 5'b01010; // output is the same as select[0]
        @(posedge clock);
        
        address <= 6'd24;
        setData <= 5'b00000; // switchOut8[0] = CLBOut[4]
        @(posedge clock);
        address <= 6'd32;
        setData <= 5'b00000; // switchOut12[0] = CLBOut[8]
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);

        if (DUT.CLBOut != 16'b0001_0001_0001_0001) begin
            $display("failed and and pass case: %b\n", DUT.CLBOut);
        end else begin
            $display("passed full though testcase\n");
        end

        reset <= 1'b1;
        @(posedge clock);
        reset <= 1'b0;
        userInput <= 4'b0001; 
        address <= 6'd40;
        setData <= 5'b00000; // muxselect input[0]
        @(posedge clock);

        address <= 6'd41;
        setData <= 5'b00001; // muxselect input[1]
        @(posedge clock);

        address <= 6'd0;
        setData <= 5'b01010; // pass enable
        @(posedge clock);

        address <= 6'd4;
        setData <= 5'b00110; // xor
        @(posedge clock);
        
        address <= 6'd8;
        setData <= 5'b11010; // FF
        @(posedge clock);

        address <= 6'd12;
        setData <= 5'b01010; // wire
        @(posedge clock);

        address <= 6'd5;
        setData <= 5'b01000; // and
        @(posedge clock);

        address <= 6'd9;
        setData <= 5'b00110; // xor
        @(posedge clock);

        address <= 6'd13;
        setData <= 5'b11010; // FF
        @(posedge clock);

        address <= 6'd16;
        setData <= 5'b00000; // CLB4 0
        @(posedge clock);

        address <= 6'd17;
        setData <= 5'b01000; // CLB4 1
        @(posedge clock);

        address <= 6'd18;
        setData <= 5'b00000; // CLB4 0
        @(posedge clock);

        address <= 6'd19;
        setData <= 5'b01000; // CLB4 1
        @(posedge clock);

        address <= 6'd26;
        setData <= 5'b00001; // CLB9 0
        @(posedge clock);

        address <= 6'd27;
        setData <= 5'b01001; // CLB9 1
        @(posedge clock);

        address <= 6'd34;
        setData <= 5'b00001; // CLB9 1
        @(posedge clock);

    
        address <= 6'd24;
        setData <= 5'b00000; // switchOut8[0] = CLBOut[4]
        @(posedge clock);

        address <= 6'd32;
        setData <= 5'b00000; // switchOut12[0] = CLBOut[8]
        @(posedge clock);

        $display("finish setting up, out is counting");

        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        
        
        
    
        #5 $finish;
    end

endmodule: FPGA_test

// module muxSel_test ();

//     logic [1:0] selConfig;
//     logic [3:0] userInput;
//     logic clock, reset, set;
//     logic out;

//     muxSel DUT(.*);

//     initial begin
//         reset = 1'b1;
//         clock = 1'b1;
//         forever #1 clock = ~clock;
//     end

//     initial begin
//         $monitor($time, , "userInput: %b, selConfig: %b, out %b", userInput, setData, out);
//         @(posedge clock);
        

    
//         #5 $finish;
//     end

// endmodule: muxSel_test
