%% setup Opal Kelly, do just once
% clear;
OK_Setup;%% Load the fpga bitstream code

%% config bit file
% FPGA_Config(xem,'F:\STEE_PROJ\CONV\OpalKelly3010_Verilog_CNN\working_dir\testing_cnn_dbg_ok1228.bit');
FPGA_Config(xem,'..\OpalKelly3010_Verilog_CNN\working_dir\testing_CNN_dbg.bit');

%% parameters
% image size
WIDTH = 320;%240;%320;
HIGHT = 240;%180;%240;
NumOfDataIn = WIDTH*HIGHT;

% clock gating
clock_gating = 1;

% AER
burst_mode = 0;

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

top_valid_wr_dbg = 0; %cnn_top.line855
class_output_dbg = 0; %cnn_top.line1028

% save result switch
save_gif_en = 0;
save_avi_en = 0;
%% weights/pointer/bias files
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
%% weights/pointer/bias for debug
% read text file
% weights_mem1 = num2str(ones(16,1)*0);% textread('./testing_data/server/22mar2020/conv2d_1_weight_table.txt','%s');
% weights_mem2 = num2str(ones(16,1)*8);% textread('./testing_data/server/26mar2020/separable_conv2d_1_weight_table.txt','%s');
% weights_mem4 = num2str(ones(16,1)*0);% textread('./testing_data/server/28mar2020/dense_1_weight_table.txt','%s');
weights_mem4 = textread('./testing_data/server_brainlab\20180717_Site2_4pm_6mm_01_HW_CNN_Test_data/dense_finetune_weight_table.txt','%s');
% kernel_ptr_lyr1     = zeros(300,1);% textread('./testing_data/server/22mar2020/weights_conv2d_1_weight_pointer.txt','%s');
% kernel_ptr_dw_lyr2  = zeros(150,1);% textread('./testing_data/server/26mar2020/weights_separable_conv2d_1depthwise_weight_pointer.txt','%s');
% kernel_ptr_pw_lyr2  = zeros(30,1);% textread('./testing_data/server/26mar2020/weights_separable_conv2d_1pointwise_weight_pointer.txt','%s');
% kernel_ptr_fc_lyr   = num2str(ones(1225,1)*5);% textread('./testing_data/server/28mar2020/weights_dense_1.txt','%s');
kernel_ptr_fc_lyr   = textread('./testing_data/server_brainlab\20180717_Site2_4pm_6mm_01_HW_CNN_Test_data/weights_dense_finetune_weight_pointer.txt','%s');
% bias_lyr1 = textread('./testing_data/server/22mar2020/conv2d_1_bias_values_dbg.txt','%s');
% bias_lyr2 = num2str(ones(5,1)*8);% textread('./testing_data/server/26mar2020/separable_conv2d_1_bias_values.txt','%s');
% bias_lyr3 = num2str(ones(5,1)*1);% textread('./testing_data/server/28mar2020/dense_1_bias_values.txt','%s');
bias_lyr3 = textread('./testing_data/server_brainlab\20180717_Site2_4pm_6mm_01_HW_CNN_Test_data/dense_finetune_bias_values.txt','%s');
% dfp_bias_lyr1   = 'FA';% textread('./testing_data/server/22mar2020/dfp_bias.txt','%s');
% dfp_lyr1        = 'FA';% textread('./testing_data/server/22mar2020/dfp_conv.txt','%s'); 
% dfp_bias_lyr2   = 'F1';% textread('./testing_data/server/26mar2020/dfp_bias_layer_2.txt','%s');
% dfp_lyr2        = 0;% textread('./testing_data/server/26mar2020/dfp_seperable_conv.txt','%s');
% dfp_bias_lyr3   = 0;% textread('./testing_data/server/28mar2020/dfp_bias_layer_3.txt','%s');
% dfp_lyr3        = 0;% textread('./testing_data/server/28mar2020/dfp_dense.txt','%s'); 
% dfp_out_lyr1 = 'FA';
% dfp_out_lyr2 = 'FD';% 'FC';
% dfp_out_lyr3 = 'FD';% 'FC';
%% reset & SPI config
% burst mode / ping pang mode
setwireinvalue(xem,hex2dec('00'),burst_mode*128,hex2dec('0080'));updatewireins(xem);
% clock divider
setwireinvalue(xem,hex2dec('02'),1,hex2dec('0001'));updatewireins(xem); %enable clock scaling (spi_clk)
setwireinvalue(xem,hex2dec('02'),20,hex2dec('fffe'));updatewireins(xem); %1/20
setwireinvalue(xem,hex2dec('04'),1,hex2dec('0001'));updatewireins(xem); %enable clock scaling (top_clk)
setwireinvalue(xem,hex2dec('04'),2,hex2dec('fffe'));updatewireins(xem); %1/2
% clcok gating enable/disable
setwireinvalue(xem,hex2dec('00'),clock_gating*64,hex2dec('0040'));updatewireins(xem); %enable clcok gating
% reset
setwireinvalue(xem,hex2dec('00'),1,hex2dec('0001'));updatewireins(xem);
setwireinvalue(xem,hex2dec('00'),0,hex2dec('0001'));updatewireins(xem);
fprintf('reset inserted\n');


