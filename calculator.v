module calculator(LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1,LCD_CS2, LCD_RST, LCD_DATA,clk,rst);
input clk,rst;
output LCD_ENABLE,LCD_RW,LCD_DI,LCD_CS1,LCD_CS2,LCD_RST;
output [7:0]  LCD_DATA;
reg[11:0] exp1,exp2,exp3,exp4,exp5,exp6;
reg[9:0] delay;
reg[9:0] ans1,ans2,ans3;
reg[15:0] score;
reg[1:0] life;
wire delay_clk,LCD_ENABLE,LCD_RW,LCD_DI,LCD_CS1,LCD_CS2, LCD_RST;
wire[1:0] line,in_line;
wire[7:0] in_ans,LCD_DATA;
wire[11:0] tmp_exp;
generator g(tmp_exp,line,delay_clk,rst);
clk_16 c(delay_clk,clk,rst);
display d(clk,rst,LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1,LCD_CS2, LCD_RST, LCD_DATA,exp1,exp2,exp3,exp4,exp5,exp6);
always @(posedge delay_clk or negedge rst) begin
	if(!rst) begin
		exp1 = 12'h000;
		exp2 = 12'h000;
		exp3 = 12'h000;
		exp4 = 12'h000;
		exp5 = 12'h000;
		exp6 = 12'h000;
		score <= 16'h0000;
		life <= 2'b10;
		delay <= {2'b00,8'h00};
	end
	else if(in_line!=2'b00) begin
		if(in_line==2'b01) begin
			if(in_ans==ans1) begin
				if(exp4!=12'h000) begin
					score <= score+5;
					exp4 = 12'h000;
				end
				else if(exp1!=12'h000) begin
					score <= score+5;
					exp1 = 12'h000;
				end
			end
		end
		else if(in_line==2'b10) begin
			if(in_ans==ans2) begin
				if(exp5!=12'h000) begin
					score <= score+5;
					exp5 = 12'h000;
				end
				else if(exp2!=12'h000) begin
					score <= score+5;
					exp2 = 12'h000;
				end
			end
		end
		else begin
			if(in_ans==ans3) begin
				if(exp6!=12'h000) begin
					score <= score+5;
					exp6 = 12'h000;
				end
				else if(exp3!=12'h000) begin
					score <= score+5;
					exp3 = 12'h000;
				end
			end
		end
	end
	else if(!delay[9]) delay <= delay+1;
	else begin
		delay <= {2'b00,8'h00};
		exp4 = exp1;
		exp5 = exp2;
		exp6 = exp3;
		exp1 = 12'h000;
		exp2 = 12'h000;
		exp3 = 12'h000;
		if(line==2'b00) exp1 = tmp_exp;
		else if(line==2'b01) exp2 = tmp_exp;
		else exp3 = tmp_exp;
		if(exp4!=12'h000) begin
			case(exp4[7:4])
				4'hA: ans1 <= exp4[11:8]+exp4[3:0];
				4'hB: ans1 <= exp4[11:8]-exp4[3:0];
				4'hC: ans1 <= exp4[11:8]*exp4[3:0];
				4'hD: ans1 <= exp4[11:8]/exp4[3:0];
			endcase
		end
		else if(exp1!=12'h000) begin
			case(exp1[7:4])
				4'hA: ans1 <= exp1[11:8]+exp1[3:0];
				4'hB: ans1 <= exp1[11:8]-exp1[3:0];
				4'hC: ans1 <= exp1[11:8]*exp1[3:0];
				4'hD: ans1 <= exp1[11:8]/exp1[3:0];
			endcase
		end
		if(exp5!=12'h000) begin
			case(exp5[7:4])
				4'hA: ans2 <= exp5[11:8]+exp5[3:0];
				4'hB: ans2 <= exp5[11:8]-exp5[3:0];
				4'hC: ans2 <= exp5[11:8]*exp5[3:0];
				4'hD: ans2 <= exp5[11:8]/exp5[3:0];
			endcase
		end
		else if(exp2!=12'h000) begin
			case(exp2[7:4])
				4'hA: ans2 <= exp2[11:8]+exp2[3:0];
				4'hB: ans2 <= exp2[11:8]-exp2[3:0];
				4'hC: ans2 <= exp2[11:8]*exp2[3:0];
				4'hD: ans2 <= exp2[11:8]/exp2[3:0];
			endcase
		end
		if(exp6!=12'h000) begin
			case(exp6[7:4])
				4'hA: ans3 <= exp6[11:8]+exp6[3:0];
				4'hB: ans3 <= exp6[11:8]-exp6[3:0];
				4'hC: ans3 <= exp6[11:8]*exp6[3:0];
				4'hD: ans3 <= exp6[11:8]/exp6[3:0];
			endcase
		end
		else if(exp3!=12'h000) begin
			case(exp3[7:4])
				4'hA: ans3 <= exp3[11:8]+exp3[3:0];
				4'hB: ans3 <= exp3[11:8]-exp3[3:0];
				4'hC: ans3 <= exp3[11:8]*exp3[3:0];
				4'hD: ans3 <= exp3[11:8]/exp3[3:0];
			endcase
		end
	end
end
endmodule

module clk_16(delay_clk,clk,rst);
input clk,rst;
output delay_clk;
reg[15:0] divider;
always@(posedge clk or negedge rst) begin
	if(!rst) divider<=16'h0000;
	else divider<=divider+1;
end
assign delay_clk=divider[15];
endmodule
