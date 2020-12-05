`timescale 1ns / 1ps
`include "define_spi_addr.h"
module tb_cnn_top_outspi_gate_bigtest();

`define n 9'h02a
`define k 9'h005
`define p 9'h002 
`define tn 0
//`define c_size 32
reg reset_new=1;
reg clk,global_rst,ce, init;

reg [`n*`n-1:0] inp_reg_ch1;
reg [`n*`n-1:0] inp_reg_ch2;
reg [3:0] kernel_ptr_lyr1 [`k*`k*2*6-1:0];
reg [3:0] kernel_ptr_dw_lyr2 [`k*`k*6-1:0];
//reg [3:0] kernel_ptr_pw_lyr2 [6*16-1:0];
reg [3:0] kernel_ptr_pw_lyr2 [6*5-1:0];
reg [3:0] kernel_ptr_fc_lyr [49*5*5-1:0];

reg signed [7:0] bias_lyr1 [5:0];
reg [7:0] bias_lyr2 [4:0];
reg [7:0] bias_lyr3 [4:0];

reg signed [7:0] dfp_bias_lyr1;
reg signed [7:0] dfp_lyr1;
reg signed [7:0] dfp_bias_lyr2;
reg signed [7:0] dfp_lyr2;
reg signed [7:0] dfp_bias_lyr3;
reg signed [7:0] dfp_lyr3;

reg signed [31:0] class_output [4:0];

//reg [7:0] weights_mem [15:0];
reg [7:0] weights_mem1 [15:0];
reg [7:0] weights_mem2 [15:0];
reg [7:0] weights_mem3 [15:0];
reg [7:0] weights_mem4 [15:0];
//reg [(`k*`k)*8-1:0] weight1;
wire [7:0] data_out;
wire inp_valid;
wire conv1_done;
parameter clkp = 10.0;//6.5;//8.0;//6;//10;
parameter clkp_spi = 10.0;
integer ip_img_ch1_file,ip_img_ch2_file,ip_wght_file1, ip_wght_file2, ip_wght_file3,ip_wght_file4,ip_ker_ptr_file,op_file1,op_file2,op_file3,op_file4,op_file5,op_file6,ch;

integer bias_file1, bias_file2, bias_file3, dfp_bias_file1, dfp_conv_file1, dfp_bias_file2, dfp_conv_file2, dfp_conv_file3, dfp_bias_file3;

 integer op1_file1;
 integer op1_file2;
 integer op1_file3;
 integer op1_file4;
 integer op1_file5;
 integer ref1_file1;
 integer ref1_file2;
 integer ref1_file3;
 integer ref1_file4;
 integer ref1_file5;
 integer ref_file1;
 integer ref_file2;
 integer ref_file3;
 integer ref_file4;
 integer ref_file5;
 integer ref_file6;

integer ref_file_out, dut_file_out;
integer ip_ker_ptr2_pw_file, ip_ker_ptr2_dw_file , ip_ker_ptr_fc_file;

reg evt_valid=0, evt_pol=0; 
reg [8:0] evt_x=0, cnn_read_x;
reg [7:0] evt_y=0, cnn_read_y;

reg  activations [0:((`n)*(`n))-1];
reg [7:0] weight [0:(`k*`k)-1];
integer r1,r2,i,j,l,m,r3,r4;
reg [23:0] endc = "EoT"; 
reg [7:0] out_lyr1 [400:0];
reg [7:0] out_lyr2 [400:0];
reg [7:0] out_lyr3 [400:0];
reg [7:0] out_lyr4 [400:0];
reg [7:0] out_lyr5 [400:0];
reg [7:0] out_lyr6 [400:0];    
reg signed [31:0] out_class [4:0];

reg [15:0] lyr2_valid;

reg [15:0] lyr2_output [4:0] [48:0];

reg [3:0] data_ina_wght_ptr_1_2 ;
integer weight_cnt = 0, lyr1_ptr_addr_cnt = 0, lyr1_ptr_cnt = 0, lyr2_dw_ptr_cnt = 0, lyr2_pw_ptr_cnt = 0,lyr3_ptr_cnt = 0;
reg init_wght_done = 1, init_ptr_lyr1_done = 0 , init_ptr_lyr2_dw_done = 0,  init_ptr_lyr2_pw_done = 0 , init_ptr_lyr3_done = 0 , start_cnn= 0, raw_mem_init = 0, raw_mem_init_second = 0, init_AER_done = 0;

integer j_idx = 0, i_idx = 0, index = 0;


reg read_cnn_data_out = 0;

reg [9:0] top_AER_data=10'b0;
reg top_AER_nreq=1;
wire top_AER_nack;
wire top_BiasAddrSel;
wire top_BiasBitIN;
wire top_BiasClock;
wire top_BiasLatch;
wire top_BiasDiagSel;

// Instantiate only the CONV TOP WITH SPI
//

localparam ARRAY_WIDTH =16;
localparam ADDR_WIDTH =7;
localparam ARRAY_DEPTH =2**ADDR_WIDTH;
localparam TOTAL_WIDTH= ARRAY_WIDTH+ ADDR_WIDTH;
localparam MAX_SIZE = ARRAY_WIDTH * ARRAY_DEPTH;
reg [7:0] dfp_out_lyr1 = 8'hFC;
reg [7:0] dfp_out_lyr2 = 8'hFC;
reg [7:0] dfp_out_lyr3 = 8'hFC;
wire spi_din;
reg clk_top;
reg clk_phase1;
reg clk_phase2;
reg clk_update;
reg reset_n;
reg reset_nn;
reg reset1;
reg capture;
reg [9:0] counter_1;
reg [9:0] counter_2;
reg [9:0] counter_3;
reg [9:0] counter_4;
reg [ARRAY_WIDTH -1:0 ] data_in ;
reg [ADDR_WIDTH -1 :0] addr_in ;
reg ready;
wire spi_out;
wire [7:0] parallel_outa;

reg en_evt2frame = 0;

reg [TOTAL_WIDTH-1 : 0] data_serial_in;
assign spi_din = data_serial_in[0];
integer i;

reg top_rgn_bit_valid=0;
reg top_rgn_done=0;

wire cnn_rd_region;
wire cnn_region_done;
wire cnn_region_valid;
wire cnn_region_x_bit;
wire cnn_region_y_bit;
wire cnn_region_clk;

wire region_rd_en;

reg [4:0] num_obj;
reg [8:0] region_x;
reg [8:0] region_y;
reg region_valid;

reg cnn_rd_done;
wire cnn_ready;
wire rgn_rd_en;
wire rgn_done, ored_rgn_done;
 reg [0:0] read_data_neg [0:76800];
 reg [0:0] read_data_pos [0:76800];
 integer ii, jj, index_AER;

