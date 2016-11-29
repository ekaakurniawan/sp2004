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

-- Function Unit
-- -------------
--
--	Hierarchy ==>	# Function_Unit
--			|
--			+-> # ALU
--			|   |
--			|   +-> # addsub32_lib_par
--			|   |   |
--		 	|   |   +-> # adder32_lib
--			|   |
--			|   +-> # LogicUnit32
--			|
--			+-> # BarrelShift32_2
--			|
--			+-> # LUI
--
--
--	FS		Operation
-----------------------------------------------------
--	00 00		Adder			   	\
--	00 01		Subtractor		   	| --> Arithmetic
--	00 10		Pass			   	|
--	00 11		(Unused)		   	/
--
--	01 00		AND				\
--	01 01		OR				| --> Logic
--	01 10		XOR				|
--	01 11		NOR				/
--
--	10 00		Logical Shift Right		\
--	10 01		Logical Shift Left		| --> Shifter
--	10 10		Arithmetic Shift Right		|
--	10 11		(Unused)			/
--
--	11 0X		XNV	 			> --> SET
--	11 1X		Load Upper Immediate		> --> Load

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Function_Unit is
	Port ( A, B : in std_logic_vector(31 downto 0);
	       FS : in std_logic_vector(3 downto 0);
	       F : out std_logic_vector(31 downto 0);
	       Cout, Zero, N, V : out std_logic);
end Function_Unit;

architecture Behavioral of Function_Unit is

	component ALU
	    Port ( A, B : in std_logic_vector(31 downto 0);
        	   FS : in std_logic_vector(1 downto 0);
	           AS, LU : out std_logic_vector(31 downto 0);
           	   Cout, XNV, Zero, N, V : out std_logic);
	end component;

	component BarrelShift32_2
	    Port ( A : in std_logic_vector(31 downto 0);
	           SH : in std_logic_vector(4 downto 0);
		   LR, AS : in std_logic;
	           BS : out std_logic_vector(31 downto 0));
	end component;

	component LUI
    	    Port ( Imm : in std_logic_vector(15 downto 0);
		   LUI : out std_logic_vector(31 downto 0));
	end component;

	signal AStmp, LUtmp, BStmp, LUItmp, LXtmp :
	          std_logic_vector(31 downto 0);
	signal MF : std_logic_vector(1 downto 0);
	signal XNV : std_logic;

begin
	-- ALU Component
	ALU_PM : ALU port map (A=>A, B=>B, FS=>FS(1 downto 0), AS=>AStmp,
	         LU=>LUtmp, Cout=>Cout, XNV=>XNV, Zero=>Zero, N=>N, V=>V);
	-- Barrel Shifter Component
	Barrel_Shift_PM : BarrelShift32_2 port map (A=>A, SH=>B(4 downto 0),
	               LR=>FS(0), AS=>FS(1), BS=>BStmp);
	-- LUI Component
	LUI_PM : LUI port map (Imm=>B(15 downto 0), LUI=>LUItmp);

	-- Multiplexer between LUI and XNV. Because XNV only 1 bit so add 31 \
	-- zero bits in MSB.
	MUX_LX : process(FS, LUItmp, XNV)
	begin
		if(FS(1) = '0') then
			LXtmp <= X"0000000" & B"000" & XNV;
		else
			LXtmp <= LUItmp;
		end if;
	end process MUX_LX;

	-- Multiplexer for FunctionUnit using MF signal that take from FS(3:2).
	MF <= FS(3 downto 2);

	-- Multiplexer for FunctionUnit (MUX_F) choose between Add/Sub, \
	-- LogicUnit, BarrelShifter, or result from MUX_LX.
	MUX_F : process(MF, AStmp, LUtmp, BStmp, LXtmp)
	begin
		case (MF) is
			when "01" => F <= LUtmp;   -- Logic Unit
			when "10" => F <= BStmp;   -- Barrel Shifter
			when "11" => F <= LXtmp;   -- result from MUX_LX
			when others => F <= AStmp; -- Add/Sub
		end case;
	end process MUX_F;

end Behavioral;
