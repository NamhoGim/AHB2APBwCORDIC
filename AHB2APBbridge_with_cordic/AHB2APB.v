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
//		FILE NAME       	: AHB2APB.v
//
// 		AUTHOR 		        : Nam-ho Kim
//
//		AUTHOR'S EMAIL		: kkjknh2@gmail.com
//
//      Checked In          : 2015-05-19 10:47:36 (Tue, 21 May 2015)
//
//      Revision            : 4 
//
//      
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// AHB2APB description single transfer
//--------------------------------------------------------------------------------------
`include "ahb_control_signals.vh"

module AHB2APB
(	//Bridge inputs AHB interface
	input wire				HCLK,
	input wire				HRESETn,
	input wire	[1:0]			HTRANS,
	input wire				HWRITE,
	input wire				HSELAPBif,
	input wire				HREADYin,	// form cpu
	input wire	[31:0]			HWDATA,
	input wire	[31:0]			HADDR,
	input wire	[31:0]			PRDATA,
	input wire				PREADY,
	//Bridge outputs
	output wire				HREADYout,  
	output wire	[1:0]			HRESP,
	output wire	[31:0]			HRDATA,
	output wire				PENABLE,
	output wire				PWRITE,
	output wire	[31:0]			PWDATA,
	output wire	[31:0]			PADDR,
	output wire	[7:0]			PSEL
);
//state parameter
localparam [2:0] ST_IDLE	   = 3'd0;
localparam [2:0] ST_READ	   = 3'd1; //wait state is needed
localparam [2:0] ST_WWAIT	   = 3'd2; // 
localparam [2:0] ST_WRITE	   = 3'd3;
localparam [2:0] ST_WRITEP	   = 3'd4;
localparam [2:0] ST_RENABLE	   = 3'd5; 
localparam [2:0] ST_WENABLE	   = 3'd6;
localparam [2:0] ST_WENABLEP   = 3'd7;

//HRESP parameter
//localparam [1:0] OKAY	 = 2'b00;
//localparam [1:0] ERROR	 = 2'b01;
//localparam [1:0] RETRY	 = 2'b10;
//localparam [1:0] SPLIT	 = 2'b11;

//HTRANS
//localparam [1:0] IDLE	 = 2'b00;
//localparam [1:0] BUSY	 = 2'b01;
//localparam [1:0] NONSEQ	 = 2'b10;
//localparam [1:0] SEQ	 = 2'b11;

reg	[2:0]	CS;
reg    		HwriteReg;
reg    		PwriteReg;
reg	[7:0]	PselReg;
reg    		PenableReg;
reg	[31:0]	HaddrReg;
reg 	[31:0]	HdataReg;
reg	[31:0]	PaddrReg;
reg 	[31:0] 	PdataReg;
reg 	[31:0]	HwirtedataReg;
reg     	HreadyReg;
wire   	        Valid;
wire	[7:0]	wsel;

assign Valid = HSELAPBif && HREADYin && HTRANS[1]; //further valid transfer
assign Regen = HSELAPBif && HREADYin;			   // pending transfer	
//assign HWRITE =	HwriteReg;
assign PWRITE		= PwriteReg; 
assign HRDATA		= PRDATA;
assign PENABLE	        = PenableReg;
assign PADDR	        = PaddrReg;
assign PWDATA	        = HwirtedataReg;
assign HREADYout	= HreadyReg;
assign PSEL	       	= PselReg;
assign HRESP	        = 2'b00;

//state machine 
always @ (posedge HCLK or negedge HRESETn)
begin
	if(~HRESETn)
		CS <= ST_IDLE;
	
	else if(CS == ST_IDLE)
	begin
	 	if(~Valid)
			CS <= ST_IDLE;

		else if((Valid) && (~HWRITE))
			CS <= ST_READ;
		
		else if((Valid) && (HWRITE))
			CS <= ST_WWAIT;
	end

	else if(CS == ST_READ)
  		  CS <= ST_RENABLE;
		
	else if(CS == ST_RENABLE)
	begin
		if(~Valid && PREADY)
			CS <= ST_IDLE;

		else if((Valid) && (~HWRITE))
			CS <= ST_READ;

		else if((Valid) && (HWRITE))
			CS <= ST_WWAIT;

		else if(~PREADY)
			CS <= ST_RENABLE;
	end 
	
	else if(CS == ST_WWAIT)
	begin
		if(Valid)
			CS <= ST_WRITEP;

		else if(~Valid)
			CS <= ST_WRITE;		
	end 

	else if(CS == ST_WRITEP)
		CS <= ST_WENABLEP;
	
	else if(CS == ST_WRITE)
	begin
		if(Valid)
			CS <= ST_WENABLEP;
	
		else if(~Valid)
			CS <= ST_WENABLE;
	end 
	
	else if(CS == ST_WENABLEP) 
	begin
		if((~Valid) && (HwriteReg))
			CS <= ST_WRITE;
	
		else if((Valid) && (HwriteReg))
			CS <= ST_WRITEP;
	 	
		else if(~HwriteReg)
			CS <= ST_READ;
			
		else if(~PREADY)
			CS <= ST_WENABLEP;
	end 

	else if(CS == ST_WENABLE)
	begin
		if(~Valid)
			CS <= ST_IDLE;

		else if((Valid) && (~HWRITE))
			CS <= ST_READ;
	
		else if((Valid) && (HWRITE))
			CS <= ST_WWAIT;
		
		else if(~PREADY)
		
			CS <= ST_WENABLE;
	end 
end 

// Sampling Haddr latest pending haddr
always @(posedge HCLK or negedge HRESETn)
begin
	if(~HRESETn)
		HaddrReg <= 32'b0;
	
	else if(Regen) //(CS == ST_IDLE)
		HaddrReg <= HADDR;
end

// Sampling HWRITE latest pending hwrite  
always @(posedge HCLK or negedge HRESETn)
begin
	if(~HRESETn)
		HwriteReg <= 1'b0;

	else if(Regen) //(CS == ST_IDLE)
		HwriteReg <= HWRITE;
end 
//*****************************************************************
// Sampling HWDATA , needed only for write     not done yet!!
always @ (posedge HCLK or negedge HRESETn)
begin
	if(~HRESETn)
		HwirtedataReg <= 32'd0;
	  
	else if(HwriteReg || HWRITE)//CS == ST_WWAIT)
		HwirtedataReg <= HWDATA;
end 
//*****************************************************************
always @ (posedge HCLK or negedge HRESETn)
begin
	if(~HRESETn)
		PaddrReg <= 32'd0;
	
	else if( (CS == ST_READ) || (CS == ST_WWAIT))// || (CS == ST_WRITE) || (CS == ST_WRITEP))	
		PaddrReg <= HaddrReg;	
end

//HREADYout
always @*
begin
	if(CS == ST_IDLE)
		HreadyReg <= 1'b1;
	
	else if(CS == ST_READ)
		HreadyReg <= 1'b0;
	
	else if(CS == ST_WWAIT)
		HreadyReg <= 1'b1;   // otherwise change 1
		
	else if((CS == ST_RENABLE) || (CS == ST_WENABLE) || (CS == ST_WENABLEP)) // ENABLE state
		HreadyReg <= PREADY;  // 1'b1;
		
	else if(CS == ST_WRITE)
		HreadyReg <= 1'b0;
		
	else if(CS == ST_WRITEP)
		HreadyReg <= 1'b0;
	
//	else
//		HreadyReg <= 1'b1;
end 

// PWRITE
always @*
begin
	if(CS == ST_IDLE)
		PwriteReg <= PwriteReg;
	
	else if((CS == ST_READ) || (CS == ST_RENABLE))
		PwriteReg <=  1'b0;//HwriteReg;
	
	else if((CS == ST_WRITE) || (CS == ST_WRITEP) || (CS == ST_WENABLE) || (CS == ST_WENABLEP))
		PwriteReg <=  1'b1;//HwriteReg;
end

//PSEL
always @*
begin
	if(CS == ST_IDLE)
		PselReg <= wsel;

	//selected by memory map	
	else if((CS == ST_READ) || (CS == ST_RENABLE))
		PselReg <= wsel;	
		
	//selected by memory map
	else if((CS == ST_WRITE) || (CS == ST_WRITEP) || (CS == ST_WENABLEP) || (CS == ST_WENABLE))
		PselReg <= wsel;
	
	else 
		PselReg <= 8'b0;
end 

//PENABLE
always @*
begin
	if((CS == ST_RENABLE) || (CS == ST_WENABLEP) || (CS == ST_WENABLE)) 
		PenableReg <= 1'b1;
	else 
		PenableReg <= 1'b0;
end 

//PADDR ****************************************************!?
/*
always @*
begin
	if((CS == ST_READ) || (CS == ST_WRITEP) || (CS == ST_WRITE))
		PaddrReg <= HaddrReg;			//HaddrReg;
		
	else
		PaddrReg <= HaddrReg;
end 
*/
APB_addr_decoder  U_apb_addr_decoder 
(
	.HADDR(PaddrReg),
	.PSEL_1(wsel[0]),
	.PSEL_2(wsel[1]),
	.PSEL_3(wsel[2]),
	.PSEL_4(wsel[3]),
	.PSEL_5(wsel[4]),
	.PSEL_6(wsel[5]),
	.PSEL_7(wsel[6]),
	.PSEL_8(wsel[7])
);

endmodule
