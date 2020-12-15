%% read ptr3
function read_ptr3(xem, kernel_ptr_fc_lyr)
lyr3_ptr_data = zeros(49*5*5,1);
spi_config(xem, 83, hex2dec('03e0'));%rden
for lyr3_ptr_cnt=1:49
    spi_config(xem, 72, lyr3_ptr_cnt-1);%addra_wght_ptr3[0]    
    spi_config(xem, 58, 36);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*0) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*1) = floor(temp/16);
    spi_config(xem, 58, 37);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*2) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*3) = floor(temp/16);
    spi_config(xem, 58, 38);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*4) = temp;
    
    spi_config(xem, 71, lyr3_ptr_cnt-1);%addra_wght_ptr3[1] 
    spi_config(xem, 58, 32);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*0+49*5) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*1+49*5) = floor(temp/16);
    spi_config(xem, 58, 33);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*2+49*5) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*3+49*5) = floor(temp/16);
    spi_config(xem, 58, 34);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*4+49*5) = temp;
    
    spi_config(xem, 70, lyr3_ptr_cnt-1);%addra_wght_ptr3[2] 
    spi_config(xem, 58, 28);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*0+49*5*2) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*1+49*5*2) = floor(temp/16);
    spi_config(xem, 58, 29);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*2+49*5*2) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*3+49*5*2) = floor(temp/16);
    spi_config(xem, 58, 30);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*4+49*5*2) = temp;
    
    spi_config(xem, 69, lyr3_ptr_cnt-1);%addra_wght_ptr3[3] 
    spi_config(xem, 58, 24);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*0+49*5*3) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*1+49*5*3) = floor(temp/16);
    spi_config(xem, 58, 25);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*2+49*5*3) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*3+49*5*3) = floor(temp/16);
    spi_config(xem, 58, 26);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*4+49*5*3) = temp;
    
    spi_config(xem, 68, lyr3_ptr_cnt-1);%addra_wght_ptr3[4] 
    spi_config(xem, 58, 20);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*0+49*5*4) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*1+49*5*4) = floor(temp/16);
    spi_config(xem, 58, 21);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*2+49*5*4) = rem(temp,16);
    lyr3_ptr_data(lyr3_ptr_cnt+49*3+49*5*4) = floor(temp/16);
    spi_config(xem, 58, 22);
    updatewireouts(xem);
    temp = getwireoutvalue(xem, hex2dec('21'));
    lyr3_ptr_data(lyr3_ptr_cnt+49*4+49*5*4) = temp;
end

if lyr3_ptr_data == hex2dec(kernel_ptr_fc_lyr)
    disp('No Error -- lyr3_ptr')
else
    disp('Error -- lyr3_ptr')
end