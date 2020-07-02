----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2019 04:55:54 PM
-- Design Name: 
-- Module Name: sumator_anticipare - Behavioral
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

entity sumator_anticipare is
Port (x: in std_logic_vector(15 downto 0);
    y: in std_logic_vector(15 downto 0);
    tin: in std_logic;
    s: out std_logic_vector(15 downto 0);
    tout: out std_logic);
end sumator_anticipare;

architecture Behavioral of sumator_anticipare is

component sumator_2biti
    Port (x: in std_logic_vector(1 downto 0);
    y: in std_logic_vector(1 downto 0);
    tin: in std_logic;
    s: out std_logic_vector(1 downto 0);
    p: out std_logic;
    g: out std_logic);
end component;

signal p01, g01, p23, g23, p45, g45, p67, g67, p89, g89, p1011, g1011, p1213, g1213, p1415, g1415: std_logic;
signal t2, t4, t6, t8, t10, t12, t14: std_logic;

begin
    S1: sumator_2biti port map(x(1 downto 0), y(1 downto 0), tin, s(1 downto 0), p01, g01);
    t2 <= g01 or (p01 and tin);
    
    S2: sumator_2biti port map(x(3 downto 2), y(3 downto 2), t2, s(3 downto 2), p23, g23);
    t4 <= g23 or (p23 and t2);
    
    S3: sumator_2biti port map(x(5 downto 4), y(5 downto 4), t4, s(5 downto 4), p45, g45);
    t6 <= g45 or (p45 and t4);
    
    S4: sumator_2biti port map(x(7 downto 6), y(7 downto 6), t6, s(7 downto 6), p67, g67);
    t8 <= g67 or (p67 and t6);
    
    S5: sumator_2biti port map(x(9 downto 8), y(9 downto 8), t8, s(9 downto 8), p89, g89);
    t10 <= g89 or (p89 and t8);
    
    S6: sumator_2biti port map(x(11 downto 10), y(11 downto 10), t10, s(11 downto 10), p1011, g1011);
    t12 <= g1011 or (p1011 and t10);
    
    S7: sumator_2biti port map(x(13 downto 12), y(13 downto 12), t12, s(13 downto 12), p1213, g1213);
    t14 <= g1213 or (p1213 and t12);
    
    S8: sumator_2biti port map(x(15 downto 14), y(15 downto 14), t14, s(15 downto 14), p1415, g1415);
    tout <= g1415 or (p1415 and t14);

end Behavioral;
