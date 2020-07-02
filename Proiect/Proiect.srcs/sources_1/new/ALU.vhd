----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2019 06:29:40 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port (clk: in std_logic;
    sw: in std_logic_vector(15 downto 0);
    btn: in std_logic_vector(4 downto 0);
    led: out std_logic_vector(15 downto 0);
    an: out std_logic_vector(3 downto 0);
    cat: out std_logic_vector(6 downto 0));
end ALU;

architecture Behavioral of ALU is

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

component Refacere_rest
generic (width : integer := 16);
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Start : in STD_LOGIC;
           X : in STD_LOGIC_VECTOR (width-1 downto 0);
           Y : in STD_LOGIC_VECTOR (width-1  downto 0);
           A : out STD_LOGIC_VECTOR (width-1 downto 0);
           Q : out STD_LOGIC_VECTOR (width-1 downto 0);
           Term : out STD_LOGIC);
end component;

component SRRN
 generic (width : integer := 16);
    Port ( D : in STD_LOGIC_VECTOR(width-1 downto 0);
           SRI : in STD_LOGIC;
           Load : in STD_LOGIC;
           CE : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(width-1 downto 0));
end component;

component SLRN
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
end component;

signal rst, start, term, term2, shift: std_logic := '0';
signal op: std_logic_vector(15 downto 0) := x"0000";
signal x, y, SSDin: std_logic_vector(15 downto 0) := x"0000";
signal rez: std_logic_vector(31 downto 0) := x"00000000";
signal out_sumator: std_logic_vector(15 downto 0) := x"0000";
signal tout: std_logic := '0';
signal minusY, shiftDr, shiftSt: std_logic_vector(15 downto 0) := x"0000";
signal a, q, a2, q2: std_logic_vector(15 downto 0) := x"0000";
signal y_aux: std_logic_vector(15 downto 0) := y;

begin
    -- SW:
    -- 3-0: bit nr
    -- 5-4: selectie parte nr
    -- 6: enable load x si y
    -- 8-7: selectie x, y, parte superioara/inferioara rez
    -- 12-9: selectie op
    -- 13: 0 sau 1 shift
    
    -- BTN:
    -- btn mijloc: start inmultire/impartire
    -- btn sus: reset
    -- btn stanga: shift
    
    -- LED:
    -- 15: transport/semn
    
    SSD: SSD_Driver port map(SSDin, clk, cat, an);
    DB_Start: debouncer port map(btn(0), clk, start);
    DB_Rst: debouncer port map(btn(1), clk, rst);
    DB_Shift: debouncer port map(btn(2), clk, shift);
    
    UC: UC_ALU port map(clk, sw, btn, op, x, y);
    SUM_DIF: sumator_anticipare port map(x, y_aux, '0', out_sumator, tout);
    PROD: Booth generic map(16) port map(Clk, rst, start, x, y, a, q, term);
    CAT_REST: Refacere_rest generic map(16) port map(Clk, rst, start, x, y, a2, q2, term2);
    SHIFT_DR: SRRN generic map(16) port map(x, sw(13), rst, shift, Clk, '0', shiftDr);
    SHIFT_ST: SLRN generic map(16) port map(x, sw(13), '0', rst, '0', shift, Clk, '0', shiftSt);
    
    process(clk)
    begin
        led(15) <= '0';
        rez <= x"00000000";
        
        if op(0) = '1' then --adunare
            y_aux <= y;
            rez(15 downto 0) <= out_sumator;
            led(15) <= tout;
        
        elsif op(1) = '1' then --scadere
            minusY <= not(y) + 1;
            y_aux <= minusY;
                
            if tout = '0' then --negativ
                rez(15 downto 0) <= not(out_sumator) + 1;
            else
                rez(15 downto 0) <= out_sumator;
            end if;
            
            led(15) <= not(tout);
            
        elsif op(2) = '1' then --inmultire
            rez(31 downto 16) <= a;
            rez(15 downto 0) <= q;
        
        elsif op(3) = '1' then --impartire
            rez(31 downto 16) <= q2; --cat
            rez(15 downto 0) <= a2; --rest
        
        elsif op(4) = '1' then
            rez(15 downto 0) <= shiftDr;
            
        elsif op(5) = '1' then
            rez(15 downto 0) <= shiftSt;
        
        elsif op(6) = '1' then
            rez(15 downto 0) <= x and y;
        
        elsif op(7) = '1' then
            rez(15 downto 0) <= x or y;    
        
        elsif op(8) = '1' then
            rez(15 downto 0) <= x xor y;     
        end if;
    end process;
    
    process(clk)
    begin
        case sw(8 downto 7) is
            when "00" => SSDin <= x;
            when "01" => SSDin <= y;
            when "10" => SSDin <= rez(31 downto 16);
            when "11" => SSDin <= rez(15 downto 0);
        end case;
    end process;

end Behavioral;
