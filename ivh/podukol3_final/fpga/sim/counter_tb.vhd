-- Testovani counteru, kod je tak, jak je vygenerovan od ISE
-- Autor: xjirgl01

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';

 	--Outputs
   signal EN : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   constant OUT_period : time := 100 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
    -- muzete samozrejme nastavit i genericke parametry!
    -- pozor na dobu simulace (nenastavujte moc dlouhe casy nebo zkratte CLK_period)
    -- Pocitejte s tim, ze pri zkouseni pobezi testbench 100 ms
    uut: entity work.counter
		GENERIC MAP (
			CLK_PERIOD => CLK_period,
			OUT_PERIOD => OUT_period
		)
		PORT MAP (
          CLK => CLK,
          RESET => RESET,
          EN => EN
        );

    -- Clock process definitions
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;


    -- Stimulus process
    stim_proc: process
		variable PERIOD_start : time := 0 ns;
    begin
        -- hold reset state for 100 ns.
        RESET <= '1';
        wait for 100 ns;
        RESET <= '0';

        wait for CLK_period*10;

        -- insert stimulus here



		----------------------------------
		-- TESTS THREE PERIODS IN A ROW --
		----------------------------------


		-- Wait for EN = '1'
		wait until (EN'event and EN = '1') for OUT_period;
		assert (EN = '1') report "EN not raised in OUT_period!" severity error;
		-- NEW PERIOD --------------------------------------------------------------------------------------------------
		PERIOD_start := now;
		report "CLK_PERIOD and OUT_PERIOD - start" severity note;


		-- wait for EN = '0' and check CLK_PERIOD length
		wait until (EN'event and EN = '0') for CLK_period*2;
		assert ((now - PERIOD_start) = CLK_period) report "CLK_PERIOD has wrong length! (Should be CLK_period long.)" severity error;
		assert ((now - PERIOD_start) /= CLK_period) report "CLK_PERIOD - OK!" severity note;
		report "CLK_PERIOD - end" severity note;


		-- wait for EN = '1' and check OUT_PERIOD length
		wait until (EN'event and EN = '1') for OUT_period*2;
		assert ((now - PERIOD_start) = OUT_period) report "OUT_PERIOD has wrong length! (Should be OUT_period long.)" severity error;
		assert ((now - PERIOD_start) /= OUT_period) report "OUT_PERIOD - OK!" severity note;
		report "OUT_PERIOD - end" severity note;
		-- PERIOD DONE --------------------------------------------------------------------------------------------------
		-- NEW PERIOD --------------------------------------------------------------------------------------------------
		PERIOD_start := now;
		report "CLK_PERIOD and OUT_PERIOD - start" severity note;


		-- wait for EN = '0' and check CLK_PERIOD length
		wait until (EN'event and EN = '0') for CLK_period*2;
		assert ((now - PERIOD_start) = CLK_period) report "CLK_PERIOD has wrong length! (Should be CLK_period long.)" severity error;
		assert ((now - PERIOD_start) /= CLK_period) report "CLK_PERIOD - OK!" severity note;
		report "CLK_PERIOD - end" severity note;


		-- wait for EN = '1' and check OUT_PERIOD length
		wait until (EN'event and EN = '1') for OUT_period*2;
		assert ((now - PERIOD_start) = OUT_period) report "OUT_PERIOD has wrong length! (Should be OUT_period long.)" severity error;
		assert ((now - PERIOD_start) /= OUT_period) report "OUT_PERIOD - OK!" severity note;
		report "OUT_PERIOD - end" severity note;
		-- PERIOD DONE --------------------------------------------------------------------------------------------------
		-- NEW PERIOD --------------------------------------------------------------------------------------------------
		PERIOD_start := now;
		report "CLK_PERIOD and OUT_PERIOD - start" severity note;


		-- wait for EN = '0' and check CLK_PERIOD length
		wait until (EN'event and EN = '0') for CLK_period*2;
		assert ((now - PERIOD_start) = CLK_period) report "CLK_PERIOD has wrong length! (Should be CLK_period long.)" severity error;
		assert ((now - PERIOD_start) /= CLK_period) report "CLK_PERIOD - OK!" severity note;
		report "CLK_PERIOD - end" severity note;


		-- wait for EN = '1' and check OUT_PERIOD length
		wait until (EN'event and EN = '1') for OUT_period*2;
		assert ((now - PERIOD_start) = OUT_period) report "OUT_PERIOD has wrong length! (Should be OUT_period long.)" severity error;
		assert ((now - PERIOD_start) /= OUT_period) report "OUT_PERIOD - OK!" severity note;
		report "OUT_PERIOD - end" severity note;
		-- PERIOD DONE --------------------------------------------------------------------------------------------------



        wait;
    end process;

END;
