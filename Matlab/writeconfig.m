function writeconfig(xem,data, addr)
    % writeconfig(xem,'data', 'addr')
    % writeconfig(xem,'100', '10')
    dataInt=hex2dec(data);
    addrInt=hex2dec(addr);
    setwireinvalue(xem,hex2dec('09'),dataInt,hex2dec('ffff'));updatewireins(xem);
    setwireinvalue(xem,hex2dec('08'),addrInt,hex2dec('ffff'));updatewireins(xem);
    activatetriggerin(xem, hex2dec('41'), 0);updatewireins(xem);
end