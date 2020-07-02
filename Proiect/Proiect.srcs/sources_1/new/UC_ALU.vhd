----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2019 06:42:55 PM
-- Design Name: 
-- Module Name: UC_ALU - Behavioral
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

entity UC_ALU is
    Port (clk: in std_logic;
    sw: in std_logic_vector(15 downto 0);
    btn: in std_logic_vector(4 downto 0);
    op: out std_logic_vector(15 downto 0);
    x, y: out std_logic_vector(15 downto 0));
end UC_ALU;

architecture Behavioral of UC_ALU is

signal selectie_afisor: std_logic_vector(1 downto 0) := sw(5 downto 4);
signal load_xy: std_logic := sw(6);
signal selectie_xy: std_logic := sw(7);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if(load_xy = '1') then
                if selectie_xy = '0' then
                    case selectie_afisor is
                        when "00" => x(3 downto 0) <= sw(3 downto 0);
                        when "01" => x(7 downto 4) <= sw(3 downto 0);
                        when "10" => x(11 downto 8) <= sw(3 downto 0);
                        when "11" => x(15 downto 12) <= sw(3 downto 0);
                    end case;     
                else
                    case selectie_afisor is
                        when "00" => y(3 downto 0) <= sw(3 downto 0);
                        when "01" => y(7 downto 4) <= sw(3 downto 0);
                        when "10" => y(11 downto 8) <= sw(3 downto 0);
                        when "11" => y(15 downto 12) <= sw(3 downto 0);
                    end case;  
                end if;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        op <= x"0000";
        
        case sw(12 downto 9) is
            when "0000" => op(0) <= '1'; --Adunare
            when "0001" => op(1) <= '1'; --Scadere
            when "0010" => op(2) <= '1'; --Inmultire
            when "0011" => op(3) <= '1'; --Impartire
            when "0100" => op(4) <= '1'; --Shift dr
            when "0101" => op(5) <= '1'; --Shift st
            when "0110" => op(6) <= '1'; --And
            when "0111" => op(7) <= '1'; --Or
            when "1000" => op(8) <= '1'; --Xor
            when others => op(0) <= '1';
        end case;
    end process;

end Behavioral;
