`timescale 1ns / 1ps

module testbench ( );

	parameter CLOCK_PERIOD = 20;

	reg [0:0] KEY;
	reg CLOCK_50;
	reg [9:0] SW;
	wire [9:0] LEDR;

	initial begin
		CLOCK_50 <= 1'b0;
	end // initial
	always @ (*)
	begin : Clock_Generator
		#((CLOCK_PERIOD) / 2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
		KEY[0] <= 1'b0; SW <= 10'h0;
		#20 SW[4:0] <= 5'b11110; SW[9:5]	<= 5'b01010;
		#40 KEY[0] <= 1'b1;
	end // initial

	Accumulate U1 (KEY, CLOCK_50, SW, LEDR);

endmodule
