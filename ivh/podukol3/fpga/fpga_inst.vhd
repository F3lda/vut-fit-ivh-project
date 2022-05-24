-- fpga_inst.vhd: IVH projekt
-- Author(s): Karel Jirgl (xjirgl01)
-- Copyright (C) 2022

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.newspaper_pack.all;

architecture Behavioral of tlv_gp_ifc is

	signal A : std_logic_vector(3 downto 0) := "0011"; -- id sloupce
	signal R : std_logic_vector(0 to 7) := "01011100"; -- data sloupce
	
	-- display on all columns
	signal cnt_led : std_logic_vector(log2(20000000)-1 downto 0) := (others => '0'); -- clock speed = 20 MHz
	constant cnt_led_refresh_rate : integer := 20833; -- led display refresh rate
	-- No flicker is visible at a refresh rate greater than 50Hz:
	-- 20 MHz CLK = 20 000 000 Hz -> 20 000 000 Hz / 50 Hz = 400 000 Hz -> 400 000 Hz / 16 rows = 25 000 Hz refresh rate
	-- 20 MHz CLK = 20 000 000 Hz -> 20 000 000 Hz / 60 Hz = 333 333 Hz -> 333 333 Hz / 16 rows = 20 833 Hz refresh rate
	
	signal cnt : std_logic_vector(23+6 downto 0) := (others => '0'); -- 1s - 20MHz / 20M ~ 24b (24 + 6 [= 64 pozic])
	
	
	
	signal ROT_DIRECTION : DIRECTION_T := DIR_LEFT;
	signal ROT_EN : std_logic := '0';
	
	signal ROM_DATA : COLUMN_ARRAY_T := (others => (others => '0'));
	signal COLUMN_STATE : COLUMN_ARRAY_T := (others => (others => '0'));
	
	signal CURRENT_STATE : std_logic_vector(log2(N_STATES)-1 downto 0) := "11";

