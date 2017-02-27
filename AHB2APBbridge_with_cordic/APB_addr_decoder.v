//--==================================================================================--
// 		   Copyright (c) 2015 Chungnam National University. All rights reserved
//--------------------------------------------------------------------------------------
//        This confidential and proprietary software may be used only as
//            authorised by a licensing agreement from Nam-ho Kim 
//
//         The entire notice above must be reproduced on all authorised
//          copies and copies may only be made to the extent permitted
//                by a licensing agreement from Nam-ho Kim 
//
//      The entire notice above must be reproduced on all authorized copies.
//--------------------------------------------------------------------------------------
// 
//
//      SVN Information
//
//		FILE NAME       	: APB_addr_decoder.v
//
// 		AUTHOR 		        : Nam-ho Kim
//
//		AUTHOR'S EMAIL		: kkjknh2@gmail.com
//
//      Checked In          : 2015-05-25 16:40:10 (Mon, 25 May 2015)
//
//      Revision            : 0
//
//      
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// APB_addr_decoder description
//--------------------------------------------------------------------------------------
//memory map in undefined   			 			 	Address	 	Peripheral memory Map
//|------------|1FFF          							0xBFFF FFFF	-----------------------------
//|	           |										| 	      		    |
//|	 slave8	   |										| 	                    |
//|------------|1C00										| 	Undefined           |
//|	           |1BFF									|			    |	
//|	 slave7	   |										|			    |	
//|------------|1800 								0x8C00 0000	-----------------------------
//|	           |17FF									|	  		    |
//|	 slave6	   |										|	Remap& pause        |
//|------------|1400										|			    |
//|			   |13FF						0x8800 0000	-----------------------------
//|	 slave5	   |										|		            |
//|------------|1000										|	counter timer 	    |
//|			   |FFF									|			    |
//|	 slave4	  |								0x8400 0000	-----------------------------
//|------------|C00										|			    |
//|		BFF									|	interrupt controller|
//|	 slave3|										|			    |
//|------------|800								0x8000 0000	-----------------------------
//|	       |7FF
//|  slave2    |
//|------------|400
//|	       |3FF
//|	 slave1|
//|------------|0

module APB_addr_decoder(
	input 	wire	[31:0]		HADDR,
	output 	reg 			PSEL_1,
	output 	reg 			PSEL_2,
	output 	reg 			PSEL_3,
	output 	reg 			PSEL_4,
	output 	reg 			PSEL_5,
	output 	reg 			PSEL_6,
	output 	reg 			PSEL_7,
	output 	reg 			PSEL_8,
	output  reg			PSEL_NOMAP
//	output reg	[2:0]		Mux_sig
);

always @*
begin
	if((HADDR >= 32'h8C00_0000) && (HADDR<=32'h8C00_0002))
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8, PSEL_NOMAP} <= 9'b1000_00000;
/*	
	else if((HADDR >= 32'h400) && (HADDR<=32'h7FF))
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8, Mux_sig} <= 8'b0100_0000;
	
	else if((HADDR >= 32'h800) && (HADDR<=32'hBFF))
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8}} <= 8'b0010_0000;
	
	else if((HADDR >= 32'hC00) && (HADDR<=32'hFFF))
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8} <= 8'b0001_0000;
	
	else if((HADDR >= 32'h1000) && (HADDR<=32'h13FF))
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8} <= 8'b0000_1000;
	
	else if((HADDR >= 32'h1400) && (HADDR<=32'h17FF))
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8} <= 8'b0000_0100;
		
	else if((HADDR >= 32'h1800) && (HADDR<=32'h1BFF))
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8} <= 8'b0000_0010;
		
	else if((HADDR >= 32'h1CFF) && (HADDR<=32'h1FFF))
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8} <= 8'b0000_0001;
*/
	else 
		{PSEL_1, PSEL_2, PSEL_3, PSEL_4, PSEL_5, PSEL_6, PSEL_7, PSEL_8, PSEL_NOMAP} <= 9'b0000_00000;
end 


endmodule
