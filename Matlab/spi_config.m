%% SPI config
% xem: okusbfrontpanel
% config_addr: decimal
% config_data: decimal
function spi_config(xem, config_addr, config_data)
    setwireinvalue(xem,hex2dec('01'),config_addr,hex2dec('ffff'));updatewireins(xem);
    setwireinvalue(xem,hex2dec('02'),config_data,hex2dec('ffff'));updatewireins(xem);
    activatetriggerin(xem, hex2dec('41'), 0);updatewireins(xem); %write
    activatetriggerin(xem, hex2dec('41'), 1);updatewireins(xem); %read
    updatewireouts(xem);
    wo_data = getwireoutvalue(xem, hex2dec('20'));
    if (wo_data == config_data) 
%         fprintf('SUCCESS -- Address: 0d%.3d   WriteIn: 0x%s   ReadOut: 0x%s \n', config_addr, dec2hex(config_data,4), dec2hex(wo_data,4));
    else
        fprintf(2,'FAILURE -- Address: 0d%.3d   WriteIn: 0x%s   ReadOut: 0x%s \n', config_addr, dec2hex(config_data,4), dec2hex(wo_data,4)); %highlight (red) display
    end