//------------------------------------------------------------------------
// okHostCalls.v
//
// Description:
//    This file is included by a test fixture designed to mimic FrontPanel
//    operations.  The functions and task below provide a pseudo
//    translation between the FrontPanel operations and the hi_in, hi_out,
//    and hi_inout signals.
//------------------------------------------------------------------------
// Copyright (c) 2005-2010 Opal Kelly Incorporated
// $Rev: 982 $ $Date: 2011-08-19 13:11:56 -0700 (Fri, 19 Aug 2011) $
//------------------------------------------------------------------------

//------------------------------------------------------------------------
// *  Do not edit any of the defines, registers, integers, arrays, or
//    functions below this point.
// *  Tasks in Verilog cannot pass arrays.  The pipe tasks utilize arrays
//    of data. If you require multiple pipe arrays, you may create new
//    arrays in the top level file (that `includes this file), duplicate
//    the pipe tasks below as required, change the names of the duplicated
//    tasks to unique identifiers, and alter the pipe array in those tasks
//    to your newly generated arrays in the top level file.
// *  For example, in the top level file, along with:
//       reg   [7:0] pipeIn [0:(pipeInSize-1)];
//       reg   [7:0] pipeOut [0:(pipeOutSize-1)];
//       - Add:   reg   [7:0] pipeIn2 [0:1023];
//       - Then, copy the WriteToPipeIn task here, rename it WriteToPipeIn2,
//         and finally change pipeIn[i] in WriteToPipeIn2 to pipeIn2[i].
//    The task and operation can then be called with a:
//       WriteToPipeIn2(8'h80, 1024);//endpoint 0x80 pipe received pipeIn2
//------------------------------------------------------------------------
// `include "parameters.v"

`define DNOP                  4'h0
`define DReset                4'h1
`define DUpdateWireIns        4'h3
`define DUpdateWireOuts       4'h5
`define DActivateTriggerIn    4'h6
`define DUpdateTriggerOuts    4'h7
`define DWriteToPipeIn        4'h9
`define DReadFromPipeOut      4'ha
`define DWriteToBlockPipeIn   4'hb
`define DReadFromBlockPipeOut 4'hc

//////////////////////////////////////////////////////////
//// created by xueyong
//// available pipes:   pipeIn1, pipeOut1
////                    pipeIn2, pipeOut2
////                    pipeIn3, pipeOut3
//////////////////////////////////////////////////////////

//---------------------------------------------------------
// WriteToPipeIn1
//---------------------------------------------------------
task WriteToPipeIn1 (
   input    [7:0]    ep,
   input    [31:0]   length
);
   integer           len, i, j, k, blockSize;
begin
   len = length/2; j = 0; k = 0; blockSize = 1024;
   if (length%2)
      $display("Error. Pipes commands may only send and receive an even # of bytes.");
   @(posedge hi_in[0]) hi_in[1] = 1;
   hi_in[7:4] = `DWriteToPipeIn;
   hi_dataout = {BlockDelayStates, ep};
   @(posedge hi_in[0]) hi_in[7:4] = `DNOP;
   hi_dataout = len;
   @(posedge hi_in[0]) hi_dataout = (len >> 16);
   for (i=0; i < length; i=i+2) begin
      @(posedge hi_in[0]);
      hi_dataout[7:0] = pipeIn1[i];
      hi_dataout[15:8] = pipeIn1[i+1];
      j=j+2;
      if (j == blockSize) begin
         for (k=0; k < BlockDelayStates; k=k+1) begin
            @(posedge hi_in[0]);
         end
         j=0;
      end
   end
   wait (hi_out[0] == 0);
end
endtask


//---------------------------------------------------------
// ReadFromPipeOut1
//---------------------------------------------------------
task ReadFromPipeOut1 (
   input    [7:0]    ep,
   input    [31:0]   length
);
   integer           len, i, j, k, blockSize;
begin
   len = length/2; i = 0; j = 0; k = 0; blockSize = 1024;
   if (length%2)
      $display("Error. Pipes commands may only send and receive an even # of bytes.");
   @(posedge hi_in[0]) hi_in[1] = 1;
   hi_in[7:4] = `DReadFromPipeOut;
   hi_dataout = {BlockDelayStates, ep};
   @(posedge hi_in[0]) hi_in[7:4] = `DNOP;
   hi_dataout = len;
   @(posedge hi_in[0]) hi_dataout = (len >> 16);
   @(posedge hi_in[0]) hi_in[1] = 0;
   for (i=0; i < length; i=i+2) begin
      @(posedge hi_in[0]);
      pipeOut1[i] = hi_inout[7:0];
      pipeOut1[i+1] = hi_inout[15:8];
      j=j+2;
      if (j == blockSize) begin
         for (k=0; k < BlockDelayStates; k=k+1) begin
            @(posedge hi_in[0]);
         end
         j=0;
      end
   end
   wait (hi_out[0] == 0);
end
endtask


