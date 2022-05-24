-- newspaper_pack.vhd: IVH projekt - 1. podúkol
-- Author(s): Karel Jirgl (xjirgl01)
-- Copyright (C) 2022

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


package newspaper_pack is

	type DIRECTION_T is (DIR_LEFT, DIR_RIGHT);

	function GETCOLUMN(signal DATA : in std_logic_vector; COLID : in integer; ROWS : in integer) return std_logic_vector;

end newspaper_pack;



package body newspaper_pack is

	function GETCOLUMN (
		signal DATA : in std_logic_vector;
		COLID : in integer;
		ROWS : in integer
	) return std_logic_vector is
		variable result	: std_logic_vector(0 to (ROWS-1)) := (others => '0');
		variable COLS	: integer := DATA'length/ROWS;
		variable COLNUM	: integer := COLID mod COLS;
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
			report integer'image(COLNUM*ROWS) & " to " & integer'image((COLNUM*ROWS)+(ROWS-1));
			result := DATA((COLNUM*ROWS) to ((COLNUM*ROWS)+(ROWS-1)));
		end if;

		return result;
	end;

end newspaper_pack;
