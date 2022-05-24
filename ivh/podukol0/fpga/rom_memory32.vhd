-- rom_memory.vhd: ROM Memory block
-- Author(s): Tomas Martinek <martinto at fit.vutbr.cz>
-- Edited: 32byte version (xjirgl01)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity rom_memory32 is
generic(
   INIT        : std_logic_vector((32*8)-1 downto 0)
);
port(
   ADDR        : in  std_logic_vector(4 downto 0);
   DATA_OUT    : out std_logic_vector(7 downto 0)
);
end entity rom_memory32;

-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of rom_memory32 is

   type   t_rom is array(0 to 31) of std_logic_vector(7 downto 0);
   signal rom : t_rom := (INIT((32*8)-1 downto 31*8),
                          INIT((31*8)-1 downto 30*8),
                          INIT((30*8)-1 downto 29*8),
                          INIT((29*8)-1 downto 28*8),
                          INIT((28*8)-1 downto 27*8),
                          INIT((27*8)-1 downto 26*8),
                          INIT((26*8)-1 downto 25*8),
                          INIT((25*8)-1 downto 24*8),
                          INIT((24*8)-1 downto 23*8),
                          INIT((23*8)-1 downto 22*8),
                          INIT((22*8)-1 downto 21*8),
                          INIT((21*8)-1 downto 20*8),
                          INIT((20*8)-1 downto 19*8),
                          INIT((19*8)-1 downto 18*8),
                          INIT((18*8)-1 downto 17*8),
                          INIT((17*8)-1 downto 16*8),
                          INIT((16*8)-1 downto 15*8),
                          INIT((15*8)-1 downto 14*8),
                          INIT((14*8)-1 downto 13*8),
                          INIT((13*8)-1 downto 12*8),
                          INIT((12*8)-1 downto 11*8),
                          INIT((11*8)-1 downto 10*8),
                          INIT((10*8)-1 downto 9*8),
                          INIT((9*8)-1 downto 8*8),
                          INIT((8*8)-1 downto 7*8),
                          INIT((7*8)-1 downto 6*8),
                          INIT((6*8)-1 downto 5*8),
                          INIT((5*8)-1 downto 4*8),
                          INIT((4*8)-1 downto 3*8),
                          INIT((3*8)-1 downto 2*8),
                          INIT((2*8)-1 downto 1*8),
                          INIT((1*8)-1 downto 0*8));

begin

     DATA_OUT <= rom(conv_integer(ADDR));

end architecture behavioral;

