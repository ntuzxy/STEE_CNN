module conv_top(
reset_n,
rst_n_sync,
clk_phase1,
clk_phase2,
capture,
clk_update,
spi_din,
spi_out,
clk_top,
parallel_out,
top_AER_data,
top_AER_nreq,
top_AER_nack,
top_BiasAddrSel,
top_BiasBitIN,
top_BiasClock,
top_BiasLatch,
top_BiasDiagSel,
en_evt2frame,
rgn_rd_en,
rgn_done,
rgn_bit_valid,
rgn_x_bit,
rgn_y_bit,
rgn_clk,
init,
conv_done1,
done,
dbg_dout_valid,
ext_dataIn_pos,
ext_dataIn_neg,
ext_xAddressOut,
ext_cnn_done,
ext_cnn_rd_done,
ext_cnn_ready
);


localparam ARRAY_WIDTH = 16;
// parameter for lavanya cnn
localparam IMG_WIDTH = 42;
localparam IMG_HEIGHT = 42;
localparam WEIGHT_WIDTH = 8; // precision of weights
localparam FLTR_PTR_SIZE = 4; // four bits to access 16 weights
localparam KERNEL_PTR1_ADDR_WIDTH = 9; // 25*2*6+25*6+6*5 = 480_
localparam KERNEL_PTR3_ADDR_WIDTH = 6; // 49*5*5 = 1225
localparam DFP_WIDTH = 8; // width of the dynamic efixed point register
localparam NUM_PW_FLTRS = 5; // 5 filters in tiny net // check with 2 PW filters
//..........spi_pad.............
input clk_phase1;
input clk_phase2;
input capture;
input clk_update;
input spi_din;
output spi_out;
output [7:0] parallel_out;
wire [7:0] parallel_out1;
/////////////////////////////AER input
//............pad...........
input clk_top;
input [9:0] top_AER_data;
input top_AER_nreq;
input en_evt2frame;
output top_AER_nack;
output top_BiasAddrSel;
output top_BiasBitIN;
output top_BiasClock;
output top_BiasLatch;
output top_BiasDiagSel;
//.............output pin............
wire top_bias_ready;
wire top_evt_out_valid;
wire [8:0] top_evt_out_x;
wire [7:0] top_evt_out_y;
wire top_evt_out_pol;
wire ready_evtframe;
wire altern;
//............evt2qvga
wire busy_frame;
wire overflow_read;
wire timer_error;
wire [8:0] cnn_read_x;
wire [8:0] cnn_read_y;
wire [1:0] top_data_wr_dbg;
wire [1:0] top_data_rd_dbg;
//.............reset_sync
input reset_n;
output rst_n_sync;
wire reset_n_int;
wire reset_p_int;
assign rst_n_sync = reset_n_int;
//.............end....................
//..............Charles CNN_input_gen
//.................pad..................
output rgn_rd_en;
input rgn_done;
input rgn_bit_valid;
input rgn_x_bit;
input rgn_y_bit;
input rgn_clk; // for slower clock

wire raw_data_pos;
wire raw_data_neg;
wire cnn_done_to_memory;
wire cnn_read_valid;
//
output dbg_dout_valid; // output pin (PAD)
wire [7:0] dbg_dout; // 
input ext_dataIn_pos;
input ext_dataIn_neg;
output [8:0] ext_xAddressOut;
output ext_cnn_done;
input ext_cnn_rd_done;
output ext_cnn_ready;
//............CNN lavanya pad.............
input init;
output conv_done1;
output done;
wire [3:0] cnn_state; 
wire [3:0] lyr2_state;
wire [2:0] fc_read_state;
wire valid_op1;
wire fc_mac_en;
wire mat_mul_done;
//...................................
wire [31:0] data_out1;
wire [31:0] data_out2;
wire [31:0] data_out3;
wire [31:0] data_out4;
wire [31:0] data_out5;
wire [31:0] data_out6;
wire [31:0] data_out7;
wire [31:0] data_out8;
wire [31:0] data_out9;
wire [31:0] data_out10;
wire [7:0] data_out11;
wire [7:0] data_out12;
wire [3:0] data_out13;

