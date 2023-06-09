/* Generated by Yosys 0.25+83 (git sha1 755b753e1, aarch64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

/* top =  1  */
/* src = "d01_example_adder/src/toplevel_chip.v:4.1-18.10" */
module d01_example_adder(io_in, io_out);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  wire _08_;
  wire _09_;
  wire _10_;
  wire _11_;
  wire _12_;
  wire _13_;
  wire _14_;
  wire _15_;
  wire _16_;
  wire _17_;
  wire _18_;
  wire _19_;
  wire _20_;
  wire _21_;
  wire _22_;
  wire _23_;
  wire _24_;
  wire _25_;
  /* src = "d01_example_adder/src/toplevel_chip.v:5.18-5.23" */
  input [13:0] io_in;
  wire [13:0] io_in;
  /* src = "d01_example_adder/src/toplevel_chip.v:6.19-6.25" */
  output [13:0] io_out;
  wire [13:0] io_out;
  /* hdlname = "mchip clock" */
  /* src = "d01_example_adder/src/toplevel_chip.v:9.13-14.6|d01_example_adder/src/chip.sv:5.17-5.22" */
  /* unused_bits = "0" */
  wire \mchip.clock ;
  /* hdlname = "mchip io_in" */
  /* src = "d01_example_adder/src/toplevel_chip.v:9.13-14.6|d01_example_adder/src/chip.sv:4.24-4.29" */
  wire [11:0] \mchip.io_in ;
  /* hdlname = "mchip io_out" */
  /* src = "d01_example_adder/src/toplevel_chip.v:9.13-14.6|d01_example_adder/src/chip.sv:6.25-6.31" */
  wire [11:0] \mchip.io_out ;
  /* hdlname = "mchip reset" */
  /* src = "d01_example_adder/src/toplevel_chip.v:9.13-14.6|d01_example_adder/src/chip.sv:5.24-5.29" */
  /* unused_bits = "0" */
  wire \mchip.reset ;
  assign _00_ = io_in[11] ^ io_in[5];
  assign _01_ = ~(io_in[10] ^ io_in[4]);
  assign _02_ = _00_ & ~(_01_);
  assign _03_ = ~(io_in[9] & io_in[3]);
  assign _04_ = io_in[9] ^ io_in[3];
  assign _05_ = ~(io_in[8] & io_in[2]);
  assign _06_ = _04_ & ~(_05_);
  assign _07_ = _03_ & ~(_06_);
  assign _08_ = ~(io_in[8] ^ io_in[2]);
  assign _09_ = _04_ & ~(_08_);
  assign _10_ = ~(io_in[7] & io_in[1]);
  assign _11_ = io_in[7] ^ io_in[1];
  assign _12_ = ~(io_in[6] & io_in[0]);
  assign _13_ = _11_ & ~(_12_);
  assign _14_ = _10_ & ~(_13_);
  assign _15_ = _09_ & ~(_14_);
  assign _16_ = _07_ & ~(_15_);
  assign _17_ = _02_ & ~(_16_);
  assign _18_ = ~(io_in[10] & io_in[4]);
  assign _19_ = _00_ & ~(_18_);
  assign _20_ = io_in[11] & io_in[5];
  assign _21_ = _20_ | _19_;
  assign io_out[6] = _21_ | _17_;
  assign io_out[1] = ~(_12_ ^ _11_);
  assign io_out[2] = _14_ ^ _08_;
  assign _22_ = ~(_14_ | _08_);
  assign _23_ = _22_ | ~(_05_);
  assign io_out[3] = _23_ ^ _04_;
  assign io_out[4] = _16_ ^ _01_;
  assign _24_ = ~(_16_ | _01_);
  assign _25_ = _24_ | ~(_18_);
  assign io_out[5] = _25_ ^ _00_;
  assign io_out[0] = io_in[6] ^ io_in[0];
  assign io_out[13:7] = 7'h00;
  assign \mchip.clock  = io_in[12];
  assign \mchip.io_in  = io_in[11:0];
  assign \mchip.io_out  = { 5'h00, io_out[6:0] };
  assign \mchip.reset  = io_in[13];
endmodule
