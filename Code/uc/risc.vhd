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

-- RISC (Reduce Instruction Set Computer)
-- --------------------------------------
--
--	Hierarchy ==>	# RISC
--			|
--			+-> # Function_Unit
--			|   |
--			|   +-> # ALU
--			|   |   |
--			|   |   +-> # addsub32_lib_par
--			|   |   |   |
--			|   |   |   +-> # adder32_lib
--			|   |   |
--			|   |   +-> # LogicUnit32
--			|   |
--			|   +-> # BarrelShift32_2
--			|   |
--			|   +-> # LUI
--			|
--			+-> # register_file_gab_DF
--			|   |
--			|   +-> # const_unit
--			|   |
--			|   +-> # register_file_DPRAM
--			|       |
--			|       +-> # RAM16X1D_1 (Library)
--			|
--			+-> # branch_ctrl
--			|
--			+-> # Data_Dependency_Detector
--			|
--			+-> # ID
--			|
--			+-> # Interrupt_Ctrl
--			|
--			+-> # reg1x1
--			|
--			+-> # reg1x2
--			|
--			+-> # reg1x3
--			|
--			+-> # reg1x4
--			|
--			+-> # reg1x5
--			|
--			+-> # reg1x26
--			|
--			+-> # reg1x32
--			|
--			+-> # BUFE32
--			    |
--			    +-> #BUFE (Library)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

------------------------------------------------------------- Port Declaration

entity RISC is
    Port ( -- Instruction
    	   Inst : in std_logic_vector(31 downto 0);
    	   -- Instruction Address
           Inst_Add : out std_logic_vector(31 downto 0);

           -- Byte Select for Load/Store Instruction
           BSel : out std_logic_vector(3 downto 0);
           -- Data
           Data : inout std_logic_vector(31 downto 0);
           -- Data Address
           Data_Add : out std_logic_vector(31 downto 0);

           -- Interrupt Request
	   IntREQ : in std_logic;
	   -- Interrupt Acknowledge
	   IntACK : out std_logic;
	   -- Interrupt Address
	   IntADD : in std_logic_vector(2 downto 0);

	   -- Clock
	   CLK : in std_logic;
	   RESET : in std_logic;

           -- Memory Write
           MW : inout std_logic;
           -- Memory Read
           MR : inout std_logic
         );
end RISC;

architecture Behavioral of RISC is

-------------------------------------------------------- Component Declaration

	-- Instruction Decoder Component
	component ID
		Port (	IR_Conv : in std_logic_vector(20 downto 0);
			AA, BA, DA : out std_logic_vector(4 downto 0);
			FS : out std_logic_vector(3 downto 0);
			BS : out std_logic_vector(2 downto 0);
			LS : out std_logic_vector(1 downto 0);
			MA, MB, MD, LD, MW, CS : out std_logic);
	end component;

	-- Combination component of Register File, Constant unit, \
	-- Mltiplexer A (MUX_A), and Multiplexer B (MUX_B).
	component Register_File_Gab_DF
    		Port (	D_data, D_data_DF, PC_1 :
    			   in std_logic_vector(31 downto 0);
    			Imm : in std_logic_vector(15 downto 0);
    			AA, BA, DA : in std_logic_vector(4 downto 0);
			MA, MB, HA, HB, CS, LD, CLK : in std_logic;
    			Bus_A, Bus_B : out std_logic_vector(31 downto 0));
	end component;

	component Function_Unit
		Port (	A, B : in std_logic_vector(31 downto 0);
			FS : in std_logic_vector(3 downto 0);
			F : out std_logic_vector(31 downto 0);
			Cout, Zero, N, V : out std_logic);
	end component;

	component Branch_Ctrl
		port (	BS : in std_logic_vector(2 downto 0);
			Zero, Cout, N, V : in std_logic;
			MC : out std_logic_vector(1 downto 0));
	end component;

	component Data_Dependency_Detector
		port(	MA, MB, LD : in std_logic;
			AA, BA, DA : in std_logic_vector(4 downto 0);
			HA, HB : out std_logic);
	end component;

	component Interrupt_Ctrl
		port(	CLK : in std_logic;
			IntREQ, MW, MR : in std_logic;
			IntEnOP : in std_logic_vector(5 downto 0);
			Br1, Br2 : in std_logic_vector(2 downto 0);
			Int : out std_logic);
	end component;

	-- reg1x32 (1-Deep by 32 Wide with Positive Edge Clock Register), \
	-- reg1x26, reg1x5, reg1x4, reg1x3, reg1x2, and reg1x1 used for \
	-- store the value in pipeline process.

	component reg1x32
    		Port (  reg_in : in std_logic_vector(31 downto 0);
			reg_out : out std_logic_vector(31 downto 0);
			CLK : in std_logic;
			RESET : in std_logic);
	end component;

	component reg1x26
    		Port (  reg_in : in std_logic_vector(25 downto 0);
			reg_out : out std_logic_vector(25 downto 0);
			CLK : in std_logic;
			RESET : in std_logic);
	end component;

	component reg1x5
    		Port (  reg_in : in std_logic_vector(4 downto 0);
			reg_out : out std_logic_vector(4 downto 0);
			CLK : in std_logic;
			RESET : in std_logic);
	end component;

	component reg1x4
    		Port (  reg_in : in std_logic_vector(3 downto 0);
			reg_out : out std_logic_vector(3 downto 0);
			CLK : in std_logic;
			RESET : in std_logic);
	end component;

	component reg1x3
    		Port (  reg_in : in std_logic_vector(2 downto 0);
			reg_out : out std_logic_vector(2 downto 0);
			CLK : in std_logic;
			RESET : in std_logic);
	end component;

	component reg1x2
    		Port (  reg_in : in std_logic_vector(1 downto 0);
			reg_out : out std_logic_vector(1 downto 0);
			CLK : in std_logic;
			RESET : in std_logic);
	end component;

	component reg1x1
    		Port (  reg_in : in std_logic;
			reg_out : out std_logic;
			CLK : in std_logic;
			RESET : in std_logic);
	end component;

	-- 32 bits Three State Buffer with Positive Clock Edge, used for \
	-- control data in/out stream between RISC Processor and external \
	-- device.
	component BUFE32
		port(	E : in std_logic;
			I : in std_logic_vector(31 downto 0);
			O : out std_logic_vector(31 downto 0)
		);
	end component;

