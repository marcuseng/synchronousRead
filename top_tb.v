`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:01:37 04/27/2014
// Design Name:   Image_viewer_top
// Module Name:   /home/student/Dropbox/EE 201 Final Project/SynchronousRead/top_tb.v
// Project Name:  SynchronousRead
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Image_viewer_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_tb;

	// Inputs
	reg ClkPort;
	reg btnC;
	reg btnR;
	reg btnL;

	// Outputs
	wire Hsync;
	wire Vsync;
	wire [2:0] vgaRed;
	wire [2:0] vgaGreen;
	wire [2:1] vgaBlue;
	wire MemOE;
	wire MemWR;
	wire MemClk;
	wire RamCS;
	wire RamUB;
	wire RamLB;
	wire RamAdv;
	wire RamCRE;
	wire [26:1] MemAdr;
	wire An0;
	wire An1;
	wire An2;
	wire An3;
	wire Ca;
	wire Cb;
	wire Cc;
	wire Cd;
	wire Ce;
	wire Cf;
	wire Cg;
	wire Dp;
	wire [1:0] Led;

	// Bidirs
	wire [15:0] data;

	// Instantiate the Unit Under Test (UUT)
	Image_viewer_top uut (
		.ClkPort(ClkPort), 
		.Hsync(Hsync), 
		.Vsync(Vsync), 
		.vgaRed(vgaRed), 
		.vgaGreen(vgaGreen), 
		.vgaBlue(vgaBlue), 
		.MemOE(MemOE), 
		.MemWR(MemWR), 
		.MemClk(MemClk), 
		.RamCS(RamCS), 
		.RamUB(RamUB), 
		.RamLB(RamLB), 
		.RamAdv(RamAdv), 
		.RamCRE(RamCRE), 
		.MemAdr(MemAdr), 
		.data(data), 
		.An0(An0), 
		.An1(An1), 
		.An2(An2), 
		.An3(An3), 
		.Ca(Ca), 
		.Cb(Cb), 
		.Cc(Cc), 
		.Cd(Cd), 
		.Ce(Ce), 
		.Cf(Cf), 
		.Cg(Cg), 
		.Dp(Dp), 
		.Led(Led), 
		.btnC(btnC), 
		.btnR(btnR), 
		.btnL(btnL)
	);

initial
	begin
		ClkPort = 0;
		forever
			#5 ClkPort = ~ClkPort;
	end

	initial begin
		// Initialize Inputs
		btnC = 1;
		btnR = 0;
		btnL = 0;

		// Wait 100 ns for global reset to finish
		#100;
      btnC = 0;
		// Add stimulus here

	end
      
endmodule

