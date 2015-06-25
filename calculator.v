module calculator(clk,rst);
input clk,rst;
reg[1:0] line;
reg[11:0] exp1,exp2,exp3,exp4,exp5,exp6,tmp_exp;
reg[15:0] delay;
reg[3:0] ans1,ans2,ans3;
generator g(tmp_exp,line,clk,rst);
always @(posedge clk or negedge rst) begin
	if(!rst) begin
		exp1 = 12'h000;
		exp2 = 12'h000;
		exp3 = 12'h000;
		exp4 = 12'h000;
		exp5 = 12'h000;
		exp6 = 12'h000;
		delay <= 16'h0000;
	end
	else if(!delay[15]) delay <= delay+1;
	else begin
		delay <= <= 16'h0000;
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
