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
//		FILE NAME       	: APB.v
//
// 		AUTHOR 		        : Nam-ho Kim
//
//		AUTHOR'S EMAIL		: kkjknh2@gmail.com
//
//      Checked In          : 2015-05-19 10:47:36 (Tue, 19 May 2015)
//
//      Revision            : 2
//
//      
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// APB description
//--------------------------------------------------------------------------------------
module APB  #(parameter slvnum = 1) (

	// input wire
	input wire           	     PCLK,
	input wire [slvnum-1 : 0]    PSEL,
	input wire		     PENABLE,
	input wire	[31:0]	     PADDR,
	input wire 	             PRESETn,
	input wire	             PWRITE,
	input wire	[31:0]       PWDATA,

	//output wire 
	output wire	[31:0]       PRDATA,
	output wire 		     PREADY
);
reg [31:0] PrdataReg;
reg	   PreadyReg;

wire [31:0] PRDATA_1;
wire [31:0] PRDATA_2;
wire [31:0] PRDATA_3;
wire [31:0] PRDATA_4;
wire [31:0] PRDATA_5;
wire [31:0] PRDATA_6;
wire [31:0] PRDATA_7;
wire [31:0] PRDATA_8;

wire PREADY_1;
wire PREADY_2;
wire PREADY_3;
wire PREADY_4;
wire PREADY_5;
wire PREADY_6;
wire PREADY_7;
wire PREADY_8;

assign PRDATA = PrdataReg;
assign PREADY = PreadyReg;

always @ *
begin
  case(PSEL)
    	8'b0000_0001 : PrdataReg <= PRDATA_1;
    	8'b0000_0010 : PrdataReg <= PRDATA_2;
   	8'b0000_0100 : PrdataReg <= PRDATA_3;
	8'b0000_1000 : PrdataReg <= PRDATA_4;
	8'b0001_0000 : PrdataReg <= PRDATA_5;
	8'b0010_0000 : PrdataReg <= PRDATA_6;
	8'b0100_0000 : PrdataReg <= PRDATA_7;
	8'b1000_0000 : PrdataReg <= PRDATA_8;
default : PrdataReg <= 'bz;
  endcase
end

always @ *
begin
  case(PSEL)
    	8'b0000_0001 : PreadyReg <= PREADY_1;
    	8'b0000_0010 : PreadyReg <= PREADY_2;
   	8'b0000_0100 : PreadyReg <= PREADY_3;
	8'b0000_1000 : PreadyReg <= PREADY_4;
	8'b0001_0000 : PreadyReg <= PREADY_5;
	8'b0010_0000 : PreadyReg <= PREADY_6;
	8'b0100_0000 : PreadyReg <= PREADY_7;
	8'b1000_0000 : PreadyReg <= PREADY_8;
default : PrdataReg <= 'bz;
  endcase
end