wire [IMG_HEIGHT*IMG_WIDTH-1:0] img_pixel_ch1_cnn;     // Input from CNN_input_gen.v
wire [IMG_HEIGHT*IMG_WIDTH-1:0] img_pixel_ch2_cnn;     // Input from CNN_input_gen.v
wire start_cnn;
//.......................................//
wire [ARRAY_WIDTH -1:0 ] config_reg0;
wire [ARRAY_WIDTH -1:0 ] config_reg1;
wire [ARRAY_WIDTH -1:0 ] config_reg2;
wire [ARRAY_WIDTH -1:0 ] config_reg3;
wire [ARRAY_WIDTH -1:0 ] config_reg4;
wire [ARRAY_WIDTH -1:0 ] config_reg5;
wire [ARRAY_WIDTH -1:0 ] config_reg6;
wire [ARRAY_WIDTH -1:0 ] config_reg7;
wire [ARRAY_WIDTH -1:0 ] config_reg8;
wire [ARRAY_WIDTH -1:0 ] config_reg9;
wire [ARRAY_WIDTH -1:0 ] config_reg10;
wire [ARRAY_WIDTH -1:0 ] config_reg11;
wire [ARRAY_WIDTH -1:0 ] config_reg12;
wire [ARRAY_WIDTH -1:0 ] config_reg13;
wire [ARRAY_WIDTH -1:0 ] config_reg14;
wire [ARRAY_WIDTH -1:0 ] config_reg15;
wire [ARRAY_WIDTH -1:0 ] config_reg16;
wire [ARRAY_WIDTH -1:0 ] config_reg17;
wire [ARRAY_WIDTH -1:0 ] config_reg18;
wire [ARRAY_WIDTH -1:0 ] config_reg19;
wire [ARRAY_WIDTH -1:0 ] config_reg20;
wire [ARRAY_WIDTH -1:0 ] config_reg21;
wire [ARRAY_WIDTH -1:0 ] config_reg22;
wire [ARRAY_WIDTH -1:0 ] config_reg23;
wire [ARRAY_WIDTH -1:0 ] config_reg24;
wire [ARRAY_WIDTH -1:0 ] config_reg25;
wire [ARRAY_WIDTH -1:0 ] config_reg26;
wire [ARRAY_WIDTH -1:0 ] config_reg27;
wire [ARRAY_WIDTH -1:0 ] config_reg28;
wire [ARRAY_WIDTH -1:0 ] config_reg29;
wire [ARRAY_WIDTH -1:0 ] config_reg30;
wire [ARRAY_WIDTH -1:0 ] config_reg31;
wire [ARRAY_WIDTH -1:0 ] config_reg32;
wire [ARRAY_WIDTH -1:0 ] config_reg33;
wire [ARRAY_WIDTH -1:0 ] config_reg34;
wire [ARRAY_WIDTH -1:0 ] config_reg35;
wire [ARRAY_WIDTH -1:0 ] config_reg36;
wire [ARRAY_WIDTH -1:0 ] config_reg37;
wire [ARRAY_WIDTH -1:0 ] config_reg38;
wire [ARRAY_WIDTH -1:0 ] config_reg39;
wire [ARRAY_WIDTH -1:0 ] config_reg40;
wire [ARRAY_WIDTH -1:0 ] config_reg41;
wire [ARRAY_WIDTH -1:0 ] config_reg42;
wire [ARRAY_WIDTH -1:0 ] config_reg43;
wire [ARRAY_WIDTH -1:0 ] config_reg44;
wire [ARRAY_WIDTH -1:0 ] config_reg45;
wire [ARRAY_WIDTH -1:0 ] config_reg46;
wire [ARRAY_WIDTH -1:0 ] config_reg47;
wire [ARRAY_WIDTH -1:0 ] config_reg48;
wire [ARRAY_WIDTH -1:0 ] config_reg49;
wire [ARRAY_WIDTH -1:0 ] config_reg50;
wire [ARRAY_WIDTH -1:0 ] config_reg51;
wire [ARRAY_WIDTH -1:0 ] config_reg52;
wire [ARRAY_WIDTH -1:0 ] config_reg53;
wire [ARRAY_WIDTH -1:0 ] config_reg54;
wire [ARRAY_WIDTH -1:0 ] config_reg55;
wire [ARRAY_WIDTH -1:0 ] config_reg56;
wire [ARRAY_WIDTH -1:0 ] config_reg57;
wire [ARRAY_WIDTH -1:0 ] config_reg58;
reg  [ARRAY_WIDTH -1:0 ] config_reg58_int1;
reg  [ARRAY_WIDTH -1:0 ] config_reg58_int2;
wire [ARRAY_WIDTH -1:0 ] config_reg59;
wire [ARRAY_WIDTH -1:0 ] config_reg60;
wire [ARRAY_WIDTH -1:0 ] config_reg61;
wire [ARRAY_WIDTH -1:0 ] config_reg62;
wire [ARRAY_WIDTH -1:0 ] config_reg63;
wire [ARRAY_WIDTH -1:0 ] config_reg64;
wire [ARRAY_WIDTH -1:0 ] config_reg65;
wire [ARRAY_WIDTH -1:0 ] config_reg66;
wire [ARRAY_WIDTH -1:0 ] config_reg67;
wire [ARRAY_WIDTH -1:0 ] config_reg68;
wire [ARRAY_WIDTH -1:0 ] config_reg69;
wire [ARRAY_WIDTH -1:0 ] config_reg70;
wire [ARRAY_WIDTH -1:0 ] config_reg71;
wire [ARRAY_WIDTH -1:0 ] config_reg72;
wire [ARRAY_WIDTH -1:0 ] config_reg73;
wire [ARRAY_WIDTH -1:0 ] config_reg74;
wire [ARRAY_WIDTH -1:0 ] config_reg75;
wire [ARRAY_WIDTH -1:0 ] config_reg76;
wire [ARRAY_WIDTH -1:0 ] config_reg77;
wire [ARRAY_WIDTH -1:0 ] config_reg78;
wire [ARRAY_WIDTH -1:0 ] config_reg79;
wire [ARRAY_WIDTH -1:0 ] config_reg80;
wire [ARRAY_WIDTH -1:0 ] config_reg81;
wire [ARRAY_WIDTH -1:0 ] config_reg82;
wire [ARRAY_WIDTH -1:0 ] config_reg83;
wire [ARRAY_WIDTH -1:0 ] config_reg84;
wire [ARRAY_WIDTH -1:0 ] config_reg85;
wire [ARRAY_WIDTH -1:0 ] config_reg86;
wire [ARRAY_WIDTH -1:0 ] config_reg87;
wire [ARRAY_WIDTH -1:0 ] config_reg88;
wire [ARRAY_WIDTH -1:0 ] config_reg89;
wire [ARRAY_WIDTH -1:0 ] config_reg90;
wire [ARRAY_WIDTH -1:0 ] config_reg91;
wire [ARRAY_WIDTH -1:0 ] config_reg92;
wire [ARRAY_WIDTH -1:0 ] config_reg93;
wire [ARRAY_WIDTH -1:0 ] config_reg94;
wire [ARRAY_WIDTH -1:0 ] config_reg95;
wire [ARRAY_WIDTH -1:0 ] config_reg96;
wire [ARRAY_WIDTH -1:0 ] config_reg97;
wire [ARRAY_WIDTH -1:0 ] config_reg98;
wire [ARRAY_WIDTH -1:0 ] config_reg99;
wire [ARRAY_WIDTH -1:0 ] config_reg100;
wire [ARRAY_WIDTH -1:0 ] config_reg101;
wire [ARRAY_WIDTH -1:0 ] config_reg102;
wire [ARRAY_WIDTH -1:0 ] config_reg103;
wire [ARRAY_WIDTH -1:0 ] config_reg104;
wire [ARRAY_WIDTH -1:0 ] config_reg105;
wire [ARRAY_WIDTH -1:0 ] config_reg106;
wire [ARRAY_WIDTH -1:0 ] config_reg107;
wire [ARRAY_WIDTH -1:0 ] config_reg108;
wire [ARRAY_WIDTH -1:0 ] config_reg109;
wire [ARRAY_WIDTH -1:0 ] config_reg110;
wire [ARRAY_WIDTH -1:0 ] config_reg111;
wire [ARRAY_WIDTH -1:0 ] config_reg112;
wire [ARRAY_WIDTH -1:0 ] config_reg113;
wire [ARRAY_WIDTH -1:0 ] config_reg114;
wire [ARRAY_WIDTH -1:0 ] config_reg115;
wire [ARRAY_WIDTH -1:0 ] config_reg116;
wire [ARRAY_WIDTH -1:0 ] config_reg117;
wire [ARRAY_WIDTH -1:0 ] config_reg118;
wire [ARRAY_WIDTH -1:0 ] config_reg119;
wire [ARRAY_WIDTH -1:0 ] config_reg120;
wire [ARRAY_WIDTH -1:0 ] config_reg121;
wire [ARRAY_WIDTH -1:0 ] config_reg122;
wire [ARRAY_WIDTH -1:0 ] config_reg123;
wire [ARRAY_WIDTH -1:0 ] config_reg124;
wire [ARRAY_WIDTH -1:0 ] config_reg125;
wire [ARRAY_WIDTH -1:0 ] config_reg126;
wire [ARRAY_WIDTH -1:0 ] config_reg127;
//...................................memory port ......... .
wire [KERNEL_PTR3_ADDR_WIDTH-1:0] addra_wght_ptr3[4:0];
assign addra_wght_ptr3[4]= config_reg68[KERNEL_PTR3_ADDR_WIDTH-1:0];
assign addra_wght_ptr3[3]= config_reg69[KERNEL_PTR3_ADDR_WIDTH-1:0];
assign addra_wght_ptr3[2]= config_reg70[KERNEL_PTR3_ADDR_WIDTH-1:0];
assign addra_wght_ptr3[1]= config_reg71[KERNEL_PTR3_ADDR_WIDTH-1:0];
assign addra_wght_ptr3[0]= config_reg72[KERNEL_PTR3_ADDR_WIDTH-1:0];

wire [32-1:0] data_ina_wght_ptr3[4:0];
assign data_ina_wght_ptr3[4] = {config_reg73,config_reg74};
assign data_ina_wght_ptr3[3] = {config_reg75,config_reg76};
assign data_ina_wght_ptr3[2] = {config_reg77,config_reg78};
assign data_ina_wght_ptr3[1] = {config_reg79,config_reg80};
assign data_ina_wght_ptr3[0] = {config_reg81,config_reg82};


wire wea_wght_ptr3[4:0];
wire ena_wght_ptr3[4:0];



reg [15:0] config_reg83_int1;
reg [15:0] config_reg83_int2;

reg [1:0] config_reg63_int1;
reg [1:0] config_reg63_int2;

reg [1:0] config_reg64_intx1;
reg [1:0] config_reg64_intx2;

reg [1:0] config_reg67_int1;
reg [1:0] config_reg67_int2;

always @( posedge clk_top or negedge reset_n_int) begin
	if (!reset_n_int) begin
		config_reg83_int1 <= 16'd0;
		config_reg83_int2 <= 16'd0;

		config_reg63_int1 <= 2'd0;
		config_reg63_int2 <= 2'd0;

		config_reg64_intx1 <= 2'd0;
		config_reg64_intx2 <= 2'd0;


		config_reg67_int1 <= 2'd0;
		config_reg67_int2 <= 2'd0;
	end
	else begin
		config_reg83_int1 <= config_reg83;
		config_reg83_int2 <= config_reg83_int1;

		config_reg63_int1 <= config_reg63[1:0];
		config_reg63_int2 <= config_reg63_int1;
		
		config_reg64_intx1 <= config_reg64[1:0];
		config_reg64_intx2 <= config_reg64_intx1;

		config_reg67_int1 <= config_reg67[1:0];
		config_reg67_int2 <= config_reg67_int1;


	end
end

assign wea_wght_ptr3[4]=config_reg83_int2[4];
assign wea_wght_ptr3[3]=config_reg83_int2[3];
assign wea_wght_ptr3[2]=config_reg83_int2[2];
assign wea_wght_ptr3[1]=config_reg83_int2[1];
assign wea_wght_ptr3[0]=config_reg83_int2[0];

assign ena_wght_ptr3[4]=config_reg83_int2[9];
assign ena_wght_ptr3[3]=config_reg83_int2[8];
assign ena_wght_ptr3[2]=config_reg83_int2[7];
assign ena_wght_ptr3[1]=config_reg83_int2[6];
assign ena_wght_ptr3[0]=config_reg83_int2[5];

wire [WEIGHT_WIDTH-1:0] weight_table4 [2**FLTR_PTR_SIZE-1:0];