%%%%%%%%%%%%%%%%%
% SPI config
%%%%%%%%%%%%%%%%%
% % clear all SPI registers
for i=0:127
    if (i==58)
        spi_config(xem,i,312);
    else
        spi_config(xem,i,0);
    end
end

% % AER
setwireinvalue(xem,hex2dec('07'),hex2dec('4232'),hex2dec('ffff'));updatewireins(xem);%frame_len and rame_us
if burst_mode
    spi_config(xem, 1, hex2dec('0501')); %AER top_burst_en/burst_mode, bias_enable , and image cols (320)
    spi_config(xem, 2, hex2dec('4232')); %frame len and frame us (66ms and 50 MHz)
else
    spi_config(xem, 1, hex2dec('0500')); %AER top_burst_en/burst_mode, bias_enable , and image cols (320)
    spi_config(xem, 2, hex2dec('4232')); %frame len and frame us (66ms and 50 MHz)
end
spi_config(xem, 127, hex2dec('05f0')); %burst_len and image rows (4ms and 240)

% % CNN_Input_Gen
% spi_config(xem, 0, hex2dec('0001')); % param a = 1. 
spi_config(xem, 106, hex2dec('0001'));% param b = 1. 
% spi_config(xem, 126, hex2dec('fff9')); % param c = -7. 

% parallel_out selection. config_reg58[15]=1 to output yAddress 
% spi_config(xem, 58, hex2dec('8000'));

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
    spi_config(xem, 72, (lyr3_ptr_cnt-1));
    spi_config(xem, 71, (lyr3_ptr_cnt-1));
    spi_config(xem, 70, (lyr3_ptr_cnt-1));
    spi_config(xem, 69, (lyr3_ptr_cnt-1));
    spi_config(xem, 68, (lyr3_ptr_cnt-1));
    spi_config(xem, 83, hex2dec('ffff'));
    spi_config(xem, 83, hex2dec('0000'));
end
fprintf('init_ptr_lyr3_done\n');

% --weight memory table
for weight_cnt4=1:16 %%NOTE: this will interfere weights_mem2, so write this first
    spi_config(xem, 100-weight_cnt4, hex2dec(weights_mem4(weight_cnt4)));
end
for weight_cnt=1:16
    spi_config(xem, 59, hex2dec(weights_mem1(weight_cnt)));
    spi_config(xem, 61, (weight_cnt-1));
    % config_reg63[1:0] for wea of memory
    % top_valid_wr_dbg(config_reg63[12]) for ev_to_qvga_tsmc
    spi_config(xem, 63, hex2dec([num2str(top_valid_wr_dbg),'0ff']));
    spi_config(xem, 63, hex2dec([num2str(top_valid_wr_dbg),'000']));
