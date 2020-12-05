`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:15:33 07/08/2020
// Design Name:   Testing_TOP
// Module Name:   C:/Users/Zhang/Desktop/XEM3010_120620_V2/OpalKelly3010_Verilog/implementation/Testing_TOP_sim.v
// Project Name:  OpalKelly3010_Verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Testing_TOP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module OK_TOP_sim;

 // Inputs
 reg [7:0] hi_in;
 wire clk1;
 reg D1_BiasAddrSel;
 reg D1_BiasBitIN;
 reg D1_BiasClock;
 reg D1_BiasDiagSel;
 reg D1_BiasLatch;
 reg D1_nAckChip;
 reg RD_OUT;
 reg RD_PRGS;
 reg XTX;
 reg XTX_DONE;
 reg YTX;
 reg YTX_DONE;
 reg SIG_OBS1;
 reg SIG_OBS2;
 reg SUPPLY_UP;
 reg RE_DONE;
 reg RE_VALID;
 reg RE_X;
 reg RE_Y;
 reg SPI_OUT;

 // Outputs
 wire [1:0] hi_out;
 wire i2c_sda;
 wire i2c_scl;
 wire hi_muxsel;
 wire CLK_AER;
 wire CLK_EXT;
 wire RESET_N;
 wire D1_AERMonadd0;
 wire D1_AERMonadd1;
 wire D1_AERMonadd2;
 wire D1_AERMonadd3;
 wire D1_AERMonadd4;
 wire D1_AERMonadd5;
 wire D1_AERMonadd6;
 wire D1_AERMonadd7;
 wire D1_AERMonadd8;
 wire D1_AERMonadd9;
 wire D1_nReq;
 wire REGION_RD;
 wire CLK_PHS1;
 wire CLK_PHS2;
 wire CLK_UPDATE;
 wire SPI_DIN;
 wire CAPTURE;
 wire XDRE_SCE0_P;
 wire XDCE_SCE1_P;
 wire XES_SCE2_P;
 wire XSI_SCE3_P;
 wire XTRS_SCE4_P;
 wire XSDQ_SCE5_P;
 wire XSE_SCE6_P;
 wire XRGD_SCE7_P;
 wire XMC_SCE8_P;
 wire SST0_P;
 wire SST1_P;
 wire XRE_SST2_P;
 wire XIDO_SST3_P;
 wire XIDI_SST4_P;
 wire XE_CLK_P;
 wire XEQ_SD_P;
 wire XRR_SSUA_P;
 wire XRP_SLC_P;
 wire XWD_SWF_P;
 wire XWR_SWD_P;
 wire [7:0] led;

 // Bidirs
 wire [15:0] hi_inout;

// parameter X_LENGTH          = 320;
// parameter Y_DEPTH           = 240;
parameter X_LENGTH          = 16;
parameter Y_DEPTH           = 12;

 // Instantiate the Unit Under Test (UUT)
OK_TOP  
    #(//Parameters :
        .X_LENGTH     (X_LENGTH),
        .Y_DEPTH      (Y_DEPTH),
        .X_ADDR_WIDTH (9),
        .Y_ADDR_WIDTH (8),
        .NUM_OBJ_MAX  (4)

        // .X_LENGTH     (320),
        // .Y_DEPTH      (240),
        // .X_ADDR_WIDTH (9),
        // .Y_ADDR_WIDTH (8),
        // .NUM_OBJ_MAX  (4)
    )
    uut
    (
     .hi_in(hi_in), 
     .hi_out(hi_out), 
     .hi_inout(hi_inout), 
     .i2c_sda(i2c_sda), 
     .i2c_scl(i2c_scl), 
     .hi_muxsel(hi_muxsel), 
     .clk1(clk1), 
     .CLK_AER(CLK_AER), 
     .CLK_EXT(CLK_EXT), 
     .RESET_N(RESET_N), 
     .D1_AERMonadd0(D1_AERMonadd0), 
     .D1_AERMonadd1(D1_AERMonadd1), 
     .D1_AERMonadd2(D1_AERMonadd2), 
     .D1_AERMonadd3(D1_AERMonadd3), 
     .D1_AERMonadd4(D1_AERMonadd4), 
     .D1_AERMonadd5(D1_AERMonadd5), 
     .D1_AERMonadd6(D1_AERMonadd6), 
     .D1_AERMonadd7(D1_AERMonadd7), 
     .D1_AERMonadd8(D1_AERMonadd8), 
     .D1_AERMonadd9(D1_AERMonadd9), 
     .D1_nReq(D1_nReq), 
     .REGION_RD(REGION_RD), 
     .CLK_PHS1(CLK_PHS1), 
     .CLK_PHS2(CLK_PHS2), 
     .CLK_UPDATE(CLK_UPDATE), 
     .SPI_DIN(SPI_DIN), 
     .CAPTURE(CAPTURE), 
     .XDRE_SCE0_P(XDRE_SCE0_P), 
     .XDCE_SCE1_P(XDCE_SCE1_P), 
     .XES_SCE2_P(XES_SCE2_P), 
     .XSI_SCE3_P(XSI_SCE3_P), 
     .XTRS_SCE4_P(XTRS_SCE4_P), 
     .XSDQ_SCE5_P(XSDQ_SCE5_P), 
     .XSE_SCE6_P(XSE_SCE6_P), 
     .XRGD_SCE7_P(XRGD_SCE7_P), 
     .XMC_SCE8_P(XMC_SCE8_P), 
     .SST0_P(SST0_P), 
     .SST1_P(SST1_P), 
     .XRE_SST2_P(XRE_SST2_P), 
     .XIDO_SST3_P(XIDO_SST3_P), 
     .XIDI_SST4_P(XIDI_SST4_P), 
     .XE_CLK_P(XE_CLK_P), 
     .XEQ_SD_P(XEQ_SD_P), 
     .XRR_SSUA_P(XRR_SSUA_P), 
     .XRP_SLC_P(XRP_SLC_P), 
     .XWD_SWF_P(XWD_SWF_P), 
     .XWR_SWD_P(XWR_SWD_P), 
     .led(led), 
     .D1_BiasAddrSel(D1_BiasAddrSel), 
     .D1_BiasBitIN(D1_BiasBitIN), 
     .D1_BiasClock(D1_BiasClock), 
     .D1_BiasDiagSel(D1_BiasDiagSel), 
     .D1_BiasLatch(D1_BiasLatch), 
     .D1_nAckChip(D1_nAckChip), 
     .RD_OUT(RD_OUT), 
     .RD_PRGS(RD_PRGS), 
     .XTX(XTX), 
     .XTX_DONE(XTX_DONE), 
     .YTX(YTX), 
     .YTX_DONE(YTX_DONE), 
     .SIG_OBS1(SIG_OBS1), 
     .SIG_OBS2(SIG_OBS2), 
     .SUPPLY_UP(SUPPLY_UP), 
     .RE_DONE(RE_DONE), 
     .RE_VALID(RE_VALID), 
     .RE_X(RE_X), 
     .RE_Y(RE_Y), 
     .SPI_OUT(SPI_OUT)
 );

 initial begin
     // Initialize Inputs
     // hi_in = 0;
     // clk1 = 0;
     D1_BiasAddrSel = 0;
     D1_BiasBitIN = 0;
     D1_BiasClock = 0;
     D1_BiasDiagSel = 0;
     D1_BiasLatch = 0;
     D1_nAckChip = 0;
     RD_OUT = 0;
     RD_PRGS = 0;
     XTX = 0;
     XTX_DONE = 0;
     YTX = 0;
     YTX_DONE = 0;
     SIG_OBS1 = 0;
     SIG_OBS2 = 0;
     SUPPLY_UP = 0;
     RE_DONE = 0;
     RE_VALID = 0;
     RE_X = 0;
     RE_Y = 0;
     SPI_OUT = 0;

     // Wait 100 ns for global reset to finish
     #100;
        
     // Add stimulus here

 end



    reg clk;
    initial clk = 0;
    always #5 clk = ~clk;

    assign clk1 = clk;

 initial begin
     // Initialize Inputs
     hi_in = 0;
     clk = 0;

     // Wait 100 ns for global reset to finish
     #100;
        
     // Add stimulus here

 end
      
reg  data[1:pipeInSize/2];
reg  ddata[1:pipeInSize]; 

reg  [15:0] N_SPI_bits;
initial N_SPI_bits = 0;


//------------------------------------------------------------------------
// Begin okHostInterface simulation user configurable  global data
//------------------------------------------------------------------------
parameter BlockDelayStates = 5;     // REQUIRED: # of clocks between blocks of pipe data
parameter ReadyCheckDelay = 5;      // REQUIRED: # of clocks before block transfer before host interface checks for ready (0-255)
parameter PostReadyDelay = 5;       // REQUIRED: # of clocks after ready is asserted and check that the block transfer begins (0-255)
parameter pipeInSize = X_LENGTH*Y_DEPTH*2;   // REQUIRED: byte (must be even) length of default PipeIn; Integer 0-2^32
parameter pipeOutSize = X_LENGTH*Y_DEPTH*2;  // REQUIRED: byte (must be even) length of default PipeOut; Integer 0-2^32
parameter pipeInSize1 = X_LENGTH*Y_DEPTH*2; 
parameter pipeOutSize1 = X_LENGTH*Y_DEPTH*2;
parameter pipeOutSize2 = X_LENGTH*Y_DEPTH*2;
reg     pipeIn [0:(pipeInSize-1)];      //PipeIn 1bit data
reg     pipeOut [0:(pipeOutSize-1)];    //PipeOut 1bit data
reg     pipeOut1 [0:(pipeOutSize1-1)];    //PipeOut 1bit data
reg     pipeOut2 [0:(pipeOutSize2-1)];    //PipeOut 1bit data
reg     pipetmp [0:(pipeInSize-1)];     // Data Check Array
integer k, e;
initial k = 0;
initial e = 0;
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
initial begin
    FrontPanelReset;    // Start routine with FrontPanelReset;
    $display("//// Beginning Tests at:                           %dns   /////", $time);

    ////LED setting
    SetWireInValue(8'h00,16'h01,16'hffff); 
    UpdateWireIns;

    $display("//// Initialize PipeIn start at:                   %dns   /////", $time);
    ////parameters setting
    // SetWireInValue(8'h07,1,16'h0001); // rst_n; 
    // UpdateWireIns;
    SetWireInValue(8'h07,0,16'h0001); // rst_n; 
    UpdateWireIns;
    SetWireInValue(8'h07,1,16'h0001); // rst_n; 
    UpdateWireIns;


////
// ActivateTriggerIn(8'h41, 16'h0000); UpdateTriggerOuts;

    ////WrData
    // SetWireInValue(8'h02,1,16'h0001); // WrData; 
    // UpdateWireIns;



    //// Initialize PipeIn with random data
    // for (k=0; k<pipeInSize; k=k+1) pipeIn[k] = $random;

    ////read file
    //fp_r=$fopen("dd.txt","r");
    //$fscanf(fp_r, "%o", ddata);
    //file_id = $fread("ddata.txt", "r"); 
    for (k=1; k<pipeInSize/2+1; k=k+1) data[k]=0; 
    for (k=1; k<pipeInSize+1; k=k+1) ddata[k]=0; 
    $readmemh("../data_input/ddata.txt",data);
    for (k=1; k<pipeInSize+1; k=k+1) ddata[2*k-1] = data[k]; //data is 8bit based while ddata is 16bit based (for each value, lower 8bit is same as data and higher 8bit is 0)
    for (k=1; k<pipeInSize+1; k=k+1) pipeIn[k-1] = ddata[k]; 
    for (k=0; k<pipeInSize; k=k+1) pipetmp[k] = ddata[k+1];
    // Clear PipeOut
    for (k=0; k<pipeOutSize; k=k+1) pipeOut[k] = 8'h00;
    $display("//// Initialize PipeIn finish at:                   %dns   /////", $time);
    
    // mem clear
    SetWireInValue(8'h00,4,16'h0004); // auto clear after reading
    UpdateWireIns;
    
    #50;
    $display("//// Data pipeIn start at:                        %dns   /////", $time);
    WriteToPipeIn(8'h80,pipeInSize);//write configure data into FPGA
    $display("//// Data pipeIn finish at:                       %dns   /////", $time);

    SetWireInValue(8'h10,0,16'hffff); // addr_x_start
    UpdateWireIns;
    SetWireInValue(8'h11,0,16'hffff); // addr_y_start
    UpdateWireIns;
    SetWireInValue(8'h12,15,16'hffff); // addr_x_stop
    UpdateWireIns;
    SetWireInValue(8'h13,11,16'hffff); // addr_y_stop
    UpdateWireIns;

    $display("//// setting WrReq & RdReq   /////");
    SetWireInValue(8'h01,3,16'h0003); // wr
    UpdateWireIns;
    SetWireInValue(8'h01,0,16'h0003); //
    UpdateWireIns;
    #50000;
    SetWireInValue(8'h01,2,16'h0003); // rd
    UpdateWireIns;
    SetWireInValue(8'h01,0,16'h0003); // 
    UpdateWireIns;
    #50000;
    SetWireInValue(8'h01,2,16'h0003); // rd
    UpdateWireIns;
    SetWireInValue(8'h01,0,16'h0003); // 
    UpdateWireIns;
    #50000;
    #50;



    // mem clear
    SetWireInValue(8'h00,8,16'h0008); // force clear
    UpdateWireIns;

    // UpdateWireOuts;
    // $display("//// GetWireOutValue start at:                    %dns   /////", $time);
    // N_SPI_bits=GetWireOutValue(8'h20);//read out the Address1_tmp. 
    // $display("//// GetWireOutValue finish at:                   %dns   /////", $time);


    $display("//// ReadFromPipeOut start at:                    %dns   /////", $time);
    ReadFromPipeOut(8'ha1,pipeOutSize);
    $display("//// ReadFromPipeOut finish at:                   %dns   /////", $time);
    // ReadFromPipeOut(8'ha1,pipeOutSize1);
    ReadFromPipeOut(8'ha0,pipeOutSize2);

    // SetWireInValue(8'h01, 16'h0001, 16'hffff);//rst=1
    // UpdateWireIns;


    // Test read-back data.
    e=0;
    for (k=0; k<pipeInSize; k=k+1) begin 
        if (pipeOut[k] != pipetmp[k]) begin
            e=e+1;  // Keep track of the number of errors
            $display(" ");
            $display("Error! Data mismatch at byte %d:   Expected: 0x%08x    Read: 0x%08x", k, pipetmp[k], pipeOut[k]);
        end
    end
    
    if (e == 0) begin
        $display(" ");
        $display("Success! All data passes readback.");
    end

    $display("Simulation done at: %dns", $time);
    $stop;

end

`include "../simulation/okHost/okHostCalls.v"   // Do not remove!  The tasks, functions, and data stored in okHostCalls.v must be included here.      
      
endmodule