apb_interface U_apb_cordic_slave_0(
 			 //APB Inputs
  	 	    	.PCLK(PCLK),
  	    		.PRESETn(PRESETn),
  	    		.PWRITE(PWRITE),
  			.PWDATA(PWDATA),
  	    		.PENABLE(PENABLE),
 			.PADDR(PADDR),
   	    		.PSEL(PSEL[0]),
  
  			//APB Outputs
   	    		.PREADY(PREADY_1),
   			.PRDATA(PRDATA_1)
);
/*
apb_sram	#(.daw(8), .dmw(8)) U_apb_sram_0 (
	                                           .PSEL 		(PSEL[0]),
	                                           .PENABLE		(PENABLE),
                                            	   .PADDR	 	(PADDR[7:0]),
	                                           .PWRITE		(PWRITE),
	                                           .PRESETn		(PRESETn),
						   .PCLK		(PCLK),
	                                           .PWDATA		(PWDATA[7:0]),
	                                           .PRDATA		(PRDATA_1[7:0]),
						   .PREADY		(PREADY_1)
);

apb_sram	#(.daw(8), .dmw(8)) U_apb_sram_1 (
	                                           .PSEL 		(PSEL[1]),
	                                           .PENABLE		(PENABLE),
                                            	   .PADDR		(PADDR[7:0]),
	                                           .PWRITE		(PWRITE),
	                                           .PRESETn	        (PRESETn),
	                                           .PCLK		(PCLK),
	                                           .PWDATA		(PWDATA[7:0]),
	                                           .PRDATA		(PRDATA_2[7:0]),
						   .PREADY		(PREADY_2)
);

apb_sram	#(.daw(8), .dmw(8)) U_apb_sram_2 (
	                                           .PSEL 		 (PSEL[2]),
	                                           .PENABLE		 (PENABLE),
                                            	   .PADDR	 	 (PADDR[7:0]),
	                                           .PWRITE		 (PWRITE),
	                                           .PRESETn		 (PRESETn),
	                                           .PCLK		 (PCLK),
	                                           .PWDATA		 (PWDATA[7:0]),
	                                           .PRDATA		 (PRDATA_3[7:0]),
					           .PREADY	         (PREADY_3)
);

apb_sram	#(.daw(8), .dmw(8)) U_apb_sram_3 (
	                                           .PSEL 		 (PSEL[3]),
	                                           .PENABLE	         (PENABLE),
                                            	   .PADDR		 (PADDR[7:0]),
	                                           .PWRITE		 (PWRITE),
	                                           .PRESETn		 (PRESETn),
	                                           .PCLK		 (PCLK),
	                                           .PWDATA		 (PWDATA[7:0]),
	                                           .PRDATA		 (PRDATA_4[7:0]),
						   .PREADY		 (PREADY_4)
);

apb_sram	#(.daw(8), .dmw(8)) U_apb_sram_4 (
	                                           .PSEL 		 (PSEL[4]),
	                                           .PENABLE		 (PENABLE),
                                            	   .PADDR	 	 (PADDR[7:0]),
	                                           .PWRITE		 (PWRITE),
	                                           .PRESETn		 (PRESETn),
	                                           .PCLK		 (PCLK),
	                                           .PWDATA		 (PWDATA[7:0]),
	                                           .PRDATA		 (PRDATA_5[7:0]),
						   .PREADY		 (PREADY_5)
);

apb_sram	#(.daw(8), .dmw(8)) U_apb_sram_5 (
	                                           .PSEL 		 (PSEL[5]),
	                                           .PENABLE	         (PENABLE),
                                            	   .PADDR	 	 (PADDR[7:0]),
	                                           .PWRITE		 (PWRITE),
	                                           .PRESETn		 (PRESETn),
	                                           .PCLK		 (PCLK),
	                                           .PWDATA		 (PWDATA[7:0]),
	                                           .PRDATA		 (PRDATA_6[7:0]),
						   .PREADY		 (PREADY_6)
);

apb_sram	#(.daw(8), .dmw(8)) U_apb_sram_6 (
	                                           .PSEL 		 (PSEL[6]),
	                                           .PENABLE	  	 (PENABLE),
                                            	   .PADDR	 	 (PADDR[7:0]),
	                                           .PWRITE		 (PWRITE),
	                                           .PRESETn		 (PRESETn),
	                                           .PCLK		 (PCLK),
	                                           .PWDATA		 (PWDATA[7:0]),
	                                           .PRDATA		 (PRDATA_7[7:0]),
						   .PREADY		 (PREADY_7)
);

apb_sram	#(.daw(8), .dmw(8)) U_apb_sram_7 (
	                                           .PSEL 		 (PSEL[7]),
	                                           .PENABLE	      	 (PENABLE),
                                                   .PADDR		 (PADDR[7:0]),
	                                           .PWRITE		 (PWRITE),
	                                           .PRESETn		 (PRESETn),
	                                           .PCLK		 (PCLK),
	                                           .PWDATA		 (PWDATA[7:0]),
	                                           .PRDATA		 (PRDATA_8[7:0]),
						   .PREADY		 (PREADY_8)
);
*/

endmodule
