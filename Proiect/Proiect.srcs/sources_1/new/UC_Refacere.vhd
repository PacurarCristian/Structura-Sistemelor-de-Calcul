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

entity UC_Refacere is
    generic( n : natural);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Start : in STD_LOGIC;
           An : in STD_LOGIC;
           Term : out STD_LOGIC;
           LoadA : out STD_LOGIC;
           SubB : out STD_LOGIC;
           LoadB : out STD_LOGIC;
           LoadQ : out STD_LOGIC;
           ShlAQ : out STD_LOGIC;
           Q0 : out STD_LOGIC);
end UC_Refacere;

architecture Behavioral of UC_Refacere is

type TIP_STARE is (idle,initialize,test,minus,plus,shift,count,stop, qzero);

signal StarePrez : TIP_STARE;
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
                     StarePrez <= shift;
             when test =>
                  if(An = '1') then
                    StarePrez <= plus;
                  else
                    C <= C - 1;
                    StarePrez <= count;
                  end if;
             when minus =>
                  StarePrez <= qzero;
             when plus =>
                  C <= C - 1;
                  StarePrez <= count;
             when shift =>
                  StarePrez <= minus;
             when qzero =>
                  StarePrez <= test;
             when count =>  
                  if( C = 0) then  
                    StarePrez <= stop;  
                  else
                    StarePrez <= shift;
                  end if;
             when stop =>
                  StarePrez <= idle;
             end case;
       end if;
   end if;      
 end process proc1;
 
 LoadA <= '1' when (StarePrez = plus or StarePrez = minus) else '0';
 LoadQ <= '1' when StarePrez = initialize else '0';
 ShlAQ <= '1' when StarePrez = shift else '0';
 SubB <= '1' when StarePrez = minus else '0';
 LoadB <= '1' when StarePrez = initialize else '0';
 Term <= '1' when StarePrez = stop else '0';
 Q0 <= '1' when StarePrez = qzero else '0';

end Behavioral;