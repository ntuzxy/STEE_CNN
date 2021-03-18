`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:40:03 01/27/2021
// Design Name:   clk_pulse_shift
// Module Name:   F:/STEE_PROJ/CONV/OpalKelly3010_Verilog_CNN/simulation/tb_clk_pulse_shift.v
// Project Name:  OpalKelly3010_Verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clk_pulse_shift
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_clk_pulse_shift;

	// Inputs
	reg rst;
	reg clk1;
	reg clk2;
	reg pulse1;

	// Outputs
	wire pulse2;
	wire pulse_flag;

	// Instantiate the Unit Under Test (UUT)
	clk_pulse_shift uut (
		.rst(rst), 
		.clk1(clk1), 
		.clk2(clk2), 
		.pulse1(pulse1), 
		.pulse2(pulse2), 
		.pulse_flag(pulse_flag)
	);

	initial clk1 = 0; 
	always #5 clk1 = ~clk1;
	initial clk2 = 0; 
	always #20 clk2 = ~clk2;

	initial begin
		// Initialize Inputs
		rst = 1;
		pulse1 = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 0;
        
		// Add stimulus here
		#5.5;
		pulse1 = 1;
		#10;
		pulse1 = 0;


	end
      
endmodule

