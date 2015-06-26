`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:13:33 03/30/2015 
// Design Name: 
// Module Name:    seven_seg 
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
module seven_seg(clk, DIGIT, DISPLAY, BCD0, BCD1);

input clk;
input [3:0] BCD0, BCD1;
output reg[3:0] DIGIT;
output [7:0] DISPLAY;
reg [3:0] value;
always@(posedge clk)
 begin
	case(DIGIT)
		4'b1110:
		 begin
			value <= BCD0;
			DIGIT <= 4'b1101;
		end
		4'b1101:
		 begin
			value <= BCD1;
			DIGIT <= 4'b1110;
		end
		default
			begin
				DIGIT <= 4'b1110;
			end
	 endcase
 end
 
assign DISPLAY =  (value==4'd0)?8'b00000011:
					   (value==4'd1)?8'b10011111:
						(value==4'd2)?8'b00100100:
						(value==4'd3)?8'b00001100:
						(value==4'd4)?8'b10011000:
						(value==4'd5)?8'b01001000:
						(value==4'd6)?8'b01000000:
						(value==4'd7)?8'b00011111:
						(value==4'd8)?8'b00000000:
						(value==4'd9)?8'b00001000:
										  8'b11111111;
endmodule
