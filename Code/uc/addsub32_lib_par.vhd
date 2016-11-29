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

-- Adder and Subtractor
-- --------------------
--
--      Hierarchy ==>	# addsub32_lib_par
-- 			|
--			+-> # adder32_lib
--
-- Pass		SubAdd		Operation
-------------------------------------------
--  0		  0		Adder
--  0		  1		Subtractor
--  1		  0		Pass
--  1		  1		Pass

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity addsub32_lib_par is
    Port ( A, B : in std_logic_vector(31 downto 0);
           SubAdd, Pass : in std_logic;
           G : out std_logic_vector(31 downto 0);
           Cout, V, N : out std_logic);
end addsub32_lib_par;

architecture Behavioral of addsub32_lib_par is

	signal Btmp, Gtmp : std_logic_vector (31 downto 0);
	signal CoutT : std_logic;

	component adder32_lib
    		Port (  A, B : in std_logic_vector(31 downto 0);
			Cin : in std_logic;
			Sum : out std_logic_vector(31 downto 0);
			Cout : out std_logic);
	end component;

begin
	-- Adder Component
	adder_PM : adder32_lib port map (A => A, B => Btmp, Cin => SubAdd,
	           Sum => Gtmp, Cout => CoutT);

	-- If its not a pass instruction (Pass=0), change adder tobe add/sub \
	-- using two's complement. Otherwise, out a zero value.
	add_sub : process (SubAdd, Pass, B, SubAdd) begin
		if (Pass = '0') then
			for I in 0 to 31 loop
				Btmp(I) <= B(I) XOR SubAdd;
			end loop;
		else Btmp <= X"00000000";
		end if;
	end process;

	-- The add/sub output and it's flag (Carry Out (Cout), Negative (N), \
	-- and Overflow (V). Zero flag generate using zero detector at \
	-- Function Unit component.
	G <= Gtmp;
	Cout <= CoutT;
	N <= Gtmp(31);
	-- We can get overflow from XOR between Carry Out (Cout) and Carry \
	-- from A(30) add B(30) calculation. We can get Carry from A(30) add \
	-- B(30) calculation using XOR between A(31), B(31), and A(31) add \
	-- B(31) result.
	V <= CoutT XOR A(31) XOR Btmp(31) XOR Gtmp(31);

end Behavioral;
