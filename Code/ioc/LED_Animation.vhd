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

-- LED Animation (I/O Device Controler)
-- ------------------------------------
--
-- Hierarchy ==> # Led _Animation
--               |
--               +-> # BUFE8
--               |   |
--               |   +-> # BUFE
--               |
--               +-> # BUFE3
--                   |
--                   +-> # BUFE
--
--  Button   Function   IntADD
-- ----------------------------
--   Btn0     RESET      ---
--   Btn1   Interrupt1   001
--   Btn2   Interrupt2   010
--
--  Data_Add(7)	Data_Add(2:0) WE         Operation
-- -------------------------------------------------------
--      1           000       0   Read 8 bits form switch
--      1           000       1   Write 8 bits to LED LSB
--      1           001       1   Write 8 bits to LED LSB

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Animasi_LED is
	port(	Data : inout std_logic_vector(7 downto 0);
		Data_Add : inout std_logic_vector(3 downto 0);
		CLK, WE : in std_logic;
		IntACK : in std_logic;
		RESET : inout std_logic;
		IntREQ : out std_logic;

		LED : out std_logic_vector(15 downto 0);
		Btn0, Btn1, Btn2 : in std_logic;
		Switch : in std_logic_vector(7 downto 0)
	);
end Animasi_LED;

architecture Behavioral of Animasi_LED is

	component BUFE8
		port(	E : in std_logic;
			I : in std_logic_vector(7 downto 0);
			O : out std_logic_vector(7 downto 0)
		);
	end component;

	component BUFE3
		port(	E : in std_logic;
			I : in std_logic_vector(2 downto 0);
			O : out std_logic_vector(2 downto 0)
		);
	end component;

	signal WE_tmp : std_logic;
	signal IntADD : std_logic_vector(2 downto 0);
	signal ADD : std_logic_vector(3 downto 0);
	signal IO_Data_Out, IO_Data_In : std_logic_vector(7 downto 0);

begin

	-- Three State Buffer (TSB) for Data Bus. Data_Add(3) is \
	-- Data_Add_RISC(7) that select between memory and IO device.
	WE_tmp <= (NOT WE) AND Data_Add(3);
	TBuf_Data : BUFE8 port map (E=>WE_tmp, I=>IO_Data_Out, O=>Data);
	IO_Data_In <= Data;

	-- Every Button 2 (Btn2) pushed, value (data) from switch save at \
	-- Data Flip-flop (D-FF) (synchronous).
	Switch_Input : process(Switch, Btn2) begin
		if (Btn2'EVENT AND Btn2 = '1') then
			IO_Data_Out <= Switch;
		end if;
	end process;

	-- Three State Buffer (TSB) for Address Bus.
	TBuf_IntADD : BUFE3 port map (E=>IntACK, I=>IntADD,
	              O=>Data_Add(2 downto 0));
	ADD <= Data_Add;

	-- LED Controler. Put the data at 8 bits LSB or MSB of 16 LEDs. The \
	-- LED is active LOW.
	LED_Ctrl : process(WE, ADD, CLK, IO_Data_In, RESET) begin
		if(WE = '1' AND ADD = "1000") then
			if(CLK'EVENT AND CLK = '0') then
				LED(7 downto 0) <= NOT(IO_Data_In);
			end if;
		elsif(WE = '1' AND ADD = "1001") then
			if(CLK'EVENT AND CLK = '0') then
				LED(15 downto 8) <= NOT(IO_Data_In);
			end if;
		end if;

		if(RESET = '1') then
			LED(15 downto 0) <= (others => '1');
		end if;
	end process;

	-- Intertupt Controler
	Interrupt_Request : process(Btn1, Btn2) begin
		if((Btn1 = '1') OR (Btn2 = '1')) then
			IntREQ <= '1';
		else
			IntREQ <= '0';
		end if;
	end process;

	-- Interrupt Address for each interrupt type.
	Int_Ctrl : process(Btn1, Btn2, IntACK) begin
		if((Btn1 = '1') AND (IntACK = '1')) then
			IntADD <= "001";
		elsif((Btn2 = '1') AND (IntACK = '1')) then
			IntADD <= "010";
		else
			IntADD <= "000";
		end if;
	end process;

	RESET <= Btn0;

end Behavioral;