wire signed [7:0] parallel_out ;
 
assign ored_rgn_done =(cnn_region_done || top_rgn_done);
assign ored_rgn_bit_valid =(cnn_region_valid || top_rgn_bit_valid);
 initial begin
                 $readmemb("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/RP_FILES/image_1006/image_1006_0", read_data_pos);
                 $readmemb("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/RP_FILES/image_1006/image_1006_1", read_data_neg);
    #210; 
         top_AER_data[9] = 1'b0;
         top_AER_data[7:0] = 169 ;
         #100;
         
         top_AER_nreq = 1'b0;
         #50
         
         top_AER_nreq = 1'b1;
         #100;
                 
                 top_AER_data[9] = 1'b1;
                 top_AER_data[8:1] = 100;
                 top_AER_data[0] = 1'b0;
                 top_AER_nreq = 1'b0;
                 #100;
                 
                 top_AER_nreq = 1'b1;
                 #100;
      en_evt2frame = 0;
     top_AER_data = 9'b0;
     top_AER_nreq = 1'b1;
//     #10000000
     wait(init_AER_done);
     #10
     en_evt2frame <=1'b1;
     @(posedge dut_conv_top.busy_frame);
     @(negedge dut_conv_top.busy_frame);
     // wait for atleast two frames so that mem is initialized and not X
     @(posedge dut_conv_top.busy_frame);
     
     index_AER = 0;
     for (jj=0; jj<240; jj=jj+1)
     begin
         top_AER_data[9] = 1'b0;
         top_AER_data[7:0] = 179 - jj;
         #100;
         
         top_AER_nreq = 1'b0;
         #50
         
         top_AER_nreq = 1'b1;
         #100;
         for (ii=0; ii<320; ii=ii+1)
         begin
             if (read_data_neg[index_AER] == 1'b1) begin
                 
                 top_AER_data[9] = 1'b1;
                 top_AER_data[8:1] = ii;
                 top_AER_data[0] = 1'b0;
                 top_AER_nreq = 1'b0;
                 #100;
                 
                 top_AER_nreq = 1'b1;
                 #100;
             end
             else if (read_data_pos[index_AER] == 1'b1) begin
                 
                 top_AER_data[9] = 1'b1;
                 top_AER_data[8:1] = ii;
                 top_AER_data[0] = 1'b1;
                 top_AER_nreq = 1'b0;
                 #100;
                 
                 top_AER_nreq = 1'b1;
                 #100;
             end
             index_AER = index_AER + 1;
         end
     end
     @(negedge dut_conv_top.busy_frame); //assert raw mem init donw after fourth frame starts to read from the thrid frame
    raw_mem_init = 1;
     @(posedge dut_conv_top.busy_frame); // fifth frame empty
     @(negedge dut_conv_top.busy_frame); // sixth frame empty
     @(posedge dut_conv_top.busy_frame); // seventh frame empty
     @(negedge dut_conv_top.busy_frame); // eight frame write AER data
     
     index_AER = 0;
     for (jj=0; jj<240; jj=jj+1)
     begin
         top_AER_data[9] = 1'b0;
         top_AER_data[7:0] = 179 - jj;
         #100;
         
         top_AER_nreq = 1'b0;
         #50
         
         top_AER_nreq = 1'b1;
         #100;
         for (ii=0; ii<320; ii=ii+1)
         begin
             if (read_data_neg[index_AER] == 1'b1) begin
                 
                 top_AER_data[9] = 1'b1;
                 top_AER_data[8:1] = ii;
                 top_AER_data[0] = 1'b0;
                 top_AER_nreq = 1'b0;
                 #100;
                 
                 top_AER_nreq = 1'b1;
                 #100;
             end
             else if (read_data_pos[index_AER] == 1'b1) begin
                 
                 top_AER_data[9] = 1'b1;
                 top_AER_data[8:1] = ii;
                 top_AER_data[0] = 1'b1;
                 top_AER_nreq = 1'b0;
                 #100;
                 
                 top_AER_nreq = 1'b1;
                 #100;
             end
             index_AER = index_AER + 1;
         end
     end
     @(posedge dut_conv_top.busy_frame); // ninth  frame get regions by asserting raw_mem_init2 done to read regions from eigth frame
    raw_mem_init_second = 1;
 end
conv_top dut_conv_top(
.spi_din(spi_din),
.spi_out(spi_out),
.clk_phase1(clk_phase1),
.clk_phase2(clk_phase2),
.clk_update(clk_update),
.capture(capture),
.reset_n(reset_n),
.clk_top(clk_top),
.init(init),
.en_evt2frame(en_evt2frame),
.parallel_out(parallel_out),
.top_AER_data(top_AER_data),
.top_AER_nreq(top_AER_nreq),
.top_AER_nack(top_AER_nack),
.top_BiasAddrSel(top_BiasAddrSel),
.top_BiasBitIN(top_BiasBitIN),
.top_BiasClock(top_BiasClock),
.top_BiasLatch(top_BiasLatch),
.top_BiasDiagSel(top_BiasDiagSel),
.rgn_rd_en(rgn_rd_en),
.rgn_done(ored_rgn_done),
.rgn_bit_valid(ored_rgn_bit_valid),
.rgn_x_bit(cnn_region_x_bit),
.rgn_y_bit(cnn_region_y_bit),
.rgn_clk(cnn_region_clk),
.done(cnn_done),
.conv_done1(conv_done1)
);



RP2serial RP2serial_1(
    .clk(clk),
	.reset(!reset_n),
	.reset_new(reset_new),
    // interface to RP
    .num_obj(num_obj),
    .region_x(region_x),
    .region_y(region_y),
    .region_valid(region_valid),
    .region_rd_en(region_rd_en),

    // interface to CNN
    .cnn_rd_region(rgn_rd_en),
    .cnn_region_done(cnn_region_done),
    .cnn_region_valid(cnn_region_valid),
    .cnn_region_x_bit(cnn_region_x_bit),
    .cnn_region_y_bit(cnn_region_y_bit),
    .cnn_region_clk(cnn_region_clk)
);

// load region file 
// integer data_file; // file handler
integer scan_file; // file handler
integer captured_data;
integer file_region_num;
integer f_i;
reg reg_file_done= 0;
integer reg_file1, reg_file2;
/*
task get_empty_region_from_file_and_output;
input integer emp_reg_file;
begin
 num_obj = 0;
 region_x = 0;
 region_y = 0;
 region_valid = 0;
 #1000000
end
endtask
*/
reg region_out_done = 0;
reg region_out_done_second = 0;
task get_region_from_file_and_output;
input integer data_file;
begin
    data_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/RP_FILES/image_1006/rp_file", "r");
    if (data_file == 0) begin
        $display("data_file handle was NULL");
        $finish;
    end
    $fscanf(data_file, "%d\n", captured_data);
    file_region_num = captured_data;
    $display("data file loaded, %d regions", file_region_num);

    for (f_i = 0; f_i < file_region_num*2; f_i = f_i + 1) begin
        @ (posedge clk); #1;
        region_valid       = 1;
        num_obj            = file_region_num;
        if (!$feof(data_file)) begin
            $fscanf(data_file, "%d\n", captured_data);
            region_x = captured_data;
        end else begin
            $display("data file not complete");
            $finish;
        end
        if (!$feof(data_file)) begin
            $fscanf(data_file, "%d\n", captured_data);
            region_y = captured_data;
        end else begin
            $display("data file not complete");
            $finish;
        end

        // output first region and wait for region read signal then continue
        if (f_i == 0) begin
            @ (posedge region_rd_en);
        end
    end

    @ (posedge clk); #1;
    num_obj            = 0;
    region_x           = 0;
    region_y           = 0;
    region_valid       = 0;
    if (raw_mem_init && !region_out_done) begin
    $display("region output done for first region!");
     region_out_done = 1;
    end
    if(raw_mem_init_second && region_out_done && !region_out_done_second) begin
    $display("region output done for second region!");
     region_out_done_second = 1;
    end
  
end
endtask

//assign dut_conv_top.ev_to_qvga_tsmc1.evt_valid = evt_valid;
//assign dut_conv_top.ev_to_qvga_tsmc1.evt_x = evt_x;
//assign dut_conv_top.ev_to_qvga_tsmc1.evt_y = evt_y;
//assign dut_conv_top.ev_to_qvga_tsmc1.evt_pol = evt_pol;
initial begin
		// Initialize Inputs
		//last_layer_done = 0;
		clk_top <= 1'b0;
		clk <= 1'b0;
                clk_phase1 <= 1'b0;
                clk_phase2 <= 1'b1;
                clk_update <= 1'b0;
                capture <= 1'b0;
                reset_n <= 1'b0;
                reset1 <=1'b0;
		init = 0;
		//weight1 = 0; 
		global_rst = 0; 
		//activation = 0;

		// Wait 100 ns for global reset to finish
		#100 reset1 <= 1'b1;

                
 //  ALl 1's testcase
	   /*ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_test_image_ch1_all1s.txt","r");
	   ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_test_image_ch2_all1s.txt","r");
	   ip_wght_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weights_conv1_all1s.txt","r");
	   ip_ker_ptr_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer.txt","r");
	   ip_ker_ptr2_dw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer2_dw.txt","r");
	   ip_ker_ptr2_pw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer2_pw.txt","r");*/
 // increasing values test case
  
//	   ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_test_image_ch1_all1s.txt","r");
//	   ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_test_image_ch2_all1s.txt","r");
	   //ip_wght_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weights_conv1_index_vals.txt","r");
	   //ip_ker_ptr_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer_inccnt.txt","r");
	   //ip_ker_ptr2_dw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer2_dw_idxvals.txt","r");
	   //ip_ker_ptr2_pw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer2_dw_idxvals.txt","r");
// walking 1's alternate 1's and 0's
  //
    //ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_test_image_ch1_alt1s0s.txt","r");
    //	   ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_test_image_ch2_alt0s1s.txt","r");
  // only one kernel conv all 1s rest all 0s
  /*
     ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_test_image_ch1_one1sall0s.txt","r");
     	   ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_test_image_ch2_one1sall0s.txt","r");
	   ip_wght_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weights_conv1_walking1s.txt","r");
	   ip_ker_ptr_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer_inccnt.txt","r");
	   ip_ker_ptr2_dw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer2_dw_idxvals.txt","r");
	   ip_ker_ptr2_pw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/test_small_lenet_lav_data/lav_weight_pointer2_dw_idxvals.txt","r");
     */

      // Soham's test vector
           //ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/17jan2020/image/image_file_channel_1.txt","r");
           //ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/17jan2020/image/image_file_channel_2.txt","r");
           //ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/test_image/image/image_file_channel_1.txt","r");
           //ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/test_image/image/image_file_channel_2.txt","r");
           ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/test_image/image/image_file_channel_0.txt","r");
           ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/test_image/image/image_file_channel_1.txt","r");
           //ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/full_video_verification/30mar2020/all_one/image_file_channel_0.txt","r");
           //ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/full_video_verification/30mar2020/all_one/image_file_channel_1.txt","r");
           //ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/full_video_verification/30mar2020/all_zero/image_file_channel_0.txt","r");
           //ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/full_video_verification/30mar2020/all_zero/image_file_channel_1.txt","r");
           //ip_img_ch1_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/30mar2020/full_verification/rp_img_0_0","r");
           //ip_img_ch2_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/30mar2020/full_verification/rp_img_0_1","r");
	   //ip_wght_file1 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/weight_map.txt","r");
	   ip_wght_file1 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/22mar2020/conv2d_1_weight_table.txt","r");
	   ip_wght_file2 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/26mar2020/separable_conv2d_1_weight_table.txt","r");
	   ip_wght_file3 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/26mar2020/separable_conv2d_1_weight_table.txt","r");
	   //ip_wght_file3 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/weight_map.txt","r");
	   //ip_wght_file4 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/weight_map.txt","r");
	   ip_wght_file4 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/28mar2020/dense_1_weight_table.txt","r");
	   //ip_ker_ptr_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/clustered_weights_conv2d_1_kernel.txt","r");
	   ip_ker_ptr_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/22mar2020/weights_conv2d_1_weight_pointer.txt","r");
	   //ip_ker_ptr2_dw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/clustered_weights_separable_conv2d_1_depthwise_kernel.txt","r");
	   //ip_ker_ptr2_pw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/clustered_weights_separable_conv2d_1_pointwise_kernel.txt","r");
	   ip_ker_ptr2_dw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/26mar2020/weights_separable_conv2d_1depthwise_weight_pointer.txt","r");
	   ip_ker_ptr2_pw_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/26mar2020/weights_separable_conv2d_1pointwise_weight_pointer.txt","r");
	   //ip_ker_ptr_fc_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/clustered_weights_dense_1_kernel_transpose.txt","r");
	   ip_ker_ptr_fc_file = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/28mar2020/weights_dense_1.txt","r");
	   //bias_file1 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/bias_conv2d_1.txt","r");
	   bias_file1 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/22mar2020/conv2d_1_bias_values.txt","r");
	   //bias_file2 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/bias_separable_conv2d_1.txt","r");
	   bias_file2 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/26mar2020/separable_conv2d_1_bias_values.txt","r");
	   //bias_file3 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/SOHAM_weights/20jan2020/temp/bias_dense_1.txt","r");
	   bias_file3 = $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/28mar2020/dense_1_bias_values.txt","r");

           dfp_bias_file1 =  $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/22mar2020/dfp_bias.txt","r");
           dfp_conv_file1 =  $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/22mar2020/dfp_conv.txt","r");
           dfp_bias_file2 =  $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/26mar2020/dfp_bias_layer_2.txt","r");
           dfp_conv_file2 =  $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/26mar2020/dfp_seperable_conv.txt","r");
           dfp_bias_file3 =  $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/28mar2020/dfp_bias_layer_3.txt","r");
           dfp_conv_file3 =  $fopen("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/28mar2020/dfp_dense.txt","r");

	   op_file1 = $fopen("tb_op1.txt","a");	
	   op_file2 = $fopen("tb_op2.txt","a");	
	   op_file3 = $fopen("tb_op3.txt","a");	
	   op_file4 = $fopen("tb_op4.txt","a");	
	   op_file5 = $fopen("tb_op5.txt","a");	
	   op_file6 = $fopen("tb_op6.txt","a");	
	   op1_file1  = $fopen("tb_op_lyr2_1.txt","a"); 
	   op1_file2  = $fopen("tb_op_lyr2_2.txt","a"); 
	   op1_file3  = $fopen("tb_op_lyr2_3.txt","a"); 
	   op1_file4  = $fopen("tb_op_lyr2_4.txt","a"); 
	   op1_file5  = $fopen("tb_op_lyr2_5.txt","a"); 
	   
           dut_file_out = $fopen("dut_output.txt","w+");
           reg_file1 = $fopen("reg_file1.txt","a");
           reg_file2 = $fopen("reg_file2.txt","a");

		for(i=0;i<16;i=i+1) begin
		r1 = $fscanf(ip_wght_file1,"%h\n",weights_mem1[i]);
                //$display("Weights tbale 1 of i = %d is %h\n", i,weights_mem1[i]);
		end
		for(i=0;i<16;i=i+1) begin
		r1 = $fscanf(ip_wght_file2,"%h\n",weights_mem2[i]);
		end
		for(i=0;i<16;i=i+1) begin
		r1 = $fscanf(ip_wght_file3,"%h\n",weights_mem3[i]);
		end
		for(i=0;i<16;i=i+1) begin
		r1 = $fscanf(ip_wght_file4,"%h\n",weights_mem4[i]);
		end
		for(j=0;j<`n*`n;j = j+1) begin
		r2 = $fscanf(ip_img_ch1_file,"%b",inp_reg_ch1[j]);
                //if(inp_reg_ch1[j])  $display(inp_reg_ch1[j]);
		r3 = $fscanf(ip_img_ch2_file,"%b",inp_reg_ch2[j]);
		end
		$display("data loading done");
		for(l =0;l<`k*`k*6*2;l=l+1) begin
		r4 = $fscanf(ip_ker_ptr_file,"%h",kernel_ptr_lyr1[l]);
		end
		for(l =0;l<`k*`k*6;l=l+1) begin
		r4 = $fscanf(ip_ker_ptr2_dw_file,"%h",kernel_ptr_dw_lyr2[l]);
		end
		for(l =0;l<16*6;l=l+1) begin
		r4 = $fscanf(ip_ker_ptr2_pw_file,"%h",kernel_ptr_pw_lyr2[l]);
		end
		for(l =0;l<49*5*5;l=l+1) begin
		r4 = $fscanf(ip_ker_ptr_fc_file,"%h",kernel_ptr_fc_lyr[l]);
		end
/*
*/
		//$display("weight pointers loading done");
/*
                for( m=0; m< 6; m++) begin
                 bias_lyr1[m] = 10*m+1;
                end
                for( m=0; m< 16; m++) begin
                 bias_lyr2[m] = -10*m+1;
                end*/
                data_ina_wght_ptr_1_2 = kernel_ptr_lyr1[0];
		for(i=0;i<6;i=i+1) begin
		r1 = $fscanf(bias_file1,"%h\n",bias_lyr1[i]);
                //$display("bias is %h for i %d\n",bias_lyr1[i],i);
		end
               
		for(i=0;i<5;i=i+1) begin
		r1 = $fscanf(bias_file2,"%h\n",bias_lyr2[i]);
		end
		for(i=0;i<5;i=i+1) begin
		r1 = $fscanf(bias_file3,"%h\n",bias_lyr3[i]);
		end
                r1 = $fscanf(dfp_bias_file1,"%h\n", dfp_bias_lyr1); 
                r1 = $fscanf(dfp_conv_file1,"%h\n", dfp_lyr1); 
                r1 = $fscanf(dfp_bias_file2,"%h\n", dfp_bias_lyr2); 
                r1 = $fscanf(dfp_conv_file2,"%h\n", dfp_lyr2); 
                r1 = $fscanf(dfp_bias_file3,"%h\n", dfp_bias_lyr3); 
                r1 = $fscanf(dfp_conv_file3,"%h\n", dfp_lyr3); 
                // $readmemb("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/RP_FILES/image_1006/image_1006_0", read_data_pos);
                // $readmemb("/home/Div6/research/lavanyay19/STEE_PROJ/vcs/TEST_DATA/RP_FILES/image_1006/image_1006_1", read_data_neg);
                $display ("memory data is %d \n", read_data_pos[0]);
		//$display("bias vector done");
		//SAIF File start toggle
                //$set_gate_level_monitoring("on");
$vcdpluson;	
		//$set_toggle_region(dut);
                //$read_rtl_saif("/home/Div6/research/lavanyay19/STEE_PROJ/synthesis/dc_rtl.saif",dut); 
		//$toggle_start();
		clk = 0;
                //dut_conv_top.img_pixel_ch1_cnn = inp_reg_ch1;
                //dut_conv_top.img_pixel_ch2_cnn = inp_reg_ch2;
		init = 0; 
		//weight1 = 0;
		//activation = 0;
		//
		//
		global_rst = 1;
		#(20*clkp);
		
		global_rst = 0;
                reset_n <= 1'b1;
	
		init = 1;
		/*for(m = 0;m<`n*`n;m=m+1)begin
		activation = activations[m];
		#clkp;
		end*/
end 
// BOOT SEQUENCE IMPORTANT
// FIRST fill the weight pointer table and then the weight memory else the
// address initialization of the weight memory table is XXX
always@(posedge clk_phase1 ) begin
              if(dut_conv_top.small_lenet_tile_based_cnn1.init ) begin
                if(!init_wght_done) begin 
                  addr_in = `data_ina_wght_tab1;
                  data_in = weights_mem1[weight_cnt];
                  @(negedge clk_update);
                  addr_in = `addra_wght_tab1;
                  data_in = weight_cnt;
                  @(negedge clk_update);
                  addr_in = `wea_wght_tab1;
                  data_in = 8'hFF;
                  @(negedge clk_update);
                  addr_in = `wea_wght_tab1;
                  data_in = 8'h0;
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_tab2;
                  data_in = weights_mem2[weight_cnt];
                  @(negedge clk_update);
                  addr_in = `addra_wght_tab2;
                  data_in = weight_cnt;
                  @(negedge clk_update);
                  addr_in = `wea_wght_tab2;
                  data_in = 8'hFF;
                  @(negedge clk_update);
                  addr_in = `wea_wght_tab2;
                  data_in = 16'h0;
                  @(negedge clk_update);
                   weight_cnt = weight_cnt + 1;
                end // end if(!iinit_wght_done)
                if(!init_ptr_lyr1_done) begin
                  addr_in = `data_ina_wght_ptr_1_2;
                  data_in = kernel_ptr_lyr1[lyr1_ptr_cnt];
                  @(negedge clk_update);
                  addr_in = `addra_wght_ptr_1_2;
                  data_in = lyr1_ptr_addr_cnt;
                  @(negedge clk_update);
                  addr_in = `wea_wght_ptr_1_2;
                  data_in = 8'hFF;
                  @(negedge clk_update);
                  addr_in = `wea_wght_ptr_1_2;
                  data_in = 0;
                  @(negedge clk_update);
                  lyr1_ptr_cnt = lyr1_ptr_cnt + 1;
                  lyr1_ptr_addr_cnt = lyr1_ptr_addr_cnt + 1;
                end // end init ptr lyr1 done
                else if(init_ptr_lyr1_done && (!init_ptr_lyr2_dw_done)) begin
                  addr_in = `data_ina_wght_ptr_1_2;
                  data_in = kernel_ptr_dw_lyr2[lyr2_dw_ptr_cnt];
                  @(negedge clk_update);
                  addr_in = `addra_wght_ptr_1_2;
                  data_in = lyr1_ptr_addr_cnt;
                  @(negedge clk_update);
                  addr_in = `wea_wght_ptr_1_2;
                  data_in = 8'hFF;
                  @(negedge clk_update);
                  addr_in = `wea_wght_ptr_1_2;
                  data_in = 0;
                  @(negedge clk_update);
                  lyr2_dw_ptr_cnt = lyr2_dw_ptr_cnt + 1;
                  lyr1_ptr_addr_cnt = lyr1_ptr_addr_cnt + 1;
                end // end if not init ptr lyr2 dw done
                else if(init_ptr_lyr1_done && (init_ptr_lyr2_dw_done) && (!init_ptr_lyr2_pw_done)) begin
                  addr_in = `data_ina_wght_ptr_1_2;
                  data_in = kernel_ptr_pw_lyr2[lyr2_pw_ptr_cnt];
                  @(negedge clk_update);
                  addr_in = `addra_wght_ptr_1_2;
                  data_in = lyr1_ptr_addr_cnt;
                  @(negedge clk_update);
                  addr_in = `wea_wght_ptr_1_2;
                  data_in = 8'hFF;
                  @(negedge clk_update);
                  addr_in = `wea_wght_ptr_1_2;
                  data_in = 0;
                  @(negedge clk_update);
                  lyr2_pw_ptr_cnt = lyr2_pw_ptr_cnt + 1;
                  lyr1_ptr_addr_cnt = lyr1_ptr_addr_cnt + 1;
                end // end of if not init ptr lyr2 pw done
                if(lyr1_ptr_cnt == 300 && !init_ptr_lyr1_done) begin
                   init_ptr_lyr1_done = 1;
                  //data_ina_wght_ptr_1_2 = kernel_ptr_dw_lyr2[0];
                end // end if lyr1 ptr count == 300
                if(lyr1_ptr_cnt == 300 && weight_cnt != 16) begin
                  init_wght_done = 0; // start filling weight table after filling weight pointer table
                end // if weight cnt is not 16
                else if (weight_cnt == 16) begin
                  init_wght_done = 1; // start filling weight table after filling weight pointer table
                end // if weight cnt == 16
                if(lyr2_dw_ptr_cnt == 150 && !init_ptr_lyr2_dw_done) begin
                   init_ptr_lyr2_dw_done = 1;
                  //data_ina_wght_ptr_1_2 = kernel_ptr_pw_lyr2[0];
                end
                if(lyr2_pw_ptr_cnt == 30) begin
                   init_ptr_lyr2_pw_done = 1;
                end
                if(!init_ptr_lyr3_done) begin
                  addr_in = `data_ina_wght_ptr3_0_msb;
                  data_in  = {12'b0,kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*4]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_0_lsb;
                  data_in =  {kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*3],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*2],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49],kernel_ptr_fc_lyr[lyr3_ptr_cnt]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_1_msb;
                  data_in = {12'b0,kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*4+49*5]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_1_lsb;
                  data_in = {kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*3+49*5],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*2+49*5],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49+49*5],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*5]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_2_msb;
                  data_in = {12'b0,kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*4+49*5*2]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_2_lsb;
                  data_in = {kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*3+49*5*2],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*2+49*5*2],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49+49*5*2],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*5*2]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_3_msb;
                  data_in = {12'b0,kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*4+49*5*3]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_3_lsb;
                  data_in = {kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*3+49*5*3],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*2+49*5*3],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49+49*5*3],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*5*3]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_4_msb;
                  data_in = {12'b0,kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*4+49*5*4]};
                  @(negedge clk_update);
                  addr_in = `data_ina_wght_ptr3_4_lsb;
                  data_in = {kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*3+49*5*4],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*2+49*5*4],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49+49*5*4],kernel_ptr_fc_lyr[lyr3_ptr_cnt+49*5*4]};
                  @(negedge clk_update);
                  addr_in = `addra_wght_ptr3_4;
                  data_in = lyr3_ptr_cnt;
                  @(negedge clk_update);
                  addr_in = `addra_wght_ptr3_3;
                  @(negedge clk_update);
                  addr_in = `addra_wght_ptr3_2;
                  @(negedge clk_update);
                  addr_in = `addra_wght_ptr3_1;
                  @(negedge clk_update);
                  addr_in = `addra_wght_ptr3_0;
                  @(negedge clk_update);
                  addr_in = `wea_wght_ptr3;
                  data_in = 16'hFFFF;
                  @(negedge clk_update);
                  addr_in = `wea_wght_ptr3;
                  data_in = 0;
                  @(negedge clk_update);
                  lyr3_ptr_cnt = lyr3_ptr_cnt + 1;
                end 
                if(lyr3_ptr_cnt == 49) begin
                  init_ptr_lyr3_done = 1;
                 //$display("completed init of dut and initialized memory weights and weight pointers \n");
                end
               end // end if(dut.init)
               if(init_ptr_lyr3_done && init_ptr_lyr1_done && init_ptr_lyr2_dw_done && init_ptr_lyr2_pw_done && init_wght_done && !start_cnn) begin
                  
                  addr_in = `weight_table4_0;
                  data_in    = {8'h0,weights_mem4[0]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_1;
                  data_in    = {8'h0,weights_mem4[1]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_2;
                  data_in    = {8'h0,weights_mem4[2]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_3;
                  data_in    = {8'h0,weights_mem4[3]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_4;
                  data_in    = {8'h0,weights_mem4[4]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_5;
                  data_in    = {8'h0,weights_mem4[5]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_6;
                  data_in    = {8'h0,weights_mem4[6]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_7;
                  data_in    = {8'h0,weights_mem4[7]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_8;
                  data_in    = {8'h0,weights_mem4[8]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_9;
                  data_in    = {8'h0,weights_mem4[9]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_10;
                  data_in    = {8'h0,weights_mem4[10]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_11;
                  data_in    = {8'h0,weights_mem4[11]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_12;
                  data_in    = {8'h0,weights_mem4[12]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_13;
                  data_in    = {8'h0,weights_mem4[13]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_14;
                  data_in    = {8'h0,weights_mem4[14]};
                  @(negedge clk_update);
                  addr_in = `weight_table4_15;
                  data_in    = {8'h0,weights_mem4[15]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr1_0;
                  data_in    = {8'h0,bias_lyr1[0]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr1_1;
                  data_in    = {8'h0,bias_lyr1[1]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr1_2;
                  data_in    = {8'h0,bias_lyr1[2]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr1_3;
                  data_in    = {8'h0,bias_lyr1[3]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr1_4;
                  data_in    = {8'h0,bias_lyr1[4]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr1_5;
                  data_in    = {8'h0,bias_lyr1[5]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr2_0;
                  data_in    = {8'h0,bias_lyr2[0]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr2_1;
                  data_in    = {8'h0,bias_lyr2[1]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr2_2;
                  data_in    = {8'h0,bias_lyr2[2]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr2_3;
                  data_in    = {8'h0,bias_lyr2[3]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr2_4;
                  data_in    = {8'h0,bias_lyr2[4]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr3_0;
                  data_in    = {8'h0,bias_lyr3[0]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr3_1;
                  data_in    = {8'h0,bias_lyr3[1]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr3_2;
                  data_in    = {8'h0,bias_lyr3[2]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr3_3;
                  data_in    = {8'h0,bias_lyr3[3]};
                  @(negedge clk_update);
                  addr_in = `bias_lyr3_4;
                  data_in    = {8'h0,bias_lyr3[4]};
                  @(negedge clk_update);
                  addr_in = `dfp_lyr1;
                  data_in   ={8'h0,dfp_lyr1};
                  @(negedge clk_update);
                  addr_in = `dfp_lyr2;
                  data_in   ={8'd0,dfp_lyr2};
                  @(negedge clk_update);
                  addr_in = `dfp_lyr3;
                  data_in   ={8'd0,dfp_lyr3};
                  @(negedge clk_update);
                  addr_in = `dfp_bias_lyr1;
                  data_in   ={8'd0,dfp_bias_lyr1};
                  @(negedge clk_update);
                  addr_in = `dfp_bias_lyr2;
                  data_in   ={8'd0,dfp_bias_lyr2};
                  @(negedge clk_update);
                  addr_in = `dfp_bias_lyr3;
                  data_in   ={8'd0,dfp_bias_lyr3};
                  @(negedge clk_update);
                  addr_in = `dfp_out_lyr1;
                  data_in   ={8'd0,dfp_out_lyr1};
                  @(negedge clk_update);
                  addr_in = `dfp_out_lyr2;
                  data_in   ={8'd0,dfp_out_lyr2};
                  @(negedge clk_update);
                  addr_in = `dfp_out_lyr3;
                  data_in   ={8'd0,dfp_out_lyr3};
                  @(negedge clk_update);
                  addr_in = `cnn_rgn_parama;
                  data_in   =1;
                  @(negedge clk_update);
                  addr_in = `cnn_rgn_paramb;
                  data_in   =1;
                  @(negedge clk_update);
                  addr_in = 3; // bias program ena
                  data_in   =0;
                  @(negedge clk_update);
                  addr_in = 1; // AER top burst en, bias_enable , burst mode and image cols
                  data_in   =16'hfd00;
                  @(negedge clk_update);
                  addr_in = 2; // frame len and frame us
                  data_in   =16'h01C8; // 200 MHz and 1ms
                  @(negedge clk_update);
                  addr_in = 127; // image rows and burst
                  data_in   =16'h04f0; // 200 MHz and 1ms
                  @(negedge clk_update);
                  addr_in = 58; // config_reg 58 controls parallel out
                  data_in   =16'h0; // class_output [4][7:0]
                  @(negedge clk_update);
                  @(negedge clk_update);// wait for two negedge of clk update for the last bias write to go through 
                  start_cnn = 1'b1;
                  init_AER_done = 1'b1;
                  //dut_conv_top.start_cnn = 1'b1;
                end  // end if (all init of layrs done)

end // end of always block for BOOT SEQUENCE

always @(posedge clk) begin // begin init for AER MEMORY and REGION PROPOSAL
                  
                 /*if(start_cnn && !raw_mem_init) begin 
                  //en_evt2frame = 1'b1; 
                  // initialize events in memory
                  if(read_data_neg[index] == 1'b1) begin
                     evt_valid = 1'b1;
                     evt_x = i_idx;
                     evt_y = j_idx;
                     evt_pol = 1'b0;
                     #clkp;
                     evt_valid = 1'b0;
                     #clkp;
                  end
                  else if (read_data_pos[index] == 1'b1) begin
                     evt_valid = 1'b1;
                     evt_x = i_idx;
                     evt_y = j_idx;
                     evt_pol = 1'b1;
                     #clkp;
                     evt_valid = 1'b0;
                     #clkp;
                   end
                   index = index + 1;
                   i_idx = i_idx + 1;
                   if(i_idx == 320) begin
                      i_idx = 0;
                      j_idx = j_idx + 1;
                   end
                   if(j_idx == 240) begin
                      raw_mem_init = 1'b1;
                   end
                  end */
                  //if(start_cnn && dut_conv_top.cnn_read_valid && !raw_mem_init) begin
                  if(start_cnn &&  !raw_mem_init) begin
                     
                     num_obj = 0;
                     region_x = 0;
                     region_y = 0;
                      region_valid = 0;
                      top_rgn_done = 1'b0;
                      top_rgn_bit_valid = 1'b0;
                      @(posedge dut_conv_top.busy_frame); // first frame
                      #15000;
                      top_rgn_done = 1'b1;
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b1;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_done = 1'b0;
                      @(negedge dut_conv_top.busy_frame); // second frame
                      #15000;
                      top_rgn_done = 1'b1;
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b1;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_done = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      @(posedge dut_conv_top.busy_frame); // third frame
                      #15000;
                      top_rgn_done = 1'b1;
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b1;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_done = 1'b0;
                      @(negedge dut_conv_top.busy_frame); // fourth frame
                  end
                  else begin
                     num_obj = 0;
                     region_x = 0;
                     region_y = 0;
                      region_valid = 0;
                      top_rgn_done = 1'b0;
                      top_rgn_bit_valid = 1'b0;
                  end
                  if(start_cnn && raw_mem_init && !region_out_done) begin
                  //if(start_cnn ) begin
                      get_region_from_file_and_output("rp_file"); 
                  end
                  if(start_cnn &&  !raw_mem_init_second) begin
                     
                     num_obj = 0;
                     region_x = 0;
                     region_y = 0;
                      region_valid = 0;
                      top_rgn_done = 1'b0;
                      top_rgn_bit_valid = 1'b0;
                      @(posedge dut_conv_top.busy_frame); // fifth frame
                      #15000;
                      top_rgn_done = 1'b1;
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b1;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_done = 1'b0;
                      @(negedge dut_conv_top.busy_frame); // sixth frame
                      #15000;
                      top_rgn_done = 1'b1;
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b1;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_done = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      @(posedge dut_conv_top.busy_frame); // seventh frame
                      #15000;
                      top_rgn_done = 1'b1;
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b1;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_done = 1'b0;
                      @(negedge dut_conv_top.busy_frame); //eigth frame
                      #15000;
                      top_rgn_done = 1'b1;
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b1;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_bit_valid = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      top_rgn_done = 1'b0;
                      @ (posedge cnn_region_clk); #1
                      @(posedge dut_conv_top.busy_frame); // ninth frame
                  end
                  else begin
                     num_obj = 0;
                     region_x = 0;
                     region_y = 0;
                      region_valid = 0;
                      top_rgn_done = 1'b0;
                      top_rgn_bit_valid = 1'b0;
                 end
                  if(start_cnn && raw_mem_init_second && !region_out_done_second) begin
                  //if(start_cnn ) begin
                      get_region_from_file_and_output("rp_file"); 
                  end

end // end always block of inita


// always block for collecting input to the cnn
//
always @(posedge clk) begin
@ (posedge dut_conv_top.start_cnn);
for(i=0; i < 42*42; i= i+1) begin
$fdisplay(reg_file1,"%b", dut_conv_top.img_pixel_ch1_cnn[i]);
$fdisplay(reg_file2,"%b", dut_conv_top.img_pixel_ch2_cnn[i]);
reg_file_done = 1;
end
if(reg_file_done) begin
reg_file_done = 0;
$fdisplay(reg_file1,"End of region");
$fdisplay(reg_file2,"End of region");
end
end


integer region_cnt = 0;
always @(posedge clk) begin // always block for output of cnn data 
/*

       // this test case has 8 regions collect the data for all 8 regions
                  //for(i = 0; i < (((`n-`k+1)*(`n-`k+1))/4);i++) begin
                     if(dut_conv_top.small_lenet_tile_based_cnn1.cnn_state == 4'h9 && dut_conv_top.small_lenet_tile_based_cnn1.tile_count_lyr1 == 4'h0 && dut_conv_top.small_lenet_tile_based_cnn1.valid_op1 && !dut_conv_top.small_lenet_tile_based_cnn1.end_op1) begin
		     $fdisplay(op_file1,"%d",dut_conv_top.small_lenet_tile_based_cnn1.data_out1); 
		     //$fdisplay(op_file2,"%h",dut.data_out2);
                     end
                     else if(dut_conv_top.small_lenet_tile_based_cnn1.cnn_state == 4'h9 && dut_conv_top.small_lenet_tile_based_cnn1.tile_count_lyr1 == 4'h1 && dut_conv_top.small_lenet_tile_based_cnn1.valid_op1 && !dut_conv_top.small_lenet_tile_based_cnn1.end_op1) begin
		     $fdisplay(op_file2,"%d",dut_conv_top.small_lenet_tile_based_cnn1.data_out1); 
		     //$fdisplay(op_file4,"%h",dut.data_out2);
                     end
                     else if(dut_conv_top.small_lenet_tile_based_cnn1.cnn_state == 4'h9 && dut_conv_top.small_lenet_tile_based_cnn1.tile_count_lyr1 == 4'h2 && dut_conv_top.small_lenet_tile_based_cnn1.valid_op1 && !dut_conv_top.small_lenet_tile_based_cnn1.end_op1) begin
		     $fdisplay(op_file3,"%d",dut_conv_top.small_lenet_tile_based_cnn1.data_out1); 
		     //$fdisplay(op_file6,"%h",dut.data_out2);
                     end
                     else if(dut_conv_top.small_lenet_tile_based_cnn1.cnn_state == 4'h9 && dut_conv_top.small_lenet_tile_based_cnn1.tile_count_lyr1 == 4'h3 && dut_conv_top.small_lenet_tile_based_cnn1.valid_op1 && !dut_conv_top.small_lenet_tile_based_cnn1.end_op1) begin
		     $fdisplay(op_file4,"%d",dut_conv_top.small_lenet_tile_based_cnn1.data_out1); 
                     end
                     else if(dut_conv_top.small_lenet_tile_based_cnn1.cnn_state == 4'h9 && dut_conv_top.small_lenet_tile_based_cnn1.tile_count_lyr1 == 4'h4 && dut_conv_top.small_lenet_tile_based_cnn1.valid_op1 && !dut_conv_top.small_lenet_tile_based_cnn1.end_op1) begin
		     $fdisplay(op_file5,"%d",dut_conv_top.small_lenet_tile_based_cnn1.data_out1); 
                     end
                     else if( dut_conv_top.small_lenet_tile_based_cnn1.tile_count_lyr1 == 4'h5 && dut_conv_top.small_lenet_tile_based_cnn1.valid_op1 && !dut_conv_top.small_lenet_tile_based_cnn1.end_op1) begin
		     $fdisplay(op_file6,"%d",dut_conv_top.small_lenet_tile_based_cnn1.data_out1); 
                     end
                  // end
                  if(dut_conv_top.small_lenet_tile_based_cnn1.lyr2_valid_op[0] && !dut_conv_top.small_lenet_tile_based_cnn1.lyr2_end_op[0]) begin
		   $fdisplay(op1_file1 ,"%d",dut_conv_top.small_lenet_tile_based_cnn1.lyr2_data_out[0]); 
		   $fdisplay(op1_file2 ,"%d",dut_conv_top.small_lenet_tile_based_cnn1.lyr2_data_out[1]); 
		   $fdisplay(op1_file3 ,"%d",dut_conv_top.small_lenet_tile_based_cnn1.lyr2_data_out[2]); 
		   $fdisplay(op1_file4 ,"%d",dut_conv_top.small_lenet_tile_based_cnn1.lyr2_data_out[3]); 
		   $fdisplay(op1_file5 ,"%d",dut_conv_top.small_lenet_tile_based_cnn1.lyr2_data_out[4]);
                 end // end of if valid_op and not end_op
*/
		if(dut_conv_top.done) begin
                      read_cnn_data_out = 1;
                 end // end if cnn_done
                 if(read_cnn_data_out) begin
                      data_in = 1;
                      addr_in = 58;
                      @(negedge clk_update);
                      class_output[4][7:0] = parallel_out[7:0];
                      data_in = 2;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[4][15:8] = parallel_out[7:0];
                      data_in = 3;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[4][23:16] = parallel_out[7:0];
                      data_in = 4;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[4][31:24] = parallel_out[7:0];
                      data_in = 5;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[3][7:0] = parallel_out[7:0];
                      data_in = 6;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[3][15:8] = parallel_out[7:0];
                      data_in = 7;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[3][23:16] = parallel_out[7:0];
                      data_in = 8;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[3][31:24] = parallel_out[7:0];
                      data_in = 9;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[2][7:0] = parallel_out[7:0];
                      data_in = 10;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[2][15:8] = parallel_out[7:0];
                      data_in = 11;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[2][23:16] = parallel_out[7:0];
                      data_in = 12;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[2][31:24] = parallel_out[7:0];
                      data_in = 13;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[1][7:0] = parallel_out[7:0];
                      data_in = 14;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[1][15:8] = parallel_out[7:0];
                      data_in = 15;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[1][23:16] = parallel_out[7:0];
                      data_in = 16;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[1][31:24] = parallel_out[7:0];
                      data_in = 17;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[0][7:0] = parallel_out[7:0];
                      data_in = 18;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[0][15:8] = parallel_out[7:0];
                      data_in = 19;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[0][23:16] = parallel_out[7:0];
                      data_in = 0;
                      addr_in = 58;
                      @(negedge clk_update);
                      #(2*clkp_spi);
                      class_output[0][31:24] = parallel_out[7:0];
                      @(negedge clk_update);
                 for(i=0; i<5;i=i+1) begin
                   // for the trained and verified model, the class outputs
                   // are :
                   // other [0]
                   // car/van [1]
                   // Bus [2]
                   // bike [3]
                   // truck [4]
                   // read the class output from SPI config_reg58_int2 = 0 to 3 class_output[4], lsb first 
                   // config_reg58_int2 4 to7 is class_output[3][7:0] to class_output [3][31:23]
                     
                   $fdisplay(dut_file_out, "%d",class_output[i]);
                   $display("%h",class_output[i]);
                 end
		$fdisplay(dut_file_out,"%s%0d",endc,`tn);
                region_cnt = region_cnt + 1; 
                      read_cnn_data_out = 0;
                 end // end if (read_cnn_data_out)
/*
		$fdisplay(op_file1,"%s%0d",endc,`tn);
		$fdisplay(op_file2,"%s%0d",endc,`tn);
		$fdisplay(op_file3,"%s%0d",endc,`tn);
		$fdisplay(op_file4,"%s%0d",endc,`tn);
		$fdisplay(op_file5,"%s%0d",endc,`tn);
		$fdisplay(op_file6,"%s%0d",endc,`tn);
		$fdisplay(op1_file1,"%s%0d",endc,`tn); 
		$fdisplay(op1_file2,"%s%0d",endc,`tn); 
		$fdisplay(op1_file3,"%s%0d",endc,`tn); 
		$fdisplay(op1_file4,"%s%0d",endc,`tn); 
		$fdisplay(op1_file5,"%s%0d",endc,`tn); 
		//$toggle_stop();
                 //$toggle_report("saif_allc1s.saif",1e-12, dut);
                 //$toggle_report("dut.saif",1e-12, dut);

		//end // end if cnn done
*/

          if(region_cnt == 16) begin  // this rp_file has 8 regions
	        $finish;
               $vcdplusclose;	
          end
end
		

always #(clkp/2) clk = ~clk;
always #(clkp/2) clk_top <= ~clk_top;
always #(clkp_spi/2) clk_phase1 <= ~clk_phase1;
always #(clkp_spi/2) clk_phase2 <= ~clk_phase2;

 always @ (posedge clk_phase1 or negedge reset_n) begin
	if (!reset_n) data_serial_in <= 0;
        else if (start_cnn && !read_cnn_data_out) data_serial_in <= 0;
	else if (clk_update) data_serial_in <= {data_in,addr_in} ;
	//else if (clk_update) data_serial_in <= {data_in[counter_1],addr_in[counter_1]} ;
	//else if (clk_update) data_serial_in <= ~ready? {data_in[counter_1],addr_in[counter_1]} : {data_in[counter_3],addr_in[counter_3]};
	//else if (capture)  data_serial_in <= {{ARRAY_WIDTH{1'b0}},addr_in[counter_3]};
	else data_serial_in <= data_serial_in >> 1;
 end 
 
 always @ (posedge clk_phase2 or negedge reset_n) begin
	if (!reset_n) begin 
		 counter_2 <=0 ;
		 counter_1 <=0 ;
		 ready <= 1'b0;
	end
 	else if ((counter_2 == TOTAL_WIDTH) & counter_1 <=(ARRAY_DEPTH)) begin 
                 if(!start_cnn || read_cnn_data_out) #(clkp_spi/10) clk_update <= 1'b1;
		counter_1 <= counter_1 +1;
		counter_2 <= 0;
	end
	else begin
		if (counter_1 == 8'd129)ready <= 1'b1; 
		counter_2 <= counter_2 +1;
		clk_update <= 1'b0;
		if (counter_1 == 8'd129)counter_1 <= 8'h0; 
                   
	end
 end

initial
begin
$sdf_annotate("/usr1/zzz/CNN/outputDB/conv_top.sdf",dut_conv_top);
end

initial begin
reset_new = 1;
# 50
reset_new = 0;
end
endmodule

