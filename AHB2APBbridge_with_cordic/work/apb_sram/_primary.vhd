library verilog;
use verilog.vl_types.all;
entity apb_sram is
    generic(
        daw             : integer := 8;
        dmw             : integer := 8
    );
    port(
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PADDR           : in     vl_logic_vector;
        PWRITE          : in     vl_logic;
        PRESETn         : in     vl_logic;
        PCLK            : in     vl_logic;
        PWDATA          : in     vl_logic_vector;
        PRDATA          : out    vl_logic_vector;
        PREADY          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of daw : constant is 1;
    attribute mti_svvh_generic_type of dmw : constant is 1;
end apb_sram;
