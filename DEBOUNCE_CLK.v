`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:34 04/09/2015 
// Design Name: 
// Module Name:    DEBOUNCE_CLK 
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
module DEBOUNCE_CLK( DEBOUNCE_CLK , RESET, PRESS_VALID ,PRESS );
input DEBOUNCE_CLK;
input RESET;
input PRESS;
output PRESS_VALID;
reg [3:0]DEBOUNCE_COUNT;
//debounce circuit
  always@(posedge DEBOUNCE_CLK or negedge RESET)
   begin
	 if(!RESET)
		DEBOUNCE_COUNT <= 4'h0;
	 else if(PRESS)
		DEBOUNCE_COUNT <= 4'h0;
	 else if(DEBOUNCE_COUNT <= 4'hE)
		DEBOUNCE_COUNT <= DEBOUNCE_COUNT +1;
	end
assign PRESS_VALID = (DEBOUNCE_COUNT == 4'hD)?1'b1:1'b0;
endmodule
