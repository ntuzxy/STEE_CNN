--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
--Date : Fri Feb 1 15:50:59 2019
--Host : dhcp-172-21-154-187 running 64-bit CentOS Linux release 7.3.1611 (Core)
--Command : generate_target design_2.bd
--Design : design_2
--Purpose : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;

entity TOP_AER_ROI_BIAS is
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
                top_altern : out STD_LOGIC;

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
end TOP_AER_ROI_BIAS;

architecture STRUCTURE of TOP_AER_ROI_BIAS is
	component davis_aer_interface is
        generic (
                ACK_Y_DELAY : integer := 12; -- 4 for 90 MHz in libcaer
                ACK_X_DELAY : integer := 2; -- 0 in libcaer
                ACK_Y_EXTENSION : integer := 6; -- 1 in libcaer
                ACK_X_EXTENSION : integer := 1 -- 0 in libcaer
        );
        port (
                clk : in STD_LOGIC;
                rst : in STD_LOGIC;
                burst_mode : in std_logic;
                burst_len : in std_logic_vector(7 downto 0);
                frame_len : in std_logic_vector(7 downto 0);
                frame_us : in std_logic_vector(7 downto 0);
                AER_data : in STD_LOGIC_VECTOR (9 downto 0);
                AER_nreq : in STD_LOGIC;
                AER_nack : out STD_LOGIC;
                DataOut : out STD_LOGIC_VECTOR (31 downto 0);
                data_valid : out STD_LOGIC;
                bursting : out std_logic;
                altern : out std_logic
        );
	end component davis_aer_interface;

	component davis_bias_config is
        port (
                clk : in STD_LOGIC;
                rst : in STD_LOGIC;
                enable : in STD_LOGIC; -- Set high to send biases
                bias_mem_0 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_1 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_2 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_3 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_4 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_5 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_6 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_7 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_8 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_9 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_10 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_11 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_12 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_13 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_14 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_15 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_16 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_17 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_18 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_19 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_20 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_mem_21 : in STD_LOGIC_VECTOR(15 downto 0);
                bias_program_enable : in STD_LOGIC;
                BiasAddrSel : out STD_LOGIC; -- 0 for uploading of address, 1 for uploading bias
                BiasBitIN : out STD_LOGIC;
                BiasClock : out STD_LOGIC; -- Starts high
                BiasLatch : out STD_LOGIC; -- Active low
                BiasDiagSel : out STD_LOGIC; -- 1 to select diagnostic register, 0 otherwise
                ready : out STD_LOGIC
        );
	end component davis_bias_config;

	component region_of_exclusion is
        generic (
                num_ROI : integer := 8 
        );
        port (
                clk : in STD_LOGIC;
                rst : in STD_LOGIC;
                evt_in_valid : in STD_LOGIC;
                evt_in_x : in STD_LOGIC_VECTOR(8 downto 0);
                evt_in_y : in STD_LOGIC_VECTOR(7 downto 0);
                evt_in_pol : in STD_LOGIC;
                region_0 : in std_logic_vector(63 downto 0);
                region_1 : in std_logic_vector(63 downto 0);
                region_2 : in std_logic_vector(63 downto 0);
                region_3 : in std_logic_vector(63 downto 0);
                region_4 : in std_logic_vector(63 downto 0);
                region_5 : in std_logic_vector(63 downto 0);
                region_6 : in std_logic_vector(63 downto 0);
                region_7 : in std_logic_vector(63 downto 0);
                evt_out_valid : out STD_LOGIC;
                evt_out_x : out STD_LOGIC_VECTOR(8 downto 0);
                evt_out_y : out STD_LOGIC_VECTOR(7 downto 0);
                evt_out_pol : out STD_LOGIC
        );
	end component region_of_exclusion;

	-- Signals

    -- DAVIS AER
    signal davis_burst_mode : STD_LOGIC;
    signal davis_AER_data : STD_LOGIC_VECTOR ( 9 downto 0 );
    signal davis_AER_nreq : STD_LOGIC;
    signal davis_AER_nack : STD_LOGIC;
    signal davis_DataOut : STD_LOGIC_VECTOR ( 31 downto 0 );
    signal davis_data_valid : STD_LOGIC;
    signal davis_bursting : STD_LOGIC;
    signal davis_altern : STD_LOGIC;

    -- BIAS CONFIG

    -- ROE
    signal roe_evt_out_valid : STD_LOGIC;
    signal roe_evt_in_pol, roe_evt_out_pol : STD_LOGIC;
    signal roe_evt_in_x, roe_evt_out_x : STD_LOGIC_VECTOR(8 downto 0);
    signal roe_evt_in_y, roe_evt_out_y : STD_LOGIC_VECTOR(7 downto 0);
