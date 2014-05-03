`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:04:44 04/27/2014
// Design Name:   VGACtrl
// Module Name:   /home/student/Dropbox/EE 201 Final Project/SynchronousRead/vga_tb.v
// Project Name:  SynchronousRead
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: VGACtrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vga_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire vga_h_sync;
	wire vga_v_sync;
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [9:0] CounterY;

	// Instantiate the Unit Under Test (UUT)
	VGACtrl uut (
		.clk(clk), 
		.reset(reset), 
		.vga_h_sync(vga_h_sync), 
		.vga_v_sync(vga_v_sync), 
		.inDisplayArea(inDisplayArea), 
		.CounterX(CounterX), 
		.CounterY(CounterY)
	);

initial
	begin
		clk = 0;
		forever
			#20 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100;
      reset = 0;
		// Add stimulus here
	
	end
      
endmodule

