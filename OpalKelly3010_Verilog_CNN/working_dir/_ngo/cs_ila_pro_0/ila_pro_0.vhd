-------------------------------------------------------------------------------
-- Copyright (c) 2020 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : ila_pro_0.vhd
-- /___/   /\     Timestamp  : Tue Nov 24 14:24:35 Malay Peninsula Standard Time 2020
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ila_pro_0 IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    TRIG0: in std_logic_vector(3 downto 0);
    TRIG1: in std_logic_vector(16 downto 0);
    TRIG2: in std_logic_vector(2 downto 0);
    TRIG3: in std_logic_vector(16 downto 0);
    TRIG4: in std_logic_vector(7 downto 0);
    TRIG5: in std_logic_vector(7 downto 0);
    TRIG6: in std_logic_vector(1 downto 0));
END ila_pro_0;

ARCHITECTURE ila_pro_0_a OF ila_pro_0 IS
BEGIN

END ila_pro_0_a;
