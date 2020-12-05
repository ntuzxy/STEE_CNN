%% setup XEM6010, do just once
% clear;
OK_Setup;%% Load the fpga bitstream code
%%
%load('image97.mat');
% FPGA_Config(xem,'F:\STEE_PROJ\CONV\OpalKelly3010_Verilog_CNN - Input_gen work\working_dir\testing_CNN_dbg.bit');
FPGA_Config(xem,'F:\STEE_PROJ\CONV\OpalKelly3010_Verilog_CNN\working_dir\testing_CNN_dbg.bit');

%% generate image with regions
% parameters
WIDTH = 320;%240;%320;
HIGHT = 240;%180;%240;
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
% region_num = 3;
% region_x = [10,11,20,29,100,110,0,0,0,0,0,0,0,0,0,0];
% region_y = [10,12,20,29,50,70,0,0,0,0,0,0,0,0,0,0];
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
% read text file
weights_mem1 = textread('./testing_data/server/22mar2020/conv2d_1_weight_table.txt','%s');
weights_mem2 = textread('./testing_data/server/26mar2020/separable_conv2d_1_weight_table.txt','%s');
weights_mem4 = textread('./testing_data/server/28mar2020/dense_1_weight_table.txt','%s');
kernel_ptr_lyr1     = textread('./testing_data/server/22mar2020/weights_conv2d_1_weight_pointer.txt','%s');
kernel_ptr_dw_lyr2  = textread('./testing_data/server/26mar2020/weights_separable_conv2d_1depthwise_weight_pointer.txt','%s');
kernel_ptr_pw_lyr2  = textread('./testing_data/server/26mar2020/weights_separable_conv2d_1pointwise_weight_pointer.txt','%s');
kernel_ptr_fc_lyr   = textread('./testing_data/server/28mar2020/weights_dense_1.txt','%s');
bias_lyr1 = textread('./testing_data/server/22mar2020/conv2d_1_bias_values.txt','%s');
bias_lyr2 = textread('./testing_data/server/26mar2020/separable_conv2d_1_bias_values.txt','%s');
bias_lyr3 = textread('./testing_data/server/28mar2020/dense_1_bias_values.txt','%s');
dfp_bias_lyr1   = textread('./testing_data/server/22mar2020/dfp_bias.txt','%s');
dfp_lyr1        = textread('./testing_data/server/22mar2020/dfp_conv.txt','%s'); 
dfp_bias_lyr2   = textread('./testing_data/server/26mar2020/dfp_bias_layer_2.txt','%s');
dfp_lyr2        = textread('./testing_data/server/26mar2020/dfp_seperable_conv.txt','%s');
dfp_bias_lyr3   = textread('./testing_data/server/28mar2020/dfp_bias_layer_3.txt','%s');
dfp_lyr3        = textread('./testing_data/server/28mar2020/dfp_dense.txt','%s'); 
dfp_out_lyr1 = 'FC';
dfp_out_lyr2 = 'FC';
dfp_out_lyr3 = 'FC';
%% parameter
% CNN_inpit_gen
dbg_dout_mem_en        = 0;
dbg_dout_rp_en         = 0;
dbg_ext_mem_en         = 1;%0 as normal, get dataIn_pos/neg from ev_to_qvga_tsmc module. 1 as debug, get dataIn_pos/neg from ext PIN
dbg_dout_yaddr_en      = 1;%1-output mem_addr_valid & mem_addr_y to ext PIN dbg_dout_valid & dbg_dout
dbg_xaddr_op_en        = 1;%1-output xAddressOut to ext PIN
dbg_ext_cnn_rd_done_en = 0;%0 as normal, select internal cnn_rd_done (done signal from cnn)
dbg_cnn_ready_op_en    = 1;%1 as normal, output cnn_ready (start_cnn) to small_lenet_tile_based_cnn module. 
dbg_cnn_done_op_en     = 1;%1 as normal, output cnn_done to ev_to_qvga_tsmc module. 
config110_15to8bit     = (~logical(dbg_cnn_done_op_en)) * 2^15 + (~logical(dbg_cnn_ready_op_en)) * 2^14 + dbg_ext_cnn_rd_done_en * 2^13 + ...
                        dbg_xaddr_op_en * 2^12 + dbg_dout_yaddr_en * 2^11 + dbg_ext_mem_en * 2^10 + dbg_dout_rp_en * 2^9 + dbg_dout_mem_en * 2^8;
% 

top_valid_wr_dbg = 0; %cnn_top.line855
class_output_dbg = 0; %cnn_top.line1028

%% 
% reset
setwireinvalue(xem,hex2dec('00'),1,hex2dec('0001'));updatewireins(xem);
setwireinvalue(xem,hex2dec('00'),0,hex2dec('0001'));updatewireins(xem);
fprintf('reset inserted\n');

