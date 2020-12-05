% function AMS035_ELM_Testing_16chips
%% setup XEM6010, do just once
% clear;
OK_Setup;%% Load the fpga bitstream code
% FPGA_Config(xem,'F:\OpalKelly_Matlab\OpalKelly\working_dir\ok_top_20us.bit');
% FPGA_Config(xem,'F:\GoogleDrive\6-Tapeout\Tapeout_201908\testing_code\OpalKelly_Verilog\testing_xem6010.bit');
%%
%load('image97.mat');
% FPGA_Config(xem,'C:\Users\Zhang\Desktop\OpalKelly3010_Verilog\working_dir\ok_top_320x240.bit');
% FPGA_Config(xem,'C:\Users\Zhang\Desktop\OpalKelly6010_Verilog\working_dir\ok_top.bit');
FPGA_Config(xem,'C:\Users\Zhang\Desktop\OpalKelly3010_Verilog\working_dir\aer_mimic.bit');
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
addr_x_start = 0; addr_x_stop = 239; 
addr_y_start = 0; addr_y_stop = 179;
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
fifo_en = 1;
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
debug_en = 0;

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
data=14*2^5 + 14*2^9; %set SIG_OBS1 as DOUT
% data=8*2^5 + 14*2^9; %set SIG_OBS1 as burst_en
data_hex = dec2hex(data);
hex_addr=dec2hex(61,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
    pause(1)
end
out1=readconfig_hex(xem, hex_addr)

% % config1
% burst_en = 1;
% burst_len = 1;%5;
% data=burst_en + burst_len*2^8;
% data_hex = dec2hex(data);
% hex_addr=dec2hex(1,2);
% 
% out=65000;
% while (out ~=data)
%     writeconfig(xem,data_hex, hex_addr)
%     out=readconfig(xem, hex_addr)
%     pause(1)
% end
% out1=readconfig_hex(xem, hex_addr)

% config2
us_cycle = 255;%100;
frame_len = 255;%66;
data=us_cycle + frame_len*2^8;
data_hex = dec2hex(data);
hex_addr=dec2hex(2,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
    pause(1)
end
out1=readconfig_hex(xem, hex_addr)

% clear memory
% setwireinvalue(xem,hex2dec('00'),4,hex2dec('0004'));updatewireins(xem); % automatically clear memory after reading
% setwireinvalue(xem,hex2dec('00'),8,hex2dec('0008'));updatewireins(xem); % force clear memory

% setwireinvalue(xem,hex2dec('00'),8,hex2dec('ffff'));updatewireins(xem);
% setwireinvalue(xem,hex2dec('00'),24,hex2dec('ffff'));updatewireins(xem);
% setwireinvalue(xem,hex2dec('00'),16,hex2dec('ffff'));updatewireins(xem);
% setwireinvalue(xem,hex2dec('00'),0,hex2dec('ffff'));updatewireins(xem);


% pipe data into FPGA
writetopipein(xem, hex2dec('80'), ddata_in, NumOfData*2); 
% setwireinvalue(xem,hex2dec('02'),0,hex2dec('ffff'));updatewireins(xem); % WrData @ force write




%% write by AER
% enable AER write
setwireinvalue(xem,hex2dec('00'),1,hex2dec('ffff'));updatewireins(xem);
% trig AER_mimic
% activatetriggerin(xem, hex2dec('40'), 0);updatewireins(xem);

% % config1
burst_en = 1;
burst_len = 254;%5;
data=burst_en + burst_len*2^8;
data_hex = dec2hex(data);
hex_addr=dec2hex(1,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
end
out1=readconfig_hex(xem, hex_addr)

% disable AER write
setwireinvalue(xem,hex2dec('00'),0,hex2dec('ffff'));updatewireins(xem);
burst_en = 0;
data=burst_en + burst_len*2^8;
data_hex = dec2hex(data);
hex_addr=dec2hex(1,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
end
out1=readconfig_hex(xem, hex_addr)

%% force write (internal addr_gen), can auto read
% writing
setwireinvalue(xem,hex2dec('01'),4,hex2dec('000c'));updatewireins(xem);%select WrReq and RdReq
activatetriggerin(xem, hex2dec('40'), 1);updatewireins(xem); %trig force write
% setwireinvalue(xem,hex2dec('01'),3,hex2dec('0003'));updatewireins(xem);%WrReq=wi01_data[0]=1, RdReq=wi01_data[1]=1
% setwireinvalue(xem,hex2dec('01'),0,hex2dec('0003'));updatewireins(xem);
pause(1);
%% force read (internal addr_gen)

% config61. sig_observe
data=14*2^5 + 14*2^9; %set SIG_OBS1 as DOUT
% data=8*2^5 + 14*2^9; %set SIG_OBS1 as burst_en
data_hex = dec2hex(data);
hex_addr=dec2hex(61,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
    pause(1)
end
out1=readconfig_hex(xem, hex_addr)

setwireinvalue(xem,hex2dec('01'),12,hex2dec('000c'));updatewireins(xem);%select WrReq and RdReq
% trig read CRAM
activatetriggerin(xem, hex2dec('40'), 2);updatewireins(xem);

%% reading
setwireinvalue(xem,hex2dec('01'),2,hex2dec('0003'));updatewireins(xem);
setwireinvalue(xem,hex2dec('01'),0,hex2dec('0003'));updatewireins(xem);

% pause(1);
%% plot
%
% pipe out from XEM and save data
data_in = zeros(NumOfData,1);
data_out = zeros(NumOfData,1);
ddata_out = zeros(NumOfData*2,2);
ddata_out(:,1) = readfrompipeout(xem, hex2dec('a1'), NumOfData*2);%ram
ddata_out(:,2) = readfrompipeout(xem, hex2dec('a2'), NumOfData*2);%ram-ic

for i = 1:NumOfData
    data_in(i) = ddata_out(2*i-1,1);
    data_out(i) = ddata_out(2*i-1,2);
end
for row = 1:HIGHT
    for col = 1:WIDTH
        input_img(row,col) = data_in((row-1) * WIDTH + col);
        output_img(row,col) = data_out((row-1) * WIDTH + col);
    end
end
figure;
% subplot(211);imshow(raw_img);title('raw image');
subplot(121);imshow(input_img);title('input image');
subplot(122);imshow(output_img);title('output image');



%%
% MEMCLR

FPGA_Config(xem,'C:\Users\Zhang\Desktop\OpalKelly3010_Verilog_MEMCLR\working_dir\ok_top.bit');
% reset
setwireinvalue(xem,hex2dec('07'),0,hex2dec('ffff'));updatewireins(xem);
setwireinvalue(xem,hex2dec('07'),1,hex2dec('ffff'));updatewireins(xem);
disp('reset done')

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

% config59. debug_en, rp_en
XSIZE_MIN = 0;
YSIZE_MIN = 0;
pg_en = 0;
rp_en1 = 1;
rp_en2 = 0;
debug_en = 0;

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
data=14*2^5 + 14*2^9; %set SIG_OBS1 as DOUT
% data=8*2^5 + 14*2^9; %set SIG_OBS1 as burst_en
data_hex = dec2hex(data);
hex_addr=dec2hex(61,2);

out=65000;
while (out ~=data)
    writeconfig(xem,data_hex, hex_addr)
    out=readconfig(xem, hex_addr)
    pause(1)
end
out1=readconfig_hex(xem, hex_addr)
%

setwireinvalue(xem,hex2dec('02'),0,hex2dec('ffff'));updatewireins(xem); %WrData
pause(1)
setwireinvalue(xem,hex2dec('01'),3,hex2dec('ffff'));updatewireins(xem); %WR
setwireinvalue(xem,hex2dec('01'),2,hex2dec('ffff'));updatewireins(xem); %RD
activatetriggerin(xem, hex2dec('40'), 0);updatewireins(xem);
setwireinvalue(xem,hex2dec('01'),0,hex2dec('ffff'));updatewireins(xem);

%% testing 
% config59. debug_en=0
XSIZE_MIN = 0;
YSIZE_MIN = 0;
pg_en = 0;
rp_en1 = 1;
rp_en2 = 0;
debug_en = 0;

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

setwireinvalue(xem,hex2dec('00'),4,hex2dec('ffff'));updatewireins(xem);
%%
hex_addr='0001';
data_hex='5555';
 writeconfig(xem,data_hex, hex_addr)
 disp('done')
 %%
 hex_addr='0001';
 out=dec2hex(readconfig(xem, hex_addr))
 disp('done')
%% Burst enable