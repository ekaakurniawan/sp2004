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

-- Interrupt Control
-- -----------------
--
--	Hierarchy  ==>	# Interrupt_Ctrl
--
-- Six bit OpCode from Instruction (Inst(31:26)) copy to Interrupt Enable \
-- OpCode (IntEnOP(5:0)) means:
--    IntEnOP(5:1)  IntEnOP(0)	    Operation
--   ---------------------------------------------
--	 01111		0	Disable Interrupt
--	 01111		1	Enable Interrupt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Interrupt_Ctrl is
	port(	CLK : in std_logic;
		IntREQ, MW, MR : in std_logic;
		IntEnOP : in std_logic_vector(5 downto 0);
		Br1, Br2 : in std_logic_vector(2 downto 0);
		Int : out std_logic);
end Interrupt_Ctrl;

architecture Behavioral of Interrupt_Ctrl is

	signal Int_Sel, E_Int_Next, E_Int_Curr, BG1, BG2 : std_logic;

begin

	-- Multiplexer for Enable Interrupt (MUX_E_Int) controled by \
	-- Interrupt Selector (IntSel) to select between current interrupt \
	-- flag (Enable or Disable Interrput) and new setting for interrupt \
	-- flag.
	MUX_E_Int : process(Int_Sel, E_Int_Curr, IntEnOP) begin
		if(Int_Sel = '0') then
			E_Int_Next <= E_Int_Curr; -- Current Interrupt Flag
		else
			E_Int_Next <= IntEnOP(0); -- New Interrupt Flag
		end if;
	end process;

	-- Interrupt Select Decoder used to control MUX_E_Int.
	-- Change Interrupt Flag if:
	--  - Request for Interrupt Flag changing occur.
	--  - DO stage not decoding branch instruction (Br1 = 111).
	--  - EX stage not executing branch instruction (Br2 = 111).
	Int_Sel_DEC : process(IntEnOP, Br1, Br2) begin
		if((IntEnOP(5 downto 1) = "01111") AND (Br1 = "111") AND
		  (Br2 = "111")) then
			Int_Sel <= '1';
		else
			Int_Sel <= '0';
		end if;
	end process;

	-- Data Flip-flop for saving Interrupt Flag.
	E_Int_Step : process begin
		wait until CLK 'EVENT AND CLK = '0';
			E_Int_Curr <= E_Int_Next;
	end process;

	-- Set BG1 and BG2 to 1 if DO and EX stage not decoding and executing \
	-- branch instruction.
	Branch_Decoder : process(Br1, Br2) begin
		if(Br1 = "111") then
			BG1 <= '1';
		else
			BG1 <= '0';
		end if;

		if(Br2 = "111") then
			BG2 <= '1';
		else
			BG2 <= '0';
		end if;
	end process;

-- Interrrupt is allowed if:
-- - Interrupt request occur.
-- - Interrupt is Enable (using Enable Interrupt (EI) and Disable Interrupt \
--   (DI)).
-- - IF stage is not fetching Branch/Jump instruction. Because all MSB of \
--   branch instruction OpCode is 1 or IntEnOP(5)=1 so just compare this bit \
--   to know IF stage still fetching branch instruction or not.
-- - DO stage is not decoding Branch/Jump instruction.
-- - EX stage is not executing Branch/Jump instruction.
-- - EX stage is not read/write from/to memory or external device. Interrupt \
--   use Data Address as it's interrupt address to specify the specific \
--   device that doing interrupt request.
-- - IF stage is not fetching EI and DI instruction.

	Int <= IntREQ AND E_Int_Curr AND (NOT IntEnOP(5)) AND BG1 AND BG2 AND
	       (NOT MW) AND (NOT MR) AND (NOT Int_Sel);

end Behavioral;
