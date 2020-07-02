----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2019 04:42:54 PM
-- Design Name: 
-- Module Name: sumator_2biti - Behavioral
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

entity sumator_2biti is
    Port (x: in std_logic_vector(1 downto 0);
    y: in std_logic_vector(1 downto 0);
    tin: in std_logic;
    s: out std_logic_vector(1 downto 0);
    p: out std_logic;
    g: out std_logic);
end sumator_2biti;

architecture Behavioral of sumator_2biti is

signal p0, p1, g0, g1: std_logic;

begin
    s <= x + y + tin;
    
    p0 <= x(0) or y(0);
    p1 <= x(1) or y(1);
    
    g0 <= x(0) and y(0);
    g1 <= x(1) and y(1);
    
    p <= p1 and p0;
    g <= g1 or (p1 and g0);

end Behavioral;
