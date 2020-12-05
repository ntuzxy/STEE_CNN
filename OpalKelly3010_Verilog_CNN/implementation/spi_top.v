// clk_update pulse should be synch with clk_phase2
// it also enable capture so that it only write in a single location
// send the lsb of the address and then lsb of the data first




module spi_top(
reset_n,
clk_phase1,
clk_phase2,
capture,
clk_update,
spi_din,
spi_out,
config_reg0,
config_reg1,
config_reg2,
config_reg3,
config_reg4,
config_reg5,
config_reg6,
config_reg7,
config_reg8,
config_reg9,
config_reg10,
config_reg11,
config_reg12,
config_reg13,
config_reg14,
config_reg15,
config_reg16,
config_reg17,
config_reg18,
config_reg19,
config_reg20,
config_reg21,
config_reg22,
config_reg23,
config_reg24,
config_reg25,
config_reg26,
config_reg27,
config_reg28,
config_reg29,
config_reg30,
config_reg31,
config_reg32,
config_reg33,
config_reg34,
config_reg35,
config_reg36,
config_reg37,
config_reg38,
config_reg39,
config_reg40,
config_reg41,
config_reg42,
config_reg43,
config_reg44,
config_reg45,
config_reg46,
config_reg47,
config_reg48,
config_reg49,
config_reg50,
config_reg51,
config_reg52,
config_reg53,
config_reg54,
config_reg55,
config_reg56,
config_reg57,
config_reg58,
config_reg59,
config_reg60,
config_reg61,
config_reg62,
config_reg63,
config_reg64,
config_reg65,
config_reg66,
config_reg67,
config_reg68,
config_reg69,
config_reg70,
config_reg71,
config_reg72,
config_reg73,
config_reg74,
config_reg75,
config_reg76,
config_reg77,
config_reg78,
config_reg79,
config_reg80,
config_reg81,
config_reg82,
config_reg83,
config_reg84,
config_reg85,
config_reg86,
config_reg87,
config_reg88,
config_reg89,
config_reg90,
config_reg91,
config_reg92,
config_reg93,
config_reg94,
config_reg95,
config_reg96,
config_reg97,
config_reg98,
config_reg99,
config_reg100,
config_reg101,
config_reg102,
config_reg103,
config_reg104,
config_reg105,
config_reg106,
config_reg107,
config_reg108,
config_reg109,
config_reg110,
config_reg111,
config_reg112,
config_reg113,
config_reg114,
config_reg115,
config_reg116,
config_reg117,
config_reg118,
config_reg119,
config_reg120,
config_reg121,
config_reg122,
config_reg123,
config_reg124,
config_reg125,
config_reg126,
config_reg127
);
input  wire reset_n;
input  wire clk_phase1;
input  wire clk_phase2;
input  wire capture;
input  wire clk_update;
input  wire spi_din;
output wire spi_out;

localparam ARRAY_WIDTH = 16;
localparam ADDR_WIDTH = 7;
localparam ARRAY_DEPTH = 2**ADDR_WIDTH;
localparam MAX_SIZE = ARRAY_WIDTH*ARRAY_DEPTH;

reg [MAX_SIZE -1 :0] config_out_int;
output [ARRAY_WIDTH-1 : 0] config_reg0;
output [ARRAY_WIDTH-1 : 0] config_reg1;
output [ARRAY_WIDTH-1 : 0] config_reg2;
output [ARRAY_WIDTH-1 : 0] config_reg3;
output [ARRAY_WIDTH-1 : 0] config_reg4;
output [ARRAY_WIDTH-1 : 0] config_reg5;
output [ARRAY_WIDTH-1 : 0] config_reg6;
output [ARRAY_WIDTH-1 : 0] config_reg7;
output [ARRAY_WIDTH-1 : 0] config_reg8;
output [ARRAY_WIDTH-1 : 0] config_reg9;
output [ARRAY_WIDTH-1 : 0] config_reg10;
output [ARRAY_WIDTH-1 : 0] config_reg11;
output [ARRAY_WIDTH-1 : 0] config_reg12;
output [ARRAY_WIDTH-1 : 0] config_reg13;
output [ARRAY_WIDTH-1 : 0] config_reg14;
output [ARRAY_WIDTH-1 : 0] config_reg15;
output [ARRAY_WIDTH-1 : 0] config_reg16;
output [ARRAY_WIDTH-1 : 0] config_reg17;
output [ARRAY_WIDTH-1 : 0] config_reg18;
output [ARRAY_WIDTH-1 : 0] config_reg19;
output [ARRAY_WIDTH-1 : 0] config_reg20;
output [ARRAY_WIDTH-1 : 0] config_reg21;
output [ARRAY_WIDTH-1 : 0] config_reg22;
output [ARRAY_WIDTH-1 : 0] config_reg23;
output [ARRAY_WIDTH-1 : 0] config_reg24;
output [ARRAY_WIDTH-1 : 0] config_reg25;
output [ARRAY_WIDTH-1 : 0] config_reg26;
output [ARRAY_WIDTH-1 : 0] config_reg27;
output [ARRAY_WIDTH-1 : 0] config_reg28;
output [ARRAY_WIDTH-1 : 0] config_reg29;
output [ARRAY_WIDTH-1 : 0] config_reg30;
output [ARRAY_WIDTH-1 : 0] config_reg31;
output [ARRAY_WIDTH-1 : 0] config_reg32;
output [ARRAY_WIDTH-1 : 0] config_reg33;
output [ARRAY_WIDTH-1 : 0] config_reg34;
output [ARRAY_WIDTH-1 : 0] config_reg35;
output [ARRAY_WIDTH-1 : 0] config_reg36;
output [ARRAY_WIDTH-1 : 0] config_reg37;
output [ARRAY_WIDTH-1 : 0] config_reg38;
output [ARRAY_WIDTH-1 : 0] config_reg39;
output [ARRAY_WIDTH-1 : 0] config_reg40;
output [ARRAY_WIDTH-1 : 0] config_reg41;
output [ARRAY_WIDTH-1 : 0] config_reg42;
output [ARRAY_WIDTH-1 : 0] config_reg43;
output [ARRAY_WIDTH-1 : 0] config_reg44;
output [ARRAY_WIDTH-1 : 0] config_reg45;
output [ARRAY_WIDTH-1 : 0] config_reg46;
output [ARRAY_WIDTH-1 : 0] config_reg47;
output [ARRAY_WIDTH-1 : 0] config_reg48;
output [ARRAY_WIDTH-1 : 0] config_reg49;
output [ARRAY_WIDTH-1 : 0] config_reg50;
output [ARRAY_WIDTH-1 : 0] config_reg51;
output [ARRAY_WIDTH-1 : 0] config_reg52;
output [ARRAY_WIDTH-1 : 0] config_reg53;
output [ARRAY_WIDTH-1 : 0] config_reg54;
output [ARRAY_WIDTH-1 : 0] config_reg55;
output [ARRAY_WIDTH-1 : 0] config_reg56;
output [ARRAY_WIDTH-1 : 0] config_reg57;
output [ARRAY_WIDTH-1 : 0] config_reg58;
output [ARRAY_WIDTH-1 : 0] config_reg59;
output [ARRAY_WIDTH-1 : 0] config_reg60;
output [ARRAY_WIDTH-1 : 0] config_reg61;
output [ARRAY_WIDTH-1 : 0] config_reg62;
output [ARRAY_WIDTH-1 : 0] config_reg63;
output [ARRAY_WIDTH-1 : 0] config_reg64;
output [ARRAY_WIDTH-1 : 0] config_reg65;
output [ARRAY_WIDTH-1 : 0] config_reg66;
output [ARRAY_WIDTH-1 : 0] config_reg67;
output [ARRAY_WIDTH-1 : 0] config_reg68;
output [ARRAY_WIDTH-1 : 0] config_reg69;
output [ARRAY_WIDTH-1 : 0] config_reg70;
output [ARRAY_WIDTH-1 : 0] config_reg71;
output [ARRAY_WIDTH-1 : 0] config_reg72;
output [ARRAY_WIDTH-1 : 0] config_reg73;
output [ARRAY_WIDTH-1 : 0] config_reg74;
output [ARRAY_WIDTH-1 : 0] config_reg75;
output [ARRAY_WIDTH-1 : 0] config_reg76;
output [ARRAY_WIDTH-1 : 0] config_reg77;
output [ARRAY_WIDTH-1 : 0] config_reg78;
output [ARRAY_WIDTH-1 : 0] config_reg79;
output [ARRAY_WIDTH-1 : 0] config_reg80;
output [ARRAY_WIDTH-1 : 0] config_reg81;
output [ARRAY_WIDTH-1 : 0] config_reg82;
output [ARRAY_WIDTH-1 : 0] config_reg83;
output [ARRAY_WIDTH-1 : 0] config_reg84;
output [ARRAY_WIDTH-1 : 0] config_reg85;
output [ARRAY_WIDTH-1 : 0] config_reg86;
output [ARRAY_WIDTH-1 : 0] config_reg87;
output [ARRAY_WIDTH-1 : 0] config_reg88;
output [ARRAY_WIDTH-1 : 0] config_reg89;
output [ARRAY_WIDTH-1 : 0] config_reg90;
output [ARRAY_WIDTH-1 : 0] config_reg91;
output [ARRAY_WIDTH-1 : 0] config_reg92;
output [ARRAY_WIDTH-1 : 0] config_reg93;
output [ARRAY_WIDTH-1 : 0] config_reg94;
output [ARRAY_WIDTH-1 : 0] config_reg95;
output [ARRAY_WIDTH-1 : 0] config_reg96;
output [ARRAY_WIDTH-1 : 0] config_reg97;
output [ARRAY_WIDTH-1 : 0] config_reg98;
output [ARRAY_WIDTH-1 : 0] config_reg99;
output [ARRAY_WIDTH-1 : 0] config_reg100;
output [ARRAY_WIDTH-1 : 0] config_reg101;
output [ARRAY_WIDTH-1 : 0] config_reg102;
output [ARRAY_WIDTH-1 : 0] config_reg103;
output [ARRAY_WIDTH-1 : 0] config_reg104;
output [ARRAY_WIDTH-1 : 0] config_reg105;
output [ARRAY_WIDTH-1 : 0] config_reg106;
output [ARRAY_WIDTH-1 : 0] config_reg107;
output [ARRAY_WIDTH-1 : 0] config_reg108;
output [ARRAY_WIDTH-1 : 0] config_reg109;
output [ARRAY_WIDTH-1 : 0] config_reg110;
output [ARRAY_WIDTH-1 : 0] config_reg111;
output [ARRAY_WIDTH-1 : 0] config_reg112;
output [ARRAY_WIDTH-1 : 0] config_reg113;
output [ARRAY_WIDTH-1 : 0] config_reg114;
output [ARRAY_WIDTH-1 : 0] config_reg115;
output [ARRAY_WIDTH-1 : 0] config_reg116;
output [ARRAY_WIDTH-1 : 0] config_reg117;
output [ARRAY_WIDTH-1 : 0] config_reg118;
output [ARRAY_WIDTH-1 : 0] config_reg119;
output [ARRAY_WIDTH-1 : 0] config_reg120;
output [ARRAY_WIDTH-1 : 0] config_reg121;
output [ARRAY_WIDTH-1 : 0] config_reg122;
output [ARRAY_WIDTH-1 : 0] config_reg123;
output [ARRAY_WIDTH-1 : 0] config_reg124;
output [ARRAY_WIDTH-1 : 0] config_reg125;
output [ARRAY_WIDTH-1 : 0] config_reg126;
output [ARRAY_WIDTH-1 : 0] config_reg127;