end
for weight_cnt=1:16
    spi_config(xem, 60, hex2dec(weights_mem2(weight_cnt)));
    spi_config(xem, 62, (weight_cnt-1));
    % config_reg64[1:0] for wea of memory
    % config_reg64[15] for class output
    spi_config(xem, 64, hex2dec([num2str(class_output_dbg*8),'0ff']));
    spi_config(xem, 64, hex2dec([num2str(class_output_dbg*8),'000']));
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

fprintf('init_wght_done\n');


% % overwrite if input via debug mode
% % dbg_reg[7:0] = config_reg110[15:8] = 8'hfc (disable CNN) or 8'h3c (enable CNN). 
% spi_config(xem, 110, config110_15to8bit + hex2dec(bias_lyr2(1+1)));

setwireinvalue(xem, 0, 32, 32); % config_done = wi00_data[5];
updatewireins(xem);
setwireinvalue(xem, 0, 0, 32); % config_done = wi00_data[5];
updatewireins(xem);
fprintf('SPI configure done!\n');

setwireinvalue(xem, 0, 2, 2); % init = wi00_data[1];
updatewireins(xem);
setwireinvalue(xem, 0, 4, 4); % en_evt2frame = wi00_data[2];
updatewireins(xem);
setwireinvalue(xem, 0, 16, 16); % aer_en = wi00_data[4];
updatewireins(xem);
fprintf('en_evt2frame & init inserted\n');

%% check the tsmc memories in cnn
%%%NOTE: set clock_gating=0 to enable clock before running this
disp('internal memories checking ...')
read_ptr_1and2(xem, kernel_ptr_lyr1,kernel_ptr_dw_lyr2,kernel_ptr_pw_lyr2)
read_ptr3(xem, kernel_ptr_fc_lyr); 
read_weight_1and2(xem, weights_mem1, weights_mem2)
disp('check internal memories done')
%% feed in image & rp from file
% visualize

%     close();
    fig = figure('Position', [500 0 1000 1000]);
    axis off;
    hold on;
%     subplot(1, 2, 1); axis off;
%     subplot(1, 2, 2); axis off;
%     hold on;
%     text(0,0.72,'HW:');
%     text(0.5,0.72,'SW:');
%     t_hw = text(0,0.5,'');
%     t_sw = text(0.5,0.5,'');
    
if save_avi_en
    writerObj=VideoWriter('out.avi');	%// ?????????????
    writerObj.FrameRate = 2;            %// set to 2 frames per second
    open(writerObj);                    %// ???????
end

% load image & rp
% path1 = './testing_data/server_brainlab/20180711_ENG_3pm_12mm_02_data/'; %/media/project2/media/project2/common/recovered_disc/deepak/data_for_Lavanya/20180711_ENG_3pm_12mm_02_data
path1 = './testing_data/server_brainlab/20180711_Site1_3pm_12mm_01_HW_CNN_Test_data/';
% for hh = 1:100
for img = 0:10
path2 = ['image_',num2str(img)];
file_name_pos = [path2,'_0'];%'image_1006_0';
file_name_neg = [path2,'_1'];%'image_1006_1';
rp_file = 'rp_file';
img_pos = load([path1,path2,'/',file_name_pos]);
img_neg = load([path1,path2,'/',file_name_neg]);
rp = load([path1,path2,'/',rp_file]);

ddata_pos = zeros(NumOfDataIn*2,1);
ddata_neg = zeros(NumOfDataIn*2,1);
for i = 1:NumOfDataIn
    ddata_pos(2*i-1) = img_pos(i);%data_pos
    ddata_neg(2*i-1) = img_neg(i);%data_pos
