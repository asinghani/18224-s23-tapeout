module tb_top;
	reg [23:0] data_in [0:4];
	reg [2:0] freq [0:4];
	reg [23:0] temp;
	reg [40:0] input_string;
	reg [8:0] freq_in [0:4];
	reg data_en;
	reg clk;
	reg reset;
	reg done;
	integer i;
	wire [11:0] io_out;
	reg [11:0] io_in;
	reg [11:0] temp1;
	reg [71:0] expected_out [0:4];
	integer j;
	integer vector_num;
	integer num;
	integer test_num;
	reg signed [31:0] f;
	reg signed [31:0] f1;
	reg vector_done;
	wire signed [31:0] line;
	reg signed [31:0] iter;
	reg signed [31:0] line1;
	reg signed [31:0] line2;
	wire signed [31:0] line3;
	wire signed [31:0] line4;
	huff_encoder DUT(
		.clk(clk),
		.reset(reset),
		.io_in(io_in),
		.io_out(io_out)
	);
	initial begin
		clk = 0;
		reset = 1;
		vector_num = 0;
		done = 1'b0;
		num = 0;
		test_num = 0;
		f = $fopen("input_vector.txt", "r");
		f1 = $fopen("expected_out.txt", "rb");
		while (!$feof(f1)) begin
			line1 = $fscanf(f1, "%b", temp1);
			if (line1 == 1) begin
				expected_out[test_num][(5 - num) * 12+:12] = temp1;
				test_num = (num == 'd5 ? test_num + 1 : test_num);
				num = (num < 'd5 ? num + 1 : 'd0);
			end
		end
		while (!$feof(f)) begin
			line1 = $fgets(input_string, f);
			if (line1 == 5) begin
				line2 = $sscanf(input_string, "%3d,%3d,%3d\n", freq[0], freq[1], freq[2]);
				freq_in[vector_num][6+:3] = freq[0];
				freq_in[vector_num][3+:3] = freq[1];
				freq_in[vector_num][0+:3] = freq[2];
			end
			else if (line1 == 4) begin
				line2 = $sscanf(input_string, "%s\n", temp);
				data_in[vector_num] = temp;
				vector_num = vector_num + 1;
			end
		end
		$fclose(f);
		$fclose(f1);
		#(5) reset = 0;
		#(150)
			;
		$finish;
	end
	always @(posedge clk)
		if (reset) begin
			i <= 'b0;
			io_in = 'b0;
			iter = 'd0;
			data_en = 'b1;
		end
		else begin
			if (i < 3)
				io_in[11:0] = {1'b1, freq_in[iter][(2 - i) * 3+:3], data_in[iter][(2 - i) * 8+:8]};
			else
				io_in[11] = 1'b0;
			i <= (vector_done ? 'b0 : i + 1'b1);
			iter = (vector_done ? iter + 1 : iter);
			if (vector_done) begin
				$display("******************************************");
				$display("\nvector starting with num:%d", iter);
			end
			if (iter == 5)
				$finish;
		end
	always @(posedge clk) begin
		if (reset) begin
			j <= 'b0;
			vector_done <= 'b0;
		end
		else if (io_out[8] && !vector_done) begin
			if (io_out[8:0] !== expected_out[iter][(5 - j) * 12+:12])
				$error("ASSERTION FAILED in %m: signal=%b != value=%b", io_out[8:0], expected_out[iter][(5 - j) * 12+:12]);
			j <= (j == 5 ? 'b0 : j + 1);
		end
		vector_done <= (j == 5 ? 'b1 : 'b0);
	end
	always #(0.5) clk = ~clk;
	always if (io_out[8]) begin : sv2v_autoblock_1
		reg signed [31:0] i;
		for (i = 0; i < 3; i = i + 1)
			$display("OUTPUT: character[%0d]:%2h(%s), encoded mask[%0d]:%b, encoded values[%0d]:%b\n", i, {3'b011, DUT.character[i]}, {3'b011, DUT.character[i]}, i, DUT.encoded_mask[i], i, DUT.encoded_value[i]);
	end
endmodule
