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
//		FILE NAME       	: cordic_top_2.v
//
// 		AUTHOR      	    : Nam-ho Kim
//
//		AUTHOR'S EMAIL		: kkjknh2@gmail.com
//
//      Checked In          : 2015-05-07 11:23:25 (Thur, 07 May 2015)
//
//      Revision            : 3
//
//      
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// Cordic HardWare discription
//--------------------------------------------------------------------------------------
module cordic_top(
input wire 					iCLK,
input wire					nRST,
input wire					START,
input wire signed		 [11:-19] 	ix_0,
input wire signed		 [11:-19]	iy_0,

output reg					OP_DONE,
output reg					PREADY,					
output reg signed 		 [7 : -19] 	oangle
);

//localparam [7:-19] one_rad = { 8'd57 , 19'b0100_1011_1011_1001_000};//31'b11_1001_0100_1011_1011_1001_000;//d57.295791 rad -> degree
localparam signed [7:-19] PI = {8'd3, 19'b0010_0100_0011_1111_011};          //d3.141592;
localparam [1:0] IDLE = 2'd0;
localparam [1:0] BUSY = 2'd1;
localparam [1:0] DONE = 2'd2;

//reg signed [11:-19] value;  // 12 + 19 = 31 bits
reg signed [11:-19] x_i;  // 12 + 19 = 31 bits
reg signed [11:-19] y_i;  // 12 + 19 = 31 bits
reg signed [11:-19] rx_i;
reg signed [11:-19] ry_i;
reg signed [2:-19] atan;   // 3 + 19 = 22 bits
reg signed [2:-19] rad;// 3 + 19 = 22 bits
reg signed [2:-19] r_rad;// 3 + 19 = 22 bits
//reg signed [2:-19] r_rad_2;// 3 + 19 = 22 bits

reg cntrl; 
reg [4:0] i;
reg [1:0] CS;
reg CSN;
reg WEN;
wire d;
assign d = y_i[11];     //if sign bit is 1 assert d  

