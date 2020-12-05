----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2020 23:47:43
-- Design Name: 
-- Module Name: top_ARB_sim - Behavioral
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

entity top_ARB_sim is
--  Port ( );
end top_ARB_sim;

architecture Behavioral of top_ARB_sim is

    component TOP_AER_ROI_BIAS is
	port (
                clk : in STD_LOGIC;
                rst : in STD_LOGIC;

                -- DAVIS AER INTF  (PAD)
                top_AER_data : in STD_LOGIC_VECTOR ( 9 downto 0 );
                top_AER_nreq : in STD_LOGIC;
                top_AER_nack : out STD_LOGIC;

                -- DAVIS AER INTF  (DBG_REG)
                top_burst_en : in STD_LOGIC; -- NOT SURE IF CONTROLLED FROM CONFIG OR AS INPUT
                top_burst_len : in STD_LOGIC_VECTOR ( 7 downto 0 );
                top_frame_len : in STD_LOGIC_VECTOR ( 7 downto 0 );
                top_us_cycle : in STD_LOGIC_VECTOR ( 7 downto 0 ); -- frame_us

                -- DAVIS AER INTF  (TO IMC)
                -- top_burst_frame : out STD_LOGIC;

                -- DAVIS BIAS CONFIG (PAD)
                top_bias_program_enable : in STD_LOGIC;
                top_BiasAddrSel : out STD_LOGIC;
                top_BiasBitIN : out STD_LOGIC;
                top_BiasClock : out STD_LOGIC;
                top_BiasLatch : out STD_LOGIC;
                top_BiasDiagSel : out STD_LOGIC;

                -- DAVIS BIAS CONFIG (DBG_REG)
                top_bias_enable : in STD_LOGIC;
                top_bias_mem_0 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_1 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_2 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_3 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_4 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_5 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_6 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_7 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_8 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_9 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_10 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_11 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_12 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_13 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_14 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_15 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_16 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_17 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_18 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_19 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_20 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_mem_21 : in STD_LOGIC_VECTOR(15 downto 0);
                top_bias_ready : out STD_LOGIC;
        
                -- ROE (TO IMC)
                top_evt_out_valid : out STD_LOGIC;
                top_evt_out_x : out STD_LOGIC_VECTOR(8 downto 0);
                top_evt_out_y : out STD_LOGIC_VECTOR(7 downto 0);
                top_evt_out_pol : out STD_LOGIC;
                -- top_evt_clk : out STD_LOGIC;

                -- ROE (DBG_REG)
                top_region_0 : in std_logic_vector(63 downto 0);
                top_region_1 : in std_logic_vector(63 downto 0);
                top_region_2 : in std_logic_vector(63 downto 0);
                top_region_3 : in std_logic_vector(63 downto 0);
                top_region_4 : in std_logic_vector(63 downto 0);
                top_region_5 : in std_logic_vector(63 downto 0);
                top_region_6 : in std_logic_vector(63 downto 0);
                top_region_7 : in std_logic_vector(63 downto 0)
	);
    end component;
    
    signal clk, rst : std_logic;
    
    -- davis aer
    signal top_burst_en : std_logic;
    -- signal top_burst_frame : std_logic;
    signal top_AER_nreq, top_AER_nack : std_logic;
    signal top_AER_data : std_logic_vector(9 downto 0);
    signal top_burst_len, top_frame_len, top_us_cycle : std_logic_vector(7 downto 0);
    
    -- bias_config
    signal top_BiasAddrSel, top_BiasBitIN, top_BiasClock, top_BiasLatch, top_BiasDiagSel, top_bias_enable : std_logic;
    signal top_bias_mem_0, top_bias_mem_1, top_bias_mem_2, top_bias_mem_3, top_bias_mem_4 : std_logic_vector(15 downto 0);
    signal top_bias_mem_5, top_bias_mem_6, top_bias_mem_7, top_bias_mem_8, top_bias_mem_9 : std_logic_vector(15 downto 0);
    signal top_bias_mem_10, top_bias_mem_11, top_bias_mem_12, top_bias_mem_13, top_bias_mem_14 : std_logic_vector(15 downto 0);
    signal top_bias_mem_15, top_bias_mem_16, top_bias_mem_17, top_bias_mem_18, top_bias_mem_19 : std_logic_vector(15 downto 0);
    signal top_bias_mem_20, top_bias_mem_21 : std_logic_vector(15 downto 0);
    signal top_bias_program_enable, top_bias_ready : std_logic;
    
    -- roe
    signal top_evt_out_valid, top_evt_out_pol : std_logic;
    -- signal top_evt_clk : STD_LOGIC;
    signal top_evt_out_x : std_logic_vector(8 downto 0);
    signal top_evt_out_y : std_logic_vector(7 downto 0);
    signal top_region_0, top_region_1, top_region_2, top_region_3, top_region_4 : std_logic_vector(63 downto 0) := (others => '0');
    signal top_region_5, top_region_6, top_region_7 : std_logic_vector(63 downto 0) := (others => '0');
    
    constant clk_period : time := 10 ns;
