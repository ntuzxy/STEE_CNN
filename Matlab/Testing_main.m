% function AMS035_ELM_Testing_16chips
%% setup XEM6010, do just once
OK_Setup;%% Load the fpga bitstream code
% FPGA_Config(xem,'F:\OpalKelly_Matlab\OpalKelly\working_dir\ok_top_20us.bit');
% FPGA_Config(xem,'F:\GoogleDrive\6-Tapeout\Tapeout_201908\testing_code\OpalKelly_Verilog\testing_xem6010.bit');
FPGA_Config(xem,'C:\Users\sumon\Desktop\XEM3010\OpalKelly3010_Verilog\working_dir\testing_top.bit');
%%
% 10ms per processing, 1s per code (for 100 samples)
% 12bit -> 4096 output codes
% 5000s(4096s) period ramp voltage.
sample_num=100*10;%100;
orig_code=zeros(sample_num,16);
gray_code=zeros(sample_num,12);
bin_code=zeros(sample_num,12);
therm_code=zeros(sample_num,4);
final_data1=zeros(sample_num,4);
final_data2=zeros(sample_num,1);

% % 
tic;
% for i=1:sample_num
%     i
% tic;

% parameter setting & input control signal
num=32;
data_all=zeros(num,3);
data=zeros(num/2,3);

setwireinvalue(xem,hex2dec('00'),0,hex2dec('ffff'));updatewireins(xem); % initialization;
% setwireinvalue(xem,hex2dec('01'),0,hex2dec('ffff'));updatewireins(xem); % initialization;

setwireinvalue(xem,hex2dec('00'),1,hex2dec('0001'));updatewireins(xem); % setup EN=1; % wi00(0)=1, led flickering
      
setwireinvalue(xem,hex2dec('02'),2,hex2dec('0002'));updatewireins(xem); % testing_en=1. setup CLK_PISO controlled by matlab

for i=1:sample_num
    i
setwireinvalue(xem,hex2dec('00'),2,hex2dec('0002'));updatewireins(xem); % setup reset; % wi00(1)=1
% pause(0.0001);
setwireinvalue(xem,hex2dec('00'),0,hex2dec('0002'));updatewireins(xem); % setup reset; % wi00(1)=0

% activatetriggerin(xem, hex2dec('40'), 1);

%         updatewireouts(xem); 
%         fifo_data_valid_initial = bitget(getwireoutvalue(xem, hex2dec('21')),1);
%         fifo_empty_initial = bitget(getwireoutvalue(xem, hex2dec('21')),2);
%         fifo_datain_initial = bitget(getwireoutvalue(xem, hex2dec('21')),3);
        
setwireinvalue(xem,hex2dec('00'),4,hex2dec('0004'));updatewireins(xem); %trig FSM
% pause(0.0001);
setwireinvalue(xem,hex2dec('00'),0,hex2dec('0004'));updatewireins(xem); %


  
% setwireinvalue(xem,hex2dec('01'),1,hex2dec('0001'));updatewireins(xem); % setup EN_CNT=1; % wi01(0)=1
% pause(10*1e-6);
% setwireinvalue(xem,hex2dec('01'),0,hex2dec('0001'));updatewireins(xem); % setup EN_CNT=0; % wi01(0)=0
% 
% pause(0.5);
% setwireinvalue(xem,hex2dec('02'),4,hex2dec('0004'));updatewireins(xem); % mem_wr_en=1
% for clk_piso_cnt = 1:16
%     pause(0.001);
%     setwireinvalue(xem,hex2dec('02'),1,hex2dec('0001'));updatewireins(xem); % setup CLK_PISO=1; % wi02(0)=1
%     pause(0.001);
%     setwireinvalue(xem,hex2dec('02'),0,hex2dec('0001'));updatewireins(xem); % setup CLK_PISO=0; % wi02(0)=0
% end
% setwireinvalue(xem,hex2dec('02'),0,hex2dec('0004'));updatewireins(xem); % mem_wr_en=0
%
%         readfrompipeout(xem, hex2dec('a2'), 2048);
%         updatewireouts(xem); 
%         fifo_data_valid = bitget(getwireoutvalue(xem, hex2dec('21')),1);
%         fifo_empty = bitget(getwireoutvalue(xem, hex2dec('21')),2);
%         fifo_datain = bitget(getwireoutvalue(xem, hex2dec('21')),3);
% 
% data_all(:,1)=readfrompipeout(xem, hex2dec('a1'), 512);%% read output data from memory, two bytes (=1 word)  
% data_all(:,2)=readfrompipeout(xem, hex2dec('a0'), 512);%% read output data from memory, two bytes (=1 word)  

