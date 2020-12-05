%% setup XEM6010, do just once
% clear;
% OK_Setup;%% Load the fpga bitstream code
%%
%load('image97.mat');
% FPGA_Config(xem,'F:\GoogleDrive\6-Tapeout\Tapeout_201911\testing_code\OpalKelly3010_Verilog\working_dir\ok_top.bit');
FPGA_Config(xem,'C:\ZXY\CNN\OpalKelly3010_Verilog_CNN\working_dir\testing_CNN_dbg.bit');
%% generate image with regions
% parameters
WIDTH = 240;%320;
HIGHT = 180;%240;
CNN_W = 42;
OBJ_MAX = 8;
NumOfDataIn = WIDTH*HIGHT;
NumOfDataOut= CNN_W*CNN_W;
input_img = zeros(HIGHT,WIDTH);
% output_img = zeros(HIGHT,WIDTH);
output_img = zeros(CNN_W,CNN_W);

region_x = zeros(OBJ_MAX*2,1);
region_y = zeros(OBJ_MAX*2,1);

% set region proposal
region_num = 1;
region_x = [10,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
region_y = [10,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
region_num = 3;
region_x = [10,11,20,29,100,110,0,0,0,0,0,0,0,0,0,0];
region_y = [10,12,20,29,50,70,0,0,0,0,0,0,0,0,0,0];
for num = 1:region_num
    for iy=region_y(num*2-1):region_y(num*2)
        for ix=region_x(num*2-1):region_x(num*2)
%             if ix-region_x(num*2-1)> iy-region_y(num*2-1) 
                input_img(iy,ix) = 1;
%             end
        end
    end
end

% write image to txt file
fid = fopen('.\testing_data\input_img.txt','w');
for row=1:HIGHT
    for col=1:WIDTH
        fprintf(fid,'%i ',input_img(row,col));
    end
    fprintf(fid,'\n');
end
fclose(fid);
%% 
% reset
setwireinvalue(xem,hex2dec('00'),1,hex2dec('0001'));updatewireins(xem);
setwireinvalue(xem,hex2dec('00'),0,hex2dec('0001'));updatewireins(xem);
fprintf('reset inserted');

% SPI config
for i=0:127
    spi_config(xem,i,0);
end
% param a = 1. 
spi_config(xem, 0, hex2dec('0001'));
% param b = 1. 
spi_config(xem, 106, hex2dec('0001'));
% param c = -7. 
spi_config(xem, 126, hex2dec('fff9'));
% dbg_reg[7:0] = config_reg110[15:8] = 8'hfc (disable CNN) or 8'h3c (enable CNN). 
spi_config(xem, 110, hex2dec('fc00'));
% config_reg58[15]=1 to output yAddress as parallel_out. 
spi_config(xem, 58, hex2dec('8000'));

fprintf('SPI configure done!\n');

%%
% write image and regions
data_in = zeros(NumOfDataIn,1);
ddata_in = zeros(NumOfDataIn*2,1);
ddata_rx = zeros(region_num*2*2,1);
ddata_ry = zeros(region_num*2*2,1);
for i = 1:HIGHT
    for j = 1:WIDTH
        data_in(j+(i-1)*WIDTH) = input_img(i,j);
    end
end
for i = 1:NumOfDataIn
    ddata_in(2*i-1) = data_in(i);
end
writetopipein(xem, hex2dec('80'), ddata_in, NumOfDataIn*2);
for i = 1:region_num*2
    ddata_rx(2*i-1) = region_x(i)-1;%index starts from 0 in verilog
    ddata_ry(2*i-1) = region_y(i)-1;
end
writetopipein(xem, hex2dec('81'), ddata_rx, region_num*2*2);
writetopipein(xem, hex2dec('82'), ddata_ry, region_num*2*2);

setwireinvalue(xem,hex2dec('03'),region_num,hex2dec('001f'));updatewireins(xem); %num_obj = wi03_data[4:0]

fprintf('write image & region done!\n');
%%
setwireinvalue(xem,hex2dec('03'),32,hex2dec('0020'));updatewireins(xem); %wi03_data[5] to enable region_valid
fprintf('start ...\n');

% read the stored region for verifying
updatetriggerouts(xem);
while (istriggered(xem,hex2dec('60'),hex2dec('0001')) == 0)
    disp('waiting...');
    updatetriggerouts(xem);
end
disp('cnn done');

ddata_out = zeros(NumOfDataOut*2,1); % mem_check is 11bit depth in verilog
data_out  = zeros(NumOfDataOut,1);
ddata_out = readfrompipeout(xem, hex2dec('a1'), NumOfDataOut*2);
for i = 1:NumOfDataOut
    data_out(i) = double(ddata_out(2*i-1))+double(ddata_out(2*i))*256;
end

%% for single obj
for i = 1:NumOfDataOut
    if data_out(i)>0
        output_img(floor((data_out(i)-data_out(1)+1)/WIDTH+1),rem(data_out(i)-data_out(1)+1,WIDTH)) = data_in(data_out(i)+1);
%         output_img(i) = data_in(data_out(i)+1);%index starts from 1 in matlab
    end
end
fprintf('total pixels: %d\n', sum(sum(output_img)));

%
figure; 
subplot(121);imshow(input_img);title('input image'); axis on; %axis([0,240,0,180])
subplot(122);imshow(output_img);title('output region'); axis on; %axis([0,42,0,42])

%% for multiple obj
region_out = cell(1,region_num);
for n = 1:region_num
    region_out{n} = zeros(CNN_W,CNN_W);
end

n = 1;
start = data_out(1);
for i = 1:NumOfDataOut
    if data_out(i)>0
        i
        if (data_out(i+1)-data_out(i)< 2*WIDTH)%buyanjin
            region_out{n}(floor((data_out(i)-start+1)/WIDTH+1),rem(data_out(i)-start+1,WIDTH)) = data_in(data_out(i)+1);
        else
            region_out{n}(floor((data_out(i)-start+1)/WIDTH+1),rem(data_out(i)-start+1,WIDTH)) = data_in(data_out(i)+1);%the last pixel of previous obj
            n = n+1;%new obj
            region_out{n}(1,1) = data_in(data_out(i)+1);
            start = data_out(i+1);
        end
    end
end
% plot
figure; 
subplot(131);imshow(input_img);title('input image'); axis on; %axis([0,240,0,180])
subplot(132);imshow(region_out{1});title('output region 1'); axis on; %axis([0,42,0,42])
subplot(133);imshow(region_out{2});title('output region 2'); axis on; %axis([0,42,0,42])
%%
%%
% i = 1;
% for n = 1:region_num
%     for iy = region_y(2*n-1):region_y(2*n)
%         for ix = region_x(2*n-1):region_x(2*n)
%             if data_out(i) == data_in(ix+(iy-1)*WIDTH)
%                 fprintf('Success! Raw image data data_in[%d] = %d,    Read out_data[%d] = %d \n', ix+(iy-1)*WIDTH, data_in(ix+(iy-1)*WIDTH), i, data_out(i));
%                 i = i + 1;
%             else
%                 fprintf(2,'Error! Raw image data data_in[%d] = %d,    Read out_data[%d] = %d \n', ix+(iy-1)*WIDTH, data_in(ix+(iy-1)*WIDTH), i, data_out(i));
%                 i = i + 1;
%             end
%         end
%     end
% end
% 
% %%
% region_y(1)
% 
% %%
% 
% 
% %%
% % load raw image and pipe in to XEM
% path_img = 'F:\sim_data\0_final_data_320x240_1.txt';
% % path_img = 'F:\sim_data\0_initial_data_16x12.txt';
% raw_img = importdata(path_img);
% figure
% imshow(raw_img);title('raw image');
% %%
% % parameters
% % WIDTH = 320;
% % HIGHT = 240;
% % WIDTH = 16;
% % HIGHT = 12;
% addr_x_start = 0; addr_x_stop = 319; 
% addr_y_start = 0; addr_y_stop = 239;
% setwireinvalue(xem,hex2dec('10'),addr_x_start,hex2dec('ffff'));updatewireins(xem);
% setwireinvalue(xem,hex2dec('11'),addr_y_start,hex2dec('ffff'));updatewireins(xem);
% setwireinvalue(xem,hex2dec('12'),addr_x_stop,hex2dec('ffff'));updatewireins(xem);
% setwireinvalue(xem,hex2dec('13'),addr_y_stop,hex2dec('ffff'));updatewireins(xem);
% WIDTH = addr_x_stop - addr_x_start + 1;
% HIGHT = addr_y_stop - addr_y_start + 1;
% NumOfDataIn = WIDTH*HIGHT;
% input_img = zeros(HIGHT,WIDTH);
% output_img = zeros(HIGHT,WIDTH);
% data_in = zeros(NumOfDataIn,1);
% ddata_in = zeros(NumOfDataIn*2,1);
% for i = 1:HIGHT
%     for j = 1:WIDTH
%         data_in(j+(i-1)*WIDTH) = raw_img(i,j);
%     end
% end
% for i = 1:NumOfDataIn
%     ddata_in(2*i-1) = data_in(i);
% end
% % reset
% setwireinvalue(xem,hex2dec('07'),0,hex2dec('ffff'));updatewireins(xem);
% setwireinvalue(xem,hex2dec('07'),1,hex2dec('ffff'));updatewireins(xem);
% disp('reset done')
% %
% % config writinng: clear all
% for i=0:63
%     hex_addr=dec2hex(i,2);
%     data_hex='0000';
%     data=0;
%     out=65000;
%     while (out ~=data)
%         writeconfig(xem,data_hex, hex_addr)
%         %pause(0.01)
%         out=readconfig(xem, hex_addr);
%     end
%     out1=readconfig_hex(xem, hex_addr)
% end
% disp('config clear done')
% 
% % config58.
% % diffusion_t_sel = 1; %0-1
% % diffusion_n_sel = 3; %0-3
% % diffusion_r_sel = 15; %0-15
% diffusion_t_sel = 0; %0-1
% diffusion_n_sel = 0; %0-3
% diffusion_r_sel = 0; %0-15
% SLOT_X = 0;
% SLOT_Y = 0;
% fifo_en = 0;
% data = diffusion_t_sel + diffusion_n_sel * 2 + diffusion_r_sel * 2^3 + SLOT_X * 2^7 + SLOT_Y * 2^11 + fifo_en * 2^15;
% data_hex = dec2hex(data);
% hex_addr=dec2hex(58,2);
% 
% out=65000;
% while (out ~=data)
%     writeconfig(xem,data_hex, hex_addr)
%     out=readconfig(xem, hex_addr)
%     pause(1)
% end
% out1=readconfig_hex(xem, hex_addr)
% 
% % config59. debug_en, rp_en
% XSIZE_MIN = 0;
% YSIZE_MIN = 0;
% pg_en = 0;
% rp_en1 = 1;
% rp_en2 = 0;
% debug_en = 1;
% 
% data = XSIZE_MIN + YSIZE_MIN * 2^4 + pg_en * 2^8 + rp_en1 * 2^9 + rp_en2 * 2^10 + debug_en * 2^11; %2^9 + 2^11;
% data_hex = dec2hex(data);
% hex_addr=dec2hex(59,2);
% 
% out=65000;
% while (out ~=data)
%     writeconfig(xem,data_hex, hex_addr)
%     out=readconfig(xem, hex_addr)
%     pause(1)
% end
% out1=readconfig_hex(xem, hex_addr)
% 
% % config61. sig_observe
% data=14*2^5 + 14*2^9;
% data_hex = dec2hex(data);
% hex_addr=dec2hex(61,2);
% 
% out=65000;
% while (out ~=data)
%     writeconfig(xem,data_hex, hex_addr)
%     out=readconfig(xem, hex_addr)
%     pause(1)
% end
% out1=readconfig_hex(xem, hex_addr)
% 
% %%
% % WrData
% setwireinvalue(xem,hex2dec('01'),0,hex2dec('ffff'));updatewireins(xem);
% % WR
% WrReq = 1; 
% setwireinvalue(xem,hex2dec('02'),WrReq*2^0,hex2dec('ffff'));updatewireins(xem);
% %addr
% setwireinvalue(xem,hex2dec('00'),15,hex2dec('ffff'));updatewireins(xem);
% %dec_en
% WrReq = 1; TOP_ROW_SEL = 1; decoder_row_en = 1; decoder_col_en_w = 1;
% setwireinvalue(xem,hex2dec('02'),WrReq*2^0 + TOP_ROW_SEL*2^3 + decoder_row_en*2^12 + decoder_col_en_w*2^13,hex2dec('ffff'));updatewireins(xem);
% 
% setwireinvalue(xem,hex2dec('02'),0,hex2dec('ffff'));updatewireins(xem);
% 
% 
% % RD
% RdReq = 1; 
% setwireinvalue(xem,hex2dec('02'),RdReq*2^1,hex2dec('ffff'));updatewireins(xem);
% %EQ
% EQ = 1;
% setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + EQ*2^4,hex2dec('ffff'));updatewireins(xem);
% pause(1)
% %WL
% WL = 1;
% setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + WL*2^12,hex2dec('ffff'));updatewireins(xem);
% %SA
% SA = 1;
% setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + SA*2^5,hex2dec('ffff'));updatewireins(xem);
% %SA, RdPage
% SA = 1; RdPage = 1;
% setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + SA*2^5 + RdPage*2^6,hex2dec('ffff'));updatewireins(xem);
% %TOP_ROW_SEL, RdGnt_delay
% TOP_ROW_SEL = 1; RdGnt_delay = 1;
% setwireinvalue(xem,hex2dec('02'),RdReq*2^1 + TOP_ROW_SEL*2^3 + RdGnt_delay*2^11,hex2dec('ffff'));updatewireins(xem);
% %
% setwireinvalue(xem,hex2dec('02'),0,hex2dec('ffff'));updatewireins(xem);



