function data=readconfig_hex(xem,addr)
    % readconfig(xem, 'addr')
    % readconfig(xem,'10')
    addrInt=hex2dec(addr)
    setwireinvalue(xem,hex2dec('08'),addrInt,hex2dec('ffff'));updatewireins(xem);
    activatetriggerin(xem, hex2dec('41'), 1);updatewireins(xem);
    updatewireouts(xem); data=getwireoutvalue(xem, hex2dec('20'));
    data= dec2hex(data);
end