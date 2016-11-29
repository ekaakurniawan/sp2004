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

-- BarrelShift32_2 : 	shift 32 bits with "two bit" multiplexer selector \
-- ---------------	every stage.
--
--	Hierarchy ==>	# BarrelShift32_2
--
--	AS	LR	Operation
--     ------------------------------------------
--	0	0	Logical Shift Right
--	0	1	Logical Shift Left
--	1	0	Arithmetic Shift Right
--	1	1	Arithmetic Shift Left (X)
--
--  SH : Shift count (0 to 31)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BarrelShift32_2 is
    Port ( A : in std_logic_vector(31 downto 0);
           SH : in std_logic_vector(4 downto 0);
	   LR, AS : in std_logic;
           BS : out std_logic_vector(31 downto 0));
end BarrelShift32_2;

architecture Behavioral of BarrelShift32_2 is

	signal SH_2C : std_logic_vector(5 downto 0);
	signal Z1 : std_logic_vector(46 downto 0);
	signal Z2 : std_logic_vector(34 downto 0);

	signal AS_32 : std_logic_vector(31 downto 0);

begin

	-- Arithmetic Shift Right do the Shift Right but insert MSB value to \
	-- the position that it leaved not zero like Logical Shift do.
	-- Barrel Shifter use 64 bit input (AS_32(31:0)||A(31:0)). AS_32 is \
	-- zero if it is Logical Shift. Otherwise, all AS_32 bits equal to \
	-- bit A(31).
	Arithmetic_Shift : process(AS, A) begin
		for i in 31 downto 0 loop
			AS_32(i) <= AS AND A(31);
		end loop;
	end process;

	-- Selective two's complement to make the shifter can shift to left \
	-- or right from the basic idea is Rotate Right.
	Left_or_Right : process(LR, SH) begin
		if (LR = '0') then
			SH_2C <= '0'&SH;
		else
			SH_2C <= ('1'&(not SH)) + '1';
		end if;
	end process;

	-- Using two bit multiplexer selector (4 successor) all bit can \
	-- covered in 3 stage.
	barel_shift : process (SH_2C, A, Z1, Z2, AS, AS_32) begin
	   case SH_2C(5 downto 4) is
			when "00" =>   Z1(46 downto 0) <= AS_32(14 downto 0) &
							  A(31 downto 0);
			when "01" =>   Z1(46 downto 0) <= AS_32(30 downto 0) &
							  A(31 downto 16);
			when "10" =>   Z1(46 downto 0) <= A(14 downto 0) &
							  AS_32(31 downto 0);
			when others => Z1(46 downto 0) <= A(30 downto 0) &
							  AS_32(31 downto 16);
		end case;

		case SH_2C(3 downto 2) is
			when "00" =>	Z2(34 downto 0) <= Z1(34 downto 0);
			when "01" =>	Z2(34 downto 0) <= Z1(38 downto 4);
			when "10" =>	Z2(34 downto 0) <= Z1(42 downto 8);
			when others =>	Z2(34 downto 0) <= Z1(46 downto 12);
		end case;

		case SH_2C(1 downto 0) is
			when "00" =>	BS(31 downto 0) <= Z2(31 downto 0);
			when "01" =>	BS(31 downto 0) <= Z2(32 downto 1);
			when "10" =>	BS(31 downto 0) <= Z2(33 downto 2);
			when others =>	BS(31 downto 0) <= Z2(34 downto 3);
		end case;

	end process;

end Behavioral;
