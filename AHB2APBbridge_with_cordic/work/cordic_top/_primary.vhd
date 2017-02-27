library verilog;
use verilog.vl_types.all;
entity cordic_top is
    port(
        iCLK            : in     vl_logic;
        nRST            : in     vl_logic;
        START           : in     vl_logic;
        ix_0            : in     vl_logic_vector;
        iy_0            : in     vl_logic_vector;
        OP_DONE         : out    vl_logic;
        PREADY          : out    vl_logic;
        oangle          : out    vl_logic_vector
    );
end cordic_top;
