`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhang Lei
// 
// Create Date: 12/06/2019 02:40:18 PM
// Design Name: 
// Module Name: RP2serial
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


module serial2RP
  #(
  parameter MAX_NUM_OBJ = 8,
  parameter X_WIDTH = 9,
  parameter Y_WIDTH = 9
  )
  (
  input clk,
  input reset,

  // RP output from FIFO 
  output [X_WIDTH-1:0] region_x, //compatible 320 x 240 resolution
  output [X_WIDTH-1:0] region_y,
  output region_valid,
  input  region_rd_en,

  // interface to RP2serial
  output reg cnn_rd_region,
  input cnn_region_done,
  input cnn_region_valid,
  input cnn_region_x_bit,
  input cnn_region_y_bit,
  input cnn_burst_en
  
  );

wire fifo_region_we;
reg [X_WIDTH-1:0] region_x_temp;
reg [Y_WIDTH-1:0] region_y_temp;

// store to fifo
wire fifo_region_x_emtpy;
wire fifo_region_x_valid;
FWFT_FIFO #(.DATA_WIDTH(X_WIDTH),.FIFO_DEPTH(MAX_NUM_OBJ*2))
fifo_region_x(
    .CLK    (clk),
    .RST    (reset),
    .WriteEn(fifo_region_we),
    .DataIn (region_x_temp),
    .ReadEn (region_rd_en),
    .DataOut(region_x),
    .Empty  (fifo_region_x_emtpy),
    .Full   ()
);

assign region_valid = ~fifo_region_x_emtpy;

wire fifo_region_y_emtpy;
FWFT_FIFO #(.DATA_WIDTH(Y_WIDTH),.FIFO_DEPTH(MAX_NUM_OBJ*2))
fifo_region_y(
    .CLK    (clk),
    .RST    (reset),
    .WriteEn(fifo_region_we),
    .DataIn (region_y_temp),
    .ReadEn (region_rd_en),
    .DataOut(region_y),
    .Empty  (),
    .Full   ()
);


reg region_rd_over;

reg [2:0] read_stm_state;
reg [3:0] bit_cnt;

// read x and y and store in list
// assert region_rd_over to trigger next state machine 
always @ (posedge clk) begin
  if (reset) begin
        cnn_rd_region   <= 0; 

        read_stm_state <= 0;
        bit_cnt <= 0;
        region_x_temp <= 0;
        region_y_temp <= 0;

    end else begin
        case(read_stm_state)
        0: begin // wait
            cnn_rd_region  <= 0; 
            read_stm_state <= 0;
            region_x_temp  <= 0;
            region_y_temp  <= 0;

            if (cnn_region_done) begin
                cnn_rd_region <= 1;
                read_stm_state <= 1;
            end
        end
        1: begin //read
            if (cnn_region_done) begin
                cnn_rd_region <= 1;
                read_stm_state <= 1;

                if (cnn_region_valid) begin
                    bit_cnt <= bit_cnt + 1;
                    region_x_temp <= {cnn_region_x_bit, region_x_temp[X_WIDTH-1:1]}; // LSB first
                    region_y_temp <= {cnn_region_y_bit, region_y_temp[Y_WIDTH-1:1]};
                end else begin //read over
                    region_x_temp <= 0;
                    region_y_temp <= 0;
                    bit_cnt <= 0;
                end 
                
            end else begin
                cnn_rd_region <= 0;
                read_stm_state <= 0;
                bit_cnt <= 0;
                region_x_temp  <= 0;
                region_y_temp  <= 0;
            end
            
        end
        default: begin
            cnn_rd_region   <= 0; 
            read_stm_state <= 0;
            bit_cnt <= 0;
            region_x_temp <= 0;
            region_y_temp <= 0;

        end
        endcase

    end
end

assign fifo_region_we = (bit_cnt == X_WIDTH) ? 1 : 0;
  
endmodule