% read_a2=0;
% while read_a2==0
%     updatewireouts(xem); getwireoutvalue(xem, hex2dec('20'))
%     read_a2 = bitget(getwireoutvalue(xem, hex2dec('20')),1);
%     if read_a2
%         1
%         data_a2=readfrompipeout(xem, hex2dec('a0'), 32);
%     end
% end

% %
    done_flag=0;
    while done_flag==0
        updatetriggerouts(xem); 
        done_flag = istriggered(xem, hex2dec('60'), 1);
        if done_flag
%             pause(1);
%             data_all(:,1)=readfrompipeout(xem, hex2dec('a0'), num);%% read output data from memory, two bytes (=1 word)  
            data_all(:,2)=readfrompipeout(xem, hex2dec('a1'), num);%% read output data from memory, two bytes (=1 word)  
%             data_all(:,3)=readfrompipeout(xem, hex2dec('a2'), num);%% read output data from memory, two bytes (=1 word)  
            for j=1:2:num
                data((j+1)/2,:)= data_all(j,:);
            end 
%             data_conv = gc2dec(data(16:-1:5,2)')*16 + sum(data(1:4,2))
        end
    end

[bin,dec] = gc2dec(data(1:12,2)');
phase = udthermo2dec(data(13:16,2));
    
orig_code(i,:)=data(1:16,2);
gray_code(i,:)=data(1:12,2);
bin_code(i,:)=bin(1:12);
therm_code(i,:)=data(13:16,2);

final_data1(i,1)=dec;
final_data2(i,:)=dec*16 + phase;

end
toc;



%%
%*************************************************************************
% % data analysis
%*************************************************************************
mu = mean(final_data1);
sigma = std(final_data1);
jitter = sigma/mu
edges = [round(mu)-5 round(mu)+5];
% h = histogram(final_data1, 'Normalization','probability')%, 'BinLimits',edges)
h = histogram(final_data1, 'BinLimits',edges);

% % Overlay a plot of the probability density function (PDF) for a normal distribution 
% % with a mean of mu and a standard deviation of sigma.
% hold on
% y = 110:1:120;
% f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
% plot(y,f,'LineWidth',1.5)

%% data recall
load testing_results\histo\EN_CNT_60us\histo_high_3_fine.mat;
hist1=final_data1(119:939,3);
hist1_normalize=hist1./sum(hist1);
% histogram boundaries
minbin=min(hist1);
maxbin=max(hist1);
code = maxbin-minbin;
% histogram
% h1=histogram(hist1, 'Normalization', 'cumcount');
[a, b]=hist(hist1, 50);

% h1.Normalization = 'probability';
code = minbin:maxbin;
[DNL,junk] = hist(hist1,code)/16 - 1;
INL=cumsum(DNL);
hold on;
figure(3);
plot(b,(a-mean(a))./a, '-');


%% 2. DNL and INL
% load testing_results\histo\EN_CNT_60us\histo_data_all.mat;
y=hist_data;
minbin=min(y);
maxbin=max(y);

%histogram
% % h=hist(y, minbin:maxbin);
num_bin=400;%define number of histogram bins
hh=histogram(y, num_bin); 
title('Ramp Histogram');
xlabel('ADC Ooutput Code');
ylabel('Code Count');
h=hh.Values(2:end-1); %Remove “Over-range bins”(0 and full-scale) 

%cumulative histogram
ch=cumsum(h);

%transition levels found by:
T=ch/sum(h);

%linearized histogram
hlin=T(2:end)-T(1:end-1);

%truncate first and last bin, more if input did not clip ADC
trunc=0;
hlin_trunc=hlin(1+trunc:end-trunc);

global misscodes;
%calculate lsb size and dnl
lsb=sum(hlin_trunc)/(length(hlin_trunc));

dnl=[0 hlin_trunc/lsb-1];
misscodes=length(find(dnl<-0.99));

%calculate inl
inl=cumsum(dnl);

%plot
figure;
plot(1:length(dnl),dnl);
grid on;
title('DNL');
xlabel('DIGITAL OUTPUT CODE');
ylabel('DNL (LSB)');
% set(gca,'XTick',-pi:pi/2:pi);
% set(gca,'XTickLabel',{'-pi','-pi/2','0','pi/2','pi'});

figure;
plot([1:length(inl)],inl);
grid on;
title('INL');
xlabel('DIGITAL OUTPUT CODE');
ylabel('INL(LSB)');

%% dnl_inl_ramp function testing
% y= round(random('Normal',500,10,1000,1))
y=[zeros(200,1);1*ones(100,1);2*ones(140,1);3*ones(100,1);4*ones(100,1);5*ones(60,1);6*ones(100,1);7*ones(200,1)];

[dnl, inl] =  dnl_inl_ramp(y);
figure;
plot(1:length(dnl),dnl,'o-');
grid on;
title('DNL');
xlabel('DIGITAL OUTPUT CODE');
ylabel('DNL (LSB)');
figure;
plot([1:length(inl)],inl);
grid on;
title('INL (BEST END-POINT FIT)');
xlabel('DIGITAL OUTPUT CODE');
ylabel('INL(LSB)');
%%
numbit=12;
[dnl, inl] =  dnl_inl_ramp(hist_data);
figure;
plot(1:length(dnl),dnl,'o-');
grid on;
title('DNL');
xlabel('DIGITAL OUTPUT CODE');
ylabel('DNL (LSB)');
figure;
plot([1:length(inl)],inl);
grid on;
title('INL (BEST END-POINT FIT)');
xlabel('DIGITAL OUTPUT CODE');
ylabel('INL(LSB)');
%%
% calculate lsb size and dnl
lsb= sum(hist1) / (length(hist1));
dnl= [0 hist1/lsb-1];
misscodes = length(find(dnl<-0.99));
% calculate inl
inl= cumsum(dnl);




%% 3. jitter
    %(1) data refine
for i = 1:length(data_valid)
    if data_valid(i) < 215
        data_valid(i)=215;
    else
        data_valid(i)=data_valid(i);
    end 
end
%% 3. jitter
    %(2) recall file
% low frequency
load testing_results\jitter\counter_value_H00_10mv_4_miu=245_sigma=0.5.mat;
mu_00 = mean(data_valid);
sigma_00 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H01_10mv_1_miu=273_sigma=0.55.mat;
mu_01 = mean(data_valid);
sigma_01 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H10_10mv_1_miu=212_sigma=0.6.mat;
mu_10 = mean(data_valid);
sigma_10 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H11_10mv_1_miu=217_sigma=0.5.mat;
mu_11 = mean(data_valid);
sigma_11 = std(data_valid);
h1=histogram(data_valid);
legend('00: miu=245, sigma=0.56','01: miu=273, sigma=0.55','10: miu=213, sigma=0.59','11: miu=217, sigma=0.54');

% medium frequency
load testing_results\jitter\counter_value_H00_50mv_4_miu=1045_sigma=1.mat;
mu_00 = mean(data_valid);
sigma_00 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H01_50mv_5_miu=1158_sigma=0.95.mat;
mu_01 = mean(data_valid);
sigma_01 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H10_50mv_1_miu=921_sigma=1.6.mat;
mu_10 = mean(data_valid);
sigma_10 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H11_50mv_2_miu=924_sigma=1.2.mat;
mu_11 = mean(data_valid);
sigma_11 = std(data_valid);
h1=histogram(data_valid);
legend('00: miu=1046, sigma=1.10','01: miu=1158, sigma=0.95','10: miu=922, sigma=1.66','11: miu=924, sigma=1.23');

% high frequency
load testing_results\jitter\counter_value_H00_100mv_3_miu=1900_sigma=4.mat;
mu_00 = mean(data_valid);
sigma_00 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H01_100mv_2_miu=2100_sigma=5.mat;
mu_01 = mean(data_valid);
sigma_01 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H10_100mv_3_miu=1710_sigma=8.mat;
mu_10 = mean(data_valid);
sigma_10 = std(data_valid);
h1=histogram(data_valid);
hold on;
load testing_results\jitter\counter_value_H11_100mv_2_miu=1692_sigma=5.4.mat;
mu_11 = mean(data_valid);
sigma_11 = std(data_valid);
h1=histogram(data_valid);
legend('00: miu=1903, sigma=5.05','01: miu=2098, sigma=5.23','10: miu=1707, sigma=8.13','11: miu=1692, sigma=5.37');


%%
h1 = openfig('median_counter_value_117.fig','reuse'); % open figure
D1=get(gca,'Children'); %get the handle of the line object
XData1=get(D1,'XData'); %get the x data
YData1=get(D1,'YData'); %get the y data
Data1=[XData1' YData1']; %join the x and y data on one array nx2

%%
h=open('median_counter_value_117.fig');
a=get(h);
b=get(a.Children);
c=get(b.Children);
xx=c.Data;

mu = mean(xx);
sigma = std(xx);
jitter = sigma/mu





