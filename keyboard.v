`timescale 1ns / 1ps
module keyboard(CLK, RESET_un, COLUMN, ROW, ENABLE, SEGMENT,answer,score,correct);

 input CLK;
 input RESET_un;
 input [3:0] COLUMN;
 input[6:0] score;
 input correct;
 output reg[3:0] ROW;
 output reg[3:0] ENABLE;
 output reg[7:0] SEGMENT;
 output [6:0] answer;
 wire RESET; 
 wire RESET_O;
 reg [3:0]SCAN_CODE;
 reg [3:0]KEY_CODE;
 reg PRESS;
 wire PRESS_VALID;
 wire DEBOUNCE_CLK;
 wire SCAN_CLK;
 reg [15:0] KEY_BUFFER;
 reg [3:0] DECODE_BCD;
 
 assign answer = KEY_BUFFER[3:0] + KEY_BUFFER[7:4]*10; 
 clock_divider C1(DEBOUNCE_CLK,SCAN_CLK, CLK);
 DEBOUNCE_CLK D1( DEBOUNCE_CLK , RESET, PRESS_VALID ,PRESS );
 DEBOUNCE_CLK D2( DEBOUNCE_CLK , RESET, RESET_O ,RESET_un );
 assign RESET = ~RESET_O;
 always@(posedge CLK or negedge RESET )
  begin
	if(!RESET)
		SCAN_CODE <= 4'h0;
	else if(PRESS)
		SCAN_CODE <= SCAN_CODE +1;
  end
  
 always@(SCAN_CODE or COLUMN)
  begin
	case(SCAN_CODE[3:2])
		2'b00:ROW = 4'b1110;
		2'b01:ROW = 4'b1101;
		2'b10:ROW = 4'b1011;
		2'b11:ROW = 4'b0111;
	endcase
	case(SCAN_CODE[1:0])
		2'b00:PRESS = COLUMN[0];
		2'b01:PRESS = COLUMN[1];
		2'b10:PRESS = COLUMN[2];
		2'b11:PRESS = COLUMN[3];
	endcase
  end
  
  
	//FETCH KEY CODE
	
	always@(negedge DEBOUNCE_CLK or negedge RESET or posedge correct)
	 begin
		if(!RESET)
			KEY_BUFFER[7:0] = 8'ha0;
		else if(correct)
			KEY_BUFFER[7:0] = 8'ha0;
		else if(PRESS_VALID)
		begin
			if( SCAN_CODE == 4'hC || SCAN_CODE == 4'hD || SCAN_CODE == 4'h9 || SCAN_CODE == 4'h5 || SCAN_CODE == 4'hE || SCAN_CODE == 4'hA || SCAN_CODE == 4'h6 || SCAN_CODE == 4'hF || SCAN_CODE == 4'hB || SCAN_CODE == 4'h7)
			begin
				KEY_BUFFER = KEY_BUFFER << 4;
				case(SCAN_CODE)
				 4'hC: KEY_BUFFER[3:0] =  4'h0;
				 4'hD: KEY_BUFFER[3:0] =  4'h1;	 
				 4'h9: KEY_BUFFER[3:0] =  4'h2;
				 4'h5: KEY_BUFFER[3:0] =  4'h3;
				 4'hE: KEY_BUFFER[3:0] =  4'h4;
				 4'hA: KEY_BUFFER[3:0] =  4'h5;
				 4'h6: KEY_BUFFER[3:0] =  4'h6;
				 4'hF: KEY_BUFFER[3:0] =  4'h7;
				 4'hB: KEY_BUFFER[3:0] =  4'h8;
				 4'h7: KEY_BUFFER[3:0] =  4'h9;
				 4'h8: KEY_BUFFER[3:0] =  4'hA;
				 4'h4: KEY_BUFFER[3:0] =  4'hB;
				 4'h3: KEY_BUFFER[3:0] =  4'hC;
				 4'h2: KEY_BUFFER[3:0] =  4'hD;
				 4'h1: KEY_BUFFER[3:0] =  4'hE;
				 4'h0: KEY_BUFFER[3:0] =  4'hF;
				endcase
			end
			if(SCAN_CODE == 4'h8)
			 begin
				KEY_BUFFER[7:0] = 8'ha0;
			 end
		end
	 end
	 
	//Enable Display
	always@(posedge SCAN_CLK)
	begin
	case(ENABLE)
		4'b1110:
		 begin
			ENABLE <= 4'b1101;
		end
		4'b1101:
		 begin
			ENABLE <= 4'b1011;
		end
		4'b1011:
		 begin
			ENABLE <= 4'b0111;
		end
		4'b0111:
		 begin
			ENABLE <= 4'b1110;
		end
		default
			begin
				ENABLE <= 4'b1110;
			end
	 endcase
	end
	
	//DISPLAY MUX
	always@(ENABLE or KEY_BUFFER)
	 begin
	  case(ENABLE)
		4'b1110: DECODE_BCD <= answer%10;
		4'b1101: DECODE_BCD <= answer/10;
		4'b1011: DECODE_BCD <= score%10;
		4'b0111: DECODE_BCD <= score/10;
		endcase
	 end
	 
	 //7seg decoder
	 
	 always@(DECODE_BCD)
	  begin
	   case(DECODE_BCD)
		 4'h0:SEGMENT = 8'b00000011;
		 4'h1:SEGMENT = 8'b10011111;
		 4'h2:SEGMENT = 8'b00100100;
		 4'h3:SEGMENT = 8'b00001100;
		 4'h4:SEGMENT = 8'b10011000;
		 4'h5:SEGMENT = 8'b01001000;
		 4'h6:SEGMENT = 8'b01000000;
		 4'h7:SEGMENT = 8'b00011111;
		 4'h8:SEGMENT = 8'b00000000;
		 4'h9:SEGMENT = 8'b00011000;
		 4'hA:SEGMENT = 8'b00010000;
		 4'hB:SEGMENT = 8'b11000000;
		 4'hC:SEGMENT = 8'b01100011;
		 4'hD:SEGMENT = 8'b10000100;
		 4'hE:SEGMENT = 8'b01100000;
		 4'hF:SEGMENT = 8'b01110000;
		 endcase
	  end
endmodule
