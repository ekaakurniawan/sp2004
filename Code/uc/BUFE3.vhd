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
--	Hirarki ==>	# BUFE3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BUFE3 is
	port(	E : in std_logic;
		I : in std_logic_vector(2 downto 0);
		O : out std_logic_vector(2 downto 0)
	);
end BUFE3;

architecture Behavioral of BUFE3 is

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

end Behavioral;
