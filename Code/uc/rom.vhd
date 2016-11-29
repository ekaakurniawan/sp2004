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

-- ROM (Read Only Memory)
-- ----------------------
--
--	Hierarchy  ==>	# ROM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
    Port ( Add_In : in std_logic_vector(7 downto 0);
           Data_Out : out std_logic_vector(31 downto 0));
end ROM;

architecture Behavioral of ROM is

begin

   -- After compile the Program file to Bit file, copy the instruction bits \
   -- and give the address for each instruction.
   counter : process(Add_In) begin
      case Add_In is
         when "00000000" => Data_Out <= B"01111000000000000000000000000000";
         when "00000001" => Data_Out <= B"10010100000000000000000000000100";
         when "00000010" => Data_Out <= B"01111000000000000000000000000000";
         when "00000011" => Data_Out <= B"10010100000000000000000000011111";
         when "00000100" => Data_Out <= B"01111000000000000000000000000000";
         when "00000101" => Data_Out <= B"10010100000000000000000000111001";
         when "00000110" => Data_Out <= B"01111100000000000000000000000000";
         when "00000111" => Data_Out <= B"00001000001000000000000000000001";
         when "00001000" => Data_Out <= B"00000000110000000000000000000000";
         when "00001001" => Data_Out <= B"00001000010000001000000000000000";
         when "00001010" => Data_Out <= B"00001000101000000000000000000001";
         when "00001011" => Data_Out <= B"01010000011000000000000000000000";
         when "00001100" => Data_Out <= B"00001000011000110111111111111111";
         when "00001101" => Data_Out <= B"00001000111000000000000010000000";
         when "00001110" => Data_Out <= B"00001001000000000000000010000001";
         when "00001111" => Data_Out <= B"00000000100000000000000000000000";
         when "00010000" => Data_Out <= B"01011000000001110000100000000000";
         when "00010001" => Data_Out <= B"00111000110000010000000000001000";
         when "00010010" => Data_Out <= B"01011000000010000011000000000000";
         when "00010011" => Data_Out <= B"00000000100001000010100000000000";
         when "00010100" => Data_Out <= B"10000000000001000001100000000001";
         when "00010101" => Data_Out <= B"10010111111111111111111111111010";
         when "00010110" => Data_Out <= B"01000000001000010000000000000001";
         when "00010111" => Data_Out <= B"10000100000000010001000000000001";
         when "00011000" => Data_Out <= B"10010111111111111111111111110110";
         when "00011001" => Data_Out <= B"00000000100000000000000000000000";
         when "00011010" => Data_Out <= B"00111000001000010000000000000001";
         when "00011011" => Data_Out <= B"01011000000001110000100000000000";
         when "00011100" => Data_Out <= B"00111000110000010000000000001000";
         when "00011101" => Data_Out <= B"01011000000010000011000000000000";
         when "00011110" => Data_Out <= B"00000000100001000010100000000000";
         when "00011111" => Data_Out <= B"10000000000001000001100000000001";
         when "00100000" => Data_Out <= B"10010111111111111111111111111010";
         when "00100001" => Data_Out <= B"10000011111000010010111111101101";
         when "00100010" => Data_Out <= B"10010111111111111111111111110110";
         when "00100011" => Data_Out <= B"00001001011000000000000000000001";
         when "00100100" => Data_Out <= B"00001001101000001000000000000000";
         when "00100101" => Data_Out <= B"00001001110000000000000000000001";
         when "00100110" => Data_Out <= B"01010001111000000000000000000000";
         when "00100111" => Data_Out <= B"00001001111011111111111111111111";
         when "00101000" => Data_Out <= B"00001010110000000000000000101101";
         when "00101001" => Data_Out <= B"00001010111000000000000000101110";
         when "00101010" => Data_Out <= B"00001011000000000000000000000000";
         when "00101011" => Data_Out <= B"00001011001000000000000000000000";
         when "00101100" => Data_Out <= B"00001011010000000000000000000000";
         when "00101101" => Data_Out <= B"00000010001000000000000000000000";
         when "00101110" => Data_Out <= B"00100011000110010101100000000000";
         when "00101111" => Data_Out <= B"01011000000001111100000000000000";
         when "00110000" => Data_Out <= B"00111011010110000000000000001000";
         when "00110001" => Data_Out <= B"01011000000010001101000000000000";
         when "00110010" => Data_Out <= B"00000010001100010111000000000000";
         when "00110011" => Data_Out <= B"10000000000100010111100000000001";
         when "00110100" => Data_Out <= B"10011100000000001011100000000000";
         when "00110101" => Data_Out <= B"01000001011010110000000000000001";
         when "00110110" => Data_Out <= B"10000000000011010101100000000001";
         when "00110111" => Data_Out <= B"10011100000000001011000000000000";
         when "00111000" => Data_Out <= B"00001001011000000000000000000001";
         when "00111001" => Data_Out <= B"00100011001110010110100000000000";
         when "00111010" => Data_Out <= B"00111001101011010000000000000001";
         when "00111011" => Data_Out <= B"10000000000011010111000000000001";
         when "00111100" => Data_Out <= B"10011100000000001011000000000000";
         when "00111101" => Data_Out <= B"01111100000000000000000000000000";
         when "00111110" => Data_Out <= B"10011100000000001111000000000000";
         when "00111111" => Data_Out <= B"01100111011001110000000000000000";
         when "01000000" => Data_Out <= B"01010001111000000000000000001111";
         when "01000001" => Data_Out <= B"00001001111011111111111111111111";
         when "01000010" => Data_Out <= B"01011000000001111101100000000000";
         when "01000011" => Data_Out <= B"00000010001000000000000000000000";
         when "01000100" => Data_Out <= B"00000110001100010000000000000001";
         when "01000101" => Data_Out <= B"10000000000100010111100000000001";
         when "01000110" => Data_Out <= B"10010111111111111111111111111101";
         when "01000111" => Data_Out <= B"01111100000000000000000000000000";
         when "01001000" => Data_Out <= B"10011100000000001111000000000000";

         when others     => Data_Out <= B"00000000000000000000000000000000";
      end case;
   end process;

end Behavioral;
