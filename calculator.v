module calculator(LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1,LCD_CS2, LCD_RST, LCD_DATA,COLUMN, ROW, ENABLE, SEGMENT,clk,rst);
input clk,rst;
input[3:0] COLUMN;
output LCD_ENABLE,LCD_RW,LCD_DI,LCD_CS1,LCD_CS2,LCD_RST;
output[3:0] ROW,ENABLE;
output[7:0] SEGMENT;
output [7:0]  LCD_DATA;
reg[11:0] exp1,exp2,exp3,exp4,exp5,exp6;
reg[9:0] delay;
reg[9:0] ans1,ans2,ans3,ans4,ans5,ans6;
reg[6:0] score;
reg[2:0] life;
wire delay_clk,LCD_ENABLE,LCD_RW,LCD_DI,LCD_CS1,LCD_CS2, LCD_RST;
wire[1:0] line,in_line;
wire[7:0] in_ans,LCD_DATA;
wire[11:0] tmp_exp;
wire update;
reg last_update;
reg correct;
reg[3:0] combo;
generator g(tmp_exp,line,update,rst);
clk_8 c(delay_clk,clk,rst);
display d(clk,rst,LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1,LCD_CS2, LCD_RST, LCD_DATA,exp1,exp2,exp3,exp4,exp5,exp6,update,score,life);
keyboard k(clk, rst, COLUMN, ROW, ENABLE, SEGMENT,in_ans,score,correct);

