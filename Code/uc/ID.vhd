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

-- Instruction Decoder
-- -------------------
--
--	Hierarchy  ==>	# ID

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ID is
	Port (	IR_Conv : in std_logic_vector(20 downto 0);
		AA, BA, DA : out std_logic_vector(4 downto 0);
		FS : out std_logic_vector(3 downto 0);
		BS : out std_logic_vector(2 downto 0);
		LS : out std_logic_vector(1 downto 0);
		MA, MB, MD, LD, MW, CS : out std_logic);
end ID;

architecture Behavioral of ID is

	signal OPCODE : std_logic_vector(5 downto 0);

	-- <DEC_OPCODE>
	--	  LD   MD        BS        MW     LS             FS          MB   MA   CS
	--	|----|----|--------------|----|--------|-------------------|----|----|----|
	--	  14   13   12   11   10   09   08  07   06   05   04   03   02   01   00
	signal DEC_OPCODE : std_logic_vector(14 downto 0);


begin

	OPCODE <= IR_Conv(20 downto 15);
	DA <= IR_Conv(14 downto 10);
	AA <= IR_Conv(9 downto 5);
	BA <= IR_Conv(4 downto 0);

	process (OPCODE) begin
		if    (OPCODE = "000000") then DEC_OPCODE <= B"1_0_111_0_00_0000_0_0_0"; -- ADD   RD, RA, RB	Addition
		elsif (OPCODE = "000001") then DEC_OPCODE <= B"1_0_111_0_00_0000_1_0_1"; -- ADI   RD, RA, Im	Add Immediate Sign
		elsif (OPCODE = "000010") then DEC_OPCODE <= B"1_0_111_0_00_0000_1_0_0"; -- ADIU  RD, RA, Im	Add Immediate Unsign
		elsif (OPCODE = "000011") then DEC_OPCODE <= B"1_0_111_0_00_0001_0_0_0"; -- SUB   RD, RA, RB	Subtract
		elsif (OPCODE = "000100") then DEC_OPCODE <= B"1_0_111_0_00_0001_1_0_1"; -- SUI   RD, RA, Im	Sub Immediate Sign
		elsif (OPCODE = "000101") then DEC_OPCODE <= B"1_0_111_0_00_0001_1_0_0"; -- SUIU  RD, RA, Im	Sub Immediate Unsign

		elsif (OPCODE = "000110") then DEC_OPCODE <= B"1_0_111_0_00_0100_0_0_0"; -- AND   RD, RA, RB	AND
		elsif (OPCODE = "000111") then DEC_OPCODE <= B"1_0_111_0_00_0100_1_0_0"; -- ANDI  RD, RA, Im	AND Immdiate
		elsif (OPCODE = "001000") then DEC_OPCODE <= B"1_0_111_0_00_0101_0_0_0"; -- OR    RD, RA, RB	OR
		elsif (OPCODE = "001001") then DEC_OPCODE <= B"1_0_111_0_00_0101_1_0_0"; -- ORI   RD, RA, Im	OR Immdiate
		elsif (OPCODE = "001010") then DEC_OPCODE <= B"1_0_111_0_00_0110_0_0_0"; -- XOR   RD, RA, RB	XOR
		elsif (OPCODE = "001011") then DEC_OPCODE <= B"1_0_111_0_00_0110_1_0_0"; -- XORI  RD, RA, Im	XOR Immediate
		elsif (OPCODE = "001100") then DEC_OPCODE <= B"1_0_111_0_00_0111_0_0_0"; -- NOR   RD, RA, RB	NOR
		elsif (OPCODE = "001101") then DEC_OPCODE <= B"1_0_111_0_00_0111_1_0_0"; -- NORI  RD, RA, Im	NOR Immediate

		elsif (OPCODE = "001110") then DEC_OPCODE <= B"1_0_111_0_00_1000_1_0_0"; -- SLR   RD, RA, Im	Shift Logical Right
		elsif (OPCODE = "001111") then DEC_OPCODE <= B"1_0_111_0_00_1000_0_0_0"; -- SLRV  RD, RA, RB	Shift Logical Right Variable
		elsif (OPCODE = "010000") then DEC_OPCODE <= B"1_0_111_0_00_1001_1_0_0"; -- SLL   RD, RA, Im	Shift Logical Left
		elsif (OPCODE = "010001") then DEC_OPCODE <= B"1_0_111_0_00_1001_0_0_0"; -- SLLV  RD, RA, RB	Shift Logical Left Variable
		elsif (OPCODE = "010010") then DEC_OPCODE <= B"1_0_111_0_00_1010_1_0_0"; -- SAR   RD, RA, Im	Shift Arithmetic Right
		elsif (OPCODE = "010011") then DEC_OPCODE <= B"1_0_111_0_00_1010_0_0_0"; -- SARV  RD, RA, RB	Shift Arithmetic Right Variable

		elsif (OPCODE = "010100") then DEC_OPCODE <= B"1_0_111_0_00_1111_1_0_0"; -- LUI   RD, Im	Load Upper Immediate
		elsif (OPCODE = "010101") then DEC_OPCODE <= B"1_0_111_0_00_0010_0_1_0"; -- LA    RD		Load Address

		elsif (OPCODE = "010110") then DEC_OPCODE <= B"0_0_111_1_00_0010_0_0_0"; -- SB    RA, RB	Store Byte
		elsif (OPCODE = "010111") then DEC_OPCODE <= B"0_0_111_1_01_0010_0_0_0"; -- SH    RA, RB	Store Half Word
		elsif (OPCODE = "011000") then DEC_OPCODE <= B"0_0_111_1_10_0010_0_0_0"; -- SW    RA, RB	Store Word
		elsif (OPCODE = "011001") then DEC_OPCODE <= B"1_1_111_0_00_0010_0_0_0"; -- LB    RD, RA	Load Byte
		elsif (OPCODE = "011010") then DEC_OPCODE <= B"1_1_111_0_01_0010_0_0_0"; -- LH    RD, RA	Load Half Word
		elsif (OPCODE = "011011") then DEC_OPCODE <= B"1_1_111_0_10_0010_0_0_0"; -- LW    RD, RA	Load Word

		elsif (OPCODE = "011100") then DEC_OPCODE <= B"1_0_111_0_00_1101_0_0_0"; -- SLT   RD, RA, RB	Set if Less Then
		elsif (OPCODE = "011101") then DEC_OPCODE <= B"1_0_111_0_00_1101_1_0_1"; -- SLTI  RD, RA, Im	Set if Less Then Immediate

		elsif (OPCODE = "011110") then DEC_OPCODE <= B"0_0_111_0_00_0010_0_0_0"; -- DI			Disable Interrupt
		elsif (OPCODE = "011111") then DEC_OPCODE <= B"0_0_111_0_00_0010_0_0_0"; -- EI			Enable Interrupt

		elsif (OPCODE = "100000") then DEC_OPCODE <= B"0_0_010_0_00_0001_0_0_0"; -- BE   RA, RB, Im	Branch on Equal
		elsif (OPCODE = "100001") then DEC_OPCODE <= B"0_0_000_0_00_0001_0_0_0"; -- BH   RA, RB, Im	Branch on Higer Then
		elsif (OPCODE = "100010") then DEC_OPCODE <= B"0_0_001_0_00_0001_0_0_0"; -- BHE  RA, RB, Im	Branch on Higer Then Equal
		elsif (OPCODE = "100011") then DEC_OPCODE <= B"0_0_011_0_00_0001_0_0_0"; -- BG   RA, RB, Im	Branch on Greater Then
		elsif (OPCODE = "100100") then DEC_OPCODE <= B"0_0_100_0_00_0001_0_0_0"; -- BGE  RA, RB, Im	Branch on Greater Then Equal
		elsif (OPCODE = "100101") then DEC_OPCODE <= B"0_0_101_0_00_0010_0_0_0"; -- JMP  Target		Jump
		elsif (OPCODE = "100110") then DEC_OPCODE <= B"1_0_101_0_00_0010_0_1_0"; -- JL   Terget		Jump and Link
                elsif (OPCODE = "100111") then DEC_OPCODE <= B"0_0_110_0_00_0010_0_0_0"; -- JR   RB		Jump Register
                elsif (OPCODE = "101000") then DEC_OPCODE <= B"1_0_110_0_00_0010_0_1_0"; -- JRL  RB		Jump Register and Link

		else			       DEC_OPCODE <= B"0_0_000_0_00_0000_0_0_0";
		end if;
	end process;

	LD <= DEC_OPCODE(14);
	MD <= DEC_OPCODE(13);
	BS <= DEC_OPCODE(12 downto 10);
	MW <= DEC_OPCODE(9);
	LS <= DEC_OPCODE(8 downto 7);
	FS <= DEC_OPCODE(6 downto 3);
	MB <= DEC_OPCODE(2);
	MA <= DEC_OPCODE(1);
	CS <= DEC_OPCODE(0);

end Behavioral;
