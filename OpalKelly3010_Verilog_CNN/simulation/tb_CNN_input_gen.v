`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2019 10:55:44 AM
// Design Name: 
// Module Name: tb_region_histogram_gen
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


module tb_CNN_input_gen();

// debug reg
reg [7:0] dbg_reg;

// config 
reg signed [15:0] param_a;
reg signed [15:0] param_b;
reg signed [15:0] param_c;

// ext resource 
reg ext_dataIn_pos;
reg ext_dataIn_neg;
reg ext_cnn_rd_done;

reg clk;
reg reset;
reg reset_new=1;
reg [4:0] num_obj;
reg [8:0] region_x;
reg [8:0] region_y;
reg region_valid;
wire region_rd_en;
//reg [0:0]dataIn_pos, dataIn_neg;
wire [0:0]dataIn_pos, dataIn_neg;

wire [8:0] xAddressOut;
wire [8:0] yAddressOut;


reg [0:0] mem_din, mem_wen;
wire [0:0] mem_dout;
reg [7:0] mem_ini_addr_x, mem_ini_addr_y; 

wire [15:0] mem_addr = {yAddressOut[7:0], xAddressOut[7:0]} | {mem_ini_addr_y[7:0], mem_ini_addr_x[7:0]};


wire cnn_rd_region;
wire cnn_region_done;
wire cnn_region_valid;
wire cnn_region_x_bit;
wire cnn_region_y_bit;
wire cnn_region_clk;

reg cnn_rd_done;
wire cnn_ready;

reg region_done_empty_test;
reg region_valid_empty_test;

wire cnn_region_done_i = cnn_region_done | region_done_empty_test;
wire cnn_region_valid_i = cnn_region_valid | region_valid_empty_test;

RP2serial #(.MAX_NUM_OBJ(16))
    RP2serial_1(
    .clk(clk),
	.reset(reset),
    .reset_new(reset), //reset_new
    // interface to RP
    .num_obj(num_obj),
    .region_x(region_x),
    .region_y(region_y),
    .region_valid(region_valid),
    .region_rd_en(region_rd_en),

    // interface to CNN
    .cnn_rd_region(cnn_rd_region),
    .cnn_region_done(cnn_region_done),
    .cnn_region_valid(cnn_region_valid),
    .cnn_region_x_bit(cnn_region_x_bit),
    .cnn_region_y_bit(cnn_region_y_bit),
    .cnn_region_clk(cnn_region_clk)
);




CNN_input_gen #(.FILTERED_MEM_DELAY(2), .MAX_NUM_OBJ(16))
    CNN_input_gen_1(
    .clk(clk),
	.reset_n(~reset),

    // debug port
    .dbg_reg(dbg_reg),
    .dbg_dout_valid(),
    .dbg_dout(),

    // ext source
    .ext_dataIn_pos(ext_dataIn_pos),
    .ext_dataIn_neg(ext_dataIn_neg),
    .ext_xAddressOut(),
    .ext_cnn_done(),
    .ext_cnn_rd_done(ext_cnn_rd_done),
    .ext_cnn_ready(),

    // config
    .param_a(param_a),
    .param_b(param_b),
    .param_c(param_c),

    // interface to RP2serial
    .region_done(cnn_region_done_i),
    .region_x_bit(cnn_region_x_bit),
    .region_y_bit(cnn_region_y_bit),
    .region_bit_valid(cnn_region_valid_i),
    .region_rd_en(cnn_rd_region),
    .region_clk(cnn_region_clk),

    // interface to memory
    .dataIn_pos(dataIn_pos),
    .dataIn_neg(dataIn_neg),
    .xAddressOut(xAddressOut),
    .yAddressOut(yAddressOut),
    .cnn_done(),
    .cnn_read_valid(1),// not used
    
    .cnn_rd_done(cnn_rd_done),
    .cnn_ready(cnn_ready),
    .cnn_dout_ch0(), // 42x42
    .cnn_dout_ch1()  // 42x42
    

    );

blk_mem_gen_0 blk_mem_gen_0_1 (
  .clka(clk),    // input wire clka
  .wea(mem_wen),      // input wire [0 : 0] wea
  .addra(mem_addr),  // input wire [15 : 0] addra
  .dina(mem_din),    // input wire [0 : 0] dina
  .douta(mem_dout)  // output wire [0 : 0] douta
);

always
begin
    #10;
    clk = ~clk;    
end

// read and send done signal 
integer i;
task task_read_out;
input integer n;
begin
    for (i=0; i<n; i=i+1) begin
        $display ("read result no.%d", i+1);
        @ (posedge cnn_ready);
        #1000;
        @ (posedge clk); #1;
        cnn_rd_done = 1;
        @ (posedge clk); #1;
        cnn_rd_done = 0;
        #10;
    end
end
endtask


// load region file 
// integer data_file; // file handler
integer scan_file; // file handler
integer captured_data;
integer file_region_num;
integer f_i;
task get_region_from_file_and_output;
input integer data_file;
begin
    data_file = $fopen("/media/NEUPROWLER/Charles/IPs/IP_projects/region_histogram_gen/region_histogram_gen.srcs/sim_1/new/rp_file", "r");
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
    
    $display("region output done!");
end
endtask

// reg [0:0] mem_dout_delay;
// one extra clock delay
// always @(posedge clk) begin
//    #0.1;
//    dataIn_neg <= mem_dout;
//    dataIn_pos <= mem_dout;
// end

// no extra clock delay
assign dataIn_neg = mem_dout;
assign dataIn_pos = mem_dout;


// test empty regions
initial begin
    // region empty test 
    region_done_empty_test = 0;
    region_valid_empty_test = 0;

    @ (posedge cnn_region_done); #1;
    @ (negedge cnn_region_done); #75000;

    @ (posedge cnn_region_clk); #1;
    region_done_empty_test = 1;
    @ (posedge cnn_region_clk); #1;
    @ (posedge cnn_region_clk); #1;
    region_valid_empty_test = 1;
    @ (posedge cnn_region_clk); #1;
    region_valid_empty_test = 0;
    @ (posedge cnn_region_clk); #1;
    region_done_empty_test = 0;


end

integer ix,iy,cnt, tar_cnt;
integer rx1,rx2,rx3,rx4;
integer ry1,ry2,ry3,ry4;
initial begin
    clk                = 0;
    reset              = 0;
    num_obj            = 0;
    region_x           = 0;
    region_y           = 0;
    region_valid       = 0;
    
    

    
    
    // test read file
    // $display ("%g start read file", $time);
    // get_region_from_file_and_output("rp_file");
    // $display ("%g end read file", $time);

    // debug
    dbg_reg = 8'b0000_0000;


    //config 
    param_a = 1;
    param_b = 1;
    param_c = -7;
    
    cnn_rd_done = 0;

    // ext resource
    ext_dataIn_pos   = 1;
    ext_dataIn_neg   = 1;
    ext_cnn_rd_done  = 0;

    
    mem_ini_addr_x = 0;
    mem_ini_addr_y = 0;
    mem_din = 0;
    mem_wen = 0;

    //reset 
    #100
    reset = 1;
    #100
    reset = 0;
    #1000;

    //simulation 

    //fill in memory 

    //clean memory 
    $display ("%g clear memory", $time);
    for (ix = 0; ix<240; ix=ix+1) begin
        for (iy = 0; iy<180; iy=iy+1) begin
            @ (posedge clk); #1;
            mem_ini_addr_x = ix;
            mem_ini_addr_y = iy;
            mem_din = 0;
            mem_wen = 1;
        end
    end
    @ (posedge clk); #1;
    mem_ini_addr_x = 0;
    mem_ini_addr_y = 0;
    mem_din = 0;
    mem_wen = 0;
        

    #100;
    $display ("%g fill in memory, 1st region", $time);

    //region has two: 
    //first one (10,20)(30,40), dx=20, dy=20
    rx1 = 10;
    ry1 = 20;
    rx2 = 30;
    ry2 = 40;

    cnt = 0;
    tar_cnt = 0;
    for (iy = ry1; iy<=ry2; iy=iy+1) begin
        tar_cnt = tar_cnt + 1;
        cnt = 0;
        for (ix = rx1; ix<=rx2 ;ix=ix+1 ) begin
            @ (posedge clk); #1;
            mem_ini_addr_x = ix;
            mem_ini_addr_y = iy;
            mem_wen = 1;
            // if(cnt < tar_cnt) begin
                mem_din = 1;
                cnt = cnt + 1;
            // end else begin
            //     mem_din = 0;
            // end
        end
    end
    @ (posedge clk); #1;
    mem_ini_addr_x = 0;
    mem_ini_addr_y = 0;
    mem_din = 0;
    mem_wen = 0;


    #1000;

    //2nd (200,120)(230,160), dx=30, dy=40
    $display ("%g fill in memory, 2nd region", $time);


    rx3 = 200;
    ry3 = 120;
    rx4 = 230;
    ry4 = 160;
    
    cnt = 0;
    tar_cnt = 0;
    for (iy = ry3; iy<=ry4; iy=iy+1) begin
        tar_cnt = tar_cnt + 1;
        cnt = 0;
        for (ix = rx3; ix<=rx4 ;ix=ix+1 ) begin
            @ (posedge clk); #1;
            mem_ini_addr_x = ix;
            mem_ini_addr_y = iy;
            mem_wen = 1;
            // if(cnt < tar_cnt) begin
                mem_din = 1;
                cnt = cnt + 1;
            // end else begin
            //     mem_din = 0;
            // end
        end
    end
    @ (posedge clk); #1;
    mem_ini_addr_x = 0;
    mem_ini_addr_y = 0;
    mem_din = 0;
    mem_wen = 0;

    // #1000;
    // // meory read and test
    // $display ("%g memory read test", $time);

    // for (ix = 0; ix<240; ix=ix+1) begin
    //     for (iy = 0; iy<180; iy=iy+1) begin
    //         @ (posedge clk); #1;
    //         mem_ini_addr_x = ix;
    //         mem_ini_addr_y = iy;
    //         mem_din = 0;
    //         mem_wen = 0;
    //     end
    // end
    // @ (posedge clk); #1;
    // mem_ini_addr_x = 0;
    // mem_ini_addr_y = 0;
    // mem_din = 0;
    // mem_wen = 0;

    #1000;

    // feed in region 
    $display ("%g feed regions", $time);

    @ (posedge clk); #1;
    num_obj            = 4;
    region_x           = rx1;
    region_y           = ry1;
    region_valid       = 1;

    @ (posedge region_rd_en);
    @ (posedge clk); #1;
    region_x           = rx2;
    region_y           = ry2;
    region_valid       = 1;
    @ (posedge clk); #1;
    region_x           = rx3;
    region_y           = ry3;
    region_valid       = 1;
    @ (posedge clk); #1;
    region_x           = rx4;
    region_y           = ry4;
    region_valid       = 1;
    // add two noises
    // noise 1
    @ (posedge clk); #1;
    region_x           = 25;
    region_y           = 25;
    region_valid       = 1;
    @ (posedge clk); #1;
    region_x           = 27;
    region_y           = 27;
    region_valid       = 1;
    // noise 2
    @ (posedge clk); #1;
    region_x           = 88;
    region_y           = 88;
    region_valid       = 1;
    @ (posedge clk); #1;
    region_x           = 90;
    region_y           = 90;
    region_valid       = 1;

    @ (posedge clk); #1;
    num_obj            = 0;
    region_x           = 0;
    region_y           = 0;
    region_valid       = 0;

    $display ("%g feed regions over", $time);

    $display ("%g read results", $time);

    task_read_out(2);

    $display ("%g read over", $time);

    

    

//////////////////////////////////////////////////////////////////////////////////
    // send round test
    $display ("===============================================");
    #1000;
    $display ("%g clear memory", $time);

    //clean memory 
    for (ix = 0; ix<240; ix=ix+1) begin
        for (iy = 0; iy<180; iy=iy+1) begin
            @ (posedge clk); #1;
            mem_ini_addr_x = ix;
            mem_ini_addr_y = iy;
            mem_din = 0;
            mem_wen = 1;
        end
    end
    @ (posedge clk); #1;
    mem_ini_addr_x = 0;
    mem_ini_addr_y = 0;
    mem_din = 0;
    mem_wen = 0;

    #100;
    //region has two: 
    //first one (0,0)(40,60), dx=41, dy=61
    $display ("%g fill in memory, 1st region", $time);

    rx1 = 0;
    ry1 = 0;
    rx2 = 40;
    ry2 = 60;

    cnt = 0;
    tar_cnt = 0;
    for (iy = ry1; iy<=ry2; iy=iy+1) begin
        tar_cnt = tar_cnt + 1;
        cnt = 0;
        for (ix = rx1; ix<=rx2 ;ix=ix+1 ) begin
            @ (posedge clk); #1;
            mem_ini_addr_x = ix;
            mem_ini_addr_y = iy;
            mem_wen = 1;
            if(cnt < tar_cnt) begin
                mem_din = 1;
                cnt = cnt + 1;
            end else begin
                mem_din = 0;
            end
        end
    end
    @ (posedge clk); #1;
    mem_ini_addr_x = 0;
    mem_ini_addr_y = 0;
    mem_din = 0;
    mem_wen = 0;


    #1000;

     //2nd (220,140)(239,160), dx=30, dy=20
    $display ("%g fill in memory, 2nd region", $time);

     rx3 = 220;
     ry3 = 140;
     rx4 = 239;
     ry4 = 160;
    
     cnt = 0;
     tar_cnt = 0;
     for (iy = ry3; iy<=ry4; iy=iy+1) begin
         tar_cnt = tar_cnt + 1;
         cnt = 0;
         for (ix = rx3; ix<=rx4 ;ix=ix+1 ) begin
             @ (posedge clk); #1;
             mem_ini_addr_x = ix;
             mem_ini_addr_y = iy;
             mem_wen = 1;
             if(cnt < tar_cnt) begin
                 mem_din = 1;
                 cnt = cnt + 1;
             end else begin
                 mem_din = 0;
             end
         end
     end
     @ (posedge clk); #1;
     mem_ini_addr_x = 0;
     mem_ini_addr_y = 0;
     mem_din = 0;
     mem_wen = 0;

    // // meory read and test
    // for (ix = 0; ix<240; ix=ix+1) begin
    //     for (iy = 0; iy<180; iy=iy+1) begin
    //         @ (posedge clk); #1;
    //         mem_ini_addr_x = ix;
    //         mem_ini_addr_y = iy;
    //         mem_din = 0;
    //         mem_wen = 0;
    //     end
    // end
    // @ (posedge clk); #1;
    // mem_ini_addr_x = 0;
    // mem_ini_addr_y = 0;
    // mem_din = 0;
    // mem_wen = 0;

    #1000;

    // feed in region 
    $display ("%g feed regions", $time);

    $display ("%g start read file", $time);
    get_region_from_file_and_output("rp_file");
    $display ("%g end read file", $time);

    // @ (posedge clk); #1;
    // num_obj            = 2;
    // region_x           = rx1;
    // region_y           = ry1;
    // region_valid       = 1;

    // @ (posedge region_rd_en);
    // @ (posedge clk); #1;
    // num_obj            = 2;
    // region_x           = rx2;
    // region_y           = ry2;
    // region_valid       = 1;
    //  @ (posedge clk); #1;
    //  num_obj            = 2;
    //  region_x           = rx3;
    //  region_y           = ry3;
    //  region_valid       = 1;
    //  @ (posedge clk); #1;
    //  num_obj            = 2;
    //  region_x           = rx4;
    //  region_y           = ry4;
    //  region_valid       = 1;
    // @ (posedge clk); #1;
    // num_obj            = 0;
    // region_x           = 0;
    // region_y           = 0;
    // region_valid       = 0;


    $display ("%g feed regions over", $time);

    $display ("%g read results", $time);

    task_read_out(file_region_num);

    $display ("%g read over", $time);

    #1000;
    $stop;
end


initial begin
reset_new = 1;
# 50
reset_new = 0;
end

endmodule
