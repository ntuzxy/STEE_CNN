% OK setup 

% Setup the XEM and PLL configuration.
% clear all;

loadlibrary('okFrontPanel', 'okFrontPanelDLL.h'); 

xPointer = calllib('okFrontPanel', 'okFrontPanel_Construct');
numDevices = calllib('okFrontPanel', 'okFrontPanel_GetDeviceCount', xPointer);
if numDevices == 0 
error('error: there are no devices connected')
elseif numDevices > 1
error('error: there is more than one device connected')
else
disp('There is one device connected')
end

pll = okpll22393(); % How to set PLL ??????

disp(['Device model: ' calllib('okFrontPanel', 'okFrontPanel_GetDeviceListModel', xPointer, 0)])
% serialNumber = calllib('okFrontPanel', 'okFrontPanel_GetDeviceListSerial', xPointer, 0, ' ');
xem = okusbfrontpanel(xPointer);
if isopen(xem)
disp('The FPGA is already open.')
else
disp('Attempting to open the FPGA.')
% resultOfAttemptingToOpenFpga = openbyserial(xem, serialNumber);
resultOfAttemptingToOpenFpga = openbyserial(xem,'');
end