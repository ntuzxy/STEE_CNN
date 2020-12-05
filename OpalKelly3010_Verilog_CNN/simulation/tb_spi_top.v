`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:03:13 09/12/2020
// Design Name:   spi_top
// Module Name:   F:/STEE_PROJ/CONV//tb_spi_top.v
// Project Name:  CONV
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: spi_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_spi_top;

	// Inputs
	reg reset_n;
	wire clk_phase1;
	wire clk_phase2;
	wire capture;
	wire clk_update;
	wire spi_din;

	// Outputs
	wire spi_out;
	wire [15:0] config_reg0;
	wire [15:0] config_reg1;
	wire [15:0] config_reg2;
	wire [15:0] config_reg3;
	wire [15:0] config_reg4;
	wire [15:0] config_reg5;
	wire [15:0] config_reg6;
	wire [15:0] config_reg7;
	wire [15:0] config_reg8;
	wire [15:0] config_reg9;
	wire [15:0] config_reg10;
	wire [15:0] config_reg11;
	wire [15:0] config_reg12;
	wire [15:0] config_reg13;
	wire [15:0] config_reg14;
	wire [15:0] config_reg15;
	wire [15:0] config_reg16;
	wire [15:0] config_reg17;
	wire [15:0] config_reg18;
	wire [15:0] config_reg19;
	wire [15:0] config_reg20;
	wire [15:0] config_reg21;
	wire [15:0] config_reg22;
	wire [15:0] config_reg23;
	wire [15:0] config_reg24;
	wire [15:0] config_reg25;
	wire [15:0] config_reg26;
	wire [15:0] config_reg27;
	wire [15:0] config_reg28;
	wire [15:0] config_reg29;
	wire [15:0] config_reg30;
	wire [15:0] config_reg31;
	wire [15:0] config_reg32;
	wire [15:0] config_reg33;
	wire [15:0] config_reg34;
	wire [15:0] config_reg35;
	wire [15:0] config_reg36;
	wire [15:0] config_reg37;
	wire [15:0] config_reg38;
	wire [15:0] config_reg39;
	wire [15:0] config_reg40;
	wire [15:0] config_reg41;
	wire [15:0] config_reg42;
	wire [15:0] config_reg43;
	wire [15:0] config_reg44;
	wire [15:0] config_reg45;
	wire [15:0] config_reg46;
	wire [15:0] config_reg47;
	wire [15:0] config_reg48;
	wire [15:0] config_reg49;
	wire [15:0] config_reg50;
	wire [15:0] config_reg51;
	wire [15:0] config_reg52;
	wire [15:0] config_reg53;
	wire [15:0] config_reg54;
	wire [15:0] config_reg55;
	wire [15:0] config_reg56;
	wire [15:0] config_reg57;
	wire [15:0] config_reg58;
	wire [15:0] config_reg59;
	wire [15:0] config_reg60;
	wire [15:0] config_reg61;
	wire [15:0] config_reg62;
	wire [15:0] config_reg63;
	wire [15:0] config_reg64;
	wire [15:0] config_reg65;
	wire [15:0] config_reg66;
	wire [15:0] config_reg67;
	wire [15:0] config_reg68;
	wire [15:0] config_reg69;
	wire [15:0] config_reg70;
	wire [15:0] config_reg71;
	wire [15:0] config_reg72;
	wire [15:0] config_reg73;
	wire [15:0] config_reg74;
	wire [15:0] config_reg75;
	wire [15:0] config_reg76;
	wire [15:0] config_reg77;
	wire [15:0] config_reg78;
	wire [15:0] config_reg79;
	wire [15:0] config_reg80;
	wire [15:0] config_reg81;
	wire [15:0] config_reg82;
	wire [15:0] config_reg83;
	wire [15:0] config_reg84;
	wire [15:0] config_reg85;
	wire [15:0] config_reg86;
	wire [15:0] config_reg87;
	wire [15:0] config_reg88;
	wire [15:0] config_reg89;
	wire [15:0] config_reg90;
	wire [15:0] config_reg91;
	wire [15:0] config_reg92;
	wire [15:0] config_reg93;
	wire [15:0] config_reg94;
	wire [15:0] config_reg95;
	wire [15:0] config_reg96;
	wire [15:0] config_reg97;
	wire [15:0] config_reg98;
	wire [15:0] config_reg99;
	wire [15:0] config_reg100;
	wire [15:0] config_reg101;
	wire [15:0] config_reg102;
	wire [15:0] config_reg103;
	wire [15:0] config_reg104;
	wire [15:0] config_reg105;
	wire [15:0] config_reg106;
	wire [15:0] config_reg107;
	wire [15:0] config_reg108;
	wire [15:0] config_reg109;
	wire [15:0] config_reg110;
	wire [15:0] config_reg111;
	wire [15:0] config_reg112;
	wire [15:0] config_reg113;
	wire [15:0] config_reg114;
	wire [15:0] config_reg115;
	wire [15:0] config_reg116;
	wire [15:0] config_reg117;
	wire [15:0] config_reg118;
	wire [15:0] config_reg119;
	wire [15:0] config_reg120;
	wire [15:0] config_reg121;
	wire [15:0] config_reg122;
	wire [15:0] config_reg123;
	wire [15:0] config_reg124;
	wire [15:0] config_reg125;
	wire [15:0] config_reg126;
	wire [15:0] config_reg127;

	// Instantiate the Unit Under Test (UUT)
	spi_top uut (
		.reset_n(reset_n), 
		.clk_phase1(clk_phase1), 
		.clk_phase2(clk_phase2), 
		.capture(capture), 
		.clk_update(clk_update), 
		.spi_din(spi_din), 
		.spi_out(spi_out), 
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




//////////////////////////////////////////////////////////////////
// opall kell interface bus:
wire        ti_clk; //48 MHz from okHost
wire [30:0] ok1;
wire [16:0] ok2;
// wire [7:0]  hi_in;
reg  [7:0]  hi_in;
wire [1:0]  hi_out;
wire [15:0] hi_inout;
wire        i2c_sda;
wire        i2c_scl;
wire        hi_muxsel;

assign i2c_sda = 1'bz;
assign i2c_scl = 1'bz;
assign hi_muxsel = 1'b0;

// Endpoint connections:
wire [15:0]     wi00_data;
wire [15:0]     wi01_data;
wire [15:0]     wi02_data;

wire [15:0]     wo20_data;
wire [15:0]     wo21_data;

wire [15:0]     ti40_trig;
wire [15:0]     ti41_trig;

reg  [15:0]     to60_trig;
reg  [15:0]     to61_trig;

wire            pi80_write;
wire            pi81_write;

wire [15:0]     pi80_data;
wire [15:0]     pi81_data;

wire            poa0_read;
wire            poa1_read;

wire [15:0]     poa0_data;
wire [15:0]     poa1_data;


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
wire [8*17-1:0]  ok2x; // Adjust size of ok2x to fit the number of outgoing FrontPanel endpoints in your design [n*17-1:0]
okWireOR # (.N(8)) wireOR (ok2, ok2x);// Adjust N to fit the number of outgoing FrontPanel endpoints in your design (.N(n))
okHost okHI(
    .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .ti_clk(ti_clk),
    .ok1(ok1), .ok2(ok2)); //Host interfaces directly with FPGA pins

//Opal Kelly communicates with host PC 
okWireIn     ep00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(wi00_data));
okWireIn     ep01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(wi01_data));
okWireIn     ep02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(wi02_data));
okWireOut    ep20 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(wo20_data));
okWireOut    ep21 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h21), .ep_datain(wo21_data));
okTriggerIn  ep40 (.ok1(ok1),                           .ep_addr(8'h40), .ep_clk(ti_clk), .ep_trigger(ti40_trig));
okTriggerIn  ep41 (.ok1(ok1),                           .ep_addr(8'h41), .ep_clk(ti_clk), .ep_trigger(ti41_trig));
okTriggerOut ep60 (.ok1(ok1), .ok2(ok2x[ 2*17 +: 17 ]), .ep_addr(8'h60), .ep_clk(ti_clk), .ep_trigger(to60_trig));
okTriggerOut ep61 (.ok1(ok1), .ok2(ok2x[ 3*17 +: 17 ]), .ep_addr(8'h60), .ep_clk(ti_clk), .ep_trigger(to61_trig));
okPipeIn     ep80 (.ok1(ok1), .ok2(ok2x[ 4*17 +: 17 ]), .ep_addr(8'h80), .ep_write(pi80_write), .ep_dataout(pi80_data));
okPipeIn     ep81 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'h81), .ep_write(pi81_write), .ep_dataout(pi81_data));
okPipeOut    epa0 (.ok1(ok1), .ok2(ok2x[ 6*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(poa0_read), .ep_datain(poa0_data));
okPipeOut    epa1 (.ok1(ok1), .ok2(ok2x[ 7*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(poa1_read), .ep_datain(poa1_data));




//------------------------------------------------------------------------
// Begin okHostInterface simulation user configurable  global data
//------------------------------------------------------------------------
parameter BlockDelayStates = 5;   // REQUIRED: # of clocks between blocks of pipe data
parameter ReadyCheckDelay = 5;    // REQUIRED: # of clocks before block transfer before
                                  //           host interface checks for ready (0-255)
parameter PostReadyDelay = 5;     // REQUIRED: # of clocks after ready is asserted and
                                  //           check that the block transfer begins (0-255)
parameter pipeInSize = 1024;      // REQUIRED: byte (must be even) length of default
                                  //           PipeIn; Integer 0-2^32
parameter pipeOutSize = 1024;     // REQUIRED: byte (must be even) length of default
                                  //           PipeOut; Integer 0-2^32

integer k;
reg  [7:0]  pipeIn [0:(pipeInSize-1)];
initial for (k=0; k<pipeInSize; k=k+1) pipeIn[k] = 8'h00;

reg  [7:0]  pipeOut [0:(pipeOutSize-1)];
initial for (k=0; k<pipeOutSize; k=k+1) pipeOut[k] = 8'h00;

`include "../simulation/okHost/okHostCalls.v"   // Do not remove!  The tasks, functions, and data stored in okHostCalls.v must be included here.
//------------------------------------------------------------------------
//  Available User Task and Function Calls:
//    FrontPanelReset;                  // Always start routine with FrontPanelReset;
//    SetWireInValue(ep, val, mask);
//    UpdateWireIns;
//    UpdateWireOuts;
//    GetWireOutValue(ep);
//    ActivateTriggerIn(ep, bit);       // bit is an integer 0-15
//    UpdateTriggerOuts;
//    IsTriggered(ep, mask);            // Returns a 1 or 0
//    WriteToPipeIn(ep, length);        // passes pipeIn array data
//    ReadFromPipeOut(ep, length);      // passes data to pipeOut array
//    WriteToBlockPipeIn(ep, blockSize, length);    // pass pipeIn array data; blockSize and length are integers
//    ReadFromBlockPipeOut(ep, blockSize, length);  // pass data to pipeOut array; blockSize and length are integers
//
//    *Pipes operate by passing arrays of data back and forth to the user's
//    design.  If you need multiple arrays, you can create a new procedure
//    above and connect it to a differnet array.  More information is
//    available in Opal Kelly documentation and online support tutorial.
//------------------------------------------------------------------------