begin
    
uut: TOP_AER_ROI_BIAS
port map (
    clk => clk,
    rst => rst,
    top_AER_data => top_AER_data,
    top_AER_nreq => top_AER_nreq,
    top_AER_nack => top_AER_nack,
    top_burst_en => top_burst_en,
    top_burst_len => top_burst_len,
    top_frame_len => top_frame_len,
    top_us_cycle => top_us_cycle,
    -- top_burst_frame => top_burst_frame,
    top_BiasAddrSel => top_BiasAddrSel,
    top_BiasBitIN => top_BiasBitIN,
    top_BiasClock => top_BiasClock,
    top_BiasLatch => top_BiasLatch,
    top_BiasDiagSel => top_BiasDiagSel,
    top_bias_enable => top_bias_enable,
    top_bias_mem_0 => top_bias_mem_0,
    top_bias_mem_1 => top_bias_mem_1,
    top_bias_mem_2 => top_bias_mem_2,
    top_bias_mem_3 => top_bias_mem_3,
    top_bias_mem_4 => top_bias_mem_4,
    top_bias_mem_5 => top_bias_mem_5,
    top_bias_mem_6 => top_bias_mem_6,
    top_bias_mem_7 => top_bias_mem_7,
    top_bias_mem_8 => top_bias_mem_8,
    top_bias_mem_9 => top_bias_mem_9,
    top_bias_mem_10 => top_bias_mem_10,
    top_bias_mem_11 => top_bias_mem_11,
    top_bias_mem_12 => top_bias_mem_12,
    top_bias_mem_13 => top_bias_mem_13,
    top_bias_mem_14 => top_bias_mem_14,
    top_bias_mem_15 => top_bias_mem_15,
    top_bias_mem_16 => top_bias_mem_16,
    top_bias_mem_17 => top_bias_mem_17,
    top_bias_mem_18 => top_bias_mem_18,
    top_bias_mem_19 => top_bias_mem_19,
    top_bias_mem_20 => top_bias_mem_20,
    top_bias_mem_21 => top_bias_mem_21,
    top_bias_program_enable => top_bias_program_enable,
    top_bias_ready => top_bias_ready,
    top_evt_out_valid => top_evt_out_valid,
    top_evt_out_x => top_evt_out_x,
    top_evt_out_y => top_evt_out_y,
    top_evt_out_pol => top_evt_out_pol,
    -- top_evt_clk => top_evt_clk,
    top_region_0 => top_region_0,
    top_region_1 => top_region_1,
    top_region_2 => top_region_2,
    top_region_3 => top_region_3,
    top_region_4 => top_region_4,
    top_region_5 => top_region_5,
    top_region_6 => top_region_6,
    top_region_7 => top_region_7
);

clk_process :process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

