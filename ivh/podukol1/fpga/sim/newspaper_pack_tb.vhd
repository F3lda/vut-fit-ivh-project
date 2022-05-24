-- newspaper_pack_tb.vhd: IVH projekt - 1. podúkol
-- Author(s): Karel Jirgl (xjirgl01)
-- Copyright (C) 2022

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use work.newspaper_pack.all;


entity testbench is
end entity testbench;



architecture behavioral of testbench is

	signal DATA : std_logic_vector(0 to 11) := "101001100111";
	signal result : std_logic_vector(0 to 2) := "000";
	
	
	function VecToStr(vector : std_logic_vector) return string is
		variable resultASC	: string(0 to (vector'length-1));
		variable resultDESC	: string((vector'length-1) downto 0);
	begin
		--report "LENGTH: " & integer'image(vector'length);
		--report "ASCENDING: " & boolean'image(vector'ascending);
		
		for i in vector'range loop
			if (vector(i) = '1') then
				resultASC(i) := '1';
				resultDESC(i) := '1';
			elsif (vector(i) = '0') then
				resultASC(i) := '0';
				resultDESC(i) := '0';
			else
				resultASC(i) := 'X';
				resultDESC(i) := 'X';
			end if;
		end loop;
		
		if (vector'ascending) then
			return resultASC;
		else
			return resultDESC;
		end if;
	end;
	
begin

	process is
		variable result3 : std_logic_vector(0 to 2) := "000";
		variable result4 : std_logic_vector(0 to 3) := "0000";
		variable result5 : std_logic_vector(0 to 4) := "00000";
	begin
		report "------------------------------";
		result3 := GETCOLUMN(DATA, 0, 3);
		assert result3 = "101" report "ERROR: GETCOLUMN(DATA, 0, 3) != 101 -> " & VecToStr(result3) severity error;
		assert result3 /= "101" report "OK: GETCOLUMN(DATA, 0, 3) == 101 -> " & VecToStr(result3) severity note;
		
		report "------------------------------";
		result3 := GETCOLUMN(DATA, 1, 3);
		assert result3 = "001" report "ERROR: GETCOLUMN(DATA, 1, 3) != 001 -> " & VecToStr(result3) severity error;
		assert result3 /= "001" report "OK: GETCOLUMN(DATA, 1, 3) == 001 -> " & VecToStr(result3) severity note;
		
		report "------------------------------";
		result3 := GETCOLUMN(DATA, 0, 3);
		assert result3 = "101" report "ERROR: GETCOLUMN(DATA, 0, 3) != 101 -> " & VecToStr(result3) severity error;
		assert result3 /= "101" report "OK: GETCOLUMN(DATA, 0, 3) == 101 -> " & VecToStr(result3) severity note;
		
		report "------------------------------";
		result3 := GETCOLUMN(DATA, 4, 3);
		assert result3 = "101" report "ERROR: GETCOLUMN(DATA, 4, 3) != 101 -> " & VecToStr(result3) severity error;
		assert result3 /= "101" report "OK: GETCOLUMN(DATA, 4, 3) == 101 -> " & VecToStr(result3) severity note;
		
		report "------------------------------";
		result3 := GETCOLUMN(DATA, -1, 3);
		assert result3 = "111" report "ERROR: GETCOLUMN(DATA, -1, 3) != 111 -> " & VecToStr(result3) severity error;
		assert result3 /= "111" report "OK: GETCOLUMN(DATA, -1, 3) == 111 -> " & VecToStr(result3) severity note;
		
		report "------------------------------";
		result5 := GETCOLUMN(DATA, -1, 5);
		assert result5 = "00000" report "ERROR: GETCOLUMN(DATA, -1, 5) != 00000 -> " & VecToStr(result5) severity error;
		assert result5 /= "00000" report "OK: GETCOLUMN(DATA, -1, 5) == 00000 -> " & VecToStr(result5) severity note;
		
		report "------------------------------";
		result4 := GETCOLUMN(DATA, 2, 4);
		assert result4 = "0111" report "ERROR: GETCOLUMN(DATA, 2, 4) != 0111 -> " & VecToStr(result4) severity error;
		assert result4 /= "0111" report "OK: GETCOLUMN(DATA, 2, 4) == 0111 -> " & VecToStr(result4) severity note;
	
		report "------------------------------";
		result4 := GETCOLUMN(DATA, 0, 4);
		assert result4 = "1010" report "ERROR: GETCOLUMN(DATA, 0, 4) != 1010 -> " & VecToStr(result4) severity error;
		assert result4 /= "1010" report "OK: GETCOLUMN(DATA, 0, 4) == 1010 -> " & VecToStr(result4) severity note;
	
		report "------------------------------";
		result4 := GETCOLUMN(DATA, 3, 4);
		assert result4 = "1010" report "ERROR: GETCOLUMN(DATA, 3, 4) != 1010 -> " & VecToStr(result4) severity error;
		assert result4 /= "1010" report "OK: GETCOLUMN(DATA, 3, 4) == 1010 -> " & VecToStr(result4) severity note;
		
		report "------------------------------";
		result4 := GETCOLUMN(DATA, 1, 4);
		assert result4 = "0110" report "ERROR: GETCOLUMN(DATA, 1, 4) != 0110 -> " & VecToStr(result4) severity error;
		assert result4 /= "0110" report "OK: GETCOLUMN(DATA, 1, 4) == 0110 -> " & VecToStr(result4) severity note;
	
		report "------------------------------";
		result <= result3;
		report "result: " & VecToStr(result);
	
		report "------------------------------";
		wait;
	end process;

end architecture behavioral;
