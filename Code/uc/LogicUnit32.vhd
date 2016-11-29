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

-- Logic Unit 32 bit
-- -----------------
--
--	Hierarchy  ==>	# LogicUnit32
--
--	S	Operation
----------------------------
--	00	AND
--	01	OR
--	10	XOR
--	11	NOR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LogicUnit32 is
    Port ( A, B : in std_logic_vector(31 downto 0);
           S : in std_logic_vector(1 downto 0);
           Z : out std_logic_vector(31 downto 0));
end LogicUnit32;

architecture Behavioral of LogicUnit32 is

begin

   process (S, A, B) begin
      case S is
         when "00"   => Z(31 downto 0) <= A(31 downto 0) AND B(31 downto 0);
         when "01"   => Z(31 downto 0) <= A(31 downto 0) OR  B(31 downto 0);
         when "10"   => Z(31 downto 0) <= A(31 downto 0) XOR B(31 downto 0);
         when others => Z(31 downto 0) <= A(31 downto 0) NOR B(31 downto 0);
      end case;
   end process;

end Behavioral;