assign weight_table4[15] = config_reg84[WEIGHT_WIDTH-1:0];
assign weight_table4[14] = config_reg85[WEIGHT_WIDTH-1:0];
assign weight_table4[13] = config_reg86[WEIGHT_WIDTH-1:0];
assign weight_table4[12] = config_reg87[WEIGHT_WIDTH-1:0];
assign weight_table4[11] = config_reg88[WEIGHT_WIDTH-1:0];
assign weight_table4[10] = config_reg89[WEIGHT_WIDTH-1:0];
assign weight_table4[9] = config_reg90[WEIGHT_WIDTH-1:0];
assign weight_table4[8] = config_reg91[WEIGHT_WIDTH-1:0];
assign weight_table4[7] = config_reg92[WEIGHT_WIDTH-1:0];
assign weight_table4[6] = config_reg93[WEIGHT_WIDTH-1:0];
assign weight_table4[5] = config_reg94[WEIGHT_WIDTH-1:0];
assign weight_table4[4] = config_reg95[WEIGHT_WIDTH-1:0];
assign weight_table4[3] = config_reg96[WEIGHT_WIDTH-1:0];
assign weight_table4[2] = config_reg97[WEIGHT_WIDTH-1:0];
assign weight_table4[1] = config_reg98[WEIGHT_WIDTH-1:0];
assign weight_table4[0] = config_reg99[WEIGHT_WIDTH-1:0];

wire [WEIGHT_WIDTH-1:0] bias_lyr1[5:0];
assign bias_lyr1[5] = config_reg100[WEIGHT_WIDTH-1:0];
assign bias_lyr1[4] = config_reg101[WEIGHT_WIDTH-1:0];
assign bias_lyr1[3] = config_reg102[WEIGHT_WIDTH-1:0];
assign bias_lyr1[2] = config_reg103[WEIGHT_WIDTH-1:0];
assign bias_lyr1[1] = config_reg104[WEIGHT_WIDTH-1:0];
assign bias_lyr1[0] = config_reg105[WEIGHT_WIDTH-1:0];
wire [WEIGHT_WIDTH-1:0] bias_lyr2[4:0];
assign bias_lyr2[4] = config_reg107[WEIGHT_WIDTH-1:0];
assign bias_lyr2[3] = config_reg108[WEIGHT_WIDTH-1:0];
assign bias_lyr2[2] = config_reg109[WEIGHT_WIDTH-1:0];
assign bias_lyr2[1] = config_reg110[WEIGHT_WIDTH-1:0];
assign bias_lyr2[0] = config_reg111[WEIGHT_WIDTH-1:0];

wire [WEIGHT_WIDTH-1:0] bias_lyr3[4:0];
assign bias_lyr3[4] = config_reg112[WEIGHT_WIDTH-1:0];
assign bias_lyr3[3] = config_reg113[WEIGHT_WIDTH-1:0];
assign bias_lyr3[2] = config_reg114[WEIGHT_WIDTH-1:0];
assign bias_lyr3[1] = config_reg115[WEIGHT_WIDTH-1:0];
assign bias_lyr3[0] = config_reg116[WEIGHT_WIDTH-1:0];

wire [31:0] class_output[4:0];
reg [31:0] class_output_reg[4:0];

assign data_out6 = class_output_reg[4];
assign data_out7 = class_output_reg[3];
assign data_out8 = class_output_reg[2];
assign data_out9 = class_output_reg[1];
assign data_out10 = class_output_reg[0];

wire [31:0] data_outa_wght_ptr3[4:0];

assign data_out1 = data_outa_wght_ptr3[4];
assign data_out2 = data_outa_wght_ptr3[3];
assign data_out3 = data_outa_wght_ptr3[2];
assign data_out4 = data_outa_wght_ptr3[1];
assign data_out5 = data_outa_wght_ptr3[0];


wire ena_lyr2_pw[NUM_PW_FLTRS-1:0];
wire wea_lyr2_pw[NUM_PW_FLTRS-1:0];
wire enb_lyr2_pw[NUM_PW_FLTRS-1:0];
wire web_lyr2_pw[NUM_PW_FLTRS-1:0];


wire [7:0] addra_pw_surf_cnt [NUM_PW_FLTRS-1:0];
wire [7:0] data_out14;
wire [7:0] data_out15;
wire [7:0] data_out16;
wire [7:0] data_out17;
wire [7:0] data_out18;

assign data_out14 = addra_pw_surf_cnt[0];
assign data_out15 = addra_pw_surf_cnt[1];
assign data_out16 = addra_pw_surf_cnt[2];
assign data_out17 = addra_pw_surf_cnt[3];
assign data_out18 = addra_pw_surf_cnt[4];

wire [7:0] addrb_pw_surf_cnt [NUM_PW_FLTRS-1:0];
wire [7:0] data_out19;
wire [7:0] data_out20;
wire [7:0] data_out21;
wire [7:0] data_out22;
wire [7:0] data_out23;

assign data_out19 = addrb_pw_surf_cnt[0];
assign data_out20 = addrb_pw_surf_cnt[1];
assign data_out21 = addrb_pw_surf_cnt[2];
assign data_out22 = addrb_pw_surf_cnt[3];
assign data_out23 = addrb_pw_surf_cnt[4];

wire [31:0] data_ina_lyr2_pw [NUM_PW_FLTRS-1:0];
wire [31:0] data_outa_lyr2_pw [NUM_PW_FLTRS-1:0];
wire [31:0] data_inb_lyr2_pw [NUM_PW_FLTRS-1:0];
wire [31:0] data_outb_lyr2_pw [NUM_PW_FLTRS-1:0];

wire [31:0] data_out24;
wire [31:0] data_out25;
wire [31:0] data_out26;
wire [31:0] data_out27;
wire [31:0] data_out28;

assign data_out24 = data_ina_lyr2_pw [0];
assign data_out25 = data_ina_lyr2_pw [1];
assign data_out26 = data_ina_lyr2_pw [2];
assign data_out27 = data_ina_lyr2_pw [3];
assign data_out28 = data_ina_lyr2_pw [4];


wire [31:0] data_out29;
wire [31:0] data_out30;
wire [31:0] data_out31;
wire [31:0] data_out32;
wire [31:0] data_out33;

assign data_out29 = data_outa_lyr2_pw [0];
assign data_out30 = data_outa_lyr2_pw [1];
assign data_out31 = data_outa_lyr2_pw [2];
assign data_out32 = data_outa_lyr2_pw [3];
assign data_out33 = data_outa_lyr2_pw [4];


wire [31:0] data_out34;
wire [31:0] data_out35;
wire [31:0] data_out36;
wire [31:0] data_out37;
wire [31:0] data_out38;

assign data_out34 = data_inb_lyr2_pw [0];
assign data_out35 = data_inb_lyr2_pw [1];
assign data_out36 = data_inb_lyr2_pw [2];
assign data_out37 = data_inb_lyr2_pw [3];
assign data_out38 = data_inb_lyr2_pw [4];

wire [31:0] data_out39;
wire [31:0] data_out40;
wire [31:0] data_out41;
wire [31:0] data_out42;
wire [31:0] data_out43;

assign data_out39 = data_outb_lyr2_pw [0];
assign data_out40 = data_outb_lyr2_pw [1];
assign data_out41 = data_outb_lyr2_pw [2];
assign data_out42 = data_outb_lyr2_pw [3];
assign data_out43 = data_outb_lyr2_pw [4];

wire [NUM_PW_FLTRS-1:0] lyr2_valid_op;
wire [NUM_PW_FLTRS-1:0] lyr2_end_op;
wire [NUM_PW_FLTRS-1:0] valid_ip;

wire [31:0] lyr2_relu_op [NUM_PW_FLTRS-1:0];
wire [31:0] lyr2_sat_in [NUM_PW_FLTRS-1:0];

wire [31:0] data_out44;
wire [31:0] data_out45;
wire [31:0] data_out46;
wire [31:0] data_out47;
wire [31:0] data_out48;

assign data_out44 = lyr2_relu_op[0];
assign data_out45 = lyr2_relu_op[1];
assign data_out46 = lyr2_relu_op[2];
assign data_out47 = lyr2_relu_op[3];
assign data_out48 = lyr2_relu_op[4];

wire [31:0] data_out49;
wire [31:0] data_out50;
wire [31:0] data_out51;
wire [31:0] data_out52;
wire [31:0] data_out53;

assign data_out49 = lyr2_sat_in[0];
assign data_out50 = lyr2_sat_in[1];
assign data_out51 = lyr2_sat_in[2];
assign data_out52 = lyr2_sat_in[3];
assign data_out53 = lyr2_sat_in[4];


wire [7:0] lyr2_data_out [NUM_PW_FLTRS-1:0];