//---------------------------------------------------------
// WriteToPipeIn2
//---------------------------------------------------------
task WriteToPipeIn2 (
   input    [7:0]    ep,
   input    [31:0]   length
);
   integer           len, i, j, k, blockSize;
begin
   len = length/2; j = 0; k = 0; blockSize = 1024;
   if (length%2)
      $display("Error. Pipes commands may only send and receive an even # of bytes.");
   @(posedge hi_in[0]) hi_in[1] = 1;
   hi_in[7:4] = `DWriteToPipeIn;
   hi_dataout = {BlockDelayStates, ep};
   @(posedge hi_in[0]) hi_in[7:4] = `DNOP;
   hi_dataout = len;
   @(posedge hi_in[0]) hi_dataout = (len >> 16);
   for (i=0; i < length; i=i+2) begin
      @(posedge hi_in[0]);
      hi_dataout[7:0] = pipeIn2[i];
      hi_dataout[15:8] = pipeIn2[i+1];
      j=j+2;
      if (j == blockSize) begin
         for (k=0; k < BlockDelayStates; k=k+1) begin
            @(posedge hi_in[0]);
         end
         j=0;
      end
   end
   wait (hi_out[0] == 0);
end
endtask


//---------------------------------------------------------
// ReadFromPipeOut2
//---------------------------------------------------------
task ReadFromPipeOut2 (
   input    [7:0]    ep,
   input    [31:0]   length
);
   integer           len, i, j, k, blockSize;
begin
   len = length/2; i = 0; j = 0; k = 0; blockSize = 1024;
   if (length%2)
      $display("Error. Pipes commands may only send and receive an even # of bytes.");
   @(posedge hi_in[0]) hi_in[1] = 1;
   hi_in[7:4] = `DReadFromPipeOut;
   hi_dataout = {BlockDelayStates, ep};
   @(posedge hi_in[0]) hi_in[7:4] = `DNOP;
   hi_dataout = len;
   @(posedge hi_in[0]) hi_dataout = (len >> 16);
   @(posedge hi_in[0]) hi_in[1] = 0;
   for (i=0; i < length; i=i+2) begin
      @(posedge hi_in[0]);
      pipeOut2[i] = hi_inout[7:0];
      pipeOut2[i+1] = hi_inout[15:8];
      j=j+2;
      if (j == blockSize) begin
         for (k=0; k < BlockDelayStates; k=k+1) begin
            @(posedge hi_in[0]);
         end
         j=0;
      end
   end
   wait (hi_out[0] == 0);
end
endtask



//---------------------------------------------------------
// WriteToPipeIn3
//---------------------------------------------------------
task WriteToPipeIn3 (
   input    [7:0]    ep,
   input    [31:0]   length
);
   integer           len, i, j, k, blockSize;
begin
   len = length/2; j = 0; k = 0; blockSize = 1024;
   if (length%2)
      $display("Error. Pipes commands may only send and receive an even # of bytes.");
   @(posedge hi_in[0]) hi_in[1] = 1;
   hi_in[7:4] = `DWriteToPipeIn;
   hi_dataout = {BlockDelayStates, ep};
   @(posedge hi_in[0]) hi_in[7:4] = `DNOP;
   hi_dataout = len;
   @(posedge hi_in[0]) hi_dataout = (len >> 16);
   for (i=0; i < length; i=i+2) begin
      @(posedge hi_in[0]);
      hi_dataout[7:0] = pipeIn3[i];
      hi_dataout[15:8] = pipeIn3[i+1];
      j=j+2;
      if (j == blockSize) begin
         for (k=0; k < BlockDelayStates; k=k+1) begin
            @(posedge hi_in[0]);
         end
         j=0;
      end
   end
   wait (hi_out[0] == 0);
end
endtask


//---------------------------------------------------------
// ReadFromPipeOut3
//---------------------------------------------------------
task ReadFromPipeOut3 (
   input    [7:0]    ep,
   input    [31:0]   length
);
   integer           len, i, j, k, blockSize;
begin
   len = length/2; i = 0; j = 0; k = 0; blockSize = 1024;
   if (length%2)
      $display("Error. Pipes commands may only send and receive an even # of bytes.");
   @(posedge hi_in[0]) hi_in[1] = 1;
   hi_in[7:4] = `DReadFromPipeOut;
   hi_dataout = {BlockDelayStates, ep};
   @(posedge hi_in[0]) hi_in[7:4] = `DNOP;
   hi_dataout = len;
   @(posedge hi_in[0]) hi_dataout = (len >> 16);
   @(posedge hi_in[0]) hi_in[1] = 0;
   for (i=0; i < length; i=i+2) begin
      @(posedge hi_in[0]);
      pipeOut3[i] = hi_inout[7:0];
      pipeOut3[i+1] = hi_inout[15:8];
      j=j+2;
      if (j == blockSize) begin
         for (k=0; k < BlockDelayStates; k=k+1) begin
            @(posedge hi_in[0]);
         end
         j=0;
      end
   end
   wait (hi_out[0] == 0);
end
endtask
