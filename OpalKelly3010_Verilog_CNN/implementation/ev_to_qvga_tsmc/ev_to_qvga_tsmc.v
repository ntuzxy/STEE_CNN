`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2020 12:42:10
// Design Name: 
// Module Name: ev_to_qvga_tsmc
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


module ev_to_qvga_tsmc(
clk,
rst,
en,
burst_mode,
altern,
frame_len,
frame_us,
image_cols,
image_rows,
evt_valid,
evt_x,
evt_y,
evt_pol,
ready,
cnn_done,
cnn_read_x,
cnn_read_y,
cnn_read_valid,
raw_data_pos,
raw_data_neg,
busy_frame,
overflow_read,
timer_error,
// SPI(DEBUG)
top_en_dbg,
top_addr_wr_dbg,
top_pos_wr_dbg,
top_valid_wr_dbg,
top_data_wr_dbg,
top_addr_rd_dbg,
top_pos_rd_dbg,
top_valid_rd_dbg,
top_data_rd_dbg
);

input clk;
input rst;
input en;
input burst_mode;
input altern;

input [7:0] frame_len;
input [7:0] frame_us;
input [8:0] image_cols;
input [7:0] image_rows;

input evt_valid;
input [8:0] evt_x;
input [7:0] evt_y;
input evt_pol;

output ready;

input cnn_done;
input [8:0] cnn_read_x;
input [7:0] cnn_read_y;

output cnn_read_valid;
output raw_data_pos;
output raw_data_neg;

output busy_frame;
output overflow_read;
output timer_error;

input top_en_dbg;
input [16:0] top_addr_wr_dbg;
input [1:0] top_pos_wr_dbg;
input top_valid_wr_dbg;
output [1:0] top_data_wr_dbg;

input [16:0] top_addr_rd_dbg;
input [1:0] top_pos_rd_dbg;
input top_valid_rd_dbg;
output [1:0] top_data_rd_dbg;

// FSM
localparam [1:0]
    resetting = 2'b00,
    receive = 2'b01, 
    cnn = 2'b10;
reg [1:0] current_state, next_state;
    
wire enable_a, enable_b, enable_mem_debug;
reg [1:0] clr_pos;

// timer
wire [23:0] frame_us_in;
wire [31:0] frame_period;
reg [31:0] frame_timer;
reg timer_advance, timer_error;
reg [1:0] top_data_wr_dbg_s, top_data_rd_dbg_s;

// tc_evt signals
wire valid_i_internal;
wire [16:0] addr_i;
wire [1:0] addr_pos;
wire overflow_input;

// tc_read signals
reg tc_read_valid_i;
reg [8:0] tc_read_x;
reg [7:0] tc_read_y;
wire tc_read_valid_o;
reg tc_read_valid_o_post;
wire [16:0] tc_addr;
wire tc_overflow;
reg tc_overflow_s;

// cnn signals
reg resetting_s;
reg cnn_valid;
reg cnn_read_valid_internal;
wire [16:0] addr_cnn;

// reset signals
reg reset_valid;
reg [8:0] reset_x;
wire [8:0] reset_x_dim;
reg [7:0] reset_y;
wire [7:0] reset_y_dim;
reg resetting_done;

// raw0 signals
reg [16:0] addr_i_A;
reg [1:0] addr_pos_A;
reg valid_i_A, clr_A;
wire [1:0] data_A, data_ext_A;

reg [16:0] top_addr_dbg_A;
reg [1:0] top_pos_dbg_A;
reg top_valid_dbg_A, top_clr_dbg_A;
wire [1:0] top_data_dbg_A;

// raw1 signals
reg [16:0] addr_i_B;
reg [1:0] addr_pos_B;
reg valid_i_B, clr_B;
wire [1:0] data_B, data_ext_B;

reg [16:0] top_addr_dbg_B;
reg [1:0] top_pos_dbg_B;
reg top_valid_dbg_B, top_clr_dbg_B;
wire [1:0] top_data_dbg_B;

// internal
reg cnn_read_valid_s;
reg write_A_not_B, ready_s;
reg [1:0] raw_data;
reg switch_back;

translate_coor tc_evt (
.clk(clk), .rst(rst), 
.valid(evt_valid), .x(evt_x), .y(evt_y), .pol(evt_pol),
.x_dim(image_cols), .y_dim(image_rows),
.valid_o(valid_i_internal), .addr(addr_i),
.pos(addr_pos), .overflow(overflow_input)
);

translate_coor tc_read (.clk(clk), .rst(rst), 
.valid(tc_read_valid_i), .x(tc_read_x), .y(tc_read_y), .pol(1'b0),
.x_dim(image_cols), .y_dim(image_rows),
.valid_o(tc_read_valid_o), .addr(tc_addr),
.pos(), .overflow(tc_overflow)
);
                                                            
raw_memory_if raw_0 (
.addr(addr_i_A),
.pos(addr_pos_A),
.valid(valid_i_A),
.en(enable_a),
.data(data_A),
.clr(clr_A),
.top_addr_dbg(top_addr_dbg_A),
.top_pos_dbg(top_pos_dbg_A),
.top_valid_dbg(top_valid_dbg_A),
.top_en_dbg(enable_mem_debug),
.top_data_dbg(top_data_dbg_A),
.top_clr_dbg(top_clr_dbg_A),
.clk(clk)
// .clk(~clk)
);
                            
raw_memory_if raw_1 (
.addr(addr_i_B),
.pos(addr_pos_B),
.valid(valid_i_B),
.en(enable_b),
.data(data_B),
.clr(clr_B),
.top_addr_dbg(top_addr_dbg_B),
.top_pos_dbg(top_pos_dbg_B),
.top_valid_dbg(top_valid_dbg_B),
.top_en_dbg(enable_mem_debug),
.top_data_dbg(top_data_dbg_B),
.top_clr_dbg(top_clr_dbg_B),
.clk(clk)
// .clk(~clk)
);

assign enable_a = (~en);
assign enable_b = ~(en & ~burst_mode);
assign enable_mem_debug = ~(top_en_dbg);
assign ready = (ready_s);
assign frame_us_in = (16'd1000 * frame_us);
assign frame_period = (frame_len * frame_us_in);
assign raw_data_pos = (raw_data[1]);
assign raw_data_neg = (raw_data[0]);
assign cnn_read_valid = (cnn_read_valid_s);
assign overflow_read = (tc_overflow_s);
assign reset_x_dim = (image_cols - 1'b1);
assign reset_y_dim = (image_rows - 1'b1);
assign busy_frame = (write_A_not_B == 1'b1) ? 1 : 0;
assign top_data_wr_dbg = (top_data_wr_dbg_s);
assign top_data_rd_dbg = (top_data_rd_dbg_s);

always @(write_A_not_B, addr_i, addr_pos, valid_i_internal, tc_addr, data_A, data_B, tc_read_valid_o_post, clr_pos, top_en_dbg)
begin
    if (top_en_dbg == 1'b0) begin
        if (write_A_not_B == 1'b0) begin
            addr_i_A = addr_i;
            addr_pos_A = addr_pos;
            valid_i_A = valid_i_internal;
            clr_A = 1'b0;
            
            addr_i_B = tc_addr;
            addr_pos_B = clr_pos;
            valid_i_B = tc_read_valid_o_post;
            clr_B = 1'b1;
            raw_data = data_B;
        end
        else begin
            addr_i_A = tc_addr;
            addr_pos_A = clr_pos;
            valid_i_A = tc_read_valid_o_post;
            clr_A = 1'b1;
            raw_data = data_A;
            
            addr_i_B = addr_i;
            addr_pos_B = addr_pos;
            valid_i_B = valid_i_internal;
            clr_B = 1'b0;
        end
    end
    else begin
        addr_i_A = 17'd0;
        addr_pos_A = 2'b11;
        valid_i_A = 1'b1;
        clr_A = 1'b0;

        addr_i_B = 17'd0;
        addr_pos_B = 2'b11;
        valid_i_B = 1'b1;
        clr_B = 1'b0;
        
        raw_data = 2'b00;
    end
end

always @(write_A_not_B, top_addr_wr_dbg, top_pos_wr_dbg, top_valid_wr_dbg, top_data_dbg_A, top_addr_rd_dbg, top_pos_rd_dbg, top_valid_rd_dbg, top_data_dbg_B, top_en_dbg)
begin
    if (top_en_dbg == 1'b1) begin
        if (write_A_not_B == 1'b0) begin
            top_addr_dbg_A = top_addr_wr_dbg;
            top_pos_dbg_A = top_pos_wr_dbg;
            top_valid_dbg_A = top_valid_wr_dbg;
            top_clr_dbg_A = 1'b0;
            top_data_wr_dbg_s = top_data_dbg_A;
            
            top_addr_dbg_B = top_addr_rd_dbg;
            top_pos_dbg_B = top_pos_rd_dbg;
            top_valid_dbg_B = top_valid_rd_dbg;
            top_clr_dbg_B = 1'b0;
            top_data_rd_dbg_s = top_data_dbg_B;
        end
        else begin
            top_addr_dbg_A = top_addr_rd_dbg;
            top_pos_dbg_A = top_pos_rd_dbg;
            top_valid_dbg_A = top_valid_rd_dbg;
            top_clr_dbg_A = 1'b0;
            top_data_rd_dbg_s = top_data_dbg_A;
            
            top_addr_dbg_B = top_addr_wr_dbg;
            top_pos_dbg_B = top_pos_wr_dbg;
            top_valid_dbg_B = top_valid_wr_dbg;
            top_clr_dbg_B = 1'b0;
            top_data_wr_dbg_s = top_data_dbg_B;
        end
    end
    else begin
        top_addr_dbg_A = 17'b0;
        top_pos_dbg_A = 2'b11;
        top_valid_dbg_A = 1'b1;
        top_clr_dbg_A = 1'b0;
        top_data_rd_dbg_s = 2'b0;
        
        top_addr_dbg_B = 17'b0;
        top_pos_dbg_B = 2'b11;
        top_valid_dbg_B = 1'b1;
        top_clr_dbg_B = 1'b0;
        top_data_wr_dbg_s = 2'b0;
    end
end

always @(posedge clk, negedge rst)
begin
    if(rst == 1'b0) begin
        current_state <= receive;
        write_A_not_B <= 1'b0;
        frame_timer <= 32'b0;
        timer_advance <= 1'b0;
        timer_error <= 1'b0;
        
        reset_x <= 9'b0;
        reset_y <= 8'b0;
        reset_valid <= 1'b0;
        resetting_done <= 1'b0;
        tc_read_valid_o_post <= 1'b1;
        tc_overflow_s <= 1'b0;
        
        switch_back <= 1'b0;
    end
    else begin
        current_state <= next_state;
        resetting_done <= 1'b0;
        tc_read_valid_o_post <= 1'b1;
        switch_back <= 1'b0;
        tc_overflow_s <= tc_overflow;
        
        cnn_read_valid_s <= (~cnn_read_valid_internal);
        if (en == 1'b1 || top_en_dbg == 1'b1) begin
            if (burst_mode == 1'b0) begin
                if (frame_timer == frame_period) begin
                    frame_timer <= 32'b0;
                    if (timer_advance == 1'b0) begin
                        timer_advance <= 1'b1;
                    end
                    else begin
                        timer_error <= 1'b1;
                    end
                end
                else begin
                    frame_timer <= frame_timer + 32'b1;
                end
            end
            if (timer_advance == 1'b1 || altern == 1'b1 || switch_back == 1'b1) begin
                write_A_not_B <= ~write_A_not_B;
                timer_advance <= 1'b0;
            end
            if (resetting_s == 1'b1) begin
                tc_read_valid_o_post <= tc_read_valid_o;
                if (reset_x == reset_x_dim) begin
                    reset_x <= 9'b0;
                    if (reset_y == reset_y_dim) begin
                        reset_y <= 8'b0;
                        resetting_done <= 1'b1;
                        reset_valid <= 1'b0;
                        if (burst_mode == 1'b1) begin
                            switch_back <= 1'b1;
                        end
                    end
                    else begin
                        reset_y <= reset_y + 8'b1;
                    end
                end
                else begin
                    reset_x <= reset_x + 9'b1;
                end
            end
            else if (cnn_done == 1'b1) begin
                reset_valid <= 1'b1;
                reset_x <= 9'b0;
                reset_y <= 8'b0;
            end
        end
    end
end

always @(current_state, altern, timer_advance, cnn_done, tc_read_valid_o, cnn_read_x, cnn_read_y, cnn_valid, reset_x, reset_y, resetting_done, reset_valid)
begin
    next_state = current_state;
    
    ready_s = 1'b0;
    resetting_s = 1'b0;
    clr_pos = 2'b11;
    
    // tc signals
    tc_read_valid_i = 1'b0;
    tc_read_x = 8'd0;
    tc_read_y = 7'd0;
    
    // cnn signals
    cnn_valid = 1'b0;
    cnn_read_valid_internal = 1'b1;
    
    case(current_state)
        resetting:
        begin
            ready_s = 1'b0;
            resetting_s = 1'b1;
            clr_pos = 2'b00;
            
            cnn_valid = 1'b0;
            cnn_read_valid_internal = 1'b1;
            
            tc_read_valid_i = reset_valid;
            tc_read_x = reset_x;
            tc_read_y = reset_y;
            
            if (resetting_done == 1'b1) begin
                next_state = receive;
            end
        end
        receive:
        begin
            ready_s = 1'b1;
            resetting_s = 1'b0;
            clr_pos = 2'b11;
            
            cnn_valid = 1'b0;
            cnn_read_valid_internal = 1'b1;
            
            tc_read_valid_i = 1'b0;
            tc_read_x = 8'd0;
            tc_read_y = 7'd0;
            
            if (timer_advance == 1'b1 || altern == 1'b1) begin
                next_state = cnn;
            end
        end
        cnn:
        begin
            ready_s = 1'b0;
            resetting_s = 1'b0;
            clr_pos = 2'b11;
            
            cnn_valid = 1'b1;
            cnn_read_valid_internal = tc_read_valid_o;
            
            tc_read_valid_i = cnn_valid;
            tc_read_x = cnn_read_x;
            tc_read_y = cnn_read_y;
            
            if (cnn_done == 1'b1) begin
                next_state = resetting;
            end
        end      
    endcase
end

endmodule
