`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
    prng_chip prng_chip_one (.reset(reset), .en(io_in[0]), .sel(io_in[1]), .clk(clock), .seed(io_in[9:2]), .valid(io_out[8]), .rand_num(io_out[7:0]));

endmodule: my_chip

module prng_chip (
    input logic reset, en, sel, clk,
    input logic [7:0] seed, 
    output logic valid,
    output logic [7:0] rand_num
);

    // datapath:
    logic serial_input, reg_en, sipo_en, fibo_out, galo_out, 
          cntr_load, shifted_eight, cnt_en, fib_load, gal_load;
    logic [7:0] lsfr_rand_num, reg_rand_num, AES_out_num, shift_cnt;

    fibo_lsfr fibo1 (.clk(clk), .reset(reset), .load(fib_load), .seed(seed), .out_num(fibo_out));

    galo_lsfr galo1 (.clk(clk), .reset(reset), .load(gal_load), .seed(seed), .out_num(galo_out));

    Mux2to1 #(1) mux1 (.I0(fibo_out), .I1(galo_out), .S(sel), .Y(serial_input));

    ShiftRegister_SIPO #(8) sr_sipo1 (.D(8'd0), .serial(serial_input), .en(sipo_en), .left(1'b1), .clock(clk), .Q(lsfr_rand_num));

    Register #(8) reg1 (.en(reg_en), .clear(reset), .clock(clk), .D(lsfr_rand_num), .Q(reg_rand_num));

    // Mux2to1 #(8) mux2 (.I0(shift_cnt), .I1(8'd0), .S(cntr_load), .Y(cntr_in));
    
    Counter #(8) counter1 (.en(cnt_en), .clear(reset), .load(cntr_load), .up(1'b1), .clock(clk), .D(8'd0), .Q(shift_cnt));

    MagComp magcomp1 (.A(shift_cnt), .B(8'd8), .AeqB(shifted_eight), .AltB(), .AgtB());

    AES_Sbox Sbox1 (.input_num(reg_rand_num), .output_num(AES_out_num));

    control_path ctrl_pth1 (.reset(reset), .shifted_eight(shifted_eight), .enable(en), .clock(clk), 
                            .cntr_load(cntr_load), .fib_load(fib_load), .gal_load(gal_load), 
                            .cnt_en(cnt_en), .sipo_en(sipo_en), .valid(valid), .reg_en(reg_en));

    assign rand_num = AES_out_num;


endmodule: prng_chip

module control_path
(
    input logic reset, shifted_eight, enable, clock,
    output logic cntr_load, fib_load, gal_load, 
                 cnt_en, sipo_en, reg_en, valid
);

    enum logic [1:0] {reset_state = 2'b00, init = 2'b01, shift = 2'b10, done = 2'b11} curr_state, next_state;

    always_comb begin
        
        case(curr_state)

            reset_state: begin
                next_state = init;
                cntr_load = 0;
                fib_load = 0;
                gal_load = 0;
                cnt_en = 0;
                sipo_en = 0;
                reg_en = 0;
                valid = 0;
            end
            init: begin

                if(enable == 1) begin
                    next_state = shift;
                    cntr_load = 1;
                    fib_load = 1;
                    gal_load = 1;
                    cnt_en = 0;
                    sipo_en = 0;
                    reg_en = 0;
                    valid = 0;
                end
                else begin
                    next_state = init;
                    cntr_load = 0;
                    fib_load = 0;
                    gal_load = 0;
                    cnt_en = 0;
                    sipo_en = 0;
                    reg_en = 0;
                    valid = 0;
                end
            end 
            shift: begin
                if(shifted_eight == 1) begin
                    next_state = done;
                    cntr_load = 0;
                    fib_load = 0;
                    gal_load = 0;
                    cnt_en = 0;
                    sipo_en = 0;
                    reg_en = 1;
                    valid = 0;
                end
                else begin
                    next_state = shift;
                    cntr_load = 0;
                    fib_load = 0;
                    gal_load = 0;
                    cnt_en = 1;
                    sipo_en = 1;
                    reg_en = 0;
                    valid = 0;
                end
            end 
            done: begin
                next_state = reset_state ? reset_state : done;
                cntr_load = 0;
                fib_load = 0;
                gal_load = 0;
                cnt_en = 0;
                sipo_en = 0;
                reg_en = 0;
                valid = 1;
                
            end 

        endcase
    end

    always_ff @(posedge clock, posedge reset) begin

        if (reset) begin
            curr_state <= reset_state;
        end
        else begin
            curr_state <= next_state;
        end
    end


endmodule: control_path

module fibo_lsfr
(   
    input logic clk, reset, load,
    input logic [7:0] seed,
    output logic out_num
);

    // logic [7:0] state_in;
    logic [7:0] state_out;
    // logic nextbit, intermed_bit;

    // assign state_in = 8'b0;

    // Mux2to1 M1 (.I0(state_in), .I1(seed), .S(load), .Y({state_out[7], 
    //                                                     state_out[6], 
    //                                                     state_out[5], 
    //                                                     state_out[4], 
    //                                                     state_out[3],
    //                                                     state_out[2],
    //                                                     state_out[1],
    //                                                     nextbit}));

    // width_FlipFlop w_ff (.preset_L(), .reset_L(~reset), .clock(clk), .D(state_in), .Q(state_out));

    // xor G1(intermed_bit, state_out[4], state_out[6]);
    // xor G2(nextbit, state_out[2], intermed_bit);

    logic feedback;

    always_ff @(posedge clk, posedge reset) begin

        if(reset)
            state_out <= 8'b0;
        else if(load)
            state_out <= seed;
        else
            state_out <= {state_out[6:0], feedback};

    end
    
    assign feedback = (state_out[4] ^ state_out[7]) ^ state_out[2];

    assign out_num = feedback;

endmodule: fibo_lsfr



module galo_lsfr
(
    input logic clk, reset, load,
    input logic [7:0] seed,
    output logic out_num
);

    // logic [7:0] state_in;
    logic [7:0] state_out;
    logic feedback;

    // assign state_in = 8'b0;

    // Mux2to1 M1 (.I0(state_in), .I1(seed), .S(load), .Y({state_out[7], 
    //                                                     state_out[6], 
    //                                                     state_out[5], 
    //                                                     state_out[4], 
    //                                                     state_out[3],
    //                                                     state_out[2],
    //                                                     state_out[1],
    //                                                     nextbit}));

    // width_FlipFlop w_ff (.preset_L(), .reset_L(~reset), .clock(clk), .D(state_in), .Q(state_out));

    // xor G1(state_out[6], state_out[5], nextbit);
    // xor G2(state_out[5], state_out[4], nextbit);
    // xor G3(state_out[4], state_out[3], nextbit);

    always_ff @(posedge clk, posedge reset) begin

        if(reset)
            state_out <= 8'b0000_0000;
        else if(load)
            state_out <= seed;
        else begin
            state_out[7] <= state_out[6];
            state_out[6] <= state_out[5] ^ feedback;
            state_out[5] <= state_out[4] ^ feedback;
            state_out[4] <= state_out[3] ^ feedback;

            state_out[3:0] <= {state_out[2:0], feedback};
        end
    end

    assign feedback = state_out[7];

    // assign out_num[6] = out_num[5] ^ feedback;
    // assign out_num[5] = out_num[4] ^ feedback;
    // assign out_num[4] = out_num[3] ^ feedback;

    assign out_num = feedback;

endmodule: galo_lsfr

module AES_Sbox
(
    input logic [7:0] input_num,
    output logic [7:0] output_num
);

    logic U0, U1, U2, U3, U4, U5, U6, U7;

    logic S3, S7, S0, S6, S4, S1, S2, S5;

    logic y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, 
          y11, y12, y13, y14, y15, y16, y17, y18, y19, y20, y21;

    logic z0, z1, z2, z3, z4, z5, z6, z7, z8, z9, z10, 
          z11, z12, z13, z14, z15, z16, z17;

    logic tc1, tc2, tc3, tc4, tc5, tc6, tc7, tc8, tc9, tc10, 
          tc11, tc12, tc13, tc14, tc16, tc17, tc18, tc20, tc21, tc26;

    logic t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, 
          t11, t12, t13, t14, t15, t16, t17, t18, t19, t20,
          t21, t22, t23, t24, t25, t26, t27, t28, t29, t30,
          t31, t32, t33, t34, t35, t36, t37, t38, t39, t40,
          t41, t42, t43, t44, t45;

    assign {U0, U1, U2, U3, U4, U5, U6, U7} = input_num; 
    assign output_num = {S3, S7, S0, S6, S4, S1, S2, S5}; 

    assign y14 = U3 ^ U5;
    assign y13 = U0 ^ U6;
    assign y9 = U0 ^ U3;
    assign y8 = U0 ^ U5;
    assign t0 = U1 ^ U2;
    assign y1 = t0 ^ U7;
    assign y4 = y1 ^ U3;
    assign y12 = y13 ^ y14;
    assign y2 = y1 ^ U0;
    assign y5 = y1 ^ U6;
    assign y3 = y5 ^ y8;
    assign t1 = U4 ^ y12;
    assign y15 = t1 ^ U5;
    assign y20 = t1 ^ U1;
    assign y6 = y15 ^ U7;
    assign y10 = y15 ^ t0;
    assign y11 = y20 ^ y9;
    assign y7 = U7 ^ y11;
    assign y17 = y10 ^ y11;
    assign y19 = y10 ^ y8;
    assign y16 = t0 ^ y11;
    assign y21 = y13 ^ y16;
    assign y18 = U0 ^ y16;
    assign t2 = y12 & y15;
    assign t3 = y3 & y6;
    assign t4 = t3 ^ t2;
    assign t5 = y4 & U7;
    assign t6 = t5 ^ t2;
    assign t7 = y13 & y16;
    assign t8 = y5 & y1;
    assign t9 = t8 ^ t7;
    assign t10 = y2 & y7;
    assign t11 = t10 ^ t7;
    assign t12 = y9 & y11;
    assign t13 = y14 & y17;
    assign t14 = t13 ^ t12;
    assign t15 = y8 & y10;
    assign t16 = t15 ^ t12;
    assign t17 = t4 ^ y20;
    assign t18 = t6 ^ t16;
    assign t19 = t9 ^ t14;
    assign t20 = t11 ^ t16;
    assign t21 = t17 ^ t14;
    assign t22 = t18 ^ y19;
    assign t23 = t19 ^ y21;
    assign t24 = t20 ^ y18;
    assign t25 = t21 ^ t22;
    assign t26 = t21 & t23;
    assign t27 = t24 ^ t26;
    assign t28 = t25 & t27;
    assign t29 = t28 ^ t22;
    assign t30 = t23 ^ t24;
    assign t31 = t22 ^ t26;
    assign t32 = t31 & t30;
    assign t33 = t32 ^ t24;
    assign t34 = t23 ^ t33;
    assign t35 = t27 ^ t33;
    assign t36 = t24 & t35;
    assign t37 = t36 ^ t34;
    assign t38 = t27 ^ t36;
    assign t39 = t29 & t38;
    assign t40 = t25 ^ t39;
    assign t41 = t40 ^ t37;
    assign t42 = t29 ^ t33;
    assign t43 = t29 ^ t40;
    assign t44 = t33 ^ t37;
    assign t45 = t42 ^ t41;
    assign z0 = t44 & y15;
    assign z1 = t37 & y6;
    assign z2 = t33 & U7;
    assign z3 = t43 & y16;
    assign z4 = t40 & y1;
    assign z5 = t29 & y7;
    assign z6 = t42 & y11;
    assign z7 = t45 & y17;
    assign z8 = t41 & y10;
    assign z9 = t44 & y12;
    assign z10 = t37 & y3;
    assign z11 = t33 & y4;
    assign z12 = t43 & y13;
    assign z13 = t40 & y5;
    assign z14 = t29 & y2;
    assign z15 = t42 & y9;
    assign z16 = t45 & y14;
    assign z17 = t41 & y8;
    assign tc1 = z15 ^ z16;
    assign tc2 = z10 ^ tc1;
    assign tc3 = z9 ^ tc2;
    assign tc4 = z0 ^ z2;
    assign tc5 = z1 ^ z0;
    assign tc6 = z3 ^ z4;
    assign tc7 = z12 ^ tc4;
    assign tc8 = z7 ^ tc6;
    assign tc9 = z8 ^ tc7;
    assign tc10 = tc8 ^ tc9;
    assign tc11 = tc6 ^ tc5;
    assign tc12 = z3 ^ z5;
    assign tc13 = z13 ^ tc1;
    assign tc14 = tc4 ^ tc12;
    assign S3 = tc3 ^ tc11;
    assign tc16 = z6 ^ tc8;
    assign tc17 = z14 ^ tc10;
    assign tc18 = tc13 ^ tc14;
    assign S7 = ~(z12 ^ tc18);
    assign tc20 = z15 ^ tc16;
    assign tc21 = tc2 ^ z11;
    assign S0 = tc3 ^ tc16;
    assign S6 = ~(tc10 ^ tc18);
    assign S4 = tc14 ^ S3;
    assign S1 = ~(S3 ^ tc16);
    assign tc26 = tc17 ^ tc20;
    assign S2 = ~(tc26 ^ z17);
    assign S5 = tc21 ^ tc17;

endmodule: AES_Sbox
