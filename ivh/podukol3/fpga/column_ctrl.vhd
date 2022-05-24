-- column_ctrl.vhd: IVH projekt
-- Author(s): Karel Jirgl (xjirgl01)
-- Copyright (C) 2022

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.newspaper_pack.all;



-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity column_ctrl is
	generic (
		N	: integer
	);
	port (
		CLK				: in  std_logic;
		RESET			: in  std_logic;
		
		STATE			: out std_logic_vector(0 to N-1);
		INIT_STATE		: in std_logic_vector(0 to N-1);
		NEIGH_LEFT		: in std_logic_vector(0 to N-1);
		NEIGH_RIGHT		: in std_logic_vector(0 to N-1);
		
		DIRECTION		: in DIRECTION_T;
		EN				: in std_logic
	);
end entity column_ctrl;



-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of column_ctrl is

	

begin

	main : process (clk) is
		variable LAST_INIT_STATE : std_logic_vector(0 to N-1) := (others => '0');
	begin
	
		if RESET = '1' then
			STATE <= INIT_STATE;
		elsif rising_edge(clk) then
			if (LAST_INIT_STATE /= INIT_STATE) then
			
				LAST_INIT_STATE := INIT_STATE;
				
				STATE <= INIT_STATE;
				
			elsif (EN = '1') then
			
				if (DIRECTION = DIR_LEFT) then
					STATE <= NEIGH_RIGHT;
				elsif (DIRECTION = DIR_RIGHT) then
					STATE <= NEIGH_LEFT;
				end if;
			
			end if;
		end if;
	
	end process;
	
	
	-- TODO
	
	--signal cnt_rot : std_logic_vector(23 downto 0) := (others => '0'); -- 1s - 20MHz / 20M ~ 24b
			--R <= GETCOLUMN(ROM_DATA, conv_integer(A), N_ROWS);
			--R(0) <= LED_ROM_DATA(0)(conv_integer(A));
			--R(1) <= LED_ROM_DATA(1)(conv_integer(A));
			--R(2) <= LED_ROM_DATA(2)(conv_integer(A));
			--R(3) <= LED_ROM_DATA(3)(conv_integer(A));
			--R(4) <= LED_ROM_DATA(4)(conv_integer(A));
			--R(5) <= LED_ROM_DATA(5)(conv_integer(A));
			--R(6) <= LED_ROM_DATA(6)(conv_integer(A));
			--R(7) <= LED_ROM_DATA(7)(conv_integer(A));
			
			--cnt_rot <= cnt_rot + 1;
			--if (conv_integer(cnt_rot) = 0) then
			--	for i in 0 to 7 loop
				
					-- right-to-left rotation
					--LED_ROM_DATA(i) <= LED_ROM_DATA(i)(0) & LED_ROM_DATA(i)(15 downto 1);
					
					-- left-to-right rotation
					--LED_ROM_DATA(i) <= LED_ROM_DATA(i)(14 downto 0) & LED_ROM_DATA(i)(15);
					
					-- top-to-down rotation
					--if (i /= 7) then
					--	LED_ROM_DATA(i+1) <= LED_ROM_DATA(i);
					--else
					--	LED_ROM_DATA(0) <= LED_ROM_DATA(7);
					--end if;
					
					-- down-to-top rotation
					--if (i /= 7) then
					--	LED_ROM_DATA(i) <= LED_ROM_DATA(i+1);
					--else
					--	LED_ROM_DATA(7) <= LED_ROM_DATA(0);
					--end if;
					
			--	end loop;
			--end if;
	
	
end architecture behavioral;
