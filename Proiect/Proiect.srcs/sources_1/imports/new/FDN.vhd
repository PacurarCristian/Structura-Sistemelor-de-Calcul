----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25/11/2019 12:11:25 PM
-- Design Name: 
-- Module Name: FDN - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FDN is
    generic (width : integer := 16);
    Port ( D : in STD_LOGIC_VECTOR (width-1 downto 0);
           CE : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (width-1 downto 0));
end FDN;

architecture Behavioral of FDN is

signal value : STD_LOGIC_VECTOR(width-1 downto 0) := "0000000000000000"; 

begin

   process(Clk) 
    begin
        if(rising_edge(Clk)) then
            if(Rst = '1') then
                value <= (others => '0');
            elsif(CE = '1') then
                value <= D;       
            end if;
        end if;        
         
   end process;
   
   Q <= value;

end Behavioral;