wire [7:0] data_out54;
wire [7:0] data_out55;
wire [7:0] data_out56;
wire [7:0] data_out57;
wire [7:0] data_out58;

assign data_out54 = lyr2_data_out[0];
assign data_out55 = lyr2_data_out[1];
assign data_out56 = lyr2_data_out[2];
assign data_out57 = lyr2_data_out[3];
assign data_out58 = lyr2_data_out[4];

wire [31:0] mul_out[4:0][4:0];

wire [31:0] data_out60;
wire [31:0] data_out61;
wire [31:0] data_out62;
wire [31:0] data_out63;
wire [31:0] data_out64;

wire [31:0] data_out65;
wire [31:0] data_out66;
wire [31:0] data_out67;
wire [31:0] data_out68;
wire [31:0] data_out69;

wire [31:0] data_out70;
wire [31:0] data_out71;
wire [31:0] data_out72;
wire [31:0] data_out73;
wire [31:0] data_out74;

wire [31:0] data_out75;
wire [31:0] data_out76;
wire [31:0] data_out77;
wire [31:0] data_out78;
wire [31:0] data_out79;

wire [31:0] data_out80;
wire [31:0] data_out81;
wire [31:0] data_out82;
wire [31:0] data_out83;
wire [31:0] data_out84;

assign data_out60 = mul_out[0][0];
assign data_out61 = mul_out[0][1];
assign data_out62 = mul_out[0][2];
assign data_out63 = mul_out[0][3];
assign data_out64 = mul_out[0][4];

assign data_out65 = mul_out[1][0];
assign data_out66 = mul_out[1][1];
assign data_out67 = mul_out[1][2];
assign data_out68 = mul_out[1][3];
assign data_out69 = mul_out[1][4];

assign data_out70 = mul_out[2][0];
assign data_out71 = mul_out[2][1];
assign data_out72 = mul_out[2][2];
assign data_out73 = mul_out[2][3];
assign data_out74 = mul_out[2][4];

assign data_out75 = mul_out[3][0];
assign data_out76 = mul_out[3][1];
assign data_out77 = mul_out[3][2];
assign data_out78 = mul_out[3][3];
assign data_out79 = mul_out[3][4];

assign data_out80 = mul_out[4][0];
assign data_out81 = mul_out[4][1];
assign data_out82 = mul_out[4][2];
assign data_out83 = mul_out[4][3];
assign data_out84 = mul_out[4][4];


wire [31:0] fc_ptr[4:0];

wire [31:0] data_out85;
wire [31:0] data_out86;
wire [31:0] data_out87;
wire [31:0] data_out88;
wire [31:0] data_out89;

assign data_out85 = fc_ptr[0];
assign data_out86 = fc_ptr[1];
assign data_out87 = fc_ptr[2];
assign data_out88 = fc_ptr[3];
assign data_out89 = fc_ptr[4];

wire  [5:0] fc_cnt;
wire  [7:0] data_out90;




//////////////////////////////////////////////////
reset_synchronizer reset_synchronizer1(
.clk(clk_top),
.asyc_rst_n(reset_n),
.sync_rst_n(reset_n_int),
.sync_rst(reset_p_int)
);


spi_top spi_top_1(
.spi_din(spi_din),
.spi_out(spi_out),
.clk_phase1(clk_phase1),
.clk_phase2(clk_phase2),
.clk_update(clk_update),
.capture(capture),
.reset_n(reset_n_int),
.config_reg0(config_reg0),
.config_reg1(config_reg1),
.config_reg2(config_reg2),
.config_reg3(config_reg3),
.config_reg4(config_reg4),
.config_reg5(config_reg5),
.config_reg6(config_reg6),
.config_reg7(config_reg7),
.config_reg8(config_reg8),
.config_reg9(config_reg9),
.config_reg10(config_reg10),
.config_reg11(config_reg11),
.config_reg12(config_reg12),
.config_reg13(config_reg13),
.config_reg14(config_reg14),
.config_reg15(config_reg15),
.config_reg16(config_reg16),
.config_reg17(config_reg17),
.config_reg18(config_reg18),
.config_reg19(config_reg19),
.config_reg20(config_reg20),
.config_reg21(config_reg21),
.config_reg22(config_reg22),
.config_reg23(config_reg23),
.config_reg24(config_reg24),
.config_reg25(config_reg25),
.config_reg26(config_reg26),
.config_reg27(config_reg27),
.config_reg28(config_reg28),
.config_reg29(config_reg29),
.config_reg30(config_reg30),
.config_reg31(config_reg31),
.config_reg32(config_reg32),
.config_reg33(config_reg33),
.config_reg34(config_reg34),
.config_reg35(config_reg35),
.config_reg36(config_reg36),
.config_reg37(config_reg37),
.config_reg38(config_reg38),
.config_reg39(config_reg39),
.config_reg40(config_reg40),
.config_reg41(config_reg41),
.config_reg42(config_reg42),
.config_reg43(config_reg43),
.config_reg44(config_reg44),
.config_reg45(config_reg45),
.config_reg46(config_reg46),
.config_reg47(config_reg47),
.config_reg48(config_reg48),
.config_reg49(config_reg49),
.config_reg50(config_reg50),
.config_reg51(config_reg51),
.config_reg52(config_reg52),
.config_reg53(config_reg53),
.config_reg54(config_reg54),
.config_reg55(config_reg55),
.config_reg56(config_reg56),
.config_reg57(config_reg57),
.config_reg58(config_reg58),
.config_reg59(config_reg59),
.config_reg60(config_reg60),
.config_reg61(config_reg61),
.config_reg62(config_reg62),
.config_reg63(config_reg63),
.config_reg64(config_reg64),
.config_reg65(config_reg65),
.config_reg66(config_reg66),
.config_reg67(config_reg67),
.config_reg68(config_reg68),
.config_reg69(config_reg69),
.config_reg70(config_reg70),
.config_reg71(config_reg71),
.config_reg72(config_reg72),
.config_reg73(config_reg73),
.config_reg74(config_reg74),
.config_reg75(config_reg75),
.config_reg76(config_reg76),
.config_reg77(config_reg77),
.config_reg78(config_reg78),
.config_reg79(config_reg79),
.config_reg80(config_reg80),
.config_reg81(config_reg81),
.config_reg82(config_reg82),
.config_reg83(config_reg83),
.config_reg84(config_reg84),
.config_reg85(config_reg85),
.config_reg86(config_reg86),
.config_reg87(config_reg87),
.config_reg88(config_reg88),
.config_reg89(config_reg89),
.config_reg90(config_reg90),
.config_reg91(config_reg91),
.config_reg92(config_reg92),
.config_reg93(config_reg93),
.config_reg94(config_reg94),
.config_reg95(config_reg95),
.config_reg96(config_reg96),
.config_reg97(config_reg97),
.config_reg98(config_reg98),
.config_reg99(config_reg99),
.config_reg100(config_reg100),
.config_reg101(config_reg101),
.config_reg102(config_reg102),
.config_reg103(config_reg103),
.config_reg104(config_reg104),
.config_reg105(config_reg105),
.config_reg106(config_reg106),
.config_reg107(config_reg107),
.config_reg108(config_reg108),
.config_reg109(config_reg109),
.config_reg110(config_reg110),
.config_reg111(config_reg111),
.config_reg112(config_reg112),
.config_reg113(config_reg113),
.config_reg114(config_reg114),
.config_reg115(config_reg115),
.config_reg116(config_reg116),
.config_reg117(config_reg117),
.config_reg118(config_reg118),
.config_reg119(config_reg119),
.config_reg120(config_reg120),
.config_reg121(config_reg121),
.config_reg122(config_reg122),
.config_reg123(config_reg123),
.config_reg124(config_reg124),
.config_reg125(config_reg125),
.config_reg126(config_reg126),
.config_reg127(config_reg127)
);