% setwireinvalue(xem,hex2dec('00'),16,16);updatewireins(xem);%aer_en = wi00_data[4];

%%%%%%%%%%%%%%%%%
% SPI config
%%%%%%%%%%%%%%%%%
% % clear all SPI registers
for i=0:127
    spi_config(xem,i,0);
end

% % CNN
% --weight pointer table
%NOTE: index start from 1 in SW(matlab) while addr start from 0 in HW(cnn chip)
lyr1_ptr_addr_cnt = 0;  % Charles fix: the cnt is continous between layer1 layer2 dw and pw
for lyr1_ptr_cnt=1:300
    spi_config(xem, 66, hex2dec(kernel_ptr_lyr1(lyr1_ptr_cnt))); %data
    spi_config(xem, 65, lyr1_ptr_addr_cnt); %addr:0~300-1
    spi_config(xem, 67, hex2dec('00ff'));
    spi_config(xem, 67, hex2dec('0000'));
    lyr1_ptr_addr_cnt = lyr1_ptr_addr_cnt + 1;
end
fprintf('init_ptr_lyr1_done\n');
for lyr2_dw_ptr_cnt=1:150
    spi_config(xem, 66, hex2dec(kernel_ptr_dw_lyr2(lyr2_dw_ptr_cnt))); %data
    spi_config(xem, 65, lyr1_ptr_addr_cnt); %addr:300~(300+150)-1
    spi_config(xem, 67, hex2dec('00ff'));
    spi_config(xem, 67, hex2dec('0000'));
    lyr1_ptr_addr_cnt = lyr1_ptr_addr_cnt + 1;
end
fprintf('init_ptr_lyr2_dw_done\n');
for lyr2_pw_ptr_cnt=1:30
    spi_config(xem, 66, hex2dec(kernel_ptr_pw_lyr2(lyr2_pw_ptr_cnt))); %data
    spi_config(xem, 65, lyr1_ptr_addr_cnt); %addr:(300+150)~(300+150+30)-1
    spi_config(xem, 67, hex2dec('00ff'));
    spi_config(xem, 67, hex2dec('0000'));
    lyr1_ptr_addr_cnt = lyr1_ptr_addr_cnt + 1;
end
fprintf('init_ptr_lyr2_pw_done\n');
for lyr3_ptr_cnt=1:49
    %data: 49*5*5=1225
    spi_config(xem, 81, hex2dec(        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*4)));
    spi_config(xem, 82, hex2dec(strcat( kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*3), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*2), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*1), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*0))));
    spi_config(xem, 79, hex2dec(        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*4+49*5)));
    spi_config(xem, 80, hex2dec(strcat( kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*3+49*5), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*2+49*5), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*1+49*5), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*0+49*5))));
    spi_config(xem, 77, hex2dec(        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*4+49*5*2)));
    spi_config(xem, 78, hex2dec(strcat( kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*3+49*5*2), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*2+49*5*2), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*1+49*5*2), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*0+49*5*2))));
    spi_config(xem, 75, hex2dec(        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*4+49*5*3)));
    spi_config(xem, 76, hex2dec(strcat( kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*3+49*5*3), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*2+49*5*3), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*1+49*5*3), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*0+49*5*3))));
    spi_config(xem, 73, hex2dec(        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*4+49*5*4)));
    spi_config(xem, 74, hex2dec(strcat( kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*3+49*5*4), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*2+49*5*4), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*1+49*5*4), ...
                                        kernel_ptr_fc_lyr(lyr3_ptr_cnt+49*0+49*5*4))));
    %addr:0~49-1
    spi_config(xem, 68, (lyr3_ptr_cnt-1));
    spi_config(xem, 69, (lyr3_ptr_cnt-1));
    spi_config(xem, 70, (lyr3_ptr_cnt-1));
    spi_config(xem, 71, (lyr3_ptr_cnt-1));
    spi_config(xem, 72, (lyr3_ptr_cnt-1));
    spi_config(xem, 83, hex2dec('ffff'));
    spi_config(xem, 83, hex2dec('0000'));
end
fprintf('init_ptr_lyr3_done\n');

% --weight memory table
for weight_cnt=1:16
    spi_config(xem, 59, hex2dec(weights_mem1(weight_cnt)));
    spi_config(xem, 61, (weight_cnt-1));
    % config_reg63[1:0] for wea of memory
    % top_valid_wr_dbg(config_reg63[12]) for ev_to_qvga_tsmc
    spi_config(xem, 63, hex2dec([num2str(top_valid_wr_dbg),'0ff']));
    spi_config(xem, 63, hex2dec([num2str(top_valid_wr_dbg),'000']));
    
    spi_config(xem, 60, hex2dec(weights_mem2(weight_cnt)));
    spi_config(xem, 62, (weight_cnt-1));
    % config_reg64[1:0] for wea of memory
    % config_reg64[15] for class output
    spi_config(xem, 64, hex2dec([num2str(class_output_dbg*8),'0ff']));
    spi_config(xem, 64, hex2dec([num2str(class_output_dbg*8),'000']));
