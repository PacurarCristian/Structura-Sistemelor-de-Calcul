----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2019 04:39:54 PM
-- Design Name: 
-- Module Name: SSD_Driver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD_Driver is
    Port ( dg : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD_Driver;

architecture Behavioral of SSD_Driver is

signal nr_out : std_logic_vector (15 downto 0) := x"0000";
signal mux1_out : std_logic_vector (3 downto 0) := "0000";

begin

--numarator
process(clk)
    begin
        if rising_edge(clk) then
            nr_out <= nr_out + 1;
        end if;
    end process;
    
--mux1
process(nr_out(15), nr_out(14))
    begin
        case nr_out(15 downto 14) is
            when "11" => mux1_out <= dg(15 downto 12);
            when "10" => mux1_out <= dg(11 downto 8);
            when "01" => mux1_out <= dg(7 downto 4);
            when "00" => mux1_out <= dg(3 downto 0);
            when others => mux1_out <= dg(15 downto 12);
        end case;
    end process;
    
--mux2
    process(nr_out(15), nr_out(14))
        begin
            case nr_out(15 downto 14) is
                when "00" => an <= "1110";
                when "01" => an <= "1101";
                when "10" => an <= "1011";
                when "11" => an <= "0111";
                when others => an <= "1110";
            end case;
        end process;

--dcd       
with mux1_out SELect
           cat<= "1111001" when "0001",   --1
                 "0100100" when "0010",   --2
                 "0110000" when "0011",   --3
                 "0011001" when "0100",   --4
                 "0010010" when "0101",   --5
                 "0000010" when "0110",   --6
                 "1111000" when "0111",   --7
                 "0000000" when "1000",   --8
                 "0010000" when "1001",   --9
                 "0001000" when "1010",   --A
                 "0000011" when "1011",   --b
                 "1000110" when "1100",   --C
                 "0100001" when "1101",   --d
                 "0000110" when "1110",   --E
                 "0001110" when "1111",   --F
                 "1000000" when others;   --0
             

end Behavioral;