end
region_num = rp(1);
ddata_rx = zeros(region_num*2*2,1);
ddata_ry = zeros(region_num*2*2,1);
for i = 1:region_num*2
    ddata_rx(2*i-1) = rp(2*i);%index starts from 0 in verilog
    ddata_ry(2*i-1) = rp(2*i+1);
end

% write image &rp to FPGA
setwireinvalue(xem,hex2dec('03'),region_num,hex2dec('001f'));updatewireins(xem); %num_obj = wi03_data[4:0]
writetopipein(xem, hex2dec('80'), ddata_pos, NumOfDataIn*2);
writetopipein(xem, hex2dec('83'), ddata_neg, NumOfDataIn*2);
writetopipein(xem, hex2dec('81'), ddata_rx, region_num*2*2);
writetopipein(xem, hex2dec('82'), ddata_ry, region_num*2*2);
fprintf('write image & region done!\n');

% % run cnn
% % input via RP2serial
% setwireinvalue(xem,hex2dec('03'),32,hex2dec('0020'));updatewireins(xem); %wi03_data[5] to trig region_valid
% setwireinvalue(xem,hex2dec('03'),0,hex2dec('0020'));updatewireins(xem);
% % input via AER
% setwireinvalue(xem,hex2dec('00'),8,hex2dec('0008'));updatewireins(xem); %data_update = wi00_data[3]; trig
% pause(0.5)
% setwireinvalue(xem,hex2dec('00'),0,hex2dec('0008'));updatewireins(xem);
% 
fprintf('start image_%d...\n',img);

if save_gif_en 
    save_as_gif(img, 0, fig, 0.5, 'out.gif');
end
if save_avi_en
    frame = getframe(fig);       %// ??????????
    writeVideo(writerObj,frame); %// ??????
end

% % read class
% read class_output to parallel_out
if region_num>0 % valid image (no read_cnn_data_out signal from chip if region_num=0)
class_out = cell(5,region_num); %5 classes
N_readout = region_num*20*2;
pipeout = zeros(N_readout,1);
read_cnn_data_out = 0;
while read_cnn_data_out == 0
    updatetriggerouts(xem);
    read_cnn_data_out = istriggered(xem, hex2dec('60'),2);
%     updatewireouts(xem);
%     read_cnn_data_out = bitget(getwireoutvalue(xem, hex2dec('21')),1);

    if read_cnn_data_out == 1
        pipeout = readfrompipeout(xem, hex2dec('a4'), N_readout);
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

% read SW results
output_path1 = 'F:\STEE_PROJ\CONV\Matlab\testing_data\server_brainlab\30mar2020\'; %/home/lavanya/Research/full_video_verification/30mar2020
classout_from_software = zeros(5, region_num); %5 classes
for i=0:region_num-1
%     classout_from_software(:,i+1) = load([output_path1,path2,'/',num2str(i),'/final_output.txt']);
    classout_from_software(:,i+1) = load([path1,path2,'/',num2str(i),'_final_output.txt']);
end
% visualize(img_pos, img_neg, rp, class_out);
% visualize_v2(img_pos, img_neg, rp, class_out, path1,path2, t_hw,t_sw);
results_show(img_pos, img_neg, rp, class_out, classout_from_software);

pause(0.2)
end
end
% end %for hh = 1:100
if save_avi_en
    close(writerObj); %// ????????
end

%%
%% no