begin
        -- top_evt_clk <= clk;
        davis_burst_mode <= top_burst_en;
        -- top_burst_frame <= davis_burst_mode and davis_bursting;

        davis_AER_data(9 downto 0) <= top_AER_data(9 downto 0);
        davis_AER_nreq <= top_AER_nreq;
        top_AER_nack <= davis_AER_nack;

        top_evt_out_valid <= roe_evt_out_valid;
        top_evt_out_x <= roe_evt_out_x;
        top_evt_out_y <= roe_evt_out_y;
        top_evt_out_pol <= roe_evt_out_pol;
        top_altern <= davis_altern;

        davis_aer_interface_0 : component davis_aer_interface
        generic map(
                ACK_Y_DELAY => 4, 
                ACK_X_DELAY => 2, 
                ACK_Y_EXTENSION => 2, 
                ACK_X_EXTENSION => 1
        )
        port map(
                clk => clk, 
                rst => rst, 
                burst_mode => davis_burst_mode, 
                burst_len(7 downto 0) => top_burst_len(7 downto 0), 
                frame_len(7 downto 0) => top_frame_len(7 downto 0), 
                frame_us(7 downto 0) => top_us_cycle(7 downto 0), 
                AER_data(9 downto 0) => davis_AER_data(9 downto 0), 
                AER_nreq => davis_AER_nreq, 
                AER_nack => davis_AER_nack, 
                DataOut(31 downto 0) => davis_DataOut(31 downto 0), 
                data_valid => davis_data_valid, 
                bursting => davis_bursting, 
                altern => davis_altern
        );

        davis_bias_config_0 : component davis_bias_config
        port map(
                clk => clk,
                rst => rst,
                enable => top_bias_enable,
                bias_mem_0(15 downto 0) => top_bias_mem_0(15 downto 0),
                bias_mem_1(15 downto 0) => top_bias_mem_1(15 downto 0),
                bias_mem_2(15 downto 0) => top_bias_mem_2(15 downto 0),
                bias_mem_3(15 downto 0) => top_bias_mem_3(15 downto 0),
                bias_mem_4(15 downto 0) => top_bias_mem_4(15 downto 0),
                bias_mem_5(15 downto 0) => top_bias_mem_5(15 downto 0),
                bias_mem_6(15 downto 0) => top_bias_mem_6(15 downto 0),
                bias_mem_7(15 downto 0) => top_bias_mem_7(15 downto 0),
                bias_mem_8(15 downto 0) => top_bias_mem_8(15 downto 0),
                bias_mem_9(15 downto 0) => top_bias_mem_9(15 downto 0),
                bias_mem_10(15 downto 0) => top_bias_mem_10(15 downto 0),
                bias_mem_11(15 downto 0) => top_bias_mem_11(15 downto 0),
                bias_mem_12(15 downto 0) => top_bias_mem_12(15 downto 0),
                bias_mem_13(15 downto 0) => top_bias_mem_13(15 downto 0),
                bias_mem_14(15 downto 0) => top_bias_mem_14(15 downto 0),
                bias_mem_15(15 downto 0) => top_bias_mem_15(15 downto 0),
                bias_mem_16(15 downto 0) => top_bias_mem_16(15 downto 0),
                bias_mem_17(15 downto 0) => top_bias_mem_17(15 downto 0),
                bias_mem_18(15 downto 0) => top_bias_mem_18(15 downto 0),
                bias_mem_19(15 downto 0) => top_bias_mem_19(15 downto 0),
                bias_mem_20(15 downto 0) => top_bias_mem_20(15 downto 0),
                bias_mem_21(15 downto 0) => top_bias_mem_21(15 downto 0),
                bias_program_enable => top_bias_program_enable,
                BiasAddrSel => top_BiasAddrSel,
                BiasBitIN => top_BiasBitIN,
                BiasClock => top_BiasClock,
                BiasLatch => top_BiasLatch,
                BiasDiagSel => top_BiasDiagSel,
                ready => top_bias_ready
        );
        
        roe_evt_in_x(8 downto 0) <= '0' & davis_DataOut(17 downto 10);
        roe_evt_in_y(7 downto 0) <= davis_DataOut(9 downto 2);
        roe_evt_in_pol <= davis_DataOut(0);

	   region_of_exclusion_0 : component region_of_exclusion
        generic map(
                num_ROI => 8
        )
        port map(
                clk => clk,
                rst => rst,
                evt_in_valid => davis_data_valid,
                evt_in_x(8 downto 0) => roe_evt_in_x,
                evt_in_y(7 downto 0) => roe_evt_in_y,
                evt_in_pol => roe_evt_in_pol,
                region_0(63 downto 0) => top_region_0(63 downto 0),
                region_1(63 downto 0) => top_region_1(63 downto 0),
                region_2(63 downto 0) => top_region_2(63 downto 0),
                region_3(63 downto 0) => top_region_3(63 downto 0),
                region_4(63 downto 0) => top_region_4(63 downto 0),
                region_5(63 downto 0) => top_region_5(63 downto 0),
                region_6(63 downto 0) => top_region_6(63 downto 0),
                region_7(63 downto 0) => top_region_7(63 downto 0),
                evt_out_valid => roe_evt_out_valid,
                evt_out_x(8 downto 0) => roe_evt_out_x(8 downto 0),
                evt_out_y(7 downto 0) => roe_evt_out_y(7 downto 0),
                evt_out_pol => roe_evt_out_pol
        );
end STRUCTURE;