----------------------------------------------------------- Signal Declaration

	-- Data Dependency's Signals
	signal Bus_D_DF : std_logic_vector(31 downto 0);
	signal HA, HB : std_logic;

	-- Branch Hazard's Signals
	signal BP, LD_In_1_BH, MW_In_BH : std_logic;
	signal BS_In_BH : std_logic_vector(2 downto 0);
	signal IR_In_BH : std_logic_vector(31 downto 0);

	-- Branch & Jump's Signal
	signal MC : std_logic_vector(1 downto 0);
	signal BS : std_logic_vector(2 downto 0);
	signal JA_R : std_logic_vector(25 downto 0);
	signal PC_In, BrA, JA, JRA : std_logic_vector(31 downto 0);

	-- Instruction Decoder's (ID) Signal
	signal AA, BA : std_logic_vector(4 downto 0);
	signal MA, MB, CS : std_logic;

	-- IF : Signals that used in IF pipeline stage.
	signal PC : std_logic_vector(31 downto 0);
	signal PC_1_In, PC_Inc, IR_In : std_logic_vector(31 downto 0);

	-- DO : Signals that used in DO pipeline stage.
	signal PC_1, IR, PC_2_In, Bus_A_In, Bus_B_In :
		  std_logic_vector(31 downto 0);
	signal DA_In_1 : std_logic_vector(4 downto 0);
	signal FS_In : std_logic_vector(3 downto 0);
	signal BS_In : std_logic_vector(2 downto 0);
	signal LS_In : std_logic_vector(1 downto 0);
	signal MD_In_1, LD_In_1, MW_In : std_logic;

	-- EX : Signals that used in EX pipeline stage.
	signal Bus_A, Bus_B, F_In, PC_2 : std_logic_vector(31 downto 0);
	signal FS : std_logic_vector(3 downto 0);
	signal DA_Out_1, DA_In_2 : std_logic_vector(4 downto 0);
	signal Zero, Cout, N, V, MD_Out_1, MD_In_2, LD_Out_1, LD_In_2 :
		  std_logic;

	-- Memory Control In/Out' (MCI/MCO) Signals
	signal LS : std_logic_vector(1 downto 0);
	signal DataTmpOut, DataTmpIn : std_logic_vector(31 downto 0);

	-- WB : Signals that used in WB pipeline stage.
	signal F, Bus_D, DataReg : std_logic_vector(31 downto 0);
	signal DA : std_logic_vector(4 downto 0);
	signal MD, LD : std_logic;

	-- Interrupt' Signals
	signal IntADD_1, PC_In_1, PC_1_In_1 : std_logic_vector(31 downto 0);
	signal Int : std_logic;

-------------------------------------------------------------------- B E G I N

