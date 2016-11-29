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

-- Data Dependency Detector
-- ------------------------
--
--	Hierarchy  ==>	# Data_Dependency_Detector
--
--  HA = (AA_DO == DA_EX) . LD_EX . (DA_EX != 00000) . MA_DO'
--  HB = (BA_DO == DA_EX) . LD_EX . (DA_EX != 00000) . MB_DO'

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Data_Dependency_Detector is
	port(	MA, MB, LD : in std_logic;
		AA, BA, DA : in std_logic_vector(4 downto 0);
		HA, HB : out std_logic
	);
end Data_Dependency_Detector;

architecture Behavioral of Data_Dependency_Detector is
begin

	DF_Sel : process(LD, DA, AA, BA, MA, MB) begin
		if((AA = DA) AND (LD = '1') AND (DA /= "00000")) AND (MA = '0') then
			HA <= '1';
		else
			HA <= '0';
		end if;

		if((BA = DA) AND (LD = '1') AND (DA /= "00000")) AND (MB = '0') then
			HB <= '1';
		else
			HB <= '0';
		end if;
	end process DF_Sel;

end Behavioral;
