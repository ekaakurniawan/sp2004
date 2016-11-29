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

-- Three State Buffer
--
--	Hirarki ==>	# BUFE8

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BUFE8 is
	port(	E : in std_logic;
		I : in std_logic_vector(7 downto 0);
		O : out std_logic_vector(7 downto 0)
	);
end BUFE8;

architecture Behavioral of BUFE8 is

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

end Behavioral;