end
fprintf('init_wght_done\n');

for weight_cnt4=1:16
    spi_config(xem, 100-weight_cnt4, hex2dec(weights_mem4(weight_cnt4)));
end
for bias_lyr1_cnt=1:6
    spi_config(xem, 106-bias_lyr1_cnt, hex2dec(bias_lyr1(bias_lyr1_cnt)));
end
for bias_lyr2_cnt=1:5
    spi_config(xem, 112-bias_lyr2_cnt, hex2dec(bias_lyr2(bias_lyr2_cnt)));
end
for bias_lyr3_cnt=1:5
    spi_config(xem, 117-bias_lyr3_cnt, hex2dec(bias_lyr3(bias_lyr3_cnt)));
end
spi_config(xem, 117, hex2dec(dfp_lyr1));
spi_config(xem, 118, hex2dec(dfp_lyr2));
spi_config(xem, 119, hex2dec(dfp_lyr3));
spi_config(xem, 120, hex2dec(dfp_bias_lyr1));
spi_config(xem, 121, hex2dec(dfp_bias_lyr2));
spi_config(xem, 122, hex2dec(dfp_bias_lyr3));
spi_config(xem, 123, hex2dec(dfp_out_lyr1));
spi_config(xem, 124, hex2dec(dfp_out_lyr2));
spi_config(xem, 125, hex2dec(dfp_out_lyr3));


% % CNN_Input_Gen
% param a = 1. 
spi_config(xem, 0, hex2dec('0001'));
% param b = 1. 
spi_config(xem, 106, hex2dec('0001'));
% param c = -7. 
spi_config(xem, 126, hex2dec('fff9'));
% parallel_out selection. config_reg58[15]=1 to output yAddress 
% spi_config(xem, 58, hex2dec('8000'));

% overwrite
% dbg_reg[7:0] = config_reg110[15:8] = 8'hfc (disable CNN) or 8'h3c (enable CNN). 
spi_config(xem, 110, config110_15to8bit + hex2dec(bias_lyr2(1+1)));

% % AER
%not used for current testing

fprintf('SPI configure done!\n');

%%
% load image & rp
load './testing_data/server/TEST_DATA/RP_FILES/image_1006/image_1006_0' %read_data_pos
load './testing_data/server/TEST_DATA/RP_FILES/image_1006/image_1006_1' %read_data_neg
load './testing_data/server/TEST_DATA/RP_FILES/image_1006/rp_file' %read_data_neg
ddata_pos = zeros(NumOfDataIn*2,1);
ddata_neg = zeros(NumOfDataIn*2,1);
for i = 1:NumOfDataIn
    ddata_pos(2*i-1) = image_1006_0(i);%data_pos
    ddata_neg(2*i-1) = image_1006_1(i);%data_pos
end
region_num = rp_file(1);
ddata_rx = zeros(region_num*2*2,1);
ddata_ry = zeros(region_num*2*2,1);
for i = 1:region_num*2
    ddata_rx(2*i-1) = rp_file(2*i);%index starts from 0 in verilog
    ddata_ry(2*i-1) = rp_file(2*i+1);
end

% write image &rp to FPGA
writetopipein(xem, hex2dec('80'), ddata_pos, NumOfDataIn*2);
writetopipein(xem, hex2dec('83'), ddata_neg, NumOfDataIn*2);
writetopipein(xem, hex2dec('81'), ddata_rx, region_num*2*2);
writetopipein(xem, hex2dec('82'), ddata_ry, region_num*2*2);
setwireinvalue(xem,hex2dec('03'),region_num,hex2dec('001f'));updatewireins(xem); %num_obj = wi03_data[4:0]
fprintf('write image & region done!\n');
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
%     ddata_in(2*i-1) = image_1006_0(i);%data_pos
end
for i = 1:region_num*2
    ddata_rx(2*i-1) = region_x(i)-1;%index starts from 0 in verilog
    ddata_ry(2*i-1) = region_y(i)-1;
end
writetopipein(xem, hex2dec('80'), ddata_in, NumOfDataIn*2);
writetopipein(xem, hex2dec('81'), ddata_rx, region_num*2*2);
writetopipein(xem, hex2dec('82'), ddata_ry, region_num*2*2);
setwireinvalue(xem,hex2dec('03'),region_num,hex2dec('001f'));updatewireins(xem); %num_obj = wi03_data[4:0]
% writetopipein(xem, hex2dec('80'), 0, NumOfDataIn*2);
% writetopipein(xem, hex2dec('81'), 0, region_num*2*2);
% writetopipein(xem, hex2dec('82'), 0, region_num*2*2);
% setwireinvalue(xem,hex2dec('03'),0,hex2dec('001f'));updatewireins(xem); %num_obj = wi03_data[4:0]

