module display(CLK, RESET,
       LCD_ENABLE, LCD_RW, LCD_DI, LCD_CS1,
       LCD_CS2, LCD_RST, LCD_DATA,exp1,exp2,exp3,exp4,exp5,exp6,update,score,Life);

  input  CLK;
  input  RESET;
  input[11:0]  exp1,exp2,exp3,exp4,exp5,exp6;
  input[2:0] Life;
  input[6:0] score;
  output LCD_ENABLE; 
  output LCD_RW;
  output LCD_DI;
  output LCD_CS1;
  output LCD_CS2;
  output LCD_RST;
  output [7:0]  LCD_DATA;
  output update;
  reg [3:0]LV;
  reg    [7:0]  LCD_DATA;
  reg    [7:0]  UPPER_PATTERN;
  reg    [7:0]  LOWER_PATTERN;
  
  reg    [7:0]  UPPER_PATTERN_page0;
  reg    [7:0]  LOWER_PATTERN_page0;
  
  reg    [7:0]  UPPER_PATTERN_startpage = 8'h00;
  reg    [7:0]  LOWER_PATTERN_startpage = 8'h00;
  
  reg    [7:0]  UPPER_PATTERN_unstart;
  reg    [7:0]  LOWER_PATTERN_unstart;
  
  reg    [1:0]  LCD_SEL;
  reg    [2:0]  STATE;
  reg    [2:0]  X_PAGE;
  reg    [8:1]  DIVIDER;
  reg    [16:1] DELAY;
  reg    [8:0]  INDEX = 8'h0;
  reg    [9:0]  PAGE;
  reg    [1:0]  ENABLE;
  reg    CLEAR;
  reg    LCD_RW;
  reg    LCD_DI;
  reg    LCD_RST;
  wire	LCD_CLK;
  wire   LCD_CS1;
  wire   LCD_CS2; 
  wire   LCD_ENABLE;
  wire[3:0] lvbit;
  reg last_update;
  reg[8:0] locexp1 = 0;
  reg[8:0] locexp2 = 0;
  reg[8:0] locexp3 = 0;
  reg[8:0] locexp4 = 9'h20; 
  reg[8:0] locexp5 = 9'h20;
  reg[8:0] locexp6 = 9'h20;
  reg[11:0]number1;
  reg[11:0]number2;
  reg[3:0]numberpattern;
  reg[8:0]loc1;
  reg[8:0]loc2;
  reg[8:0]loc;
  reg update;
  reg [5:0]start = 0;
  reg[15:0] speed;
  reg startpage = 0;
always@(score) begin
	if(score<4) 
		LV=1;
	else if(score<10) 
		LV=2;
	else if(score<19) 
		LV=3;
	else 
		LV=score/15+3;
end
/*****************************
 * Set ROM's Display Pattern *
 *****************************/
 
 
 
always@(X_PAGE)
 begin
	case(X_PAGE)
	 3'h2 : number1 = exp1;
	 3'h3 : number1 = exp1;
	 3'h4 : number1 = exp2;
	 3'h5 : number1 = exp2;
	 3'h6 : number1 = exp3;
	 3'h7 : number1 = exp3;
	default : number1 = 0;
	endcase
 end

 always@(X_PAGE)
 begin
	case(X_PAGE)
	 3'h2 : number2 = exp4;
	 3'h3 : number2 = exp4;
	 3'h4 : number2 = exp5;
	 3'h5 : number2 = exp5;
	 3'h6 : number2 = exp6;
	 3'h7 : number2 = exp6;
	default : number2 = 0;
	endcase
 end
 
always@(X_PAGE)
 begin
	case(X_PAGE)
	 3'h2 : loc1 = locexp1;
	 3'h4 : loc1 = locexp2;
	 3'h6 : loc1 = locexp3;
	default : loc1 = loc1;
	endcase
 end

 always@(X_PAGE)
 begin
	case(X_PAGE)
	 3'h2 : loc2 = locexp4;
	 3'h4 : loc2 = locexp5;
	 3'h6 : loc2 = locexp6;
	default : loc2 = loc2;
	endcase
 end
 
