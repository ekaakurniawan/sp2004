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

-- Register File 32x32 using DP_RAM
-- --------------------------------
--
--	Hierarchy  ==>	# register_file_DPRAM
--			|
--			+-> # RAM16X1D_1 (Library)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Register_File_DPRAM is
	port (	AA, BA, DA : in STD_LOGIC_vector(4 downto 0);
		D_Data : in std_logic_vector(31 downto 0);
		CLK, LD : in STD_LOGIC;
		A_Data, B_Data : out STD_LOGIC_vector(31 downto 0)
	);
end Register_File_DPRAM;

architecture Behavioral of Register_File_DPRAM is

	component RAM16X1D_1

		generic (INIT: bit_vector := X"16");

		port (	DPO : out STD_ULOGIC;
			SPO : out STD_ULOGIC;
			A0 : in STD_ULOGIC;
			A1 : in STD_ULOGIC;
			A2 : in STD_ULOGIC;
			A3 : in STD_ULOGIC;
			D : in STD_ULOGIC;
			DPRA0 : in STD_ULOGIC;
			DPRA1 : in STD_ULOGIC;
			DPRA2 : in STD_ULOGIC;
			DPRA3 : in STD_ULOGIC;
			WCLK : in STD_ULOGIC;
			WE : in STD_ULOGIC);
	end component;

	signal LD0, LD1 : std_logic;
	signal A_Data_tmp0, A_Data_tmp1, B_Data_tmp0, B_Data_tmp1 :
	       std_logic_vector(31 downto 0);

