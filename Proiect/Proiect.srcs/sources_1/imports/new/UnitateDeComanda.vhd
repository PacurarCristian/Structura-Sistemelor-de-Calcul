----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25/11/2019 01:33:55 PM
-- Design Name: 
-- Module Name: UnitateDeComanda - Behavioral
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

entity UnitateDeComanda is
    generic( n : natural);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Start : in STD_LOGIC;
           Q0Qm1 : in STD_LOGIC_VECTOR(1 downto 0);
           Term : out STD_LOGIC;
           RstA : out STD_LOGIC;
           LoadA : out STD_LOGIC;
           SubB : out STD_LOGIC;
           LoadB : out STD_LOGIC;
           LoadQ : out STD_LOGIC;
           ShrAQ : out STD_LOGIC;
           RstQm1 : out STD_LOGIC);
end UnitateDeComanda;

architecture Behavioral of UnitateDeComanda is

type TIP_STARE is (idle,initialize,test,minus,plus,shift,count,stop);

signal StarePrez : TIP_STARE;
signal Q00,Q11 : STD_LOGIC;
signal C: Integer Range 0 to 16 := 0 ;
begin

proc1: process (Clk)
begin
    if(rising_edge(clk)) then
        if(Rst = '1') then
            StarePrez <= idle;
        else 
             case StarePrez is
             when idle =>
                 if (Start = '1') then
                     StarePrez <= initialize;
                     else 
                     StarePrez <= idle;
                 end if;
                 
             when initialize =>
                     C <= 16;                     
                     StarePrez <= test;
             when test =>
                  if(Q0Qm1 = "10") then
                    StarePrez <= minus;
                  elsif(Q0Qm1 = "01") then
                    StarePrez <= plus;
                  else 
                    StarePrez <= shift;
                  end if;
             when minus =>
                  StarePrez <= shift;
             when plus =>
                  StarePrez <= shift;
             when shift =>
                  C <= C -1;
                  StarePrez <= count;
             when count =>  
                  if( C = 0) then  
                    StarePrez <= stop;  
                  else
                    StarePrez <= test;
                  end if;
             when stop =>
                  StarePrez <= idle;
             end case;
       end if;
   end if;      
 end process proc1;
 
 RstA <= '1' when StarePrez = initialize else '0';
 RstQm1 <= '1' when StarePrez = initialize else '0';
 LoadA <= '1' when (StarePrez = plus or StarePrez = minus) else '0';
 LoadQ <= '1' when StarePrez = initialize else '0';
 ShrAQ <= '1' when StarePrez = shift else '0';
 SubB <= '1' when StarePrez = minus else '0';
 LoadB <= '1' when StarePrez = initialize else '0';
 Term <= '1' when StarePrez = stop else '0';

end Behavioral;