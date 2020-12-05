library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- NOTE! Bias clock config is 100kHz in the inilabs firmware
-- The counter has to be set for the proper number (now tuned for 100 MHz FPGA clock)

entity davis_bias_config is
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
end davis_bias_config;

architecture Behavioral of davis_bias_config is

	component bias_clock_div
		port (
			clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            ce : in STD_LOGIC;
            th : out STD_LOGIC
		);
	end component;
	
	signal current_bias_address : STD_LOGIC_VECTOR(4 downto 0); -- One more to avoid counter overflow
	signal buffered_bias_address : STD_LOGIC_VECTOR(8 downto 0); -- 8 given by CPLD code, 5 is enough really
	signal bias_parallel : STD_LOGIC_VECTOR(15 downto 0);
	signal buffered_bias : STD_LOGIC_VECTOR(15 downto 0);

	-- Let's register the outputs, there seem to be quite a few issues when we multiplex the output to multiple ports?
	signal BiasAddrSel_internal : std_logic;
	signal BiasBitIN_internal : std_logic;
	signal BiasClock_internal : std_logic;
	signal BiasLatch_internal : std_logic;
	signal BiasDiagSel_internal : std_logic;

	signal downsampled_clk : STD_LOGIC;

	signal bitcounter : STD_LOGIC_VECTOR(5 downto 0);
	signal latchcounter : STD_LOGIC_VECTOR(10 downto 0);
	signal startupcounter : STD_LOGIC_VECTOR(15 downto 0);

	signal buffered_chipconfig : STD_LOGIC_VECTOR(55 downto 0);

	signal ready_internal : STD_LOGIC;

	type workState is (Idle, ResettingDiagChain, SendDiagChainUP, SendDiagChainDOWN, LatchingDiagChain, WaitingForStart, Reading, TransmittingAddressUP, TransmittingAddressDOWN, LatchingAddressUP, LatchedAddressDelay, TransmittingBiasUP, TransmittingBiasDOWN, LatchingBiasUP, PauseBeforeReady);
	signal CurrentState : workState;

	-- It seems that when we config the DAVIS through libcaer (epf) the library actually sends the same diagnostic
	-- chain bits many times. I doubt this is necessary but trying doesn't hurt

	signal diagcounter : STD_LOGIC_VECTOR(5 downto 0);
	
	type bias_mem_array is array (0 to 22) of std_logic_vector (15 downto 0);
	signal bias_mem_dist : bias_mem_array;
	signal open_mem : STD_LOGIC_VECTOR(15 downto 0);