// TOP_AER_ROI_BIAS top_aer_roi_bias1(
// .clk(clk_top),
// .rst(reset_n_int),
// .top_AER_data(top_AER_data),
// .top_AER_nreq(top_AER_nreq),
// .top_AER_nack(top_AER_nack),
// .top_burst_en(config_reg1[0]), 
// .top_burst_len(config_reg127[15:8]),              
// .top_frame_len(config_reg2[15:8]),              
// .top_us_cycle(config_reg2[7:0]),
// .top_altern(altern),
// .top_bias_program_enable(config_reg3[0]),// single register is kept for pulse generation
// .top_BiasAddrSel(top_BiasAddrSel),
// .top_BiasBitIN(top_BiasBitIN),
// .top_BiasClock(top_BiasClock),
// .top_BiasLatch(top_BiasLatch),
// .top_BiasDiagSel(top_BiasDiagSel),
// .top_bias_enable(config_reg1[1]),
// .top_bias_mem_0(config_reg4),
// .top_bias_mem_1(config_reg5),
// .top_bias_mem_2(config_reg6),
// .top_bias_mem_3(config_reg7),
// .top_bias_mem_4(config_reg8),
// .top_bias_mem_5(config_reg9),
// .top_bias_mem_6(config_reg10),
// .top_bias_mem_7(config_reg11),
// .top_bias_mem_8(config_reg12),
// .top_bias_mem_9(config_reg13),
// .top_bias_mem_10(config_reg14),
// .top_bias_mem_11(config_reg15),
// .top_bias_mem_12(config_reg16),
// .top_bias_mem_13(config_reg17),
// .top_bias_mem_14(config_reg18),
// .top_bias_mem_15(config_reg19),
// .top_bias_mem_16(config_reg20),
// .top_bias_mem_17(config_reg21),
// .top_bias_mem_18(config_reg22),
// .top_bias_mem_19(config_reg23),
// .top_bias_mem_20(config_reg24),
// .top_bias_mem_21(config_reg25),
// .top_bias_ready(top_bias_ready),
// .top_evt_out_valid(top_evt_out_valid),
// .top_evt_out_x(top_evt_out_x),
// .top_evt_out_y(top_evt_out_y),
// .top_evt_out_pol(top_evt_out_pol),
// .top_region_0({config_reg26,config_reg27,config_reg28,config_reg29}),
// .top_region_1({config_reg30,config_reg31,config_reg32,config_reg33}),
// .top_region_2({config_reg34,config_reg35,config_reg36,config_reg37}),
// .top_region_3({config_reg38,config_reg39,config_reg40,config_reg41}),
// .top_region_4({config_reg42,config_reg43,config_reg44,config_reg45}),
// .top_region_5({config_reg46,config_reg47,config_reg48,config_reg49}),
// .top_region_6({config_reg50,config_reg51,config_reg52,config_reg53}),
// .top_region_7({config_reg54,config_reg55,config_reg56,config_reg57})
// );

// ev_to_qvga_tsmc ev_to_qvga_tsmc1(
// .clk(clk_top),
// .rst(reset_n_int),
// .en(en_evt2frame),
// .burst_mode(config_reg1[0]),
// .altern(altern),
// .frame_len(config_reg2[15:8]),
// .frame_us(config_reg2[7:0]),
// .image_cols(config_reg1[10:2]),
// .image_rows(config_reg127[7:0]),
// .evt_valid(top_evt_out_valid),
// .evt_x(top_evt_out_x),
// .evt_y(top_evt_out_y),
// .evt_pol(top_evt_out_pol),
// .ready(ready_evtframe),
// .cnn_done(cnn_done_to_memory),
// .cnn_read_x(cnn_read_x),
// .cnn_read_y(cnn_read_y[7:0]),
// .cnn_read_valid(cnn_read_valid),
// .raw_data_pos(raw_data_pos),
// .raw_data_neg(raw_data_neg),
// .busy_frame(busy_frame),
// .overflow_read(overflow_read),
// .timer_error(timer_error),
// .top_en_dbg(config_reg117[12]),
// .top_addr_wr_dbg({config_reg66[15:8],config_reg67[12:4]}),
// .top_pos_wr_dbg(config_reg65[13:12]),
// .top_valid_wr_dbg(config_reg63[12]),
// .top_data_wr_dbg(top_data_wr_dbg),
// .top_addr_rd_dbg({config_reg61[15:8],config_reg62[12:4]}),
// .top_pos_rd_dbg(config_reg60[13:12]),
// .top_valid_rd_dbg(config_reg59[12]),
// .top_data_rd_dbg(top_data_rd_dbg)
// );

CNN_input_gen
#(
  .FILTERED_MEM_DELAY(2),
  .MAX_NUM_OBJ(16),
  .X_WIDTH(9),
  .Y_WIDTH(9),
  .CNN_W(42)
)
CNN_input_gen1(
.clk(clk_top),
.reset_n(reset_n_int),
.param_a(config_reg0), 
.param_b(config_reg106), 
.param_c(config_reg126), 
.region_rd_en(rgn_rd_en),
.region_done(rgn_done),
.region_bit_valid(rgn_bit_valid),
.region_x_bit(rgn_x_bit),
.region_y_bit(rgn_y_bit),
.region_clk(rgn_clk),
.dataIn_pos(raw_data_pos),
.dataIn_neg(raw_data_neg),
.xAddressOut(cnn_read_x),
.yAddressOut(cnn_read_y),
.cnn_done(cnn_done_to_memory),
.cnn_read_valid(cnn_read_valid),
.cnn_rd_done(done),
.cnn_ready(start_cnn),
.cnn_dout_ch0(img_pixel_ch1_cnn),
.cnn_dout_ch1(img_pixel_ch2_cnn),
.dbg_reg(config_reg110[15:8]), 
.dbg_dout_valid(dbg_dout_valid),
.dbg_dout(dbg_dout),
.ext_dataIn_pos(ext_dataIn_pos),
.ext_dataIn_neg(ext_dataIn_neg),
.ext_xAddressOut(ext_xAddressOut),
.ext_cnn_done(ext_cnn_done),
.ext_cnn_rd_done(ext_cnn_rd_done),
.ext_cnn_ready(ext_cnn_ready)
);



// small_lenet_tile_based_cnn small_lenet_tile_based_cnn1(
// .clk(clk_top),
// .reset(reset_p_int),
// .init(init),
// //input from CNN_input_gen.v 
// .start(start_cnn),
// .img_pixel_ch1(img_pixel_ch1_cnn),
// .img_pixel_ch2(img_pixel_ch2_cnn),
// .img_data_valid(1'b0),
// // Memory interface via SPI for two 16 depth x8  width memories for weigh
// .data_ina_wght_tab1(config_reg59[WEIGHT_WIDTH-1:0]),
// .data_ina_wght_tab2(config_reg60[WEIGHT_WIDTH-1:0]),
// .addra_wght_tab1(config_reg61[FLTR_PTR_SIZE-1:0]),
// .addra_wght_tab2(config_reg62[FLTR_PTR_SIZE-1:0]),
// .wea_wght_tab1(config_reg63_int2[0]),
// .wea_wght_tab2(config_reg64_intx2[0]),
// .ena_wght_tab1(config_reg63_int2[1]),
// .ena_wght_tab2(config_reg64_intx2[1]),
// .data_outa_wght_tab1(data_out11),
// .data_outa_wght_tab2(data_out12),
// // Memory interface via SPI for 512 depth x 4 width memory
// .addra_wght_ptr_1_2(config_reg65[KERNEL_PTR1_ADDR_WIDTH-1:0]),
// .data_ina_wght_ptr_1_2(config_reg66[FLTR_PTR_SIZE-1:0]),
// .wea_wght_ptr_1_2(config_reg67_int2[0]),
// .ena_wght_ptr_1_2(config_reg67_int2[1]),
// .data_outa_wght_ptr_1_2(data_out13),
// // Memory interface via SPI for five 64 depth x32 width memories
// .addra_wght_ptr3(addra_wght_ptr3),
// .data_ina_wght_ptr3(data_ina_wght_ptr3),
// .wea_wght_ptr3(wea_wght_ptr3),
// .ena_wght_ptr3(ena_wght_ptr3),
// .data_outa_wght_ptr3(data_outa_wght_ptr3),
// // SPI input to configure weights for FC layer
// .weight_table4(weight_table4),
// //SPI inputs to configure BIAS registers
// .bias_lyr1(bias_lyr1),
// .bias_lyr2(bias_lyr2),
// .bias_lyr3(bias_lyr3),
//  //SPI inputs for configuration of DFP registers
// .dfp_lyr1(config_reg117[DFP_WIDTH-1:0]),
// .dfp_lyr2(config_reg118[DFP_WIDTH-1:0]),
// .dfp_lyr3(config_reg119[DFP_WIDTH-1:0]),
// .dfp_bias_lyr1(config_reg120[DFP_WIDTH-1:0]),
// .dfp_bias_lyr2(config_reg121[DFP_WIDTH-1:0]),
// .dfp_bias_lyr3(config_reg122[DFP_WIDTH-1:0]),
// .dfp_out_lyr1(config_reg123[DFP_WIDTH-1:0]),
// .dfp_out_lyr2(config_reg124[DFP_WIDTH-1:0]),
// .dfp_out_lyr3(config_reg125[DFP_WIDTH-1:0]),
// // interface to the convolution aclerator
// // output via SPI
// .done(done),
// .conv_done1(conv_done1),
// .class_output(class_output),
// .cnn_state(cnn_state), 
// .lyr2_state(lyr2_state),
// .fc_read_state(fc_read_state),
// .valid_op1(valid_op1),
// .data_out1(data_out90),
// .fc_mac_en(fc_mac_en),
// .mat_mul_done(mat_mul_done),
// .ena_lyr2_pw(ena_lyr2_pw),
// .wea_lyr2_pw(wea_lyr2_pw),
// .enb_lyr2_pw(enb_lyr2_pw),
// .web_lyr2_pw(web_lyr2_pw),
// .addra_pw_surf_cnt(addra_pw_surf_cnt),
// .addrb_pw_surf_cnt(addrb_pw_surf_cnt),
// .data_ina_lyr2_pw(data_ina_lyr2_pw),
// .data_outa_lyr2_pw(data_outa_lyr2_pw),
// .data_inb_lyr2_pw(data_inb_lyr2_pw),
// .data_outb_lyr2_pw(data_outb_lyr2_pw),
// .lyr2_valid_op(lyr2_valid_op),
// .lyr2_end_op(lyr2_end_op),
// .valid_ip(valid_ip),
// .lyr2_relu_op(lyr2_relu_op),
// .lyr2_sat_in(lyr2_sat_in),
// .lyr2_data_out(lyr2_data_out),
// .mul_out(mul_out),
// .fc_cnt(fc_cnt),
// .fc_ptr(fc_ptr)
// );