always @(INDEX)
 begin
	case(INDEX)
	 9'h000  :  UPPER_PATTERN_page0 = 8'h10; // L
    9'h001  :  UPPER_PATTERN_page0 = 8'hF0;
    9'h002  :  UPPER_PATTERN_page0 = 8'hF0;
    9'h003  :  UPPER_PATTERN_page0 = 8'h10;
    9'h004  :  UPPER_PATTERN_page0 = 8'h00;
    9'h005  :  UPPER_PATTERN_page0 = 8'h00;
    9'h006  :  UPPER_PATTERN_page0 = 8'h00;
    9'h007  :  UPPER_PATTERN_page0 = 8'h00;
    9'h008  :  UPPER_PATTERN_page0 = 8'h20; // V
    9'h009  :  UPPER_PATTERN_page0 = 8'hE0;
    9'h00A  :  UPPER_PATTERN_page0 = 8'hE0;
    9'h00B  :  UPPER_PATTERN_page0 = 8'h00;
    9'h00C  :  UPPER_PATTERN_page0 = 8'h00;
    9'h00D  :  UPPER_PATTERN_page0 = 8'hE0;
    9'h00E  :  UPPER_PATTERN_page0 = 8'hE0;
    9'h00F  :  UPPER_PATTERN_page0 = 8'h20;  
	  default : UPPER_PATTERN_page0 = 8'h00;
	endcase
	if( INDEX > 9'h017 && INDEX < 9'h020 )
	 begin
		case ( (INDEX-9'h017)%8 + 8*LV )  
		  9'h000  :  UPPER_PATTERN_page0 = 8'h00; // 0
		  9'h001  :  UPPER_PATTERN_page0 = 8'hE0;
		  9'h002  :  UPPER_PATTERN_page0 = 8'h18;
		  9'h003  :  UPPER_PATTERN_page0 = 8'h08;
		  9'h004  :  UPPER_PATTERN_page0 = 8'h08;
		  9'h005  :  UPPER_PATTERN_page0 = 8'h18;
		  9'h006  :  UPPER_PATTERN_page0 = 8'hE0;
		  9'h007  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h008  :  UPPER_PATTERN_page0 = 8'h00; // 1
		  9'h009  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h00A  :  UPPER_PATTERN_page0 = 8'h10;
		  9'h00B  :  UPPER_PATTERN_page0 = 8'h18;
		  9'h00C  :  UPPER_PATTERN_page0 = 8'hF8;
		  9'h00D  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h00E  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h00F  :  UPPER_PATTERN_page0 = 8'h00;  
		  9'h010  :  UPPER_PATTERN_page0 = 8'h00; // 2
		  9'h011  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h012  :  UPPER_PATTERN_page0 = 8'h10;
		  9'h013  :  UPPER_PATTERN_page0 = 8'h08;
		  9'h014  :  UPPER_PATTERN_page0 = 8'h08;
		  9'h015  :  UPPER_PATTERN_page0 = 8'h88;
		  9'h016  :  UPPER_PATTERN_page0 = 8'h70; 
		  9'h017  :  UPPER_PATTERN_page0 = 8'h00;  
		  9'h018  :  UPPER_PATTERN_page0 = 8'h00; // 3
		  9'h019  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h01A  :  UPPER_PATTERN_page0 = 8'h10;
		  9'h01B  :  UPPER_PATTERN_page0 = 8'h88;
		  9'h01C  :  UPPER_PATTERN_page0 = 8'h88;
		  9'h01D  :  UPPER_PATTERN_page0 = 8'h88;
		  9'h01E  :  UPPER_PATTERN_page0 = 8'h70;
		  9'h01F  :  UPPER_PATTERN_page0 = 8'h00;   
		  
		  9'h020  :  UPPER_PATTERN_page0 = 8'h00; // 4
		  9'h021  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h022  :  UPPER_PATTERN_page0 = 8'h80;
		  9'h023  :  UPPER_PATTERN_page0 = 8'h60;
		  9'h024  :  UPPER_PATTERN_page0 = 8'h18;
		  9'h025  :  UPPER_PATTERN_page0 = 8'hF8;
		  9'h026  :  UPPER_PATTERN_page0 = 8'h00;    
		  9'h027  :  UPPER_PATTERN_page0 = 8'h00;  
		  9'h028  :  UPPER_PATTERN_page0 = 8'h00; // 5
		  9'h029  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h02A  :  UPPER_PATTERN_page0 = 8'h78;
		  9'h02B  :  UPPER_PATTERN_page0 = 8'h48;
		  9'h02C  :  UPPER_PATTERN_page0 = 8'h48;
		  9'h02D  :  UPPER_PATTERN_page0 = 8'hC8;
		  9'h02E  :  UPPER_PATTERN_page0 = 8'h88;
		  9'h02F  :  UPPER_PATTERN_page0 = 8'h00; 
		 
		  9'h030  :  UPPER_PATTERN_page0 = 8'h00; // 6
		  9'h031  :  UPPER_PATTERN_page0 = 8'hE0;
		  9'h032  :  UPPER_PATTERN_page0 = 8'h90;
		  9'h033  :  UPPER_PATTERN_page0 = 8'H48;
		  9'h034  :  UPPER_PATTERN_page0 = 8'h48;
		  9'h035  :  UPPER_PATTERN_page0 = 8'hC8; 
		  9'h036  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h037  :  UPPER_PATTERN_page0 = 8'h00;   
		  9'h038  :  UPPER_PATTERN_page0 = 8'h00; // 7
		  9'h039  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h03A  :  UPPER_PATTERN_page0 = 8'h08;
		  9'h03B  :  UPPER_PATTERN_page0 = 8'h08;
		  9'h03C  :  UPPER_PATTERN_page0 = 8'h88;
		  9'h03D  :  UPPER_PATTERN_page0 = 8'h68;
		  9'h03E  :  UPPER_PATTERN_page0 = 8'h18;
		  9'h03F  :  UPPER_PATTERN_page0 = 8'h00; 
		 
		  9'h040  :  UPPER_PATTERN_page0 = 8'h00; // 8
		  9'h041  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h042  :  UPPER_PATTERN_page0 = 8'h70;
		  9'h043  :  UPPER_PATTERN_page0 = 8'H88;
		  9'h044  :  UPPER_PATTERN_page0 = 8'h88;
		  9'h045  :  UPPER_PATTERN_page0 = 8'h88;
		  9'h046  :  UPPER_PATTERN_page0 = 8'h70;
		  9'h047  :  UPPER_PATTERN_page0 = 8'h00;   
		  9'h048  :  UPPER_PATTERN_page0 = 8'h00; // 9
		  9'h049  :  UPPER_PATTERN_page0 = 8'h00;
		  9'h04A  :  UPPER_PATTERN_page0 = 8'hF0;
		  9'h04B  :  UPPER_PATTERN_page0 = 8'h08;
		  9'h04C  :  UPPER_PATTERN_page0 = 8'h08;
		  9'h04D  :  UPPER_PATTERN_page0 = 8'h18;
		  9'h04E  :  UPPER_PATTERN_page0 = 8'hF0;
		  9'h04F  :  UPPER_PATTERN_page0 = 8'h00;   
		  default : UPPER_PATTERN_page0 = 8'h00; 
		  endcase
	 end
	 
	if( INDEX >= 9'h050 && INDEX < 9'h050 + 8*Life )
	 begin
		case ( (INDEX-9'h050)%8 )  
		  9'h000  :  UPPER_PATTERN_page0 = 8'hC0; // 0
		  9'h001  :  UPPER_PATTERN_page0 = 8'hE0;
		  9'h002  :  UPPER_PATTERN_page0 = 8'hF0;
		  9'h003  :  UPPER_PATTERN_page0 = 8'hE0;
		  9'h004  :  UPPER_PATTERN_page0 = 8'hE0;
		  9'h005  :  UPPER_PATTERN_page0 = 8'hF0;
		  9'h006  :  UPPER_PATTERN_page0 = 8'hE0;
		  9'h007  :  UPPER_PATTERN_page0 = 8'hC0;
		endcase
	 end
 end
 
always @(INDEX)
 begin
	case(INDEX)
	9'h000  :  LOWER_PATTERN_page0 = 8'h00; // L
    9'h001  :  LOWER_PATTERN_page0 = 8'h0F;
    9'h002  :  LOWER_PATTERN_page0 = 8'h0F;
    9'h003  :  LOWER_PATTERN_page0 = 8'h0C;
    9'h004  :  LOWER_PATTERN_page0 = 8'h0C;
    9'h005  :  LOWER_PATTERN_page0 = 8'h0C;
    9'h006  :  LOWER_PATTERN_page0 = 8'h0E;
    9'h007  :  LOWER_PATTERN_page0 = 8'h00;
    9'h008  :  LOWER_PATTERN_page0 = 8'h00; // V
    9'h009  :  LOWER_PATTERN_page0 = 8'h00;
    9'h00A  :  LOWER_PATTERN_page0 = 8'h03;
    9'h00B  :  LOWER_PATTERN_page0 = 8'h0E;
    9'h00C  :  LOWER_PATTERN_page0 = 8'h0E;
    9'h00D  :  LOWER_PATTERN_page0 = 8'h03;
    9'h00E  :  LOWER_PATTERN_page0 = 8'h00;
    9'h00F  :  LOWER_PATTERN_page0 = 8'h00;  
	default : LOWER_PATTERN_page0 = 8'h00;
	endcase
	if( INDEX > 9'h017 && INDEX < 9'h020)
	 begin
		case ( (INDEX-9'h017)%8 + 8*LV )  
		      9'h000  :  LOWER_PATTERN_page0 = 8'h00; // 0
			  9'h001  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h002  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h003  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h004  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h005  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h006  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h007  :  LOWER_PATTERN_page0 = 8'h00; 
			  9'h008  :  LOWER_PATTERN_page0 = 8'h00; // 1
			  9'h009  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h00A  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h00B  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h00C  :  LOWER_PATTERN_page0 = 8'h0F;
			  9'h00D  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h00E  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h00F  :  LOWER_PATTERN_page0 = 8'h00;  
			  9'h010  :  LOWER_PATTERN_page0 = 8'h00; // 2
			  9'h011  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h012  :  LOWER_PATTERN_page0 = 8'h0C;
			  9'h013  :  LOWER_PATTERN_page0 = 8'h0E;
			  9'h014  :  LOWER_PATTERN_page0 = 8'h0B;
			  9'h015  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h016  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h017  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h018  :  LOWER_PATTERN_page0 = 8'h00; // 3
			  9'h019  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h01A  :  LOWER_PATTERN_page0 = 8'h04;
			  9'h01B  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h01C  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h01D  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h01E  :  LOWER_PATTERN_page0 = 8'h07;
			  9'h01F  :  LOWER_PATTERN_page0 = 8'h00;  
			  9'h020  :  LOWER_PATTERN_page0 = 8'h00; // 4
			  9'h021  :  LOWER_PATTERN_page0 = 8'h03;
			  9'h022  :  LOWER_PATTERN_page0 = 8'h02;
			  9'h023  :  LOWER_PATTERN_page0 = 8'h02;
			  9'h024  :  LOWER_PATTERN_page0 = 8'h02;
			  9'h025  :  LOWER_PATTERN_page0 = 8'h0F;
			  9'h026  :  LOWER_PATTERN_page0 = 8'h02;
			  9'h027  :  LOWER_PATTERN_page0 = 8'h00;   
			  9'h028  :  LOWER_PATTERN_page0 = 8'h00; // 5
			  9'h029  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h02A  :  LOWER_PATTERN_page0 = 8'h04;
			  9'h02B  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h02C  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h02D  :  LOWER_PATTERN_page0 = 8'h0C;
			  9'h02E  :  LOWER_PATTERN_page0 = 8'h07;
			  9'h02F  :  LOWER_PATTERN_page0 = 8'h00;    
			  9'h030  :  LOWER_PATTERN_page0 = 8'h00; // 6
			  9'h031  :  LOWER_PATTERN_page0 = 8'h03;
			  9'h032  :  LOWER_PATTERN_page0 = 8'h0C;
			  9'h033  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h034  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h035  :  LOWER_PATTERN_page0 = 8'h0C;
			  9'h036  :  LOWER_PATTERN_page0 = 8'h07;
			  9'h037  :  LOWER_PATTERN_page0 = 8'h00; 
			  9'h038  :  LOWER_PATTERN_page0 = 8'h00; // 7
			  9'h039  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h03A  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h03B  :  LOWER_PATTERN_page0 = 8'h0C;
			  9'h03C  :  LOWER_PATTERN_page0 = 8'h03;
			  9'h03D  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h03E  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h03F  :  LOWER_PATTERN_page0 = 8'h00;  
			  9'h040  :  LOWER_PATTERN_page0 = 8'h00; // 8
			  9'h041  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h042  :  LOWER_PATTERN_page0 = 8'h07;
			  9'h043  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h044  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h045  :  LOWER_PATTERN_page0 = 8'h08;
			  9'h046  :  LOWER_PATTERN_page0 = 8'h07;
			  9'h047  :  LOWER_PATTERN_page0 = 8'h00;  
			  9'h048  :  LOWER_PATTERN_page0 = 8'h00; // 9
			  9'h049  :  LOWER_PATTERN_page0 = 8'h00;
			  9'h04A  :  LOWER_PATTERN_page0 = 8'h08; 
			  9'h04B  :  LOWER_PATTERN_page0 = 8'h09;
			  9'h04C  :  LOWER_PATTERN_page0 = 8'h09;
			  9'h04D  :  LOWER_PATTERN_page0 = 8'h05;
			  9'h04E  :  LOWER_PATTERN_page0 = 8'h03;
			  9'h04F  :  LOWER_PATTERN_page0 = 8'h00;  
		  default : LOWER_PATTERN_page0 = 8'h00; 
		  endcase
	 end
	if( INDEX >= 9'h050 && INDEX < 9'h050 + 8*Life )
	 begin
		case ( (INDEX-9'h050)%8 )  
		  9'h000  :  LOWER_PATTERN_page0 = 8'h01; // 0
		  9'h001  :  LOWER_PATTERN_page0 = 8'h03;
		  9'h002  :  LOWER_PATTERN_page0 = 8'h07;
		  9'h003  :  LOWER_PATTERN_page0 = 8'h0F;
		  9'h004  :  LOWER_PATTERN_page0 = 8'h0F;
		  9'h005  :  LOWER_PATTERN_page0 = 8'h07;
		  9'h006  :  LOWER_PATTERN_page0 = 8'h03;
		  9'h007  :  LOWER_PATTERN_page0 = 8'h01;
		endcase
	 end
 end
always @(INDEX)
   begin
	if(INDEX < loc1 + 6'd8 && INDEX > loc1)
	 begin
		numberpattern = number1[11:8];
		loc =loc1;
	 end
	else if(INDEX < loc1 + 6'd16 && INDEX > loc1)
	 begin
		numberpattern = number1[7:4];
		loc =loc1;
	 end 
	else if(INDEX < loc1 + 6'd24 && INDEX > loc1)
	 begin
		numberpattern = number1[3:0];
		loc =loc1;
	 end 
	 else if(INDEX < loc2 + 6'd8 && INDEX > loc2)
	 begin
		numberpattern = number2[11:8];
		loc =loc2;
	 end
	else if(INDEX < loc2 + 6'd16 && INDEX > loc2)
	 begin
		numberpattern = number2[7:4];
		loc =loc2;
	 end
	else if(INDEX < loc2 + 6'd24 && INDEX > loc2)
	 begin
		numberpattern = number2[3:0];
		loc =loc2;
	 end 
    else
	 begin
		numberpattern = 4'hE;
		loc = 0;
	 end
	 
	case ( (INDEX-loc)%8 +8*numberpattern )  
     9'h000  :  UPPER_PATTERN = 8'h00; // 0
     9'h001  :  UPPER_PATTERN = 8'h00;
     9'h002  :  UPPER_PATTERN = 8'h00;
     9'h003  :  UPPER_PATTERN = 8'h00;
     9'h004  :  UPPER_PATTERN = 8'h00;
     9'h005  :  UPPER_PATTERN = 8'h00;
     9'h006  :  UPPER_PATTERN = 8'h00;
     9'h007  :  UPPER_PATTERN = 8'h00;
     9'h008  :  UPPER_PATTERN = 8'h00; // 1
     9'h009  :  UPPER_PATTERN = 8'h00;
     9'h00A  :  UPPER_PATTERN = 8'h10;
     9'h00B  :  UPPER_PATTERN = 8'h18;
     9'h00C  :  UPPER_PATTERN = 8'hF8;
     9'h00D  :  UPPER_PATTERN = 8'h00;
     9'h00E  :  UPPER_PATTERN = 8'h00;
     9'h00F  :  UPPER_PATTERN = 8'h00;  
     9'h010  :  UPPER_PATTERN = 8'h00; // 2
     9'h011  :  UPPER_PATTERN = 8'h00;
     9'h012  :  UPPER_PATTERN = 8'h10;
     9'h013  :  UPPER_PATTERN = 8'h08;
     9'h014  :  UPPER_PATTERN = 8'h08;
     9'h015  :  UPPER_PATTERN = 8'h88;
     9'h016  :  UPPER_PATTERN = 8'h70; 
     9'h017  :  UPPER_PATTERN = 8'h00;  
     9'h018  :  UPPER_PATTERN = 8'h00; // 3
     9'h019  :  UPPER_PATTERN = 8'h00;
     9'h01A  :  UPPER_PATTERN = 8'h10;
     9'h01B  :  UPPER_PATTERN = 8'h88;
     9'h01C  :  UPPER_PATTERN = 8'h88;
     9'h01D  :  UPPER_PATTERN = 8'h88;
     9'h01E  :  UPPER_PATTERN = 8'h70;
     9'h01F  :  UPPER_PATTERN = 8'h00;   
	  
     9'h020  :  UPPER_PATTERN = 8'h00; // 4
     9'h021  :  UPPER_PATTERN = 8'h00;
     9'h022  :  UPPER_PATTERN = 8'h80;
     9'h023  :  UPPER_PATTERN = 8'h60;
     9'h024  :  UPPER_PATTERN = 8'h18;
     9'h025  :  UPPER_PATTERN = 8'hF8;
     9'h026  :  UPPER_PATTERN = 8'h00;    
     9'h027  :  UPPER_PATTERN = 8'h00;  
     9'h028  :  UPPER_PATTERN = 8'h00; // 5
     9'h029  :  UPPER_PATTERN = 8'h00;
     9'h02A  :  UPPER_PATTERN = 8'h78;
     9'h02B  :  UPPER_PATTERN = 8'h48;
     9'h02C  :  UPPER_PATTERN = 8'h48;
     9'h02D  :  UPPER_PATTERN = 8'hC8;
     9'h02E  :  UPPER_PATTERN = 8'h88;
     9'h02F  :  UPPER_PATTERN = 8'h00; 
	 
     9'h030  :  UPPER_PATTERN = 8'h00; // 6
     9'h031  :  UPPER_PATTERN = 8'hE0;
     9'h032  :  UPPER_PATTERN = 8'h90;
     9'h033  :  UPPER_PATTERN = 8'H48;
     9'h034  :  UPPER_PATTERN = 8'h48;
     9'h035  :  UPPER_PATTERN = 8'hC8; 
     9'h036  :  UPPER_PATTERN = 8'h00;
     9'h037  :  UPPER_PATTERN = 8'h00;   
     9'h038  :  UPPER_PATTERN = 8'h00; // 7
     9'h039  :  UPPER_PATTERN = 8'h00;
     9'h03A  :  UPPER_PATTERN = 8'h08;
     9'h03B  :  UPPER_PATTERN = 8'h08;
     9'h03C  :  UPPER_PATTERN = 8'h88;
     9'h03D  :  UPPER_PATTERN = 8'h68;
     9'h03E  :  UPPER_PATTERN = 8'h18;
     9'h03F  :  UPPER_PATTERN = 8'h00; 
	 
     9'h040  :  UPPER_PATTERN = 8'h00; // 8
     9'h041  :  UPPER_PATTERN = 8'h00;
     9'h042  :  UPPER_PATTERN = 8'h70;
     9'h043  :  UPPER_PATTERN = 8'H88;
     9'h044  :  UPPER_PATTERN = 8'h88;
     9'h045  :  UPPER_PATTERN = 8'h88;
     9'h046  :  UPPER_PATTERN = 8'h70;
     9'h047  :  UPPER_PATTERN = 8'h00;   
     9'h048  :  UPPER_PATTERN = 8'h00; // 9
     9'h049  :  UPPER_PATTERN = 8'h00;
     9'h04A  :  UPPER_PATTERN = 8'hF0;
     9'h04B  :  UPPER_PATTERN = 8'h08;
     9'h04C  :  UPPER_PATTERN = 8'h08;
     9'h04D  :  UPPER_PATTERN = 8'h18;
     9'h04E  :  UPPER_PATTERN = 8'hF0;
     9'h04F  :  UPPER_PATTERN = 8'h00;   
	  
	  9'h050  :  UPPER_PATTERN = 8'h00; // +
     9'h051  :  UPPER_PATTERN = 8'h80;
     9'h052  :  UPPER_PATTERN = 8'h80;
     9'h053  :  UPPER_PATTERN = 8'hE0;
     9'h054  :  UPPER_PATTERN = 8'hE0;
     9'h055  :  UPPER_PATTERN = 8'h80;
     9'h056  :  UPPER_PATTERN = 8'h80;
     9'h057  :  UPPER_PATTERN = 8'h00;   
     9'h058  :  UPPER_PATTERN = 8'h00; // -
     9'h059  :  UPPER_PATTERN = 8'h80;
     9'h05A  :  UPPER_PATTERN = 8'h80;
     9'h05B  :  UPPER_PATTERN = 8'h80;
     9'h05C  :  UPPER_PATTERN = 8'h80;
     9'h05D  :  UPPER_PATTERN = 8'h80;
     9'h05E  :  UPPER_PATTERN = 8'h80;
     9'h05F  :  UPPER_PATTERN = 8'h00;
	 
	  9'h060  :  UPPER_PATTERN = 8'h00; // *
     9'h061  :  UPPER_PATTERN = 8'h20;
     9'h062  :  UPPER_PATTERN = 8'h40;
     9'h063  :  UPPER_PATTERN = 8'h80;
     9'h064  :  UPPER_PATTERN = 8'h80;
     9'h065  :  UPPER_PATTERN = 8'h40;
     9'h066  :  UPPER_PATTERN = 8'h20;
     9'h067  :  UPPER_PATTERN = 8'h00;   
     9'h068  :  UPPER_PATTERN = 8'h00; // /
     9'h069  :  UPPER_PATTERN = 8'h00;
     9'h06A  :  UPPER_PATTERN = 8'h00;
     9'h06B  :  UPPER_PATTERN = 8'h80;
     9'h06C  :  UPPER_PATTERN = 8'hc0;
     9'h06D  :  UPPER_PATTERN = 8'hf0;
     9'h06E  :  UPPER_PATTERN = 8'h30;
     9'h06F  :  UPPER_PATTERN = 8'h00;
	 
	 default :  UPPER_PATTERN = 8'h00;  
    endcase 
	if(numberpattern == 4'hE)
		UPPER_PATTERN = 8'h00;
   end
  always @(INDEX)
   begin
	 
    case ((INDEX-loc)%8 +8*numberpattern) 
     9'h000  :  LOWER_PATTERN = 8'h00; // 0
     9'h001  :  LOWER_PATTERN = 8'h00;
     9'h002  :  LOWER_PATTERN = 8'h00;
     9'h003  :  LOWER_PATTERN = 8'h00;
     9'h004  :  LOWER_PATTERN = 8'h00;
     9'h005  :  LOWER_PATTERN = 8'h00;
     9'h006  :  LOWER_PATTERN = 8'h00;
     9'h007  :  LOWER_PATTERN = 8'h00; 
     9'h008  :  LOWER_PATTERN = 8'h00; // 1
     9'h009  :  LOWER_PATTERN = 8'h00;
     9'h00A  :  LOWER_PATTERN = 8'h08;
     9'h00B  :  LOWER_PATTERN = 8'h08;
     9'h00C  :  LOWER_PATTERN = 8'h0F;
     9'h00D  :  LOWER_PATTERN = 8'h08;
     9'h00E  :  LOWER_PATTERN = 8'h08;
     9'h00F  :  LOWER_PATTERN = 8'h00;  
     9'h010  :  LOWER_PATTERN = 8'h00; // 2
     9'h011  :  LOWER_PATTERN = 8'h00;
     9'h012  :  LOWER_PATTERN = 8'h0C;
     9'h013  :  LOWER_PATTERN = 8'h0E;
     9'h014  :  LOWER_PATTERN = 8'h0B;
     9'h015  :  LOWER_PATTERN = 8'h08;
     9'h016  :  LOWER_PATTERN = 8'h08;
     9'h017  :  LOWER_PATTERN = 8'h00;
     9'h018  :  LOWER_PATTERN = 8'h00; // 3
     9'h019  :  LOWER_PATTERN = 8'h00;
     9'h01A  :  LOWER_PATTERN = 8'h04;
     9'h01B  :  LOWER_PATTERN = 8'h08;
     9'h01C  :  LOWER_PATTERN = 8'h08;
     9'h01D  :  LOWER_PATTERN = 8'h08;
     9'h01E  :  LOWER_PATTERN = 8'h07;
     9'h01F  :  LOWER_PATTERN = 8'h00;  
     9'h020  :  LOWER_PATTERN = 8'h00; // 4
     9'h021  :  LOWER_PATTERN = 8'h03;
     9'h022  :  LOWER_PATTERN = 8'h02;
     9'h023  :  LOWER_PATTERN = 8'h02;
     9'h024  :  LOWER_PATTERN = 8'h02;
     9'h025  :  LOWER_PATTERN = 8'h0F;
     9'h026  :  LOWER_PATTERN = 8'h02;
     9'h027  :  LOWER_PATTERN = 8'h00;   
     9'h028  :  LOWER_PATTERN = 8'h00; // 5
     9'h029  :  LOWER_PATTERN = 8'h00;
     9'h02A  :  LOWER_PATTERN = 8'h04;
     9'h02B  :  LOWER_PATTERN = 8'h08;
     9'h02C  :  LOWER_PATTERN = 8'h08;
     9'h02D  :  LOWER_PATTERN = 8'h0C;
     9'h02E  :  LOWER_PATTERN = 8'h07;
     9'h02F  :  LOWER_PATTERN = 8'h00;    
     9'h030  :  LOWER_PATTERN = 8'h00; // 6
     9'h031  :  LOWER_PATTERN = 8'h03;
     9'h032  :  LOWER_PATTERN = 8'h0C;
     9'h033  :  LOWER_PATTERN = 8'h08;
     9'h034  :  LOWER_PATTERN = 8'h08;
     9'h035  :  LOWER_PATTERN = 8'h0C;
     9'h036  :  LOWER_PATTERN = 8'h07;
     9'h037  :  LOWER_PATTERN = 8'h00; 
     9'h038  :  LOWER_PATTERN = 8'h00; // 7
     9'h039  :  LOWER_PATTERN = 8'h00;
     9'h03A  :  LOWER_PATTERN = 8'h00;
     9'h03B  :  LOWER_PATTERN = 8'h0C;
     9'h03C  :  LOWER_PATTERN = 8'h03;
     9'h03D  :  LOWER_PATTERN = 8'h00;
     9'h03E  :  LOWER_PATTERN = 8'h00;
     9'h03F  :  LOWER_PATTERN = 8'h00;  
     9'h040  :  LOWER_PATTERN = 8'h00; // 8
     9'h041  :  LOWER_PATTERN = 8'h00;
     9'h042  :  LOWER_PATTERN = 8'h07;
     9'h043  :  LOWER_PATTERN = 8'h08;
     9'h044  :  LOWER_PATTERN = 8'h08;
     9'h045  :  LOWER_PATTERN = 8'h08;
     9'h046  :  LOWER_PATTERN = 8'h07;
     9'h047  :  LOWER_PATTERN = 8'h00;  
     9'h048  :  LOWER_PATTERN = 8'h00; // 9
     9'h049  :  LOWER_PATTERN = 8'h00;
     9'h04A  :  LOWER_PATTERN = 8'h08; 
     9'h04B  :  LOWER_PATTERN = 8'h09;
     9'h04C  :  LOWER_PATTERN = 8'h09;
     9'h04D  :  LOWER_PATTERN = 8'h05;
     9'h04E  :  LOWER_PATTERN = 8'h03;
     9'h04F  :  LOWER_PATTERN = 8'h00; 
	  
	  9'h050  :  LOWER_PATTERN = 8'h00; // +
     9'h051  :  LOWER_PATTERN = 8'h01;
     9'h052  :  LOWER_PATTERN = 8'h01;
     9'h053  :  LOWER_PATTERN = 8'h07;
     9'h054  :  LOWER_PATTERN = 8'h07;
     9'h055  :  LOWER_PATTERN = 8'h01;
     9'h056  :  LOWER_PATTERN = 8'h01;
     9'h057  :  LOWER_PATTERN = 8'h00;  
     9'h058  :  LOWER_PATTERN = 8'h00; // -
     9'h059  :  LOWER_PATTERN = 8'h01;
     9'h05A  :  LOWER_PATTERN = 8'h01; 
     9'h05B  :  LOWER_PATTERN = 8'h01;
     9'h05C  :  LOWER_PATTERN = 8'h01;
     9'h05D  :  LOWER_PATTERN = 8'h01;
     9'h05E  :  LOWER_PATTERN = 8'h01;
     9'h05F  :  LOWER_PATTERN = 8'h00; 
	 
	  9'h060  :  LOWER_PATTERN = 8'h00; // *
     9'h061  :  LOWER_PATTERN = 8'h04;
     9'h062  :  LOWER_PATTERN = 8'h02;
     9'h063  :  LOWER_PATTERN = 8'h01;
     9'h064  :  LOWER_PATTERN = 8'h01;
     9'h065  :  LOWER_PATTERN = 8'h02;
     9'h066  :  LOWER_PATTERN = 8'h04;
     9'h067  :  LOWER_PATTERN = 8'h00;  
     9'h068  :  LOWER_PATTERN = 8'h00; // /
     9'h069  :  LOWER_PATTERN = 8'h0c;
     9'h06A  :  LOWER_PATTERN = 8'h0e; 
     9'h06B  :  LOWER_PATTERN = 8'h07;
     9'h06C  :  LOWER_PATTERN = 8'h01;
     9'h06D  :  LOWER_PATTERN = 8'h00;
     9'h06E  :  LOWER_PATTERN = 8'h00;
     9'h06F  :  LOWER_PATTERN = 8'h00; 

     default :  LOWER_PATTERN = 8'h00;  
    endcase  
	if(numberpattern == 4'hE)
		LOWER_PATTERN = 8'h00; 
   end   
   
     always@(INDEX)
   begin
	case ( INDEX - 44)
	9'h000: UPPER_PATTERN_unstart = 8'h00;  //s
	9'h001: UPPER_PATTERN_unstart = 8'hc0; 
	9'h002: UPPER_PATTERN_unstart = 8'hb0; 
	9'h003: UPPER_PATTERN_unstart = 8'hb0; 
	9'h004: UPPER_PATTERN_unstart = 8'hb0; 
	9'h005: UPPER_PATTERN_unstart = 8'hb0; 
	9'h006: UPPER_PATTERN_unstart = 8'h20; 
	9'h007: UPPER_PATTERN_unstart = 8'h00; 
	
	9'h008: UPPER_PATTERN_unstart = 8'h70;  //t
	9'h009: UPPER_PATTERN_unstart = 8'h70; 
	9'h00a: UPPER_PATTERN_unstart = 8'hf0; 
	9'h00b: UPPER_PATTERN_unstart = 8'hf0; 
	9'h00c: UPPER_PATTERN_unstart = 8'hf0; 
	9'h00d: UPPER_PATTERN_unstart = 8'h70; 
	9'h00e: UPPER_PATTERN_unstart = 8'h70; 
	9'h00f: UPPER_PATTERN_unstart = 8'h00; 
	
	9'h010: UPPER_PATTERN_unstart = 8'hc0;  //a
	9'h011: UPPER_PATTERN_unstart = 8'he0; 
	9'h012: UPPER_PATTERN_unstart = 8'h30; 
	9'h013: UPPER_PATTERN_unstart = 8'h30; 
	9'h014: UPPER_PATTERN_unstart = 8'h30; 
	9'h015: UPPER_PATTERN_unstart = 8'he0; 
	9'h016: UPPER_PATTERN_unstart = 8'hc0; 
	9'h017: UPPER_PATTERN_unstart = 8'h00; 

	9'h018: UPPER_PATTERN_unstart = 8'hf0;  //r
	9'h019: UPPER_PATTERN_unstart = 8'h90; 
	9'h01a: UPPER_PATTERN_unstart = 8'h90; 
	9'h01b: UPPER_PATTERN_unstart = 8'h90; 
	9'h01c: UPPER_PATTERN_unstart = 8'h90; 
	9'h01d: UPPER_PATTERN_unstart = 8'h90; 
	9'h01e: UPPER_PATTERN_unstart = 8'h90; 
	9'h01f: UPPER_PATTERN_unstart = 8'h60; 
	
	9'h020: UPPER_PATTERN_unstart = 8'h00;  //t
	9'h021: UPPER_PATTERN_unstart = 8'h70; 
	9'h022: UPPER_PATTERN_unstart = 8'h70; 
	9'h023: UPPER_PATTERN_unstart = 8'hf0; 
	9'h024: UPPER_PATTERN_unstart = 8'hf0; 
	9'h025: UPPER_PATTERN_unstart = 8'hf0; 
	9'h026: UPPER_PATTERN_unstart = 8'h70; 
	9'h027: UPPER_PATTERN_unstart = 8'h70; 
	
	default : UPPER_PATTERN_unstart = 8'h00; 
	endcase
   end
  
always@(INDEX)
   begin
	case ( INDEX -44)
	9'h000: LOWER_PATTERN_unstart = 8'h00;  //s
	9'h001: LOWER_PATTERN_unstart = 8'h04; 
	9'h002: LOWER_PATTERN_unstart = 8'h05; 
	9'h003: LOWER_PATTERN_unstart = 8'h0d; 
	9'h004: LOWER_PATTERN_unstart = 8'h0d; 
	9'h005: LOWER_PATTERN_unstart = 8'h0d; 
	9'h006: LOWER_PATTERN_unstart = 8'h07; 
	9'h007: LOWER_PATTERN_unstart = 8'h00; 
	
	9'h008: LOWER_PATTERN_unstart = 8'h00;  //t
	9'h009: LOWER_PATTERN_unstart = 8'h00; 
	9'h00a: LOWER_PATTERN_unstart = 8'h0f; 
	9'h00b: LOWER_PATTERN_unstart = 8'h0f; 
	9'h00c: LOWER_PATTERN_unstart = 8'h0f; 
	9'h00d: LOWER_PATTERN_unstart = 8'h00; 
	9'h00e: LOWER_PATTERN_unstart = 8'h00; 
	9'h00f: LOWER_PATTERN_unstart = 8'h00; 
	
	9'h010: LOWER_PATTERN_unstart = 8'h0f;  //a
	9'h011: LOWER_PATTERN_unstart = 8'h0f; 
	9'h012: LOWER_PATTERN_unstart = 8'h01; 
	9'h013: LOWER_PATTERN_unstart = 8'h01; 
	9'h014: LOWER_PATTERN_unstart = 8'h01; 
	9'h015: LOWER_PATTERN_unstart = 8'h0f; 
	9'h016: LOWER_PATTERN_unstart = 8'h0f; 
	9'h017: LOWER_PATTERN_unstart = 8'h00; 

	9'h018: LOWER_PATTERN_unstart = 8'h00;  //r
	9'h019: LOWER_PATTERN_unstart = 8'h0f; 
	9'h01a: LOWER_PATTERN_unstart = 8'h0f; 
	9'h01b: LOWER_PATTERN_unstart = 8'h00; 
	9'h01c: LOWER_PATTERN_unstart = 8'h01; 
	9'h01d: LOWER_PATTERN_unstart = 8'h01; 
	9'h01e: LOWER_PATTERN_unstart = 8'h06; 
	9'h01f: LOWER_PATTERN_unstart = 8'h0c; 
	
	9'h020: LOWER_PATTERN_unstart = 8'h00;  //t
	9'h021: LOWER_PATTERN_unstart = 8'h00; 
	9'h022: LOWER_PATTERN_unstart = 8'h00; 
	9'h023: LOWER_PATTERN_unstart = 8'h0f; 
	9'h024: LOWER_PATTERN_unstart = 8'h0f; 
	9'h025: LOWER_PATTERN_unstart = 8'h0f; 
	9'h026: LOWER_PATTERN_unstart = 8'h00; 
	9'h027: LOWER_PATTERN_unstart = 8'h00; 
	
	default : LOWER_PATTERN_unstart = 8'h00; 
	endcase
   end  
  always@(INDEX)
   begin
	case ( INDEX - 32)
	9'h000: UPPER_PATTERN_startpage = 8'h01;  //G
	9'h001: UPPER_PATTERN_startpage = 8'h07; 
	9'h002: UPPER_PATTERN_startpage = 8'h0c; 
	9'h003: UPPER_PATTERN_startpage = 8'h0c; 
	9'h004: UPPER_PATTERN_startpage = 8'h0d; 
	9'h005: UPPER_PATTERN_startpage = 8'h07; 
	9'h006: UPPER_PATTERN_startpage = 8'h03; 
	9'h007: UPPER_PATTERN_startpage = 8'h00; 
	
	9'h008: UPPER_PATTERN_startpage = 8'h0f;  //A
	9'h009: UPPER_PATTERN_startpage = 8'h0f; 
	9'h00a: UPPER_PATTERN_startpage = 8'h01; 
	9'h00b: UPPER_PATTERN_startpage = 8'h01; 
	9'h00c: UPPER_PATTERN_startpage = 8'h01; 
	9'h00d: UPPER_PATTERN_startpage = 8'h0f; 
	9'h00e: UPPER_PATTERN_startpage = 8'h0f; 
	9'h00f: UPPER_PATTERN_startpage = 8'h00; 
	
	9'h010: UPPER_PATTERN_startpage = 8'h0f;  //M
	9'h011: UPPER_PATTERN_startpage = 8'h0f; 
	9'h012: UPPER_PATTERN_startpage = 8'h00; 
	9'h013: UPPER_PATTERN_startpage = 8'h01; 
	9'h014: UPPER_PATTERN_startpage = 8'h01; 
	9'h015: UPPER_PATTERN_startpage = 8'h00; 
	9'h016: UPPER_PATTERN_startpage = 8'h0f; 
	9'h017: UPPER_PATTERN_startpage = 8'h0f; 

	9'h018: UPPER_PATTERN_startpage = 8'h00;  //E
	9'h019: UPPER_PATTERN_startpage = 8'h0f; 
	9'h01a: UPPER_PATTERN_startpage = 8'h0f; 
	9'h01b: UPPER_PATTERN_startpage = 8'h0d; 
	9'h01c: UPPER_PATTERN_startpage = 8'h0d; 
	9'h01d: UPPER_PATTERN_startpage = 8'h0d; 
	9'h01e: UPPER_PATTERN_startpage = 8'h0c; 
	9'h01f: UPPER_PATTERN_startpage = 8'h00; 
	
	9'h020: UPPER_PATTERN_startpage = 8'h0f;  //O
	9'h021: UPPER_PATTERN_startpage = 8'h0f; 
	9'h022: UPPER_PATTERN_startpage = 8'h0c; 
	9'h023: UPPER_PATTERN_startpage = 8'h0c; 
	9'h024: UPPER_PATTERN_startpage = 8'h0c; 
	9'h025: UPPER_PATTERN_startpage = 8'h0f; 
	9'h026: UPPER_PATTERN_startpage = 8'h0f; 
	9'h027: UPPER_PATTERN_startpage = 8'h00; 
	
	9'h028: UPPER_PATTERN_startpage = 8'h01;  //V
	9'h029: UPPER_PATTERN_startpage = 8'h03; 
	9'h02a: UPPER_PATTERN_startpage = 8'h06; 
	9'h02b: UPPER_PATTERN_startpage = 8'h0c; 
	9'h02c: UPPER_PATTERN_startpage = 8'h0c; 
	9'h02d: UPPER_PATTERN_startpage = 8'h06; 
	9'h02e: UPPER_PATTERN_startpage = 8'h03; 
	9'h02f: UPPER_PATTERN_startpage = 8'h01; 
	
	9'h030: UPPER_PATTERN_startpage = 8'h00;  //E
	9'h031: UPPER_PATTERN_startpage = 8'h0f; 
	9'h032: UPPER_PATTERN_startpage = 8'h0f; 
	9'h033: UPPER_PATTERN_startpage = 8'h0d; 
	9'h034: UPPER_PATTERN_startpage = 8'h0d; 
	9'h035: UPPER_PATTERN_startpage = 8'h0d; 
	9'h036: UPPER_PATTERN_startpage = 8'h0c; 
	9'h037: UPPER_PATTERN_startpage = 8'h00; 
	
	9'h038: UPPER_PATTERN_startpage = 8'h0f;  //R
	9'h039: UPPER_PATTERN_startpage = 8'h0f; 
	9'h03a: UPPER_PATTERN_startpage = 8'h01; 
	9'h03b: UPPER_PATTERN_startpage = 8'h03; 
	9'h03c: UPPER_PATTERN_startpage = 8'h07; 
	9'h03d: UPPER_PATTERN_startpage = 8'h0b; 
	9'h03e: UPPER_PATTERN_startpage = 8'h08; 
	9'h03f: UPPER_PATTERN_startpage = 8'h00; 
	default : UPPER_PATTERN_startpage = 8'h00; 
	endcase
   end

   always@(INDEX)
   begin
	case ( INDEX - 32)
	9'h000: LOWER_PATTERN_startpage = 8'hc0;  //G
	9'h001: LOWER_PATTERN_startpage = 8'he0; 
	9'h002: LOWER_PATTERN_startpage = 8'h30; 
	9'h003: LOWER_PATTERN_startpage = 8'h30; 
	9'h004: LOWER_PATTERN_startpage = 8'h30; 
	9'h005: LOWER_PATTERN_startpage = 8'h60; 
	9'h006: LOWER_PATTERN_startpage = 8'h40; 
	9'h007: LOWER_PATTERN_startpage = 8'h00; 
	
	9'h008: LOWER_PATTERN_startpage = 8'hc0;  //A
	9'h009: LOWER_PATTERN_startpage = 8'hc0; 
	9'h00a: LOWER_PATTERN_startpage = 8'h30; 
	9'h00b: LOWER_PATTERN_startpage = 8'h30; 
	9'h00c: LOWER_PATTERN_startpage = 8'h30; 
	9'h00d: LOWER_PATTERN_startpage = 8'h30; 
	9'h00e: LOWER_PATTERN_startpage = 8'hc0; 
	9'h00f: LOWER_PATTERN_startpage = 8'hf0; 
	
	9'h010: LOWER_PATTERN_startpage = 8'hf0;  //M
	9'h011: LOWER_PATTERN_startpage = 8'hf0; 
	9'h012: LOWER_PATTERN_startpage = 8'h60; 
	9'h013: LOWER_PATTERN_startpage = 8'h80; 
	9'h014: LOWER_PATTERN_startpage = 8'h80; 
	9'h015: LOWER_PATTERN_startpage = 8'h60; 
	9'h016: LOWER_PATTERN_startpage = 8'hf0; 
	9'h017: LOWER_PATTERN_startpage = 8'hf0; 

	9'h018: LOWER_PATTERN_startpage = 8'h00;  //E
	9'h019: LOWER_PATTERN_startpage = 8'hf0; 
	9'h01a: LOWER_PATTERN_startpage = 8'hf0; 
	9'h01b: LOWER_PATTERN_startpage = 8'hb0; 
	9'h01c: LOWER_PATTERN_startpage = 8'hb0; 
	9'h01d: LOWER_PATTERN_startpage = 8'hb0; 
	9'h01e: LOWER_PATTERN_startpage = 8'h30; 
	9'h01f: LOWER_PATTERN_startpage = 8'h00; 
	
	9'h020: LOWER_PATTERN_startpage = 8'hf0;  //O
	9'h021: LOWER_PATTERN_startpage = 8'hf0; 
	9'h022: LOWER_PATTERN_startpage = 8'h30; 
	9'h023: LOWER_PATTERN_startpage = 8'h30; 
	9'h024: LOWER_PATTERN_startpage = 8'h30; 
	9'h025: LOWER_PATTERN_startpage = 8'hf0; 
	9'h026: LOWER_PATTERN_startpage = 8'hf0; 
	9'h027: LOWER_PATTERN_startpage = 8'h00; 
	
	9'h028: LOWER_PATTERN_startpage = 8'hf0;  //V
	9'h029: LOWER_PATTERN_startpage = 8'hf0; 
	9'h02a: LOWER_PATTERN_startpage = 8'h00; 
	9'h02b: LOWER_PATTERN_startpage = 8'h00; 
	9'h02c: LOWER_PATTERN_startpage = 8'h00; 
	9'h02d: LOWER_PATTERN_startpage = 8'h00; 
	9'h02e: LOWER_PATTERN_startpage = 8'hf0; 
	9'h02f: LOWER_PATTERN_startpage = 8'hf0; 
	
	9'h030: LOWER_PATTERN_startpage = 8'h00;  //E
	9'h031: LOWER_PATTERN_startpage = 8'hf0; 
	9'h032: LOWER_PATTERN_startpage = 8'hf0; 
	9'h033: LOWER_PATTERN_startpage = 8'hb0; 
	9'h034: LOWER_PATTERN_startpage = 8'hb0; 
	9'h035: LOWER_PATTERN_startpage = 8'hb0; 
	9'h036: LOWER_PATTERN_startpage = 8'h30; 
	9'h037: LOWER_PATTERN_startpage = 8'h00; 

	9'h038: LOWER_PATTERN_startpage = 8'hf0;  //R
	9'h039: LOWER_PATTERN_startpage = 8'hb0; 
	9'h03a: LOWER_PATTERN_startpage = 8'hb0; 
	9'h03b: LOWER_PATTERN_startpage = 8'hb0; 
	9'h03c: LOWER_PATTERN_startpage = 8'hb0; 
	9'h03d: LOWER_PATTERN_startpage = 8'hb0; 
	9'h03e: LOWER_PATTERN_startpage = 8'he0; 
	9'h03f: LOWER_PATTERN_startpage = 8'h00; 
	default : LOWER_PATTERN_startpage = 8'h00; 
	endcase
   end
/***********************
 * Time Base Generator *
 ***********************/
 
  always @(posedge CLK or negedge RESET)
   begin
    if (!RESET)
     DIVIDER <= {6'o00,2'b00};
    else
     DIVIDER <= DIVIDER + 1;
   end
  assign LCD_CLK = DIVIDER[7];

/******************************
 * Initial And Write LGM Data * 
 ******************************/

  always @(negedge LCD_CLK or negedge RESET)
   begin
    if (!RESET)
     begin
	     CLEAR  <= 1'b1;
	     STATE  <= 3'b0;
	     DELAY  <= 16'h0000;
         X_PAGE <= 3'o0;
	     INDEX   = 0;
	     LCD_RST<= 1'b0;
	     ENABLE <= 2'b00;
         LCD_SEL<= 2'b11;
         LCD_DI <= 1'b0;
	     LCD_RW <= 1'b0;
		locexp4 = 9'h40;
		locexp5 = 9'h40;
		locexp6 = 9'h40;
		locexp1 = 9'h30;
		locexp2 = 9'h30;
		locexp3 = 9'h30;
		speed<=16'h0000;
		update=0;
		start = 0;
     end
    else
     begin
		if(locexp1>=64||locexp2>=64||locexp3>=64) update=1;
		else update=0;
		if(update) begin
			locexp4 = locexp1;
			locexp5 = locexp2;
			locexp6 = locexp3;
			locexp1 = 0;
			locexp2 = 0;
			locexp3 = 0;
		 end
		 if (ENABLE < 2'b10)
         begin
	       ENABLE  <= ENABLE + 1;
	       if(X_PAGE==3'o2) DELAY[lvbit]<= 1'b1;
		   else DELAY[2]<=1'b1;
         end  
         else if (DELAY != 16'h0000)    
            DELAY <= DELAY - 1;
         else if (STATE == 3'o0)
         begin          
            STATE   <= 3'o1;
            LCD_RST <= 1'b1;
	        LCD_DATA<= 8'h3F;
	        ENABLE  <= 2'b00; 
         end
         else if (STATE == 3'o1)
         begin          
            STATE   <= 3'o2;
	        LCD_DATA<= 8'h40;
	        ENABLE  <= 2'b00;
         end               
         else if (STATE == 3'o2)          
         begin
            STATE   <= 3'o3;
	        LCD_DATA<= {2'b11,6'b000000};
	        ENABLE  <= 2'b00;
         end
         else if (STATE == 3'o3)
         begin        
            STATE   <= 3'o4; 
            LCD_DI  <= 1'b0;
			INDEX = 0;
            LCD_DATA<= {5'b10111,X_PAGE};
	        ENABLE  <= 2'b00;
         end  
	     else if (STATE == 3'o4)
         begin
	       if (CLEAR)              	
           begin
		        if (INDEX < 64)
                begin                  
			         INDEX    = INDEX + 1;
			         LCD_DI  <= 1'b1;
                     LCD_DATA<= 8'h00;
			         ENABLE  <= 2'b00;
                end  
				else if	(X_PAGE < 3'o7)     
                begin
 			        STATE  <= 3'o3;
                    X_PAGE <= X_PAGE + 1; 
                end  
 		        else
                begin
                    STATE  <= 3'o3;
			        X_PAGE <= 3'o0;
			        CLEAR  <= 1'b0; 
                end  
   	       end
		   else if(start[5] != 1'b1)
		    begin
               if (INDEX < 128)
               begin
                  LCD_DI <= 1'b1;
                  if (X_PAGE == 3)
					begin
					LCD_DATA <= UPPER_PATTERN_unstart;
                   end
				  else if(X_PAGE == 4)
					begin
                    LCD_DATA <= LOWER_PATTERN_unstart;
					end
				  else
				   begin
					LCD_DATA <= 8'h00;
				   end
               if (INDEX < 64)
                    LCD_SEL <= 2'b01;
					else
                    LCD_SEL <= 2'b10;
                              
               INDEX  = INDEX + 1;
               ENABLE<= 2'b00;
               end
           else
           begin
               STATE  <= 3'o3;
               LCD_SEL<= 2'b11;
               X_PAGE <= X_PAGE+1; 
			   if(X_PAGE == 3'O7)
					start = start +1;
           end 
		end
		   else if(Life == 0)
		    begin
               if (INDEX < 128)
               begin
                  LCD_DI <= 1'b1;
                  if (X_PAGE == 3)
					begin
					LCD_DATA <= LOWER_PATTERN_startpage;
                   end
				  else if(X_PAGE == 4)
					begin
                    LCD_DATA <= UPPER_PATTERN_startpage;
					end
				  else
				   begin
					LCD_DATA <= 8'h00;
				   end
               if (INDEX < 64)
                    LCD_SEL <= 2'b01;
					else
                    LCD_SEL <= 2'b10;
                              
               INDEX  = INDEX + 1;
               ENABLE<= 2'b00;
               end
           else
           begin
               STATE  <= 3'o3;
               LCD_SEL<= 2'b11;
               X_PAGE <= X_PAGE+1; 
           end 
          end
		   else if ((X_PAGE == 3'o0)||(X_PAGE == 3'o1))         
           begin
               if (INDEX < 128)
               begin
                  LCD_DI <= 1'b1;
                  if (X_PAGE == 3'o0)
						 begin
                    LCD_DATA <= UPPER_PATTERN_page0;
                   end
						else
						 begin
                    LCD_DATA <= LOWER_PATTERN_page0;
						 end
               if (INDEX < 64)
                    LCD_SEL <= 2'b01;
					else
                    LCD_SEL <= 2'b10;
                              
               INDEX  = INDEX + 1;
               ENABLE<= 2'b00;
               end
           else
           begin
               STATE  <= 3'o3;
               LCD_SEL<= 2'b11;
               X_PAGE <= X_PAGE+1; 
           end 
          end
		   else if ((X_PAGE == 3'o2)||(X_PAGE == 3'o3))         
           begin
               if (INDEX < 128)
               begin
                  LCD_DI <= 1'b1;
                  if (X_PAGE == 3'o2)
                    LCD_DATA <= UPPER_PATTERN;
                  else
                    LCD_DATA <= LOWER_PATTERN;
             
               if (INDEX < 64)
                    LCD_SEL <= 2'b01;
					else
                    LCD_SEL <= 2'b10;
                              
               INDEX  = INDEX + 1;
               ENABLE<= 2'b00;
               end
           else
           begin
               STATE  <= 3'o3;
               LCD_SEL<= 2'b11;
               X_PAGE <= X_PAGE+1;
				end
          end
		  else if ((X_PAGE == 3'o4)||(X_PAGE == 3'o5))         
           begin
               if (INDEX < 128)
               begin
                  LCD_DI <= 1'b1;
                  if (X_PAGE == 3'o4)
                    LCD_DATA <= UPPER_PATTERN;
                  else
                    LCD_DATA <= LOWER_PATTERN;
             
               if (INDEX < 64)
                    LCD_SEL <= 2'b01;
		       else
                    LCD_SEL <= 2'b10;
                              
               INDEX  = INDEX + 1;
               ENABLE<= 2'b00;
               end
           else
           begin
               STATE  <= 3'o3;
               LCD_SEL<= 2'b11;
               X_PAGE <= X_PAGE + 1;
           end 
          end
		  else if ((X_PAGE == 3'o6)||(X_PAGE == 3'o7))         
           begin
               if (INDEX < 128)
               begin
                  LCD_DI <= 1'b1;
                  if (X_PAGE == 3'o6)
                    LCD_DATA <= UPPER_PATTERN;
                  else
                    LCD_DATA <= LOWER_PATTERN;
             
               if (INDEX < 64)
                    LCD_SEL <= 2'b01;
		       else
                    LCD_SEL <= 2'b10;
                              
               INDEX  = INDEX + 1;
               ENABLE<= 2'b00;
               end
           else
           begin
               STATE  <= 3'o3;
               LCD_SEL<= 2'b11;
               X_PAGE <= X_PAGE + 1;
			   if( X_PAGE == 3'o7)
				begin
					locexp1 = locexp1+1; 
					locexp2 = locexp2+1;
					locexp3 = locexp3+1;
					locexp4 = locexp4+1;
					locexp5 = locexp5+1;
					locexp6 = locexp6+1;
				end
           end 
          end
          else   
          begin
             STATE  <= 3'o3;
             X_PAGE <= 3'o2;
			DELAY[16]<= 1'b1;
          end
         end  
	   end
   end 
  assign LCD_ENABLE = ENABLE[0];
  assign LCD_CS1    = LCD_SEL[0];
  assign LCD_CS2    = LCD_SEL[1];
  assign lvbit = (LV>2?7-LV+2:7);
endmodule 