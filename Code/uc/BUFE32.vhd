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

-- Three State Buffer 32 bit
--
--	Hierarchy  ==> 	# BUFE32
--
-- 32 bits Three State Buffer with Positive Clock Edge, used for control data \
-- in/out stream between RISC Processor and external device.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BUFE32 is
	port(	E : in std_logic;
		I : in std_logic_vector(31 downto 0);
		O : out std_logic_vector(31 downto 0)
	);
end BUFE32;

architecture Behavioral of BUFE32 is

	component BUFE
		port(	E : in std_logic;
			I : in std_logic;
			O : out std_logic
		);
	end component;

begin

	bit00 : BUFE port map (E=>E, I=>I(0),  O=>O(0));
	bit01 : BUFE port map (E=>E, I=>I(1),  O=>O(1));
	bit02 : BUFE port map (E=>E, I=>I(2),  O=>O(2));
	bit03 : BUFE port map (E=>E, I=>I(3),  O=>O(3));
	bit04 : BUFE port map (E=>E, I=>I(4),  O=>O(4));
	bit05 : BUFE port map (E=>E, I=>I(5),  O=>O(5));
	bit06 : BUFE port map (E=>E, I=>I(6),  O=>O(6));
	bit07 : BUFE port map (E=>E, I=>I(7),  O=>O(7));
	bit08 : BUFE port map (E=>E, I=>I(8),  O=>O(8));
	bit09 : BUFE port map (E=>E, I=>I(9),  O=>O(9));
	bit10 : BUFE port map (E=>E, I=>I(10), O=>O(10));
	bit11 : BUFE port map (E=>E, I=>I(11), O=>O(11));
	bit12 : BUFE port map (E=>E, I=>I(12), O=>O(12));
	bit13 : BUFE port map (E=>E, I=>I(13), O=>O(13));
	bit14 : BUFE port map (E=>E, I=>I(14), O=>O(14));
	bit15 : BUFE port map (E=>E, I=>I(15), O=>O(15));
	bit16 : BUFE port map (E=>E, I=>I(16), O=>O(16));
	bit17 : BUFE port map (E=>E, I=>I(17), O=>O(17));
	bit18 : BUFE port map (E=>E, I=>I(18), O=>O(18));
	bit19 : BUFE port map (E=>E, I=>I(19), O=>O(19));
	bit20 : BUFE port map (E=>E, I=>I(20), O=>O(20));
	bit21 : BUFE port map (E=>E, I=>I(21), O=>O(21));
	bit22 : BUFE port map (E=>E, I=>I(22), O=>O(22));
	bit23 : BUFE port map (E=>E, I=>I(23), O=>O(23));
	bit24 : BUFE port map (E=>E, I=>I(24), O=>O(24));
	bit25 : BUFE port map (E=>E, I=>I(25), O=>O(25));
	bit26 : BUFE port map (E=>E, I=>I(26), O=>O(26));
	bit27 : BUFE port map (E=>E, I=>I(27), O=>O(27));
	bit28 : BUFE port map (E=>E, I=>I(28), O=>O(28));
	bit29 : BUFE port map (E=>E, I=>I(29), O=>O(29));
	bit30 : BUFE port map (E=>E, I=>I(30), O=>O(30));
	bit31 : BUFE port map (E=>E, I=>I(31), O=>O(31));

end Behavioral;
