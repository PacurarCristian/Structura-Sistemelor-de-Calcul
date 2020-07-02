----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2019 11:09:45 AM
-- Design Name: 
-- Module Name: booth_tb - Behavioral
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

entity booth_tb is
--  Port ( );
end booth_tb;

architecture Behavioral of booth_tb is

signal RstA : STD_LOGIC := '0';
signal SubB : STD_LOGIC := '0';
signal LoadB : STD_LOGIC := '0';
signal LoadA : STD_LOGIC := '0';
signal LoadQ : STD_LOGIC := '0';
signal RstQm1 : STD_LOGIC := '0';
signal ShrAQ : STD_LOGIC := '0';
signal Q0Qm1 : STD_LOGIC_VECTOR(1 downto 0) := "00";

signal Ain : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal Aout : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

signal Q1 : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal Bout : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal Sout : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal Qout : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');
signal Qm1out : STD_LOGIC := '0';
signal Tin: STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';
signal Bout1 : STD_LOGIC_VECTOR(15 downto 0) := (others =>'0');

constant CLK_PERIOD : TIME := 10 ns;
signal Clk, Rst, Term: std_logic := '0';
signal Start: std_logic := '1';
signal X : STD_LOGIC_VECTOR (15 downto 0) := x"0002";
signal Y : STD_LOGIC_VECTOR (15  downto 0) := x"0003";
signal A : STD_LOGIC_VECTOR (15 downto 0) := (others =>'0');
signal Q : STD_LOGIC_VECTOR (15 downto 0) := (others =>'0');

begin
    
    gen_clk: process
    begin
        Clk <= '0';
        wait for (CLK_PERIOD/2);
        Clk <= '1';
        wait for (CLK_PERIOD/2);
    end process gen_clk;

   reset <= Rst or RstA;

UC : entity WORK.UnitateDeComanda 

generic map( n => 16)
port map (
           Clk => Clk,
           Rst => Rst,
           Start => Start,
           Q0Qm1 => Q0Qm1,
           Term => Term,
           RstA  => RstA,
           LoadA  => LoadA,
           SubB => SubB,
           LoadB => LoadB,
           LoadQ => LoadQ, 
           ShrAQ => ShrAQ, 
           RstQm1 => RstQm1);
           

           
FDN_B : entity WORK.FDN 
    generic map (width => 16)
    port map ( 
        D  => X,
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
           Tout => open
    
    ); 
        
SRRN_A : entity WORK.SRRN 
    generic map (width => 16)
    port map ( 
           D => Sout,
           SRI => Aout(15),
           Load => LoadA,
           CE => ShrAQ,
           Clk => Clk,
           Rst => reset,
           Q => Aout
        );
                
SRRN_Q : entity WORK.SRRN 
    generic map (width => 16)
    port map ( 
           D => Y,
           SRI => Aout(0),
           Load => LoadQ,
           CE => ShrAQ,
           Clk => Clk,
           Rst => Rst,
           Q => Qout
        );
FDQm1 : entity WORK.FD
    port map (
          D => Qout(0),
          CE => ShrAQ,
          Clk => Clk,
          Rst => RstQm1,
          Q => Qm1Out
    );        
        
Q0Qm1(1) <= Qout(0);            
Q0Qm1(0) <= Qm1Out;


A <= Aout;
Q <= Qout;


    
end Behavioral;
