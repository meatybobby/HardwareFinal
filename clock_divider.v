`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:40 03/30/2015 
// Design Name: 
// Module Name:    clock_divider 
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
module clock_divider(clk_div_by14,clk_div_by15, clk);
input clk;
output clk_div_by14,clk_div_by15;

reg [14:0] num;
wire [14:0] next_num;

always@(posedge clk)
 begin
  num <= next_num;
 end
assign next_num = num +1'b1;
assign clk_div_by14 = num[14];
assign clk_div_by15 = num[14];

endmodule
