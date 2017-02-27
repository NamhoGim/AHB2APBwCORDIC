library verilog;
use verilog.vl_types.all;
entity APB is
    generic(
        slvnum          : integer := 1
    );
    port(
        PCLK            : in     vl_logic;
        PSEL            : in     vl_logic_vector;
        PENABLE         : in     vl_logic;
        PADDR           : in     vl_logic_vector(31 downto 0);
        PRESETn         : in     vl_logic;
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        PREADY          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of slvnum : constant is 1;
end APB;
