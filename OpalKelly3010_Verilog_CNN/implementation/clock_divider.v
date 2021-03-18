// Verilog project: Verilog code for clock divider on FPGA
// Top level Verilog code for clock divider on FPGA
`timescale 1ns / 1ps

module clock_divider
    #(
    parameter WIDTH   = 16
    )
    (DIVISOR,clock_in,clock_out
    );
input [WIDTH-1:0] DIVISOR;
input  clock_in;  // input clock
output clock_out; // output clock after dividing the input clock by divisor
reg[WIDTH-1:0] counter=0;
// parameter DIVISOR = 28'd2;
// The frequency of the output clk_out
//  = The frequency of the input clk_in divided by DIVISOR
// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
// You will modify the DIVISOR parameter value to 28'd50.000.000
// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
always @(posedge clock_in)
begin
    counter <= counter + 1;
    if(counter>=(DIVISOR-1))
    counter <= 0;
end
assign clock_out = (counter<DIVISOR/2)?1'b0:1'b1;
endmodule