wire [ARRAY_WIDTH-1 :0] capture_in;
wire [ARRAY_WIDTH-1 :0] data_out;
wire [ADDR_WIDTH-1 :0] addr_out;
reg [ARRAY_WIDTH-1 :0] capture_int;
reg [ARRAY_DEPTH-1 : 0] update_int;

assign capture_in = capture_int;

assign config_reg0 = config_out_int[ARRAY_WIDTH*(0+1)-1 : ARRAY_WIDTH*0];
assign config_reg1 = config_out_int[ARRAY_WIDTH*(1+1)-1 : ARRAY_WIDTH*1];
assign config_reg2 = config_out_int[ARRAY_WIDTH*(2+1)-1 : ARRAY_WIDTH*2];
assign config_reg3 = config_out_int[ARRAY_WIDTH*(3+1)-1 : ARRAY_WIDTH*3];
assign config_reg4 = config_out_int[ARRAY_WIDTH*(4+1)-1 : ARRAY_WIDTH*4];
assign config_reg5 = config_out_int[ARRAY_WIDTH*(5+1)-1 : ARRAY_WIDTH*5];
assign config_reg6 = config_out_int[ARRAY_WIDTH*(6+1)-1 : ARRAY_WIDTH*6];
assign config_reg7 = config_out_int[ARRAY_WIDTH*(7+1)-1 : ARRAY_WIDTH*7];
assign config_reg8 = config_out_int[ARRAY_WIDTH*(8+1)-1 : ARRAY_WIDTH*8];
assign config_reg9 = config_out_int[ARRAY_WIDTH*(9+1)-1 : ARRAY_WIDTH*9];
assign config_reg10 = config_out_int[ARRAY_WIDTH*(10+1)-1 : ARRAY_WIDTH*10];
assign config_reg11 = config_out_int[ARRAY_WIDTH*(11+1)-1 : ARRAY_WIDTH*11];
assign config_reg12 = config_out_int[ARRAY_WIDTH*(12+1)-1 : ARRAY_WIDTH*12];
assign config_reg13 = config_out_int[ARRAY_WIDTH*(13+1)-1 : ARRAY_WIDTH*13];
assign config_reg14 = config_out_int[ARRAY_WIDTH*(14+1)-1 : ARRAY_WIDTH*14];
assign config_reg15 = config_out_int[ARRAY_WIDTH*(15+1)-1 : ARRAY_WIDTH*15];
assign config_reg16 = config_out_int[ARRAY_WIDTH*(16+1)-1 : ARRAY_WIDTH*16];
assign config_reg17 = config_out_int[ARRAY_WIDTH*(17+1)-1 : ARRAY_WIDTH*17];
assign config_reg18 = config_out_int[ARRAY_WIDTH*(18+1)-1 : ARRAY_WIDTH*18];
assign config_reg19 = config_out_int[ARRAY_WIDTH*(19+1)-1 : ARRAY_WIDTH*19];
assign config_reg20 = config_out_int[ARRAY_WIDTH*(20+1)-1 : ARRAY_WIDTH*20];
assign config_reg21 = config_out_int[ARRAY_WIDTH*(21+1)-1 : ARRAY_WIDTH*21];
assign config_reg22 = config_out_int[ARRAY_WIDTH*(22+1)-1 : ARRAY_WIDTH*22];
assign config_reg23 = config_out_int[ARRAY_WIDTH*(23+1)-1 : ARRAY_WIDTH*23];
assign config_reg24 = config_out_int[ARRAY_WIDTH*(24+1)-1 : ARRAY_WIDTH*24];
assign config_reg25 = config_out_int[ARRAY_WIDTH*(25+1)-1 : ARRAY_WIDTH*25];
assign config_reg26 = config_out_int[ARRAY_WIDTH*(26+1)-1 : ARRAY_WIDTH*26];
assign config_reg27 = config_out_int[ARRAY_WIDTH*(27+1)-1 : ARRAY_WIDTH*27];
assign config_reg28 = config_out_int[ARRAY_WIDTH*(28+1)-1 : ARRAY_WIDTH*28];
assign config_reg29 = config_out_int[ARRAY_WIDTH*(29+1)-1 : ARRAY_WIDTH*29];
assign config_reg30 = config_out_int[ARRAY_WIDTH*(30+1)-1 : ARRAY_WIDTH*30];
assign config_reg31 = config_out_int[ARRAY_WIDTH*(31+1)-1 : ARRAY_WIDTH*31];
assign config_reg32 = config_out_int[ARRAY_WIDTH*(32+1)-1 : ARRAY_WIDTH*32];
assign config_reg33 = config_out_int[ARRAY_WIDTH*(33+1)-1 : ARRAY_WIDTH*33];
assign config_reg34 = config_out_int[ARRAY_WIDTH*(34+1)-1 : ARRAY_WIDTH*34];
assign config_reg35 = config_out_int[ARRAY_WIDTH*(35+1)-1 : ARRAY_WIDTH*35];
assign config_reg36 = config_out_int[ARRAY_WIDTH*(36+1)-1 : ARRAY_WIDTH*36];
assign config_reg37 = config_out_int[ARRAY_WIDTH*(37+1)-1 : ARRAY_WIDTH*37];
assign config_reg38 = config_out_int[ARRAY_WIDTH*(38+1)-1 : ARRAY_WIDTH*38];
assign config_reg39 = config_out_int[ARRAY_WIDTH*(39+1)-1 : ARRAY_WIDTH*39];
assign config_reg40 = config_out_int[ARRAY_WIDTH*(40+1)-1 : ARRAY_WIDTH*40];
assign config_reg41 = config_out_int[ARRAY_WIDTH*(41+1)-1 : ARRAY_WIDTH*41];
assign config_reg42 = config_out_int[ARRAY_WIDTH*(42+1)-1 : ARRAY_WIDTH*42];
assign config_reg43 = config_out_int[ARRAY_WIDTH*(43+1)-1 : ARRAY_WIDTH*43];
assign config_reg44 = config_out_int[ARRAY_WIDTH*(44+1)-1 : ARRAY_WIDTH*44];
assign config_reg45 = config_out_int[ARRAY_WIDTH*(45+1)-1 : ARRAY_WIDTH*45];
assign config_reg46 = config_out_int[ARRAY_WIDTH*(46+1)-1 : ARRAY_WIDTH*46];
assign config_reg47 = config_out_int[ARRAY_WIDTH*(47+1)-1 : ARRAY_WIDTH*47];
assign config_reg48 = config_out_int[ARRAY_WIDTH*(48+1)-1 : ARRAY_WIDTH*48];
assign config_reg49 = config_out_int[ARRAY_WIDTH*(49+1)-1 : ARRAY_WIDTH*49];
assign config_reg50 = config_out_int[ARRAY_WIDTH*(50+1)-1 : ARRAY_WIDTH*50];
assign config_reg51 = config_out_int[ARRAY_WIDTH*(51+1)-1 : ARRAY_WIDTH*51];
assign config_reg52 = config_out_int[ARRAY_WIDTH*(52+1)-1 : ARRAY_WIDTH*52];
assign config_reg53 = config_out_int[ARRAY_WIDTH*(53+1)-1 : ARRAY_WIDTH*53];
assign config_reg54 = config_out_int[ARRAY_WIDTH*(54+1)-1 : ARRAY_WIDTH*54];
assign config_reg55 = config_out_int[ARRAY_WIDTH*(55+1)-1 : ARRAY_WIDTH*55];
assign config_reg56 = config_out_int[ARRAY_WIDTH*(56+1)-1 : ARRAY_WIDTH*56];
assign config_reg57 = config_out_int[ARRAY_WIDTH*(57+1)-1 : ARRAY_WIDTH*57];
assign config_reg58 = config_out_int[ARRAY_WIDTH*(58+1)-1 : ARRAY_WIDTH*58];
assign config_reg59 = config_out_int[ARRAY_WIDTH*(59+1)-1 : ARRAY_WIDTH*59];
assign config_reg60 = config_out_int[ARRAY_WIDTH*(60+1)-1 : ARRAY_WIDTH*60];
assign config_reg61 = config_out_int[ARRAY_WIDTH*(61+1)-1 : ARRAY_WIDTH*61];
assign config_reg62 = config_out_int[ARRAY_WIDTH*(62+1)-1 : ARRAY_WIDTH*62];
assign config_reg63 = config_out_int[ARRAY_WIDTH*(63+1)-1 : ARRAY_WIDTH*63];
assign config_reg64 = config_out_int[ARRAY_WIDTH*(64+1)-1 : ARRAY_WIDTH*64];
assign config_reg65 = config_out_int[ARRAY_WIDTH*(65+1)-1 : ARRAY_WIDTH*65];
assign config_reg66 = config_out_int[ARRAY_WIDTH*(66+1)-1 : ARRAY_WIDTH*66];
assign config_reg67 = config_out_int[ARRAY_WIDTH*(67+1)-1 : ARRAY_WIDTH*67];
assign config_reg68 = config_out_int[ARRAY_WIDTH*(68+1)-1 : ARRAY_WIDTH*68];
assign config_reg69 = config_out_int[ARRAY_WIDTH*(69+1)-1 : ARRAY_WIDTH*69];
assign config_reg70 = config_out_int[ARRAY_WIDTH*(70+1)-1 : ARRAY_WIDTH*70];
assign config_reg71 = config_out_int[ARRAY_WIDTH*(71+1)-1 : ARRAY_WIDTH*71];
assign config_reg72 = config_out_int[ARRAY_WIDTH*(72+1)-1 : ARRAY_WIDTH*72];
assign config_reg73 = config_out_int[ARRAY_WIDTH*(73+1)-1 : ARRAY_WIDTH*73];
assign config_reg74 = config_out_int[ARRAY_WIDTH*(74+1)-1 : ARRAY_WIDTH*74];
assign config_reg75 = config_out_int[ARRAY_WIDTH*(75+1)-1 : ARRAY_WIDTH*75];
assign config_reg76 = config_out_int[ARRAY_WIDTH*(76+1)-1 : ARRAY_WIDTH*76];
assign config_reg77 = config_out_int[ARRAY_WIDTH*(77+1)-1 : ARRAY_WIDTH*77];
assign config_reg78 = config_out_int[ARRAY_WIDTH*(78+1)-1 : ARRAY_WIDTH*78];
assign config_reg79 = config_out_int[ARRAY_WIDTH*(79+1)-1 : ARRAY_WIDTH*79];
assign config_reg80 = config_out_int[ARRAY_WIDTH*(80+1)-1 : ARRAY_WIDTH*80];
assign config_reg81 = config_out_int[ARRAY_WIDTH*(81+1)-1 : ARRAY_WIDTH*81];
assign config_reg82 = config_out_int[ARRAY_WIDTH*(82+1)-1 : ARRAY_WIDTH*82];
assign config_reg83 = config_out_int[ARRAY_WIDTH*(83+1)-1 : ARRAY_WIDTH*83];
assign config_reg84 = config_out_int[ARRAY_WIDTH*(84+1)-1 : ARRAY_WIDTH*84];
assign config_reg85 = config_out_int[ARRAY_WIDTH*(85+1)-1 : ARRAY_WIDTH*85];
assign config_reg86 = config_out_int[ARRAY_WIDTH*(86+1)-1 : ARRAY_WIDTH*86];
assign config_reg87 = config_out_int[ARRAY_WIDTH*(87+1)-1 : ARRAY_WIDTH*87];
assign config_reg88 = config_out_int[ARRAY_WIDTH*(88+1)-1 : ARRAY_WIDTH*88];
assign config_reg89 = config_out_int[ARRAY_WIDTH*(89+1)-1 : ARRAY_WIDTH*89];
assign config_reg90 = config_out_int[ARRAY_WIDTH*(90+1)-1 : ARRAY_WIDTH*90];
assign config_reg91 = config_out_int[ARRAY_WIDTH*(91+1)-1 : ARRAY_WIDTH*91];
assign config_reg92 = config_out_int[ARRAY_WIDTH*(92+1)-1 : ARRAY_WIDTH*92];
assign config_reg93 = config_out_int[ARRAY_WIDTH*(93+1)-1 : ARRAY_WIDTH*93];
assign config_reg94 = config_out_int[ARRAY_WIDTH*(94+1)-1 : ARRAY_WIDTH*94];
assign config_reg95 = config_out_int[ARRAY_WIDTH*(95+1)-1 : ARRAY_WIDTH*95];
assign config_reg96 = config_out_int[ARRAY_WIDTH*(96+1)-1 : ARRAY_WIDTH*96];
assign config_reg97 = config_out_int[ARRAY_WIDTH*(97+1)-1 : ARRAY_WIDTH*97];
assign config_reg98 = config_out_int[ARRAY_WIDTH*(98+1)-1 : ARRAY_WIDTH*98];
assign config_reg99 = config_out_int[ARRAY_WIDTH*(99+1)-1 : ARRAY_WIDTH*99];
assign config_reg100 = config_out_int[ARRAY_WIDTH*(100+1)-1 : ARRAY_WIDTH*100];
assign config_reg101 = config_out_int[ARRAY_WIDTH*(101+1)-1 : ARRAY_WIDTH*101];
assign config_reg102 = config_out_int[ARRAY_WIDTH*(102+1)-1 : ARRAY_WIDTH*102];
assign config_reg103 = config_out_int[ARRAY_WIDTH*(103+1)-1 : ARRAY_WIDTH*103];
assign config_reg104 = config_out_int[ARRAY_WIDTH*(104+1)-1 : ARRAY_WIDTH*104];
assign config_reg105 = config_out_int[ARRAY_WIDTH*(105+1)-1 : ARRAY_WIDTH*105];
assign config_reg106 = config_out_int[ARRAY_WIDTH*(106+1)-1 : ARRAY_WIDTH*106];
assign config_reg107 = config_out_int[ARRAY_WIDTH*(107+1)-1 : ARRAY_WIDTH*107];
assign config_reg108 = config_out_int[ARRAY_WIDTH*(108+1)-1 : ARRAY_WIDTH*108];
assign config_reg109 = config_out_int[ARRAY_WIDTH*(109+1)-1 : ARRAY_WIDTH*109];
assign config_reg110 = config_out_int[ARRAY_WIDTH*(110+1)-1 : ARRAY_WIDTH*110];
assign config_reg111 = config_out_int[ARRAY_WIDTH*(111+1)-1 : ARRAY_WIDTH*111];
assign config_reg112 = config_out_int[ARRAY_WIDTH*(112+1)-1 : ARRAY_WIDTH*112];
assign config_reg113 = config_out_int[ARRAY_WIDTH*(113+1)-1 : ARRAY_WIDTH*113];
assign config_reg114 = config_out_int[ARRAY_WIDTH*(114+1)-1 : ARRAY_WIDTH*114];
assign config_reg115 = config_out_int[ARRAY_WIDTH*(115+1)-1 : ARRAY_WIDTH*115];
assign config_reg116 = config_out_int[ARRAY_WIDTH*(116+1)-1 : ARRAY_WIDTH*116];
assign config_reg117 = config_out_int[ARRAY_WIDTH*(117+1)-1 : ARRAY_WIDTH*117];
assign config_reg118 = config_out_int[ARRAY_WIDTH*(118+1)-1 : ARRAY_WIDTH*118];
assign config_reg119 = config_out_int[ARRAY_WIDTH*(119+1)-1 : ARRAY_WIDTH*119];
assign config_reg120 = config_out_int[ARRAY_WIDTH*(120+1)-1 : ARRAY_WIDTH*120];
assign config_reg121 = config_out_int[ARRAY_WIDTH*(121+1)-1 : ARRAY_WIDTH*121];
assign config_reg122 = config_out_int[ARRAY_WIDTH*(122+1)-1 : ARRAY_WIDTH*122];
assign config_reg123 = config_out_int[ARRAY_WIDTH*(123+1)-1 : ARRAY_WIDTH*123];
assign config_reg124 = config_out_int[ARRAY_WIDTH*(124+1)-1 : ARRAY_WIDTH*124];
assign config_reg125 = config_out_int[ARRAY_WIDTH*(125+1)-1 : ARRAY_WIDTH*125];
assign config_reg126 = config_out_int[ARRAY_WIDTH*(126+1)-1 : ARRAY_WIDTH*126];
assign config_reg127 = config_out_int[ARRAY_WIDTH*(127+1)-1 : ARRAY_WIDTH*127];

