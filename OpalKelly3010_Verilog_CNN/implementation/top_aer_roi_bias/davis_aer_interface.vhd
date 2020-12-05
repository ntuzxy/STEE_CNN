----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.04.2017 14:59:38
-- Design Name: 
-- Module Name: davis_aer_interface - Behavioral
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
--use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;

-- For log2b operations
use IEEE.MATH_REAL.ALL;
--use work.ATISpackage.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity davis_aer_interface is
    generic (
                ACK_Y_DELAY : integer := 12; -- 4 for 90 MHz in libcaer
                ACK_X_DELAY : integer := 2; -- 0 in libcaer
                ACK_Y_EXTENSION : integer := 6; -- 1 in libcaer
                ACK_X_EXTENSION : integer := 1 -- 0 in libcaer
            );
    Port (
             clk        :   in std_logic;
             rst        :   in std_logic;
             burst_mode :   in std_logic;
             burst_len  :   in std_logic_vector(7 downto 0);
             frame_len  :   in std_logic_vector(7 downto 0);
             frame_us   :   in std_logic_vector(7 downto 0);
             AER_data   :   in std_logic_vector(9 downto 0);
             AER_nreq   :   in std_logic;

             AER_nack   :   out std_logic;
             DataOut    :   out std_logic_vector(31 downto 0);
             data_valid :   out std_logic;
             bursting   :   out std_logic;
             altern     :   out std_logic
         );
end davis_aer_interface;

architecture Behavioral of davis_aer_interface is

    signal  frame_timer, frame_period, burst_timer, burst_period    : STD_LOGIC_VECTOR(31 downto 0);
    signal  frame_us_in : unsigned(23 downto 0);
    signal  timer_advance, timer_error  : STD_LOGIC;
    signal  get_burst   : STD_LOGIC;

    signal TD_X, TD_Y   : std_logic_vector(7 downto 0);
    signal event_valid_internal  : std_logic;

    signal AER_ack_internal : STD_LOGIC;
    signal AER_req_internal : std_logic;
    signal AER_req_sync : std_logic;

    signal ack_cycle_counter : STD_LOGIC_VECTOR(4 downto 0);
    signal ext_cycle_counter : STD_LOGIC_VECTOR(4 downto 0);

    signal polarity     : std_logic;

    type workstate_type is (idle, acknowledging, wait_for_ack_y, extend_ack_y, wait_for_ack_x, extend_ack_x);
    signal workstate    : workstate_type;

begin

bursting <= get_burst;
AER_nack <= not AER_ack_internal;

frame_us_in <= to_unsigned(1000, 16) * unsigned(frame_us);
frame_period <= std_logic_vector( unsigned(frame_len) * frame_us_in );
burst_period <= std_logic_vector( unsigned(burst_len) * frame_us_in );

process(clk) begin
    if rising_edge(clk) then
        if rst = '0' then
            frame_timer <= (others => '0');
            timer_advance <= '0';
            timer_error <= '0';
        elsif burst_mode = '1' then
            timer_error <= '0';
            if frame_timer = frame_period then
                frame_timer <= (others => '0');
                if timer_advance = '0' then
                    timer_advance <= '1';
                else
                    timer_error <= '1';
                    timer_advance <= '0';
                end if;
            else
                frame_timer <= frame_timer + "01";
                timer_advance <= '0';
            end if;
        else
            frame_timer <= (others => '0');
            timer_advance <= '0';
            timer_error <= '0';
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if rst = '0' then
            burst_timer <= (others => '0');
            altern <= '0';
            get_burst <= '0';
        elsif timer_advance = '1' then
            burst_timer <= (others => '0');
            altern <= '0';
            
            get_burst <= '1';
        elsif get_burst = '1' then
            altern <= '0';
            if burst_timer = burst_period then
                burst_timer <= (others => '0');
                
                get_burst <= '0';
                altern <= '1';
            else
                burst_timer <= burst_timer + "01";
            end if;
        else
            burst_timer <= (others => '0');
            altern <= '0';
        end if;
    end if;
end process;


