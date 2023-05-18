/* Generated by Yosys 0.25+83 (git sha1 755b753e1, aarch64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

/* top =  1  */
/* src = "d33_mgee3_adder/src/wrapper.v:2.9-12.18" */
module d33_mgee3_adder(io_in, io_out);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  /* src = "d33_mgee3_adder/src/wrapper.v:3.26-3.31" */
  input [13:0] io_in;
  wire [13:0] io_in;
  /* src = "d33_mgee3_adder/src/wrapper.v:4.27-4.33" */
  output [13:0] io_out;
  wire [13:0] io_out;
  /* hdlname = "mchip gate10 a" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:17.16-17.17|d33_mgee3_adder/src/wokwi.v:52.12-56.4" */
  wire \mchip.gate10.a ;
  /* hdlname = "mchip gate10 b" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:18.16-18.17|d33_mgee3_adder/src/wokwi.v:52.12-56.4" */
  wire \mchip.gate10.b ;
  /* hdlname = "mchip gate12 a" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:35.16-35.17|d33_mgee3_adder/src/wokwi.v:62.12-66.4" */
  wire \mchip.gate12.a ;
  /* hdlname = "mchip gate12 b" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:36.16-36.17|d33_mgee3_adder/src/wokwi.v:62.12-66.4" */
  wire \mchip.gate12.b ;
  /* hdlname = "mchip gate13 out" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:37.17-37.20|d33_mgee3_adder/src/wokwi.v:67.12-71.4" */
  wire \mchip.gate13.out ;
  /* hdlname = "mchip gate15 a" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:17.16-17.17|d33_mgee3_adder/src/wokwi.v:77.12-81.4" */
  wire \mchip.gate15.a ;
  /* hdlname = "mchip gate15 b" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:18.16-18.17|d33_mgee3_adder/src/wokwi.v:77.12-81.4" */
  wire \mchip.gate15.b ;
  /* hdlname = "mchip gate16 out" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:28.17-28.20|d33_mgee3_adder/src/wokwi.v:82.11-86.4" */
  wire \mchip.gate16.out ;
  /* hdlname = "mchip gate17 a" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:17.16-17.17|d33_mgee3_adder/src/wokwi.v:87.12-91.4" */
  wire \mchip.gate17.a ;
  /* hdlname = "mchip gate17 b" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:18.16-18.17|d33_mgee3_adder/src/wokwi.v:87.12-91.4" */
  wire \mchip.gate17.b ;
  /* hdlname = "mchip gate18 a" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:35.16-35.17|d33_mgee3_adder/src/wokwi.v:92.12-96.4" */
  wire \mchip.gate18.a ;
  /* hdlname = "mchip gate18 b" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:36.16-36.17|d33_mgee3_adder/src/wokwi.v:92.12-96.4" */
  wire \mchip.gate18.b ;
  /* hdlname = "mchip gate18 out" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:37.17-37.20|d33_mgee3_adder/src/wokwi.v:92.12-96.4" */
  wire \mchip.gate18.out ;
  /* hdlname = "mchip gate7 a" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:35.16-35.17|d33_mgee3_adder/src/wokwi.v:37.12-41.4" */
  wire \mchip.gate7.a ;
  /* hdlname = "mchip gate7 b" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:36.16-36.17|d33_mgee3_adder/src/wokwi.v:37.12-41.4" */
  wire \mchip.gate7.b ;
  /* hdlname = "mchip gate8 out" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/cells.v:37.17-37.20|d33_mgee3_adder/src/wokwi.v:42.12-46.4" */
  wire \mchip.gate8.out ;
  /* hdlname = "mchip io_in" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:6.15-6.20" */
  /* unused_bits = "6 7" */
  wire [7:0] \mchip.io_in ;
  /* hdlname = "mchip io_out" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:7.16-7.22" */
  wire [7:0] \mchip.io_out ;
  /* hdlname = "mchip net1" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:9.8-9.12" */
  wire \mchip.net1 ;
  /* hdlname = "mchip net10" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:18.8-18.13" */
  wire \mchip.net10 ;
  /* hdlname = "mchip net11" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:19.8-19.13" */
  wire \mchip.net11 ;
  /* hdlname = "mchip net12" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:20.8-20.13" */
  wire \mchip.net12 ;
  /* hdlname = "mchip net14" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:22.8-22.13" */
  wire \mchip.net14 ;
  /* hdlname = "mchip net2" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:10.8-10.12" */
  wire \mchip.net2 ;
  /* hdlname = "mchip net22" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:30.8-30.13" */
  wire \mchip.net22 ;
  /* hdlname = "mchip net3" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:11.8-11.12" */
  wire \mchip.net3 ;
  /* hdlname = "mchip net4" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:12.8-12.12" */
  wire \mchip.net4 ;
  /* hdlname = "mchip net5" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:13.8-13.12" */
  wire \mchip.net5 ;
  /* hdlname = "mchip net6" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:14.8-14.12" */
  wire \mchip.net6 ;
  /* hdlname = "mchip net7" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:15.8-15.12" */
  wire \mchip.net7 ;
  /* hdlname = "mchip net8" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:16.8-16.12" */
  wire \mchip.net8 ;
  /* hdlname = "mchip net9" */
  /* src = "d33_mgee3_adder/src/wrapper.v:7.44-10.14|d33_mgee3_adder/src/wokwi.v:17.8-17.12" */
  wire \mchip.net9 ;
  assign \mchip.gate18.out  = io_in[0] ^ io_in[3];
  assign _00_ = io_in[2] & io_in[5];
  assign _01_ = ~(io_in[0] & io_in[3]);
  assign _02_ = ~(io_in[1] ^ io_in[4]);
  assign _03_ = ~(_02_ | _01_);
  assign _04_ = io_in[1] & io_in[4];
  assign _05_ = _04_ | _03_;
  assign _06_ = io_in[2] ^ io_in[5];
  assign _07_ = _06_ & _05_;
  assign \mchip.gate16.out  = _07_ | _00_;
  assign \mchip.gate13.out  = _06_ ^ _05_;
  assign \mchip.gate8.out  = _02_ ^ _01_;
  assign io_out = { 10'h000, \mchip.gate16.out , \mchip.gate13.out , \mchip.gate8.out , \mchip.gate18.out  };
  assign \mchip.gate10.a  = io_in[1];
  assign \mchip.gate10.b  = io_in[4];
  assign \mchip.gate12.a  = io_in[2];
  assign \mchip.gate12.b  = io_in[5];
  assign \mchip.gate15.a  = io_in[2];
  assign \mchip.gate15.b  = io_in[5];
  assign \mchip.gate17.a  = io_in[0];
  assign \mchip.gate17.b  = io_in[3];
  assign \mchip.gate18.a  = io_in[0];
  assign \mchip.gate18.b  = io_in[3];
  assign \mchip.gate7.a  = io_in[1];
  assign \mchip.gate7.b  = io_in[4];
  assign \mchip.io_in  = io_in[7:0];
  assign \mchip.io_out  = { 4'h0, \mchip.gate16.out , \mchip.gate13.out , \mchip.gate8.out , \mchip.gate18.out  };
  assign \mchip.net1  = \mchip.gate18.out ;
  assign \mchip.net10  = io_in[5];
  assign \mchip.net11  = 1'h0;
  assign \mchip.net12  = 1'h1;
  assign \mchip.net14  = 1'h0;
  assign \mchip.net2  = \mchip.gate8.out ;
  assign \mchip.net22  = 1'h0;
  assign \mchip.net3  = \mchip.gate13.out ;
  assign \mchip.net4  = \mchip.gate16.out ;
  assign \mchip.net5  = io_in[0];
  assign \mchip.net6  = io_in[1];
  assign \mchip.net7  = io_in[2];
  assign \mchip.net8  = io_in[3];
  assign \mchip.net9  = io_in[4];
endmodule