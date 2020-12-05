//****************************************************************************** */
//*                                                                              */
//*STATEMENT OF USE                                                              */
//*                                                                              */
//*This information contains confidential and proprietary information of TSMC.   */
//*No part of this information may be reproduced, transmitted, transcribed,      */
//*stored in a retrieval system, or translated into any human or computer        */
//*language, in any form or by any means, electronic, mechanical, magnetic,      */
//*optical, chemical, manual, or otherwise, without the prior written permission */
//*of TSMC. This information was prepared for informational purpose and is for   */
//*use by TSMC's customers only. TSMC reserves the right to make changes in the  */
//*information at any time and without notice.                                   */
//*                                                                              */
//****************************************************************************** */
//*                                                                              */
//*      Usage Limitation: PLEASE READ CAREFULLY FOR CORRECT USAGE               */
//*                                                                              */
//* The model doesn't support the control enable, data and address signals       */
//* transition at positive clock edge.                                           */
//* Please have some timing delays between control/data/address and clock signals*/
//* to ensure the correct behavior.                                              */
//*                                                                              */
//* Please be careful when using non 2^n  memory.                                */
//* In a non-fully decoded array, a write cycle to a nonexistent address location*/
//* does not change the memory array contents and output remains the same.       */
//* In a non-fully decoded array, a read cycle to a nonexistent address location */
//* does not change the memory array contents but the output becomes unknown.    */
//*                                                                              */
//* In the verilog model, the behavior of unknown clock will corrupt the         */
//* memory data and make output unknown regardless of CEB signal.  But in the    */
//* silicon, the unknown clock at CEB high, the memory and output data will be   */
//* held. The verilog model behavior is more conservative in this condition.     */
//*                                                                              */
//* The model doesn't identify physical column and row address                   */
//*                                                                              */
//* The verilog model provides UNIT_DELAY mode for the fast function simulation. */
//* All timing values in the specification are not checked in the UNIT_DELAY mode*/
//* simulation.                                                                  */
//*                                                                              */
//* The critical contention timings, tcc, is not checked in the UNIT_DELAY mode  */
//* simulation.  If addresses of read and write operations are the same and the  */
//* real time of the positive edge of CLKA and CLKB are identical the same,      */
//* it will be treated as a read/write port contention.                          */ 
//*                                                                              */
//* Please use the verilog simulator version with $recrem timing check support.  */
//* Some earlier simulator versions might support $recovery only, not $recrem.   */
//*                                                                              */
//****************************************************************************** */
//*      Macro Usage       : (+define[MACRO] for Verilog compiliers)             */
//* +UNIT_DELAY : Enable fast function simulation.                              */
//* +no_warning : Disable all runtime warnings message from this model.          */
//* +TSMC_INITIALIZE_MEM : Initialize the memory data in verilog format.         */
//* +TSMC_INITIALIZE_FAULT : Initialize the memory fault data in verilog format. */
//****************************************************************************** */
//*        Compiler Version : TSMC MEMORY COMPILER tsn65lplldpsram_2006.09.01.d.200a */
//*        Memory Type      : TSMC 65nm Low Power Low Leakage Dual Port SRAM Memory */
//*        Library Name     : tsdn65lplla16384x2m8s (user specify : TSDN65LPLLA16384X2M8S) */
//*        Library Version  : 200a */
//*        Generated Time   : 2020/04/17, 12:05:44 */
//*************************************************************************** ** */

//xy20201024
`define UNIT_DELAY
`define TSMC_INITIALIZE_MEM

`resetall
`celldefine

`timescale 1ns/1ps
`delay_mode_path
`suppress_faults
`enable_portfaults

`ifdef UNIT_DELAY
`define SRAM_DELAY 0.010
`endif

module TSDN65LPLLA16384X2M8S
  (AA,
  DA,
  BWEBA,
  WEBA,CEBA,CLKA,
  AB,
  DB,
  BWEBB,
  WEBB,CEBB,CLKB,
  QA,
  QB);


// Parameter declarations
parameter  N = 2;
parameter  W = 16384;
parameter  M = 14;

// Input-Output declarations
   input [M-1:0] AA;
   input [N-1:0] DA;                
   input [N-1:0] BWEBA;             
   input WEBA;                     
   input CEBA;                    
   input CLKA;                   
   input [M-1:0] AB;            
   input [N-1:0] DB;           
   input [N-1:0] BWEBB;       
   input WEBB;               
   input CEBB;              
   input CLKB;  
   output [N-1:0] QA;         
   output [N-1:0] QB;        

`ifdef no_warning
parameter MES_ALL = "OFF";
`else
parameter MES_ALL = "ON";
`endif

`ifdef TSMC_INITIALIZE_MEM
  parameter cdeFileInit  = "TSDN65LPLLA16384X2M8S_initial.cde";
`endif
`ifdef TSMC_INITIALIZE_FAULT
   parameter cdeFileFault = "TSDN65LPLLA16384X2M8S_fault.cde";
`endif

// Registers
reg [N-1:0] DAL;
reg [N-1:0] DBL;
 
reg [N-1:0] BWEBAL;
reg [N-1:0] BWEBBL;
reg [N-1:0] bBWEBAL;
reg [N-1:0] bBWEBBL;
 
reg [M-1:0] AAL;
reg [M-1:0] ABL;
 
reg WEBAL,CEBAL;
reg WEBBL,CEBBL;
 
wire [N-1:0] QAL;
wire [N-1:0] QBL;
 
reg valid_cka, valid_ckb, valid_ckm;
reg valid_cea;
reg valid_ceb;
reg valid_wea;
reg valid_web;
reg valid_aa;
reg valid_ab;
reg valid_contentiona,valid_contentionb,valid_contentionc;
reg valid_da1, valid_da0;
reg valid_db1, valid_db0;
reg valid_bwa1, valid_bwa0;
reg valid_bwb1, valid_bwb0;

 
reg EN;
reg RDA, RDB;

