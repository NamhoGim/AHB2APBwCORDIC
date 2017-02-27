library verilog;
use verilog.vl_types.all;
entity APB_addr_decoder is
    port(
        HADDR           : in     vl_logic_vector(31 downto 0);
        PSEL_1          : out    vl_logic;
        PSEL_2          : out    vl_logic;
        PSEL_3          : out    vl_logic;
        PSEL_4          : out    vl_logic;
        PSEL_5          : out    vl_logic;
        PSEL_6          : out    vl_logic;
        PSEL_7          : out    vl_logic;
        PSEL_8          : out    vl_logic;
        PSEL_NOMAP      : out    vl_logic
    );
end APB_addr_decoder;
