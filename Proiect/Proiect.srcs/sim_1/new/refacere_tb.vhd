----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2019 07:08:45 PM
-- Design Name: 
-- Module Name: refacere_tb - Behavioral
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

entity refacere_tb is
--  Port ( );
end refacere_tb;

architecture Behavioral of refacere_tb is

constant CLK_PERIOD : TIME := 10 ns;
signal Clk, Rst, Term: std_logic := '0';
signal Start: std_logic := '1';
signal X : STD_LOGIC_VECTOR (15 downto 0) := x"000D";
signal Y : STD_LOGIC_VECTOR (15 downto 0) := x"0005";
signal A, Q: STD_LOGIC_VECTOR (15 downto 0) := x"0000";

signal SubB : STD_LOGIC := '0';
signal LoadB : STD_LOGIC := '0';
signal LoadA : STD_LOGIC := '0';
signal LoadQ : STD_LOGIC := '0';
signal ShlAQ : STD_LOGIC := '0';
signal Q0 : STD_LOGIC := '0';

signal Aout : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal Bout : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal Sout : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal Qout : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal Q0out, Qzero: STD_LOGIC := '0';
signal Tin, Tout: STD_LOGIC := '0';
signal Bout1 : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');

begin
    gen_clk: process
    begin
        Clk <= '0';
        wait for (CLK_PERIOD/2);
        Clk <= '1';
        wait for (CLK_PERIOD/2);
    end process gen_clk;
    
    UC : entity WORK.UC_Refacere
    generic map( n => 16)
    port map (
           Clk => Clk,
           Rst => Rst,
           Start => Start,
           An => Tout,
           Term => Term,
           LoadA  => LoadA,
           SubB => SubB,
           LoadB => LoadB,
           LoadQ => LoadQ, 
           ShlAQ => ShlAQ,
           Q0 => Q0);
               
FDN_B : entity WORK.FDN 
    generic map (width => 16)
    port map ( 
        D  => Y,
        CE => LoadB,
        Clk => Clk,
        Rst => Rst,
        Q => Bout);
        
Bout1 <= Bout xor "0000000000000000" when SubB = '0' else Bout xor "1111111111111111";
 
Sumator : entity WORK.ADDN 
    generic map (width => 16)     
    port map (
           Tin => SubB,
           X =>  Bout1,
           Y => Aout,
           S => Sout,
           OVF => open,
           Tout => Tout); 
        
SLRN_A : entity WORK.SLRN 
    generic map (width => 16)
    port map ( 
           D => Sout,
           SRI => Qout(15),
           SRI2 => '0',
           Load => LoadA,
           Load2 => '0',
           CE => ShlAQ,
           Clk => Clk,
           Rst => Rst,
           Q => Aout);
                
SLRN_Q : entity WORK.SLRN 
    generic map (width => 16)
    port map ( 
           D => X,
           SRI => '0',
           SRI2 => Qzero,
           Load => LoadQ,
           Load2 => Q0,
           CE => ShlAQ,
           Clk => Clk,
           Rst => Rst,
           Q => Qout);
           
FDQ0 : entity WORK.FD
    port map (
          D => Qout(15),
          CE => ShlAQ,
          Clk => Clk,
          Rst => Rst,
          Q => Q0Out);        


Qzero <= not(Tout);

A <= Aout;
Q <= Qout;

end Behavioral;
