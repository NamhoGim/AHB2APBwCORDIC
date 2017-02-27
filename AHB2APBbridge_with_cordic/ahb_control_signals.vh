//Control signals
//_AHB_control_signals_.vh

`ifndef _ahb_control_signals_
`define _ahb_control_signals_

//define parameters

//HTRANS
`define IDLE    0
`define BUSY    1
`define NONSEQ  2
`define SEQ     3

//HRESP
`define OKAY    0
`define ERROR  	1
`define RETRY   2
`define SPLIT   3

//HSIZE
`define Byte            0
`define Halfword        1
`define Word           	2

//HBURST
`define SINGLE  3'b000
`define INCR    3'b001
`define WRAP4   3'b010
`define INCR4   3'b011
`define WRAP8   3'b100
`define INCR8   3'b101
`define WRAP16  3'b110
`define INCR16 	3'b111

//HPROT
`define Opcode_fetch            4'bxxx0
`define Data_access     	    4'bxxx1
`define User_access             4'bxx0x
`define Privileged_access       4'bxx1x
`define Not_bufferable          4'bx0xx
`define Bufferable              4'bx1xx
`define Not_cacheable           4'b0xxx
`define Cacheable               4'b1xxx

    
`else 

`endif