reg RCLKA,RCLKB;

wire [N-1:0] bBWEBA;
wire [N-1:0] bBWEBB;
 
wire [N-1:0] bDA;
wire [N-1:0] bDB;
 
wire [M-1:0] bAA;
wire [M-1:0] bAB;
 
wire bWEBA,bWEBB;
wire bCEBA,bCEBB;
wire bCLKA,bCLKB;
 
reg [N-1:0] bQA;
reg [N-1:0] bQB;


wire [N-1:0] bbQA;
wire [N-1:0] bbQB;
 
integer i;
 
// Address Inputs
buf sAA0 (bAA[0], AA[0]);
buf sAB0 (bAB[0], AB[0]);
buf sAA1 (bAA[1], AA[1]);
buf sAB1 (bAB[1], AB[1]);
buf sAA2 (bAA[2], AA[2]);
buf sAB2 (bAB[2], AB[2]);
buf sAA3 (bAA[3], AA[3]);
buf sAB3 (bAB[3], AB[3]);
buf sAA4 (bAA[4], AA[4]);
buf sAB4 (bAB[4], AB[4]);
buf sAA5 (bAA[5], AA[5]);
buf sAB5 (bAB[5], AB[5]);
buf sAA6 (bAA[6], AA[6]);
buf sAB6 (bAB[6], AB[6]);
buf sAA7 (bAA[7], AA[7]);
buf sAB7 (bAB[7], AB[7]);
buf sAA8 (bAA[8], AA[8]);
buf sAB8 (bAB[8], AB[8]);
buf sAA9 (bAA[9], AA[9]);
buf sAB9 (bAB[9], AB[9]);
buf sAA10 (bAA[10], AA[10]);
buf sAB10 (bAB[10], AB[10]);
buf sAA11 (bAA[11], AA[11]);
buf sAB11 (bAB[11], AB[11]);
buf sAA12 (bAA[12], AA[12]);
buf sAB12 (bAB[12], AB[12]);
buf sAA13 (bAA[13], AA[13]);
buf sAB13 (bAB[13], AB[13]);


// Bit Write/Data Inputs 
buf sDA0 (bDA[0], DA[0]);
buf sDB0 (bDB[0], DB[0]);
buf sDA1 (bDA[1], DA[1]);
buf sDB1 (bDB[1], DB[1]);


buf sBWEBA0 (bBWEBA[0], BWEBA[0]);
buf sBWEBB0 (bBWEBB[0], BWEBB[0]);
buf sBWEBA1 (bBWEBA[1], BWEBA[1]);
buf sBWEBB1 (bBWEBB[1], BWEBB[1]);


// Input Controls
buf sWEBA (bWEBA, WEBA);
buf sWEBB (bWEBB, WEBB);
 
buf sCEBA (bCEBA, CEBA);
buf sCEBB (bCEBB, CEBB);
 
buf sCLKA (bCLKA, CLKA);
buf sCLKB (bCLKB, CLKB);


// Output Data
buf sQA0 (QA[0], bbQA[0]);
buf sQA1 (QA[1], bbQA[1]);

buf sQB0 (QB[0], bbQB[0]);
buf sQB1 (QB[1], bbQB[1]);

assign bbQA=bQA;
assign bbQB=bQB;

and sWEA (WEA, !bWEBA, !bCEBA);
and sWEB (WEB, !bWEBB, !bCEBB);

buf sCSA (CSA, !bCEBA);
buf sCSB (CSB, !bCEBB);

wire AeqB, BeqA;
wire AbeforeB, BbeforeA;

real CLKA_time, CLKB_time;

wire CLK_same;   
assign CLK_same = ((CLKA_time == CLKB_time)?1'b1:1'b0);

assign AeqB = (((bAA == bAB) && CLK_same) || ((AAL == bAB) && !CLK_same)) ? 1'b1:1'b0;
assign BeqA = (((bAB == bAA) && CLK_same) || ((ABL == bAA) && !CLK_same)) ? 1'b1:1'b0;

assign AbeforeB = ((((!bCEBA && !bCEBB && (!bWEBA || !bWEBB)) && CLK_same) || ((!CEBAL && !bCEBB) && (!WEBAL || !bWEBB) && !CLK_same)) && AeqB) ? 1'b1:1'b0;
assign BbeforeA = ((((!bCEBB && !bCEBA && (!bWEBB || !bWEBA)) && CLK_same) || ((!CEBBL && !bCEBA) && (!WEBBL || !bWEBA) && !CLK_same)) && BeqA) ? 1'b1:1'b0;


`ifdef UNIT_DELAY
`else
specify

   specparam PATHPULSE$CLKA$QA = ( 0, 0.001 );
   specparam PATHPULSE$CLKB$QB = ( 0, 0.001 );

specparam
ckpl = 0.2653785,
ckph = 0.2653785,
ckp = 1.3268940,
cksep = 0.728,

as = 0.0827409,
ah = 0.0721031,
ds = 0.1873622,
dh = 0.1029876,
css = 0.1223310,
csh = 0.0000000,
wes = 0.0925960,
weh = 0.0721031,
bws = 0.2002897,
bwh = 0.1029876,

