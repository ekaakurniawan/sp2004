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

-- uC (Micro Controller)
-- --------------------
--
--	Hierarchy  ==>	# uC
--			|
--			+-> # RISC
--			|
--			+-> # ROM
--			|
--			+-> # RAM32x32S_1
--			|   |
--                      |   +-> # RAM16x8S_1
--                      |       |
--                      |       +-> # RAM16x1S_1 (Library)
--			|
--			+-> # BUFE3
--			    |
--			    +-> # BUFE (Library)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uc is
    Port (	Data : inout std_logic_vector(31 downto 0);
    		Data_Add : inout std_logic_vector(31 downto 0);

    		Inst : in std_logic_vector(31 downto 0);
    		Inst_Add : inout std_logic_vector(31 downto 0);

		-- GCLK: Global Clock from Oscillator
    		GCLK, RESET : in std_logic;

    		-- Interrupt Request(IntREQ) and Interrupt Acknowledge(IntACK)
		IntREQ : in std_logic;
    		IntACK : out std_logic;

    		-- Sync: Clock Synchronization with other Device
		Sync : out std_logic;
		-- Memory Write(MW) and Memory Read(MR)
    		MW : inout std_logic;
    		MR : inout std_logic);
end uc;

architecture Behavioral of uc is

	component RISC
	    Port ( Inst : in std_logic_vector(31 downto 0);
	           Inst_Add : out std_logic_vector(31 downto 0);

	           BSel : out std_logic_vector(3 downto 0);
	           Data : inout std_logic_vector(31 downto 0);
	           Data_Add : out std_logic_vector(31 downto 0);

		   CLK, RESET, IntREQ : in std_logic;
		   IntACK : out std_logic;
		   IntADD : in std_logic_vector(2 downto 0);

	           MW : inout std_logic;
	           MR : inout std_logic);
	end component;

	component ROM
	    Port ( Add_In : in std_logic_vector(7 downto 0);
	           Data_Out : out std_logic_vector(31 downto 0));
	end component;

	component RAM32x32S_1
		port(	WE, WCLK, CS : in std_logic;
			-- BSel = Byte Select
			BSel : in std_logic_vector(3 downto 0);
			A : in std_logic_vector(4 downto 0);
			D : inout std_logic_vector(31 downto 0)
		);
	end component;

	component BUFE3
		port(	E : in std_logic;
			I : in std_logic_vector(2 downto 0);
			O : out std_logic_vector(2 downto 0)
		);
	end component;

	signal Data_Add_RISC : std_logic_vector(31 downto 0);

	signal CLK : std_logic;
	signal CTR : std_logic_vector(1 downto 0);

	signal BSel : std_logic_vector(3 downto 0);

	signal IntADD : std_logic_vector(2 downto 0);

	signal MRW : std_logic;

	signal Inst_Internal : std_logic_vector(31 downto 0);
	signal Inst_RISC : std_logic_vector(31 downto 0);

begin
	-- RISC Component
	RISC_uP_PM : RISC port map (IntREQ=>IntREQ, IntACK=>IntACK,
	             Inst=>Inst_RISC, Inst_Add=>Inst_Add, BSel=>BSel,
	             Data=>Data, Data_Add=>Data_Add_RISC, CLK=>CLK,
	             RESET=>RESET, IntADD=>IntADD, MW=>MW, MR=>MR);

	-- Clock divide by 4 (12.5MHz), because clock from D2 board is 50Mhz \
	-- and maximum frekuency for this design is 24.781MHz.
	two_bit_counter : process(GCLK, CTR, RESET) begin
		if(RESET = '1') then
			CTR <= "00";
		elsif(GCLK'EVENT AND GCLK = '1') then
			CTR <= CTR + 1;
		end if;
	end process;

	CLK <= CTR(1);
	-- Clock Synchronization is a same clock with internal clock.
	Sync <= CTR(1);

	-- If Memory Read or Write occur, Three State Buffer (TSB) pass the \
	-- Data Address (Data_Add) from RISC processor to external device. \
	-- Its because when Interrupt occure, Interrupt Address (IntAdd) also \
	-- use this line so TSB must be High Impedance.
	MRW <= MR OR MW;
	TBuf_IntADD : BUFE3 port map (E=>MRW, I=>Data_Add_RISC(2 downto 0),
	              O=>Data_Add(2 downto 0));
	-- Because only 3 bits that used together between Data_Add and \
	-- Int_Add so just pass the 29 bits.
	Data_Add(31 downto 3) <= Data_Add_RISC(31 downto 3);

	-- 3 bit Interrupt Address (IntAdd) take from Data_add(2:0).
	IntADD <= Data_Add(2 downto 0);

	-- ROM component
	ROM_PM : ROM port map (Add_In=>Inst_Add(7 downto 0),
	         Data_Out=>Inst_Internal);

	-- Using internal ROM only,  made ISE compiler know what the design \
	-- do and the compiler throw the design that unused. If you want to \
	-- see how many Slice and Time Propagation Delay that used in a whole \
	-- design, say this to compiler "Some instruction is get from \
	-- external ROM and you must build up all design for unpredictable \
	-- instruction".
	Inst_Internal_External : process(Inst_Add(8), Inst, Inst_Internal) begin
		if(Inst_Add(31) = '0') then
			Inst_RISC <= Inst_internal;
		else
			Inst_RISC <= Inst; -- Inst is External Instruction.
		end if;
	end process;

	-- RAM component
	SRAM : RAM32x32S_1 port map (WE=>MW, WCLK=>CLK, CS=>Data_Add_RISC(7),
	       BSel=>BSel, A=>Data_Add_RISC(6 downto 2), D=>Data);

end Behavioral;
