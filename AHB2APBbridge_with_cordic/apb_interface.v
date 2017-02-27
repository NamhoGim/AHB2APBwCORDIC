module apb_interface(
  //APB Inputs
  input wire 	    	PCLK,
  input wire 	    	PRESETn,
  input wire 	    	PWRITE,
  input wire [31:0] 	PWDATA,
  input wire 	    	PENABLE,
  input wire [31:0]	PADDR,
  
  input 	    	PSEL,
  
  //APB Outputs
  output wire	    	PREADY,
  output reg [31:0] 	PRDATA
);

wire	     OP_DONE;
wire [7 :-19] oangle;
reg	      startReg;
reg [11:-19]  ix_0Reg;
reg [11:-19]  iy_0Reg;
//reg [7 :-19]  oangleReg;	

always @(posedge PENABLE or negedge PRESETn)
begin
	if(!PRESETn)
  	begin
		ix_0Reg <= 31'd0;    
    	end
    	else if(PWRITE && PREADY && PSEL && (PADDR == 32'h8C00_0000))
      		ix_0Reg <= PWDATA;

end

always @(posedge PENABLE or negedge PRESETn)
begin
	if(!PRESETn)
  	begin
		iy_0Reg <= 31'd0;    
    	end

    	else if(PWRITE && PREADY && PSEL && (PADDR == 32'h8C00_0001))
      		iy_0Reg <= PWDATA;
end

always @* 
begin
	if(!PRESETn)
		 PRDATA <= 31'd0;    
	
    	else if(~PWRITE && PREADY && OP_DONE && PSEL)
      		 PRDATA <= oangle;
end 

always @(posedge PENABLE or negedge PRESETn)
begin
	if(~PWRITE && PREADY && ~OP_DONE && PSEL && (PADDR == 32'h8C00_0002))
		startReg <=1'b1;
	
	else 
		startReg <= 1'b0;

end 
//always @(posedge PENABLE or negedge PRESETn)
//begin
//	if(!PRESETn)
  //	begin
//		startReg <= 1'b0;    
    //	end
	
//	else if(~PWRITE && PREADY && ~OP_DONE && PSEL && (PADDR == 32'h8C00_0002))
//		startReg <= 1'b1;		

//end 
/*
always @//(posedge PENABLE or negedge PRESETn)
begin
	if(!PRESETn)
		PREADY <= 1'b1;

	else if(PSEL && ~PWRITE && ~OP_DONE)
	      PREADY <= 1'b0;

      	else if(PSEL && PWRITE)
		PREADY <= 1'b1;
	
      	else if(PSEL && OP_DONE)
		PREADY <= 1'b1;
	
	else 
		PREADY <= 1'b1;

	      
end 
*/
cordic_top	U_cordic_ip(
 					.iCLK(PCLK),
					.nRST(PRESETn),
					.START(startReg),
			 	 	.ix_0(ix_0Reg),
			 		.iy_0(iy_0Reg),

					.OP_DONE(OP_DONE),
					.PREADY(PREADY),					
 		 		 	.oangle(oangle)
); 

endmodule
