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

-- Register 3 bits
--
--	Hierarchy  ==>	# reg1x3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg1x3 is
    Port ( reg_in : in std_logic_vector(2 downto 0);
           reg_out : out std_logic_vector(2 downto 0);
           CLK : in std_logic;
           RESET : in std_logic);
end reg1x3;

architecture Behavioral of reg1x3 is

begin

	process(CLK, RESET, reg_in) begin
		if(RESET = '1') then
			reg_out <= "000";
		elsif(CLK'EVENT and CLK = '1') then
			reg_out <= reg_in;
		end if;
	end process;

end Behavioral;
