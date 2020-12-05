function reset_msp(xem)
    setwireinvalue(xem,hex2dec('07'),0,hex2dec('ffff'));updatewireins(xem);
    pause(0.001);
    setwireinvalue(xem,hex2dec('07'),1,hex2dec('ffff'));updatewireins(xem);
end