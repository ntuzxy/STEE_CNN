`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:22:28 01/27/2021 
// Design Name: 
// Module Name:    clk_pulse_shift 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_pulse_shift(
    input wire rst,
    input wire clk1, //higher frequency clock
    input wire clk2, //lower frequency clock
    input wire pulse1, //input pulse synchronized by clk1 (one clock cycle)
    output reg pulse2, //output pulse synchronized by clk2 (one clock cycle)
    output reg pulse_flag //pulse ahead
    );

// reg pulse_flag;
always @(posedge clk1 or posedge rst) begin
    if (rst) begin
        pulse_flag <= 0;
    end
    else if (pulse1) begin
        pulse_flag <= 1;
    end
    else if (pulse2) begin
        pulse_flag <= 0;
    end
end

always @(posedge clk2 or posedge rst) begin
    if (rst) begin
        pulse2 <= 0;
    end
    else begin
        if (pulse_flag) begin
            pulse2 <= 1;
        end
        else begin
            pulse2 <= 0;
        end
    end
end

endmodule