ckq = 1.3133320,
ckqh = 0.9416178,
dq = 0.2914993,
dqh = 0.2436228,
bwq = 0.2885020,
bwqh = 0.2439668;

  $recrem (posedge CLKA, posedge CLKB &&& AbeforeB, cksep, 0, valid_contentiona);
  $recrem (posedge CLKB, posedge CLKA &&& BbeforeA, cksep, 0, valid_contentionb);

  $setuphold (posedge CLKA &&& CSA, posedge AA[0], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[0], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[0], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[0], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[1], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[1], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[1], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[1], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[2], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[2], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[2], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[2], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[3], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[3], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[3], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[3], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[4], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[4], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[4], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[4], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[5], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[5], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[5], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[5], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[6], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[6], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[6], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[6], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[7], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[7], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[7], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[7], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[8], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[8], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[8], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[8], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[9], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[9], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[9], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[9], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[10], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[10], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[10], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[10], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[11], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[11], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[11], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[11], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[12], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[12], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[12], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[12], as, ah, valid_ab);
  $setuphold (posedge CLKA &&& CSA, posedge AA[13], as, ah, valid_aa);
  $setuphold (posedge CLKA &&& CSA, negedge AA[13], as, ah, valid_aa);
  $setuphold (posedge CLKB &&& CSB, posedge AB[13], as, ah, valid_ab);
  $setuphold (posedge CLKB &&& CSB, negedge AB[13], as, ah, valid_ab);

  $setuphold (posedge CLKA &&& WEA, posedge DA[0], ds, dh, valid_da0);
  $setuphold (posedge CLKA &&& WEA, negedge DA[0], ds, dh, valid_da0);
  $setuphold (posedge CLKB &&& WEB, posedge DB[0], ds, dh, valid_db0);
  $setuphold (posedge CLKB &&& WEB, negedge DB[0], ds, dh, valid_db0);
 
  $setuphold (posedge CLKA &&& WEA, posedge BWEBA[0], bws, bwh, valid_bwa0);
  $setuphold (posedge CLKA &&& WEA, negedge BWEBA[0], bws, bwh, valid_bwa0);
  $setuphold (posedge CLKB &&& WEB, posedge BWEBB[0], bws, bwh, valid_bwb0);
  $setuphold (posedge CLKB &&& WEB, negedge BWEBB[0], bws, bwh, valid_bwb0);
  $setuphold (posedge CLKA &&& WEA, posedge DA[1], ds, dh, valid_da1);
  $setuphold (posedge CLKA &&& WEA, negedge DA[1], ds, dh, valid_da1);
  $setuphold (posedge CLKB &&& WEB, posedge DB[1], ds, dh, valid_db1);
  $setuphold (posedge CLKB &&& WEB, negedge DB[1], ds, dh, valid_db1);
 
  $setuphold (posedge CLKA &&& WEA, posedge BWEBA[1], bws, bwh, valid_bwa1);
  $setuphold (posedge CLKA &&& WEA, negedge BWEBA[1], bws, bwh, valid_bwa1);
  $setuphold (posedge CLKB &&& WEB, posedge BWEBB[1], bws, bwh, valid_bwb1);
  $setuphold (posedge CLKB &&& WEB, negedge BWEBB[1], bws, bwh, valid_bwb1);
  $setuphold (posedge CLKA &&& CSA, posedge WEBA, wes, weh, valid_wea);
  $setuphold (posedge CLKA &&& CSA, negedge WEBA, wes, weh, valid_wea);
  $setuphold (posedge CLKB &&& CSB, posedge WEBB, wes, weh, valid_web);
  $setuphold (posedge CLKB &&& CSB, negedge WEBB, wes, weh, valid_web);

  $setuphold (posedge CLKA, posedge CEBA, css, csh, valid_cea);
  $setuphold (posedge CLKA, negedge CEBA, css, csh, valid_cea);
  $setuphold (posedge CLKB, posedge CEBB, css, csh, valid_ceb);
  $setuphold (posedge CLKB, negedge CEBB, css, csh, valid_ceb);

  $width (negedge CLKA, ckpl, 0, valid_cka);
  $width (posedge CLKA, ckph, 0, valid_cka);
  $width (negedge CLKB, ckpl, 0, valid_ckb);
  $width (posedge CLKB, ckph, 0, valid_ckb);
  $period (posedge CLKA, ckp, valid_cka);
  $period (negedge CLKA, ckp, valid_cka);
  $period (posedge CLKB, ckp, valid_ckb);
  $period (negedge CLKB, ckp, valid_ckb);