stim_proc: process
begin
    -- timing and mode
    top_burst_len <= "00000100";
    top_frame_len <= "00100001";
    top_us_cycle <= "01100100";
    
    -- biases
    top_bias_mem_0 <= x"627F";
    top_bias_mem_1 <= x"2FFF";
    top_bias_mem_2 <= x"600F";
    top_bias_mem_3 <= x"2B9B";
    top_bias_mem_4 <= x"273B";
    top_bias_mem_5 <= x"4DBF";
    top_bias_mem_6 <= x"2A4F";
    top_bias_mem_7 <= x"281F";
    top_bias_mem_8 <= x"53AD";
    top_bias_mem_9 <= x"310D";
    top_bias_mem_10 <= x"619D";
    top_bias_mem_11 <= x"45BF";
    top_bias_mem_12 <= x"231F";
    top_bias_mem_13 <= x"650D";
    top_bias_mem_14 <= x"098D";
    top_bias_mem_15 <= x"2FFF";
    top_bias_mem_16 <= x"2FFF";
    top_bias_mem_17 <= x"0D7F";
    top_bias_mem_18 <= x"4FDF";
    top_bias_mem_19 <= x"2FEF";
    top_bias_mem_20 <= x"8410";
    top_bias_mem_21 <= x"8410";
    
    -- enable signals
    top_burst_en <= '0';
    top_bias_enable <= '0';
    top_bias_program_enable <= '0';
    rst <= '0';
    
    -- event data
    top_AER_data(9) <= '0';
    -- 8 don't care
    top_AER_data(7 downto 0) <= "00001111";
    -- Assert request
    top_AER_nreq <= '0';
    wait for 1 ms;
    rst <= '1';
    wait for 1 ms;    
    top_bias_enable <= '1';
    wait for 1 ms;
    
    -- Deassert request
    top_AER_nreq <= '1';
    wait for clk_period*20;
    -- Now send X
    top_AER_data(9) <= '1';
    top_AER_data(8 downto 1) <= "00001000";
    top_AER_data(0) <= '1'; --polarity
    top_AER_nreq <= '0';
    wait until top_evt_out_valid = '1';
    assert ((top_evt_out_x(7 downto 0) = x"08") and (top_evt_out_y = x"a4") and (top_evt_out_pol = '1'))  -- expected output
    report "test failed for AER" severity error;
    wait for clk_period*8;
    -- Deassert request
    top_AER_nreq <= '1';
    wait for clk_period*5;
    
    top_AER_data(9) <= '0';
    -- 8 don't care
    top_AER_data(7 downto 0) <= "00110000";
    -- Assert request
    top_AER_nreq <= '0';
    wait for clk_period*20;
    -- Deassert request
    top_AER_nreq <= '1';
    wait for clk_period*20;
    -- Now send X
    top_AER_data(9) <= '1';
    top_AER_data(8 downto 1) <= "00010000";
    top_AER_data(0) <= '0'; --polarity
    top_AER_nreq <= '0';
--    wait until top_evt_out_valid = '1';
    wait for clk_period*12;
    assert ((top_evt_out_x(7 downto 0) = x"10") and (top_evt_out_y = x"83") and (top_evt_out_pol = '0'))  -- expected output
    report "test failed for AER" severity error;
    wait for clk_period*8;
    -- Deassert request
    top_AER_nreq <= '1';
    wait for clk_period*50;
    top_region_2 <= x"0009001900800090"; -- setting ROI
    
    wait for clk_period*10;
    -- event data
    top_AER_data(9) <= '0';
    -- 8 don't care
    top_AER_data(7 downto 0) <= "00001111";
    -- Assert request
    top_AER_nreq <= '0';
    wait for 1 ms;
    rst <= '1';
    wait for 1 ms;    
    top_bias_enable <= '1';
    wait for 1 ms;
    
    -- Deassert request
    top_AER_nreq <= '1';
    wait for clk_period*20;
    -- Now send X
    top_AER_data(9) <= '1';
    top_AER_data(8 downto 1) <= "00001000";
    top_AER_data(0) <= '1';
    top_AER_nreq <= '0';
--    wait until top_evt_out_valid = '1';
    wait for clk_period*12;
    assert ((top_evt_out_x(7 downto 0) = x"08") and (top_evt_out_y = x"a4")  and (top_evt_out_pol = '1'))  -- expected output
    report "test failed for AER" severity error;
    wait for clk_period*8;
    -- Deassert request
    top_AER_nreq <= '1';
    wait for clk_period*5;
    
    top_AER_data(9) <= '0';
    -- 8 don't care
    top_AER_data(7 downto 0) <= "00110000";
    -- Assert request
    top_AER_nreq <= '0';
    wait for clk_period*20;
    -- Deassert request
    top_AER_nreq <= '1';
    wait for clk_period*20;
    -- Now send X
    top_AER_data(9) <= '1';
    top_AER_data(8 downto 1) <= "00010000";
    top_AER_data(0) <= '0';
    top_AER_nreq <= '0';
    --    wait until top_evt_out_valid = '1';
    wait for clk_period*12;
    assert (top_evt_out_valid = '0')  -- expected output
    report "test failed for ROI" severity error;
    wait for clk_period*8;
    -- Deassert request
    top_AER_nreq <= '1';
        
    wait for clk_period*50;
    top_bias_program_enable <= '1';
    wait for clk_period;
    top_bias_program_enable <= '0';
    wait for 10.32681 ms;
    assert ((top_BiasAddrSel = '0') and (top_BiasBitIN = '0') and (top_BiasClock = '1') and (top_BiasLatch = '0'))  -- expected output
    report "test failed for BIAS" severity error;
    wait;
end process;

end Behavioral;
