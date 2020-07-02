----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2019 01:53:34 PM
-- Design Name: 
-- Module Name: alu_tb - Behavioral
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

entity alu_tb is
--  Port ( );
end alu_tb;

architecture Behavioral of alu_tb is

component debouncer
    Port ( btn : in STD_LOGIC;
           clock : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component SSD_Driver
    Port ( dg : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component UC_ALU
    Port (clk: in std_logic;
    sw: in std_logic_vector(15 downto 0);
    btn: in std_logic_vector(4 downto 0);
    op: out std_logic_vector(15 downto 0);
    x, y: out std_logic_vector(15 downto 0));
end component;

component sumator_anticipare
Port (x: in std_logic_vector(15 downto 0);
    y: in std_logic_vector(15 downto 0);
    tin: in std_logic;
    s: out std_logic_vector(15 downto 0);
    tout: out std_logic);
end component;

component Booth
generic (width : integer := 8);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Start : in STD_LOGIC;
           X : in STD_LOGIC_VECTOR (width-1 downto 0);
           Y : in STD_LOGIC_VECTOR (width-1  downto 0);
           A : out STD_LOGIC_VECTOR (width-1 downto 0);
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           Term : out STD_LOGIC);
end component;

signal rst, term: std_logic := '0';
signal start: std_logic := '0';
signal op: std_logic_vector(15 downto 0) := x"0000";
signal x, y, SSDin: std_logic_vector(15 downto 0) := x"0000";
signal rez: std_logic_vector(31 downto 0) := x"00000000";
signal suma, diferenta: std_logic_vector(15 downto 0) := x"0000";
signal tout1, tout2: std_logic := '0';
signal minusY: std_logic_vector(15 downto 0) := x"0000";
signal a, q: std_logic_vector(15 downto 0) := x"0000";

constant CLK_PERIOD : TIME := 10 ns;
signal Clk: std_logic;
signal sw: std_logic_vector(15 downto 0);
signal btn: std_logic_vector(4 downto 0);
signal led: std_logic_vector(15 downto 0);
signal an: std_logic_vector(3 downto 0);
signal cat: std_logic_vector(6 downto 0);
signal stop: std_logic := '0';
signal da: std_logic := '0';

begin
    gen_clk: process
    begin
        Clk <= '0';
        wait for (CLK_PERIOD/2);
        Clk <= '1';
        wait for (CLK_PERIOD/2);
    end process gen_clk;
    
    -- SW:
    -- 3-0: bit nr
    -- 5-4: selectie parte nr
    -- 6: enable load x si y
    -- 8-7: selectie x, y, parte superioara/inferioara rez
    -- 12-9: selectie op
    
    -- BTN:
    -- btn mijloc: rst
    
    -- LED:
    -- 15: transport/semn
    
    --SSD: SSD_Driver port map(SSDin, clk, cat, an);
    --DB: debouncer port map(btn(0), clk, rst);
    
    --UC: UC_ALU port map(clk, sw, btn, op, x, y);
    --SUM: sumator_anticipare port map(x, y, '0', suma, tout1);
    --DIF: sumator_anticipare port map(x, minusY, '0', diferenta, tout2);
    PROD: Booth generic map(16) port map(Clk, '0', start, x"0002", x"0003", a, q, term);
    
    --minusY <= not(y) + 1;
    
    process(clk)
    begin
        --led(15) <= '0';
        
        --if op(0) = '1' then
            --rez(15 downto 0) <= suma;
            --led(15) <= tout1;
        
        --elsif op(1) = '1' then
            --if tout2 = '0' then --negativ
                --rez(15 downto 0) <= not(diferenta) + 1;
            --else
                --rez(15 downto 0) <= diferenta;
            --end if;
            
            --led(15) <= not(tout2);
            
        --elsif op(2) = '1' then
            --start <= '1';
            
            if da = '1' then
                start <= '1';
            end if;
            
            if(term = '1') then
                start <= '0';
                stop <= '1';
            elsif stop = '0' then
                rez(31 downto 16) <= a;
                rez(15 downto 0) <= q;
            end if;
            
            if rst = '1' then
                start <= '1';
                stop <= '0';
            end if;
        --end if;
    end process;
    
    process(clk)
    begin
        case sw(8 downto 7) is
            when "00" => SSDin <= x;
            when "01" => SSDin <= y;
            when "10" => SSDin <= rez(31 downto 16);
            when "11" => SSDin <= rez(15 downto 0);
            when others => SSDin <= x;
        end case;
    end process;
    
    process
    begin
        da <= '0';
        wait for 50ns;
        da <= '1';
    end process;

end Behavioral;