if (!CEBA & WEBA) (posedge CLKA => (QA[0] : 1'bx)) = (ckq,ckq,ckqh,ckq,ckqh,ckq);
if (!CEBB & WEBB) (posedge CLKB => (QB[0] : 1'bx)) = (ckq,ckq,ckqh,ckq,ckqh,ckq);
if (!CEBA & WEBA) (posedge CLKA => (QA[1] : 1'bx)) = (ckq,ckq,ckqh,ckq,ckqh,ckq);
if (!CEBB & WEBB) (posedge CLKB => (QB[1] : 1'bx)) = (ckq,ckq,ckqh,ckq,ckqh,ckq);
endspecify
`endif

initial
begin
  assign EN = 1;
  RDA = 1;
  RDB = 1;
  ABL = 1'b1;
  AAL = {M{1'b0}};
  BWEBAL = {N{1'b1}};
  BWEBBL = {N{1'b1}};
end

`ifdef TSMC_INITIALIZE_MEM
initial
   begin 
     #0.01  $readmemh(cdeFileInit, MX.mem, 0, W-1);
   end
`endif //  `ifdef TSMC_INITIALIZE_MEM
   
`ifdef TSMC_INITIALIZE_FAULT
initial
   begin
     $readmemh(cdeFileFault, MX.mem_fault, 0, W-1);
   end
`endif //  `ifdef TSMC_INITIALIZE_FAULT

always @(posedge bCLKA) CLKA_time = $realtime;
always @(posedge bCLKB) CLKB_time = $realtime;

always @(bCLKA)
begin
  if (bCLKA === 1'bx)
  begin
     if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m : CLKA Unknown at %t. >>", $realtime);
     #0;
     AAL <= {M{1'bx}};
     BWEBAL <= {N{1'b0}};
`ifdef UNIT_DELAY
     bQA <= #(`SRAM_DELAY + 0.001) {N{1'bx}};
`else
     bQA <= # 0.001 {N{1'bx}}; 
`endif
  end
  else if (bCLKA === 1'b1 && RCLKA === 1'b0)
  begin
     if (bCEBA === 1'bx)
       begin
	  if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m CEBA Unknown at %t. >>", $realtime);
          #0;
	  AAL <= {M{1'bx}};
	  BWEBAL <= {N{1'b0}};
          bQA <= #0.001 {N{1'bx}};
       end
     else if (bWEBA === 1'bx && bCEBA === 1'b0)
       begin
	  if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m WEBA Unknown at %t. >>", $realtime);
	  #0;
          AAL <= {M{1'bx}};
	  BWEBAL <= {N{1'b0}};
	  bQA <= #0.001 {N{1'bx}};
`ifdef UNIT_DELAY
          bQB <= #(`SRAM_DELAY + 0.001) {N{1'bx}};
`else
          bQB <= # 0.001 {N{1'bx}}; 
`endif
       end
     else 
   begin                                
      WEBAL = bWEBA;
      CEBAL = bCEBA;
     if (^bAA === 1'bx && bWEBA === 1'b0 && bCEBA === 1'b0)
       begin
	  if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m WRITE AA Unknown at %t. >>", $realtime);
	  #0;
	  AAL <= {M{1'bx}};
	  BWEBAL <= {N{1'b0}};
       end
     else if (^bAA === 1'bx && bWEBA === 1'b1 && bCEBA === 1'b0)
       begin
	  if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m READ AA Unknown at %t. >>", $realtime);
	  #0;
	  AAL <= {M{1'bx}};
	  BWEBAL <= {N{1'b0}};
	  bQA <= #0.001 {N{1'bx}};
       end
      else
      begin
      if (!bCEBA)
      begin
         AAL = bAA;
         DAL = bDA;
         if (bWEBA === 1'b1) RDA = #0 ~RDA;
         if (bWEBA !== 1'b1)
         begin
            for (i = 0; i < N; i = i + 1)
            begin
               if (!bBWEBA[i] && !bWEBA)
               begin
                  bBWEBAL[i] = 1'b0;
                  BWEBAL[i] = 1'b0;
               end
               if (bBWEBA[i] && !bWEBA)
               begin
                  bBWEBAL[i] = 1'b1;
               end
               if (((bBWEBA[i] || bBWEBA[i]===1'bx) && bWEBA===1'bx) || (!bWEBA && bBWEBA[i] ===1'bx))
               begin
                  bBWEBAL[i] = 1'bx;
                  BWEBAL[i] = 1'b0;
                  DAL[i] = 1'bx;
               end
            end
         end
`ifdef UNIT_DELAY
	 #0;
	 if ((bAA == bAB) && (WEA && WEB) && CLK_same) // A-write and B-write ,same-addr
	   begin
              if( MES_ALL=="ON" && $realtime != 0)
		 $display("\nWarning %m WRITE/WRITE contention. If BWEB enables, Write data set to unknown at %t. >>", $realtime);
	      for (i=0; i<N; i=i+1)
		begin
                   if(!bBWEBAL[i] && !bBWEBBL[i])       DAL[i] = 1'bx;
		end
	   end
`endif
      end
    end
   end
end// end always @(posedge bCLKA)
  RCLKA = bCLKA;
end

always @(bCLKB)
begin
 if (bCLKB === 1'bx)
 begin
     if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m CLKB Unknown at %t. >>", $realtime);
     #0;
     ABL <= {M{1'bx}};
     BWEBBL <= {N{1'b0}};
`ifdef UNIT_DELAY
     bQB <= #(`SRAM_DELAY + 0.001) {N{1'bx}};
`else
     bQB <= #0.001 {N{1'bx}}; 
`endif
 end
 else if (bCLKB === 1'b1 && RCLKB === 1'b0)
 begin
     if (bCEBB === 1'bx)
       begin
	  if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m CEBB Unknown at %t. >>", $realtime);
	  #0;
	  ABL <= {M{1'bx}};
	  BWEBBL <= {N{1'b0}};
	  bQB <= #0.001 {N{1'bx}};
       end
     else if (bWEBB === 1'bx && bCEBB === 1'b0)
       begin
	  if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m WEBB Unknown at %t. >>", $realtime);
	  #0;
	  ABL <= {M{1'bx}};
	  BWEBBL <= {N{1'b0}};
`ifdef UNIT_DELAY
          bQA <= #(`SRAM_DELAY + 0.001) {N{1'bx}};
`else
          bQA <= # 0.001 {N{1'bx}}; 
`endif
	  bQB <= #0.001 {N{1'bx}};
       end
     else
   begin                               
      WEBBL = bWEBB;
      CEBBL = bCEBB;

     if (^bAB === 1'bx && bWEBB === 1'b0 && bCEBB === 1'b0)
       begin
	  if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m WRITE AB Unknown at %t. >>", $realtime);
	  #0;
	  ABL <= {M{1'bx}};
	  BWEBBL <= {N{1'b0}};
       end

     else if (^bAB === 1'bx && bWEBB === 1'b1 && bCEBB === 1'b0)
       begin
	  if( MES_ALL=="ON" && $realtime != 0) $display("\nWarning %m READ AB Unknown at %t. >>", $realtime);
	  #0;
	  ABL <= {M{1'bx}};
	  BWEBBL <= {N{1'b0}};
	  bQB <= #0.001 {N{1'bx}};
       end
       else
       begin
      if (!bCEBB)
      begin
         ABL = bAB;
         DBL = bDB;
         if (bWEBB === 1'b1) RDB = #0 ~RDB;
         if (bWEBB !== 1'b1)
         begin
            for (i = 0; i < N; i = i + 1)
            begin
               if (!bBWEBB[i] && !bWEBB) 
               begin
                  bBWEBBL[i] = 1'b0;
                  BWEBBL[i] = 1'b0;
               end
               if (bBWEBB[i] && !bWEBB)
               begin
                  bBWEBBL[i] = 1'b1;
               end
               if (((bBWEBB[i] || bBWEBB[i]===1'bx) && bWEBB===1'bx) || (!bWEBB && bBWEBB[i] ===1'bx))
               begin
                  bBWEBBL[i] = 1'bx;
                  BWEBBL[i] = 1'b0;
                  DBL[i] = 1'bx;
               end
            end
         end
`ifdef UNIT_DELAY
	 #0;
	 if ((bAB == bAA) && (WEA && WEB) && CLK_same) // A-write and B-write ,same-addr
	   begin
              if( MES_ALL=="ON" && $realtime != 0)
		 $display("\nWarning %m WRITE/WRITE contention. If BWEB enables, Write data set to unknown at %t. >>", $realtime);
	      for (i=0; i<N; i=i+1)
		begin
		   if(!bBWEBA[i] && !bBWEBB[i])       DBL[i] = 1'bx;
		end
	   end
`endif
      end
    end
   end                       
 end
 RCLKB = bCLKB;
end



`ifdef UNIT_DELAY
always @(RDA or QAL)
  begin
     if (!CEBAL && WEBAL)
       begin
	  if ((bAA == bAB) && (!WEA && WEB) && CLK_same) // A-read and B-write ,same-addr
	    begin
             if( MES_ALL=="ON" && $realtime != 0)
	       $display("\nWarning %m READ/WRITE contention. If BWEB enables, Port A outputs set to unknown at %t. >>", $realtime);
               #(`SRAM_DELAY);
	       for (i=0; i<N; i=i+1)
		 begin
		    if(!bBWEBBL[i] || bBWEBBL[i] === 1'bx) 
                      begin
                         bQA[i] <= 1'bx;
                      end
		    else 
		      begin
			 bQA[i] <= QAL[i];
		      end
		 end
	    end
	  else 
	    begin
               #(`SRAM_DELAY);
	       bQA <= QAL;
	    end
       end
  end // always @ (RDA or QAL)
`else
always @(RDA or QAL)
  begin
     if (!CEBAL && WEBAL)
       begin
	  bQA = {N{1'bx}};
	  #0.001 bQA = QAL;
       end
  end
`endif

`ifdef UNIT_DELAY
always @(RDB or QBL)
  begin
     if (!CEBBL && WEBBL)
       begin
	  if ((bAA == bAB) && (WEA && !WEB) && CLK_same) // A-write and B-read ,same-addr
	    begin
             if( MES_ALL=="ON" && $realtime != 0)
	       $display("\nWarning %m READ/WRITE contention. If BWEB enables, Port B outputs set to unknown at %t. >>", $realtime);
               #(`SRAM_DELAY);
	       for (i=0; i<N; i=i+1)
		 begin
		    if(!bBWEBAL[i] || bBWEBAL[i] === 1'bx) 
                      begin
                         bQB[i] <= 1'bx;
                      end
		    else 
		      begin
			 bQB[i] <= QBL[i];
		      end
		 end
	    end
	  else
	    begin
               #(`SRAM_DELAY);
	       bQB <= QBL;
	    end
       end
  end // always @ (RDB or QBL)
`else
always @(RDB or QBL)
  begin
     if (!CEBBL && WEBBL)
       begin
	  bQB = {N{1'bx}};
	  #0.001 bQB = QBL;
       end
  end
`endif


always @(BWEBAL)
   begin
      BWEBAL = #0.01 {N{1'b1}};
   end

always @(BWEBBL)
   begin
      BWEBBL = #0.01 {N{1'b1}};
   end
 
`ifdef UNIT_DELAY
`else
always @(valid_contentiona)
begin
  if ((!bWEBA && bWEBB && CLK_same) || (!WEBAL && bWEBB && !CLK_same))
    begin
       #0.003;
       for (i=0; i<N; i=i+1)
         begin
           if((bBWEBA[i] ===1'bx)||(BWEBAL[i]===1'bx))
             begin
                  BWEBAL[i] = 1'b0;
                  DAL[i] = 1'bx;
                  bQB[i] =  1'bx;
               end
          end
       for (i=0; i<N; i=i+1)
	 begin
	   if((!bBWEBA[i]) || (!BWEBAL[i] ))
             bQB[i] =  1'bx;
         end
    end  

  if ((bWEBA && !bWEBB && CLK_same) || (WEBAL && !bWEBB && !CLK_same))
    begin
       #0.003;
       for (i=0; i<N; i=i+1)
         begin
           if((bBWEBB[i] ===1'bx)||(BWEBBL[i]===1'bx))
             begin
                  BWEBBL[i] = 1'b0;
                  DBL[i] = 1'bx;
                  bQA[i] =  1'bx;
               end
          end
       for (i=0; i<N; i=i+1)
	 begin
	   if((!bBWEBB[i]) || (!BWEBBL[i] ))
             bQA[i] =  1'bx;
         end   
    end  

  if ((!bWEBA && !bWEBB && CLK_same) || (!WEBAL && !bWEBB && !CLK_same))
     begin
       #0.003;
       for (i=0; i<N; i=i+1)
         begin
           if((bBWEBA[i] ===1'bx)||(BWEBAL[i]===1'bx))
             begin
                  BWEBAL[i] = 1'b0;
                  DAL[i] = 1'bx;
                 end
           if((bBWEBB[i] ===1'bx)||(BWEBBL[i]===1'bx))
             begin
                  BWEBBL[i] = 1'b0;
                  DBL[i] = 1'bx;
               end
          end

       for (i=0; i<N; i=i+1)
         begin
	   if((!bBWEBB[i]) || (!BWEBBL[i] ))
              DAL[i] = 1'bx;
	   if((!bBWEBA[i]) || (!BWEBAL[i] ))
              DBL[i] = 1'bx;
         end 
     end
end
 
always @(valid_contentionb)
begin
  if ((!bWEBB && bWEBA && CLK_same) || (!WEBBL && bWEBA && !CLK_same))
     begin
       #0.003;
       for (i=0; i<N; i=i+1)
         begin
           if((bBWEBB[i] ===1'bx)||(BWEBBL[i]===1'bx))
             begin
                  BWEBBL[i] = 1'b0;
                  DBL[i] = 1'bx;
                  bQA[i] =  1'bx;
               end
          end
       for (i=0; i<N; i=i+1)
	 begin
	   if((!bBWEBB[i]) || (!BWEBBL[i] ))
             bQA[i] =  1'bx;
         end
     end 

  if ((bWEBB && !bWEBA && CLK_same) || (WEBBL && !bWEBA && !CLK_same))
    begin
       #0.003;
       for (i=0; i<N; i=i+1)
         begin
           if((bBWEBA[i] ===1'bx)||(BWEBAL[i]===1'bx))
             begin
                  BWEBAL[i] = 1'b0;
                  DAL[i] = 1'bx;
                  bQB[i] =  1'bx;
               end
          end
       for (i=0; i<N; i=i+1)
	 begin
	   if((!bBWEBA[i]) || (!BWEBAL[i] ))
             bQB[i] =  1'bx;
         end   
    end  

  if ((!bWEBB && !bWEBA && CLK_same) || (!WEBBL && !bWEBA && !CLK_same))
     begin
       #0.003;
       for (i=0; i<N; i=i+1)
         begin
           if((bBWEBA[i] ===1'bx)||(BWEBAL[i]===1'bx))
             begin
                  BWEBAL[i] = 1'b0;
                  DAL[i] = 1'bx;
                end
           if((bBWEBB[i] ===1'bx)||(BWEBBL[i]===1'bx))
             begin
                  BWEBBL[i] = 1'b0;
                  DBL[i] = 1'bx;
               end
          end

       for (i=0; i<N; i=i+1)
         begin
	   if((!bBWEBB[i]) || (!BWEBBL[i] ))
              DAL[i] = 1'bx;
	   if((!bBWEBA[i]) || (!BWEBAL[i] ))
              DBL[i] = 1'bx;
         end 
     end
end

 
always @(valid_cka)
   begin
   #0;
   AAL = {M{1'bx}};
   BWEBAL = {N{1'bx}};
   bQA = #0.001 {N{1'bx}};
   end

always @(valid_ckb)
   begin
      #0;
      ABL = {M{1'bx}};
      BWEBBL = {N{1'b0}};
      bQB = #0.001 {N{1'bx}};
   end


always @(valid_aa)
   begin
      #0;
      if (!WEBAL)
        begin
          BWEBAL = {N{1'b0}};
          AAL = {M{1'bx}};
        end
      else
        begin
          BWEBAL = {N{1'b0}};
          AAL = {M{1'bx}};
          bQA = #0.001 {N{1'bx}};
        end
   end

always @(valid_ab)
   begin
      #0;
      if (!WEBBL)
        begin
          BWEBBL = {N{1'b0}};
          ABL = {M{1'bx}};
        end
      else
        begin
          BWEBBL = {N{1'b0}};
          ABL = {M{1'bx}};
          bQB = #0.001 {N{1'bx}};
        end
   end

always @(valid_da0)
   begin
      #0;
      DAL[0] = 1'bx;
      BWEBAL[0] = 1'b0;
   end

always @(valid_db0)
   begin
      #0;
      DBL[0] = 1'bx;
      BWEBBL[0] = 1'b0;
   end

always @(valid_bwa0)
   begin
      #0;
      DAL[0] = 1'bx;
      BWEBAL[0] = 1'b0;
   end

always @(valid_bwb0)
   begin
      #0;
      DBL[0] = 1'bx;
      BWEBBL[0] = 1'b0;
   end
always @(valid_da1)
   begin
      #0;
      DAL[1] = 1'bx;
      BWEBAL[1] = 1'b0;
   end

always @(valid_db1)
   begin
      #0;
      DBL[1] = 1'bx;
      BWEBBL[1] = 1'b0;
   end

always @(valid_bwa1)
   begin
      #0;
      DAL[1] = 1'bx;
      BWEBAL[1] = 1'b0;
   end

always @(valid_bwb1)
   begin
      #0;
      DBL[1] = 1'bx;
      BWEBBL[1] = 1'b0;
   end

always @(valid_cea)
   begin
      #0;
      BWEBAL = {N{1'b0}};
      AAL = {M{1'bx}};
      bQA = #0.001 {N{1'bx}};
   end

always @(valid_ceb)
   begin
      #0;
      BWEBBL = {N{1'b0}};
      ABL = {M{1'bx}};
      bQB = #0.001 {N{1'bx}};
   end

always @(valid_wea)
   begin
      #0;
      BWEBAL = {N{1'b0}};
      AAL = {M{1'bx}};
      bQA = #0.001 {N{1'bx}};
      bQB = #0.001 {N{1'bx}};
   end
 
always @(valid_web)
   begin
      #0;
      BWEBBL = {N{1'b0}};
      ABL = {M{1'bx}};
      bQA = #0.001 {N{1'bx}};
      bQB = #0.001 {N{1'bx}};
   end

`endif

TSDN65LPLLA16384X2M8S_Int_Array #(2,2,W,N,M,MES_ALL) MX (.D({DAL,DBL}),.BW({BWEBAL,BWEBBL}),
         .AW({AAL,ABL}),.EN(EN),.AAR(AAL),.ABR(ABL),.RDA(RDA),.RDB(RDB),.QA(QAL),.QB(QBL));
 
endmodule

`disable_portfaults
`nosuppress_faults
`endcelldefine

/*
   The module ports are parameterizable vectors.
*/

module TSDN65LPLLA16384X2M8S_Int_Array (D, BW, AW, EN, AAR, ABR, RDA, RDB, QA, QB);
parameter Nread = 2;   // Number of Read Ports
parameter Nwrite = 2;  // Number of Write Ports
parameter Nword = 2;   // Number of Words
parameter Ndata = 1;   // Number of Data Bits / Word
parameter Naddr = 1;   // Number of Address Bits / Word
parameter MES_ALL = "ON";
parameter dly = 0.000;
// Cannot define inputs/outputs as memories
input  [Ndata*Nwrite-1:0] D;  // Data Word(s)
input  [Ndata*Nwrite-1:0] BW; // Negative Bit Write Enable
input  [Naddr*Nwrite-1:0] AW; // Write Address(es)
input  EN;                    // Positive Write Enable
input  RDA;                    // Positive Write Enable
input  RDB;                    // Positive Write Enable
input  [Naddr-1:0] AAR;  // Read Address(es)
input  [Naddr-1:0] ABR;  // Read Address(es)
output [Ndata-1:0] QA;   // Output Data Word(s)
output [Ndata-1:0] QB;   // Output Data Word(s)
reg    [Ndata-1:0] QA;
reg    [Ndata-1:0] QB;
reg [Ndata-1:0] mem [Nword-1:0];
reg [Ndata-1:0] mem_fault [Nword-1:0];
reg chgmem;            // Toggled when write to mem
reg [Nwrite-1:0] wwe;  // Positive Word Write Enable for each Port
reg we;                // Positive Write Enable for all Ports
integer waddr[Nwrite-1:0]; // Write Address for each Enabled Port
integer address;       // Current address
reg [Naddr-1:0] abuf;  // Address of current port
reg [Ndata-1:0] dbuf;  // Data for current port
reg [Ndata-1:0] bwbuf; // Bit Write enable for current port
reg dup;               // Is the address a duplicate?
integer log;           // Log file descriptor
integer ip, ip2, ib, iw, iwb; // Vector indices


initial
   begin
   $timeformat (-9, 3, " ns", 9);
   if (log[0] === 1'bx)
      log = 1;
   chgmem = 1'b0;
   end


always @(D or BW or AW or EN)
   begin: WRITE //{
   if (EN !== 1'b0)
      begin //{ Possible write
      we = 1'b0;
      // Mark any write enabled ports & get write addresses
      for (ip = 0 ; ip < Nwrite ; ip = ip + 1)
         begin //{
         ib = ip * Ndata;
         iw = ib + Ndata;
         while (ib < iw && BW[ib] === 1'b1)
            ib = ib + 1;
         if (ib == iw)
            wwe[ip] = 1'b0;
         else
            begin //{ ip write enabled
            iw = ip * Naddr;
            for (ib = 0 ; ib < Naddr ; ib = ib + 1)
               begin //{
               abuf[ib] = AW[iw+ib];
               if (abuf[ib] !== 1'b0 && abuf[ib] !== 1'b1)
                  ib = Naddr;
               end //}
            if (ib == Naddr)
               begin //{
               if (abuf < Nword)
                  begin //{ Valid address
                  waddr[ip] = abuf;
                  wwe[ip] = 1'b1;
                  if (we == 1'b0)
                     begin
                     chgmem = ~chgmem;
                     we = EN;
                     end
                  end //}
               else
                  begin //{ Out of range address
                  wwe[ip] = 1'b0;
                  if( MES_ALL=="ON" && $realtime != 0)
                       $fdisplay (log,
                             "\nWarning! Int_Array instance, %m:",
                             "\n\t Port %0d", ip,
                             " write address x'%0h'", abuf,
                             " out of range at time %t.", $realtime,
                             "\n\t Port %0d data not written to memory.", ip);
                  end //}
               end //}
            else
               begin //{ Unknown write address
               if( MES_ALL=="ON" && $realtime != 0)
                    $fdisplay (log,
                          "\nWarning! Int_Array instance, %m:",
                          "\n\t Port %0d", ip,
                          " write address unknown at time %t.", $realtime,
                          "\n\t Entire memory set to unknown.");
               for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                  dbuf[ib] = 1'bx;
               for (iw = 0 ; iw < Nword ; iw = iw + 1)
                  mem[iw] = dbuf;
               chgmem = ~chgmem;
               disable WRITE;
               end //}
            end //} ip write enabled
         end //} for ip
      if (we === 1'b1)
         begin //{ active write enable
         for (ip = 0 ; ip < Nwrite ; ip = ip + 1)
            begin //{
            if (wwe[ip])
               begin //{ write enabled bits of write port ip
               address = waddr[ip];
               dbuf = mem[address];
               iw = ip * Ndata;
               for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                  begin //{
                  iwb = iw + ib;
                  if (BW[iwb] === 1'b0)
                     dbuf[ib] = D[iwb];
                  else if (BW[iwb] !== 1'b1)
                     dbuf[ib] = 1'bx;
                  end //}
               // Check other ports for same address &
               // common write enable bits active
               dup = 0;
               for (ip2 = ip + 1 ; ip2 < Nwrite ; ip2 = ip2 + 1)
                  begin //{
                  if (wwe[ip2] && address == waddr[ip2])
                     begin //{
                     // initialize bwbuf if first dup
                     if (!dup)
                        begin
                        for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                           bwbuf[ib] = BW[iw+ib];
                        dup = 1;
                        end
                     iw = ip2 * Ndata;
                     for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                        begin //{
                        iwb = iw + ib;
                        // New: Always set X if BW X
                        if (BW[iwb] === 1'b0)
                           begin //{
                           if (bwbuf[ib] !== 1'b1)
                              begin
                              if (D[iwb] !== dbuf[ib])
                                 dbuf[ib] = 1'bx;
                              end
                           else
                              begin
                              dbuf[ib] = D[iwb];
                              bwbuf[ib] = 1'b0;
                              end
                           end //}
                        else if (BW[iwb] !== 1'b1)
                           begin
                           dbuf[ib] = 1'bx;
                           bwbuf[ib] = 1'bx;
                           end
                        end //} for each bit
                        wwe[ip2] = 1'b0;
                     end //} Port ip2 address matches port ip
                  end //} for each port beyond ip (ip2=ip+1)
               // Write dbuf to memory
               mem[address] = dbuf;
               end //} wwe[ip] - write port ip enabled
            end //} for each write port ip
         end //} active write enable
      else if (we !== 1'b0)
         begin //{ unknown write enable
         for (ip = 0 ; ip < Nwrite ; ip = ip + 1)
            begin //{
            if (wwe[ip])
               begin //{ write X to enabled bits of write port ip
               address = waddr[ip];
               dbuf = mem[address];
               iw = ip * Ndata;
               for (ib = 0 ; ib < Ndata ; ib = ib + 1)
                  begin //{ 
                 if (BW[iw+ib] !== 1'b1)
                     dbuf[ib] = 1'bx;
                  end //} 
               mem[address] = dbuf;
               if( MES_ALL=="ON" && $realtime != 0)
                    $fdisplay (log,
                          "\nWarning! Int_Array instance, %m:",
                          "\n\t Enable pin unknown at time %t.", $realtime,
                          "\n\t Enabled bits at port %0d", ip,
                          " write address x'%0h' set unknown.", address);
               end //} wwe[ip] - write port ip enabled
            end //} for each write port ip
         end //} unknown write enable
      end //} possible write (EN != 0)
   end //} always @(D or BW or AW or EN)


// Read memory
always @(AAR or RDA)
   begin //{
      for (ib = 0 ; ib < Naddr ; ib = ib + 1)
         begin
         abuf[ib] = AAR[ib];
         if (abuf[ib] !== 0 && abuf[ib] !== 1)
            ib = Naddr;
         end
      if (ib == Naddr && abuf < Nword)
         begin //{ Read valid address
`ifdef TSMC_INITIALIZE_FAULT
         dbuf = mem[abuf] ^ mem_fault[abuf];
`else
         dbuf = mem[abuf];
`endif
         for (ib = 0 ; ib < Ndata ; ib = ib + 1)
            begin
            if (QA[ib] == dbuf[ib])
                QA[ib] <= #(dly) dbuf[ib];
            else
                begin
                QA[ib] <= #(dly) dbuf[ib];
                end // else
            end // for
         end //} valid address
      else
         begin //{ Invalid address
         if( MES_ALL=="ON" && $realtime != 0)
               $fwrite (log, "\nWarning! Int_Array instance, %m:",
                       "\n\t Port A read address");
         if (ib > Naddr)
         begin
         if( MES_ALL=="ON" && $realtime != 0)
            $fwrite (log, " unknown");
         end   
         else
         begin
         if( MES_ALL=="ON" && $realtime != 0)
            $fwrite (log, " x'%0h' out of range", abuf);
         end   
         if( MES_ALL=="ON" && $realtime != 0)
            $fdisplay (log,
                    " at time %t.", $realtime,
                    "\n\t Port A outputs set to unknown.");
         for (ib = 0 ; ib < Ndata ; ib = ib + 1)
            QA[ib] <= #(dly) 1'bx;
         end //} invalid address
   end //} always @(chgmem or AR)

// Read memory
always @(ABR or RDB)
   begin //{
      for (ib = 0 ; ib < Naddr ; ib = ib + 1)
         begin
         abuf[ib] = ABR[ib];
         if (abuf[ib] !== 0 && abuf[ib] !== 1)
            ib = Naddr;
         end
      if (ib == Naddr && abuf < Nword)
         begin //{ Read valid address
`ifdef TSMC_INITIALIZE_FAULT
         dbuf = mem[abuf] ^ mem_fault[abuf];
`else
         dbuf = mem[abuf];
`endif
         for (ib = 0 ; ib < Ndata ; ib = ib + 1)
            begin
            if (QB[ib] == dbuf[ib])
                QB[ib] <= #(dly) dbuf[ib];
            else
                begin
                QB[ib] <= #(dly) dbuf[ib];
                end // else
            end // for
         end //} valid address
      else
         begin //{ Invalid address
         if( MES_ALL=="ON" && $realtime != 0)
               $fwrite (log, "\nWarning! Int_Array instance, %m:",
                       "\n\t Port B read address");
         if (ib > Naddr)
         begin
         if( MES_ALL=="ON" && $realtime != 0)
            $fwrite (log, " unknown");
         end   
         else
         begin
         if( MES_ALL=="ON" && $realtime != 0)
            $fwrite (log, " x'%0h' out of range", abuf);
         end   
         if( MES_ALL=="ON" && $realtime != 0)
            $fdisplay (log,
                    " at time %t.", $realtime,
                    "\n\t Port B outputs set to unknown.");
         for (ib = 0 ; ib < Ndata ; ib = ib + 1)
            QB[ib] <= #(dly) 1'bx;
         end //} invalid address
   end //} always @(chgmem or AR)


// Task for loading contents of a memory
task load;   //{ USAGE: initial inst.load ("file_name");
   input [256*8:1] file;  // Max 256 character File Name
   begin
   $display ("\n%m: Reading file, %0s, into memory", file);
   $readmemb (file, mem, 0, Nword-1);
   end
endtask //}


// Task for displaying contents of a memory
task show;   //{ USAGE: inst.show (low, high);
   input [31:0] low, high;
   integer i;
   begin //{
   $display ("\n%m: Memory content dump");
   if (low < 0 || low > high || high >= Nword)
      $display ("Error! Invalid address range (%0d, %0d).", low, high,
                "\nUsage: %m (low, high);",
                "\n       where low >= 0 and high <= %0d.", Nword-1);
   else
      begin
      $display ("\n    Address\tValue");
      for (i = low ; i <= high ; i = i + 1)
         $display ("%d\t%b", i, mem[i]);
      end
   end //}
endtask //}

endmodule

