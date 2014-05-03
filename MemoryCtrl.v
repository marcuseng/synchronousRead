`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:44:10 04/27/2014 
// Design Name: 
// Module Name:    MemoryCtrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MemoryCtrl(Clk, Reset, MemAdr, MemOE, MemWR,
		RamCS, RamUB, RamLB, RamAdv, RamCRE, writeData, AddressIn,
		BtnU_Pulse, BtnD_Pulse
    );

	input Clk, Reset, BtnU_Pulse, BtnD_Pulse;
	input [22:0] AddressIn;
	output MemOE, MemWR, RamCS, RamUB, RamLB, RamAdv, RamCRE;
	output [26:1] MemAdr;
	output writeData;


	reg _MemOE, _MemWR, _RamCS, _RamUB, _RamLB, _RamAdv, _RamCRE;
	reg [22:0] address = 23'b000_10_00_0_1_011_1_0_0_0_0_01_1_111;
	reg [7:0] state;
	reg [6:0] clock_counter;
	reg writeData;
	
	assign MemAdr = {4'b0, address};
	assign MemOE = _MemOE;
	assign MemWR = _MemWR;
	assign RamCS = _RamCS;
	assign RamUB = _RamUB;
	assign RamLB = _RamLB;
	assign RamAdv = _RamAdv;
	assign RamCRE = _RamCRE;
	
localparam
	INITIAL_CONFIG =  8'b00000001,
	CONFIGMEM = 		8'b00000010,
	CONFIGMEM2 = 		8'b00000100,
	INIT = 				8'b00001000,
	PREPARE_READ = 	8'b00010000,
	WAIT = 				8'b00100000,
	READ_DATA =			8'b01000000,
	IDLE =				8'b10000000;
	

always @ (posedge Clk, posedge Reset)
	begin : State_Machine
		if (Reset)
		   begin
				state <= CONFIGMEM;
				writeData <= 0;
		   end

		else 
		   begin			   
				case (state)
					INITIAL_CONFIG:
						begin
							state <= CONFIGMEM;
							_MemOE <= 1;
							_RamCS <= 0;
							_MemWR <= 1;
							_RamAdv <= 0;
							_RamCRE <= 1;
						end
		
					CONFIGMEM:
						begin
							address <= 23'b000_10_00_0_1_011_1_0_0_0_0_01_1_111;
							_RamCRE <= 1;
							_RamAdv <= 0;
							_RamCS <= 0;
							_MemWR <= 0;
							_MemOE <= 1;
							_RamUB <= 1;
							_RamLB <= 1;
							clock_counter <= 0;
							state <= CONFIGMEM2;
						end
					CONFIGMEM2:
						begin
							_RamCRE <= 1;
							_RamAdv <= 1;
							_RamCS <= 0;
							_MemWR <= 1;
							
							if(clock_counter == 7'b0000010)
								begin
									state <= INIT;
									_RamCS <= 1;
								end
							else
								clock_counter <= clock_counter + 1;
						end
					INIT:
						begin
							address <= AddressIn;
							state <= PREPARE_READ;
						end
					PREPARE_READ:
						begin
							_RamCRE <= 0;
							_RamAdv <= 0;
							_RamCS <= 0;
							_MemWR <= 1;
							_MemOE <= 1;
							_RamUB <= 0;
							_RamLB <= 0;
							state <= WAIT;
							clock_counter <= 0;
						end
					WAIT:
						begin
							_RamAdv <= 1;

							if(clock_counter == 7'b0000011)
								begin
									writeData <= 1;
									_MemOE <= 0;
									state <= READ_DATA;
									clock_counter <= 0;
								end
							else
								clock_counter <= clock_counter + 1;
						end
					READ_DATA:
						begin
							clock_counter <= clock_counter + 1;

							if(clock_counter == 7'b1111111)
								begin
									state <= IDLE;
									writeData <= 0;
								end
						end
					IDLE:
						begin
							if(BtnU_Pulse || BtnD_Pulse)
								state <= CONFIGMEM;
							
							_RamCRE <= 0;
							_RamAdv <= 1;
							_RamCS <= 1;
							_MemWR <= 1;
							_MemOE <= 1;
							_RamUB <= 1;
							_RamLB <= 1;
						end
					default:
						state <= 8'bXXXXXXXX;
				endcase
			end
		end
endmodule