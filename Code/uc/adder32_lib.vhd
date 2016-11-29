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

-- Adder 32 bit using Library
-- --------------------------
--
--	Hierarchy ==>	# adder32_lib

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder32_lib is
    Port ( A, B : in std_logic_vector(31 downto 0);
           Cin : in std_logic;
           Sum : out std_logic_vector(31 downto 0);
           Cout : out std_logic);
end adder32_lib;

architecture Behavioral of adder32_lib is

	signal Stmp : std_logic_vector(32 downto 0);

begin
	-- Adder 32 bit to get Cout as a last result. Add Cin because we need \
	-- it for two's complement.
	Stmp(32 downto 0) <= ('0'&A(31 downto 0)) + ('0'&B(31 downto 0)) + Cin;

	-- The Carry Out (Cout)
	Cout <= Stmp(32);

	-- The Result of 31 bits addition
	Sum(31 downto 0) <= Stmp(31 downto 0);

end Behavioral;
