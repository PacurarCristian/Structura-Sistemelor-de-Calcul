----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25/11/2019 12:26:37 PM
-- Design Name: 
-- Module Name: SRRN - Behavioral
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

entity SLRN is
 generic (width : integer := 16);
    Port ( D : in STD_LOGIC_VECTOR(width-1 downto 0);
           SRI : in STD_LOGIC;
           SRI2 : in STD_LOGIC;
           Load : in STD_LOGIC;
           Load2 : in STD_LOGIC;
           CE : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(width-1 downto 0));
end SLRN;

architecture Behavioral of SLRN is

signal Q1 : STD_LOGIC_VECTOR(width-1 downto 0):= (others => '0');
begin

 process(Clk) 
    begin
        if(rising_edge(Clk)) then
            if(Rst = '1') then
                Q1 <= (others => '0');
            elsif(Load = '1') then
                Q1 <= D;
            elsif(Load2 = '1') then
                Q1(0) <= SRI2;
            elsif(CE = '1') then
                Q1 <= Q1(width-2 downto 0) & SRI;
            end if;
        end if;        
         
   end process;
   
   Q <= Q1;

end Behavioral;
