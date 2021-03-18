%% SPI config
% xem: okusbfrontpanel
% config_addr: decimal
% config_data: decimal
function writeconfig(xem, config_addr, config_data)
    dataInt=hex2dec(config_data);
    addressInt=hex2dec(config_addr);
    setwireinvalue(xem,hex2dec('06'),dataInt,hex2dec('ffff'));updatewireins(xem);
    setwireinvalue(xem,hex2dec('01'),addressInt,hex2dec('ffff'));updatewireins(xem);
    activatetriggerin(xem, hex2dec('41'), 0);updatewireins(xem); %write
