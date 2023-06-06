# 18-224 Student Designs Spring 2023

This repository contains the tapeout infrastructure and student designs from the Spring 2023 18-224/18-624/98-154 course "Intro to Open-Source Chip Design" at Carnegie Mellon.

## The Course

The course was run for the first time in Spring 2023 as a way to introduce students to chip design who might not otherwise get that exposure and give them an opportunity to do mini-tapeout project. Students were taught a variety of tools including Yosys, OpenLANE/OpenROAD, NextPNR, Verilator, CocoTB, MCY, Chisel, Amaranth, LiteX, and more.

The course culminated in a final project where students were given a limited area (equivalent to ~4000 standard cells) in which to design a chip of their choosing. Students chose a variety of projects ranging from games to CPUs to accelerators.

## The Chip

The final chip, taped out through the Skywater foundry (via the Efabless ChipIgnite program), is comprised of all student designs merged together, along with a multiplexer unit to share the limited I/O ports amongst all of the designs. Each design is given 12 outputs, 12 inputs, and a dedicated clock and reset signal. 

## Index of Designs

Following is a list of student designs on the chip, along with the design indices (The `des_sel` pins on the chip are used to enable a particular design).

Designs \#1-\#7 are example designs and test-structures used for teaching purposes. \#10-\#30 are student designs from the Spring 2023 course, and \#31-\#43 are from a similar workshop taught in Fall 2022.

