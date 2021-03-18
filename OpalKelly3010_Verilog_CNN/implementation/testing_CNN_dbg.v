`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2020 10:55:44 AM
// Design Name: 
// Module Name: 
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


module testing_CNN_dbg
#(
    parameter SIM               = 0,
    parameter X_LENGTH          = 320,
    parameter Y_DEPTH           = 240,
    parameter X_ADDR_WIDTH      = 9,
    parameter Y_ADDR_WIDTH      = 8
)
(
// pins needed for opal kelly interfaces
    input  wire [7:0]  hi_in,
    output wire [1:0]  hi_out,
    inout  wire [15:0] hi_inout,
    output wire        i2c_sda,
    output wire        i2c_scl,
    output wire        hi_muxsel,
// led displaying
    output wire [7:0]  led,
// clock from PLL
    input  wire sys_clk1,
    input  wire sys_clk2,
// teesting PIN
    output wire test_clk,
    output wire test2,
    output wire test3,
// output signals (to testing chip)
    // to reset_synchronizer
    output wire clk_top,
    output wire reset_n,
    // to SPI
    output wire clk_phase1,
    output wire clk_phase2,
    output wire clk_update,
    output wire capture,
    output wire spi_din,
    // to CNN_input_gen
    output wire rgn_done,
    output wire rgn_bit_valid,
    output wire rgn_x_bit,
    output wire rgn_y_bit,
    output wire rgn_clk,
    output wire ext_dataIn_pos,
    output wire ext_dataIn_neg,
    output wire ext_cnn_rd_done,
    // to AER
    output wire top_AER_nreq,
    output wire [9:0] top_AER_data,
    output wire en_evt2frame,
    // to CNN
    output wire init,
// input signals (from testing chip)
    // from reset_synchronizer
    input wire rst_n_sync,
    // from top level
    input wire [7:0] parallel_out,
    // from CNN_input_gen
    input wire rgn_rd_en,
    input wire [8:0] ext_xAddressOut,
    input wire ext_cnn_done,
    input wire ext_cnn_ready,
    input wire dbg_dout_valid,
    // from AER
    input wire top_AER_nack,
    input wire top_BiasAddrSel,
    input wire top_BiasDiagSel,
    input wire top_BiasBitIN,
    input wire top_BiasClock,
    input wire top_BiasLatch,
    // from CNN
    input wire done,
    input wire conv_done1,
    // from SPI
    input wire spi_out
    );



//////////////////////////////////////////////////////////////////
// opall kell interface bus:
wire        ti_clk; //48 MHz from okHost
wire [30:0] ok1;
wire [16:0] ok2;

assign i2c_sda = 1'bz;
assign i2c_scl = 1'bz;
assign hi_muxsel = 1'b0;

// Endpoint connections:
wire [15:0]     wi00_data;
wire [15:0]     wi01_data;
wire [15:0]     wi02_data;
wire [15:0]     wi03_data;
wire [15:0]     wi04_data;
wire [15:0]     wi05_data;
wire [15:0]     wi06_data;
wire [15:0]     wi07_data;
wire [15:0]     wi08_data;

wire [15:0]     wo20_data;
wire [15:0]     wo21_data;
wire [15:0]     wo22_data;

wire [15:0]     ti40_trig;
wire [15:0]     ti41_trig;

wire [15:0]     to60_trig;
reg  [15:0]     to61_trig;

wire            pi80_write;
wire            pi81_write;
wire            pi82_write;
wire            pi83_write;

wire [15:0]     pi80_data;
wire [15:0]     pi81_data;
wire [15:0]     pi82_data;
wire [15:0]     pi83_data;

wire            poa0_read;
wire            poa1_read;
wire            poa2_read;
wire            poa3_read;
wire            poa4_read;
wire            poa5_read;

wire [15:0]     poa0_data;
wire [15:0]     poa1_data;
wire [15:0]     poa2_data;
wire [15:0]     poa3_data;
wire [15:0]     poa4_data;
wire [15:0]     poa5_data;


reg [15:0] wo20_datareg;
wire clk;
wire clk_div;
wire clk_div1;
wire clk_div2;
//-----------------------------------------------------------OPAL KELLY INTERFACE-----------------------------------------------------
//--#### Endpoint Types:
//--#### Endpoint Type  |  Address Range  |  Sync/Async   |  Data Type
//--####   Wire In          0x00 - 0x1F      Asynchronous    Signal state
//--####   Wire Out         0x20 - 0x3F      Asynchronous    Signal state
//--####   Trigger In       0x40 - 0x5F      Synchronous     One-shot
//--####   Trigger Out      0x60 - 0x7F      Synchronous     One-shot
//--####   Pipe In          0x80 - 0x9F      Synchronous     Multi-byte transfer
//--####   Pipe Out         0xA0 - 0xBF      Synchronous     Multi-byte transfer
/****top-level module for FrontPanel-enabled USB 2.0 devices***/
// Instantiate the okHost and connect endpoints.
wire [15*17-1:0]  ok2x; // Adjust size of ok2x to fit the number of outgoing FrontPanel endpoints in your design [n*17-1:0]
okWireOR # (.N(15)) wireOR (ok2, ok2x);// Adjust N to fit the number of outgoing FrontPanel endpoints in your design (.N(n))
okHost okHI(
    .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .ti_clk(ti_clk),
    .ok1(ok1), .ok2(ok2)); //Host interfaces directly with FPGA pins

//Opal Kelly communicates with host PC 
okWireIn     ep00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(wi00_data));
okWireIn     ep01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(wi01_data));
okWireIn     ep02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(wi02_data));
okWireIn     ep03 (.ok1(ok1),                           .ep_addr(8'h03), .ep_dataout(wi03_data));
okWireIn     ep04 (.ok1(ok1),                           .ep_addr(8'h04), .ep_dataout(wi04_data));
okWireIn     ep05 (.ok1(ok1),                           .ep_addr(8'h05), .ep_dataout(wi05_data));
okWireIn     ep06 (.ok1(ok1),                           .ep_addr(8'h06), .ep_dataout(wi06_data));
okWireIn     ep07 (.ok1(ok1),                           .ep_addr(8'h07), .ep_dataout(wi07_data));
okWireIn     ep08 (.ok1(ok1),                           .ep_addr(8'h08), .ep_dataout(wi08_data));
okWireOut    ep20 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(wo20_data));
okWireOut    ep21 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h21), .ep_datain(wo21_data));
okWireOut    ep22 (.ok1(ok1), .ok2(ok2x[ 2*17 +: 17 ]), .ep_addr(8'h22), .ep_datain(wo22_data));
okTriggerIn  ep40 (.ok1(ok1),                           .ep_addr(8'h40), .ep_clk(ti_clk), .ep_trigger(ti40_trig));
okTriggerIn  ep41 (.ok1(ok1),                           .ep_addr(8'h41), .ep_clk(clk_div), .ep_trigger(ti41_trig));
okTriggerOut ep60 (.ok1(ok1), .ok2(ok2x[ 3*17 +: 17 ]), .ep_addr(8'h60), .ep_clk(clk_div), .ep_trigger(to60_trig));
okTriggerOut ep61 (.ok1(ok1), .ok2(ok2x[ 4*17 +: 17 ]), .ep_addr(8'h61), .ep_clk(ti_clk), .ep_trigger(to61_trig));
okPipeIn     ep80 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'h80), .ep_write(pi80_write), .ep_dataout(pi80_data));
okPipeIn     ep81 (.ok1(ok1), .ok2(ok2x[ 6*17 +: 17 ]), .ep_addr(8'h81), .ep_write(pi81_write), .ep_dataout(pi81_data));
okPipeIn     ep82 (.ok1(ok1), .ok2(ok2x[ 7*17 +: 17 ]), .ep_addr(8'h82), .ep_write(pi82_write), .ep_dataout(pi82_data));
okPipeIn     ep83 (.ok1(ok1), .ok2(ok2x[ 8*17 +: 17 ]), .ep_addr(8'h83), .ep_write(pi83_write), .ep_dataout(pi83_data));
okPipeOut    epa0 (.ok1(ok1), .ok2(ok2x[ 9*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(poa0_read), .ep_datain(poa0_data));
okPipeOut    epa1 (.ok1(ok1), .ok2(ok2x[10*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(poa1_read), .ep_datain(poa1_data));
okPipeOut    epa2 (.ok1(ok1), .ok2(ok2x[11*17 +: 17 ]), .ep_addr(8'ha2), .ep_read(poa2_read), .ep_datain(poa2_data));
okPipeOut    epa3 (.ok1(ok1), .ok2(ok2x[12*17 +: 17 ]), .ep_addr(8'ha3), .ep_read(poa3_read), .ep_datain(poa3_data));
okPipeOut    epa4 (.ok1(ok1), .ok2(ok2x[13*17 +: 17 ]), .ep_addr(8'ha4), .ep_read(poa4_read), .ep_datain(poa4_data));
okPipeOut    epa5 (.ok1(ok1), .ok2(ok2x[14*17 +: 17 ]), .ep_addr(8'ha5), .ep_read(poa5_read), .ep_datain(poa5_data));
//-----------------------------------------------------------OPAL KELLY INTERFACE-----------------------------------------------------






assign led = wi00_data[7:0];

wire reset;
wire reset_new;
wire clk_scale1, clk_scale2;
wire [15:0] clk_dividor1, clk_dividor2;
assign clk_scale1    = wi02_data[0];
assign clk_dividor1  = {wi02_data[15:1],1'b0};
assign clk_scale2    = wi04_data[0];
assign clk_dividor2  = {wi04_data[15:1],1'b0};
////notice: the memory IP is driven by single clk (ti_clk). Change the IP if use scaling frequency.
// assign clk = sys_clk2;
assign clk = clk_div2;
// assign clk = ti_clk; 
//assign clk_top = clk;
assign reset = wi00_data[0];
assign reset_new = reset;
assign reset_n = ~reset;

wire [15:0] div, div1, div2;
assign div  = SIM==1 ? 2 : clk_scale1 ? clk_dividor1 : 20;
assign div1 = div >> 1;
assign div2 = SIM==1 ? 2 : clk_scale2 ? clk_dividor2 : 2;
    clock_divider clk_div_u0
    (
    .DIVISOR    (div),
    .clock_in   (sys_clk1),
    .clock_out  (clk_div)
    );
    clock_divider clk_div_u1
    (
    .DIVISOR    (div1),
    .clock_in   (sys_clk1),
    .clock_out  (clk_div1)
    );

    clock_divider clk_div_u2
    (
    .DIVISOR    (div2),
    .clock_in   (sys_clk1),
    .clock_out  (clk_div2)
    );



assign en_evt2frame = wi00_data[2];
assign aer_en = wi00_data[4];
assign burst_mode = wi00_data[7];
wire [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] addr;
wire data_update; //start feed into chip
//assign data_update = wi00_data[3];//would get stuck when run a loop [Matlab-OpalKelly connetion issue]
wire config_done;
assign config_done = wi00_data[5];
//// clock gating
reg clk_en;
reg frame_en;
reg classify_done; //generated by clk_div
always @(posedge ti_clk or posedge reset) begin //ti_clk is stable for MATLAB loop
    if (reset) begin
        clk_en <= 1;
        frame_en <= 0;
    end
    else begin
        if (data_update) begin
            clk_en <= 1;
            frame_en <= 1;
        end
        else if (config_done || classify_done) begin
            clk_en <= 0;
            frame_en <= 0;
        end
    end
end
// assign clk_top = clk;
// assign clk_top = clk && clk_en;
assign clk_top = clk && (clk_en || ~wi00_data[6]);

//// busy_frame generation locally
wire [7:0] frame_len, frame_us;
wire [15:0] frame_ms;
wire [31:0] frame_period;
assign frame_len = wi07_data[15:8];
assign frame_us  = wi07_data[7:0];
assign frame_ms  = frame_us * 16'd1000;
assign frame_period = frame_len * frame_ms;
reg [31:0] frame_timer;
reg timer_advance;
reg busy_frame_local;
always @(posedge clk_top or posedge reset) begin
    if (reset) begin
        frame_timer <= 0;
        timer_advance <= 0;
        busy_frame_local <= 0;
    end
    else if (frame_en) begin
        if (frame_timer<frame_period) begin
            frame_timer <= frame_timer + 1;
            timer_advance <= 0;
        end
        else begin
            timer_advance <= 1;
            frame_timer <= 0;
        end
        busy_frame_local <= timer_advance ? ~busy_frame_local : busy_frame_local;
    end
end

//// get busy_frame signal from parallel_out
reg aer_feedin, rp_feedin;
reg [3:0] cnt_frame;
reg probe_busy_frame;
wire busy_frame, busy_frame_chip;
assign busy_frame_chip = parallel_out[3] && probe_busy_frame;
assign busy_frame = busy_frame_local;
// assign busy_frame = busy_frame_chip;
reg busy_frame_delay;
wire frame_rising, frame_falling, frame_edge;
assign frame_rising = busy_frame && (~busy_frame_delay);
assign frame_falling= (~busy_frame) && busy_frame_delay;
assign frame_edge   = frame_rising || frame_falling;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        busy_frame_delay <= 0;
    end
    else begin
        busy_frame_delay <= busy_frame;
    end
end

//// FSM to feed image and region to CNN
reg [3:0] state_feedin;
localparam [3:0] S_FEEDIN_IDLE = 0, S_FEEDIN_START = 1, S_FEEDIN_IMG = 2, S_FEEDIN_RGN = 3, S_FEEDIN_WAIT = 4;
reg img_update, rgn_update;
reg [4:0] cnt_feedin_rgn;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        img_update <= 0;
        rgn_update <= 0;
        cnt_frame  <= 0;
        cnt_feedin_rgn <= 0;
        state_feedin <= S_FEEDIN_IDLE;
    end
    else begin
        case (state_feedin)
            S_FEEDIN_IDLE : begin
                img_update <= 0;
                rgn_update <= 0;
                cnt_frame  <= 0;
                cnt_feedin_rgn <= 0;
                if (data_update) begin
                    state_feedin <= S_FEEDIN_START;
                end
                else begin
                    state_feedin <= S_FEEDIN_IDLE;
                end
            end
            S_FEEDIN_START : begin
                cnt_frame <= (frame_edge) ? cnt_frame + 1 : cnt_frame;
                if (burst_mode) begin
                    if (cnt_frame == 4) begin
                        state_feedin <= S_FEEDIN_IMG;
                        img_update <= 1;
                    end
                end
                else if (cnt_frame == 3) begin
                    state_feedin <= S_FEEDIN_IMG;
                    img_update <= 1;
                end
            end
            S_FEEDIN_IMG : begin
                img_update <= 0;
                cnt_frame <= (frame_edge) ? cnt_frame + 1 : cnt_frame;
                if (burst_mode) begin
                    if (cnt_frame == 5) begin
                        state_feedin <= S_FEEDIN_RGN;
                        rgn_update <= 1;
                    end
                end
                else if (cnt_frame == 4) begin
                    state_feedin <= S_FEEDIN_RGN;
                    rgn_update <= 1;
                end
            end
            S_FEEDIN_RGN : begin
                //rgn_update <= 0;
                state_feedin <= S_FEEDIN_WAIT;
            end
            S_FEEDIN_WAIT : begin
                cnt_feedin_rgn <= cnt_feedin_rgn + 1;
                state_feedin <= (cnt_feedin_rgn == 15) ? S_FEEDIN_IDLE : S_FEEDIN_WAIT;
            end
            default: begin
                img_update <= 0;
                rgn_update <= 0;
                cnt_frame  <= 0;
                cnt_feedin_rgn <= 0;
                state_feedin <= S_FEEDIN_IDLE;
            end
        endcase
    end
end

//always @(posedge busy_frame or posedge reset) begin
//    if (reset) begin
//        cnt_frame   <= 0;
//        aer_feedin  <= 0;
//        rp_feedin   <= 0;
//    end
//    // else if (start) begin
//        else if (cnt_frame<=3) begin
//            if (cnt_frame==2) begin
//                aer_feedin <= 1;
//            end
//            else if (cnt_frame==3) begin
//                rp_feedin  <= 1;
//            end
//            cnt_frame   <= cnt_frame + 1;
//        end
//    // end
//end
wire trig_input;
//assign trig_input = wi03_data[5];
assign trig_input = (cnt_frame==2) && (frame_falling);
wire level_input;
assign level_input = (cnt_frame==2) && (~busy_frame);

//// ext_mem
wire [0:0] mem_din_0, mem_din_1;
wire [0:0] mem_wen_0, mem_wen_1;
wire [0:0] mem_dout_0, mem_dout_1;
reg  [X_ADDR_WIDTH-1:0] addr_x_0, addr_x_1;
reg  [Y_ADDR_WIDTH-1:0] addr_y_0, addr_y_1;
wire [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] mem_addr_rd_0, mem_addr_rd_1; 
wire [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] mem_addr_wr_0, mem_addr_wr_1;
wire [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] mem_addr_rd;
reg  [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] mem_addr_rd_reg;
////===================
//readout data_pos & data_neg for debug
reg [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] dbg_rd80_addr;
reg [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] dbg_rd83_addr;
always @(posedge ti_clk or posedge reset) begin 
    if (reset) begin
        dbg_rd80_addr <= 0;
        dbg_rd83_addr <= 0;
    end
    else if (poa0_read) begin
        dbg_rd80_addr <= dbg_rd80_addr + 1;
    end
    else if (poa3_read) begin
        dbg_rd83_addr <= dbg_rd83_addr + 1;
    end
end
assign poa0_data[0] = mem_dout_0;
assign poa0_data[15:1] = 15'b0;
assign poa3_data[0] = mem_dout_1;
assign poa3_data[15:1] = 15'b0;
////===================
assign mem_din_0 = pi80_data[0];
assign mem_wen_0 = pi80_write;
assign mem_addr_rd_0 = aer_en ? addr : poa0_read ? dbg_rd80_addr : mem_addr_rd_reg;
assign mem_din_1 = pi83_data[0];
assign mem_wen_1 = pi83_write;
assign mem_addr_rd_1 = aer_en ? addr : poa3_read ? dbg_rd83_addr : mem_addr_rd_reg;
// assign mem_addr_rd = {parallel_out[7:0], ext_xAddressOut[8:0]};
// assign mem_addr_wr = {addr_y, addr_x};
assign mem_addr_rd = parallel_out[7:0] *X_LENGTH + ext_xAddressOut[8:0]; //read the regions only
assign mem_addr_wr_0 = addr_y_0 * X_LENGTH + addr_x_0; //write the whole memory
assign mem_addr_wr_1 = addr_y_1 * X_LENGTH + addr_x_1; //write the whole memory
always @(posedge ti_clk or posedge reset) begin
    if (reset) begin
        addr_x_0 <= 0;
        addr_y_0 <= 0;
        addr_x_1 <= 0;
        addr_y_1 <= 0;
    end
    else if (pi80_write) begin
        if (addr_y_0<Y_DEPTH) begin
            if (addr_x_0<X_LENGTH-1) begin
                addr_x_0 <= addr_x_0 + 1;
            end
            else begin
                addr_x_0 <= 0;
                addr_y_0 <= addr_y_0 + 1;
            end
        end
    end
    else if (pi83_write) begin
        if (addr_y_1<Y_DEPTH) begin
            if (addr_x_1<X_LENGTH-1) begin
                addr_x_1 <= addr_x_1 + 1;
            end
            else begin
                addr_x_1 <= 0;
                addr_y_1 <= addr_y_1 + 1;
            end
        end
    end
    ////NOTE: write once and DON'T reset addr when pixx_write is low 
    ////      need multiple pixx_write periods to write a huge amount of data
    // else begin 
    //     addr_x_0 <= 0;
    //     addr_y_0 <= 0;
    //     addr_x_1 <= 0;
    //     addr_y_1 <= 0;
    // end

    //else if (data_update) begin
    else if (addr_y_0 == Y_DEPTH) begin
        addr_y_0 <= 0;
    end
    else if (addr_y_1 == Y_DEPTH) begin
        addr_y_1 <= 0;
    end
end
always @(posedge clk or posedge reset) begin //1 clock delay: see ev_to_qvga_tsmc
    if (reset) begin
        mem_addr_rd_reg <= 0;
    end
    else begin
        mem_addr_rd_reg <= mem_addr_rd;
    end
end    

// assign ext_dataIn_pos = mem_dout_0;
// assign ext_dataIn_neg = mem_dout_1;
// assign ext_dataIn_pos = busy_frame_local;//wi00_data[6];//data_update;//busy_frame;
// assign ext_dataIn_neg = busy_frame_chip;//probe_busy_frame;//img_update;//classify_done;//to60_trig[1];

blk_mem_gen_0 ext_mem_0 ( //data_pos
    .clka   (ti_clk), //input clka;
    .wea    (mem_wen_0), //input [0 : 0] wea;
    .addra  (mem_addr_wr_0), //input [16 : 0] addra;
    .dina   (mem_din_0), //input [0 : 0] dina;
    .clkb   (clk), //input clkb;
    .addrb  (mem_addr_rd_0), //input [16 : 0] addrb;
    .doutb  (mem_dout_0)  //output [0 : 0] doutb;
);
blk_mem_gen_0 ext_mem_1 ( //data_neg
    .clka   (ti_clk), //input clka;
    .wea    (mem_wen_1), //input [0 : 0] wea;
    .addra  (mem_addr_wr_1), //input [16 : 0] addra;
    .dina   (mem_din_1), //input [0 : 0] dina;
    .clkb   (clk), //input clkb;
    .addrb  (mem_addr_rd_1), //input [16 : 0] addrb;
    .doutb  (mem_dout_1)  //output [0 : 0] doutb;
);


//// RP
wire [4:0] num_obj;
wire [8:0] region_x;
wire [8:0] region_y;
reg  region_valid;
wire region_rd_en;
wire [15:0] mem_dout1, mem_dout2;
wire [4:0] mem_addr1, mem_addr2;
reg  [4:0] mem_addr1_wr, mem_addr2_wr;
reg  [4:0] cnt, cnt_addr;
always @(posedge ti_clk or posedge reset) begin //write region [from MATLAB]
    if (reset) begin
        mem_addr1_wr <= 0;
        mem_addr2_wr <= 0;
    end
    //else if (pi81_write) begin
    //    mem_addr1_wr <= mem_addr1_wr + 1;
    //end
    //else if (pi82_write) begin
    //    mem_addr2_wr <= mem_addr2_wr + 1;
    //end
    else begin
        mem_addr1_wr <= (pi81_write) ? mem_addr1_wr + 1 : 0;
        mem_addr2_wr <= (pi82_write) ? mem_addr2_wr + 1 : 0;
    end
end
wire data_valid;//generated by ti_clk
reg  [7:0] cnt_valid;
reg  data_valid_reg;//extended by ti_clk [for lower clk case]
assign data_valid = (num_obj > 0) && (mem_addr2_wr == num_obj * 2);
always @(posedge ti_clk or posedge reset) begin
    if (reset) begin
        cnt_valid       <= 0;
        data_valid_reg  <= 0;
    end
    else begin
        if (data_valid) begin
            data_valid_reg <= 1;
        end
        if (data_valid_reg) begin
            cnt_valid <= cnt_valid + 1;
        end
        if (cnt_valid == 16) begin
            cnt_valid       <= 0;
            data_valid_reg  <= 0;
        end
    end
end
assign data_update = data_valid_reg;
always @(posedge clk or posedge reset) begin //read region [to CHIP]
    if (reset) begin
        cnt          <= 0;
        cnt_addr     <= 0;
        region_valid <= 0;
    end
    else begin
        cnt_addr     <= cnt;
        if (rgn_update) begin
        //if (level_input) begin
            if (cnt<num_obj*2 + 1) begin
                cnt          <= cnt + 1;
                region_valid <= 1;
            end
            else begin
                // cnt          <= 0;
                region_valid <= 0;
            end
        end
        else begin
            cnt          <= 0;
            region_valid <= 0;
        end
    end
end

////===================
//readout rp for debug
reg [4:0] dbg_rd81_addr;
reg [4:0] dbg_rd82_addr;
always @(posedge ti_clk or posedge reset) begin 
    if (reset) begin
        dbg_rd81_addr <= 0;
        dbg_rd82_addr <= 0;
    end
    else if (poa1_read) begin
        dbg_rd81_addr <= dbg_rd81_addr + 1;
    end
    else if (poa2_read) begin
        dbg_rd82_addr <= dbg_rd82_addr + 1;
    end
end
assign poa1_data = mem_dout1;
assign poa2_data = mem_dout2;
////===================

assign mem_addr1 = poa1_read ? dbg_rd81_addr : cnt_addr;
assign mem_addr2 = poa2_read ? dbg_rd82_addr : cnt_addr;
assign num_obj  = wi03_data[4:0];
assign region_x = mem_dout1[8:0];
assign region_y = mem_dout2[8:0];
blk_mem_gen_1 rgn_x (
    .clka   (ti_clk), //input clka;
    .wea    (pi81_write), //input [0 : 0] wea;
    .addra  (mem_addr1_wr[3:0]), //input [3 : 0] addra;
    .dina   (pi81_data), //input [15 : 0] dina;
    .clkb   (clk), //input clkb;
    .addrb  (mem_addr1[3:0]), //input [3 : 0] addrb;
    .doutb  (mem_dout1)  //output [15 : 0] doutb;
);
blk_mem_gen_1 rgn_y (
    .clka   (ti_clk), //input clka;
    .wea    (pi82_write), //input [0 : 0] wea;
    .addra  (mem_addr2_wr[3:0]), //input [3 : 0] addra;
    .dina   (pi82_data), //input [15 : 0] dina;
    .clkb   (clk), //input clkb;
    .addrb  (mem_addr2[3:0]), //input [3 : 0] addrb;
    .doutb  (mem_dout2)  //output [15 : 0] doutb;
);


RP2serial #(.MAX_NUM_OBJ(16))
    RP2serial_1(
    .clk(clk),
    .reset(reset),
    .reset_new(reset_new),
    // interface to RP
    .num_obj(num_obj),
    .region_x(region_x),
    .region_y(region_y),
    .region_valid(region_valid),
    .region_rd_en(region_rd_en),

    // interface to CNN
    .cnn_rd_region(rgn_rd_en),
    .cnn_region_done(rgn_done),
    .cnn_region_valid(rgn_bit_valid),
    .cnn_region_x_bit(rgn_x_bit),
    .cnn_region_y_bit(rgn_y_bit),
    .cnn_region_clk(rgn_clk)
);




//// AER
//wire clk_aer;
//wire busy_frame;
//assign busy_frame = wo20_data==16'd312 ? parallel_out[3] : 0;
//reg aer_input_go = 0;
//reg [3:0] frame_cnt = 4'b0;
//always @(busy_frame) begin
//    if (frame_cnt<3) begin // wait for at least two frames so that mem is initialized and not X
//        frame_cnt = frame_cnt + 1;
//        aer_input_go = 0;
//    end
//    else begin
//        aer_input_go = 1; 
//    end
//end


    AER_mimic_wi_input
    #(//Parameters :
        .X_LENGTH     (X_LENGTH),
        .Y_DEPTH      (Y_DEPTH),
        .X_ADDR_WIDTH (X_ADDR_WIDTH),
        .Y_ADDR_WIDTH (Y_ADDR_WIDTH)
    )
    aer_mimic_u1 (
        .clk(clk),
        .rst(reset),
        .aer_trig(img_update),
        .read_data_neg(mem_dout_1),
        .read_data_pos(mem_dout_0),
        .addr(addr),
        .AER_nack(top_AER_nack),
        .AER_nreq(top_AER_nreq),
        .AER_data(top_AER_data[9:0]) //used for debug
        // .AER_data()
    );

//// CNN
//extend "done" signal
reg [15:0] done_cnt;
reg done_lowf;
reg [3:0] state_cnn_done;
localparam [3:0] SS0 = 0, SS1 = 1, SS2 = 2, SS3 = 3;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        done_cnt <= 0;
        done_lowf <= 0;
        state_cnn_done  <= SS0;
    end
    else begin
        case (state_cnn_done)
            SS0 : begin
                if (done) begin
                    done_lowf <= 1;
                    state_cnn_done  <= SS1;
                end
                else begin
                    done_cnt <= 0;
                    done_lowf <= 0;
                    state_cnn_done  <= SS0;
                end
            end
            SS1: begin
                if (done_cnt==16'd100) begin
                    done_cnt <= 0;
                    state_cnn_done  <= SS0;
                end
                else begin 
                    done_cnt <= done_cnt + 1;
                    done_lowf <= 1;
                    state_cnn_done  <= SS1;
                end
            end
            default : begin
                    done_cnt <= 0;
                    done_lowf <= 0;
                    state_cnn_done  <= SS0;
            end
        endcase
    end
end
//extend "ext_cnn_done" signal
reg [15:0] ext_cnn_done_cnt;
reg ext_cnn_done_lowf;
reg [3:0] state_cnn_ext_cnn_done;
localparam [3:0] SSS0 = 0, SSS1 = 1, SSS2 = 2, SSS3 = 3;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ext_cnn_done_cnt <= 0;
        ext_cnn_done_lowf <= 0;
        state_cnn_ext_cnn_done  <= SSS0;
    end
    else begin
        case (state_cnn_ext_cnn_done)
            SSS0 : begin
                if (ext_cnn_done) begin
                    ext_cnn_done_lowf <= 1;
                    state_cnn_ext_cnn_done  <= SSS1;
                end
                else begin
                    ext_cnn_done_cnt <= 0;
                    ext_cnn_done_lowf <= 0;
                    state_cnn_ext_cnn_done  <= SSS0;
                end
            end
            SSS1: begin
                if (ext_cnn_done_cnt==16'd100) begin
                    ext_cnn_done_cnt <= 0;
                    state_cnn_ext_cnn_done  <= SSS0;
                end
                else begin 
                    ext_cnn_done_cnt <= ext_cnn_done_cnt + 1;
                    ext_cnn_done_lowf <= 1;
                    state_cnn_ext_cnn_done  <= SSS1;
                end
            end
            default : begin
                    ext_cnn_done_cnt <= 0;
                    ext_cnn_done_lowf <= 0;
                    state_cnn_ext_cnn_done  <= SSS0;
            end
        endcase
    end
end

wire dbg_cnn;
wire dbg_read_valid, dbg_read_data;
assign dbg_cnn = dbg_read_valid | dbg_read_data;
assign dbg_read_valid = wi05_data[0];
assign dbg_read_data  = wi05_data[1];

assign init = wi00_data[1];

reg  ext_cnn_rd_done_reg;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ext_cnn_rd_done_reg <= 0;
    end
    else if (ext_cnn_ready) begin
        ext_cnn_rd_done_reg <= 1'b1;
    end
    else begin
        ext_cnn_rd_done_reg <= 1'b0;
    end
end
// assign ext_cnn_rd_done = ext_cnn_rd_done_reg;
assign to60_trig[0] = ext_cnn_done_lowf;//ext_cnn_done;
// assign ext_cnn_rd_done = frame_en;//timer_advance;//busy_frame;//parallel_out[3];


//read class_output
reg signed [31:0] class_output [4:0];
reg  read_cnn_data_out;
wire read_cnn_data_out_done;
reg cnn_busy;
reg cnn_done_flag;
reg [15:0] region_cnt;
reg [15:0] readclass_cnt;
reg [15:0] spi_data_readcnn;
reg [6:0]  spi_addr_readcnn;
reg spi_wr_readcnn;
assign wo22_data = spi_data_readcnn;
assign to60_trig[1] = read_cnn_data_out;
// assign wo21_data[0] = read_cnn_data_out;//for sim
assign read_cnn_data_out_done = wi04_data[0];
reg [7:0] cnt_wait;
reg [3:0] state_read_cnn;
localparam [3:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S_dbg = 5, S_init = 6, S_wait = 7;
reg [4:0] counter1;
always @(posedge clk_div or posedge reset) begin
    if (reset) begin
        cnn_busy <= 0;
        counter1 <= 0;
        cnt_wait <= 0;
        cnn_done_flag <= 0;
        read_cnn_data_out <= 0;
        region_cnt <= 0;
        readclass_cnt <= 0;
        spi_wr_readcnn <= 0;
        spi_addr_readcnn <= 0;
        spi_data_readcnn <= 0;
        probe_busy_frame <= 0;
        state_read_cnn  <= S_init; //S0;
        classify_done <= 0;
    end
    else begin
        case (state_read_cnn)
            S_wait : begin //to block parallel_out to busy_frame
                spi_wr_readcnn <= 0;
                cnt_wait <= cnt_wait + 1;
                if (cnt_wait == 64) begin
                    state_read_cnn <= S_init;
                    classify_done <= 1;
                end
                else begin
                    state_read_cnn <= S_wait;
                end
            end
            S_init : begin
                spi_wr_readcnn <= 1;
                spi_addr_readcnn <= 7'd58;
                spi_data_readcnn <= 16'd312;
                probe_busy_frame <= 0;
                state_read_cnn <= S0;
                classify_done <= 0;
            end
            S0 : begin
                //if (trig_input) begin //trig signal to start input data to IC
                if (rgn_update) begin //trig regions to start input data to IC
                    cnn_busy <= 1; 
                    spi_wr_readcnn <= 1;
                    spi_addr_readcnn <= 7'd58;
                    spi_data_readcnn <= 16'h8000;
                    probe_busy_frame <= 0;
                    state_read_cnn  <= S1;
                end
                else begin
                    cnn_busy <= 0;
                    counter1 <= 0;
                    cnt_wait <= 0;
                    cnn_done_flag <= 0;
                    read_cnn_data_out <= 0;
                    region_cnt <= 0;
                    readclass_cnt <= 0;
                    spi_wr_readcnn <= 0;
                    spi_addr_readcnn <= 0;
                    spi_data_readcnn <= 0;
                    probe_busy_frame <= 1;
                    state_read_cnn  <= S0;
                end
            end
            S1 : begin
                spi_wr_readcnn <= 0;
                if (ext_cnn_ready) begin //
                    spi_wr_readcnn <= 1;
                    spi_addr_readcnn <= 7'd58;
                    spi_data_readcnn <= dbg_read_valid ? 16'd313 : dbg_read_data ? 16'd311 : 16'h8000;
                    state_read_cnn  <= S_dbg;
                end
                else begin
                    state_read_cnn  <= S1;
                end
            end
            S_dbg : begin
                spi_wr_readcnn <= 0;
                // if (done) begin //
                if (done_lowf) begin //done_lowf
                    spi_wr_readcnn <= 1;
                    spi_addr_readcnn <= 7'd58;
                    spi_data_readcnn <= 16'h8000;
                    state_read_cnn  <= S2;
                end
            end
            S2 : begin //
                counter1 <= 0;
                readclass_cnt <= 0;
                spi_wr_readcnn <= 0;
                if (ext_cnn_ready) begin
                    state_read_cnn  <= S3;
                end
                // else if (ext_cnn_done) begin //need output class of the last region
                else if (ext_cnn_done_lowf) begin //need output class of the last region
                    cnn_done_flag <= 1;
                    state_read_cnn  <= S3;
                end
                else begin
                    state_read_cnn  <= S2;
                end
            end
            S3 : begin
                spi_wr_readcnn <= 0;
                if (readclass_cnt < 20) begin
                    spi_wr_readcnn <= 1;
                    spi_addr_readcnn <= 7'd58;
                    // spi_data_readcnn <= wi02_data;//readclass_cnt;
                    spi_data_readcnn <= readclass_cnt;
                    state_read_cnn  <= S4;
                end
                else if (cnn_done_flag & readclass_cnt==20) begin
                    cnt_wait <= cnt_wait + 1;
                    read_cnn_data_out <= 1; //pulse for matlab, make sure this pulse is longer than 1 ti_clk cycle.
                    //state_read_cnn  <= (cnt_wait == 1) ? S0 : S3; //hold on for matlab acquiring in case of higher clk
                    if (cnt_wait==1) begin
                        state_read_cnn <= S_wait;
                        spi_wr_readcnn <= 1;
                        spi_addr_readcnn <= 7'd58;
                        spi_data_readcnn <= 16'd312;
                    end
                    else begin
                        state_read_cnn <= S3;
                    end
                end
                else begin
                    spi_wr_readcnn <= 1;
                    spi_addr_readcnn <= 7'd58;
                    spi_data_readcnn <= dbg_read_valid ? 16'd313 : dbg_read_data ? 16'd311 : 16'h8000;
                    region_cnt <= region_cnt + 1;
                    state_read_cnn  <= S_dbg;//S3;
                end
            end
            S4 : begin
                spi_wr_readcnn <= 0;
                if (counter1<24+3) begin
                    counter1 <= counter1 + 1;
                    state_read_cnn  <= S4;
                end
                else begin
                    // if      (readclass_cnt <  4) class_output [4] <= {parallel_out, class_output [4][31:8]};
                    // else if (readclass_cnt <  8) class_output [3] <= {parallel_out, class_output [3][31:8]};
                    // else if (readclass_cnt < 12) class_output [2] <= {parallel_out, class_output [2][31:8]};
                    // else if (readclass_cnt < 16) class_output [1] <= {parallel_out, class_output [1][31:8]};
                    // else                         class_output [0] <= {parallel_out, class_output [0][31:8]};
                    counter1 <= 0;
                    readclass_cnt <= readclass_cnt + 1;
                    state_read_cnn  <= S3;
                end
            end
            default : begin
                cnn_busy <= 0;
                counter1 <= 0;
                cnn_done_flag <= 0;
                read_cnn_data_out <= 0;
                region_cnt <= 0;
                readclass_cnt <= 0;
                spi_wr_readcnn <= 0;
                spi_addr_readcnn <= 0;
                spi_data_readcnn <= 0;
                probe_busy_frame <= 0;
                state_read_cnn  <= S0;
                classify_done <= 0;
            end
        endcase
    end
end

//// store class_output in a mem
reg  [10:0] mem_addra_classout1;
reg  [10:0] mem_addra_classout;
wire [15:0] mem_din_classout;
wire [15:0] mem_dout_classout;
wire mem_wr_classout;
reg  [10:0] mem_addrb_classout;
wire clk_sample;
assign clk_sample = clk_div;
assign mem_din_classout = {8'h00, parallel_out};
assign mem_wr_classout = counter1==5'd27;
always @(posedge clk_sample or posedge reset) begin
    if (reset) begin
        mem_addra_classout <= 0;
        mem_addra_classout1<= 0;
    end
    else if (mem_wr_classout) begin//
        mem_addra_classout <= region_cnt * 20 + readclass_cnt;
        mem_addra_classout1<= mem_addra_classout1 + 1;
    end
    else if (read_cnn_data_out) begin
        mem_addra_classout <= 0;
        mem_addra_classout1<= 0;
    end
end
// assign mem_addra_classout = cnn_busy ? region_cnt * 20 + readclass_cnt : 0;
always @(posedge ti_clk or posedge reset) begin
    if (reset) begin
        mem_addrb_classout <= 0;
    end
    else if (poa4_read) begin//
        mem_addrb_classout <= mem_addrb_classout + 1;
    end
    else begin //reset addr for multiple readout
        mem_addrb_classout <= 0;
    end
end
blk_mem_gen2 mem_classout ( //11bit addr --2048
    .clka   (clk_sample), //input clka;
    .wea    (mem_wr_classout), //input [0 : 0] wea;
    .addra  (mem_addra_classout1), //input [10 : 0] addra;
    .dina   (mem_din_classout),  //input [15 : 0] dina;
    .clkb   (ti_clk), //input clkb;
    .addrb  (mem_addrb_classout), //input [10 : 0] addrb;
    .doutb  (poa4_data) //output [15 : 0] doutb;
);


////debug
//store valid and data seperately
reg cnn_busy_reg1;
wire valid_op_from_mem;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        cnn_busy_reg1 <= 0;
    end
    else begin
        cnn_busy_reg1 <= cnn_busy;
    end
end

// reg [15:0] spi_data_dbgcnn;
// reg [6:0]  spi_addr_dbgcnn;
reg dbg_valid_wren;
reg dbg_valid_rden;
reg cnn_computing, cnn_computing_reg1;
reg [9:0] cnt_after_start_cnn;
wire fifo_full;
wire fifo_empty;
wire [7:0] dbg_data;
// assign poa5_data = {8'h00, dbg_data};
always @(posedge clk or posedge reset) begin : proc_config_ready
    if(reset) begin
        cnn_computing <= 0;
        cnn_computing_reg1 <= 0;
        cnt_after_start_cnn <= 0;
    end else if (ext_cnn_ready) begin
        cnn_computing_reg1 <= cnn_computing;
        if (cnt_after_start_cnn<610) begin
            cnt_after_start_cnn <= cnt_after_start_cnn + 1; 
        end
        else begin
            cnn_computing <= 1;
        end
    end else begin
        cnn_computing <= 0;
        cnn_computing_reg1 <= 0;
        cnt_after_start_cnn <= 0;
    end
end
always @(posedge clk or posedge reset) begin
    if (reset) begin
        dbg_valid_wren <= 0;
        dbg_valid_rden <= 0;
        // spi_data_dbgcnn<= 0;
        // spi_addr_dbgcnn<= 0;
    end
    else if (dbg_read_valid) begin
        dbg_valid_wren <= cnn_computing_reg1 & ~fifo_full;
        // spi_data_dbgcnn<= 16'd313;
        // spi_addr_dbgcnn<= 7'd58;
    end
    else if (dbg_read_data) begin
        dbg_valid_rden <= cnn_computing & ~fifo_empty;
        // spi_data_dbgcnn<= 16'd311;
        // spi_addr_dbgcnn<= 7'd58;
    end
end
// fifo_76800x1 fifo_valid(
//   .rst       (reset),
//   .wr_clk    (clk),
//   .rd_clk    (clk),
//   .din       (parallel_out[3]),
//   .wr_en     (dbg_valid_wren),
//   .rd_en     (dbg_valid_rden),
//   .dout      (valid_op_from_mem),
//   .full      (fifo_full),
//   .empty     (fifo_empty)
// );
// fifo_512x8b fifo_data(
//   .rst       (reset),
//   .wr_clk    (clk),
//   .rd_clk    (ti_clk),
//   .din       (parallel_out),
//   .wr_en     (valid_op_from_mem),
//   .rd_en     (poa5_read),
//   .dout      (dbg_data),
//   .full      (),
//   .empty     ()
// );


////=====
wire [0:0] mem_dbg_wen;
wire [0:0] mem_dbg_din;
wire [0:0] mem_dbg_dout;
reg [16:0] mem_dbg_addr_wr, mem_dbg_addr_rd;
reg  [2:0] po_cnt, po_cnt_reg1;
// assign mem_dbg_wen = ext_cnn_ready;
assign mem_dbg_wen = cnn_computing;//ext_cnn_ready;
// assign mem_dbg_din = dbg_read_valid ? parallel_out[3] : parallel_out[po_cnt_reg1];
// assign mem_dbg_din = dbg_read_valid ? parallel_out[3] : parallel_out[wi05_data[4:2]];
assign mem_dbg_din = wi05_data[5] ? wi05_data[6] : parallel_out[wi05_data[4:2]];
// assign mem_dbg_din = parallel_out[0];//1'b1;
assign poa5_data = {15'h0000, mem_dbg_dout};
// always @(posedge ti_clk or posedge reset) begin
//     if (reset) begin
//         po_cnt      <= 0;
//         po_cnt_reg1 <= 0;
//     end
//     else if (dbg_read_data) begin
//         if (trig_input) begin
//             po_cnt      <= (po_cnt == 3'b111) ? po_cnt : po_cnt + 1;
//             po_cnt_reg1 <= po_cnt;
//         end
//     end
//     // else if (dbg_read_valid) begin
//     else begin
//         po_cnt      <= 0;
//         po_cnt_reg1 <= 0;
//     end
// end
always @(posedge clk or posedge trig_input) begin
    if (trig_input) begin
        mem_dbg_addr_wr <= 0;
    end
    else if (mem_dbg_wen) begin
        if (mem_dbg_addr_wr == 17'h1ffff) mem_dbg_addr_wr <= mem_dbg_addr_wr;
        else mem_dbg_addr_wr <= mem_dbg_addr_wr + 1;
    end
end
always @(posedge ti_clk or posedge trig_input) begin
    if (trig_input) begin
        mem_dbg_addr_rd <= 0;
    end
    else if (poa5_read) begin
        mem_dbg_addr_rd <= mem_dbg_addr_rd + 1;
    end
end
blk_mem_gen_0 mem_dbg1 ( // 
    .clka   (clk), //input clka;
    .wea    (mem_dbg_wen), //input [0 : 0] wea;
    .addra  (mem_dbg_addr_wr), //input [16 : 0] addra;
    .dina   (mem_dbg_din), //input [0 : 0] dina;
    .clkb   (ti_clk), //input clkb;
    .addrb  (mem_dbg_addr_rd), //input [16 : 0] addrb;
    .doutb  (mem_dbg_dout)  //output [0 : 0] doutb;
);



////debug
// assign top_AER_data[4:0] = {state_read_cnn[2:0],read_cnn_data_out,cnn_done_flag};
// assign top_AER_data[3] = cnn_computing;
// assign top_AER_data[9:5] = done_lowf;
// assign top_AER_data[7:0] = parallel_out & {8{cnn_computing & dbg_read_data}};
// assign top_AER_data[8] = dbg_read_data;//valid_op_from_mem;
// assign top_AER_data[9] = dbg_read_valid;

assign wo21_data = {8'h00,parallel_out}; //for checking the tsmc memories

//check readout logic
reg sr_read_cnn_data_out;
reg sr_read_cnn_data_out_done;
reg [4:0] dbg_region_num;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sr_read_cnn_data_out <= 0;
        sr_read_cnn_data_out_done  <= 0;
        dbg_region_num <= 0;
    end
    else begin
        if (read_cnn_data_out) sr_read_cnn_data_out <= ~sr_read_cnn_data_out;
        if (read_cnn_data_out_done) sr_read_cnn_data_out_done <= ~sr_read_cnn_data_out_done;
        if (ext_cnn_done) dbg_region_num <= region_cnt;
    end
end

// assign wo21_data[4:0] = dbg_region_num;
// assign wo21_data[15:5] = 11'b0;


// //// store output to check
// reg dbg_dout_valid_dly1;
// reg [15:0] mem_addra_bdg, mem_addrb_bdg;
// always @(posedge clk_top or posedge reset) begin
//     if (reset) begin
//         mem_addra_bdg       <= 0;
//         dbg_dout_valid_dly1 <= 0;
//     end
//     else begin
//          dbg_dout_valid_dly1 <= dbg_dout_valid;
//         if (dbg_dout_valid_dly1) begin
//             mem_addra_bdg   <= mem_addra_bdg + 1;
//         end
//     end
// end
// always @(posedge ti_clk or posedge reset) begin
//     if (reset) begin
//         mem_addrb_bdg <= 0;
//     end
//     else if (poa0_read) begin
//         mem_addrb_bdg <= mem_addrb_bdg + 1;
//     end
// end

// blk_mem_gen mem_dbg(
//     .clka   (clk_top), //input clka;
//     .wea    (dbg_dout_valid_dly1), //input [0 : 0] wea;
//     .addra  (mem_addra_bdg), //input [15 : 0] addra;
//     .dina   (ext_dataIn_pos),  //input [0 : 0] dina;
//     .clkb   (ti_clk), //input clkb;
//     .addrb  (mem_addrb_bdg), //input [15 : 0] addrb;
//     .doutb  (poa0_data[0]) //output [0 : 0] doutb;
// );
// assign poa0_data[15:1] = {15{1'b0}};



// //// store output address to check
// reg [10:0] mem_addra_check, mem_addrb_check;
// always @(posedge clk_top or posedge reset) begin
//     if (reset) begin
//         mem_addra_check     <= 0;
//     end
//     else if (dbg_dout_valid) begin
//         mem_addra_check     <= mem_addra_check + 1;
//     end
// end
// always @(posedge ti_clk or posedge reset) begin
//     if (reset) begin
//         mem_addrb_check <= 0;
//     end
//     else if (poa1_read) begin//note: cannot clear addr if ~poa1_read since poa1_read is segmented
//         mem_addrb_check <= mem_addrb_check + 1;
//     end
// end
// blk_mem_gen2 mem_check ( //11bit addr --2048
//     .clka   (clk_top), //input clka;
//     .wea    (dbg_dout_valid), //input [0 : 0] wea;
//     .addra  (mem_addra_check), //input [10 : 0] addra;
//     .dina   (mem_addr_rd),  //input [15 : 0] dina;
//     .clkb   (ti_clk), //input clkb;
//     .addrb  (mem_addrb_check), //input [10 : 0] addrb;
//     .doutb  (poa1_data) //output [15 : 0] doutb;
// );



//// SPI
reg [22:0] data_in1; // ARRAY_WIDTH + ADDR_WIDTH = 16+7 =23
reg [23:0] update;
reg [23:0] clk_capture;
reg [23:0] data_out;
reg [4:0] counter3;

// assign clk_phase1 = ~clk;
// assign clk_phase2 = clk;
assign clk_update = update[0] & clk_phase1 & clk_div1; //narrow the update clk, 20201126
assign spi_din = data_in1[0];
assign capture = clk_capture[0];
assign wo20_data = wo20_datareg;

wire [15:0] spi_data;
wire [6:0]  spi_addr;
wire spi_wr;
wire spi_rd;
wire spi_clk;
// assign spi_clk  = cnn_busy ? clk : clk_div;
assign spi_data = spi_wr_readcnn ? spi_data_readcnn : wi06_data; 
assign spi_addr = spi_wr_readcnn ? spi_addr_readcnn : wi01_data[6:0]; 
assign spi_wr = ti41_trig[0] | spi_wr_readcnn;

assign spi_clk  = clk_div;
// assign spi_data = wi06_data; 
// assign spi_addr = wi01_data[6:0]; 
// assign spi_wr = ti41_trig[0] ;
assign spi_rd = ti41_trig[1] ;
assign clk_phase1 = ~spi_clk;
assign clk_phase2 = spi_clk;

always @(posedge spi_clk or negedge reset_n) begin
    if (!reset_n) begin
        update  <= 24'd0;
        clk_capture <= 24'd0;
        data_in1 <= 23'd0;
    end
    else begin
        if (spi_wr | spi_rd) begin
            if (spi_wr) begin
                data_in1 <= {spi_data,spi_addr};
                update <= 24'h800000;
            end
            if (spi_rd) begin
                data_in1 <= {16'd0,spi_addr};
                clk_capture <= 24'h800000;
            end
        end
        else begin
            data_in1 <= data_in1 >> 1;
            update <= update >>1;
            clk_capture <= clk_capture >>1;
        end
    end
end

always @(posedge spi_clk or negedge reset_n) begin
    if (!reset_n) begin
        data_out <= 24'd0;
        counter3 <= 5'd0;
    end
    else begin
        if (clk_capture[0]==1) begin
             data_out <= 24'd0;
             counter3 <= 5'd0;
        end
        else begin
            if (counter3 < 5'd31) begin  // ARRAY_WIDTH + ADDR_WIDTH + ADDR_WIDTH + 1 = 16+7+7+1 = 31
                data_out <= {spi_out,data_out[23:1]};
                counter3 <= counter3+1;
            end
            else begin
                wo20_datareg <= data_out[15:0];
            end
        end
    end
end


assign ext_dataIn_pos = state_feedin[0];//rgn_update;//clk_en;//wi00_data[6];//data_update;//busy_frame;
assign ext_dataIn_neg = state_feedin[1];//img_update;//data_update;//probe_busy_frame;//img_update;//classify_done;//to60_trig[1];
assign ext_cnn_rd_done = data_valid;//data_update;
// testing
assign test_clk = sys_clk1;
assign test2 = sys_clk2;
assign test3 = clk_div1;
endmodule