`timescale 1ns / 1ps

module DisplayCtrl(Clk, reset, memoryData,
		An0, An1, An2, An3, Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp
   );
	
	input [26:0] Clk;
	input reset;
	input [15:0] memoryData;
	output An0, An1, An2, An3, Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp;

	reg [6:0] SSD_CATHODES;
	wire [26:0] DIV_CLK;
	reg [3:0] SSD;
	wire [3:0] SSD0, SSD1, SSD2, SSD3;
	wire [1:0] ssdscan_clk;
	
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES, 1'b1};
	assign DIV_CLK = Clk;

	assign SSD3 = memoryData[15:12];
	assign SSD2 = memoryData[11:8];
	assign SSD1 = memoryData[7:4];
	assign SSD0 = memoryData[3:0];

	assign ssdscan_clk = DIV_CLK[19:18];	
	assign An0 = !(~(ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 00
	assign An1 = !(~(ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 01
	assign An2 = !( (ssdscan_clk[1]) && ~(ssdscan_clk[0]));  // when ssdscan_clk = 10
	assign An3 = !( (ssdscan_clk[1]) &&  (ssdscan_clk[0]));  // when ssdscan_clk = 11

	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
			2'b00: 
				SSD = SSD0;
			2'b01: 
				SSD = SSD1;
			2'b10: 
				SSD = SSD2;
			2'b11: 
				SSD = SSD3;				
		endcase 
	end	

	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD)
			4'b0000: SSD_CATHODES = 7'b0000001 ; // 0
			4'b0001: SSD_CATHODES = 7'b1001111 ; // 1
			4'b0010: SSD_CATHODES = 7'b0010010 ; // 2
			4'b0011: SSD_CATHODES = 7'b0000110 ; // 3
			4'b0100: SSD_CATHODES = 7'b1001100 ; // 4
			4'b0101: SSD_CATHODES = 7'b0100100 ; // 5
			4'b0110: SSD_CATHODES = 7'b0100000 ; // 6
			4'b0111: SSD_CATHODES = 7'b0001111 ; // 7
			4'b1000: SSD_CATHODES = 7'b0000000 ; // 8
			4'b1001: SSD_CATHODES = 7'b0000100 ; // 9	
			4'b1010: SSD_CATHODES = 7'b0001000 ; // A
			4'b1011: SSD_CATHODES = 7'b1100000 ; // B
			4'b1100: SSD_CATHODES = 7'b0110001 ; // C
			4'b1101: SSD_CATHODES = 7'b1000010 ; // D
			4'b1110: SSD_CATHODES = 7'b0110000 ; // E
			4'b1111: SSD_CATHODES = 7'b0111000 ; // F			
		endcase
	end	
endmodule
