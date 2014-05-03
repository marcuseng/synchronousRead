`timescale 1ns / 100ps

module ee201_debouncer(CLK, RESET, PB, DPB, SCEN, MCEN, CCEN);

//inputs
input	CLK, RESET;
input PB;

//outputs
output DPB;
output SCEN, MCEN, CCEN;

//parameters
parameter N_dc = 7;

(* fsm_encoding = "user" *)
reg [5:0] state;
// other items not controlledd by the special atribute
reg [N_dc-1:0] debounce_count;
reg [3:0] MCEN_count;

//concurrent signal assignment statements
// The following is possible because of the output coding used by us.
assign {DPB, SCEN, MCEN, CCEN} = state[5:2];

//constants used for state naming // the don't cares are replaced here with zeros
localparam
 INI        = 6'b000000,
 W84        = 6'b000001,
 SCEN_st    = 6'b111100,
 WS         = 6'b100000,
 MCEN_st    = 6'b101100,
 CCEN_st    = 6'b100100,
 MCEN_cont  = 6'b101101,
 CCR        = 6'b100001,
 WFCR       = 6'b100010;
		      
//logic
always @ (posedge CLK, posedge RESET)
	begin : State_Machine
		
		if (RESET)
		   begin
		      state <= INI;
		      debounce_count <= 'bx;
		      MCEN_count <= 4'bx;
		   end
		else 
		   begin
			   case (state)
			   
				   INI: begin					
					     debounce_count <= 0;
					     MCEN_count <= 0;  
					     if (PB)
						   begin
							   state <= W84;
						   end
			            end
						
			       W84: begin
					     debounce_count <= debounce_count + 1;
			             if (!PB)
			              begin
			                state <= INI;
			              end
				         else if (debounce_count[N_dc-5])// for N_dc of 28, it is debounce_count[23], i.e T = 0.084 sec for f = 100MHz
				          begin
				            state <= SCEN_st;
				          end
				        end
						
				   SCEN_st: begin
					     debounce_count <= 0;
				         MCEN_count <= MCEN_count + 1;
				         state <= WS;
				        end
				   
				   WS:  begin
					     debounce_count <= debounce_count + 1;
				         if (!PB)
				           begin
							state <= CCR;
						   end	
				         else if (debounce_count[N_dc-1])// for N_dc of 28, it is debounce_count[27], i.e T = 1.342 sec for f = 100MHz
				           begin
						    state <= MCEN_st;
						   end
				        end
				      
				   MCEN_st: begin
					     debounce_count <= 0;
				         MCEN_count <= MCEN_count + 1;
				         state <= CCEN_st;
				        end
				   
				   CCEN_st: begin
					     debounce_count <= debounce_count + 1;
				         if (!PB)
				          begin
						   state <= CCR;
						  end
				         else if (debounce_count[N_dc-1])// for N_dc of 28, it is debounce_count[27], i.e T = 1.342 sec for f = 100MHz
				          begin
				            if (MCEN_count == 4'b1000)
				                begin
									state <= MCEN_cont;
								end
				            else
				                begin
									state <= MCEN_st;
								end
				          end
				        end
				      
				   MCEN_cont: begin
					     if (!PB)
				          begin
						   state <= CCR;
						  end
				        end
				   
				   CCR: begin
					     debounce_count <= 0;
				         MCEN_count <= 0;
				         state <= WFCR;
				        end
				   
				   WFCR: begin
					     debounce_count <= debounce_count + 1;
				         if (PB)
				           begin
							state <= WS;
						   end
				         else if (debounce_count[N_dc-5])// for N_dc of 28, it is debounce_count[23], i.e T = 0.084 sec for f = 100MHz
				           begin
							state <= INI;
						   end
				         end
				endcase		    
	      end
	end // State_Machine

endmodule // ee201_debouncer