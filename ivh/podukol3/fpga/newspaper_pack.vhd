-- newspaper_pack.vhd: IVH projekt - 1. podúkol
-- Author(s): Karel Jirgl (xjirgl01)
-- Copyright (C) 2022

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


package newspaper_pack is

	constant N_ROWS : integer := 8;
	constant N_COLUMNS : integer := 16;
	constant N_STATES : integer := 4;

	type DIRECTION_T is (DIR_LEFT, DIR_RIGHT);
	type COLUMN_ARRAY_T is array (0 to N_COLUMNS-1) of std_logic_vector(0 to N_ROWS-1);

	function GETCOLUMN(signal DATA : in std_logic_vector; COLID : in integer; ROWS : in integer) return std_logic_vector;
	function log2(A: integer) return integer;
	function VecToStr(vector : std_logic_vector) return string;

end newspaper_pack;



package body newspaper_pack is

	function GETCOLUMN (
		signal DATA : in std_logic_vector;
		COLID : in integer;
		ROWS : in integer
	) return std_logic_vector is
		variable result	: std_logic_vector(0 to (ROWS-1)) := (others => '0');
		constant COLS	: integer := DATA'length/ROWS;
		constant COLNUM	: integer := COLID mod COLS;
	begin
		if (DATA'length < 1) then
			report "DATA vector is empty!" severity error;
		elsif (DATA'length mod ROWS /= 0) then
			report "DATA vector is not divisible by number of ROWS!" severity error;
		elsif (COLID < 0) then
			report "COLID is smaller than the first index (0)!" severity warning;
			result := DATA((DATA'length-ROWS) to (DATA'length-1));
		elsif (COLID > COLS-1) then
			report "COLID is bigger than the last index (" & integer'image(COLS-1) & ")!" severity warning;
			result := DATA(0 to (ROWS-1));
		else
			--report integer'image(COLNUM*ROWS) & " to " & integer'image((COLNUM*ROWS)+(ROWS-1));
			result := DATA((COLNUM*ROWS) to ((COLNUM*ROWS)+(ROWS-1)));
		end if;

		return result;
	end;


	-- zde je funkce log2 z prednasek, pravdepodobne se vam bude hodit.
	function log2(A: integer) return integer is
		variable bits : integer := 0;
		variable b : integer := 1;
	begin
		while (b < a) loop
			b := b * 2;
			bits := bits + 1;
		end loop;
		return bits;
	end function;
	
	
	function VecToStr(
		vector : std_logic_vector
	) return string is
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
	

end newspaper_pack;
