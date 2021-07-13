// Data written to registers R0 to R5 are sent to the H digits
module seg7_scroll (Data, Addr, Sel, Resetn, Clock, H5, H4, H3, H2, H1, H0);
	input [6:0] Data;
	input [2:0] Addr;
	input Sel, Resetn, Clock;
	output [6:0] H5, H4, H3, H2, H1, H0;

	... your code goes here
	declare variables, instantiate registers, etc.
	
endmodule

module regne (R, Clock, Resetn, E, Q);
	parameter n = 7;
	input [n-1:0] R;
	input Clock, Resetn, E;
	output [n-1:0] Q;
	reg [n-1:0] Q;	
	
	always @(posedge Clock)
		if (Resetn == 0)
			Q <= {n{1'b0}};
		else if (E)
			Q <= R;
endmodule
