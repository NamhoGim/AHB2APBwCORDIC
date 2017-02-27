library verilog;
use verilog.vl_types.all;
entity apb_interface is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PENABLE         : in     vl_logic;
        PADDR           : in     vl_logic_vector(31 downto 0);
        PSEL            : in     vl_logic;
        PREADY          : out    vl_logic;
        PRDATA          : out    vl_logic_vector(31 downto 0)
    );
end apb_interface;
