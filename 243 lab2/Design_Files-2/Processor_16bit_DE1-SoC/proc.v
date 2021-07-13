module proc(DIN, Resetn, Clock, Run, DOUT, ADDR, W, Done);
	input [15:0] DIN;
	input Resetn, Clock, Run;
	output wire [15:0] DOUT;
	output wire [15:0] ADDR;
	output wire W;
	output Done;

	parameter T0 = 3'b000, T1 = 3'b001, T2 = 3'b010, T3 = 3'b011, T4 = 3'b100, T5 = 3'b101;
	reg [15:0] BusWires;
	reg [0:7] Rin, Rout;
	reg [15:0] Sum;
	reg IRin, ADDRin, Done, DINout, DOUTin, Ain, Gin, Gout, AddSub;
	reg [2:0] Tstep_Q, Tstep_D;
	wire [2:0] I;
	wire [0:7] Xreg, Yreg;
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7 /* pc */, A;
	wire [15:0] G;
	wire [1:9] IR;
	wire [1:10] Sel; // bus selector
	reg pc_inc, W_D;
	
	assign I = IR[1:3];
	dec3to8 decX (IR[4:6], 1'b1, Xreg);
	dec3to8 decY (IR[7:9], 1'b1, Yreg);

	// Control FSM state table
	always @(Tstep_Q, Run, Done)
	begin
		case (Tstep_Q)
			T0: // instruction fetch
				if (~Run) Tstep_D = T0;
				else Tstep_D = T1;
			T1: // wait cycle for synchronous memory
 				Tstep_D = T2;
			T2: // this time step stores the instruction word in IR
 				Tstep_D = T3;
	 		T3: // some instructions end after this time step
				if (Done) Tstep_D = T0;
				else Tstep_D = T4;
			T4: // always go to T5 after this
 				Tstep_D = T5;
			T5: // instructions end after this time step
 				Tstep_D = T0;
		endcase
	end

	/* Instruction Table
	* 	000: mv		Rx,Ry		: Rx <- Ry
	* 	001: mvi		Rx,D		: Rx <- D
	* 	010: add		Rx,Ry		: Rx <- Rx + Ry
	* 	011: sub		Rx,Ry		: Rx <- Rx - Ry
	* 	100: ld		Rx,[Ry]	: Rx <- [Ry]
	* 	101: st		Rx,[Ry]	: [Ry] <- Rx
	* 	110: mvnz	Rx,Ry		: Rx <- Ry, if G != 0
	* 	111: mvnc	Rx,Ry		: Rx <- Ry, if carry-out != 1
	* 	OPCODE format: III XXX YYY , where 
	* 	III = instruction, XXX = Rx, and YYY = Ry. For mvi,
	* 	a second word of data is read in the following clock cycle
	*/
  	// R7 is the program counter
	parameter 
		mv = 3'b000, mvi = 3'b001, add = 3'b010, sub = 3'b011, ld = 3'b100, st = 3'b101;
	// Control FSM outputs
	always @(*)
	begin
		Done = 1'b0; Ain = 1'b0; Gin = 1'b0; Gout = 1'b0; AddSub = 1'b0;
		IRin = 1'b0; DINout = 1'b0; DOUTin = 1'b0; ADDRin = 1'b0; W_D = 1'b0;
		Rin = 8'b0; Rout = 8'b0; pc_inc = 1'b0;
		case (Tstep_Q)
			T0: // fetch the instruction
				begin
					Rout = 8'b00000001;	// R7 is program counter (pc)
					ADDRin = 1'b1;
					pc_inc = Run; // to increment pc
				end
			T1: // wait cycle for synchronous memory
				// in case the instruction turns out to be mvi, read memory
				begin
					Rout = 8'b00000001;	// R7 is program counter (pc)
					ADDRin = 1'b1;
				end
			T2: // store instruction on DIN in IR 
				begin
					IRin = 1'b1;
				end
			T3:   //define signals in T3
				case (I)
					mv: // mv Rx,Ry
					begin
						Rout = Yreg;
						Rin = Xreg;
						Done = 1'b1;
					end
					mvi: // mvi Rx,#D
					begin
						// data is available now on DIN
						DINout = 1'b1;
						Rin = Xreg; 
						pc_inc = 1'b1;
						Done = 1'b1;
					end
					add, sub: //add, sub 
					begin
						Rout = Xreg;
						Ain = 1'b1;
					end
					ld: // ld Rx,[Ry]
					begin
						// ... your code goes here
					end
					st: // st Rx,[Ry]
					begin
						// ... your code goes here
					end
					default: ;
			   endcase
			T4:   //define signals T4
				case (I)
					add: // add
					begin
						Rout = Yreg;
						Gin = 1'b1;
					end
					sub: // sub
					begin
						Rout = Yreg;
						AddSub = 1'b1;
						Gin = 1'b1;
					end
					ld: // ld Rx,[Ry]
						; // wait cycle for synchronous memory
					st: // st Rx,[Ry]
					begin
						// ... your code goes here
					end
					default: ; 
				endcase
			T5:   //define T5
				case (I)
					add, sub: //add, sub
					begin
						Gout = 1'b1;
						Rin = Xreg;
						Done = 1'b1;
					end
					ld: // ld Rx,[Ry]
					begin
						// ... your code goes here
					end
					st: // st Rx,[Ry]
					begin
						// ... your code goes here
					end
					default: ;
				endcase
			default: ;
		endcase
	end	
	
	// Control FSM flip-flops
	always @(posedge Clock)
		if (!Resetn)
			Tstep_Q <= T0;
		else
			Tstep_Q <= Tstep_D;	
	
	regn reg_0 (BusWires, Rin[0], Clock, R0);
	regn reg_1 (BusWires, Rin[1], Clock, R1);
	regn reg_2 (BusWires, Rin[2], Clock, R2);
	regn reg_3 (BusWires, Rin[3], Clock, R3);
	regn reg_4 (BusWires, Rin[4], Clock, R4);
	regn reg_5 (BusWires, Rin[5], Clock, R5);
	regn reg_6 (BusWires, Rin[6], Clock, R6);

	// R7 is program counter
	// module pc_count(R, Resetn, Clock, E, L, Q);
	pc_count pc (BusWires, Resetn, Clock, pc_inc, Rin[7], R7);

	regn reg_A (BusWires, Ain, Clock, A);
	regn reg_DOUT (BusWires, DOUTin, Clock, DOUT);
	regn reg_ADDR (BusWires, ADDRin, Clock, ADDR);
	regn #(.n(9)) reg_IR (DIN[8:0], IRin, Clock, IR);

	flipflop reg_W (W_D, Resetn, Clock, W);

	//	alu
	always @(AddSub or A or BusWires)
		begin
		if (!AddSub)
			Sum = A + BusWires;
	    else
			Sum = A - BusWires;
		end

	regn #(.n(16)) reg_G (Sum, Gin, Clock, G);

	// define the internal processor bus
	assign Sel = {Rout, Gout, DINout};

	always @(*)
	begin
		if (Sel == 10'b1000000000)
			BusWires = R0;
   	else if (Sel == 10'b0100000000)
			BusWires = R1;
		else if (Sel == 10'b0010000000)
			BusWires = R2;
		else if (Sel == 10'b0001000000)
			BusWires = R3;
		else if (Sel == 10'b0000100000)
			BusWires = R4;
		else if (Sel == 10'b0000010000)
			BusWires = R5;
		else if (Sel == 10'b0000001000)
			BusWires = R6;
		else if (Sel == 10'b0000000100)
			BusWires = R7;
		else if (Sel == 10'b0000000010)
			BusWires = G;
   	else BusWires = DIN;
	end	
endmodule


module pc_count(R, Resetn, Clock, E, L, Q);
	input [15:0] R;
	input Resetn, Clock, E, L;
	output [15:0] Q;
	reg [15:0] Q;
	
	always @(posedge Clock)
	 	if (!Resetn)
			Q <= 9'b0;
		else if (L)
			Q <= R;
		else if (E)
			Q <= Q + 1'b1;
endmodule

module dec3to8(W, En, Y);
	input [2:0] W;
	input En;
	output [0:7] Y;
	reg [0:7] Y;
	
	always @(W or En)
	begin
		if (En == 1)
			case (W)
				3'b000: Y = 8'b10000000;
	   	   3'b001: Y = 8'b01000000;
				3'b010: Y = 8'b00100000;
				3'b011: Y = 8'b00010000;
				3'b100: Y = 8'b00001000;
				3'b101: Y = 8'b00000100;
				3'b110: Y = 8'b00000010;
				3'b111: Y = 8'b00000001;
			endcase
		else 
			Y = 8'b00000000;
	end
endmodule

module regn(R, Rin, Clock, Q);
	parameter n = 16;
	input [n-1:0] R;
	input Rin, Clock;
	output [n-1:0] Q;
	reg [n-1:0] Q;

	always @(posedge Clock)
	 	if (Rin)
			Q <= R;
endmodule
