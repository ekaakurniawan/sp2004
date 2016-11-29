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

-- Branch Control
-- --------------
--
--	Hierarchy  ==>	# branch_ctrl
--
-- Instruction Name         BS   Flag              MC  Operation
------------------------------------------------------------------------------
-- Branch if Higher         000  C=1 AND ZERO=0    01  PC<-PC+Target(16)<-BrA
--                               C=0 OR  ZERO=1    00  PC<-PC+1
-- Branch if Higher Equal   001  C=1               01  PC<-PC+Target(16)<-BrA
--                               C=0               00  PC<-PC+1
-- Branch if Equal          010  ZERO=1            01  PC<-PC+Target(16)<-BrA
--                               ZERO=0            00  PC<-PC+1
-- Branch if Greater        011  XNV=0 AMD ZERO=0  01  PC<-PC+Target(16)<-BrA
--                               XNV=1 OR  ZERO=1  00  PC<-PC+1
-- Branch if Greater Equal  100  XNV=0             01  PC<-PC+Target(16)<-BrA
--                               XNV=1             00  PC<-PC+1
-- Jump                     101  ---               10  PC<-PC+Target(26)<-JA
-- Jump Register            110  ---               11  PC<-RB<-JRA
-- Next Instruction         111  ---               00  PC<-PC+1

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Branch_Ctrl is
	port (	BS : in std_logic_vector(2 downto 0);
		Zero, Cout, N, V : in std_logic;
		MC : out std_logic_vector(1 downto 0)
	);
end Branch_Ctrl;

architecture Behavioral of Branch_Ctrl is

begin

	-- Branch Control Component
	Branch_Ctrl_Process : process(BS, Zero, Cout, N, V) begin
		-- Branch if Higher
		if   ((BS = "000") AND ((Cout = '1') AND (Zero = '0'))) then
		      MC <= "01";
		elsif((BS = "000") AND ((Cout = '0') OR  (Zero = '1'))) then
		      MC <= "00";
		-- Branch if Higher Equal
		elsif((BS = "001") AND (Cout = '1')) then MC <= "01";
		elsif((BS = "001") AND (Cout = '0')) then MC <= "00";
		-- Branch if Equal
		elsif((BS = "010") AND (Zero = '1')) then MC <= "01";
		elsif((BS = "010") AND (Zero = '0')) then MC <= "00";
		-- Branch if Greater
		elsif((BS = "011") AND (((N XOR V) = '0') AND (Zero = '0')))
		      then MC <= "01";
		elsif((BS = "011") AND (((N XOR V) = '1') OR  (Zero = '1')))
		      then MC <= "00";
		-- Branch if Greater Equal
		elsif((BS = "100") AND (( N XOR V) = '0')) then MC <= "01";
		elsif((BS = "100") AND (( N XOR V) = '1')) then MC <= "00";
		-- Jump Address
		elsif( BS = "101") then MC <= "10";
		-- Jump Register Address
		elsif( BS = "110") then MC <= "11";
		-- Next
		else MC <= "00";
		end if;
	end process Branch_Ctrl_Process;

end Behavioral;