process(clk) begin
    if rising_edge(clk) then

        if rst = '0' then
            -- Reset things
            workstate   <= idle;
            AER_ack_internal <= '0';
            AER_req_sync <= '0';
            AER_req_internal <= '0';
            ack_cycle_counter <= (others => '0');
            ext_cycle_counter <= (others => '0');
           
            DataOut <= (others => '0');
            data_valid <= '0';
            workstate <= idle;
        else
            AER_req_sync <= not AER_nreq;
            AER_req_internal <= AER_req_sync;

            case workstate is

                when idle => 
                    if burst_mode = '1' then
                        if (AER_req_internal = '1' and AER_req_sync = '1' and AER_nreq = '0' and get_burst = '1') or timer_advance = '1' then
                            if AER_data(9) = '1' then
                               ack_cycle_counter <= (others => '0');
                               TD_X <= AER_data(8 downto 1);
                               polarity <= AER_data(0);
                               
                               workstate <= wait_for_ack_x;
                            else
                               ack_cycle_counter <= (others => '0');
                               TD_Y <= std_logic_vector(to_unsigned(179, 8) - unsigned(AER_data(7 downto 0)));
    
                               if timer_advance = '1' then
                                    workstate <= extend_ack_y;
                                    AER_ack_internal <= '1';
                              else
                                   workstate <= wait_for_ack_y;
                              end if;
                            end if;
                        end if;
                    else
                        if  AER_req_internal = '1' and AER_req_sync = '1' and AER_nreq = '0' then
                            if AER_data(9) = '1' then
                               -- We have X information in the AER
                                ack_cycle_counter <= (others => '0');
                                TD_X <= AER_data(8 downto 1);
                                polarity <= AER_data(0);
                               --                           event_valid_internal <= '1';
                                workstate <= wait_for_ack_x;
                            else
                                -- We have Y information in the bus
                                ack_cycle_counter <= (others => '0');
                                -- HARDCODED VALUE FOR DAVIS240
                                TD_Y <= std_logic_vector(to_unsigned(179, 8) - unsigned(AER_data(7 downto 0)));
                                workstate <= wait_for_ack_y;
                            end if;
                        end if;
                    end if;

                when wait_for_ack_y =>
                    -- Wait 4 clock cycles before ack
                    -- Make sure that the request signal is still asserted
                    -- To avoid that single assertion cycles (glitches) might be interpreted as a request
                    if AER_req_internal = '1' then
                        ack_cycle_counter <= ack_cycle_counter + '1';
                        if unsigned(ack_cycle_counter) = ACK_Y_DELAY then
                            ext_cycle_counter <= (others => '0');
                            workstate <= extend_ack_y;
                            AER_ack_internal <= '1';
                        end if;
                    else
                        -- It was a glitch, go back to the previous state
                        workstate <= idle;
                    end if;

                when extend_ack_y =>
                    -- Extend for additional clock cycles
                    ext_cycle_counter <= ext_cycle_counter + '1';
                    if unsigned(ext_cycle_counter) = ACK_Y_EXTENSION then
                        workstate <= acknowledging;
                    end if;

                when wait_for_ack_x =>
                    -- Wait 4 clock cycles before ack
                    -- Make sure that the request signal is still asserted
                    -- To avoid that single assertion cycles (glitches) might be interpreted as a request
                    if AER_req_internal = '1' then
                        ack_cycle_counter <= ack_cycle_counter + '1';
                        if unsigned(ack_cycle_counter) = ACK_X_DELAY then
                            ext_cycle_counter <= (others => '0');
                            workstate <= extend_ack_x;
                            AER_ack_internal <= '1';
                        end if;
                    else
                        -- It was a glitch, go back to the previous state
                        workstate <= idle;
                    end if;

                when extend_ack_x =>
                    -- Extend for additional clock cycles
                    ext_cycle_counter <= ext_cycle_counter + '1';
                    if unsigned(ext_cycle_counter) = ACK_X_EXTENSION then
                        event_valid_internal <= '1';
                        workstate <= acknowledging;
                    end if;

                when acknowledging => 
                    event_valid_internal <= '0';
                    if  AER_req_internal = '0' then
                        workstate <= idle;
                        -- Deassert the ack line
                        AER_ack_internal <= '0';
                    end if;

            end case;

            if (event_valid_internal = '1') then
                -- Send the event, mostly copied from the atis aer interface, will also need byte swapping, maybe fix in the future?
                -- Swapped the bits now, no need for an additional block
                -- New compressed format for smaller events, 32 bits:
                -- 0 : polarity
                -- 1 : Camera num
                -- 2-9 : Y address
                -- 10-17 : X address
                -- 18 - 31 : Timestamp
                DataOut(0) <= polarity;
                DataOut(1) <= '0';
                DataOut(9 downto 2) <= TD_Y;
                DataOut(17 downto 10) <= TD_X;
                DataOut(31 downto 18) <= (others => '0');
                data_valid <= '1';
            else
                data_valid <= '0';
            end if; 
        end if;        
    end if;
end process;

end Behavioral;