reg [7:0] parallel_out_reg;

assign parallel_out1 = config_reg58_int2[15] ?  ~dbg_dout :  ~parallel_out_reg;
assign parallel_out = ~parallel_out1;
reg reg64_int1;
reg reg64_int2;

always @( posedge clk_top or negedge reset_n_int) begin
	if (!reset_n_int) begin
		reg64_int1 <= 1'b0;
		reg64_int2 <= 1'b0;
	end
	else begin
		reg64_int1 <= config_reg64[15];
		reg64_int2 <= reg64_int1;
	end
end

always @( posedge clk_top or negedge reset_n_int) begin
	if (!reset_n_int) begin
		config_reg58_int1 <= 16'd0;
		config_reg58_int2 <= 16'd0;
	end
	else begin
		config_reg58_int1 <= config_reg58;
		config_reg58_int2 <= config_reg58_int1;
	end
end


always @( posedge clk_top or negedge reset_n_int) begin
	if (!reset_n_int) begin
		class_output_reg[0] <= 32'd0;
		class_output_reg[1] <= 32'd0;
		class_output_reg[2] <= 32'd0;
		class_output_reg[3] <= 32'd0;
		class_output_reg[4] <= 32'd0;
	end
	else begin
		if (done | reg64_int2) begin
		class_output_reg[0] <= class_output[0];
		class_output_reg[1] <= class_output[1];
		class_output_reg[2] <= class_output[2];
		class_output_reg[3] <= class_output[3];
		class_output_reg[4] <= class_output[4];
		end
	end
end


always @( posedge clk_top or negedge reset_n_int) begin

	if (!reset_n_int) begin
		parallel_out_reg <= 8'd0;
	end
	else begin
	case (config_reg58_int2)
	
	16'd0:    parallel_out_reg <= data_out6[7:0];
	16'd1:    parallel_out_reg <= data_out6[15:8];
	16'd2:    parallel_out_reg <= data_out6[23:16];
	16'd3:    parallel_out_reg <= data_out6[31:24];
	16'd4:    parallel_out_reg <= data_out7[7:0];
	16'd5:    parallel_out_reg <= data_out7[15:8];
	16'd6:    parallel_out_reg <= data_out7[23:16];
	16'd7:    parallel_out_reg <= data_out7[31:24];
	16'd8:    parallel_out_reg <= data_out8[7:0];
	16'd9:    parallel_out_reg <= data_out8[15:8];
	16'd10:   parallel_out_reg <= data_out8[23:16];
	16'd11:   parallel_out_reg <= data_out8[31:24];
	16'd12:   parallel_out_reg <= data_out9[7:0];
	16'd13:   parallel_out_reg <= data_out9[15:8];
	16'd14:   parallel_out_reg <= data_out9[23:16];
	16'd15:   parallel_out_reg <= data_out9[31:24];
	16'd16:   parallel_out_reg <= data_out10[7:0];
	16'd17:   parallel_out_reg <= data_out10[15:8];
	16'd18:   parallel_out_reg <= data_out10[23:16];
	16'd19:   parallel_out_reg <= data_out10[31:24];
	16'd20:   parallel_out_reg <= data_out1[7:0];
	16'd21:   parallel_out_reg <= data_out1[15:8];
	16'd22:   parallel_out_reg <= data_out1[23:16];
	16'd23:   parallel_out_reg <= data_out1[31:24];
	16'd24:   parallel_out_reg <= data_out2[7:0];
	16'd25:   parallel_out_reg <= data_out2[15:8];
	16'd26:   parallel_out_reg <= data_out2[23:16];
	16'd27:   parallel_out_reg <= data_out2[31:24];
	16'd28:   parallel_out_reg <= data_out3[7:0];
	16'd29:   parallel_out_reg <= data_out3[15:8];
	16'd30:   parallel_out_reg <= data_out3[23:16];
	16'd31:   parallel_out_reg <= data_out3[31:24];
	16'd32:   parallel_out_reg <= data_out4[7:0];
	16'd33:   parallel_out_reg <= data_out4[15:8];
	16'd34:   parallel_out_reg <= data_out4[23:16];
	16'd35:   parallel_out_reg <= data_out4[31:24];
	16'd36:   parallel_out_reg <= data_out5[7:0];
	16'd37:   parallel_out_reg <= data_out5[15:8];
	16'd38:   parallel_out_reg <= data_out5[23:16];
	16'd39:   parallel_out_reg <= data_out5[31:24];
	16'd40:   parallel_out_reg <= data_out11;
	16'd41:   parallel_out_reg <= data_out12;
	16'd42:   parallel_out_reg <= {data_out13,data_out13};
///////////////////////////////////////////////////////////////
	16'd43:   parallel_out_reg <= {3'b000,ena_lyr2_pw[4],ena_lyr2_pw[3],ena_lyr2_pw[2],ena_lyr2_pw[1],ena_lyr2_pw[0]};
	16'd44:   parallel_out_reg <= {3'b000,wea_lyr2_pw[4],wea_lyr2_pw[3],wea_lyr2_pw[2],wea_lyr2_pw[1],wea_lyr2_pw[0]};
	16'd45:   parallel_out_reg <= {3'b000,enb_lyr2_pw[4],enb_lyr2_pw[3],enb_lyr2_pw[2],enb_lyr2_pw[1],enb_lyr2_pw[0]};
	16'd46:   parallel_out_reg <= {3'b000,web_lyr2_pw[4],web_lyr2_pw[3],web_lyr2_pw[2],web_lyr2_pw[1],web_lyr2_pw[0]};
	16'd47:   parallel_out_reg <= data_out14;
	16'd48:   parallel_out_reg <= data_out15;
	16'd49:   parallel_out_reg <= data_out16;
	16'd50:   parallel_out_reg <= data_out17;
	16'd51:   parallel_out_reg <= data_out18;
	16'd52:   parallel_out_reg <= data_out19;
	16'd53:   parallel_out_reg <= data_out20;
	16'd54:   parallel_out_reg <= data_out21;
	16'd55:   parallel_out_reg <= data_out22;
	16'd56:   parallel_out_reg <= data_out23;
//////////////////////////////////////////////////////////////////
	16'd57:   parallel_out_reg <= data_out24[7:0];
	16'd58:   parallel_out_reg <= data_out24[15:8];
	16'd59:   parallel_out_reg <= data_out24[23:16];
	16'd60:   parallel_out_reg <= data_out24[31:24];

	16'd61:   parallel_out_reg <= data_out25[7:0];
	16'd62:   parallel_out_reg <= data_out25[15:8];
	16'd63:   parallel_out_reg <= data_out25[23:16];
	16'd64:   parallel_out_reg <= data_out25[31:24];

	16'd65:   parallel_out_reg <= data_out26[7:0];
	16'd66:   parallel_out_reg <= data_out26[15:8];
	16'd67:   parallel_out_reg <= data_out26[23:16];
	16'd68:   parallel_out_reg <= data_out26[31:24];
	
	16'd69:   parallel_out_reg <= data_out27[7:0];
	16'd70:   parallel_out_reg <= data_out27[15:8];
	16'd71:   parallel_out_reg <= data_out27[23:16];
	16'd72:   parallel_out_reg <= data_out27[31:24];

	16'd73:   parallel_out_reg <= data_out28[7:0];
	16'd74:   parallel_out_reg <= data_out28[15:8];
	16'd75:   parallel_out_reg <= data_out28[23:16];
	16'd76:   parallel_out_reg <= data_out28[31:24];
