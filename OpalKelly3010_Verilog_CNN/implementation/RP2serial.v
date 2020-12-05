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
// `include "..\implementation\define.h"

module RP2serial
  #(
  parameter MAX_NUM_OBJ = 8,
  parameter X_WIDTH = 9,
  parameter Y_WIDTH = 9,
  parameter CLK_DIVISOR = 5

  )
  (
  input wire clk,
  input wire reset,
  input wire reset_new,
  // interface to RP
  // input [$clog2(MAX_NUM_OBJ*2)-1:0] num_obj,
  input wire [4:0] num_obj,
  input wire [X_WIDTH-1:0] region_x, //compatible 320 x 240 resolution
  input wire [Y_WIDTH-1:0] region_y,
  input wire region_valid,
  output reg region_rd_en,

  // interface to CNN
  input  wire cnn_rd_region,
  output reg  cnn_region_done,
  output reg  cnn_region_valid,
  output wire cnn_region_x_bit,
  output wire cnn_region_y_bit,
  output wire cnn_region_clk
  
  );

reg [X_WIDTH-1:0] region_x_list [0:MAX_NUM_OBJ*2-1];//max MAX_NUM_OBJ object
reg [Y_WIDTH-1:0] region_y_list [0:MAX_NUM_OBJ*2-1];
// reg [`clog2(MAX_NUM_OBJ*2)-1:0] region_cnt, region_num; //start from 1 to object number
reg [4:0] region_cnt, region_num; //start from 1 to object number
reg region_rd_over;
reg state_sync;

reg [2:0] read_stm_state;

// read x and y and store in list
// assert region_rd_over to trigger next state machine 
always @ (posedge clk) begin
  if (reset) begin
        region_cnt     <= 0;
        region_rd_en   <= 0; 
        read_stm_state <= 0;
        region_rd_over <= 0;
        region_num     <= 0;
    end else begin
        case(read_stm_state)
        0: begin // wait
            region_cnt     <= 0;
            region_rd_en   <= 0; 
            read_stm_state <= 0;
            region_rd_over <= 0;
            if (region_valid) begin
                if (num_obj > 0) begin
                    region_num <= num_obj;
                    region_rd_en   <= 1;
                    read_stm_state <= 1;
                end
            end
        end
        1: begin //read
            if (region_valid) begin
                region_rd_en <= 1;
                region_x_list[region_cnt] <= region_x;
                region_y_list[region_cnt] <= region_y;
                region_cnt <= region_cnt + 1;
                region_rd_over <= 0;
                read_stm_state <= 1;
            end else begin //read over
                region_rd_en <= 0;
                region_rd_over <= 1;
                region_cnt <= 0;
                read_stm_state <= 2; //wait 
            end 
        end
        2: begin //wait sync
            region_rd_en <= 0;
            region_rd_over <= 1;
            region_cnt <= 0;
           if (state_sync) begin
               read_stm_state <= 0;
           end else begin
               read_stm_state <= 2;
           end
        end
        default: begin
            region_cnt     <= 0;
            region_rd_en   <= 0; 
            read_stm_state <= 0;
            region_rd_over <= 0;
        end
        endcase

    end
end

// output clock gen 
reg [7:0] cnt;
reg clk_div;
always @ (posedge clk) begin
   if (reset_new) begin
       cnt <= 0;
       clk_div <= 0;
   end else begin
       if (cnt == CLK_DIVISOR) begin
           cnt <= 0;
           clk_div <= ~clk_div;
       end else begin
           cnt <= cnt + 1;
       end
   end 
end

assign cnn_region_clk = clk_div;

reg [2:0] main_stm_state;
reg [5:0] cnt_index; //max 16
reg [X_WIDTH-1:0] x_out_buf;
reg [Y_WIDTH-1:0] y_out_buf;
reg [4:0] bit_cnt;
reg x_bit_internal, y_bit_internal;

always @ (posedge clk_div) begin
    if (reset) begin
        main_stm_state <= 0;
 
        bit_cnt <= 0;
        cnt_index <= 0;
        cnn_region_valid <= 0;
        cnn_region_done <= 0;

        x_out_buf <= 0;
        y_out_buf <= 0;
        x_bit_internal <= 0;
        y_bit_internal <= 0;

        state_sync <= 0;
        
    end else begin
        case (main_stm_state)
            0: begin //idle and wait for start
                main_stm_state <= 0;
        
                cnt_index <= 0;
                bit_cnt <= 0;

                cnn_region_valid <= 0;
                cnn_region_done <= 0;

                x_out_buf <= 0;
                y_out_buf <= 0;

                state_sync <= 0;

                x_bit_internal <= 0;
                y_bit_internal <= 0;
        
                if (region_rd_over) begin
                    main_stm_state <= 1;
                    state_sync <= 1;
                end
            end

            1: begin // wait for reading
              state_sync <= 0;
              bit_cnt <= 0;
              cnn_region_valid <= 0;
              cnn_region_done <= 1;
              x_out_buf <= 0;
              y_out_buf <= 0;
              x_bit_internal <= 0;
              y_bit_internal <= 0;
              if (cnn_rd_region) begin
                main_stm_state <= 2;
              end else begin
                main_stm_state <= 1;
              end 
            end

            2: begin //get a region
                state_sync <= 0;
                bit_cnt <= 0;
                cnn_region_valid <= 0;
                cnn_region_done <= 1;
                x_bit_internal <= 0;
                y_bit_internal <= 0;
                if (cnt_index < region_num*2) begin
                    x_out_buf <= region_x_list[cnt_index];
                    y_out_buf <= region_y_list[cnt_index];

                    // update counter
                    cnt_index <= cnt_index + 1;

                    main_stm_state <= 3; //start to loop every pixel
                end else begin
                    main_stm_state <= 4; //all done 
                end
            end

            3: begin //output region
                state_sync <= 0;
                cnn_region_done <= 1;
                if (bit_cnt < X_WIDTH) begin
                  bit_cnt <= bit_cnt + 1;
                  x_bit_internal <= x_out_buf[0];
                  y_bit_internal <= y_out_buf[0];
                  x_out_buf <= x_out_buf >> 1;
                  y_out_buf <= y_out_buf >> 1;

                  cnn_region_valid <= 1;
                  main_stm_state <= 3;
                end else begin
                  cnn_region_valid <= 0;
                  x_bit_internal <= 0;
                  y_bit_internal <= 0;
                  main_stm_state <= 2; // get a new region
                end
            end

            4: begin //all done
                state_sync <= 0;
                main_stm_state <= 0;
                cnn_region_done <= 0;
                // obj_cnt <= 0;
                cnt_index <= 0;
            end
            
          default: main_stm_state <= 0;
        endcase
    end
end

assign cnn_region_x_bit = x_bit_internal;
assign cnn_region_y_bit = y_bit_internal;
  
endmodule
