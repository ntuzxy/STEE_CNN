`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:26:24 07/09/2020
// Design Name:   BinaryCounter
// Module Name:   C:/Users/Zhang/Desktop/OpalKelly3010_Verilog/simulation/BinarCounter_tb.v
// Project Name:  OpalKelly3010_Verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: BinaryCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BinarCounter_tb;

	// Inputs
	reg clk;
	reg ce;
	reg sclr;

	// Outputs
	wire thresh0;
	wire [4:0] q;

	// Instantiate the Unit Under Test (UUT)
	BinaryCounter
	#(	
	    .ADDR_WIDTH(5),
	    .FINAL_COUNT_VALUE(15)
	) 
	uut (
		.clk(clk), 
		.ce(ce), 
		.sclr(sclr), 
		.thresh0(thresh0), 
		.q(q)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		ce = 0;
		sclr = 1;
		#100;
		sclr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		ce = 1;

	end
    

    always #5 clk = ~clk;  

endmodule

