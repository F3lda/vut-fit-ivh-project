-- top.vhd: IVH projekt LCD
-- Author(s): Karel Jirgl (xjirgl01)
-- Copyright (C) 2022

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

architecture main of tlv_bare_ifc is

	signal cnt : std_logic_vector(23 downto 0) := (others => '0');

	signal mem_cnt          : std_logic_vector(4 downto 0) := "00000";
	signal mem_data         : std_logic_vector(7 downto 0);

	signal lcd_write_en    : std_logic := '1';
	signal lcd_write_done  : std_logic := '0';

begin

	LEDF <= not lcd_write_en;


	-- synchronni citac s asynchronnim nulovanim
	process(RESET, SMCLK)
	begin
		if (RESET = '1') then
			cnt <= (others => '0');
		elsif SMCLK'event and SMCLK = '1' then
			cnt <= cnt + 1;

			if (lcd_write_done = '0') then
				mem_cnt <= mem_cnt + 1;
			else 
				mem_cnt <= "00000";
			end if;
			
			if (mem_cnt = "11111") then
				lcd_write_done <= '1';
			else
				lcd_write_done <= lcd_write_done;
			end if;
			
		end if;
	end process;
	
	
	lcd_write_en <= '1' when (lcd_write_done = '0') else '0';
	
	
	-- Instance pameti ROM ------------------------------------------------
	ROM_OK : entity work.rom_memory32
	generic map(
		INIT        => X"2020565554204649542042726E6F202050726F6A656B74204956482032303232"
	)
	port map(
		ADDR        => mem_cnt,
		DATA_OUT    => mem_data 
	);
	
	
	-- Instance kontroleru LCD -------------------------------------------
	lcdc_u : entity work.lcd_ctrl_high32
	port map(
		CLK         => SMCLK,
		RESET       => RESET,

		-- user interface
		DATA        => mem_data,
		WRITE       => lcd_write_en,
		CLEAR       => '0',

		-- lcd interface
		LRS         => LRS,
		LRW         => LRW,
		LE          => LE,
		LD          => LD
	);

end main;
