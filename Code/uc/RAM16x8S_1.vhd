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

-- RAM16x8S_1 : 16-deep by 8-wide static sync. RAM with negative-edge clock
--
--	Hierarchy  ==>	# RAM16x8S_1
--			|
--			+-> # RAM16x1S_1 (Library)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM16x8S_1 is
	port(	WE, WCLK : in std_logic;
		D : in std_logic_vector(7 downto 0);
		A : in std_logic_vector(3 downto 0);
		O : out std_logic_vector(7 downto 0)
	);
end RAM16x8S_1;

architecture Behavioral of RAM16x8S_1 is

	component RAM16x1S_1
		port(	WE : in std_logic;
			D : in std_logic;
			A3 : in std_logic;
			A2 : in std_logic;
			A1 : in std_logic;
			A0 : in std_logic;
			WCLK : in std_logic;
			O : out std_logic
		);
	end component;

begin

	-- From RAM16x1S_1, duplicate the wide (bit) 8 times to be RAM16x8S_1.
	bit1 : RAM16x1S_1 port map (WE=>WE, D=>D(0), A3=>A(3), A2=>A(2),
	       A1=>A(1), A0=>A(0), WCLK=>WCLK, O=>O(0));
	bit2 : RAM16x1S_1 port map (WE=>WE, D=>D(1), A3=>A(3), A2=>A(2),
	       A1=>A(1), A0=>A(0), WCLK=>WCLK, O=>O(1));
	bit3 : RAM16x1S_1 port map (WE=>WE, D=>D(2), A3=>A(3), A2=>A(2),
	       A1=>A(1), A0=>A(0), WCLK=>WCLK, O=>O(2));
	bit4 : RAM16x1S_1 port map (WE=>WE, D=>D(3), A3=>A(3), A2=>A(2),
	       A1=>A(1), A0=>A(0), WCLK=>WCLK, O=>O(3));
	bit5 : RAM16x1S_1 port map (WE=>WE, D=>D(4), A3=>A(3), A2=>A(2),
	       A1=>A(1), A0=>A(0), WCLK=>WCLK, O=>O(4));
	bit6 : RAM16x1S_1 port map (WE=>WE, D=>D(5), A3=>A(3), A2=>A(2),
	       A1=>A(1), A0=>A(0), WCLK=>WCLK, O=>O(5));
	bit7 : RAM16x1S_1 port map (WE=>WE, D=>D(6), A3=>A(3), A2=>A(2),
	       A1=>A(1), A0=>A(0), WCLK=>WCLK, O=>O(6));
	bit8 : RAM16x1S_1 port map (WE=>WE, D=>D(7), A3=>A(3), A2=>A(2),
	       A1=>A(1), A0=>A(0), WCLK=>WCLK, O=>O(7));

end Behavioral;
