function []=FPGA_Config(xem,fpga_bit_file)
% Load the fpga bitstream code
% resultOfAttemptingToConfigureFpga = configurefpga(xem, 'ams035_oct13_test.bit');
resultOfAttemptingToConfigureFpga = configurefpga(xem, fpga_bit_file);
% resultOfAttemptingToConfigureFpga = configurefpga(xem, 'ams035_oct13_test - bk20140311.bit');
disp(['Result of attempting to configure the FPGA: ' resultOfAttemptingToConfigureFpga]) 
pause on;%newly added
setwireinvalue(xem,hex2dec('00'),0,hex2dec('1'));updatewireins(xem);%newly added
pause(0.5);%newly added
setwireinvalue(xem,hex2dec('00'),1,hex2dec('1'));updatewireins(xem);