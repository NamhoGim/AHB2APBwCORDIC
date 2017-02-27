module SPI_SLAVE(
input wire 		SPI_CLK,
input wire 		SPI_RST,
input wire 		SPI_CS,
input wire 	[2:0]	SID_assign, 		//hard wired
input wire 		SPI_MOSI,
output reg 		SPI_MISO
);

//states
localparam [2:0] IDLE = 3'd0;
localparam [2:0] ADDR = 3'd1;
localparam [2:0] WRITE = 3'd2;
localparam [2:0] READ = 3'd3;
localparam [2:0] EOF = 3'd4;
localparam [2:0] CONF = 3'd5;

reg [3:0] CS;
reg [2:0] SID_r;
reg wr_r;
reg SID_FAIL;
reg [6:0] addr_r;
reg [5:0] ctrl_cnt;
reg [31:0] din_r;
reg [31:0] dout_r;
reg [31:0] slave_register [0:127];

//reg MISO;
wire SID_match;
wire reset_n;
wire [31:0] reg_data_ch;
assign  SID_match = (SID_assign==SID_r);
assign  reset_n = SPI_RST & (!SPI_CS);  
assign	reg_data_ch = slave_register [addr_r];
//bit wise AND : &
//1-bit true false : &&
//! 1-bit , ~ bit wise inverting

//state transition                               
always@(negedge SPI_CLK or negedge reset_n)
begin
		if(!reset_n)
			CS <= IDLE;

		else if((CS == IDLE) && SID_match && (ctrl_cnt == 6'd3) && !SID_FAIL)  //IDLE_END
			CS <= ADDR;

		else if((CS == IDLE) && !SID_match && (ctrl_cnt == 6'd3) && !SID_FAIL) //SID not match
			CS <= IDLE;

		else if((CS == ADDR) && (ctrl_cnt == 6'd6) && (wr_r) && !SID_FAIL) //ADDR_END 
			CS <= WRITE;

		else if((CS == ADDR) && (ctrl_cnt == 6'd6) && (!wr_r) && !SID_FAIL) // READ_START
			CS <= READ;

		else if((CS == WRITE) && (ctrl_cnt == 6'd31) && !SID_FAIL) //WRITE_END
			CS <= EOF;

		else if((CS == READ) && (ctrl_cnt == 6'd31) && !SID_FAIL) // RETRUN to EOF
			CS <= EOF;

		else if(CS == EOF) // CONFIRM for one cycle 
			CS <= CONF;

		else if(CS == CONF) //RETURN TO IDLE
			CS <= IDLE;

		else 
			CS <= CS;
end

//control counter 
always@(negedge SPI_CLK or negedge reset_n)
begin
	if(!reset_n)
		ctrl_cnt <= 6'd0;

	else if((CS == IDLE) && SID_match && (ctrl_cnt == 6'd3))
		ctrl_cnt <= 6'd0;

	else if((CS == IDLE) && !SID_match && (ctrl_cnt == 6'd3))
		ctrl_cnt <= 6'd0;

	else if((CS == ADDR) && (ctrl_cnt == 6'd6) && (wr_r))
		ctrl_cnt <= 6'd0;

	else if((CS == ADDR) && (ctrl_cnt == 6'd6) && (!wr_r))
		ctrl_cnt <= 6'd0;

	else if((CS == WRITE) && (ctrl_cnt == 6'd31)) 
		ctrl_cnt <= 6'd0;

	else if((CS == READ) && (ctrl_cnt == 6'd32))
		ctrl_cnt <= 6'd0;

	else if(CS == EOF) 
		ctrl_cnt <= 6'd0;
	
	else if(CS == CONF)
		ctrl_cnt <= 6'd0;

	else if(SID_FAIL)
		ctrl_cnt <= 6'd0;

	else 
		ctrl_cnt <= ctrl_cnt + 6'd1;
end

//MOSI -> SID_r
always@(negedge SPI_CLK or negedge reset_n)
begin
		if(!reset_n)
			SID_r <= 3'b0;

		else if(CS == IDLE)
			SID_r[2-ctrl_cnt] <= SPI_MOSI;

		else if((CS == IDLE) && !SID_match && (ctrl_cnt == 6'd3)) //SID not match
			SID_r <= 3'd0;

end

//IF SID DID NOT MATCHED ASSERTING FAIL FLAG SIGNAL
always@(negedge SPI_CLK or negedge reset_n)
begin
	if(!reset_n)
		SID_FAIL <= 1'b0;

	else if((CS == IDLE) && !SID_match && (ctrl_cnt == 3'd3))
		SID_FAIL <= 1'b1;
end

//MOSI -> wr_r
always@(negedge SPI_CLK or negedge reset_n)
begin
		if(!reset_n)
			wr_r <= 1'b0;

		else if((CS == IDLE) && (ctrl_cnt == 6'd3))
			wr_r <= SPI_MOSI;

end

//MOSI -> addr_r 
always@(negedge SPI_CLK or negedge reset_n)
begin
		if(!reset_n)
			addr_r <= 7'd0;
					
		else if(CS == ADDR)
			addr_r[6-ctrl_cnt] <= SPI_MOSI;
 
end

//MOSI -> din_r
always@(negedge SPI_CLK or negedge reset_n)
begin
		if(!reset_n)
			din_r <= 32'd0;

		else if(CS == WRITE)
			din_r[31-ctrl_cnt] <= SPI_MOSI;
end

//dout_r
always@(negedge SPI_CLK or negedge reset_n)
begin
	if(!reset_n)
		dout_r <= 32'b0;

	else if((CS == ADDR) && (ctrl_cnt == 6'd6) && (!wr_r))
		dout_r <= slave_register [addr_r];
end

//at read state 
always@(posedge SPI_CLK or negedge reset_n)
begin
	if(!reset_n)
		SPI_MISO <= 1'b0;

	else if((CS == READ))
	begin
		dout_r <= dout_r << 1'b1;
		SPI_MISO <= dout_r[31]; 
	end
end 
// at EOF (End Of signal) state
always@(negedge SPI_CLK)
begin
	if(!SPI_CS && (CS == EOF) && wr_r)

		slave_register [addr_r] <= din_r ;
	
end



endmodule 



