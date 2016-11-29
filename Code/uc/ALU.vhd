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

-- ALU (Arithmetic Logic Unit)
-- ---------------------------
--
--	Hierarchy ==>	# ALU
--			|
--			+-> # addsub32_lib_par
--			|   |
--		 	|   +-> # adder32_lib_par
--			|
--			+-> # LogicUnit32
--
--	Output	FS		Operation
----------------------------------------------
--	AS	00		Adder		\
--	AS	01		Subtractor	| --> Arithmetic
--	As	10		Pass		|
--	As	11		(Unused)	/
--	LU	00		AND	\
--	LU	01		OR	| --> Logic
--	LU	10		XOR	|
--	LU	11		NOR	/

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port ( A, B : in std_logic_vector(31 downto 0);
           FS : in std_logic_vector(1 downto 0);
           AS, LU : out std_logic_vector(31 downto 0);
           Cout, XNV, Zero, N, V : out std_logic);
end ALU;

architecture Behavioral of ALU is

	component addsub32_lib_par
	    Port ( A, B : in std_logic_vector(31 downto 0);
	           SubAdd, Pass : in std_logic;
	           G : out std_logic_vector(31 downto 0);
	           Cout, V, N : out std_logic);
	end component;

	component LogicUnit32
    	    Port ( A, B : in std_logic_vector(31 downto 0);
           	   S : in std_logic_vector(1 downto 0);
		   Z : out std_logic_vector(31 downto 0));
	end component;

	signal AStmp : std_logic_vector(31 downto 0);
	signal Ntmp, Vtmp : std_logic;

begin

	-- Adder and Subtractor Component
	add_sub_PM : addsub32_lib_par port map (A=>A, B=>B, SubAdd=>FS(0),
	             Pass=>FS(1), G=>AStmp, Cout=>Cout, V=>Vtmp, N=>Ntmp);
	-- Logic Unit component
	logic_unit_PM : LogicUnit32 port map (A=>A, B=>B, S=>FS(1 downto 0),
	                Z=>LU);
	-- Negative (N) and Overflow (V) Flag
	N <= Ntmp;
	V <= Vtmp;

	-- XNV is XOR between Negative (N) and Overflow (V) Flag.
	XNV <= Ntmp XOR Vtmp;

	-- Add/Sub output (AS) different from Logic Unit output.
	AS <= AStmp;

	-- Zero detector : NOR all bit from AS output.
	Zero <= NOT( AStmp(31) OR AStmp(30) OR AStmp(29) OR AStmp(28) OR
	             AStmp(27) OR AStmp(26) OR AStmp(25) OR AStmp(24) OR
	             AStmp(23) OR AStmp(22) OR AStmp(21) OR AStmp(20) OR
	             AStmp(19) OR AStmp(18) OR AStmp(17) OR AStmp(16) OR
		     AStmp(15) OR AStmp(14) OR AStmp(13) OR AStmp(12) OR
		     AStmp(11) OR AStmp(10) OR AStmp(9) OR AStmp(8) OR
		     AStmp(7) OR AStmp(6) OR AStmp(5) OR AStmp(4) OR
		     AStmp(3) OR AStmp(2) OR AStmp(1) OR AStmp(0) );

end Behavioral;
