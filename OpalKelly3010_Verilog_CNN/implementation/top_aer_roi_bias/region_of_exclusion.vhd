----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 08.11.2019 15:32:20
-- Design Name:
-- Module Name: region_of_exclusion - Behavioral
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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity region_of_exclusion is
	generic (
		num_ROI : integer := 8 
	);
	port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
 
		--input events
		evt_in_valid : in STD_LOGIC;
		evt_in_x : in STD_LOGIC_VECTOR(8 downto 0);
		evt_in_y : in STD_LOGIC_VECTOR(7 downto 0);
		evt_in_pol : in STD_LOGIC;
 		
		--ROIs
		region_0 : in std_logic_vector(63 downto 0);
        region_1 : in std_logic_vector(63 downto 0);
        region_2 : in std_logic_vector(63 downto 0);
        region_3 : in std_logic_vector(63 downto 0);
        region_4 : in std_logic_vector(63 downto 0);
        region_5 : in std_logic_vector(63 downto 0);
        region_6 : in std_logic_vector(63 downto 0);
        region_7 : in std_logic_vector(63 downto 0);
 
		--output events
		evt_out_valid : out STD_LOGIC;
		evt_out_x : out STD_LOGIC_VECTOR(8 downto 0);
		evt_out_y : out STD_LOGIC_VECTOR(7 downto 0);
		evt_out_pol : out STD_LOGIC
	);
end region_of_exclusion;

architecture Behavioral of region_of_exclusion is

type region_array_t is array (num_ROI - 1 downto 0) of std_logic_vector (63 downto 0);
signal region_array : region_array_t;

type ROI_box_record is record
	min_x : std_logic_vector(15 downto 0);
	max_x : std_logic_vector(15 downto 0);
	min_y : std_logic_vector(15 downto 0);
	max_y : std_logic_vector(15 downto 0);
end record ROI_box_record;

signal box_check_valid : STD_LOGIC_VECTOR(num_ROI - 1 downto 0);

type ROI_boxes_type is array (num_ROI - 1 downto 0) of ROI_box_record; 

signal ROI_boxes : ROI_boxes_type;

signal evt_internal_valid, evt_internal_pol : STD_LOGIC;
signal evt_internal_x : STD_LOGIC_VECTOR(8 downto 0);
signal evt_internal_y : STD_LOGIC_VECTOR(7 downto 0);
signal evt_out_valid_reg : STD_LOGIC;

begin
	process (clk) begin
	if rising_edge(clk) then
        region_array <= (
            region_0,
            region_1,
            region_2,
            region_3,
            region_4,
            region_5,
            region_6,
            region_7
        );
    end if;
    end process;
	evt_out_valid <= evt_out_valid_reg;
        
	process (clk) begin
	if rising_edge(clk) then
		if rst = '0' then
			--ROI_boxes <= (others => (others => (others => '0'))); --xueyong 20201020, for sim in ISE
			evt_internal_valid <= '0';
			evt_internal_x <= (others => '0');
			evt_internal_y <= (others => '0');
			evt_internal_pol <= '0';
			evt_out_valid_reg <= '0';
            evt_out_x <= (others => '0');
            evt_out_y <= (others => '0');
            evt_out_pol <= '0';
		else
			-- program the ROI
            for ii in num_ROI - 1 downto 0 loop
                ROI_boxes(ii).min_x <= region_array(ii)(63 downto 48);
                ROI_boxes(ii).max_x <= region_array(ii)(47 downto 32);
                ROI_boxes(ii).min_y <= region_array(ii)(31 downto 16);
                ROI_boxes(ii).max_y <= region_array(ii)(15 downto 0);
            end loop;
 
			-- register the event coming in
			evt_internal_valid <= evt_in_valid;
			evt_internal_x <= evt_in_x;
			evt_internal_y <= evt_in_y;
			evt_internal_pol <= evt_in_pol;
 
			-- check input event against each ROI
			for ii in num_ROI - 1 downto 0 loop
				if (unsigned(evt_in_x) < unsigned(ROI_boxes(ii).min_x)) or (unsigned(evt_in_y) < unsigned(ROI_boxes(ii).min_y)) or (unsigned(evt_in_x) > unsigned(ROI_boxes(ii).max_x)) or (unsigned(evt_in_y) > unsigned(ROI_boxes(ii).max_y)) then
					box_check_valid(ii) <= '0'; --event lies outside the ROI
				else
					box_check_valid(ii) <= '1'; --event lies within the ROI
				end if;
			end loop;
 
			-- if event doesn't lie in any ROI, output the event
			if evt_internal_valid = '1' then
				if unsigned(box_check_valid) = 0 then
					evt_out_valid_reg <= '1'; 
					evt_out_x <= evt_internal_x; 
					evt_out_y <= evt_internal_y;
					evt_out_pol <= evt_internal_pol;
				else
					evt_out_valid_reg <= '0';
				end if;
			else
				evt_out_valid_reg <= '0';
			end if;
		end if;
	end if;
end process;
end Behavioral;