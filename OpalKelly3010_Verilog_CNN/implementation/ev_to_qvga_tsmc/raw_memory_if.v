`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2020 17:09:17
// Design Name: 
// Module Name: raw_memory_if
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
//////////////////////////////////////////////////////////////////////////////////


module raw_memory_if(
addr,
pos,
valid,
en,
data,
clr,
top_addr_dbg,
top_pos_dbg,
top_valid_dbg,
top_en_dbg,
top_data_dbg,
top_clr_dbg,
clk
);

input [16:0] addr;
input [1:0] pos;
input en;
input valid;
input clk;
input clr;
output [1:0] data;

input [16:0] top_addr_dbg;
input [1:0] top_pos_dbg;
input top_en_dbg;
input top_valid_dbg;
input top_clr_dbg;
output [1:0] top_data_dbg;

wire [1:0] DA, DB;
reg WEBA_S, WEBA_B, WEBB_S, WEBB_B;
reg [1:0] QA, QB;

wire [1:0] BWEBA_S, BWEBA_B, BWEBB_S, BWEBB_B;
wire [13:0] A_S, B_S;
wire [15:0] A_B, B_B;
wire [1:0] QA_S, QA_B, QB_S, QB_B;
wire select, select_dbg;

TSDN65LPLLA16384X2M8S raw_s (.AA(A_S), .DA(DA), .BWEBA(BWEBA_S), .WEBA(WEBA_S), .CEBA(en), .CLKA(clk),
  .AB(B_S), .DB(DB), .BWEBB(BWEBB_S), .WEBB(WEBB_S), .CEBB(top_en_dbg), .CLKB(clk), 
  .QA(QA_S), .QB(QB_S));

TSDN65LPLLA65536X2M32S raw_b (.AA(A_B), .DA(DA), .BWEBA(BWEBA_B), .WEBA(WEBA_B), .CEBA(en), .CLKA(clk),
  .AB(B_B), .DB(DB), .BWEBB(BWEBB_B), .WEBB(WEBB_B), .CEBB(top_en_dbg), .CLKB(clk), 
  .QA(QA_B), .QB(QB_B));

assign A_S = (addr[13:0]);
assign A_B = (addr[15:0]);

assign B_S = (top_addr_dbg[13:0]);
assign B_B = (top_addr_dbg[15:0]);

assign BWEBA_S = (pos);
assign BWEBA_B = (pos);

assign BWEBB_S = (top_pos_dbg);
assign BWEBB_B = (top_pos_dbg);

assign select = (addr[16]);
assign select_dbg = (top_addr_dbg[16]);

assign data = (QA);
assign top_data_dbg = (QB);

assign DA = (clr == 1'b1) ? 2'b00 : 2'b11;
assign DB = (top_clr_dbg == 1'b1) ? 2'b00 : 2'b11;

always @(valid, select) begin
    if (valid == 1'b0) begin
        if (select == 1'b1) begin
            WEBA_B = 1'b1;
            WEBA_S = 1'b0;
        end
        else begin
            WEBA_B = 1'b0;
            WEBA_S = 1'b1;
        end
    end
    else begin
        WEBA_B = 1'b1;
        WEBA_S = 1'b1;
    end
end

always @(select, QA_S, QA_B)
begin
    case (select)
        0 : QA = QA_B;
        1 : QA = QA_S;
        default : QA = 2'b00;
    endcase
end

always @(top_valid_dbg, select_dbg) begin
    if (top_valid_dbg == 1'b0) begin
        if (select_dbg == 1'b1) begin
            WEBB_B = 1'b1;
            WEBB_S = 1'b0;
        end
        else begin
            WEBB_B = 1'b0;
            WEBB_S = 1'b1;
        end
    end
    else begin
        WEBB_B = 1'b1;
        WEBB_S = 1'b1;
    end
end

always @(select_dbg, QB_S, QB_B)
begin
    case (select_dbg)
        0 : QB = QB_B;
        1 : QB = QB_S;
        default : QB = 2'b00;
    endcase
end

endmodule
