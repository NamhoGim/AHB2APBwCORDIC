library verilog;
use verilog.vl_types.all;
entity AHB2APB is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HWRITE          : in     vl_logic;
        HSELAPBif       : in     vl_logic;
        HREADYin        : in     vl_logic;
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HADDR           : in     vl_logic_vector(31 downto 0);
        PRDATA          : in     vl_logic_vector(31 downto 0);
        PREADY          : in     vl_logic;
        HREADYout       : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0);
        HRDATA          : out    vl_logic_vector(31 downto 0);
        PENABLE         : out    vl_logic;
        PWRITE          : out    vl_logic;
        PWDATA          : out    vl_logic_vector(31 downto 0);
        PADDR           : out    vl_logic_vector(31 downto 0);
        PSEL            : out    vl_logic_vector(7 downto 0)
    );
end AHB2APB;
