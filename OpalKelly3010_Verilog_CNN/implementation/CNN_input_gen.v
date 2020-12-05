`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zhang Lei
// 
// Create Date: 12/11/2019 09:14:56 PM
// Design Name: 
// Module Name: CNN_input_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 0.01 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CNN_input_gen
    #(
    parameter FILTERED_MEM_DELAY = 2,
    parameter MAX_NUM_OBJ = 16,
    parameter X_WIDTH = 9,
    parameter Y_WIDTH = 9,
    parameter CNN_W = 42
    )
    (
    input wire clk,
//  input wire reset,
    input wire reset_n,

    //debug
    input wire [7:0] dbg_reg,   // SPI register 
    output wire dbg_dout_valid, // output pin (PAD)
    output wire [7:0] dbg_dout, // output pins (PADs)
                            // Zeros, debug off, 
                            // reg[0]=1: output 42x42 memory, 
                            // reg[1]=1: output rp list
                            // reg[2]=1: output y address

    // config
    input wire signed [15:0] param_a, 
    input wire signed [15:0] param_b, 
    input wire signed [15:0] param_c, 

    // interface to RP2serial
    output reg region_rd_en,
    input wire region_done,
    input wire region_bit_valid,
    input wire region_x_bit,
    input wire region_y_bit,
    input wire region_clk, // for slower clock

    // internal interface to memory
    input wire dataIn_pos,
    input wire dataIn_neg,
    output wire [X_WIDTH-1:0] xAddressOut,
    output wire [Y_WIDTH-1:0] yAddressOut,
    output wire cnn_done, //pulse, to inform that memory access over
    input wire cnn_read_valid, // not used since FILTERED_MEM_DELAY fixed the timing

    // external interface to memory
    input wire ext_dataIn_pos,
    input wire ext_dataIn_neg,
    output wire [X_WIDTH-1:0] ext_xAddressOut,
    output wire ext_cnn_done,

    // output to CNN
    input wire  cnn_rd_done,
    output wire cnn_ready,
    output wire [CNN_W*CNN_W-1:0] cnn_dout_ch0, // 42x42
    output wire [CNN_W*CNN_W-1:0] cnn_dout_ch1,  // 42x42

    // external control signal 
    input wire ext_cnn_rd_done,
    output wire ext_cnn_ready

    );

`define clog2(x) \
((x <= 1) || (x > 512)) ? 0 : \
(x <= 2) ? 1 : \
(x <= 4) ? 2 : \
(x <= 8) ? 3 : \
(x <= 16) ? 4 : \
(x <= 32) ? 5 : \
(x <= 64) ? 6 : \
(x <= 128) ? 7: \
(x <= 256) ? 8: \
(x <= 512) ? 9 : 0

//reg cnn_rd_done_internal;

// test
// assign dbg_reg = 1;

// debug 
// wire [16:0] dbg_reg;
wire dbg_dout_mem_en        = dbg_reg[0];
wire dbg_dout_rp_en         = dbg_reg[1];
wire dbg_ext_mem_en         = dbg_reg[2];
wire dbg_dout_yaddr_en      = dbg_ext_mem_en ? 1 : dbg_reg[3];
wire dbg_xaddr_op_en        = dbg_ext_mem_en ? 1 : dbg_reg[4];
wire dbg_ext_cnn_rd_done_en = dbg_reg[5];
wire dbg_cnn_ready_op_en    = ~dbg_reg[6];
wire dbg_cnn_done_op_en     = ~dbg_reg[7];

// mux assign 
wire dataIn_pos_internal;
wire dataIn_neg_internal;
reg  cnn_done_internal;
wire cnn_rd_done_internal;
reg  cnn_ready_internal;

// output signal 
assign cnn_done      = dbg_cnn_done_op_en ? cnn_done_internal : 0;
assign cnn_ready     = dbg_cnn_ready_op_en ? cnn_ready_internal : 0;

// control debug signal output
assign ext_cnn_ready = cnn_ready_internal;
// control debug signal input
assign cnn_rd_done_internal = dbg_ext_cnn_rd_done_en ? ext_cnn_rd_done : cnn_rd_done;

