`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:49 06/26/2015 
// Design Name: 
// Module Name:    combo 
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
module combo(combo,LED);

input [3:0] combo;
output reg[15:0]LED;

always@(combo)
begin
 case(combo)
			 4'd0: LED = 16'b0000000000000000;
			 4'd1: LED = 16'b0000000000000001;
			 4'd2: LED = 16'b0000000000000011;
			 4'd3: LED = 16'b0000000000000111;
			 4'd4: LED = 16'b0000000000001111;
			 4'd5: LED = 16'b0000000000011111;
			 4'd6: LED = 16'b0000000000111111;
			 4'd7: LED = 16'b0000000001111111;
			 4'd8: LED = 16'b0000000011111111;
			 4'd9: LED = 16'b0000000111111111;
			 4'd10: LED = 16'b0000001111111111;
			 4'd11: LED = 16'b0000011111111111;
			 4'd12: LED = 16'b0000111111111111;
			 4'd13: LED = 16'b0001111111111111;
			 4'd14: LED = 16'b0011111111111111;
			 4'd15: LED = 16'b0111111111111111;
 endcase
end


endmodule
