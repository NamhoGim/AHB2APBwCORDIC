library verilog;
use verilog.vl_types.all;
entity SPI_SLAVE is
    port(
        SPI_CLK         : in     vl_logic;
        SPI_RST         : in     vl_logic;
        SPI_CS          : in     vl_logic;
        SID_assign      : in     vl_logic_vector(2 downto 0);
        SPI_MOSI        : in     vl_logic;
        SPI_MISO        : out    vl_logic
    );
end SPI_SLAVE;