always@(posedge iCLK or negedge nRST)
begin
	if(~nRST)
		CS <= 2'd0;
	
	else if((CS == IDLE) && START)
		CS <= BUSY;
	
	else if((CS == IDLE) && ~START)
		CS <= IDLE;
	
	else if((CS == BUSY) && (cntrl) && (i == 5'd19))
		CS <= DONE;
	
	else if((CS == BUSY) && (~cntrl) && (i != 5'd19))
		CS <= BUSY;

	else if((CS == DONE) && (cntrl))
		CS <=IDLE;
end 

always@(posedge iCLK or negedge nRST)
begin
	if(~nRST)
		cntrl <= 1'b0;
	
	else if(CS == BUSY)
		cntrl <= cntrl + 1'b1;
	
	else 
		cntrl <= 1'b0;
end

always@(posedge iCLK or negedge nRST)
begin
	if(~nRST)
		i <= 5'd0;
	
	else if((CS == BUSY) && (cntrl))
		i <= i + 1'b1;
end

always@(posedge iCLK or negedge nRST)
begin
	if(~nRST)
		rx_i <= 31'd0;
	
	else if((CS == BUSY) && ~d && (~cntrl))   // if positive
		rx_i <=	x_i + (y_i >>> i);	
		
	else if((CS == BUSY) && d && (~cntrl))    //if negative
		rx_i <=	x_i - (y_i >>> i);
		
	else 
		rx_i <= rx_i;
end 

always@(posedge iCLK or negedge nRST)
begin
	if(~nRST)
		ry_i <= 31'd0;
	
	else if((CS == BUSY) && ~d && (~cntrl)) //positive
		ry_i <=	-(x_i >>> i) + y_i;	
		
	else if((CS == BUSY) && d && (~cntrl)) // negative
		ry_i <= (x_i >>> i) + y_i;
		
	else 
		ry_i <= ry_i;	
end 

// x & y value mux
always@*
begin
	if(~nRST)
	begin
		x_i <= 31'd0;
		y_i <= 31'd0;
	end 
	
	else if(CS == BUSY)
	case(i)
		5'd0 : {x_i, y_i} <= {ix_0, iy_0};  // initial value 
		default : {x_i, y_i} <= {rx_i, ry_i};	//previous value
	endcase 
end 

always@(posedge iCLK or negedge nRST)
begin
	if(~nRST)
		r_rad <=  21'd0;
	
	else if((CS == BUSY) && (~cntrl) && ~d)  
		r_rad <= rad - atan; 
	
	else if((CS == BUSY) && (~cntrl) && d)
		r_rad <= rad + atan; 
end

// radian output 
always@(posedge iCLK or negedge nRST)
begin
	if(~nRST)
		oangle <= 28'd0;
	
	else if((CS == BUSY) && (cntrl) && (i == 5'd19))
		oangle <= - r_rad;
	
	else if(CS == DONE)
		oangle <= oangle;
	
	else 
		oangle <= 28'd0;//28'dX;
end

//MUX radian
always@*
begin
	if(~nRST)
		rad <= 21'd0;
	
	else
	case({i, d})
		{5'd0, 1'b0}	:	rad	<= 22'd0;
		{5'd0, 1'b1}	:	rad	<= - PI;
	default				:	rad <= r_rad; 
	endcase
end


// to write radian 
always@*
begin
	case(cntrl)
		1'b1		: {CSN, WEN}  <= 2'b00;
	default	  		: {CSN, WEN}  <= 2'b11;
	endcase
end


always@*//(posedge iCLK or negedge nRST)
begin
	if(~nRST)
		OP_DONE <= 1'b0;
	
	else if((CS == DONE) && (cntrl == 1'b0))
		OP_DONE <= 1'b1;
	
	else 
		OP_DONE <= 1'b0;
end

always @*
begin
	if(CS == IDLE && ~START)
		PREADY <= 1'b1;

	else if(CS == IDLE && START)
		PREADY <= 1'b0;

	else if(CS == BUSY)
		PREADY <= 1'b0;

	else if(CS == DONE)
		PREADY <= 1'b1;
end

//Look Up Table
always@*
begin
	if(~nRST)
		atan <= 21'd0;
	else 
	case(i)
		5'd0  :  atan [-1 : -19] <= 19'b110_0100_1000_0111_1111;   
		5'd1  :  atan [-1 : -19] <= 19'b11_1011_0101_1000_1101; 
		5'd2  :  atan [-1 : -19] <= 19'b1_1111_0101_1011_0111;
		5'd3  :  atan [-1 : -19] <= 19'b1111_1110_1010_1110;
		5'd4  :  atan [-1 : -19] <= 19'b111_1111_1101_0101;
		5'd5  :  atan [-1 : -19] <= 19'b11_1111_1111_1011;
		5'd6  :  atan [-1 : -19] <= 19'b1_1111_1111_1111;
		5'd7  :  atan [-1 : -19] <= 19'b1_0000_0000_0000;
		5'd8  :  atan [-1 : -19] <= 19'b1000_0000_0000;
		5'd9  :  atan [-1 : -19] <= 19'b100_0000_0000;
		5'd10 :  atan [-1 : -19] <= 19'b10_0000_0000;
		5'd11 :  atan [-1 : -19] <= 19'b1_0000_0000;
		5'd12 :  atan [-1 : -19] <= 19'b1000_0000;
		5'd13 :  atan [-1 : -19] <= 19'b100_0000;
		5'd14 :  atan [-1 : -19] <= 19'b10_0000;
		5'd15 :  atan [-1 : -19] <= 19'b1_0000;
		5'd16 :  atan [-1 : -19] <= 19'b1000;
		5'd17 :  atan [-1 : -19] <= 19'b100;
		5'd18 :  atan [-1 : -19] <= 19'b10;
		5'd19 :  atan [-1 : -19] <= 19'b1;
		default : atan [-1 : -19] <= 19'd0;
	endcase  
end
/*
SRAM #(5, 20, 22)  sram_unit_rad (
				.CLK(~iCLK),
				.CSN(CSN),
				.OEN(1'b1),
				.WEN(WEN),
				.ADDR(i),
				.DIN(r_rad),
				.DOUT()
);
*/
/*
SRAM #(5, 20, 31)  sram_unit_y (
				.CLK(~iCLK),
				.CSN(CSN),
				.OEN(1'b1),
				.WEN(WEN),
				.ADDR(i),
				.DIN(y_i),
				.DOUT()
);
*/
endmodule
