----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2019 11:48:14
-- Design Name: 
-- Module Name: bias_clock_div - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bias_clock_div is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : in STD_LOGIC;
           th : out STD_LOGIC
    );
end bias_clock_div;

architecture Behavioral of bias_clock_div is
signal counter : unsigned(8 downto 0);
signal th_s : STD_LOGIC;
begin

th <= th_s;

process(clk) begin
if rising_edge(clk) then
    if rst = '0' then
        th_s <= '0';    
    elsif ce = '1' then
        if counter = "111111101" then
            th_s <= '1';
        else
            th_s <= '0';
        end if;
    else
        th_s <= '0';        
    end if;
end if;
end process;

process(clk) begin
if rising_edge(clk) then
    if rst = '0' then
        counter <= (others => '0');
    elsif ce = '1' then
        if th_s = '1' then
            counter <= (others => '0');
        else
            counter <= counter + 1;
        end if;
    else
        counter <= (others => '0');
    end if;
end if;
end process;


end Behavioral;
