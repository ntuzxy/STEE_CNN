`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2020 13:29:57
// Design Name: 
// Module Name: ev_to_qvga__tsmc_tb
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


module ev_to_qvga__tsmc_tb;


reg clk, rst, en;
reg burst_mode, altern, cnn_done;
reg [7:0] frame_len, frame_us, image_rows;
reg [8:0] image_cols;
reg evt_valid, evt_pol;
reg [8:0] evt_x, cnn_read_x;
reg [7:0] evt_y, cnn_read_y;

wire ready, busy_frame, overflow_read, timer_adv, timer_error;
wire cnn_read_valid, raw_data_pos, raw_data_neg;

localparam period = 10;
localparam half_period = 5;

ev_to_qvga_tsmc uut(
.clk(clk),
.rst(rst),
.en(en),
.burst_mode(burst_mode),
.altern(altern),
.frame_len(frame_len),
.frame_us(frame_us),
.image_cols(image_cols),
.image_rows(image_rows),
.evt_valid(evt_valid),
.evt_x(evt_x),
.evt_y(evt_y),
.evt_pol(evt_pol),
.ready(ready),
.cnn_done(cnn_done),
.cnn_read_x(cnn_read_x),
.cnn_read_y(cnn_read_y),
.cnn_read_valid(cnn_read_valid),
.raw_data_pos(raw_data_pos),
.raw_data_neg(raw_data_neg),
.busy_frame(busy_frame),
.overflow_read(overflow_read),
//.timer_adv(timer_adv),
.timer_error(timer_error)
);

initial begin
    clk = 1'b0;
    forever #half_period clk = ~clk; // generate a clock
end

initial begin
//    #half_period
    rst = 1'b0;
    en = 1'b0;
    burst_mode = 1'b0;
    altern = 1'b0;
    cnn_done = 1'b0;
//    frame_len = 8'd66; //66 ms
    frame_len = 8'd5; // 5 ms for testing
    frame_us = 8'd100;
    image_cols = 9'd320;
    image_rows = 8'd240;
    evt_valid = 0;
    evt_x = 9'd0;
    evt_y = 8'd0;
    evt_pol = 0;
    
    cnn_read_x = 9'd0;
    cnn_read_y = 8'd0;
    #950
    
    rst = 1'b1;
    #50
    
    en = 1;
    #50
    
    evt_valid = 1;
    evt_x = 9'd1;
    evt_y = 8'd0;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #50
    
    evt_valid = 1;
    evt_x = 9'd0;
    evt_y = 8'd1;
    evt_pol = 0;
    #period
    
    evt_valid = 0;
    #50
    
    evt_valid = 1;
    evt_x = 9'd319;
    evt_y = 8'd239;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #50
    
    evt_valid = 1;
    evt_x = 9'd320;
    evt_y = 8'd240;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #50
    
    evt_valid = 1;
    evt_x = 9'd0;
    evt_y = 8'd1;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #50
        
    evt_valid = 1;
    evt_x = 9'd319;
    evt_y = 8'd0;
    evt_pol = 0;
    #period
    
    evt_valid = 0;
    #5000000
        
    evt_valid = 1;
    evt_x = 9'd100;
    evt_y = 8'd110;
    evt_pol = 0;
    #period
    
    evt_valid = 0;
    #50
    
    cnn_read_x = 9'd1;
    cnn_read_y = 8'd0;
    #period
    #period
    if(cnn_read_valid != 1'b1 || (raw_data_pos != 1'b1 || raw_data_neg != 1'b0 || overflow_read != 1'b0))
        $display("test failed for input combination x=1 y=0");

    cnn_read_x = 9'd320;
    cnn_read_y = 8'd240;
    #period
    #period
    if(cnn_read_valid != 1'b0 || (raw_data_pos != 1'b0 || raw_data_neg != 1'b0 || overflow_read != 1'b1))
        $display("test failed for input combination x=320 y=240");
    
    cnn_read_x = 9'd0;
    cnn_read_y = 8'd1;
    #period
    #period
    if(cnn_read_valid != 1'b1 || (raw_data_pos != 1'b1 || raw_data_neg != 1'b1 || overflow_read != 1'b0))
        $display("test failed for input combination x=0 y=1");
    
    cnn_done = 1'b1;
    #period
    
    cnn_done = 1'b0;
    #537000
        
    evt_valid = 1;
    evt_x = 9'd30;
    evt_y = 8'd200;
    evt_pol = 0;
    #period
    
    evt_valid = 0;
    #1000000
            
    evt_valid = 1;
    evt_x = 9'd130;
    evt_y = 8'd200;
    evt_pol = 0;
    #period
    
    evt_valid = 0;
    #50
    
    evt_valid = 1;
    evt_x = 9'd319;
    evt_y = 8'd239;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #4000000
    
    cnn_done = 1'b1;
    #period
    
    cnn_done = 1'b0;
    #1000000
    
    // ENABLE BURST MODE
    rst = 1'b0;
    #50
    rst = 1'b1;
    #50
    burst_mode = 1'b1;
    #50
        
    evt_valid = 1;
    evt_x = 9'd320;
    evt_y = 8'd240;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #50
    
    evt_valid = 1;
    evt_x = 9'd0;
    evt_y = 8'd0;
    evt_pol = 0;
    #period
    
    evt_valid = 0;
    #50
    
    evt_valid = 1;
    evt_x = 9'd0;
    evt_y = 8'd1;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #50
        
    evt_valid = 1;
    evt_x = 9'd319;
    evt_y = 8'd0;
    evt_pol = 0;
    #period
    
    evt_valid = 0;
    #50
    
    evt_valid = 1;
    evt_x = 9'd0;
    evt_y = 8'd0;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #5000000
    
    altern = 1'b1;
    #period
    
    altern = 1'b0;
    #50
    
    cnn_read_x = 9'd319;
    cnn_read_y = 8'd0;
    #period
    #period
    if(cnn_read_valid != 1'b1 || (raw_data_pos != 1'b0 || raw_data_neg != 1'b1 || overflow_read != 1'b0))
        $display("test failed for input combination x=319 y=0");
    
    cnn_read_x = 9'd0;
    cnn_read_y = 8'd0;
    #period
    #period
    if(cnn_read_valid != 1'b1 || (raw_data_pos != 1'b1 || raw_data_neg != 1'b1 || overflow_read != 1'b0))
        $display("test failed for input combination x=0 y=0");
        
    cnn_read_x = 9'd0;
    cnn_read_y = 8'd1;
    #period
    #period
    if(cnn_read_valid != 1'b1 || (raw_data_pos != 1'b1 || raw_data_neg != 1'b0 || overflow_read != 1'b0))
        $display("test failed for input combination x=0 y=1");
    
    cnn_done = 1'b1;
    #period
    
    cnn_done = 1'b0;
    #1000000
        
    evt_valid = 1;
    evt_x = 9'd100;
    evt_y = 8'd1;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #50
            
    evt_valid = 1;
    evt_x = 9'd319;
    evt_y = 8'd239;
    evt_pol = 1;
    #period
    
    evt_valid = 0;
    #5000
    
    altern = 1'b1;
    #period
    
    altern = 1'b0;
    #50
        
    cnn_read_x = 9'd100;
    cnn_read_y = 8'd1;
    #period
    #period
    if(cnn_read_valid != 1'b1 || (raw_data_pos != 1'b1 || raw_data_neg != 1'b0 || overflow_read != 1'b0))
        $display("test failed for input combination x=100 y=1");
        
    cnn_read_x = 9'd319;
    cnn_read_y = 8'd239;
    #period
    #period
    if(cnn_read_valid != 1'b1 || (raw_data_pos != 1'b1 || raw_data_neg != 1'b0 || overflow_read != 1'b0))
        $display("test failed for input combination x=319 y=239");
    #100
        
    cnn_done = 1'b1;
    #period
    
    cnn_done = 1'b0;
    #100
    
    burst_mode = 1'b0;
end

endmodule