////////////////////////////////////////////////////////////////////
	16'd77:   parallel_out_reg <= data_out29[7:0];
	16'd78:   parallel_out_reg <= data_out29[15:8];
	16'd79:   parallel_out_reg <= data_out29[23:16];
	16'd80:   parallel_out_reg <= data_out29[31:24];

	16'd81:   parallel_out_reg <= data_out30[7:0];
	16'd82:   parallel_out_reg <= data_out30[15:8];
	16'd83:   parallel_out_reg <= data_out30[23:16];
	16'd84:   parallel_out_reg <= data_out30[31:24];

	16'd85:   parallel_out_reg <= data_out31[7:0];
	16'd86:   parallel_out_reg <= data_out31[15:8];
	16'd87:   parallel_out_reg <= data_out31[23:16];
	16'd88:   parallel_out_reg <= data_out31[31:24];
	
	16'd89:   parallel_out_reg <= data_out32[7:0];
	16'd90:   parallel_out_reg <= data_out32[15:8];
	16'd91:   parallel_out_reg <= data_out32[23:16];
	16'd92:   parallel_out_reg <= data_out32[31:24];

	16'd93:   parallel_out_reg <= data_out33[7:0];
	16'd94:   parallel_out_reg <= data_out33[15:8];
	16'd95:   parallel_out_reg <= data_out33[23:16];
	16'd96:   parallel_out_reg <= data_out33[31:24];

////////////////////////////////////////////////////////////////////
	16'd97:   parallel_out_reg <= data_out34[7:0];
	16'd98:   parallel_out_reg <= data_out34[15:8];
	16'd99:   parallel_out_reg <= data_out34[23:16];
	16'd100:   parallel_out_reg <= data_out34[31:24];

	16'd101:   parallel_out_reg <= data_out35[7:0];
	16'd102:   parallel_out_reg <= data_out35[15:8];
	16'd103:   parallel_out_reg <= data_out35[23:16];
	16'd104:   parallel_out_reg <= data_out35[31:24];

	16'd105:   parallel_out_reg <= data_out36[7:0];
	16'd106:   parallel_out_reg <= data_out36[15:8];
	16'd107:   parallel_out_reg <= data_out36[23:16];
	16'd108:   parallel_out_reg <= data_out36[31:24];
	
	16'd109:   parallel_out_reg <= data_out37[7:0];
	16'd110:   parallel_out_reg <= data_out37[15:8];
	16'd111:   parallel_out_reg <= data_out37[23:16];
	16'd112:   parallel_out_reg <= data_out37[31:24];

	16'd113:   parallel_out_reg <= data_out38[7:0];
	16'd114:   parallel_out_reg <= data_out38[15:8];
	16'd115:   parallel_out_reg <= data_out38[23:16];
	16'd116:   parallel_out_reg <= data_out38[31:24];

////////////////////////////////////////////////////////////////////
	16'd117:   parallel_out_reg <= data_out39[7:0];
	16'd118:   parallel_out_reg <= data_out39[15:8];
	16'd119:   parallel_out_reg <= data_out39[23:16];
	16'd120:   parallel_out_reg <= data_out39[31:24];

	16'd121:   parallel_out_reg <= data_out40[7:0];
	16'd122:   parallel_out_reg <= data_out40[15:8];
	16'd123:   parallel_out_reg <= data_out40[23:16];
	16'd124:   parallel_out_reg <= data_out40[31:24];

	16'd125:   parallel_out_reg <= data_out41[7:0];
	16'd126:   parallel_out_reg <= data_out41[15:8];
	16'd127:   parallel_out_reg <= data_out41[23:16];
	16'd128:   parallel_out_reg <= data_out41[31:24];
	
	16'd129:   parallel_out_reg <= data_out42[7:0];
	16'd130:   parallel_out_reg <= data_out42[15:8];
	16'd131:   parallel_out_reg <= data_out42[23:16];
	16'd132:   parallel_out_reg <= data_out42[31:24];

	16'd133:   parallel_out_reg <= data_out43[7:0];
	16'd134:   parallel_out_reg <= data_out43[15:8];
	16'd135:   parallel_out_reg <= data_out43[23:16];
	16'd136:   parallel_out_reg <= data_out43[31:24];
/////////////////////////////////////////////////////////////////////
	16'd137:   parallel_out_reg <= {3'b000,lyr2_valid_op};
	16'd138:   parallel_out_reg <= {3'b000,lyr2_end_op};
	16'd139:   parallel_out_reg <= {3'b000,valid_ip};
////////////////////////////////////////////////////////////////////
	16'd140:   parallel_out_reg <= data_out44[7:0];
	16'd141:   parallel_out_reg <= data_out44[15:8];
	16'd142:   parallel_out_reg <= data_out44[23:16];
	16'd143:   parallel_out_reg <= data_out44[31:24];

	16'd144:   parallel_out_reg <= data_out45[7:0];
	16'd145:   parallel_out_reg <= data_out45[15:8];
	16'd146:   parallel_out_reg <= data_out45[23:16];
	16'd147:   parallel_out_reg <= data_out45[31:24];

	16'd148:   parallel_out_reg <= data_out46[7:0];
	16'd149:   parallel_out_reg <= data_out46[15:8];
	16'd150:   parallel_out_reg <= data_out46[23:16];
	16'd151:   parallel_out_reg <= data_out46[31:24];
	
	16'd152:   parallel_out_reg <= data_out47[7:0];
	16'd153:   parallel_out_reg <= data_out47[15:8];
	16'd154:   parallel_out_reg <= data_out47[23:16];
	16'd155:   parallel_out_reg <= data_out47[31:24];

	16'd156:   parallel_out_reg <= data_out48[7:0];
	16'd157:   parallel_out_reg <= data_out48[15:8];
	16'd158:   parallel_out_reg <= data_out48[23:16];
	16'd159:   parallel_out_reg <= data_out48[31:24];
////////////////////////////////////////////////////////////////////
	16'd160:   parallel_out_reg <= data_out49[7:0];
	16'd161:   parallel_out_reg <= data_out49[15:8];
	16'd162:   parallel_out_reg <= data_out49[23:16];
	16'd163:   parallel_out_reg <= data_out49[31:24];

	16'd164:   parallel_out_reg <= data_out50[7:0];
	16'd165:   parallel_out_reg <= data_out50[15:8];
	16'd166:   parallel_out_reg <= data_out50[23:16];
	16'd167:   parallel_out_reg <= data_out50[31:24];

	16'd168:   parallel_out_reg <= data_out51[7:0];
	16'd169:   parallel_out_reg <= data_out51[15:8];
	16'd170:   parallel_out_reg <= data_out51[23:16];
	16'd171:   parallel_out_reg <= data_out51[31:24];
	
	16'd172:   parallel_out_reg <= data_out52[7:0];
	16'd173:   parallel_out_reg <= data_out52[15:8];
	16'd174:   parallel_out_reg <= data_out52[23:16];
	16'd175:   parallel_out_reg <= data_out52[31:24];

	16'd176:   parallel_out_reg <= data_out53[7:0];
	16'd177:   parallel_out_reg <= data_out53[15:8];
	16'd178:   parallel_out_reg <= data_out53[23:16];
	16'd179:   parallel_out_reg <= data_out53[31:24];
/////////////////////////////////////////////////////////////////////
	16'd180:   parallel_out_reg <= data_out54;
	16'd181:   parallel_out_reg <= data_out55;
	16'd182:   parallel_out_reg <= data_out56;
	16'd183:   parallel_out_reg <= data_out57;
	16'd184:   parallel_out_reg <= data_out58;
