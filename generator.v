module generator(exp,line,clk,rst);
output[11:0] exp;
output[1:0] line;
input clk,rst;
reg[5:0] num1,num2;
reg[3:0] op;
wire[3:0] op_fin,num1_fin,num2_fin;
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		num1 <= 6'b110010;
		num2 <= 6'b100110;
		op <= 4'b0110;
	end
	else begin
		num1[4:0] <= num1[5:1];
		num1[5] <= num1[1] ^ num1[0];
		num2[4:0] <= num2[5:1];
		num2[5] <= num2[1] ^ num2[0];
		op[2:0] <= op[3:1];
		op[3] <= op[1] ^ op[0];
	end
end
assign op_fin = op[1:0]+4'hA;
assign line = op%3;
assign num1_fin = (num1%9)+1 ,num2_fin = (num2%9)+1;
assign exp = {num1_fin,op_fin,num2_fin};
endmodule