| **Index** | **Project**                          | **Student**             | **Link**                                                     |
|-----------|--------------------------------------|-------------------------|--------------------------------------------------------------|
| 1         | 6-Bit Combinational Adder            | (demo)                  | [d01_example_adder](designs/d01_example_adder)               |
| 2         | 12-Bit Counter                       | (demo)                  | [d02_example_counter](designs/d02_example_counter)           |
| 3         | "Beep Boop" Traffic Light Controller | (demo)                  | [d03_example_beepboop](designs/d03_example_beepboop)         |
| 4         | AES-128 Side-Channel Model           | (demo)                  | [d04_example_aes128sca](designs/d04_example_aes128sca)       |
| 5         | Tapeout Meta-Info                    | (demo)                  | [d05_meta_info](designs/d05_meta_info)                       |
| 6         | Pong Game with VGA                   | (demo)                  | [d06_demo_vgapong](designs/d06_demo_vgapong)                 |
| 7         | Endless Runner Game with VGA         | (demo)                  | [d07_demo_vgarunner](designs/d07_demo_vgarunner)             |
|           |                                      |                         |                                                              |
| 10        | Tic-Tac-Toe Game                     | Wahib Abib              | [d10_wabib_tictactoe](designs/d10_wabib_tictactoe)           |
| 11        | Brainfuck CPU                        | Gary Bailey             | [d11_gbailey_bfchip](designs/d11_gbailey_bfchip)             |
| 12        | I2C Peripheral                       | Owen Ball               | [d12_oball_i2c](designs/d12_oball_i2c)                       |
| 13        | S444 FPGA Logic Cell                 | Jack Duvall             | [d13_jrduvall_s444](designs/d13_jrduvall_s444)               |
| 14        | Traffic Light Controller             | Jessie Fan              | [d14_jessief_trafficlight](designs/d14_jessief_trafficlight) |
| 15        | Pseudo Random Number Generator       | Jerry Feng              | [d15_jerryfen_prng](designs/d15_jerryfen_prng)               |
| 16        | Digital Phase Locked Loop            | Joel Gonzalez           | [d16_bgonzale_pll](designs/d16_bgonzale_pll)                 |
| 17        | Tetris Game                          | Navod Jayawardhane      | [d17_njayawar_tetris](designs/d17_njayawar_tetris)           |
| 18        | Multiply-Accumulate Unit             | Nikhil Dinkar Joshi     | [d18_nikhildj_mac](designs/d18_nikhildj_mac)                 |
| 19        | Encryption Unit (custom cipher)      | Roman Kapur             | [d19_rdkapur_encryptor](designs/d19_rdkapur_encryptor)       |
| 20        | Simplified Tetris Game               | Rashi Kejriwal          | [d20_rashik_tetris](designs/d20_rashik_tetris)               |
| 21        | Motor Controller                     | Varun Kumar             | [d21_varunk2_motorctrl](designs/d21_varunk2_motorctrl)       |
| 22        | Convolution Accelerator              | Yushuang Liu            | [d22_yushuanl_convolution](designs/d22_yushuanl_convolution) |
| 23        | Turing Machine                       | Ying Meng               | [d23_zhiyingm_turing](designs/d23_zhiyingm_turing)           |
| 24        | Tensor Processing Unit               | M Nguyen                | [d24_mnguyen2_tpu](designs/d24_mnguyen2_tpu)                 |
| 25        | Huffman Encoder                      | Anusha Raghavendra      | [d25_araghave_huffman](designs/d25_araghave_huffman)         |
| 26        | Trainable Perceptron                 | Christopher Stange      | [d26_cjstange_perceptron](designs/d26_cjstange_perceptron)   |
| 27        | Floating Point Unit                  | Sri Lakshmi Vemulapalli | [d27_svemulap_fpu](designs/d27_svemulap_fpu)                 |
| 28        | Microcoded CPU                       | Ganesh Venkatachalam    | [d28_gvenkata_ucpu](designs/d28_gvenkata_ucpu)               |
| 29        | Intel 8008-based CPU                 | Brendan Wilhelm         | [d29_bwilhelm_i8008](designs/d29_bwilhelm_i8008)             |
| 30        | Tiny FPGA                            | Yu-Ching Wu             | [d30_yuchingw_fpga](designs/d30_yuchingw_fpga)               |
|           |                                      |                         |                                                              |
| 31        | Linear Feedback Shift Register       | Mihir Dhamankar         | [d31_mdhamank_lfsr](designs/d31_mdhamank_lfsr)               |
| 32        | 4-bit CPU                            | Noah Gaertner           | [d32_ngaertne_cpu](designs/d32_ngaertne_cpu)                 |
| 33        | Adder Architecture in Wokwi          | Michael Gee             | [d33_mgee3_adder](designs/d33_mgee3_adder)                   |
| 34        | Collatz Sequence Computer            | Harrison Grodin         | [d34_hgrodin_collatz](designs/d34_hgrodin_collatz)           |
| 35        | Magnitude Comparator                 | Caroline Kasuba         | [d35_ckasuba_comparator](designs/d35_ckasuba_comparator)     |
| 36        | Floating Point Multiplier            | Joseph Li               | [d36_jxli_fpmul](designs/d36_jxli_fpmul)                     |
| 37        | Calculator Chip                      | Sophia Li               | [d37_sophiali_calculator](designs/d37_sophiali_calculator)   |
| 38        | PWM Signal Generator                 | Jason Lu                | [d38_jxlu_pwm](designs/d38_jxlu_pwm)                         |
| 39        | Hex to Seven-Segment                 | Kachi Onyeador          | [d39_oonyeado_sevenseg](designs/d39_oonyeado_sevenseg)       |
| 40        | Clock Domain Crossing FIFO           | Jon Recta               | [d40_jrecta_asyncfifo](designs/d40_jrecta_asyncfifo)         |
| 41        | "Corral" Game                        | Michael Stroucken       | [d41_stroucki_corralgame](designs/d41_stroucki_corralgame)   |
| 42        | Hex to Seven-Segment                 | Samuel Sun              | [d42_qilins_sevenseg](designs/d42_qilins_sevenseg)           |
| 43        | Counter                              | Mason Xiao              | [d43_mmx_counter](designs/d43_mmx_counter)                   |



## Multiplexer Documentation

TODO

## Bringup Instructions

TODO
