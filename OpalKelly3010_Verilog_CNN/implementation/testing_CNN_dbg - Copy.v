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

wire [15:0]     wo20_data;
wire [15:0]     wo21_data;

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

wire [15:0]     poa0_data;
wire [15:0]     poa1_data;
wire [15:0]     poa2_data;


reg [15:0] wo20_datareg;
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
wire [11*17-1:0]  ok2x; // Adjust size of ok2x to fit the number of outgoing FrontPanel endpoints in your design [n*17-1:0]
okWireOR # (.N(11)) wireOR (ok2, ok2x);// Adjust N to fit the number of outgoing FrontPanel endpoints in your design (.N(n))
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
okWireOut    ep20 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(wo20_data));
okWireOut    ep21 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h21), .ep_datain(wo21_data));
okTriggerIn  ep40 (.ok1(ok1),                           .ep_addr(8'h40), .ep_clk(ti_clk), .ep_trigger(ti40_trig));
okTriggerIn  ep41 (.ok1(ok1),                           .ep_addr(8'h41), .ep_clk(ti_clk), .ep_trigger(ti41_trig));
okTriggerOut ep60 (.ok1(ok1), .ok2(ok2x[ 2*17 +: 17 ]), .ep_addr(8'h60), .ep_clk(ti_clk), .ep_trigger(to60_trig));
okTriggerOut ep61 (.ok1(ok1), .ok2(ok2x[ 3*17 +: 17 ]), .ep_addr(8'h60), .ep_clk(ti_clk), .ep_trigger(to61_trig));
okPipeIn     ep80 (.ok1(ok1), .ok2(ok2x[ 4*17 +: 17 ]), .ep_addr(8'h80), .ep_write(pi80_write), .ep_dataout(pi80_data));
okPipeIn     ep81 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'h81), .ep_write(pi81_write), .ep_dataout(pi81_data));
okPipeIn     ep82 (.ok1(ok1), .ok2(ok2x[ 6*17 +: 17 ]), .ep_addr(8'h82), .ep_write(pi82_write), .ep_dataout(pi82_data));
okPipeIn     ep83 (.ok1(ok1), .ok2(ok2x[ 7*17 +: 17 ]), .ep_addr(8'h83), .ep_write(pi83_write), .ep_dataout(pi83_data));
okPipeOut    epa0 (.ok1(ok1), .ok2(ok2x[ 8*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(poa0_read), .ep_datain(poa0_data));
okPipeOut    epa1 (.ok1(ok1), .ok2(ok2x[ 9*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(poa1_read), .ep_datain(poa1_data));
okPipeOut    epa2 (.ok1(ok1), .ok2(ok2x[ 10*17 +: 17 ]), .ep_addr(8'ha2), .ep_read(poa2_read), .ep_datain(poa2_data));
//-----------------------------------------------------------OPAL KELLY INTERFACE-----------------------------------------------------






assign led = wi00_data[7:0];

wire clk;
wire reset;
wire reset_new;

////notice: the memory IP is driven by single clk (ti_clk). Change the IP if use scaling frequency.
// assign clk = sys_clk1;
// assign clk_top = sys_clk1;
assign clk = ti_clk; 
assign clk_top = ti_clk;
assign reset = wi00_data[0];
assign reset_new = reset;
assign reset_n = ~reset;

(*KEEP = "TRUE"*) reg clk_div;
always @(posedge sys_clk1) begin
    if(reset) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_div;
    end
end

(*KEEP = "TRUE"*) wire clk_trig;
assign clk_trig = sys_clk1;

assign en_evt2frame = wi00_data[2];
assign aer_en = wi00_data[4];
wire [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] addr;

//// ext_mem
wire [0:0] mem_din_0, mem_din_1;
wire [0:0] mem_wen_0, mem_wen_1;
wire [0:0] mem_dout_0, mem_dout_1;
reg  [X_ADDR_WIDTH-1:0] addr_x_0, addr_x_1;
reg  [Y_ADDR_WIDTH-1:0] addr_y_0, addr_y_1;
wire [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] mem_addr_0, mem_addr_1; 
wire [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] mem_addr_wr_0, mem_addr_wr_1;
wire [X_ADDR_WIDTH+Y_ADDR_WIDTH-1:0] mem_addr_rd;
assign mem_din_0 = pi80_data[0];
assign mem_wen_0 = pi80_write;
assign mem_addr_0 = pi80_write ? mem_addr_wr_0 : 
                    aer_en ? addr : mem_addr_rd;
assign mem_din_1 = pi83_data[0];
assign mem_wen_1 = pi83_write;
assign mem_addr_1 = pi83_write ? mem_addr_wr_1 : 
                    aer_en ? addr : mem_addr_rd;
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
    else begin 
        addr_x_0 <= 0;
        addr_y_0 <= 0;
        addr_x_1 <= 0;
        addr_y_1 <= 0;
    end
end

assign ext_dataIn_pos = mem_dout_0;
assign ext_dataIn_neg = mem_dout_1;

blk_mem_gen_0 ext_mem_0 ( //data_pos
    .clka(ti_clk),    // input wire clka
    .wea(mem_wen_0),      // input wire [0 : 0] wea
    .addra(mem_addr_0),  // input wire [16 : 0] addra
    .dina(mem_din_0),    // input wire [0 : 0] dina
    .douta(mem_dout_0)  // output wire [0 : 0] douta
);
blk_mem_gen_0 ext_mem_1 ( //data_neg
    .clka(ti_clk),    // input wire clka
    .wea(mem_wen_1),      // input wire [0 : 0] wea
    .addra(mem_addr_1),  // input wire [16 : 0] addra
    .dina(mem_din_1),    // input wire [0 : 0] dina
    .douta(mem_dout_1)  // output wire [0 : 0] douta
);


//// RP
wire [4:0] num_obj;
wire [8:0] region_x;
wire [8:0] region_y;
reg  region_valid;
wire region_rd_en;
wire [15:0] mem_dout1, mem_dout2;
wire [3:0] mem_addr1, mem_addr2; 
reg  [3:0] mem_addr1_wr, mem_addr2_wr;
reg  [4:0] cnt, cnt_addr;
reg  rg_valid;
always @(posedge ti_clk or posedge reset) begin //write region
    if (reset) begin
        mem_addr1_wr <= 0;
        mem_addr2_wr <= 0;
    end
    else if (pi81_write) begin
        mem_addr1_wr <= mem_addr1_wr + 1;
    end
    else if (pi82_write) begin
        mem_addr2_wr <= mem_addr2_wr + 1;
    end
end
always @(posedge clk or posedge reset) begin //read region
    if (reset) begin
        cnt          <= 0;
        cnt_addr     <= 0;
        region_valid <= 0;
    end
    else begin
        cnt_addr     <= cnt;
        if (wi03_data[5]) begin
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
assign mem_addr1 = pi81_write ? mem_addr1_wr : cnt_addr;
assign mem_addr2 = pi82_write ? mem_addr2_wr : cnt_addr;
assign num_obj  = wi03_data[4:0];
assign region_x = mem_dout1[8:0];
assign region_y = mem_dout2[8:0];
blk_mem_gen_1 rgn_x (
    .clka(ti_clk),    // input wire clka
    .wea(pi81_write),      // input wire [0 : 0] wea
    .addra(mem_addr1),  // input wire [3 : 0] addra
    .dina(pi81_data),    // input wire [15 : 0] dina
    .douta(mem_dout1)  // output wire [15 : 0] douta
);
blk_mem_gen_1 rgn_y (
    .clka(ti_clk),    // input wire clka
    .wea(pi82_write),      // input wire [0 : 0] wea
    .addra(mem_addr2),  // input wire [3 : 0] addra
    .dina(pi82_data),    // input wire [15 : 0] dina
    .douta(mem_dout2)  // output wire [15 : 0] douta
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
wire clk_aer;
wire busy_frame;
assign busy_frame = wo20_data==16'd312 ? parallel_out[3] : 0;
reg aer_input_go = 0;
reg [3:0] frame_cnt = 4'b0;
always @(busy_frame) begin
    if (frame_cnt<3) begin // wait for at least two frames so that mem is initialized and not X
        frame_cnt = frame_cnt + 1;
        aer_input_go = 0;
    end
    else begin
        aer_input_go = 1; 
    end
end

wire data_update;
assign data_update = wi00_data[3];
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
        .aer_trig(data_update), 
        // .aer_trig(aer_input_go), 
        .read_data_neg(mem_dout_1),
        .read_data_pos(mem_dout_0),
        .addr(addr),
        .AER_nack(top_AER_nack),
        .AER_nreq(top_AER_nreq),
        .AER_data(top_AER_data[9:6]) //other bits are used for debug
    );

//// CNN
assign init = wi00_data[1];//reset_n;

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
assign ext_cnn_rd_done = ext_cnn_rd_done_reg;
assign to60_trig[0] = done;//ext_cnn_done;

//read class_output
reg  read_cnn_data_out;
wire read_cnn_data_out_done;
assign to60_trig[1] = read_cnn_data_out;
assign read_cnn_data_out_done = wi04_data[0];
assign poa2_data[7:0] = parallel_out;
assign poa2_data[15:8] = 8'b0;
reg [2:0] state_read_cnn;
localparam [2:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3;
// reg [4:0] counter1;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        read_cnn_data_out <= 0;
        state_read_cnn  <= S0;
    end
    else begin
        case (state_read_cnn)
            S0 : begin
                if (done) begin //done from cnn
                    read_cnn_data_out <= 1; //start read class_output, pluse
                    state_read_cnn  <= S1;
                end
                else begin
                    read_cnn_data_out <= 0;
                    state_read_cnn  <= S0;
                end
            end
            S1 : begin
                if (read_cnn_data_out_done) begin //read_cnn_data_out_done from matlab
                    read_cnn_data_out <= 0;
                    state_read_cnn  <= S2;
                end
                else begin
                    read_cnn_data_out <= 0;
                    state_read_cnn  <= S1;
                end
            end
            S2 : begin //read finished
                read_cnn_data_out <= 0;
                state_read_cnn  <= S0;
            end
            default : begin
                read_cnn_data_out <= 0;
                state_read_cnn  <= S0;
            end
        endcase
    end
end

////debug
reg sr_read_cnn_data_out;
reg sr_read_cnn_data_out_done;
reg sr_done;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sr_read_cnn_data_out <= 0;
        sr_read_cnn_data_out_done  <= 0;
        sr_done <= 0;
    end
    else begin
        if (read_cnn_data_out) sr_read_cnn_data_out <= ~sr_read_cnn_data_out;
        if (read_cnn_data_out_done) sr_read_cnn_data_out_done <= ~sr_read_cnn_data_out_done;
        if (done) sr_done <= ~sr_done;
    end
end
assign top_AER_data[0] = sr_read_cnn_data_out;
assign top_AER_data[1] = sr_read_cnn_data_out_done;
assign top_AER_data[2] = sr_done;
assign top_AER_data[5:3] = state_read_cnn;



//// store output to check
reg dbg_dout_valid_dly1;
reg [15:0] mem_addra_bdg, mem_addrb_bdg;
always @(posedge clk_top or posedge reset) begin
    if (reset) begin
        mem_addra_bdg       <= 0;
        dbg_dout_valid_dly1 <= 0;
    end
    else begin
         dbg_dout_valid_dly1 <= dbg_dout_valid;
        if (dbg_dout_valid_dly1) begin
            mem_addra_bdg   <= mem_addra_bdg + 1;
        end
    end
end
always @(posedge ti_clk or posedge reset) begin
    if (reset) begin
        mem_addrb_bdg <= 0;
    end
    else if (poa0_read) begin
        mem_addrb_bdg <= mem_addrb_bdg + 1;
    end
end

blk_mem_gen mem_dbg(
    .clka   (clk_top), //input clka;
    .wea    (dbg_dout_valid_dly1), //input [0 : 0] wea;
    .addra  (mem_addra_bdg), //input [15 : 0] addra;
    .dina   (ext_dataIn_pos),  //input [0 : 0] dina;
    .clkb   (ti_clk), //input clkb;
    .addrb  (mem_addrb_bdg), //input [15 : 0] addrb;
    .doutb  (poa0_data[0]) //output [0 : 0] doutb;
);
assign poa0_data[15:1] = {15{1'b0}};



//// store output address to check
reg [10:0] mem_addra_check, mem_addrb_check;
always @(posedge clk_top or posedge reset) begin
    if (reset) begin
        mem_addra_check     <= 0;
    end
    else if (dbg_dout_valid) begin
        mem_addra_check     <= mem_addra_check + 1;
    end
end
always @(posedge ti_clk or posedge reset) begin
    if (reset) begin
        mem_addrb_check <= 0;
    end
    else if (poa1_read) begin//note: cannot clear addr if ~poa1_read since poa1_read is segmented
        mem_addrb_check <= mem_addrb_check + 1;
    end
end
blk_mem_gen2 mem_check ( //11bit addr --2048
    .clka   (clk_top), //input clka;
    .wea    (dbg_dout_valid), //input [0 : 0] wea;
    .addra  (mem_addra_check), //input [10 : 0] addra;
    .dina   (mem_addr_rd),  //input [15 : 0] dina;
    .clkb   (ti_clk), //input clkb;
    .addrb  (mem_addrb_check), //input [10 : 0] addrb;
    .doutb  (poa1_data) //output [15 : 0] doutb;
);



//// SPI
reg [22:0] data_in1; // ARRAY_WIDTH + ADDR_WIDTH = 16+7 =23
reg [23:0] update;
reg [23:0] clk_capture;
reg [23:0] data_out;
reg [4:0] counter3;

assign clk_phase1 = ~clk;
assign clk_phase2 = clk;
assign clk_update = update[0] & clk_phase1; //narrow the update clk, 20201126
assign spi_din = data_in1[0];
assign capture = clk_capture[0];
assign wo20_data = wo20_datareg;


always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        update  <= 24'd0;
        clk_capture <= 24'd0;
        data_in1 <= 23'd0;
    end
    else begin
        if (ti41_trig[0] | ti41_trig[1]) begin
            if (ti41_trig[0]) begin 
                data_in1 <= {wi02_data,wi01_data[6:0]};
                update <= 24'h800000;
            end
            if (ti41_trig[1]) begin
                data_in1 <= {16'd0,wi01_data[6:0]};
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

always @(posedge clk or negedge reset_n) begin
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



// testing
assign test_clk = sys_clk1;
assign test2 = sys_clk2;
assign test3 = clk_div;
endmodule