// memory debug config output
assign ext_xAddressOut     = dbg_xaddr_op_en ? xAddressOut : 0;
assign ext_cnn_done        = cnn_done_internal;
// memory debug config input
assign dataIn_pos_internal = dbg_ext_mem_en ? ext_dataIn_pos : dataIn_pos;
assign dataIn_neg_internal = dbg_ext_mem_en ? ext_dataIn_neg : dataIn_neg;



wire reset;
assign reset = ~reset_n;

//serial to RP module
reg [2:0] read_bit_stm_state;
reg [X_WIDTH-1:0] region_x;
reg [Y_WIDTH-1:0] region_y;
// reg [($clog2(X_WIDTH)-1):0] bit_cnt;
reg [(`clog2(X_WIDTH)-1):0] bit_cnt;

always @ (posedge region_clk) begin
  if (reset) begin
        region_rd_en   <= 0; 

        read_bit_stm_state <= 0;
        bit_cnt <= 0;
        region_x <= 0;
        region_y <= 0;

    end else begin
        case(read_bit_stm_state)
        0: begin // wait
            region_rd_en  <= 0; 
            read_bit_stm_state <= 0;
            region_x  <= 0;
            region_y  <= 0;

            if (region_done) begin
                region_rd_en <= 1;
                read_bit_stm_state <= 1;
            end
        end
        1: begin //read
            if (region_done) begin
                region_rd_en <= 1;
                read_bit_stm_state <= 1;

                if (region_bit_valid) begin
                    bit_cnt <= bit_cnt + 1;
                    region_x <= {region_x_bit, region_x[X_WIDTH-1:1]}; // LSB first
                    region_y <= {region_y_bit, region_y[Y_WIDTH-1:1]};
                end else begin //read over
                    region_x <= 0;
                    region_y <= 0;
                    bit_cnt <= 0;
                end 
                
            end else begin
                region_rd_en <= 0;
                read_bit_stm_state <= 0;
                bit_cnt <= 0;
                region_x  <= 0;
                region_y  <= 0;
                
            end
            
        end
        default: begin
            region_rd_en   <= 0; 
            read_bit_stm_state <= 0;
            bit_cnt <= 0;
            region_x <= 0;
            region_y <= 0;

        end
        endcase

    end
end

wire region_valid;
assign region_valid = (bit_cnt == X_WIDTH) ? 1 : 0;
  

reg [X_WIDTH-1:0] region_x_list [0:MAX_NUM_OBJ*2-1];//max MAX_NUM_OBJ object
reg [Y_WIDTH-1:0] region_y_list [0:MAX_NUM_OBJ*2-1];

reg [`clog2(MAX_NUM_OBJ*2):0] region_cnt, region_num, loop_index; //start from 1 to object number * 2
reg histo_read_done;

reg [2:0] read_stm_state;
reg region_rd_over;

reg [`clog2(MAX_NUM_OBJ*2):0] dbg_rp_cnt;
reg [X_WIDTH-1:0] dbg_rp_buf;
reg dbg_rp_ch;
reg dbg_rp_lsb_msb; //0 lsb, 1 msb
wire [7:0] dbg_dout_rp;
reg dbg_dout_rp_valid;

// read x and y and store in list
// assert region_rd_over to trigger next state machine 
integer region_i;
always @ (posedge region_clk) begin
  if (reset) begin
        region_cnt     <= 0;
        read_stm_state <= 0;
        region_num     <= 0;
        region_rd_over <= 0;

        for (region_i = 0; region_i <= MAX_NUM_OBJ*2-1; region_i = region_i + 1) begin
            region_x_list[region_i] <= 0;
            region_y_list[region_i] <= 0;
        end
    end else begin
        case(read_stm_state)
        0: begin // wait
            read_stm_state <= 0;
            region_rd_over <= 0;
            region_cnt     <= 0;

            if (region_done) begin
                read_stm_state <= 1;
            end
        end
        1: begin //read
            if (region_done) begin
                if (region_valid) begin
                    region_x_list[region_cnt] <= region_x;
                    region_y_list[region_cnt] <= region_y;

                    // test data 
                    // for (region_i = 0; region_i <= MAX_NUM_OBJ*2-1; region_i = region_i + 1) begin
                    //     region_x_list[region_i][7:0] <= region_i+1;
                    //     region_y_list[region_i][7:0] <= region_i+20;
                    //     region_x_list[region_i][8] <= 1;
                    //     region_y_list[region_i][8] <= 1;
                    // end

                    region_cnt <= region_cnt + 1;
                end 
                read_stm_state <= 1;
                region_rd_over <= 0;
            end else begin
                read_stm_state <= 0; //over
                region_rd_over <= 1;
                region_num     <= region_cnt;
                region_cnt     <= 0;
            end
        end
        default: begin
            region_cnt     <= 0;
            read_stm_state <= 0;
            region_num     <= 0;
            region_rd_over <= 0;
            for (region_i = 0; region_i <= MAX_NUM_OBJ*2-1; region_i = region_i + 1) begin
                region_x_list[region_i] <= 0;
                region_y_list[region_i] <= 0;
            end
        end
        endcase

    end
end

// debug output 
wire [7:0] dbg_dout_rp_internal;
assign dbg_dout_rp_internal = dbg_rp_lsb_msb ? {7'b0, dbg_rp_buf[8]} : dbg_rp_buf[7:0];
assign dbg_dout_rp = dbg_dout_rp_valid ? dbg_dout_rp_internal : 0;


// read memory after region_rd_over assert
// validate the object
parameter IDLE  = 0 , GET_REGION = 1 , CROP_REGION = 2 , SCAN_REGION = 3 , ALL_OVER = 4 , ONE_OVER = 5 ;
parameter FILTER_REGION_1 = 6, FILTER_REGION_2 = 7;
parameter DBG_OUT_1 = 8, DBG_OUT_2 = 9;
reg [4:0] main_stm_state;
reg [X_WIDTH-1:0] region_dx;
reg [Y_WIDTH-1:0] region_dy;
reg signed [32:0] region_filter; 
reg [X_WIDTH-1:0] margin_x1, margin_x2, margin_y1, margin_y2, margin_x_center, margin_y_center;
reg [X_WIDTH-1:0] region_row, region_col;
wire [X_WIDTH:0] mem_addr_x;
wire [Y_WIDTH:0] mem_addr_y;

reg mem_addr_valid;
reg op_over;
// memory address gen
always @ (posedge clk) begin
    if (reset) begin
        main_stm_state <= IDLE;
 
        loop_index <= 0;

        cnn_done_internal <= 0;
        mem_addr_valid <= 0;
        region_dx <= 0;
        region_dy <= 0;
        region_filter <=0;
        margin_x_center <= 0;
        margin_y_center <= 0;

        margin_x1 <= 0;
        margin_x2 <= 0;
        margin_y1 <= 0;
        margin_y2 <= 0;

        region_col <= 0;
        region_row <= 0;

        dbg_dout_rp_valid <= 0;
        dbg_rp_lsb_msb <= 0;
        dbg_rp_ch <= 0;
        dbg_rp_buf <= 0;
        dbg_rp_cnt <= 0;

    end else begin
        case (main_stm_state)
            IDLE: begin //idle and wait for start
                main_stm_state <= IDLE;
        
                loop_index <= 0;

                cnn_done_internal <= 0;
                mem_addr_valid <= 0;

                region_dx <= 0;
                region_dy <= 0;
                region_filter <=0;

                dbg_dout_rp_valid <= 0;
                dbg_rp_lsb_msb <= 0;
                dbg_rp_ch <= 0;
                dbg_rp_buf <= 0;
                dbg_rp_cnt <= 0;

                if (region_rd_over) begin
                    if (region_num > 0) begin
                        if (dbg_dout_rp_en) begin
                            main_stm_state <= DBG_OUT_1; //debug output
                        end else begin
                            main_stm_state <= GET_REGION;
                        end
                    end else begin
                        main_stm_state <= ALL_OVER;
                    end
                end
            end
            GET_REGION: begin //get a region
                cnn_done_internal <= 0;
                mem_addr_valid <= 0;
                region_filter <=0;

                dbg_dout_rp_valid <= 0;
                dbg_rp_lsb_msb <= 0;
                dbg_rp_ch <= 0;
                dbg_rp_buf <= 0;
                dbg_rp_cnt <= 0;

                if (loop_index < region_num) begin
                    margin_x1 <= region_x_list[loop_index];
                    margin_x2 <= region_x_list[loop_index+1];
                    margin_y1 <= region_y_list[loop_index];
                    margin_y2 <= region_y_list[loop_index+1];

                    margin_x_center <= (region_x_list[loop_index+1] + region_x_list[loop_index]) >> 1; // x_center = x1 + (x2-x1)/2 = (x2+x1)/2
                    margin_y_center <= (region_y_list[loop_index+1] + region_y_list[loop_index]) >> 1;

                    region_dx <= region_x_list[loop_index+1] - region_x_list[loop_index] + 1;
                    region_dy <= region_y_list[loop_index+1] - region_y_list[loop_index] + 1;

                    // update counter
                    loop_index <= loop_index + 2; //two x and two y are paired

                    main_stm_state <= FILTER_REGION_1; 
                end else begin
                    main_stm_state <= ALL_OVER; //all over 
                end
            end

            FILTER_REGION_1: begin //filter out the region that too small
                mem_addr_valid <= 0;
                region_filter <= $signed({1'b0, region_dx}) * param_a + $signed({1'b0, region_dy}) * param_b + param_c;
                main_stm_state <= FILTER_REGION_2; 
            end

            FILTER_REGION_2: begin //filter out the region that too small
                mem_addr_valid <= 0;
                if (region_filter > 0) begin
                    main_stm_state <= CROP_REGION; 
                end else begin
                    main_stm_state <= GET_REGION; 
                end
            end

            CROP_REGION: begin
                if (region_dx > CNN_W) begin
                    margin_x1 <= margin_x_center - CNN_W/2;
                    margin_x2 <= margin_x_center + CNN_W/2;
                    region_dx <= CNN_W;
                end

                if (region_dy > CNN_W) begin
                    margin_y1 <= margin_y_center - CNN_W/2;
                    margin_y2 <= margin_y_center + CNN_W/2;
                    region_dy <= CNN_W;
                end
                
                cnn_done_internal <= 0;
                region_col <= 0;
                region_row <= 0;
                region_filter <=0;
                mem_addr_valid <= 1;
                main_stm_state <= SCAN_REGION;    
            end

            SCAN_REGION: begin //scan region 42 x 42
                cnn_done_internal <= 0;
                region_filter <=0;
                mem_addr_valid <= 1;
                main_stm_state <= SCAN_REGION;
                if((region_row == region_dy-1) && (region_col == region_dx-1)) begin
                    // scan over
                    region_col <= 0;
                    region_row <= 0;
                    mem_addr_valid <= 0;
                    main_stm_state <= ONE_OVER;
                end else begin
                    // scan next row
                    if (region_col == region_dx-1) begin
                        region_col <= 0;
                        region_row <= region_row + 1;
                    end else begin
                        region_col <= region_col + 1;
                    end
                end
            end

            ALL_OVER: begin //all scan over
                // wait for region rd over to be low, because it's slower than main clock
                // avoid repeat trigger
                if (region_rd_over) begin
                    main_stm_state <= ALL_OVER;
                    loop_index <= 0;
                    mem_addr_valid <= 0;
                    region_dx <= 0;
                    region_dy <= 0;
                    region_filter <=0;
                    cnn_done_internal <= 0;
                end else begin
                    main_stm_state <= IDLE;
                    loop_index <= 0;
                    mem_addr_valid <= 0;
                    region_dx <= 0;
                    region_dy <= 0;
                    region_filter <=0;
                    cnn_done_internal <= 1;
                end
            end

            ONE_OVER: begin // halt, waiting for next instruction to start
                cnn_done_internal <= 0;
                region_filter <=0;
                mem_addr_valid <= 0;
               if (op_over) 
                    main_stm_state <= GET_REGION;
               else
                   main_stm_state <= ONE_OVER;
            end

            DBG_OUT_1: begin // debug, output via debug port before next state
                dbg_rp_lsb_msb <= 0;
                dbg_dout_rp_valid <= 1;
                dbg_rp_ch <= 0;
                dbg_rp_buf <= region_x_list[dbg_rp_cnt];
                main_stm_state <= DBG_OUT_2;
            end
            DBG_OUT_2: begin //debug, output in 8bits format
                dbg_dout_rp_valid <= 1;
                main_stm_state <= DBG_OUT_2; // keep shifting

                if (dbg_rp_ch == 0) begin
                    dbg_rp_buf <= region_x_list[dbg_rp_cnt];
                end else begin
                    dbg_rp_buf <= region_y_list[dbg_rp_cnt];
                end

                if (dbg_rp_lsb_msb == 0) begin
                    if (dbg_rp_cnt == region_num - 1) begin
                        dbg_rp_cnt <= 0;
                    end else begin
                        dbg_rp_cnt <= dbg_rp_cnt + 1;
                    end

                    if ((dbg_rp_cnt == region_num-1) && (dbg_rp_ch == 0)) begin //first channel finished
                        dbg_rp_ch <= 1;
                    end

                    if ((dbg_rp_cnt == region_num-1) && (dbg_rp_ch == 1)) begin // second channel finished
                        // debug output over, output data to port
                        main_stm_state <= GET_REGION;
                    end
                end

                if (dbg_rp_lsb_msb == 0) begin
                    dbg_rp_lsb_msb <= 1;
                end else begin
                    dbg_rp_lsb_msb <= 0;
                end
            end
            
            
            default: main_stm_state <= IDLE;
        endcase
    end
end

assign mem_addr_x = mem_addr_valid ? margin_x1 + region_col : 0;
assign mem_addr_y = mem_addr_valid ? margin_y1 + region_row : 0;
assign xAddressOut = mem_addr_x ;
assign yAddressOut = mem_addr_y ;


//memory delay handle
reg mem_addr_valid_d            [0:FILTERED_MEM_DELAY-1];
reg [X_WIDTH-1:0] region_dx_d [0:FILTERED_MEM_DELAY-1];
reg [Y_WIDTH-1:0] region_dy_d [0:FILTERED_MEM_DELAY-1];
reg [X_WIDTH-1:0] region_col_d [0:FILTERED_MEM_DELAY-1];
reg [Y_WIDTH-1:0] region_row_d [0:FILTERED_MEM_DELAY-1];

integer i;

always @ (posedge clk) begin
    if (reset) begin
        for (i = 0; i < FILTERED_MEM_DELAY ; i = i + 1 ) begin
            mem_addr_valid_d[i]       <= 0;
            region_dx_d[i]            <= 0;
            region_dy_d[i]            <= 0;
            region_col_d[i]           <= 0;
            region_row_d[i]           <= 0;
        end
    end else begin
        mem_addr_valid_d[0]       <= mem_addr_valid;
        region_dx_d[0]            <= region_dx;
        region_dy_d[0]            <= region_dy;
        region_col_d[0]            <= region_col;
        region_row_d[0]            <= region_row;

        for (i = 0; i < FILTERED_MEM_DELAY-1 ; i = i + 1 ) begin
            mem_addr_valid_d[i+1]       <= mem_addr_valid_d[i];
            region_dx_d[i+1]            <= region_dx_d[i];
            region_dy_d[i+1]            <= region_dy_d[i];
            region_col_d[i+1]            <= region_col_d[i];
            region_row_d[i+1]            <= region_row_d[i];
        end
    end 
end

reg act_mem_data_valid;
reg [X_WIDTH-1:0] act_region_dx;
reg [Y_WIDTH-1:0] act_region_dy;
reg [X_WIDTH-1:0] act_region_col;
reg [Y_WIDTH-1:0] act_region_row;

always @(*) begin
    if(FILTERED_MEM_DELAY > 1) begin
        act_mem_data_valid       = mem_addr_valid_d[FILTERED_MEM_DELAY-1];
        act_region_dx            = region_dx_d[FILTERED_MEM_DELAY-1];
        act_region_dy            = region_dy_d[FILTERED_MEM_DELAY-1];
        act_region_col           = region_col_d[FILTERED_MEM_DELAY-1];
        act_region_row           = region_row_d[FILTERED_MEM_DELAY-1];
    end else begin
        act_mem_data_valid       = mem_addr_valid;
        act_region_dx            = region_dx;
        act_region_dy            = region_dy;
        act_region_col           = region_col;
        act_region_row           = region_row;
    end
end



// region to cnn region
//--------------------------------------------
// cnn region column offset
wire [X_WIDTH-1:0] col_offset = (CNN_W-act_region_dx) >> 1;
wire [X_WIDTH-1:0] cnn_col_tmp = act_region_col + col_offset;
// cap column
// cnn region column index
wire [X_WIDTH-1:0] cnn_col = cnn_col_tmp > CNN_W-1 ? CNN_W-1 : cnn_col_tmp;
// cnn region row offset
wire [X_WIDTH-1:0] row_offset  = (CNN_W-act_region_dy) >> 1;
wire [X_WIDTH-1:0] cnn_row_tmp = act_region_row + row_offset;
// cap row
// cnn region row index
wire [X_WIDTH-1:0] cnn_row = cnn_row_tmp > CNN_W-1 ? CNN_W-1 : cnn_row_tmp;
wire act_region_end = ((act_region_col == act_region_dx-1) && (act_region_row == act_region_dy-1)) ? 1 : 0;


// cnn region row store
//--------------------------------------------
reg [CNN_W-1:0] cnn_op_buffer_0 [0:CNN_W-1];
reg [CNN_W-1:0] cnn_op_buffer_1 [0:CNN_W-1];

// read row buffer and write to output buffer 

reg [3:0] op_stm;

//debug regs
reg [`clog2(CNN_W)-1:0] dbg_row_cnt;
reg [CNN_W-1:0] dbg_op_buf;
reg dbg_op_ch;
reg [4:0] dbg_op_shift_cnt;
wire [7:0] dbg_dout_mem;
reg dbg_dout_mem_valid;

integer dbg_i;

always @ (posedge clk) begin
    if (reset) begin
        cnn_ready_internal <= 0;
        op_stm <= 0;
        op_over <= 0;

        dbg_dout_mem_valid <= 0;
        dbg_op_shift_cnt <= 0;
        dbg_op_ch <= 0;
        dbg_op_buf <= 0;
        dbg_row_cnt <= 0;

        for (i = 0; i < CNN_W; i = i + 1) begin
            cnn_op_buffer_0[i] <= 0;
            cnn_op_buffer_1[i] <= 0;
        end
    end else begin
        case (op_stm)
            0: begin //idle
                op_stm <= 0; 
                cnn_ready_internal <= 0;
                op_over <= 0;

                dbg_dout_mem_valid <= 0;
                dbg_op_shift_cnt <= 0;
                dbg_op_ch <= 0;
                dbg_op_buf <= 0;
                dbg_row_cnt <= 0;

                for (i = 0; i < CNN_W; i = i + 1) begin
                    cnn_op_buffer_0[i] <= 0;
                    cnn_op_buffer_1[i] <= 0;
                end

                if(act_mem_data_valid) begin
                    // the cnn_data has one more clock cycle than cnn_row
                    cnn_op_buffer_0[cnn_row][cnn_col] <= dataIn_pos_internal;
                    cnn_op_buffer_1[cnn_row][cnn_col] <= dataIn_neg_internal;
                    // cnn_op_buffer_0[cnn_row] <= cnn_row+1; //test
                    op_stm <= 1; // state fill in date
                end

            end 

            1:begin //cnn output buffer fillin
                op_stm <= 1;
                cnn_ready_internal <= 0;
                op_over <= 0;
                dbg_dout_mem_valid <= 0;
                dbg_op_shift_cnt <= 0;
                dbg_op_ch <= 0;
                dbg_op_buf <= 0;
                dbg_row_cnt <= 0;

                if(act_mem_data_valid) begin
                    cnn_op_buffer_0[cnn_row][cnn_col] <= dataIn_pos_internal;
                    cnn_op_buffer_1[cnn_row][cnn_col] <= dataIn_neg_internal;

                    //test data
                    // cnn_op_buffer_0[cnn_row] <= cnn_row+1; 
                    //test data
                    // for (dbg_i = 0; dbg_i < CNN_W; dbg_i = dbg_i + 1) begin
                    //     cnn_op_buffer_0[dbg_i][8*1-1:8*0] <= 1 + dbg_i;
                    //     cnn_op_buffer_0[dbg_i][8*2-1:8*1] <= 2 + dbg_i;
                    //     cnn_op_buffer_0[dbg_i][8*3-1:8*2] <= 3 + dbg_i;
                    //     cnn_op_buffer_0[dbg_i][8*4-1:8*3] <= 4 + dbg_i;
                    //     cnn_op_buffer_0[dbg_i][8*5-1:8*4] <= 5 + dbg_i;
                    //     cnn_op_buffer_0[dbg_i][41:8*5] <= 7;

                    //     cnn_op_buffer_1[dbg_i][8*1-1:8*0] <= 1 + dbg_i + 1;
                    //     cnn_op_buffer_1[dbg_i][8*2-1:8*1] <= 2 + dbg_i + 1;
                    //     cnn_op_buffer_1[dbg_i][8*3-1:8*2] <= 3 + dbg_i + 1;
                    //     cnn_op_buffer_1[dbg_i][8*4-1:8*3] <= 4 + dbg_i + 1;
                    //     cnn_op_buffer_1[dbg_i][8*5-1:8*4] <= 5 + dbg_i + 1;
                    //     cnn_op_buffer_1[dbg_i][41:8*5] <= 7;
                    // end
                end

                if (act_region_end) begin
                    if (dbg_dout_mem_en) begin
                        op_stm <= 4; 
                    end else begin
                        op_stm <= 2;
                    end
                end
            end

            2:begin // wait for output done
                op_stm <= 2;
                cnn_ready_internal <= 1;
                op_over <= 0;
                dbg_dout_mem_valid <= 0;
                dbg_op_shift_cnt <= 0;
                dbg_op_ch <= 0;
                dbg_op_buf <= 0;
                dbg_row_cnt <= 0;
                if (cnn_rd_done_internal) begin
                    op_stm <= 3; // over
                    cnn_ready_internal <= 0;
                end
            end

            3: begin // over
                cnn_ready_internal    <= 0;
                op_over      <= 1;
                op_stm       <= 0; // to idle
                dbg_dout_mem_valid <= 0;
                dbg_op_shift_cnt <= 0;
                dbg_op_ch <= 0;
                dbg_op_buf <= 0;
                dbg_row_cnt <= 0;
            end

            4: begin // debug, output via debug port before output data
                dbg_op_shift_cnt <= 0;
                dbg_dout_mem_valid <= 1;
                dbg_op_buf <= cnn_op_buffer_0[dbg_row_cnt];
                op_stm <= 5;
            end

            5: begin //debug, output in 8bits format
                dbg_dout_mem_valid <= 1;
                op_stm <= 5; // keep shifting

                if (dbg_op_ch == 0) begin
                    dbg_op_buf <= cnn_op_buffer_0[dbg_row_cnt];
                end else begin
                    dbg_op_buf <= cnn_op_buffer_1[dbg_row_cnt];
                end

                if (dbg_op_shift_cnt == 4) begin
                    if (dbg_row_cnt == CNN_W -1) begin
                        dbg_row_cnt <= 0;
                    end else begin
                        dbg_row_cnt <= dbg_row_cnt + 1;
                    end

                    if ((dbg_row_cnt == CNN_W-1) && (dbg_op_ch == 0)) begin //first channel finished
                        dbg_op_ch <= 1;
                    end

                    if ((dbg_row_cnt == CNN_W-1) && (dbg_op_ch == 1)) begin // second channel finished
                        // debug output over, output data to port
                        op_stm <= 2;
                    end
                end

                if (dbg_op_shift_cnt == 5) begin
                    dbg_op_shift_cnt <= 0;
                end else begin
                    dbg_op_shift_cnt <= dbg_op_shift_cnt + 1;
                    dbg_op_buf <= dbg_op_buf >> 8;
                end
            end

            default: op_stm <= 0;
        endcase
    end
end



assign dbg_dout_mem = dbg_dout_mem_valid ? dbg_op_buf[7:0] : 0;

wire dbg_dout_y_addr_valid = dbg_dout_yaddr_en ? mem_addr_valid : 0;
wire [7:0] dbg_dout_y_addr = dbg_dout_y_addr_valid ? mem_addr_y[7:0] : 0;

// debug output 
assign dbg_dout =   dbg_dout_mem | 
                    dbg_dout_rp  |
                    dbg_dout_y_addr;
assign dbg_dout_valid = dbg_dout_mem_valid |
                        dbg_dout_rp_valid  |
                        dbg_dout_y_addr_valid;

// output convert
generate
    genvar o_i;
    for (o_i = 0; o_i < CNN_W; o_i = o_i + 1) begin: output_to_cnn
        assign cnn_dout_ch0[CNN_W*o_i+CNN_W-1:CNN_W*o_i] = cnn_op_buffer_0[o_i]; // assign row by row
        assign cnn_dout_ch1[CNN_W*o_i+CNN_W-1:CNN_W*o_i] = cnn_op_buffer_1[o_i];
    end
endgenerate 

endmodule