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

-- RAM32x32S_1 : 32-deep by 32-wide static sync. RAM with negative-edge clock
--
--	Hierarchy  ==>	# RAM32x32S_1
--			|
--			+-> # RAM16x8S_1
--			|   |
--			|   +-> # RAM16x1S_1 (Library)
--			|
--			+-> # BUFE32
--			    |
--			    +-> # BUFE (Library)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM32x32S_1 is
	port(	WE, WCLK, CS : in std_logic;
		BSel : in std_logic_vector(3 downto 0); -- BSel = Byte Select
		A : in std_logic_vector(4 downto 0);
		D : inout std_logic_vector(31 downto 0)
	);
end RAM32x32S_1;

architecture Behavioral of RAM32x32S_1 is

	component RAM16x8S_1
		port(	WE, WCLK : in std_logic;
			D : in std_logic_vector(7 downto 0);
			A : in std_logic_vector(3 downto 0);
			O : out std_logic_vector(7 downto 0)
		);
	end component;

	component BUFE32
		port(	E : in std_logic;
			I : in std_logic_vector(31 downto 0);
			O : out std_logic_vector(31 downto 0)
		);
	end component;

	signal WE1_0, WE1_1, WE1_2, WE1_3, WE2_0, WE2_1, WE2_2, WE2_3 : std_logic;
	signal WE_tmp : std_logic;
	signal Dout, Dout1, Dout2 : std_logic_vector(31 downto 0);

begin

	-- WE Signal for each Byte in 1 Word (32 bits) at first 16 RAM.
	WE1_0 <= WE AND (NOT CS) AND (NOT A(4)) AND BSel(0);
	WE1_1 <= WE AND (NOT CS) AND (NOT A(4)) AND BSel(1);
	WE1_2 <= WE AND (NOT CS) AND (NOT A(4)) AND BSel(2);
	WE1_3 <= WE AND (NOT CS) AND (NOT A(4)) AND BSel(3);
	-- WE Signal for each Byte in 1 Word (32 bits) at second 16 RAM.
	WE2_0 <= WE AND (NOT CS) AND A(4) AND BSel(0);
	WE2_1 <= WE AND (NOT CS) AND A(4) AND BSel(1);
	WE2_2 <= WE AND (NOT CS) AND A(4) AND BSel(2);
	WE2_3 <= WE AND (NOT CS) AND A(4) AND BSel(3);

	-- Duplicate the RAM two time for deep and four time for wide to make \
	-- RAM32x32S_1.
	RAM16_1x8_0 : RAM16x8S_1 port map (WE=>WE1_0, WCLK=>WCLK,
	    D=>D( 7 downto 0),  A=>A(3 downto 0), O=>Dout1( 7 downto 0));
	RAM16_2x8_0 : RAM16x8S_1 port map (WE=>WE2_0, WCLK=>WCLK,
	    D=>D( 7 downto 0),  A=>A(3 downto 0), O=>Dout2( 7 downto 0));
	RAM16_1x8_1 : RAM16x8S_1 port map (WE=>WE1_1, WCLK=>WCLK,
	    D=>D(15 downto 8),  A=>A(3 downto 0), O=>Dout1(15 downto 8));
	RAM16_2x8_1 : RAM16x8S_1 port map (WE=>WE2_1, WCLK=>WCLK,
	    D=>D(15 downto 8),  A=>A(3 downto 0), O=>Dout2(15 downto 8));
	RAM16_1x8_2 : RAM16x8S_1 port map (WE=>WE1_2, WCLK=>WCLK,
	    D=>D(23 downto 16), A=>A(3 downto 0), O=>Dout1(23 downto 16));
	RAM16_2x8_2 : RAM16x8S_1 port map (WE=>WE2_2, WCLK=>WCLK,
	    D=>D(23 downto 16), A=>A(3 downto 0), O=>Dout2(23 downto 16));
	RAM16_1x8_3 : RAM16x8S_1 port map (WE=>WE1_3, WCLK=>WCLK,
	    D=>D(31 downto 24), A=>A(3 downto 0), O=>Dout1(31 downto 24));
	RAM16_2x8_3 : RAM16x8S_1 port map (WE=>WE2_3, WCLK=>WCLK,
	    D=>D(31 downto 24), A=>A(3 downto 0), O=>Dout2(31 downto 24));

	-- Multiplexer to select between first or second 16 RAM that readed \
	-- by RISC processor.
	process(A, Dout1, Dout2) begin
		if(A(4) = '0') then
			Dout <= Dout1; -- First 16 RAM
		else
			Dout <= Dout2; -- Second 16 RAM
		end if;
	end process;

	-- TSB for Data Bus.
	WE_tmp <= (NOT WE) AND (NOT CS);
	TS_Buffer : BUFE32 port map (E=>WE_tmp, I=>Dout, O=>D);

end Behavioral;