fprintf('write image & region done!\n');
%%

% setwireinvalue(xem, 0, 4, 4); % en_evt2frame = wi00_data[2];
% updatewireins(xem);
setwireinvalue(xem, 0, 2, 2); % init = wi00_data[1];
updatewireins(xem);
fprintf('en_evt2frame & init inserted\n');
% input via RP2serial
setwireinvalue(xem,hex2dec('03'),32,hex2dec('0020'));updatewireins(xem); %wi03_data[5] to trig region_valid
setwireinvalue(xem,hex2dec('03'),0,hex2dec('0020'));updatewireins(xem);
% % input via AER
% setwireinvalue(xem,hex2dec('00'),8,hex2dec('0008'));updatewireins(xem); %data_update = wi00_data[3]; trig
% setwireinvalue(xem,hex2dec('00'),0,hex2dec('0008'));updatewireins(xem);
% 
fprintf('start ...\n');

% % read class
% read class_output to parallel_out
class_out = cell(5,region_num); %5 classes
N_readout = region_num*20*2;
pipeout = zeros(N_readout,1);
read_cnn_data_out = 0;
region_cnt = 0;
while read_cnn_data_out == 0
    updatetriggerouts(xem);
    read_cnn_data_out = istriggered(xem, hex2dec('60'),2);
    if read_cnn_data_out == 1
        pipeout = readfrompipeout(xem, hex2dec('a1'), N_readout);
    else
%         disp('waiting...');
    end
end
for region_cnt = 1:region_num
    for i = (region_cnt-1)*40+1:2:(region_cnt-1)*40+40
        if ((region_cnt-1)*40<i && i<(region_cnt-1)*40+4*2)
            class_out{5,region_cnt} = [dec2hex(pipeout(i),2), class_out{5,region_cnt}];
        elseif ((region_cnt-1)*40+4*2<i && i<(region_cnt-1)*40+8*2)
            class_out{4,region_cnt} = [dec2hex(pipeout(i),2), class_out{4,region_cnt}];
        elseif ((region_cnt-1)*40+8*2<i && i<(region_cnt-1)*40+12*2)
            class_out{3,region_cnt} = [dec2hex(pipeout(i),2), class_out{3,region_cnt}];
        elseif ((region_cnt-1)*40+12*2<i && i<(region_cnt-1)*40+16*2)
            class_out{2,region_cnt} = [dec2hex(pipeout(i),2), class_out{2,region_cnt}];
        else
            class_out{1,region_cnt} = [dec2hex(pipeout(i),2), class_out{1,region_cnt}];
        end
    end
    fprintf('=========== region %d of %d ===========\n', region_cnt, region_num);
    for i=1:5
        fprintf('class[%d] = 0x%s, 0d%d\n', i, class_out{i,region_cnt},hex2sdec(class_out{i,region_cnt},32));
    end
end
%%
hex2sdec('ff',8)
%%
updatewireouts(xem);
getwireoutvalue(xem,hex2dec('21'))
%%









%% plot image & RP boundary
load ./testing_data/server/TEST_DATA/RP_FILES/image_1006/image_1006_0
load ./testing_data/server/TEST_DATA/RP_FILES/image_1006/image_1006_1
load ./testing_data/server/TEST_DATA/RP_FILES/image_1006/rp_file
read_data_pos = zeros(240,320);
read_data_neg = zeros(240,320);
for j=1:240
    for i=1:320
        read_data_pos(j,i) = image_1006_0((j-1)*320+i);
    end
end
for j=1:240
    for i=1:320
        read_data_neg(j,i) = image_1006_1((j-1)*320+i);
    end
end
figure; 
subplot(121);showImage(read_data_pos,rp_file,2,'red');title('read\_data\_pos'); axis on; %axis([0,240,0,180])
hold on;
subplot(122);imshow(read_data_neg);title('read\_data\_neg'); axis on; %axis([0,42,0,42])

%%
image_1006_1_new = zeros(76800,1);
read_data_new = zeros(240,320);
for j=1:2:240
    for i=1:2:320
        image_1006_1_new((j-1)*320+i)  = read_data_pos(j,i);
    end
end
for j=1:240
    for i=1:320
        read_data_new(j,i) = image_1006_1_new((j-1)*320+i);
    end
end
figure; 
imshow(read_data_new);


%%
showImage(read_data_pos,rp_file,2,'red') 
hold on;
% rectangle('Position', [100, 100, 30, 50], 'EdgeColor', 'b', 'FaceColor', 'r', 'LineWidth', 4);


%%
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