% clock divider
setwireinvalue(xem,hex2dec('02'),1,hex2dec('0001'));updatewireins(xem); %enable clock scaling (spi_clk)
setwireinvalue(xem,hex2dec('02'),20,hex2dec('fffe'));updatewireins(xem); %1/20
setwireinvalue(xem,hex2dec('04'),1,hex2dec('0001'));updatewireins(xem); %enable clock scaling (top_clk)
setwireinvalue(xem,hex2dec('04'),2,hex2dec('fffe'));updatewireins(xem); %1/20
% reset
setwireinvalue(xem,hex2dec('00'),1,hex2dec('0001'));updatewireins(xem);
setwireinvalue(xem,hex2dec('00'),0,hex2dec('0001'));updatewireins(xem);
% % get busy_frame
% spi_config(xem,58,312);
% % AER
spi_config(xem, 1, hex2dec('0500')); %AER top_burst_en/burst_mode, bias_enable , and image cols (320)
spi_config(xem, 2, hex2dec('0132')); %frame len and frame us (1ms and 50 MHz)
spi_config(xem, 127, hex2dec('04f0')); %burst_len and image rows (4ms and 240)

% setwireinvalue(xem, 0, 2, 2); % init = wi00_data[1];
% updatewireins(xem);
setwireinvalue(xem, 0, 4, 4); % en_evt2frame = wi00_data[2];
updatewireins(xem);
% setwireinvalue(xem, 0, 8, 8); % data_update = wi00_data[3];
% updatewireins(xem);
setwireinvalue(xem, 0, 16, 16); % aer_en = wi00_data[4];
updatewireins(xem);
%% debug internal outputs of cnn
spi_config(xem, 58, 12);
setwireinvalue(xem,hex2dec('05'),0*2^6+0*2^5,hex2dec('0060'));updatewireins(xem);
N_readout_dbg = 110000;
pipeout5 = zeros(N_readout_dbg*2,9);
dbg_data = zeros(N_readout_dbg,9);
setwireinvalue(xem, 0, 0, 2); % init = wi00_data[1];
setwireinvalue(xem, 0, 2, 2); % init = wi00_data[1];
updatewireins(xem);
% % read & store data
setwireinvalue(xem, 5, 2, 3); % dbg_read_data = wi05_data[1]; dbg_read_valid = wi05_data[0];
updatewireins(xem);readconfig(xem,dec2hex(58))
for i = 1:8
    setwireinvalue(xem,hex2dec('05'),(i-1)*2^2,hex2dec('001c'));updatewireins(xem);
    % input via RP2serial
    setwireinvalue(xem,hex2dec('03'),32,hex2dec('0020'));updatewireins(xem); %wi03_data[5] to trig region_valid
    setwireinvalue(xem,hex2dec('03'),0,hex2dec('0020'));updatewireins(xem);
    read_cnn_data_out = 0;
    while read_cnn_data_out == 0
        updatetriggerouts(xem);
        read_cnn_data_out = istriggered(xem, hex2dec('60'),2); 
        if read_cnn_data_out == 1
            pipeout5(:,i) = readfrompipeout(xem, hex2dec('a5'), N_readout_dbg*2);
        end
    end
end
% read and store valid 
setwireinvalue(xem, 5, 1, 3); % dbg_read_data = wi05_data[1]; dbg_read_valid = wi05_data[0];
updatewireins(xem);
setwireinvalue(xem,hex2dec('05'),3*2^2,hex2dec('001c'));updatewireins(xem);
% input via RP2serial
setwireinvalue(xem,hex2dec('03'),32,hex2dec('0020'));updatewireins(xem); %wi03_data[5] to trig region_valid
setwireinvalue(xem,hex2dec('03'),0,hex2dec('0020'));updatewireins(xem);
read_cnn_data_out = 0;
while read_cnn_data_out == 0
    updatetriggerouts(xem);
    read_cnn_data_out = istriggered(xem, hex2dec('60'),2); 
    if read_cnn_data_out == 1
        pipeout5(:,9) = readfrompipeout(xem, hex2dec('a5'), N_readout_dbg*2);
    end
end

