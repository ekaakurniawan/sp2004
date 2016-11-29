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

-- Register_File_Gab_DF : Register File + Constant Unit + MUX_A + MUX_B
-- --------------------
--
--	Hierarchy  ==>	# register_file_gab_DF
--			|
--			+-> # const_unit
--			|
--			+-> # register_file_DPRAM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Register_File_Gab_DF is
    Port ( D_data, D_data_DF, PC_1 : in std_logic_vector(31 downto 0);
	   Imm : in std_logic_vector(15 downto 0);
	   AA, BA, DA : in std_logic_vector(4 downto 0);
	   MA, MB, HA, HB, CS, LD, CLK : in std_logic;
	   Bus_A, Bus_B : out std_logic_vector(31 downto 0));
end Register_File_Gab_DF;

architecture Behavioral of Register_File_Gab_DF is

	component Register_File_DPRAM
	 	Port (  D_data : in std_logic_vector(31 downto 0);
			DA, AA, BA : in std_logic_vector(4 downto 0);
			LD, CLK : in std_logic;
			A_data, B_data : out std_logic_vector(31 downto 0));
	end component;

	component Const_Unit
    		Port (  Imm : in std_logic_vector(15 downto 0);
			CS : in std_logic;
			Const : out std_logic_vector(31 downto 0));
	end component;

	signal A_data, B_data, Const : std_logic_vector(31 downto 0);
	signal MAtmp, MBtmp : std_logic_vector(1 downto 0);

begin
	-- Register File Component
	register_file_PM : Register_File_DPRAM port map (D_data=>D_data,
	                   DA=>DA, AA=>AA, BA=>BA, LD=>LD, CLK=>CLK,
	                   A_data=>A_data, B_data=>B_data);

	-- Constant Unit Component
	constant_unit_PM : Const_Unit port map (Imm=>Imm, CS=>CS,
	                   Const=>Const);

	-- Selector for Mux_A and MUX_B with signal HA and HB from Data \
	-- Dependency Detector component.
	MAtmp <= HA & MA;
	MBtmp <= HB & MB;

	-- Multiplexer A (MUX_A) select between Oparand A, PC, and Function \
	-- Unit output for Data Forwarding.
	MUX_A : process(MAtmp, PC_1, A_data, D_data_DF) begin
		if    (MAtmp = "00") then
			Bus_A <= A_data;
		elsif (MAtmp = "01") then
			Bus_A <= PC_1;
		else
			BUS_A <= D_data_DF;
		end if;
	end process;

	-- Multiplexer B (MUX_B) select between Oparand B, Immediate, and \
	-- Function Unit output for Data Forwarding.
	MUX_B : process(MBtmp, Const, B_data, D_data_DF) begin
		if    (MBtmp = "00") then
			Bus_B <= B_data;
		elsif (MBtmp = "01") then
			Bus_B <= Const; -- Immediate from Constant Unit
		else
			BUS_B <= D_data_DF;
		end if;
	end process;

end Behavioral;