begin

	-- Instance pameti ROM ------------------------------------------------
	ROM_MEM : entity work.rom_memory
	generic map(
		DATA_BLOCKS	=> 
			"0000000000000000"&
			"0000010000100000"&
			"0000010000100000"&
			"0000010000100000"&
			"0001000000001000"&
			"0000100000010000"&
			"0000011111100000"&
			"0000000000000000"&
			
			"0000000110000000"&
			"0000001001010000"&
			"0000010000110000"&
			"0000100000010000"&
			"0001111111111000"&
			"0011000000001100"&
			"0001000110001000"&
			"0001111111111000"&
			
			"0000000000111110"&
			"0000000000100010"&
			"0000011100111110"&
			"0000010100100000"&
			"0100010100100010"&
			"0011111111111100"&
			"0001000000001000"&
			"0000111111110000"&
			
			"0000000000000000"&
			"0111100100111110"&
			"0100000100001000"&
			"0100000100001000"&
			"0111100100001000"&
			"0100000100001000"&
			"0100000100001000"&
			"0000000000000000"
	)
	port map(
		BLOCK_ADDR	=> CURRENT_STATE,
		DATA_OUT    => ROM_DATA
	);
	
	
	
	-- Generovani SLOUPCU ------------------------------------------------
	GEN_COLUMN_ARRAY: for i in 0 to N_COLUMNS-1 generate
	
		GEN_COLUMN_ARRAY_IF_1: if (i = 0) generate

			COLUMN_CONTROLLER : entity work.column_ctrl
			generic map(
				N	=> N_ROWS
			)
			port map(
				CLK				=> clk,
				RESET			=> reset,
				
				STATE			=> COLUMN_STATE(i),
				INIT_STATE		=> ROM_DATA(i),
				NEIGH_LEFT		=> COLUMN_STATE(N_COLUMNS-1),
				NEIGH_RIGHT		=> COLUMN_STATE(i+1),
				
				DIRECTION		=> ROT_DIRECTION,
				EN				=> ROT_EN
			);
		
		end generate GEN_COLUMN_ARRAY_IF_1;

		GEN_COLUMN_ARRAY_IF_2: if (i = N_COLUMNS-1) generate

			COLUMN_CONTROLLER : entity work.column_ctrl
			generic map(
				N	=> N_ROWS
			)
			port map(
				CLK				=> clk,
				RESET			=> reset,
				
				STATE			=> COLUMN_STATE(i),
				INIT_STATE		=> ROM_DATA(i),
				NEIGH_LEFT		=> COLUMN_STATE(i-1),
				NEIGH_RIGHT		=> COLUMN_STATE(0),
				
				DIRECTION		=> ROT_DIRECTION,
				EN				=> ROT_EN
			);
			
		end generate GEN_COLUMN_ARRAY_IF_2;
		
		GEN_COLUMN_ARRAY_IF_3: if (i /= 0 and i /= N_COLUMNS-1) generate
		
			COLUMN_CONTROLLER : entity work.column_ctrl
			generic map(
				N	=> N_ROWS
			)
			port map(
				CLK				=> clk,
				RESET			=> reset,
				
				STATE			=> COLUMN_STATE(i),
				INIT_STATE		=> ROM_DATA(i),
				NEIGH_LEFT		=> COLUMN_STATE(i-1),
				NEIGH_RIGHT		=> COLUMN_STATE(i+1),
				
				DIRECTION		=> ROT_DIRECTION,
				EN				=> ROT_EN
			);
			
		end generate GEN_COLUMN_ARRAY_IF_3;

	end generate GEN_COLUMN_ARRAY;



	-- Renderovani SLOUPCU na LED display ------------------------------------------------
	RENDER_LED : process (clk) is
	begin
		if RESET = '1' then
			cnt_led <= (others => '0');
		elsif rising_edge(clk) then
			cnt_led <= cnt_led + 1;
			
			if (conv_integer(cnt_led(log2(cnt_led_refresh_rate)-1 downto 0)) = cnt_led_refresh_rate) then
				
				cnt_led <= (others => '0');
				
				A <= A + 1;
				
			end if;
			
			-- send current column to LED display
			R <= COLUMN_STATE(conv_integer(A));
			
		end if;
		
	end process;
	
	
	
	-- FSM ------------------------------------------------
	FSM : process (clk) is
		variable LAST_ROTATION : DIRECTION_T := DIR_LEFT;
	begin
	
		if RESET = '1' then
			cnt <= (others => '0');
		elsif rising_edge(clk) then
			cnt <= cnt + 1;
			
			if (cnt = 0) then
				CURRENT_STATE <= CURRENT_STATE + 1;
			end if;
			
			if (cnt(23 downto 0) = 1) then -- 1 -> wait one clock tick to load new image
				ROT_EN <= '1';
			else
				ROT_EN <= '0';
			end if;
			
			if (cnt = "111111111111111111111111111111" or cnt = "011111111111111111111111111110") then -- -> change rotation 1 clock tick before loading new image
				if (LAST_ROTATION = DIR_LEFT) then
					LAST_ROTATION := DIR_RIGHT;
					ROT_DIRECTION <= DIR_RIGHT;
				else
					LAST_ROTATION := DIR_LEFT;
					ROT_DIRECTION <= DIR_LEFT;
				end if;
			end if;
			
		end if;
		
	end process;



    -- mapovani vystupu
    -- nemenit
    X(6) <= A(3);
    X(8) <= A(1);
    X(10) <= A(0);
    X(7) <= '0'; -- en_n
    X(9) <= A(2);

    X(16) <= R(1);
    X(18) <= R(0);
    X(20) <= R(7);
    X(22) <= R(2);
  
    X(17) <= R(4);
    X(19) <= R(3);
    X(21) <= R(6);
    X(23) <= R(5);
	
end Behavioral;