begin

	-- Data Dependency with Data Forwarding (Data Dependency Detector and \
	-- Multiplexer D for Data Forwarding (MUX_D_DF)).

	Data_Dependency_Detector_PM : Data_Dependency_Detector port map
	   (MA=>MA, MB=>MB, AA=>AA, BA=>BA, LD=>LD_Out_1, DA=>DA_Out_1,
	   HA=>HA, HB=>HB);

	MUX_D_DF_Sel : process(MD_Out_1, F_In, DataTmpIn) begin
		if (MD_Out_1 = '0') then
			Bus_D_DF <= F_In;
		else
			Bus_D_DF <= DataTmpIn;
		end if;
	end process MUX_D_DF_Sel;

	-- Branch Prediction for Branch Hazard.

	BP <= MC(0) OR MC(1);

	-- Branch & Jump Control Component (Branch Control and Miltilexer C \
	-- (MUX_C)).

	Branch_Ctrl_PM : Branch_Ctrl port map (BS=>BS, Zero=>Zero, Cout=>Cout,
	   N=>N, V=>V, MC=>MC);

	MUX_C : process(MC, PC_Inc, BrA, JRA, JA) begin
		if    (MC = "00") then PC_In_1 <= PC_Inc;
		elsif (MC = "01") then PC_In_1 <= BrA;
		elsif (MC = "10") then PC_In_1 <= JA;
		else 		       PC_In_1 <= JRA;
		end if;
	end process;

	-- Interrupt Control Component.
	-- Shift the Interrupt Address (IntAdd) one step to Left or \
	-- Multiplication with two.
	IntADD_1 <= X"0000000" & IntADD & '0';

	-- Multipexer for Interrupt that select between next PC and Interrupt \
	-- Address (IntAdd).
	MUX_I_PC : process(Int, IntADD_1, PC_In_1) begin
		if(Int = '1') then
			PC_In <= IntADD_1;
		else
			PC_In <= PC_In_1;
		end if;
	end process;

	-- Multiplexer for Interrupt that select between PC and PC + 1.
	MUX_I_PC_1 : process(Int, PC, PC_1_In_1) begin
		if(Int = '1') then
			PC_1_In <= PC;
		else
			PC_1_In <= PC_1_In_1; -- PC + 1
		end if;
	end process;

	-- Multiplexer for Instruction Register (MUX_IR) that select beetwen:
	--  - NOP (No Poeration) Instruction = 00000000h
	--  - Instruction from Instruction Memory
	--  - Load Address (LA) Instruction that save current PC to Register \
	--    30 (R30):
	--       010101__11110__00000__00000__00000000000b = 57C00000h
	--         ^       ^
	--    (LA Inst.)  R30
	MUX_IR : process(BP, Int, IR_In_BH) begin
		if(Int = '0') then
			if(BP = '1') then
				IR_In <= X"00000000"; -- NOP
			else
				IR_In <= IR_In_BH; -- Inst. from Inst.Memory
			end if;
		else
			IR_In <= X"57C00000"; -- LA to R30
		end if;
	end process;

	-- Interrupt Control Component

	Interrupt_Control_PM : Interrupt_Ctrl port map (CLK=>CLK,
	   IntREQ=>IntREQ, MW=>MW, MR=>MR, IntEnOP=>Inst(31 downto 26),
	   Br1=>BS_In, Br2=>BS, Int=>Int);

	IntACK <= Int;

	-- IF : Process in IF pipeline stage.

	Inst_Add <= PC;
	PC_Inc <= PC + "1";
	PC_1_In_1 <= PC_Inc;
	IR_In_BH <= Inst;

	-- DO : Process in DO pipeline stage.

	PC_2_In <= PC_1;

	-- Instruction Decoder Component
	Instruction_Decoder_PM : ID port map (IR_Conv=>IR(31 downto 11),
	   LD=>LD_In_1_BH, DA=>DA_In_1, MD=>MD_In_1, BS=>BS_In_BH,
	   MW=>MW_In_BH, LS=>LS_In, FS=>FS_In, MA=>MA, MB=>MB, AA=>AA, BA=>BA,
	   CS=>CS);

	-- Avoid Control Hazard if Branch Prediction (BP) say that \
	-- Branch/Jump occur.
	Branch_Prediction : process(BP, LD_In_1_BH, BS_In_BH, MW_In_BH) begin
		if(BP = '1') then
			LD_In_1 <= '0'; -- Avoid change of Register File
			BS_In <= "111"; -- Avoid change of instruction stream
			MW_In <= '0';   -- Avoid change of external device
		else
			LD_In_1 <= LD_In_1_BH; -- Pass the (LD, BS, and MW) \
			BS_In <= BS_In_BH;     -- value from Instruction \
			MW_In <= MW_In_BH;     -- Decoder.
		end if;
	end process;

	-- Combination component of Register File, Constant unit, \
	-- Mltiplexer A (MUX_A), and Multiplexer B (MUX_B).
	Register_File_PM : Register_File_Gab_DF port map (D_data=>Bus_D,
	   D_data_DF=>Bus_D_DF , PC_1=>PC_1, Imm=>IR(15 downto 0), AA=>AA,
	   BA=>BA, DA=>DA, MA=>MA, MB=>MB, HA=>HA, HB=>HB, CS=>CS, LD=>LD,
	   CLK=>CLK, Bus_A=>Bus_A_In, Bus_B=>Bus_B_In);

	--EX : Process in IF pipeline stage.

	LD_In_2 <= LD_Out_1;
	DA_In_2 <= DA_Out_1;
	MD_In_2 <= MD_Out_1;



	-- Function Unit Component
	FunctionUnit_PM : Function_Unit port map (A=>Bus_A, B=>Bus_B, FS=>FS,
	   F=>F_In, Cout=>Cout, Zero=>Zero, N=>N, V=>V);

	-- Jump Register Address (JRA) take from Bus_B (Function Unit).
	JRA <= Bus_B;

	-- Branch Address (BrA) is relative from PC.
	-- BrA <= PC + (se || IR(25:21) || IR(10:0))
	BrA <= (PC_2) + (JA_R(25) & JA_R(25) & JA_R(25) & JA_R(25) & JA_R(25)
	                & JA_R(25) & JA_R(25) & JA_R(25) & JA_R(25) & JA_R(25)
	                & JA_R(25) & JA_R(25) & JA_R(25) & JA_R(25) & JA_R(25)
	                & JA_R(25) & JA_R(25 downto 21) & JA_R(10 downto 0));

	-- Jump Address (JA) is relative from PC.
	-- JA <= PC + (se || IR(25:0))
	JA <= (PC_2) + (JA_R(25) & JA_R(25) & JA_R(25) & JA_R(25) & JA_R(25)
	               & JA_R(25) & JA_R(25 downto 0));

	-- Three State Buffer to control Data In/Out stream.
	TS_Buffer_PM : BUFE32 port map (E=>MW, I=>DataTmpOut, O=>Data);

	-- Data Address (Data_Add) take from Bus_A (Function Unit).
	Data_Add(31 downto 0) <= Bus_A(31 downto 0);

	-- Memory Read (MR) signal to external device take from Multiplexer D
	-- (MD) signal because MD is equal to 1 if we want to read data from
	-- external device.
	MR <= MD_In_2;

	-- Byte Selector (BSel) decoder for Memory Control Out.
	MCO_sel : process(Bus_A, LS) begin
		if   (Bus_A(1) & Bus_A(0) & LS = "0000") then BSel <= "0001";
		elsif(Bus_A(1) & Bus_A(0) & LS = "0001") then BSel <= "0011";
		elsif(Bus_A(1) & Bus_A(0) & LS = "0010") then BSel <= "1111";
		elsif(Bus_A(1) & Bus_A(0) & LS = "0100") then BSel <= "0010";
		elsif(Bus_A(1) & Bus_A(0) & LS = "1000") then BSel <= "0100";
		elsif(Bus_A(1) & Bus_A(0) & LS = "1001") then BSel <= "1100";
		elsif(Bus_A(1) & Bus_A(0) & LS = "1100") then BSel <= "1000";
		else 					      BSel <= "0000";
		end if;
	end process;

	-- Multiplexer control of data positioning for Memory Control Out \
	-- (Store Instruction).
	MCO_MUX : process(Bus_A, Bus_B) begin
		if   ((Bus_A(1) = '1') AND (Bus_A(0) = '0')) then
			DataTmpOut(31 downto 24) <= Bus_B(15 downto 8);
		elsif((Bus_A(1) = '1') AND (Bus_A(0) = '1')) then
			DataTmpOut(31 downto 24) <= Bus_B(7 downto 0);
		else	DataTmpOut(31 downto 24) <= Bus_B(31 downto 24);
		end if;

		if(Bus_A(1) = '0') then
			DataTmpOut(23 downto 16) <= Bus_B(23 downto 16);
		else	DataTmpOut(23 downto 16) <= Bus_B(7 downto 0);
		end if;

		if(Bus_A(0) = '0') then
			DataTmpOut(15 downto 8) <= Bus_B(15 downto 8);
		else	DataTmpOut(15 downto 8) <= Bus_B(7 downto 0);
		end if;
	end process;

	-- Because DataTempOut(7:0) allways take a value from Bus_B(7:0) so \
	-- just put it laike this.
	DataTmpOut(7 downto 0) <= Bus_B(7 downto 0);

	-- Multiplexer control of data positioning for Memory Control in \
	-- (Load Instruction).
	MCI : process(Bus_A, LS, Data) begin
		if   (Bus_A(1) & Bus_A(0) & LS = "0000") then
			DataTmpIn <= X"000000" & Data(7 downto 0);
		elsif(Bus_A(1) & Bus_A(0) & LS = "0001") then
			DataTmpIn <= X"0000" & Data(15 downto 0);
		elsif(Bus_A(1) & Bus_A(0) & LS = "0100") then
			DataTmpIn <= X"000000" & Data(15 downto 8);
		elsif(Bus_A(1) & Bus_A(0) & LS = "1000") then
			DataTmpIn <= X"000000" & Data(23 downto 16);
		elsif(Bus_A(1) & Bus_A(0) & LS = "1001") then
			DataTmpIn <= X"0000" & Data(31 downto 16);
		elsif(Bus_A(1) & Bus_A(0) & LS = "1100") then
			DataTmpIn <= X"000000" & Data(31 downto 24);
		else	DataTmpIn <= Data(31 downto 0);
		end if;
	end process;


	-- WB : Process in WB pipeline stage.
	MUX_D : process(MD, F, DataReg) begin
		if (MD = '0') then Bus_D <= F;
		else               Bus_D <= DataReg;
		end if;
	end process;

	-- Register that used at every Pipeline stage.
	Reg_PC : reg1x32 port map
		(reg_in=>PC_In, reg_out=>PC, CLK=>CLK, RESET=>RESET);
	Reg_PC_1 : reg1x32 port map
		(reg_in=>PC_1_In, reg_out=>PC_1, CLK=>CLK, RESET=>RESET);
	Reg_PC_2 : reg1x32 port map
		(reg_in=>PC_2_In, reg_out=>PC_2, CLK=>CLK, RESET=>RESET);
	Reg_IR : reg1x32 port map (
		reg_in=>IR_In, reg_out=>IR, CLK=>CLK, RESET=>RESET);

	Reg_Bus_A : reg1x32 port map
		(reg_in=>Bus_A_In, reg_out=>Bus_A, CLK=>CLK, RESET=>RESET);
	Reg_Bus_B : reg1x32 port map
		(reg_in=>Bus_B_In, reg_out=>Bus_B, CLK=>CLK, RESET=>RESET);

	Reg_F : reg1x32 port map
		(reg_in=>F_In, reg_out=>F, CLK=>CLK, RESET=>RESET);
	Reg_Data : reg1x32 port map
		(reg_in=>DataTmpIn, reg_out=>DataReg, CLK=>CLK, RESET=>RESET);

	Reg_JA_R : reg1x26 port map
		(reg_in=>IR(25 downto 0),reg_out=>JA_R,CLK=>CLK,RESET=>RESET);

	Reg_LD_1 : reg1x1 port map
		(reg_in=>LD_In_1, reg_out=>LD_Out_1, CLK=>CLK, RESET=>RESET);
	Reg_DA_1 : reg1x5 port map
		(reg_in=>DA_In_1, reg_out=>DA_Out_1, CLK=>CLK, RESET=>RESET);
	Reg_MD_1 : reg1x1 port map
		(reg_in=>MD_In_1, reg_out=>MD_Out_1, CLK=>CLK, RESET=>RESET);
	Reg_BS : reg1x3 port map
		(reg_in=>BS_In, reg_out=>BS, CLK=>CLK, RESET=>RESET);
	Reg_MW : reg1x1 port map
		(reg_in=>MW_In, reg_out=>MW, CLK=>CLK, RESET=>RESET);
	Reg_LS : reg1x2 port map
		(reg_in=>LS_In, reg_out=>LS, CLK=>CLK, RESET=>RESET);
	Reg_FS : reg1x4 port map
		(reg_in=>FS_In, reg_out=>FS, CLK=>CLK, RESET=>RESET);

	Reg_LD_2 : reg1x1 port map
		(reg_in=>LD_In_2, reg_out=>LD, CLK=>CLK, RESET=>RESET);
	Reg_DA_2 : reg1x5 port map
		(reg_in=>DA_In_2, reg_out=>DA, CLK=>CLK, RESET=>RESET);
	Reg_MD_2 : reg1x1 port map
		(reg_in=>MD_In_2, reg_out=>MD, CLK=>CLK, RESET=>RESET);

end Behavioral;
