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
//		FILE NAME       	: tb_ahb_lite.v
//
// 		AUTHOR 		        : Nam-ho Kim
//
//		AUTHOR'S EMAIL		: kkjknh2@gmail.com
//
//      Checked In          : 2015-05-29 23:30:10 (Fri, 29 May 2015)
//
//      Revision            : 7
//
//      
//--------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------
// AHB_Lite test bench description
//--------------------------------------------------------------------------------------
// this test bench based on AHB_Lite protocol 
`include "ahb_control_signals.vh"

module tb_ahb_lite;
  
//Global signals
reg	 HCLK;
reg	 HRESETn;

//FROM Master signals
reg	[31:0]	HADDR; 	    //Master to Slave and decoder
reg	[2:0]	HBURST;     //Master to Slave
reg	     	HMASTLOCK;  //Master to Slave
reg	[3:0]	HPROT;	    //Master to Slave
reg	[2:0]	HSIZE;	    //Master to slave
reg	[1:0]	HTRANS;     //Master to Slave 
reg	[31:0]	HWDATA;	    //Master to Slave
reg		HWRITE;     //Master to Slave
reg		HSEL_1;
reg       	HSEL_2;

//FROM Slave signals
//HRDATA
wire [31:0] HRDATA;    		 //muxed signal
wire [31:0] HRDATA_1;   	 // to Mux 2, 3 ... n to be more
wire [31:0] HRDATA_2;		 // t0 Mux 2, 3 ... n to be more

//HREADYOUT
wire	HREADYOUT;	   // muxed signal	
//wire	HREADYOUT_1;	   // to Mux 2, 3 ... n to be more
//wire	HREADYOUT_2;
reg	HREADYIN;   	   //from cpu 

//HRESP
wire [1:0]  HRESP;
wire [1:0]  HRESP_1;        // to Mux 2, 3 ... n to be more
wire [1:0]  HRESP_2;	    // to Mux 2, 3 ... n to be more

//APB BUS 
wire        PENABLE;
wire        PREADY;
wire        PWRITE;
wire [31:0] PWDATA;
wire [31:0] PRDATA;
wire [31:0] PADDR;
wire [7:0]  PSEL;
  
localparam PER  = 10;
localparam HPER = PER/2;
localparam DELAY = 1.0;

initial HCLK <= 1'b0;
initial HRESETn <= 1'b1;
initial HREADYIN <=1'b0;
initial HADDR <= 1'b0;
initial HWDATA <= 32'd0;
initial HTRANS <= 2'b00;
initial HSEL_2 <= 1'b0;
initial HSEL_1 <= 1'b0;

always #(HPER)	HCLK <= ~HCLK;

/*
AHB_DECODER U_ahb_decoder (
				//input wire
				.HADDR      	(),
				.HSEL_1	        (),
				.HSEL_2	        (),
				
				//output
				.HSEL_NOMAP	(),
				.MUX_SEL	()	
);
*/


AHB2APB U_ahb2apb_bridge (
			         //Bridge inputs AHB interface
       		                .HCLK       (HCLK),
	                        .HRESETn    (HRESETn),
	                        .HTRANS     (HTRANS),
	                        .HWRITE     (HWRITE),
	                        .HSELAPBif  (HSEL_2),
                          	.HREADYin   (HREADYIN),
				.PREADY	    (PREADY),
	                        .HWDATA     (HWDATA),
	                        .HADDR      (HADDR),
	                        .PRDATA     (PRDATA),    // from slave

	                        //Bridge outputs
	                        .HREADYout  (HREADYOUT),
	                        .HRESP      (HRESP_2),
	                        .HRDATA     (HRDATA),
	                        .PENABLE    (PENABLE),
				.PWRITE     (PWRITE),
				.PWDATA     (PWDATA),
				.PADDR      (PADDR),
				.PSEL       (PSEL)
							            
);

APB #(.slvnum(8)) U_apb (
 	      	     .PCLK       (HCLK),
	       	     .PSEL     	 (PSEL),
	             .PENABLE 	 (PENABLE),
	             .PADDR      (PADDR),
	             .PRESETn    (HRESETn),
	             .PWRITE     (PWRITE),
	             .PWDATA     (PWDATA),
	             .PRDATA     (PRDATA),
		     .PREADY	 (PREADY)
  
);

//for running in cygwin
//Simulation file dump
initial
begin
	$dumpfile("AHB_lite_verifi.vcd");
	$dumpvars();
end


// Simulation Scenario
initial
begin
  @ (posedge HCLK);
  HRESETn <= 1'b0;
  @ (posedge HCLK);
  HRESETn <= 1'b1;
  //ahb_read(32'h0000_0001);
  ahb_write(32'h8C00_0000, 3'd4, {1'b0,  12'd7,	19'b0000_0000_0000_0000_000}); // x value insert
  ahb_write(32'h8C00_0001, 3'd4, {1'b0, 12'd11, 19'b1000_0000_0000_0000_000}); // y value insert
  ahb_read(32'h8C00_0002, 3'd4);
  cmp(31'b1_0000_0110_0010_0101_101);  
 // ahb_write(32'h0000_0002, 3'd4, 32'd123);
 // ahb_read(32'h0000_0002,3'd4);
  $finish;
end   

//ahb_write task 
task ahb_write;
	input [31:0]	address;
	input [2:0]	size;
	input [31:0]	data;
	begin
		//@ (posedge HCLK);
		//HBUSREQ <= #1 1;
		@ (posedge HCLK);
   		//while ((HGRANT!==1'b1) || (HREADY!==1'b1)) @ (posedge HCLK);   //address phase
		while (HREADYOUT!==1'b1) @ (posedge HCLK);
		//HBUSREQ <= #1 1'b0;
		HREADYIN <= #1 1'b1;
		//HSEL_1 <= #1 1'b1;
		HSEL_2 <= #1 1'b1;
		HADDR 	<= #1 address;
		HPROT	<= #1 4'b0001;  //'HPROT_DATA
		HTRANS	<= #1 2'b10;	//'HTRANS_NONSEQ
		HBURST	<= #1 3'b000;	//'HBURST_SINGLE
		HWRITE	<= #1 1'b1;		//'HWRITE_WRITE
		case(size)
		1:	HSIZE <= #1 3'b000; //'HSIZE_BYTE
		2:	HSIZE <= #1 3'b001; //'HSIZE_HWORD
		4:	HSIZE <= #1 3'b010; //'HSIZE_WORD
		default: $display($time,, "ERROR: unsupported transfer size: %d-byte",size);
		endcase
		@ (posedge HCLK);
		while(HREADYOUT!==1) @ (posedge HCLK);		//data phase
		HADDR	<= #1 32'b0;
		HPROT	<= #1 4'b0000;	//'HPROT_OPCODE
		HTRANS	<= #1 2'b0;
		HBURST	<= #1 3'b0;
		HWRITE	<= #1 1'b0;
		HSIZE	<= #1 3'b0;
		HWDATA 	<= #1 data;
		@ (posedge HCLK)
		while (HREADYOUT === 0) @ (posedge HCLK);
	//	HSEL_1 <= #1 1'b0;
		HSEL_2 <= #1 1'b0;
		HREADYIN <= #1 1'b0;
		if (HRESP!=2'b00)  //if(HRESP!='HRESP_OKAY)
			$display($time,, "ERROR: non OK response write");
		HWDATA	<= #1 0;
		@ (posedge HCLK);		
	end 
endtask

task ahb_read;
	input [31:0]	 address;
	input [2:0]	 size;
	begin
		//@ (posedge HCLK);
		//HBUSREQ <= #1 1'b1;
		@ (posedge HCLK);
		//while (HGRANT!==1'b1) @ (posedge HCLK);
		//while ((HGRANT!==1'b1) || (HREADY!==1'b1)) @ (posedge HCLK);   //address phase
		while(HREADYOUT!==1'b1) @ (posedge HCLK);
		//HBUSREQ	<= #1 1'b0;
	//	HSEL_1 <= #1 1'b1;
		HSEL_2 <= #1 1'b1;
		HREADYIN <= #1 1'b1;
		HADDR	<= #1 address;
		HPROT	<= #1 4'b0001;  //'HPROT_DATA
		HTRANS	<= #1 2'b10;	//'HTRANS_NONSEQ
		HBURST	<= #1 3'b000;	//'HBURST_SINGLE
		HWRITE	<= #1 1'b0;		//'HWRITE_READ
		case(size)
		1:	HSIZE <= #1 3'b000; //'HSIZE_BYTE
		2:	HSIZE <= #1 3'b001; //'HSIZE_HWORD
		4:	HSIZE <= #1 3'b010; //'HSIZE_WORD
		default: $display($time,, "ERROR: unsupported transfer size: %d-byte",size);
		endcase
		@ (posedge HCLK);
		while(HREADYOUT!==1) @ (posedge HCLK);		//data phase
		HADDR	<= #1 32'b0;
		HPROT	<= #1 4'b0000;	//'HPROT_OPCODE
		HTRANS	<= #1 2'b0;
		HBURST	<= #1 3'b0;
		HWRITE	<= #1 1'b0;
		HSIZE	<= #1 3'b0;
		@ (posedge HCLK)
		while (HREADYOUT === 0) @ (posedge HCLK);
//		HSEL_1 <= #1 1'b0;
		HSEL_2 <= #1 1'b0;
		HREADYIN <= #1 1'b0;
		if (HRESP!=2'b00)  //if(HRESP!='HRESP_OKAY)
			$display($time,, "ERROR: non OK response write");
		@ (posedge HCLK);
	end 
endtask
task cmp;
   // input [6:0] addr;
    input [30:0] expectedData;

     begin
         if(expectedData != HRDATA)
         begin
             $write("value ERROR Expected 0x%0x, got 0x%0x\n",expectedData, HRDATA);
         end

         else
         begin
             $write("correct value !! 0x%0x\n",HRDATA);
         end
    end

endtask

		  
endmodule