% % % process data
% for i = 1: N_readout_dbg
%     dbg_data(i,:) = pipeout5(2*i-1,:);
% end
% dbg_valid = dbg_data(:,9);
% dbg_data1 = dbg_data(:,8)*2^7+ dbg_data(:,7)*2^6+ dbg_data(:,6)*2^5+ dbg_data(:,5)*2^4+ ...
%             dbg_data(:,4)*2^3+ dbg_data(:,3)*2^2+ dbg_data(:,2)*2^1+ dbg_data(:,1);
% figure;
% for i = 1:9
%     subplot(9,1,i); plot(1: N_readout_dbg, dbg_data(:,i))
%     ax(i) = subplot(9,1,i);
%     set(gca,'ylim',[0 1]); set(gca,'ytick',0:1:1);
%     if i<9
%         set(gca,'xticklabel',[]);
%     end
% end
% linkaxes(ax,'x');
% zoom xon

% sum(dbg_data(:,:))
%%
spi_config(xem,58,312);
readconfig(xem,dec2hex(58))
readconfig(xem,dec2hex(100))
readconfig(xem,dec2hex(117))
readconfig(xem,dec2hex(120))
readconfig(xem,dec2hex(123))
%%

readconfig(xem,dec2hex(110))
%%
setwireinvalue(xem,hex2dec('00'),1,hex2dec('0001'));updatewireins(xem);
setwireinvalue(xem,hex2dec('00'),0,hex2dec('0001'));updatewireins(xem);
a=zeros(128,1);
for i=0:127
    writeconfig(xem,dec2hex(i,3),dec2hex(i+1,4));
    readconfig(xem,dec2hex(i))
end
for i=0:127
    a(i+1)=readconfig(xem,dec2hex(i));
end
%%
%% debug data
setwireinvalue(xem, 0, 2, 2); % init = wi00_data[1];
updatewireins(xem);
% % read & store data
setwireinvalue(xem, 5, 2, 3); % dbg_read_data = wi05_data[1]; dbg_read_valid = wi05_data[0];
updatewireins(xem);
for i = 1:8
    % input via RP2serial
    setwireinvalue(xem,hex2dec('03'),32,hex2dec('0020'));updatewireins(xem); %wi03_data[5] to trig region_valid
    setwireinvalue(xem,hex2dec('03'),0,hex2dec('0020'));updatewireins(xem);
    setwireinvalue(xem,hex2dec('05'),i*2^2,hex2dec('001c'));updatewireins(xem);
    read_cnn_data_out = 0;
    while read_cnn_data_out == 0
        updatetriggerouts(xem);
        read_cnn_data_out = istriggered(xem, hex2dec('60'),2); 
        if read_cnn_data_out == 1
            
            pipeout5(:,i) = readfrompipeout(xem, hex2dec('a5'), N_readout_dbg*2);
        end
    end
end
setwireinvalue(xem, 5, 0, 3); % dbg_read_data = wi05_data[1]; dbg_read_valid = wi05_data[0];
updatewireins(xem);
% input via RP2serial
setwireinvalue(xem,hex2dec('03'),32,hex2dec('0020'));updatewireins(xem); %wi03_data[5] to trig region_valid
setwireinvalue(xem,hex2dec('03'),0,hex2dec('0020'));updatewireins(xem);
% figure;
% for i = 1:8
%     subplot(9,1,i); plot(1: N_readout_dbg, dbg_data(:,i))
%     ax(i) = subplot(9,1,i);
%     set(gca,'ylim',[0 1]); set(gca,'ytick',0:1:1);
%     if i<9
%         set(gca,'xticklabel',[]);
%     end
% end
sum(dbg_data(:,1:8))