always @(posedge delay_clk or negedge rst) begin
	if(!rst) begin
		exp1 = 12'h000;
		exp2 = 12'h000;
		exp3 = 12'h000;
		exp4 = 12'h000;
		exp5 = 12'h000;
		exp6 = 12'h000;
		score <= 7'b0000000;
		life <= 3'b011;
		delay <= {2'b00,8'h00};
		correct<=0;
		combo<=4'h0;
	end
	else begin
		if(correct==1) correct<=0;
		else begin
			if(in_ans==ans4&&(exp4||exp1)) begin
				if(exp4!=12'h000) begin
					score <= score+1;
					if(combo!=4'hF) combo<=combo+1;
					else begin
						combo<=4'h0;
						if(life<5) life<=life+1;
					end
					exp4 = 12'h000;
					ans4 <= ans1;
					correct<=1;
				end
				else if(exp1!=12'h000) begin
					score <= score+1;
					if(combo!=4'hF) combo<=combo+1;
					else begin
						combo<=4'h0;
						if(life<5) life<=life+1;
					end
					exp1 = 12'h000;
					correct<=1;
				end
			end
			if(in_ans==ans5&&(exp5||exp2)) begin
				if(exp5!=12'h000) begin
					score <= score+1;
					if(combo!=4'hF) combo<=combo+1;
					else begin
						combo<=4'h0;
						if(life<5) life<=life+1;
					end
					exp5 = 12'h000;
					ans5 <= ans2;
					correct<=1;
				end
				else if(exp2!=12'h000) begin
					score <= score+1;
					if(combo!=4'hF) combo<=combo+1;
					else begin
						combo<=4'h0;
						if(life<5) life<=life+1;
					end
					exp2 = 12'h000;
					correct<=1;
				end
			end
			if(in_ans==ans6&&(exp6||exp3)) begin
				if(exp6!=12'h000) begin
					score <= score+1;
					if(combo!=4'hF) combo<=combo+1;
					else begin
						combo<=4'h0;
						if(life<5) life<=life+1;
					end
					exp6 = 12'h000;
					ans6 <= ans3;
					correct<=1;
				end
				else if(exp3!=12'h000) begin
					score <= score+1;
					if(combo!=4'hF) combo<=combo+1;
					else begin
						combo<=4'h0;
						if(life<5) life<=life+1;
					end
					exp3 = 12'h000;
					correct<=1;
				end
			end
		end
		if(update) begin
			if(exp4||exp5||exp6) begin
				life <= life-1;
				combo<=0;
			end
			exp4 = exp1;
			exp5 = exp2;
			exp6 = exp3;
			exp1 = 12'h000;
			exp2 = 12'h000;
			exp3 = 12'h000;
			delay <= {2'b00,8'h00};
			if(line==2'b00) exp1 = tmp_exp;
			else if(line==2'b01) exp2 = tmp_exp;
			else exp3 = tmp_exp;
			if(exp4!=12'h000) begin
				case(exp4[7:4])
				4'hA: ans4 <= exp4[11:8]+exp4[3:0];
				4'hB: ans4 <= exp4[11:8]-exp4[3:0];!
				4'hC: ans4 <= exp4[11:8]*exp4[3:0];	
				4'hD: ans4 <= exp4[11:8]/exp4[3:0];	
				endcase	
			end	
			else if(exp1!=12'h000) begin	
				case(exp1[7:4])	
					4'hA: ans4 <= exp1[11:8]+exp1[3:0];	
					4'hB: ans4 <= exp1[11:8]-exp1[3:0];	
					4'hC: ans4 <= exp1[11:8]*exp1[3:0];	
					4'hD: ans4 <= exp1[11:8]/exp1[3:0];	
				endcase	
			end
			if(exp1!=12'h000) begin	
				case(exp1[7:4])	
					4'hA: ans1 <= exp1[11:8]+exp1[3:0];	
					4'hB: ans1 <= exp1[11:8]-exp1[3:0];	
					4'hC: ans1 <= exp1[11:8]*exp1[3:0];	
					4'hD: ans1 <= exp1[11:8]/exp1[3:0];	
				endcase	
			end
			if(exp5!=12'h000) begin	
				case(exp5[7:4])	
					4'hA: ans5 <= exp5[11:8]+exp5[3:0];	
					4'hB: ans5 <= exp5[11:8]-exp5[3:0];	
					4'hC: ans5 <= exp5[11:8]*exp5[3:0];	
					4'hD: ans5 <= exp5[11:8]/exp5[3:0];	
				endcase	
			end	
			else if(exp2!=12'h000) begin	
				case(exp2[7:4])	
					4'hA: ans5 <= exp2[11:8]+exp2[3:0];	
					4'hB: ans5 <= exp2[11:8]-exp2[3:0];	
					4'hC: ans5 <= exp2[11:8]*exp2[3:0];	
					4'hD: ans5 <= exp2[11:8]/exp2[3:0];	
				endcase	
			end
			if(exp2!=12'h000) begin	
				case(exp2[7:4])	
					4'hA: ans2 <= exp2[11:8]+exp2[3:0];	
					4'hB: ans2 <= exp2[11:8]-exp2[3:0];	
					4'hC: ans2 <= exp2[11:8]*exp2[3:0];	
					4'hD: ans2 <= exp2[11:8]/exp2[3:0];	
				endcase	
			end
			if(exp6!=12'h000) begin	
				case(exp6[7:4])	
					4'hA: ans6 <= exp6[11:8]+exp6[3:0];	
					4'hB: ans6 <= exp6[11:8]-exp6[3:0];	
					4'hC: ans6 <= exp6[11:8]*exp6[3:0];	
					4'hD: ans6 <= exp6[11:8]/exp6[3:0];	
				endcase	
			end	
			else if(exp3!=12'h000) begin	
				case(exp3[7:4])	
					4'hA: ans6 <= exp3[11:8]+exp3[3:0];	
					4'hB: ans6 <= exp3[11:8]-exp3[3:0];	
					4'hC: ans6 <= exp3[11:8]*exp3[3:0];	
					4'hD: ans6 <= exp3[11:8]/exp3[3:0];	
				endcase	
			end	
			if(exp3!=12'h000) begin	
				case(exp3[7:4])	
					4'hA: ans3 <= exp3[11:8]+exp3[3:0];	
					4'hB: ans3 <= exp3[11:8]-exp3[3:0];	
					4'hC: ans3 <= exp3[11:8]*exp3[3:0];	
					4'hD: ans3 <= exp3[11:8]/exp3[3:0];	
				endcase	
			end
		end
	end
end
endmodule

module clk_8(delay_clk,clk,rst);
input clk,rst;
output delay_clk;
reg[7:0] divider;
always@(posedge clk or negedge rst) begin
	if(!rst) divider<=8'h00;
	else divider<=divider+1;
end
assign delay_clk=divider[7];
endmodule