begin
	process (clk) begin
	if rising_edge(clk) then
        bias_mem_dist <= (
            bias_mem_0,
            bias_mem_1,
            bias_mem_2,
            bias_mem_3,
            bias_mem_4,
            bias_mem_5,
            bias_mem_6,
            bias_mem_7,
            bias_mem_8,
            bias_mem_9,
            bias_mem_10,
            bias_mem_11,
            bias_mem_12,
            bias_mem_13,
            bias_mem_14,
            bias_mem_15,
            bias_mem_16,
            bias_mem_17,
            bias_mem_18,
            bias_mem_19,
            bias_mem_20,
            bias_mem_21,
            open_mem
        );
    end if;
    end process;
    
    bias_counter_inst : bias_clock_div
    port map(
        clk => clk, 
        rst => rst,
        ce => '1', 
        th => downsampled_clk
    );

	ready <= ready_internal;
	BiasAddrSel <= BiasAddrSel_internal;
	BiasBitIN <= BiasBitIN_internal;
	BiasClock <= BiasClock_internal;
	BiasLatch <= BiasLatch_internal;
	BiasDiagSel <= BiasDiagSel_internal;
	
    process (clk) begin
    if rising_edge(clk) then
        bias_parallel <= bias_mem_dist(to_integer(unsigned(current_bias_address)));
    end if;
    end process;
    
	process (clk) begin
	if rising_edge(clk) then
		-- Restart sending biases if we get a program enable trigger
		if bias_program_enable = '1' then
			ready_internal <= '0';
			startupcounter <= (others => '0');
			current_bias_address <= (others => '0');
			diagcounter <= (others => '0');
		end if;
		if downsampled_clk = '1' then
			if rst = '0' or enable = '0' then
				ready_internal <= '0';
				diagcounter <= (others => '0');
				bitcounter <= (others => '0');
                latchcounter <= (others => '0');
				current_bias_address <= (others => '0');
				BiasClock_internal <= '1'; -- Default states, as per CPLD source
				BiasLatch_internal <= '1';
				BiasAddrSel_internal <= '1';
				BiasBitIN_internal <= '0';
				BiasDiagSel_internal <= '0';
				startupcounter <= (others => '0');
				CurrentState <= WaitingForStart;
				open_mem <= (others => '0');
                buffered_bias_address <= (others => '0');
                buffered_bias <= (others => '0');
			else
				if enable = '1' then
					-- Do things
					case CurrentState is
						when WaitingForStart => 
							-- Only do things if we are not ready yet or if we have to program from the PS side
							if ready_internal = '0' then
								startupcounter <= startupcounter + '1';
								if unsigned(startupcounter) = 2000 then -- 50 ms at 100kHz downsampled clock
									CurrentState <= Idle;
								end if;
							end if;
						when Idle => 
							-- Increase address of bias_mem
							BiasLatch_internal <= '1';
							BiasDiagSel_internal <= '0';
							BiasClock_internal <= '1';
							BiasAddrSel_internal <= '1';
							BiasBitIN_internal <= '0';
							bitcounter <= (others => '0');
							latchcounter <= (others => '0');
							buffered_bias_address <= (others => '0');
							buffered_bias <= (others => '0');
							if unsigned(current_bias_address) = 22 then
								CurrentState <= ResettingDiagChain;
							else
								CurrentState <= Reading;
							end if;
						when Reading => 
							-- Read the data from memory and prepare the buffer
							buffered_bias_address(4 downto 0) <= current_bias_address(4 downto 0);
							current_bias_address <= current_bias_address + '1';
							buffered_bias <= bias_parallel; -- READ VALUE FROM MEM
							BiasAddrSel_internal <= '0'; -- Set to transmit address mode
							CurrentState <= TransmittingAddressUP;
						when TransmittingAddressUP => 
							-- Transmit the address one bit at a time
							BiasBitIN_internal <= buffered_bias_address(7);
							buffered_bias_address(7 downto 1) <= buffered_bias_address(6 downto 0); -- And shift left one bit
							--BiasClock_internal <= '1';
							if unsigned(bitcounter) = 8 then
								CurrentState <= LatchingAddressUP;
							else
								CurrentState <= TransmittingAddressDOWN;
							end if;
						when TransmittingAddressDOWN => 
							-- Dummy state for clock switching
							BiasClock_internal <= '0';
							bitcounter <= bitcounter + '1';
							CurrentState <= TransmittingAddressUP;
						when LatchingAddressUP => 
							-- Latch the address for ten clock cycles
							--BiasClock_internal <= '1';
							BiasLatch_internal <= '0';
							latchcounter <= latchcounter + '1';
							if unsigned(latchcounter) = 20 then
								latchcounter <= (others => '0');
								bitcounter <= (others => '0');
								BiasLatch_internal <= '1';
								CurrentState <= LatchedAddressDelay;
							end if;
						when LatchedAddressDelay => 
							CurrentState <= TransmittingBiasUP; -- Wait one clock cycle
						when TransmittingBiasUP => 
							BiasLatch_internal <= '1';
							-- Transmit the bias one bit at a time
							BiasAddrSel_internal <= '1'; -- Set to bias mode
							BiasBitIN_internal <= buffered_bias(15);
							buffered_bias(15 downto 1) <= buffered_bias(14 downto 0); -- Shift left one bit
							-- BiasClock_internal <= '1';
							if unsigned(bitcounter) = 16 then
								CurrentState <= LatchingBiasUP;
							else
								CurrentState <= TransmittingBiasDOWN;
							end if;
						when TransmittingBiasDOWN => 
							-- BiasClock_internal <= '0';
							bitcounter <= bitcounter + '1';
							CurrentState <= TransmittingBiasUP;
						when LatchingBiasUP => 
							BiasClock_internal <= '1';
							BiasLatch_internal <= '0';
							latchcounter <= latchcounter + '1';
							if unsigned(latchcounter) = 20 then
								BiasAddrSel_internal <= '1';
								CurrentState <= Idle;
							end if;
						when ResettingDiagChain => 
							-- Send a bunch of zeros to the diagnostic chain register
							BiasDiagSel_internal <= '1';
							BiasLatch_internal <= '1';
							BiasAddrSel_internal <= '1';
							buffered_chipconfig <= X"00000000450000";
							bitcounter <= (others => '0');
							latchcounter <= (others => '0');
							CurrentState <= SendDiagChainUP;
						when SendDiagChainUP => 
							-- Send default config
							BiasBitIN_internal <= buffered_chipconfig(55);
							buffered_chipconfig(55 downto 1) <= buffered_chipconfig(54 downto 0);
							-- BiasClock_internal <= '1';
							if unsigned(bitcounter) = 56 then
								CurrentState <= LatchingDiagChain;
							else
								CurrentState <= SendDiagChainDOWN;
							end if;
						when SendDiagChainDOWN => 
							-- BiasClock_internal <= '0';
							bitcounter <= bitcounter + '1';
							CurrentState <= SendDiagChainUP;
						when LatchingDiagChain => 
							BiasLatch_internal <= '0';
							latchcounter <= latchcounter + '1';
							if unsigned(latchcounter) = 20 then
								diagcounter <= diagcounter + '1';
								latchcounter <= (others => '0');
								BiasDiagSel_internal <= '0';
								BiasLatch_internal <= '1';
								if unsigned(diagcounter) = 10 then
									CurrentState <= PauseBeforeReady;
								else
									CurrentState <= ResettingDiagChain;
								end if; 
							end if;
						when PauseBeforeReady => 
							-- Wait a bunch of clock cycles
							latchcounter <= latchcounter + '1';
							if unsigned(latchcounter) = 500 then
								ready_internal <= '1';
								CurrentState <= WaitingForStart;
							end if;
					end case;
				end if;
			end if;
		else
			-- Play with the clock to make sure we always read valid data
			case CurrentState is
				when TransmittingAddressUP => 
					BiasClock_internal <= '1';
				when TransmittingAddressDOWN => 
					BiasClock_internal <= '0';
				when TransmittingBiasUP => 
					BiasClock_internal <= '1';
				when TransmittingBiasDOWN => 
					BiasClock_internal <= '0';
				when SendDiagChainUP => 
					BiasClock_internal <= '1';
				when SendDiagChainDOWN => 
					BiasClock_internal <= '0';
				when others => 
					null;
			end case;
		end if;
	end if;
end process;
end Behavioral;