spi_cell_top spi_cell_top1
	(
	.reset_n(reset_n),
	.clk_phase1(clk_phase1),
	.clk_phase2(clk_phase2),
	.capture(capture|clk_update),
	.spi_din(spi_din),
	.capture_in(capture_in),
	.spi_out(spi_out),
	.data_out(data_out),
	.addr_out(addr_out)
);
integer i;
always @(*) begin
	for (i=0; i < ARRAY_DEPTH; i=i+1) begin 
			update_int[i] <= clk_update & ( addr_out==i);
	end
end
//..............................Update......................//
//..............................0......................//
always @( posedge update_int[0] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(0+1)-1) : ARRAY_WIDTH*0] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(0+1)-1 : ARRAY_WIDTH*0] <= data_out;
end
//..............................1......................//
always @( posedge update_int[1] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(1+1)-1) : ARRAY_WIDTH*1] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(1+1)-1 : ARRAY_WIDTH*1] <= data_out;
end
//..............................2......................//
always @( posedge update_int[2] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(2+1)-1) : ARRAY_WIDTH*2] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(2+1)-1 : ARRAY_WIDTH*2] <= data_out;
end
//..............................3......................//
always @( posedge update_int[3] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(3+1)-1) : ARRAY_WIDTH*3] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(3+1)-1 : ARRAY_WIDTH*3] <= data_out;
end
//..............................4......................//
always @( posedge update_int[4] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(4+1)-1) : ARRAY_WIDTH*4] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(4+1)-1 : ARRAY_WIDTH*4] <= data_out;
end
//..............................5......................//
always @( posedge update_int[5] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(5+1)-1) : ARRAY_WIDTH*5] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(5+1)-1 : ARRAY_WIDTH*5] <= data_out;
end
//..............................6......................//
always @( posedge update_int[6] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(6+1)-1) : ARRAY_WIDTH*6] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(6+1)-1 : ARRAY_WIDTH*6] <= data_out;
end
//..............................7......................//
always @( posedge update_int[7] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(7+1)-1) : ARRAY_WIDTH*7] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(7+1)-1 : ARRAY_WIDTH*7] <= data_out;
end
//..............................8......................//
always @( posedge update_int[8] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(8+1)-1) : ARRAY_WIDTH*8] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(8+1)-1 : ARRAY_WIDTH*8] <= data_out;
end
//..............................9......................//
always @( posedge update_int[9] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(9+1)-1) : ARRAY_WIDTH*9] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(9+1)-1 : ARRAY_WIDTH*9] <= data_out;
end
//..............................10......................//
always @( posedge update_int[10] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(10+1)-1) : ARRAY_WIDTH*10] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(10+1)-1 : ARRAY_WIDTH*10] <= data_out;
end
//..............................11......................//
always @( posedge update_int[11] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(11+1)-1) : ARRAY_WIDTH*11] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(11+1)-1 : ARRAY_WIDTH*11] <= data_out;
end
//..............................12......................//
always @( posedge update_int[12] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(12+1)-1) : ARRAY_WIDTH*12] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(12+1)-1 : ARRAY_WIDTH*12] <= data_out;
end
//..............................13......................//
always @( posedge update_int[13] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(13+1)-1) : ARRAY_WIDTH*13] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(13+1)-1 : ARRAY_WIDTH*13] <= data_out;
end
//..............................14......................//
always @( posedge update_int[14] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(14+1)-1) : ARRAY_WIDTH*14] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(14+1)-1 : ARRAY_WIDTH*14] <= data_out;
end
//..............................15......................//
always @( posedge update_int[15] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(15+1)-1) : ARRAY_WIDTH*15] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(15+1)-1 : ARRAY_WIDTH*15] <= data_out;
end
//..............................16......................//
always @( posedge update_int[16] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(16+1)-1) : ARRAY_WIDTH*16] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(16+1)-1 : ARRAY_WIDTH*16] <= data_out;
end
//..............................17......................//
always @( posedge update_int[17] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(17+1)-1) : ARRAY_WIDTH*17] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(17+1)-1 : ARRAY_WIDTH*17] <= data_out;
end
//..............................18......................//
always @( posedge update_int[18] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(18+1)-1) : ARRAY_WIDTH*18] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(18+1)-1 : ARRAY_WIDTH*18] <= data_out;
end
//..............................19......................//
always @( posedge update_int[19] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(19+1)-1) : ARRAY_WIDTH*19] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(19+1)-1 : ARRAY_WIDTH*19] <= data_out;
end
//..............................20......................//
always @( posedge update_int[20] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(20+1)-1) : ARRAY_WIDTH*20] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(20+1)-1 : ARRAY_WIDTH*20] <= data_out;
end
//..............................21......................//
always @( posedge update_int[21] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(21+1)-1) : ARRAY_WIDTH*21] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(21+1)-1 : ARRAY_WIDTH*21] <= data_out;
end
//..............................22......................//
always @( posedge update_int[22] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(22+1)-1) : ARRAY_WIDTH*22] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(22+1)-1 : ARRAY_WIDTH*22] <= data_out;
end
//..............................23......................//
always @( posedge update_int[23] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(23+1)-1) : ARRAY_WIDTH*23] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(23+1)-1 : ARRAY_WIDTH*23] <= data_out;
end
//..............................24......................//
always @( posedge update_int[24] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(24+1)-1) : ARRAY_WIDTH*24] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(24+1)-1 : ARRAY_WIDTH*24] <= data_out;
end
//..............................25......................//
always @( posedge update_int[25] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(25+1)-1) : ARRAY_WIDTH*25] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(25+1)-1 : ARRAY_WIDTH*25] <= data_out;
end
//..............................26......................//
always @( posedge update_int[26] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(26+1)-1) : ARRAY_WIDTH*26] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(26+1)-1 : ARRAY_WIDTH*26] <= data_out;
end
//..............................27......................//
always @( posedge update_int[27] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(27+1)-1) : ARRAY_WIDTH*27] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(27+1)-1 : ARRAY_WIDTH*27] <= data_out;
end
//..............................28......................//
always @( posedge update_int[28] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(28+1)-1) : ARRAY_WIDTH*28] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(28+1)-1 : ARRAY_WIDTH*28] <= data_out;
end
//..............................29......................//
always @( posedge update_int[29] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(29+1)-1) : ARRAY_WIDTH*29] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(29+1)-1 : ARRAY_WIDTH*29] <= data_out;
end
//..............................30......................//
always @( posedge update_int[30] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(30+1)-1) : ARRAY_WIDTH*30] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(30+1)-1 : ARRAY_WIDTH*30] <= data_out;
end
//..............................31......................//
always @( posedge update_int[31] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(31+1)-1) : ARRAY_WIDTH*31] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(31+1)-1 : ARRAY_WIDTH*31] <= data_out;
end
//..............................32......................//
always @( posedge update_int[32] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(32+1)-1) : ARRAY_WIDTH*32] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(32+1)-1 : ARRAY_WIDTH*32] <= data_out;
end
//..............................33......................//
always @( posedge update_int[33] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(33+1)-1) : ARRAY_WIDTH*33] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(33+1)-1 : ARRAY_WIDTH*33] <= data_out;
end
//..............................34......................//
always @( posedge update_int[34] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(34+1)-1) : ARRAY_WIDTH*34] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(34+1)-1 : ARRAY_WIDTH*34] <= data_out;
end
//..............................35......................//
always @( posedge update_int[35] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(35+1)-1) : ARRAY_WIDTH*35] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(35+1)-1 : ARRAY_WIDTH*35] <= data_out;
end
//..............................36......................//
always @( posedge update_int[36] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(36+1)-1) : ARRAY_WIDTH*36] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(36+1)-1 : ARRAY_WIDTH*36] <= data_out;
end
//..............................37......................//
always @( posedge update_int[37] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(37+1)-1) : ARRAY_WIDTH*37] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(37+1)-1 : ARRAY_WIDTH*37] <= data_out;
end
//..............................38......................//
always @( posedge update_int[38] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(38+1)-1) : ARRAY_WIDTH*38] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(38+1)-1 : ARRAY_WIDTH*38] <= data_out;
end
//..............................39......................//
always @( posedge update_int[39] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(39+1)-1) : ARRAY_WIDTH*39] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(39+1)-1 : ARRAY_WIDTH*39] <= data_out;
end
//..............................40......................//
always @( posedge update_int[40] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(40+1)-1) : ARRAY_WIDTH*40] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(40+1)-1 : ARRAY_WIDTH*40] <= data_out;
end
//..............................41......................//
always @( posedge update_int[41] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(41+1)-1) : ARRAY_WIDTH*41] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(41+1)-1 : ARRAY_WIDTH*41] <= data_out;
end
//..............................42......................//
always @( posedge update_int[42] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(42+1)-1) : ARRAY_WIDTH*42] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(42+1)-1 : ARRAY_WIDTH*42] <= data_out;
end
//..............................43......................//
always @( posedge update_int[43] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(43+1)-1) : ARRAY_WIDTH*43] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(43+1)-1 : ARRAY_WIDTH*43] <= data_out;
end
//..............................44......................//
always @( posedge update_int[44] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(44+1)-1) : ARRAY_WIDTH*44] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(44+1)-1 : ARRAY_WIDTH*44] <= data_out;
end
//..............................45......................//
always @( posedge update_int[45] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(45+1)-1) : ARRAY_WIDTH*45] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(45+1)-1 : ARRAY_WIDTH*45] <= data_out;
end
//..............................46......................//
always @( posedge update_int[46] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(46+1)-1) : ARRAY_WIDTH*46] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(46+1)-1 : ARRAY_WIDTH*46] <= data_out;
end
//..............................47......................//
always @( posedge update_int[47] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(47+1)-1) : ARRAY_WIDTH*47] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(47+1)-1 : ARRAY_WIDTH*47] <= data_out;
end
//..............................48......................//
always @( posedge update_int[48] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(48+1)-1) : ARRAY_WIDTH*48] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(48+1)-1 : ARRAY_WIDTH*48] <= data_out;
end
//..............................49......................//
always @( posedge update_int[49] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(49+1)-1) : ARRAY_WIDTH*49] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(49+1)-1 : ARRAY_WIDTH*49] <= data_out;
end
//..............................50......................//
always @( posedge update_int[50] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(50+1)-1) : ARRAY_WIDTH*50] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(50+1)-1 : ARRAY_WIDTH*50] <= data_out;
end
//..............................51......................//
always @( posedge update_int[51] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(51+1)-1) : ARRAY_WIDTH*51] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(51+1)-1 : ARRAY_WIDTH*51] <= data_out;
end
//..............................52......................//
always @( posedge update_int[52] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(52+1)-1) : ARRAY_WIDTH*52] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(52+1)-1 : ARRAY_WIDTH*52] <= data_out;
end
//..............................53......................//
always @( posedge update_int[53] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(53+1)-1) : ARRAY_WIDTH*53] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(53+1)-1 : ARRAY_WIDTH*53] <= data_out;
end
//..............................54......................//
always @( posedge update_int[54] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(54+1)-1) : ARRAY_WIDTH*54] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(54+1)-1 : ARRAY_WIDTH*54] <= data_out;
end
//..............................55......................//
always @( posedge update_int[55] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(55+1)-1) : ARRAY_WIDTH*55] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(55+1)-1 : ARRAY_WIDTH*55] <= data_out;
end
//..............................56......................//
always @( posedge update_int[56] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(56+1)-1) : ARRAY_WIDTH*56] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(56+1)-1 : ARRAY_WIDTH*56] <= data_out;
end
//..............................57......................//
always @( posedge update_int[57] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(57+1)-1) : ARRAY_WIDTH*57] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(57+1)-1 : ARRAY_WIDTH*57] <= data_out;
end
//..............................58......................//
always @( posedge update_int[58] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(58+1)-1) : ARRAY_WIDTH*58] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(58+1)-1 : ARRAY_WIDTH*58] <= data_out;
end
//..............................59......................//
always @( posedge update_int[59] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(59+1)-1) : ARRAY_WIDTH*59] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(59+1)-1 : ARRAY_WIDTH*59] <= data_out;
end
//..............................60......................//
always @( posedge update_int[60] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(60+1)-1) : ARRAY_WIDTH*60] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(60+1)-1 : ARRAY_WIDTH*60] <= data_out;
end
//..............................61......................//
always @( posedge update_int[61] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(61+1)-1) : ARRAY_WIDTH*61] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(61+1)-1 : ARRAY_WIDTH*61] <= data_out;
end
//..............................62......................//
always @( posedge update_int[62] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(62+1)-1) : ARRAY_WIDTH*62] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(62+1)-1 : ARRAY_WIDTH*62] <= data_out;
end
//..............................63......................//
always @( posedge update_int[63] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(63+1)-1) : ARRAY_WIDTH*63] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(63+1)-1 : ARRAY_WIDTH*63] <= data_out;
end
//..............................64......................//
always @( posedge update_int[64] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(64+1)-1) : ARRAY_WIDTH*64] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(64+1)-1 : ARRAY_WIDTH*64] <= data_out;
end
//..............................65......................//
always @( posedge update_int[65] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(65+1)-1) : ARRAY_WIDTH*65] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(65+1)-1 : ARRAY_WIDTH*65] <= data_out;
end
//..............................66......................//
always @( posedge update_int[66] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(66+1)-1) : ARRAY_WIDTH*66] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(66+1)-1 : ARRAY_WIDTH*66] <= data_out;
end
//..............................67......................//
always @( posedge update_int[67] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(67+1)-1) : ARRAY_WIDTH*67] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(67+1)-1 : ARRAY_WIDTH*67] <= data_out;
end
//..............................68......................//
always @( posedge update_int[68] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(68+1)-1) : ARRAY_WIDTH*68] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(68+1)-1 : ARRAY_WIDTH*68] <= data_out;
end
//..............................69......................//
always @( posedge update_int[69] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(69+1)-1) : ARRAY_WIDTH*69] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(69+1)-1 : ARRAY_WIDTH*69] <= data_out;
end
//..............................70......................//
always @( posedge update_int[70] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(70+1)-1) : ARRAY_WIDTH*70] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(70+1)-1 : ARRAY_WIDTH*70] <= data_out;
end
//..............................71......................//
always @( posedge update_int[71] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(71+1)-1) : ARRAY_WIDTH*71] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(71+1)-1 : ARRAY_WIDTH*71] <= data_out;
end
//..............................72......................//
always @( posedge update_int[72] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(72+1)-1) : ARRAY_WIDTH*72] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(72+1)-1 : ARRAY_WIDTH*72] <= data_out;
end
//..............................73......................//
always @( posedge update_int[73] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(73+1)-1) : ARRAY_WIDTH*73] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(73+1)-1 : ARRAY_WIDTH*73] <= data_out;
end
//..............................74......................//
always @( posedge update_int[74] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(74+1)-1) : ARRAY_WIDTH*74] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(74+1)-1 : ARRAY_WIDTH*74] <= data_out;
end
//..............................75......................//
always @( posedge update_int[75] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(75+1)-1) : ARRAY_WIDTH*75] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(75+1)-1 : ARRAY_WIDTH*75] <= data_out;
end
//..............................76......................//
always @( posedge update_int[76] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(76+1)-1) : ARRAY_WIDTH*76] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(76+1)-1 : ARRAY_WIDTH*76] <= data_out;
end
//..............................77......................//
always @( posedge update_int[77] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(77+1)-1) : ARRAY_WIDTH*77] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(77+1)-1 : ARRAY_WIDTH*77] <= data_out;
end
//..............................78......................//
always @( posedge update_int[78] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(78+1)-1) : ARRAY_WIDTH*78] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(78+1)-1 : ARRAY_WIDTH*78] <= data_out;
end
//..............................79......................//
always @( posedge update_int[79] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(79+1)-1) : ARRAY_WIDTH*79] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(79+1)-1 : ARRAY_WIDTH*79] <= data_out;
end
//..............................80......................//
always @( posedge update_int[80] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(80+1)-1) : ARRAY_WIDTH*80] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(80+1)-1 : ARRAY_WIDTH*80] <= data_out;
end
//..............................81......................//
always @( posedge update_int[81] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(81+1)-1) : ARRAY_WIDTH*81] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(81+1)-1 : ARRAY_WIDTH*81] <= data_out;
end
//..............................82......................//
always @( posedge update_int[82] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(82+1)-1) : ARRAY_WIDTH*82] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(82+1)-1 : ARRAY_WIDTH*82] <= data_out;
end
//..............................83......................//
always @( posedge update_int[83] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(83+1)-1) : ARRAY_WIDTH*83] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(83+1)-1 : ARRAY_WIDTH*83] <= data_out;
end
//..............................84......................//
always @( posedge update_int[84] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(84+1)-1) : ARRAY_WIDTH*84] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(84+1)-1 : ARRAY_WIDTH*84] <= data_out;
end
//..............................85......................//
always @( posedge update_int[85] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(85+1)-1) : ARRAY_WIDTH*85] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(85+1)-1 : ARRAY_WIDTH*85] <= data_out;
end
//..............................86......................//
always @( posedge update_int[86] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(86+1)-1) : ARRAY_WIDTH*86] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(86+1)-1 : ARRAY_WIDTH*86] <= data_out;
end
//..............................87......................//
always @( posedge update_int[87] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(87+1)-1) : ARRAY_WIDTH*87] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(87+1)-1 : ARRAY_WIDTH*87] <= data_out;
end
//..............................88......................//
always @( posedge update_int[88] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(88+1)-1) : ARRAY_WIDTH*88] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(88+1)-1 : ARRAY_WIDTH*88] <= data_out;
end
//..............................89......................//
always @( posedge update_int[89] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(89+1)-1) : ARRAY_WIDTH*89] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(89+1)-1 : ARRAY_WIDTH*89] <= data_out;
end
//..............................90......................//
always @( posedge update_int[90] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(90+1)-1) : ARRAY_WIDTH*90] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(90+1)-1 : ARRAY_WIDTH*90] <= data_out;
end
//..............................91......................//
always @( posedge update_int[91] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(91+1)-1) : ARRAY_WIDTH*91] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(91+1)-1 : ARRAY_WIDTH*91] <= data_out;
end
//..............................92......................//
always @( posedge update_int[92] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(92+1)-1) : ARRAY_WIDTH*92] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(92+1)-1 : ARRAY_WIDTH*92] <= data_out;
end
//..............................93......................//
always @( posedge update_int[93] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(93+1)-1) : ARRAY_WIDTH*93] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(93+1)-1 : ARRAY_WIDTH*93] <= data_out;
end
//..............................94......................//
always @( posedge update_int[94] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(94+1)-1) : ARRAY_WIDTH*94] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(94+1)-1 : ARRAY_WIDTH*94] <= data_out;
end
//..............................95......................//
always @( posedge update_int[95] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(95+1)-1) : ARRAY_WIDTH*95] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(95+1)-1 : ARRAY_WIDTH*95] <= data_out;
end
//..............................96......................//
always @( posedge update_int[96] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(96+1)-1) : ARRAY_WIDTH*96] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(96+1)-1 : ARRAY_WIDTH*96] <= data_out;
end
//..............................97......................//
always @( posedge update_int[97] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(97+1)-1) : ARRAY_WIDTH*97] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(97+1)-1 : ARRAY_WIDTH*97] <= data_out;
end
//..............................98......................//
always @( posedge update_int[98] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(98+1)-1) : ARRAY_WIDTH*98] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(98+1)-1 : ARRAY_WIDTH*98] <= data_out;
end
//..............................99......................//
always @( posedge update_int[99] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(99+1)-1) : ARRAY_WIDTH*99] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(99+1)-1 : ARRAY_WIDTH*99] <= data_out;
end
//..............................100......................//
always @( posedge update_int[100] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(100+1)-1) : ARRAY_WIDTH*100] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(100+1)-1 : ARRAY_WIDTH*100] <= data_out;
end
//..............................101......................//
always @( posedge update_int[101] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(101+1)-1) : ARRAY_WIDTH*101] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(101+1)-1 : ARRAY_WIDTH*101] <= data_out;
end
//..............................102......................//
always @( posedge update_int[102] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(102+1)-1) : ARRAY_WIDTH*102] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(102+1)-1 : ARRAY_WIDTH*102] <= data_out;
end
//..............................103......................//
always @( posedge update_int[103] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(103+1)-1) : ARRAY_WIDTH*103] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(103+1)-1 : ARRAY_WIDTH*103] <= data_out;
end
//..............................104......................//
always @( posedge update_int[104] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(104+1)-1) : ARRAY_WIDTH*104] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(104+1)-1 : ARRAY_WIDTH*104] <= data_out;
end
//..............................105......................//
always @( posedge update_int[105] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(105+1)-1) : ARRAY_WIDTH*105] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(105+1)-1 : ARRAY_WIDTH*105] <= data_out;
end
//..............................106......................//
always @( posedge update_int[106] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(106+1)-1) : ARRAY_WIDTH*106] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(106+1)-1 : ARRAY_WIDTH*106] <= data_out;
end
//..............................107......................//
always @( posedge update_int[107] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(107+1)-1) : ARRAY_WIDTH*107] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(107+1)-1 : ARRAY_WIDTH*107] <= data_out;
end
//..............................108......................//
always @( posedge update_int[108] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(108+1)-1) : ARRAY_WIDTH*108] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(108+1)-1 : ARRAY_WIDTH*108] <= data_out;
end
//..............................109......................//
always @( posedge update_int[109] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(109+1)-1) : ARRAY_WIDTH*109] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(109+1)-1 : ARRAY_WIDTH*109] <= data_out;
end
//..............................110......................//
always @( posedge update_int[110] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(110+1)-1) : ARRAY_WIDTH*110] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(110+1)-1 : ARRAY_WIDTH*110] <= data_out;
end
//..............................111......................//
always @( posedge update_int[111] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(111+1)-1) : ARRAY_WIDTH*111] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(111+1)-1 : ARRAY_WIDTH*111] <= data_out;
end
//..............................112......................//
always @( posedge update_int[112] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(112+1)-1) : ARRAY_WIDTH*112] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(112+1)-1 : ARRAY_WIDTH*112] <= data_out;
end
//..............................113......................//
always @( posedge update_int[113] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(113+1)-1) : ARRAY_WIDTH*113] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(113+1)-1 : ARRAY_WIDTH*113] <= data_out;
end
//..............................114......................//
always @( posedge update_int[114] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(114+1)-1) : ARRAY_WIDTH*114] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(114+1)-1 : ARRAY_WIDTH*114] <= data_out;
end
//..............................115......................//
always @( posedge update_int[115] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(115+1)-1) : ARRAY_WIDTH*115] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(115+1)-1 : ARRAY_WIDTH*115] <= data_out;
end
//..............................116......................//
always @( posedge update_int[116] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(116+1)-1) : ARRAY_WIDTH*116] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(116+1)-1 : ARRAY_WIDTH*116] <= data_out;
end
//..............................117......................//
always @( posedge update_int[117] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(117+1)-1) : ARRAY_WIDTH*117] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(117+1)-1 : ARRAY_WIDTH*117] <= data_out;
end
//..............................118......................//
always @( posedge update_int[118] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(118+1)-1) : ARRAY_WIDTH*118] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(118+1)-1 : ARRAY_WIDTH*118] <= data_out;
end
//..............................119......................//
always @( posedge update_int[119] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(119+1)-1) : ARRAY_WIDTH*119] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(119+1)-1 : ARRAY_WIDTH*119] <= data_out;
end
//..............................120......................//
always @( posedge update_int[120] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(120+1)-1) : ARRAY_WIDTH*120] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(120+1)-1 : ARRAY_WIDTH*120] <= data_out;
end
//..............................121......................//
always @( posedge update_int[121] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(121+1)-1) : ARRAY_WIDTH*121] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(121+1)-1 : ARRAY_WIDTH*121] <= data_out;
end
//..............................122......................//
always @( posedge update_int[122] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(122+1)-1) : ARRAY_WIDTH*122] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(122+1)-1 : ARRAY_WIDTH*122] <= data_out;
end
//..............................123......................//
always @( posedge update_int[123] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(123+1)-1) : ARRAY_WIDTH*123] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(123+1)-1 : ARRAY_WIDTH*123] <= data_out;
end
//..............................124......................//
always @( posedge update_int[124] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(124+1)-1) : ARRAY_WIDTH*124] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(124+1)-1 : ARRAY_WIDTH*124] <= data_out;
end
//..............................125......................//
always @( posedge update_int[125] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(125+1)-1) : ARRAY_WIDTH*125] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(125+1)-1 : ARRAY_WIDTH*125] <= data_out;
end
//..............................126......................//
always @( posedge update_int[126] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(126+1)-1) : ARRAY_WIDTH*126] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(126+1)-1 : ARRAY_WIDTH*126] <= data_out;
end
//..............................127......................//
always @( posedge update_int[127] or negedge reset_n) begin
	if (!reset_n) config_out_int[(ARRAY_WIDTH*(127+1)-1) : ARRAY_WIDTH*127] <= {ARRAY_WIDTH{1'b0}};
	else config_out_int[ARRAY_WIDTH*(127+1)-1 : ARRAY_WIDTH*127] <= data_out;
end


//..............................CAPTURE......................//
//..............................0......................//
always @(*) begin
	case (addr_out)
//..............................0......................//
	8'd0 :	capture_int <= config_out_int[ARRAY_WIDTH*(0+1)-1 : ARRAY_WIDTH*0];
//..............................1......................//
	8'd1 :	capture_int <= config_out_int[ARRAY_WIDTH*(1+1)-1 : ARRAY_WIDTH*1];
//..............................2......................//
	8'd2 :	capture_int <= config_out_int[ARRAY_WIDTH*(2+1)-1 : ARRAY_WIDTH*2];
//..............................3......................//
	8'd3 :	capture_int <= config_out_int[ARRAY_WIDTH*(3+1)-1 : ARRAY_WIDTH*3];
//..............................4......................//
	8'd4 :	capture_int <= config_out_int[ARRAY_WIDTH*(4+1)-1 : ARRAY_WIDTH*4];
//..............................5......................//
	8'd5 :	capture_int <= config_out_int[ARRAY_WIDTH*(5+1)-1 : ARRAY_WIDTH*5];
//..............................6......................//
	8'd6 :	capture_int <= config_out_int[ARRAY_WIDTH*(6+1)-1 : ARRAY_WIDTH*6];
//..............................7......................//
	8'd7 :	capture_int <= config_out_int[ARRAY_WIDTH*(7+1)-1 : ARRAY_WIDTH*7];
//..............................8......................//
	8'd8 :	capture_int <= config_out_int[ARRAY_WIDTH*(8+1)-1 : ARRAY_WIDTH*8];
//..............................9......................//
	8'd9 :	capture_int <= config_out_int[ARRAY_WIDTH*(9+1)-1 : ARRAY_WIDTH*9];
//..............................10......................//
	8'd10 :	capture_int <= config_out_int[ARRAY_WIDTH*(10+1)-1 : ARRAY_WIDTH*10];
//..............................11......................//
	8'd11 :	capture_int <= config_out_int[ARRAY_WIDTH*(11+1)-1 : ARRAY_WIDTH*11];
//..............................12......................//
	8'd12 :	capture_int <= config_out_int[ARRAY_WIDTH*(12+1)-1 : ARRAY_WIDTH*12];
//..............................13......................//
	8'd13 :	capture_int <= config_out_int[ARRAY_WIDTH*(13+1)-1 : ARRAY_WIDTH*13];
//..............................14......................//
	8'd14 :	capture_int <= config_out_int[ARRAY_WIDTH*(14+1)-1 : ARRAY_WIDTH*14];
//..............................15......................//
	8'd15 :	capture_int <= config_out_int[ARRAY_WIDTH*(15+1)-1 : ARRAY_WIDTH*15];
//..............................16......................//
	8'd16 :	capture_int <= config_out_int[ARRAY_WIDTH*(16+1)-1 : ARRAY_WIDTH*16];
//..............................17......................//
	8'd17 :	capture_int <= config_out_int[ARRAY_WIDTH*(17+1)-1 : ARRAY_WIDTH*17];
//..............................18......................//
	8'd18 :	capture_int <= config_out_int[ARRAY_WIDTH*(18+1)-1 : ARRAY_WIDTH*18];
//..............................19......................//
	8'd19 :	capture_int <= config_out_int[ARRAY_WIDTH*(19+1)-1 : ARRAY_WIDTH*19];
//..............................20......................//
	8'd20 :	capture_int <= config_out_int[ARRAY_WIDTH*(20+1)-1 : ARRAY_WIDTH*20];
//..............................21......................//
	8'd21 :	capture_int <= config_out_int[ARRAY_WIDTH*(21+1)-1 : ARRAY_WIDTH*21];
//..............................22......................//
	8'd22 :	capture_int <= config_out_int[ARRAY_WIDTH*(22+1)-1 : ARRAY_WIDTH*22];
//..............................23......................//
	8'd23 :	capture_int <= config_out_int[ARRAY_WIDTH*(23+1)-1 : ARRAY_WIDTH*23];
//..............................24......................//
	8'd24 :	capture_int <= config_out_int[ARRAY_WIDTH*(24+1)-1 : ARRAY_WIDTH*24];
//..............................25......................//
	8'd25 :	capture_int <= config_out_int[ARRAY_WIDTH*(25+1)-1 : ARRAY_WIDTH*25];
//..............................26......................//
	8'd26 :	capture_int <= config_out_int[ARRAY_WIDTH*(26+1)-1 : ARRAY_WIDTH*26];
//..............................27......................//
	8'd27 :	capture_int <= config_out_int[ARRAY_WIDTH*(27+1)-1 : ARRAY_WIDTH*27];
//..............................28......................//
	8'd28 :	capture_int <= config_out_int[ARRAY_WIDTH*(28+1)-1 : ARRAY_WIDTH*28];
//..............................29......................//
	8'd29 :	capture_int <= config_out_int[ARRAY_WIDTH*(29+1)-1 : ARRAY_WIDTH*29];
//..............................30......................//
	8'd30 :	capture_int <= config_out_int[ARRAY_WIDTH*(30+1)-1 : ARRAY_WIDTH*30];
//..............................31......................//
	8'd31 :	capture_int <= config_out_int[ARRAY_WIDTH*(31+1)-1 : ARRAY_WIDTH*31];
//..............................32......................//
	8'd32 :	capture_int <= config_out_int[ARRAY_WIDTH*(32+1)-1 : ARRAY_WIDTH*32];
//..............................33......................//
	8'd33 :	capture_int <= config_out_int[ARRAY_WIDTH*(33+1)-1 : ARRAY_WIDTH*33];
//..............................34......................//
	8'd34 :	capture_int <= config_out_int[ARRAY_WIDTH*(34+1)-1 : ARRAY_WIDTH*34];
//..............................35......................//
	8'd35 :	capture_int <= config_out_int[ARRAY_WIDTH*(35+1)-1 : ARRAY_WIDTH*35];
//..............................36......................//
	8'd36 :	capture_int <= config_out_int[ARRAY_WIDTH*(36+1)-1 : ARRAY_WIDTH*36];
//..............................37......................//
	8'd37 :	capture_int <= config_out_int[ARRAY_WIDTH*(37+1)-1 : ARRAY_WIDTH*37];
//..............................38......................//
	8'd38 :	capture_int <= config_out_int[ARRAY_WIDTH*(38+1)-1 : ARRAY_WIDTH*38];
//..............................39......................//
	8'd39 :	capture_int <= config_out_int[ARRAY_WIDTH*(39+1)-1 : ARRAY_WIDTH*39];
//..............................40......................//
	8'd40 :	capture_int <= config_out_int[ARRAY_WIDTH*(40+1)-1 : ARRAY_WIDTH*40];
//..............................41......................//
	8'd41 :	capture_int <= config_out_int[ARRAY_WIDTH*(41+1)-1 : ARRAY_WIDTH*41];
//..............................42......................//
	8'd42 :	capture_int <= config_out_int[ARRAY_WIDTH*(42+1)-1 : ARRAY_WIDTH*42];
//..............................43......................//
	8'd43 :	capture_int <= config_out_int[ARRAY_WIDTH*(43+1)-1 : ARRAY_WIDTH*43];
//..............................44......................//
	8'd44 :	capture_int <= config_out_int[ARRAY_WIDTH*(44+1)-1 : ARRAY_WIDTH*44];
//..............................45......................//
	8'd45 :	capture_int <= config_out_int[ARRAY_WIDTH*(45+1)-1 : ARRAY_WIDTH*45];
//..............................46......................//
	8'd46 :	capture_int <= config_out_int[ARRAY_WIDTH*(46+1)-1 : ARRAY_WIDTH*46];
//..............................47......................//
	8'd47 :	capture_int <= config_out_int[ARRAY_WIDTH*(47+1)-1 : ARRAY_WIDTH*47];
//..............................48......................//
	8'd48 :	capture_int <= config_out_int[ARRAY_WIDTH*(48+1)-1 : ARRAY_WIDTH*48];
//..............................49......................//
	8'd49 :	capture_int <= config_out_int[ARRAY_WIDTH*(49+1)-1 : ARRAY_WIDTH*49];
//..............................50......................//
	8'd50 :	capture_int <= config_out_int[ARRAY_WIDTH*(50+1)-1 : ARRAY_WIDTH*50];
//..............................51......................//
	8'd51 :	capture_int <= config_out_int[ARRAY_WIDTH*(51+1)-1 : ARRAY_WIDTH*51];
//..............................52......................//
	8'd52 :	capture_int <= config_out_int[ARRAY_WIDTH*(52+1)-1 : ARRAY_WIDTH*52];
//..............................53......................//
	8'd53 :	capture_int <= config_out_int[ARRAY_WIDTH*(53+1)-1 : ARRAY_WIDTH*53];
//..............................54......................//
	8'd54 :	capture_int <= config_out_int[ARRAY_WIDTH*(54+1)-1 : ARRAY_WIDTH*54];
//..............................55......................//
	8'd55 :	capture_int <= config_out_int[ARRAY_WIDTH*(55+1)-1 : ARRAY_WIDTH*55];
//..............................56......................//
	8'd56 :	capture_int <= config_out_int[ARRAY_WIDTH*(56+1)-1 : ARRAY_WIDTH*56];
//..............................57......................//
	8'd57 :	capture_int <= config_out_int[ARRAY_WIDTH*(57+1)-1 : ARRAY_WIDTH*57];
//..............................58......................//
	8'd58 :	capture_int <= config_out_int[ARRAY_WIDTH*(58+1)-1 : ARRAY_WIDTH*58];
//..............................59......................//
	8'd59 :	capture_int <= config_out_int[ARRAY_WIDTH*(59+1)-1 : ARRAY_WIDTH*59];
//..............................60......................//
	8'd60 :	capture_int <= config_out_int[ARRAY_WIDTH*(60+1)-1 : ARRAY_WIDTH*60];
//..............................61......................//
	8'd61 :	capture_int <= config_out_int[ARRAY_WIDTH*(61+1)-1 : ARRAY_WIDTH*61];
//..............................62......................//
	8'd62 :	capture_int <= config_out_int[ARRAY_WIDTH*(62+1)-1 : ARRAY_WIDTH*62];
//..............................63......................//
	8'd63 :	capture_int <= config_out_int[ARRAY_WIDTH*(63+1)-1 : ARRAY_WIDTH*63];
//..............................64......................//
	8'd64 :	capture_int <= config_out_int[ARRAY_WIDTH*(64+1)-1 : ARRAY_WIDTH*64];
//..............................65......................//
	8'd65 :	capture_int <= config_out_int[ARRAY_WIDTH*(65+1)-1 : ARRAY_WIDTH*65];
//..............................66......................//
	8'd66 :	capture_int <= config_out_int[ARRAY_WIDTH*(66+1)-1 : ARRAY_WIDTH*66];
//..............................67......................//
	8'd67 :	capture_int <= config_out_int[ARRAY_WIDTH*(67+1)-1 : ARRAY_WIDTH*67];
//..............................68......................//
	8'd68 :	capture_int <= config_out_int[ARRAY_WIDTH*(68+1)-1 : ARRAY_WIDTH*68];
//..............................69......................//
	8'd69 :	capture_int <= config_out_int[ARRAY_WIDTH*(69+1)-1 : ARRAY_WIDTH*69];
//..............................70......................//
	8'd70 :	capture_int <= config_out_int[ARRAY_WIDTH*(70+1)-1 : ARRAY_WIDTH*70];
//..............................71......................//
	8'd71 :	capture_int <= config_out_int[ARRAY_WIDTH*(71+1)-1 : ARRAY_WIDTH*71];
//..............................72......................//
	8'd72 :	capture_int <= config_out_int[ARRAY_WIDTH*(72+1)-1 : ARRAY_WIDTH*72];
//..............................73......................//
	8'd73 :	capture_int <= config_out_int[ARRAY_WIDTH*(73+1)-1 : ARRAY_WIDTH*73];
//..............................74......................//
	8'd74 :	capture_int <= config_out_int[ARRAY_WIDTH*(74+1)-1 : ARRAY_WIDTH*74];
//..............................75......................//
	8'd75 :	capture_int <= config_out_int[ARRAY_WIDTH*(75+1)-1 : ARRAY_WIDTH*75];
//..............................76......................//
	8'd76 :	capture_int <= config_out_int[ARRAY_WIDTH*(76+1)-1 : ARRAY_WIDTH*76];
//..............................77......................//
	8'd77 :	capture_int <= config_out_int[ARRAY_WIDTH*(77+1)-1 : ARRAY_WIDTH*77];
//..............................78......................//
	8'd78 :	capture_int <= config_out_int[ARRAY_WIDTH*(78+1)-1 : ARRAY_WIDTH*78];
//..............................79......................//
	8'd79 :	capture_int <= config_out_int[ARRAY_WIDTH*(79+1)-1 : ARRAY_WIDTH*79];
//..............................80......................//
	8'd80 :	capture_int <= config_out_int[ARRAY_WIDTH*(80+1)-1 : ARRAY_WIDTH*80];
//..............................81......................//
	8'd81 :	capture_int <= config_out_int[ARRAY_WIDTH*(81+1)-1 : ARRAY_WIDTH*81];
//..............................82......................//
	8'd82 :	capture_int <= config_out_int[ARRAY_WIDTH*(82+1)-1 : ARRAY_WIDTH*82];
//..............................83......................//
	8'd83 :	capture_int <= config_out_int[ARRAY_WIDTH*(83+1)-1 : ARRAY_WIDTH*83];
//..............................84......................//
	8'd84 :	capture_int <= config_out_int[ARRAY_WIDTH*(84+1)-1 : ARRAY_WIDTH*84];
//..............................85......................//
	8'd85 :	capture_int <= config_out_int[ARRAY_WIDTH*(85+1)-1 : ARRAY_WIDTH*85];
//..............................86......................//
	8'd86 :	capture_int <= config_out_int[ARRAY_WIDTH*(86+1)-1 : ARRAY_WIDTH*86];
//..............................87......................//
	8'd87 :	capture_int <= config_out_int[ARRAY_WIDTH*(87+1)-1 : ARRAY_WIDTH*87];
//..............................88......................//
	8'd88 :	capture_int <= config_out_int[ARRAY_WIDTH*(88+1)-1 : ARRAY_WIDTH*88];
//..............................89......................//
	8'd89 :	capture_int <= config_out_int[ARRAY_WIDTH*(89+1)-1 : ARRAY_WIDTH*89];
//..............................90......................//
	8'd90 :	capture_int <= config_out_int[ARRAY_WIDTH*(90+1)-1 : ARRAY_WIDTH*90];
//..............................91......................//
	8'd91 :	capture_int <= config_out_int[ARRAY_WIDTH*(91+1)-1 : ARRAY_WIDTH*91];
//..............................92......................//
	8'd92 :	capture_int <= config_out_int[ARRAY_WIDTH*(92+1)-1 : ARRAY_WIDTH*92];
//..............................93......................//
	8'd93 :	capture_int <= config_out_int[ARRAY_WIDTH*(93+1)-1 : ARRAY_WIDTH*93];
//..............................94......................//
	8'd94 :	capture_int <= config_out_int[ARRAY_WIDTH*(94+1)-1 : ARRAY_WIDTH*94];
//..............................95......................//
	8'd95 :	capture_int <= config_out_int[ARRAY_WIDTH*(95+1)-1 : ARRAY_WIDTH*95];
//..............................96......................//
	8'd96 :	capture_int <= config_out_int[ARRAY_WIDTH*(96+1)-1 : ARRAY_WIDTH*96];
//..............................97......................//
	8'd97 :	capture_int <= config_out_int[ARRAY_WIDTH*(97+1)-1 : ARRAY_WIDTH*97];
//..............................98......................//
	8'd98 :	capture_int <= config_out_int[ARRAY_WIDTH*(98+1)-1 : ARRAY_WIDTH*98];
//..............................99......................//
	8'd99 :	capture_int <= config_out_int[ARRAY_WIDTH*(99+1)-1 : ARRAY_WIDTH*99];
//..............................100......................//
	8'd100 : capture_int <= config_out_int[ARRAY_WIDTH*(100+1)-1 : ARRAY_WIDTH*100];
//..............................101......................//
	8'd101 : capture_int <= config_out_int[ARRAY_WIDTH*(101+1)-1 : ARRAY_WIDTH*101];
//..............................102......................//
	8'd102 : capture_int <= config_out_int[ARRAY_WIDTH*(102+1)-1 : ARRAY_WIDTH*102];
//..............................103......................//
	8'd103 : capture_int <= config_out_int[ARRAY_WIDTH*(103+1)-1 : ARRAY_WIDTH*103];
//..............................104......................//
	8'd104 : capture_int <= config_out_int[ARRAY_WIDTH*(104+1)-1 : ARRAY_WIDTH*104];
//..............................105......................//
	8'd105 : capture_int <= config_out_int[ARRAY_WIDTH*(105+1)-1 : ARRAY_WIDTH*105];
//..............................106......................//
	8'd106 : capture_int <= config_out_int[ARRAY_WIDTH*(106+1)-1 : ARRAY_WIDTH*106];
//..............................107......................//
	8'd107 : capture_int <= config_out_int[ARRAY_WIDTH*(107+1)-1 : ARRAY_WIDTH*107];
//..............................108......................//
	8'd108 : capture_int <= config_out_int[ARRAY_WIDTH*(108+1)-1 : ARRAY_WIDTH*108];
//..............................109......................//
	8'd109 : capture_int <= config_out_int[ARRAY_WIDTH*(109+1)-1 : ARRAY_WIDTH*109];
//..............................110......................//
	8'd110 : capture_int <= config_out_int[ARRAY_WIDTH*(110+1)-1 : ARRAY_WIDTH*110];
//..............................111......................//
	8'd111 : capture_int <= config_out_int[ARRAY_WIDTH*(111+1)-1 : ARRAY_WIDTH*111];
//..............................112......................//
	8'd112 : capture_int <= config_out_int[ARRAY_WIDTH*(112+1)-1 : ARRAY_WIDTH*112];
//..............................113......................//
	8'd113 : capture_int <= config_out_int[ARRAY_WIDTH*(113+1)-1 : ARRAY_WIDTH*113];
//..............................114......................//
	8'd114 : capture_int <= config_out_int[ARRAY_WIDTH*(114+1)-1 : ARRAY_WIDTH*114];
//..............................115......................//
	8'd115 : capture_int <= config_out_int[ARRAY_WIDTH*(115+1)-1 : ARRAY_WIDTH*115];
//..............................116......................//
	8'd116 : capture_int <= config_out_int[ARRAY_WIDTH*(116+1)-1 : ARRAY_WIDTH*116];
//..............................117......................//
	8'd117 : capture_int <= config_out_int[ARRAY_WIDTH*(117+1)-1 : ARRAY_WIDTH*117];
//..............................118......................//
	8'd118 : capture_int <= config_out_int[ARRAY_WIDTH*(118+1)-1 : ARRAY_WIDTH*118];
//..............................119......................//
	8'd119 : capture_int <= config_out_int[ARRAY_WIDTH*(119+1)-1 : ARRAY_WIDTH*119];
//..............................120......................//
	8'd120 : capture_int <= config_out_int[ARRAY_WIDTH*(120+1)-1 : ARRAY_WIDTH*120];
//..............................121......................//
	8'd121 : capture_int <= config_out_int[ARRAY_WIDTH*(121+1)-1 : ARRAY_WIDTH*121];
//..............................122......................//
	8'd122 : capture_int <= config_out_int[ARRAY_WIDTH*(122+1)-1 : ARRAY_WIDTH*122];
//..............................123......................//
	8'd123 : capture_int <= config_out_int[ARRAY_WIDTH*(123+1)-1 : ARRAY_WIDTH*123];
//..............................124......................//
	8'd124 : capture_int <= config_out_int[ARRAY_WIDTH*(124+1)-1 : ARRAY_WIDTH*124];
//..............................125......................//
	8'd125 : capture_int <= config_out_int[ARRAY_WIDTH*(125+1)-1 : ARRAY_WIDTH*125];
//..............................126......................//
	8'd126 : capture_int <= config_out_int[ARRAY_WIDTH*(126+1)-1 : ARRAY_WIDTH*126];
//..............................127......................//
	8'd127 : capture_int <= config_out_int[ARRAY_WIDTH*(127+1)-1 : ARRAY_WIDTH*127];
	endcase
end
 
endmodule
