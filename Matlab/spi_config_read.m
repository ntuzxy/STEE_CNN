function wo_data=spi_config_read(xem, config_addr)
    setwireinvalue(xem,hex2dec('01'),config_addr,hex2dec('ffff'));updatewireins(xem);
%     setwireinvalue(xem,hex2dec('02'),config_data,hex2dec('ffff'));updatewireins(xem);
%     activatetriggerin(xem, hex2dec('41'), 0);updatewireins(xem); %write
    activatetriggerin(xem, hex2dec('41'), 1);updatewireins(xem); %read
    updatewireouts(xem);
    wo_data = getwireoutvalue(xem, hex2dec('20'));