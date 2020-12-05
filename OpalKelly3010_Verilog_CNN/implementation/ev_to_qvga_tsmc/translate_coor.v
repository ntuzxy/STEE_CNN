// File translate_coor.vhd translated with vhd2vl v2.5 VHDL to Verilog RTL translator
// vhd2vl settings:
//  * Verilog Module Declaration Style: 1995

// vhd2vl is Free (libre) Software:
//   Copyright (C) 2001 Vincenzo Liguori - Ocean Logic Pty Ltd
//     http://www.ocean-logic.com
//   Modifications Copyright (C) 2006 Mark Gonzales - PMC Sierra Inc
//   Modifications (C) 2010 Shankar Giri
//   Modifications Copyright (C) 2002, 2005, 2008-2010, 2015 Larry Doolittle - LBNL
//     http://doolittle.icarus.com/~larry/vhd2vl/
//
//   vhd2vl comes with ABSOLUTELY NO WARRANTY.  Always check the resulting
//   Verilog for correctness, ideally with a formal verification tool.
//
//   You are welcome to redistribute vhd2vl under certain conditions.
//   See the license (GPLv2) file included with the source for details.

// The result of translation follows.  Its copyright status should be
// considered unchanged from the original VHDL.

//--------------------------------------------------------------------------------
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2019 17:17:04
// Design Name: 
// Module Name: translate_coor - Behavioral
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//--------------------------------------------------------------------------------
// Uncomment the following library declaration if using
// arithmetic functions with Signed or Unsigned values
// Uncomment the following library declaration if instantiating
// any Xilinx leaf cells in this code.
//library UNISIM;
//use UNISIM.VComponents.all;
// no timescale needed

module translate_coor(
clk,
rst,
valid,
x,
y,
pol,
x_dim,
y_dim,
valid_o,
addr,
pos,
overflow
);

input clk;
input rst;
input valid;
input [8:0] x;
input [7:0] y;
input pol;
input [8:0] x_dim;
input [7:0] y_dim;
output valid_o;
output [16:0] addr;
output [1:0] pos;
output overflow;

wire clk;
wire rst;
wire valid;
wire [8:0] x;
wire [7:0] y;
wire pol;
wire [8:0] x_dim;
wire [7:0] y_dim;
reg valid_o;
wire [16:0] addr;
reg overflow;
reg [1:0] pos;


reg [16:0] addr_s;

  assign addr = (addr_s);
  always @(posedge clk) begin
    if(rst == 1'b0) begin
        valid_o <= 1'b 1;
        addr_s <= {17{1'b0}};
        pos <= 2'b11;
        overflow <= 1'b 0;
    end
    else if(valid == 1'b 1) begin
      if(((y)) >= ((y_dim)) || ((x)) >= ((x_dim))) begin
        valid_o <= 1'b 1;
        addr_s <= {17{1'b0}};
        pos <= 2'b11;
        overflow <= 1'b 1;
      end
      else begin
        valid_o <= 1'b 0;
        addr_s <= ((((x_dim)) * ((y)))) + ((x));
        overflow <= 1'b 0;
        if(pol == 1) begin
            pos <= 2'b01;
        end
        else begin 
            pos <= 2'b10;
        end
      end
    end
    else begin
        valid_o <= 1'b 1;
        addr_s <= {17{1'b0}};
        pos <= 2'b11;
        overflow <= 1'b 0;
    end
  end


endmodule
