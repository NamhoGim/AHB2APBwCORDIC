library verilog;
use verilog.vl_types.all;
entity SRAM is
    generic(
        daw             : integer := 12;
        dmw             : integer := 8
    );
    port(
        CLK             : in     vl_logic;
        CSN             : in     vl_logic;
        ADDR            : in     vl_logic_vector;
        WEN             : in     vl_logic;
        DI              : in     vl_logic_vector;
        DOUT            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of daw : constant is 1;
    attribute mti_svvh_generic_type of dmw : constant is 1;
end SRAM;