begin
	-- Only RAM16x1D_1 (16-Deep by 1-Wide Static Dual Port Synchronous \
	-- RAM with Negative-Edge Clock) that support for Xilinx Spartan 2.
	-- Using Negative-Edge Clock for Read-after-Write Memory System.
	-- In writing process, se LD0 to select the first 16 and LD1 to the \
	-- second.
	LD0 <= LD AND (NOT DA(4));
	LD1 <= LD AND DA(4);

	-- First 16-deep by 32-wide for Operand A.
	RAM16X1D_1_16A_0  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(0),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(0),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_1  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(1),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(1),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_2  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(2),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(2),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_3  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(3),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(3),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_4  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(4),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(4),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_5  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(5),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(5),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_6  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(6),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(6),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_7  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(7),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(7),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_8  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(8),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(8),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_9  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(9),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(9),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_10 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(10), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(10), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_11 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(11), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(11), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_12 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(12), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(12), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_13 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(13), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(13), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_14 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(14), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(14), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_15 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(15), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(15), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_16 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(16), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(16), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_17 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(17), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(17), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_18 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(18), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(18), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_19 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(19), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(19), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_20 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(20), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(20), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_21 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(21), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(21), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_22 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(22), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(22), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_23 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(23), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(23), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_24 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(24), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(24), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_25 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(25), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(25), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_26 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(26), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(26), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_27 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(27), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(27), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_28 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(28), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(28), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_29 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(29), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(29), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_30 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(30), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(30), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16A_31 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp0(31), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(31), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD0);
	-- Second 16-deep by 32-wide for Operand A.
	RAM16X1D_1_32A_0  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(0),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(0),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_1  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(1),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(1),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_2  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(2),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(2),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_3  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(3),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(3),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_4  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(4),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(4),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_5  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(5),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(5),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_6  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(6),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(6),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_7  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(7),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(7),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_8  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(8),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(8),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_9  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(9),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(9),  DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_10 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(10), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(10), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_11 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(11), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(11), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_12 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(12), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(12), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_13 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(13), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(13), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_14 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(14), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(14), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_15 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(15), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(15), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_16 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(16), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(16), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_17 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(17), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(17), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_18 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(18), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(18), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_19 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(19), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(19), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_20 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(20), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(20), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_21 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(21), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(21), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_22 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(22), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(22), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_23 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(23), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(23), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_24 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(24), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(24), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_25 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(25), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(25), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_26 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(26), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(26), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_27 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(27), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(27), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_28 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(28), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(28), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_29 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(29), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(29), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_30 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(30), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(30), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32A_31 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => A_Data_tmp1(31), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(31), DPRA0 => AA(0), DPRA1 => AA(1), DPRA2 => AA(2), DPRA3 => AA(3), WCLK => CLK, WE => LD1);

	-- First 16-deep by 32-wide for Operand B.
	RAM16X1D_1_16B_0  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(0),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(0),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_1  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(1),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(1),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_2  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(2),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(2),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_3  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(3),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(3),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_4  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(4),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(4),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_5  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(5),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(5),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_6  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(6),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(6),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_7  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(7),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(7),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_8  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(8),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(8),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_9  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(9),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(9),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_10 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(10), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(10), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_11 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(11), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(11), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_12 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(12), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(12), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_13 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(13), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(13), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_14 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(14), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(14), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_15 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(15), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(15), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_16 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(16), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(16), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_17 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(17), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(17), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_18 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(18), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(18), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_19 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(19), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(19), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_20 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(20), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(20), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_21 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(21), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(21), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_22 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(22), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(22), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_23 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(23), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(23), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_24 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(24), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(24), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_25 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(25), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(25), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_26 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(26), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(26), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_27 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(27), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(27), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_28 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(28), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(28), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_29 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(29), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(29), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_30 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(30), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(30), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	RAM16X1D_1_16B_31 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp0(31), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(31), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD0);
	-- Second 16-deep by 32-wide for Operand B.
	RAM16X1D_1_32B_0  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(0),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(0),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_1  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(1),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(1),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_2  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(2),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(2),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_3  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(3),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(3),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_4  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(4),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(4),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_5  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(5),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(5),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_6  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(6),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(6),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_7  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(7),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(7),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_8  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(8),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(8),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_9  : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(9),  A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(9),  DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_10 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(10), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(10), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_11 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(11), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(11), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_12 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(12), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(12), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_13 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(13), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(13), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_14 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(14), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(14), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_15 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(15), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(15), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_16 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(16), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(16), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_17 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(17), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(17), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_18 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(18), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(18), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_19 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(19), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(19), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_20 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(20), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(20), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_21 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(21), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(21), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_22 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(22), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(22), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_23 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(23), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(23), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_24 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(24), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(24), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_25 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(25), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(25), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_26 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(26), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(26), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_27 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(27), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(27), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_28 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(28), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(28), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_29 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(29), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(29), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_30 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(30), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(30), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);
	RAM16X1D_1_32B_31 : RAM16X1D_1 generic map (INIT => X"16") port map (DPO => B_Data_tmp1(31), A0 => DA(0), A1 => DA(1), A2 => DA(2), A3 => DA(3), D => D_Data(31), DPRA0 => BA(0), DPRA1 => BA(1), DPRA2 => BA(2), DPRA3 => BA(3), WCLK => CLK, WE => LD1);

	-- Multiplexer used when get the data from register, to select \
	-- between first 16 or second 16.
	process(AA(4),BA(4),A_Data_tmp0,A_Data_tmp1,B_Data_tmp0,B_Data_tmp1)
	begin
		-- Multiplexer for Operand A
		if(AA = "00000") then
			A_Data <= X"00000000"; -- Register 0 (R0) return zero
		else
			if(AA(4) = '0') then
				A_Data <= A_Data_tmp0; -- First 16 register
			else
				A_Data <= A_Data_tmp1; -- Second 16 register
			end if;
		end if;

		-- Multiplexer for Operand B
		if(BA = "00000") then
			B_Data <= X"00000000"; -- Register 0 (R0) return zero
		else
			if(BA(4) = '0') then
				B_Data <= B_Data_tmp0; -- First 16 register
			else
				B_Data <= B_Data_tmp1; -- Second 16 register
			end if;
		end if;
	end process;

end Behavioral;