%% debug valid
setwireinvalue(xem, 0, 2, 2); % init = wi00_data[1];
updatewireins(xem);
setwireinvalue(xem, 5, 0, 3); % dbg_read_data = wi05_data[1]; dbg_read_valid = wi05_data[0];
updatewireins(xem);
% % read and store valid 
setwireinvalue(xem, 5, 1, 3); % dbg_read_data = wi05_data[1]; dbg_read_valid = wi05_data[0];
updatewireins(xem);
% input via RP2serial
setwireinvalue(xem,hex2dec('03'),32,hex2dec('0020'));updatewireins(xem); %wi03_data[5] to trig region_valid
setwireinvalue(xem,hex2dec('03'),0,hex2dec('0020'));updatewireins(xem);
read_cnn_data_out = 0;
while read_cnn_data_out == 0
    updatetriggerouts(xem);
    read_cnn_data_out = istriggered(xem, hex2dec('60'),2); 
    if read_cnn_data_out == 1
        pipeout5(:,9) = readfrompipeout(xem, hex2dec('a5'), N_readout_dbg*2);
    end
end
% figure;
% for i = 9
%     subplot(9,1,i); plot(1: N_readout_dbg, dbg_data(:,i))
%     ax(i) = subplot(9,1,i);
%     set(gca,'ylim',[0 1]); set(gca,'ytick',0:1:1);
%     if i<9
%         set(gca,'xticklabel',[]);
%     end
% end
sum(dbg_data(:,9))
%% check
%read and compare; run onec for each reset
pipeout_rx = readfrompipeout(xem, hex2dec('a1'), region_num*2*2);
pipeout_ry = readfrompipeout(xem, hex2dec('a2'), region_num*2*2);
pipeout_pos = readfrompipeout(xem, hex2dec('a0'), NumOfDataIn*2);
pipeout_neg = readfrompipeout(xem, hex2dec('a3'), NumOfDataIn*2);
if (isequal(pipeout_rx,ddata_rx) && isequal(pipeout_ry,ddata_ry))
    fprintf('region match \n');
else
    fprintf('region mismatch \n');
end
if (isequal(pipeout_pos,ddata_pos) && isequal(pipeout_neg,ddata_neg))
    fprintf('img match \n');
else
    fprintf('img mismatch \n');
end
%%

a = [pipeout_pos,ddata_pos];
b = [pipeout_neg,ddata_neg];



%%
% Bus found in frame: 180
% Car found in frame: 290
% Human found in frame: 1291
% Bike found in frame: 1628
% Van found in frame: 3027
%% plot image & RP boundary
% parameter
X_SIZE = 320;
Y_SIZE = 240;

% path1 = '/media/project2/media/project2/common/recovered_disc/Lavanya/CNN_soham_verif/dfp/full_video_verification/20apr2020/30mar2020/';
% path2 = 'image_1006/0/';
% file_name_pos = 'image_file_channel_0.txt';
% file_name_neg = 'image_file_channel_1.txt';
% rp_file = '';

path1 = 'F:/STEE_PROJ/CONV/Matlab/testing_data/server_brainlab/20180711_ENG_3pm_12mm_02_data/';
path2 = 'image_71';
file_name_pos = [path2,'_0'];%'image_1006_0';
file_name_neg = [path2,'_1'];%'image_1006_1';
rp_file = 'rp_file';
img_pos = load([path1,path2,'/',file_name_pos]);
img_neg = load([path1,path2,'/',file_name_neg]);
rp = load([path1,path2,'/',rp_file]);


read_data_pos = zeros(Y_SIZE,X_SIZE);
read_data_neg = zeros(Y_SIZE,X_SIZE);
for j=1:Y_SIZE
    for i=1:X_SIZE
        read_data_pos(j,i) = img_pos((j-1)*X_SIZE+i);
    end
end
for j=1:Y_SIZE
    for i=1:X_SIZE
        read_data_neg(j,i) = img_neg((j-1)*X_SIZE+i);
    end
end

figure; 
subplot(121);showImage(read_data_pos,rp,2,'red');title('read\_data\_pos'); axis on; %axis([0,240,0,180])
hold on;
subplot(122);showImage(read_data_neg,rp,2,'red');title('read\_data\_neg'); axis on; %axis([0,42,0,42])
% subplot(122);imshow(read_data_neg);title('read\_data\_neg'); axis on; %axis([0,42,0,42])


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


