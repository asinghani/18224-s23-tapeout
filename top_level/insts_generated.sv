`default_nettype none

module design_instantiations (
	input logic [11:0] io_in,
	output logic [11:0] io_out,

	input logic [5:0] des_sel,
	input logic hold_if_not_sel,
	input logic sync_inputs,

	input logic clock, reset
);

	logic [11:0] des_io_in[0:63];
	logic [11:0] des_io_out[0:63];
	logic des_reset[0:63];

    multiplexer mux (.*);

// Design #0
// Unpopulated design slot
assign des_io_out[0] = 12'h000;


// Design #1
// Design name d01_example_adder
d01_example_adder inst1 (
    .io_in({des_reset[1], clock, des_io_in[1]}),
    .io_out(des_io_out[1])
);


// Design #2
// Design name d02_example_counter
d02_example_counter inst2 (
    .io_in({des_reset[2], clock, des_io_in[2]}),
    .io_out(des_io_out[2])
);


// Design #3
// Design name d03_example_beepboop
d03_example_beepboop inst3 (
    .io_in({des_reset[3], clock, des_io_in[3]}),
    .io_out(des_io_out[3])
);


// Design #4
// Unpopulated design slot
assign des_io_out[4] = 12'h000;


// Design #5
// Design name d05_meta_info
d05_meta_info inst5 (
    .io_in({des_reset[5], clock, des_io_in[5]}),
    .io_out(des_io_out[5])
);


// Design #6
// Design name d06_demo_vgapong
d06_demo_vgapong inst6 (
    .io_in({des_reset[6], clock, des_io_in[6]}),
    .io_out(des_io_out[6])
);


// Design #7
// Design name d07_demo_vgarunner
d07_demo_vgarunner inst7 (
    .io_in({des_reset[7], clock, des_io_in[7]}),
    .io_out(des_io_out[7])
);


// Design #8
// Unpopulated design slot
assign des_io_out[8] = 12'h000;


// Design #9
// Unpopulated design slot
assign des_io_out[9] = 12'h000;


// Design #10
// Unpopulated design slot
assign des_io_out[10] = 12'h000;


// Design #11
// Design name d11_gbailey_bfchip
d11_gbailey_bfchip inst11 (
    .io_in({des_reset[11], clock, des_io_in[11]}),
    .io_out(des_io_out[11])
);


// Design #12
// Design name d12_oball_i2c
d12_oball_i2c inst12 (
    .io_in({des_reset[12], clock, des_io_in[12]}),
    .io_out(des_io_out[12])
);


// Design #13
// Design name d13_jrduvall_s444
d13_jrduvall_s444 inst13 (
    .io_in({des_reset[13], clock, des_io_in[13]}),
    .io_out(des_io_out[13])
);


// Design #14
// Design name d14_jessief_trafficlight
d14_jessief_trafficlight inst14 (
    .io_in({des_reset[14], clock, des_io_in[14]}),
    .io_out(des_io_out[14])
);


// Design #15
// Design name d15_jerryfen_prng
d15_jerryfen_prng inst15 (
    .io_in({des_reset[15], clock, des_io_in[15]}),
    .io_out(des_io_out[15])
);


// Design #16
// Design name d16_bgonzale_pll
d16_bgonzale_pll inst16 (
    .io_in({des_reset[16], clock, des_io_in[16]}),
    .io_out(des_io_out[16])
);


// Design #17
// Design name d17_njayawar_tetris
d17_njayawar_tetris inst17 (
    .io_in({des_reset[17], clock, des_io_in[17]}),
    .io_out(des_io_out[17])
);


// Design #18
// Design name d18_nikhildj_mac
d18_nikhildj_mac inst18 (
    .io_in({des_reset[18], clock, des_io_in[18]}),
    .io_out(des_io_out[18])
);


// Design #19
// Design name d19_rdkapur_encryptor
d19_rdkapur_encryptor inst19 (
    .io_in({des_reset[19], clock, des_io_in[19]}),
    .io_out(des_io_out[19])
);


// Design #20
// Design name d20_rashik_tetris
d20_rashik_tetris inst20 (
    .io_in({des_reset[20], clock, des_io_in[20]}),
    .io_out(des_io_out[20])
);


// Design #21
// Design name d21_varunk2_motorctrl
d21_varunk2_motorctrl inst21 (
    .io_in({des_reset[21], clock, des_io_in[21]}),
    .io_out(des_io_out[21])
);


// Design #22
// Design name d22_yushuanl_convolution
d22_yushuanl_convolution inst22 (
    .io_in({des_reset[22], clock, des_io_in[22]}),
    .io_out(des_io_out[22])
);


// Design #23
// Design name d23_zhiyingm_turing
d23_zhiyingm_turing inst23 (
    .io_in({des_reset[23], clock, des_io_in[23]}),
    .io_out(des_io_out[23])
);


// Design #24
// Design name d24_mnguyen2_tpu
d24_mnguyen2_tpu inst24 (
    .io_in({des_reset[24], clock, des_io_in[24]}),
    .io_out(des_io_out[24])
);


// Design #25
// Design name d25_araghave_huffman
d25_araghave_huffman inst25 (
    .io_in({des_reset[25], clock, des_io_in[25]}),
    .io_out(des_io_out[25])
);


// Design #26
// Design name d26_cjstange_perceptron
d26_cjstange_perceptron inst26 (
    .io_in({des_reset[26], clock, des_io_in[26]}),
    .io_out(des_io_out[26])
);


// Design #27
// Design name d27_svemulap_fpu
d27_svemulap_fpu inst27 (
    .io_in({des_reset[27], clock, des_io_in[27]}),
    .io_out(des_io_out[27])
);


// Design #28
// Design name d28_gvenkata_ucpu
d28_gvenkata_ucpu inst28 (
    .io_in({des_reset[28], clock, des_io_in[28]}),
    .io_out(des_io_out[28])
);


// Design #29
// Design name d29_bwilhelm_i8008
d29_bwilhelm_i8008 inst29 (
    .io_in({des_reset[29], clock, des_io_in[29]}),
    .io_out(des_io_out[29])
);


// Design #30
// Design name d30_yuchingw_fpga
d30_yuchingw_fpga inst30 (
    .io_in({des_reset[30], clock, des_io_in[30]}),
    .io_out(des_io_out[30])
);


// Design #31
// Design name d31_mdhamank_lfsr
d31_mdhamank_lfsr inst31 (
    .io_in({des_reset[31], clock, des_io_in[31]}),
    .io_out(des_io_out[31])
);


// Design #32
// Design name d32_ngaertne_cpu
d32_ngaertne_cpu inst32 (
    .io_in({des_reset[32], clock, des_io_in[32]}),
    .io_out(des_io_out[32])
);


// Design #33
// Design name d33_mgee3_adder
d33_mgee3_adder inst33 (
    .io_in({des_reset[33], clock, des_io_in[33]}),
    .io_out(des_io_out[33])
);


// Design #34
// Design name d34_hgrodin_collatz
d34_hgrodin_collatz inst34 (
    .io_in({des_reset[34], clock, des_io_in[34]}),
    .io_out(des_io_out[34])
);


// Design #35
// Design name d35_ckasuba_comparator
d35_ckasuba_comparator inst35 (
    .io_in({des_reset[35], clock, des_io_in[35]}),
    .io_out(des_io_out[35])
);


// Design #36
// Design name d36_jxli_fpmul
d36_jxli_fpmul inst36 (
    .io_in({des_reset[36], clock, des_io_in[36]}),
    .io_out(des_io_out[36])
);


// Design #37
// Design name d37_sophiali_calculator
d37_sophiali_calculator inst37 (
    .io_in({des_reset[37], clock, des_io_in[37]}),
    .io_out(des_io_out[37])
);


// Design #38
// Design name d38_jxlu_pwm
d38_jxlu_pwm inst38 (
    .io_in({des_reset[38], clock, des_io_in[38]}),
    .io_out(des_io_out[38])
);


// Design #39
// Design name d39_oonyeado_sevenseg
d39_oonyeado_sevenseg inst39 (
    .io_in({des_reset[39], clock, des_io_in[39]}),
    .io_out(des_io_out[39])
);


// Design #40
// Design name d40_jrecta_asyncfifo
d40_jrecta_asyncfifo inst40 (
    .io_in({des_reset[40], clock, des_io_in[40]}),
    .io_out(des_io_out[40])
);


// Design #41
// Design name d41_stroucki_corralgame
d41_stroucki_corralgame inst41 (
    .io_in({des_reset[41], clock, des_io_in[41]}),
    .io_out(des_io_out[41])
);


// Design #42
// Design name d42_qilins_sevenseg
d42_qilins_sevenseg inst42 (
    .io_in({des_reset[42], clock, des_io_in[42]}),
    .io_out(des_io_out[42])
);


// Design #43
// Design name d43_mmx_counter
d43_mmx_counter inst43 (
    .io_in({des_reset[43], clock, des_io_in[43]}),
    .io_out(des_io_out[43])
);


// Design #44
// Unpopulated design slot
assign des_io_out[44] = 12'h000;


// Design #45
// Unpopulated design slot
assign des_io_out[45] = 12'h000;


// Design #46
// Unpopulated design slot
assign des_io_out[46] = 12'h000;


// Design #47
// Unpopulated design slot
assign des_io_out[47] = 12'h000;


// Design #48
// Unpopulated design slot
assign des_io_out[48] = 12'h000;


// Design #49
// Unpopulated design slot
assign des_io_out[49] = 12'h000;


// Design #50
// Unpopulated design slot
assign des_io_out[50] = 12'h000;


// Design #51
// Unpopulated design slot
assign des_io_out[51] = 12'h000;


// Design #52
// Unpopulated design slot
assign des_io_out[52] = 12'h000;


// Design #53
// Unpopulated design slot
assign des_io_out[53] = 12'h000;


// Design #54
// Unpopulated design slot
assign des_io_out[54] = 12'h000;


// Design #55
// Unpopulated design slot
assign des_io_out[55] = 12'h000;


// Design #56
// Unpopulated design slot
assign des_io_out[56] = 12'h000;


// Design #57
// Unpopulated design slot
assign des_io_out[57] = 12'h000;


// Design #58
// Unpopulated design slot
assign des_io_out[58] = 12'h000;


// Design #59
// Unpopulated design slot
assign des_io_out[59] = 12'h000;


// Design #60
// Unpopulated design slot
assign des_io_out[60] = 12'h000;


// Design #61
// Unpopulated design slot
assign des_io_out[61] = 12'h000;


// Design #62
// Unpopulated design slot
assign des_io_out[62] = 12'h000;


// Design #63
// Unpopulated design slot
assign des_io_out[63] = 12'h000;


endmodule