////////////////////////////////////////////////////////////////////
	16'd190:   parallel_out_reg <= data_out60[7:0];
	16'd191:   parallel_out_reg <= data_out60[15:8];
	16'd192:   parallel_out_reg <= data_out60[23:16];
	16'd193:   parallel_out_reg <= data_out60[31:24];

	16'd194:   parallel_out_reg <= data_out61[7:0];
	16'd195:   parallel_out_reg <= data_out61[15:8];
	16'd196:   parallel_out_reg <= data_out61[23:16];
	16'd197:   parallel_out_reg <= data_out61[31:24];

	16'd198:   parallel_out_reg <= data_out62[7:0];
	16'd199:   parallel_out_reg <= data_out62[15:8];
	16'd200:   parallel_out_reg <= data_out62[23:16];
	16'd201:   parallel_out_reg <= data_out62[31:24];
	
	16'd202:   parallel_out_reg <= data_out63[7:0];
	16'd203:   parallel_out_reg <= data_out63[15:8];
	16'd204:   parallel_out_reg <= data_out63[23:16];
	16'd205:   parallel_out_reg <= data_out63[31:24];

	16'd206:   parallel_out_reg <= data_out64[7:0];
	16'd207:   parallel_out_reg <= data_out64[15:8];
	16'd208:   parallel_out_reg <= data_out64[23:16];
	16'd209:   parallel_out_reg <= data_out64[31:24];

////////////////////////////////////////////////////////////////////
	16'd210:   parallel_out_reg <= data_out65[7:0];
	16'd211:   parallel_out_reg <= data_out65[15:8];
	16'd212:   parallel_out_reg <= data_out65[23:16];
	16'd213:   parallel_out_reg <= data_out65[31:24];

	16'd214:   parallel_out_reg <= data_out66[7:0];
	16'd215:   parallel_out_reg <= data_out66[15:8];
	16'd216:   parallel_out_reg <= data_out66[23:16];
	16'd217:   parallel_out_reg <= data_out66[31:24];

	16'd218:   parallel_out_reg <= data_out67[7:0];
	16'd219:   parallel_out_reg <= data_out67[15:8];
	16'd220:   parallel_out_reg <= data_out67[23:16];
	16'd221:   parallel_out_reg <= data_out67[31:24];
	
	16'd222:   parallel_out_reg <= data_out68[7:0];
	16'd223:   parallel_out_reg <= data_out68[15:8];
	16'd224:   parallel_out_reg <= data_out68[23:16];
	16'd225:   parallel_out_reg <= data_out68[31:24];

	16'd226:   parallel_out_reg <= data_out69[7:0];
	16'd227:   parallel_out_reg <= data_out69[15:8];
	16'd228:   parallel_out_reg <= data_out69[23:16];
	16'd229:   parallel_out_reg <= data_out69[31:24];


////////////////////////////////////////////////////////////////////
	16'd230:   parallel_out_reg <= data_out70[7:0];
	16'd231:   parallel_out_reg <= data_out70[15:8];
	16'd232:   parallel_out_reg <= data_out70[23:16];
	16'd233:   parallel_out_reg <= data_out70[31:24];

	16'd234:   parallel_out_reg <= data_out71[7:0];
	16'd235:   parallel_out_reg <= data_out71[15:8];
	16'd236:   parallel_out_reg <= data_out71[23:16];
	16'd237:   parallel_out_reg <= data_out71[31:24];

	16'd238:   parallel_out_reg <= data_out72[7:0];
	16'd239:   parallel_out_reg <= data_out72[15:8];
	16'd240:   parallel_out_reg <= data_out72[23:16];
	16'd241:   parallel_out_reg <= data_out72[31:24];
	
	16'd242:   parallel_out_reg <= data_out73[7:0];
	16'd243:   parallel_out_reg <= data_out73[15:8];
	16'd244:   parallel_out_reg <= data_out73[23:16];
	16'd245:   parallel_out_reg <= data_out73[31:24];

	16'd246:   parallel_out_reg <= data_out74[7:0];
	16'd247:   parallel_out_reg <= data_out74[15:8];
	16'd248:   parallel_out_reg <= data_out74[23:16];
	16'd249:   parallel_out_reg <= data_out74[31:24];

///////////////////////////////////////////////7////////////////////
	16'd250:   parallel_out_reg <= data_out75[7:0];
	16'd251:   parallel_out_reg <= data_out75[15:8];
	16'd252:   parallel_out_reg <= data_out75[23:16];
	16'd253:   parallel_out_reg <= data_out75[31:24];

	16'd254:   parallel_out_reg <= data_out76[7:0];
	16'd255:   parallel_out_reg <= data_out76[15:8];
	16'd256:   parallel_out_reg <= data_out76[23:16];
	16'd257:   parallel_out_reg <= data_out76[31:24];

	16'd258:   parallel_out_reg <= data_out77[7:0];
	16'd259:   parallel_out_reg <= data_out77[15:8];
	16'd260:   parallel_out_reg <= data_out77[23:16];
	16'd261:   parallel_out_reg <= data_out77[31:24];
	
	16'd262:   parallel_out_reg <= data_out78[7:0];
	16'd263:   parallel_out_reg <= data_out78[15:8];
	16'd264:   parallel_out_reg <= data_out78[23:16];
	16'd265:   parallel_out_reg <= data_out78[31:24];

	16'd266:   parallel_out_reg <= data_out79[7:0];
	16'd267:   parallel_out_reg <= data_out79[15:8];
	16'd268:   parallel_out_reg <= data_out79[23:16];
	16'd269:   parallel_out_reg <= data_out79[31:24];
////////////////////////////////////////////////////////////////////
	16'd270:   parallel_out_reg <= data_out80[7:0];
	16'd271:   parallel_out_reg <= data_out80[15:8];
	16'd272:   parallel_out_reg <= data_out80[23:16];
	16'd273:   parallel_out_reg <= data_out80[31:24];

	16'd274:   parallel_out_reg <= data_out81[7:0];
	16'd275:   parallel_out_reg <= data_out81[15:8];
	16'd276:   parallel_out_reg <= data_out81[23:16];
	16'd277:   parallel_out_reg <= data_out81[31:24];

	16'd278:   parallel_out_reg <= data_out82[7:0];
	16'd279:   parallel_out_reg <= data_out82[15:8];
	16'd280:   parallel_out_reg <= data_out82[23:16];
	16'd281:   parallel_out_reg <= data_out82[31:24];
	
	16'd282:   parallel_out_reg <= data_out83[7:0];
	16'd283:   parallel_out_reg <= data_out83[15:8];
	16'd284:   parallel_out_reg <= data_out83[23:16];
	16'd285:   parallel_out_reg <= data_out83[31:24];

	16'd286:   parallel_out_reg <= data_out84[7:0];
	16'd287:   parallel_out_reg <= data_out84[15:8];
	16'd288:   parallel_out_reg <= data_out84[23:16];
	16'd289:   parallel_out_reg <= data_out84[31:24];
///////////////////////////////////////////////7////////////////////
	16'd290:   parallel_out_reg <= data_out85[7:0];
	16'd291:   parallel_out_reg <= data_out85[15:8];
	16'd292:   parallel_out_reg <= data_out85[23:16];
	16'd293:   parallel_out_reg <= data_out85[31:24];

	16'd294:   parallel_out_reg <= data_out86[7:0];
	16'd295:   parallel_out_reg <= data_out86[15:8];
	16'd296:   parallel_out_reg <= data_out86[23:16];
	16'd297:   parallel_out_reg <= data_out86[31:24];

	16'd298:   parallel_out_reg <= data_out87[7:0];
	16'd299:   parallel_out_reg <= data_out87[15:8];
	16'd300:   parallel_out_reg <= data_out87[23:16];
	16'd301:   parallel_out_reg <= data_out87[31:24];
	
	16'd302:   parallel_out_reg <= data_out88[7:0];
	16'd303:   parallel_out_reg <= data_out88[15:8];
	16'd304:   parallel_out_reg <= data_out88[23:16];
	16'd305:   parallel_out_reg <= data_out88[31:24];

	16'd306:   parallel_out_reg <= data_out89[7:0];
	16'd307:   parallel_out_reg <= data_out89[15:8];
	16'd308:   parallel_out_reg <= data_out89[23:16];
	16'd309:   parallel_out_reg <= data_out89[31:24];
/////////////////////////////////////////////////////////////
	16'd310:   parallel_out_reg <= {2'b00,fc_cnt};
	16'd311:   parallel_out_reg <= data_out90;
	16'd312:   parallel_out_reg <= {3'b000,ready_evtframe,busy_frame,overflow_read,timer_error,top_bias_ready};
	16'd313:   parallel_out_reg <= {2'b00,mat_mul_done,fc_mac_en,valid_op1,fc_read_state};
	16'd314:   parallel_out_reg <= {lyr2_state,cnn_state};
	16'd315:   parallel_out_reg <= {4'b0000,top_data_wr_dbg,top_data_rd_dbg};
	default:      parallel_out_reg <= 8'd85;
   endcase
end
end

endmodule
