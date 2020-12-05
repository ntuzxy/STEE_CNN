%% setup XEM6010, do just once
% clear;
OK_Setup;%% Load the fpga bitstream code
% FPGA_Config(xem,'F:\OpalKelly_Matlab\OpalKelly\working_dir\ok_top_20us.bit');
% FPGA_Config(xem,'F:\GoogleDrive\6-Tapeout\Tapeout_201908\testing_code\OpalKelly_Verilog\testing_xem6010.bit');
%%
%load('image97.mat');
% FPGA_Config(xem,'C:\Users\Zhang\Desktop\OpalKelly3010_Verilog\working_dir\ok_top_320x240.bit');
FPGA_Config(xem,'C:\Users\Zhang\Desktop\OpalKelly3010_Verilog\working_dir\testing.bit');
%% 
% load raw image and pipe in to XEM
path_img = 'F:\sim_data\0_final_data_320x240_1.txt';
% path_img = 'F:\sim_data\0_initial_data_16x12.txt';
raw_img = importdata(path_img);
figure
imshow(raw_img);title('raw image');
%%
% parameters
% WIDTH = 320;
% HIGHT = 240;
% WIDTH = 16;
% HIGHT = 12;
addr_x_start = 0; addr_x_stop = 319; 
addr_y_start = 0; addr_y_stop = 239;
setwireinvalue(xem,hex2dec('10'),addr_x_start,hex2dec('ffff'));updatewireins(xem);
setwireinvalue(xem,hex2dec('11'),addr_y_start,hex2dec('ffff'));updatewireins(xem);
setwireinvalue(xem,hex2dec('12'),addr_x_stop,hex2dec('ffff'));updatewireins(xem);
setwireinvalue(xem,hex2dec('13'),addr_y_stop,hex2dec('ffff'));updatewireins(xem);
WIDTH = addr_x_stop - addr_x_start + 1;
HIGHT = addr_y_stop - addr_y_start + 1;
NumOfData = WIDTH*HIGHT;
input_img = zeros(HIGHT,WIDTH);
output_img = zeros(HIGHT,WIDTH);
data_in = zeros(NumOfData,1);
ddata_in = zeros(NumOfData*2,1);
for i = 1:HIGHT
    for j = 1:WIDTH
        data_in(j+(i-1)*WIDTH) = raw_img(i,j);
    end
end
for i = 1:NumOfData
    ddata_in(2*i-1) = data_in(i);
end
% reset
setwireinvalue(xem,hex2dec('07'),0,hex2dec('ffff'));updatewireins(xem);
setwireinvalue(xem,hex2dec('07'),1,hex2dec('ffff'));updatewireins(xem);
disp('reset done')
%
% config writinng: clear all
for i=0:63
    hex_addr=dec2hex(i,2);
    data_hex='0000';
    data=0;
    out=65000;
    while (out ~=data)
        writeconfig(xem,data_hex, hex_addr)
        %pause(0.01)
        out=readconfig(xem, hex_addr);
    end
    out1=readconfig_hex(xem, hex_addr)
end
disp('config clear done')

% config58.
% diffusion_t_sel = 1; %0-1
% diffusion_n_sel = 3; %0-3
% diffusion_r_sel = 15; %0-15
diffusion_t_sel = 0; %0-1
diffusion_n_sel = 0; %0-3
diffusion_r_sel = 0; %0-15
SLOT_X = 0;
SLOT_Y = 0;
fifo_en = 0;
data = diffusion_t_sel + diffusion_n_sel * 2 + diffusion_r_sel * 2^3 + SLOT_X * 2^7 + SLOT_Y * 2^11 + fifo_en * 2^15;
data_hex = dec2hex(data);
hex_addr=dec2hex(58,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
    pause(1)
end
out1=readconfig_hex(xem, hex_addr)

% config59. debug_en, rp_en
XSIZE_MIN = 0;
YSIZE_MIN = 0;
pg_en = 0;
rp_en1 = 1;
rp_en2 = 0;
debug_en = 1;

data = XSIZE_MIN + YSIZE_MIN * 2^4 + pg_en * 2^8 + rp_en1 * 2^9 + rp_en2 * 2^10 + debug_en * 2^11; %2^9 + 2^11;
data_hex = dec2hex(data);
hex_addr=dec2hex(59,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
    pause(1)
end
out1=readconfig_hex(xem, hex_addr)

% config61. sig_observe
data=14*2^5 + 14*2^9;
data_hex = dec2hex(data);
hex_addr=dec2hex(61,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
    pause(1)
end
out1=readconfig_hex(xem, hex_addr)

%%
% WrData
setwireinvalue(xem,hex2dec('01'),0,hex2dec('ffff'));updatewireins(xem);
% WR
WrReq = 1; 
setwireinvalue(xem,hex2dec('02'),WrReq*2^0,hex2dec('ffff'));updatewireins(xem);
%addr
setwireinvalue(xem,hex2dec('00'),15,hex2dec('ffff'));updatewireins(xem);
%dec_en
WrReq = 1; TOP_ROW_SEL = 1; decoder_row_en = 1; decoder_col_en_w = 1;
setwireinvalue(xem,hex2dec('02'),WrReq*2^0 + TOP_ROW_SEL*2^3 + decoder_row_en*2^12 + decoder_col_en_w*2^13,hex2dec('ffff'));updatewireins(xem);

setwireinvalue(xem,hex2dec('02'),0,hex2dec('ffff'));updatewireins(xem);


% RD
RdReq = 1; 
setwireinvalue(xem,hex2dec('02'),RdReq*2^1,hex2dec('ffff'));updatewireins(xem);
%EQ
EQ = 1;
setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + EQ*2^4,hex2dec('ffff'));updatewireins(xem);
pause(1)
%WL
WL = 1;
setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + WL*2^12,hex2dec('ffff'));updatewireins(xem);
%SA
SA = 1;
setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + SA*2^5,hex2dec('ffff'));updatewireins(xem);
%SA, RdPage
SA = 1; RdPage = 1;
setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + SA*2^5 + RdPage*2^6,hex2dec('ffff'));updatewireins(xem);
%TOP_ROW_SEL, RdGnt_delay
TOP_ROW_SEL = 1; RdGnt_delay = 1;
setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + TOP_ROW_SEL*2^3 + RdGnt_delay*2^11,hex2dec('ffff'));updatewireins(xem);
%
setwireinvalue(xem,hex2dec('02'),0,hex2dec('ffff'));updatewireins(xem);



