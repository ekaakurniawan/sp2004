-- Copyright (C) 2004-2010 by Eka A. Kurniawan
-- eka.a.kurniawan(ta)gmail(tod)com
--
-- This program is free software; you can redistribute it and/or modify 
-- it under the terms of the GNU General Public License as published by 
-- the Free Software Foundation; version 2 of the License.
--
-- This program is distributed in the hope that it will be useful, 
-- but WITHOUT ANY WARRANTY; without even the implied warranty of 
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License 
-- along with this program; if not, write to the 
-- Free Software Foundation, Inc., 
-- 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

-- Constant Unit
-- -------------
--
--	Hierarchy ==>	# Const_Unit
--
--	CS	Operation
------------------------------------
--	0	X"0000" || IR(15:0)
--	1	IR(15) || IR(15:0)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Const_Unit is
    Port ( Imm : in std_logic_vector(15 downto 0);
           CS : in std_logic;
           Const : out std_logic_vector(31 downto 0));
end Const_Unit;

architecture Behavioral of Const_Unit is

begin

	-- Just pass the 16 LSB value.
	Const(15 downto 0) <= Imm(15 downto 0);

	process (CS, Imm) begin
		if (CS = '0') then
			-- For unsign value.
			Const(31 downto 16) <= X"0000";
		else
			-- For sign value (Sign Extention).
			for i in 31 downto 16 loop
				Const(i) <= Imm(15);
			end loop;
		end if;
	end process;

end Behavioral;