// User configurable block of called FrontPanel operations.
reg  [15:0] wo_data;
initial wo_data = 0;

localparam ARRAY_WIDTH = 16;
localparam ADDR_WIDTH = 7;
localparam ARRAY_DEPTH = 2**ADDR_WIDTH;
reg [ARRAY_WIDTH-1:0] config_data [0:ARRAY_DEPTH-1];
reg [ADDR_WIDTH-1:0]  config_addr [0:ARRAY_DEPTH-1];
initial for (k=0; k<ARRAY_DEPTH; k=k+1) config_data[k] = k; //16'h0000;
initial for (k=0; k<ARRAY_DEPTH; k=k+1) config_addr[k] = k; //7'h00;


initial begin
	FrontPanelReset; 	// Start routine with FrontPanelReset;


    SetWireInValue(8'h01,63,16'hffff); // addr; 
    UpdateWireIns;
    SetWireInValue(8'h02,32767,16'hffff); // data; 
    UpdateWireIns;
	ActivateTriggerIn(8'h41, 0);       // bit is an integer 0-15
	UpdateTriggerOuts;
	ActivateTriggerIn(8'h41, 1);       // bit is an integer 0-15
	UpdateTriggerOuts;

	UpdateWireOuts;
	wo_data = GetWireOutValue(8'h20);
	if (wo_data == wi02_data) 
		$display("SUCCESS -- Address: 0d%03d   WriteIn: 0x%04h   ReadOut: 0x%04h", wi01_data[6:0], wi02_data, wo_data);
	else
		$display("FAILURE -- Address: 0d%03d   WriteIn: 0x%04h   ReadOut: 0x%04h", wi01_data[6:0], wi02_data, wo_data);



	for (k=0; k<ARRAY_DEPTH; k=k+1) begin
		SetWireInValue(8'h01, config_addr[k], 16'hffff); // addr;
		SetWireInValue(8'h02, config_data[k], 16'hffff); // data; 
		UpdateWireIns;                      
		ActivateTriggerIn(8'h41, 0);       // bit is an integer 0-15
		UpdateTriggerOuts;
		ActivateTriggerIn(8'h41, 1);       // bit is an integer 0-15
		UpdateTriggerOuts;

		UpdateWireOuts;
		wo_data = GetWireOutValue(8'h20);
		if (wo_data == wi02_data) 
			$display("SUCCESS -- Address: 0d%03d   WriteIn: 0x%04h   ReadOut: 0x%04h", wi01_data[6:0], wi02_data, wo_data);
		else
			$display("SUCCESS -- Address: 0d%03d   WriteIn: 0x%04h   ReadOut: 0x%04h", wi01_data[6:0], wi02_data, wo_data);
	end

	$stop;
end




reg clk;
initial begin	
	clk <= 1'b0;
	reset_n <= 1'b0;
	#1000 reset_n <= 1'b1;
end 

always begin
	#10 clk <= ~clk;
end


reg [22:0] data_in1; // ARRAY_WIDTH + ADDR_WIDTH = 16+7 =23
reg [23:0] update;
reg [23:0] clk_capture;
reg [23:0] data_out;
reg [4:0] counter3;


assign clk_phase1 = clk;
assign clk_phase2 = ~clk;
assign clk_update = update[0];
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


endmodule

