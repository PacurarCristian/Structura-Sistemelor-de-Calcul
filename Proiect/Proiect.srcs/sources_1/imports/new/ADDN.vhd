----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25/11/2019 12:31:56 PM
-- Design Name: 
-- Module Name: ADDN - Behavioral
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

entity ADDN is
generic (width : integer := 16);
    Port ( Tin : in STD_LOGIC;
           X : in STD_LOGIC_VECTOR(width-1 downto 0);
           Y : in STD_LOGIC_VECTOR(width-1 downto 0);
           S : out STD_LOGIC_VECTOR(width-1 downto 0);
           OVF : out STD_LOGIC;
           Tout : out STD_LOGIC);       
end ADDN;

architecture Behavioral of ADDN is

signal T, x2, y2, tin2 : STD_LOGIC_VECTOR(width downto 0) := (others => '0');

begin

    x2 <= "0" & x;
    y2 <= "0" & y;
    tin2(0) <= tin;
    T <= x2 + y2 + tin2;
    Tout <= T(width);
    OVF <= T(width) xor T(width-1);
    S <= T(width-1 downto 0);

end Behavioral;
