function read_ptr_1and2(xem, kernel_ptr_lyr1,kernel_ptr_dw_lyr2,kernel_ptr_pw_lyr2)
%% read ptr1~2
    spi_config(xem, 58, 42); %connect data to parallel_out
    spi_config(xem, 67, 2); %rd_en
    ptr1=zeros(1,480);
for weight_cnt=1:480
    spi_config(xem, 65, weight_cnt-1); %rd_addr
    updatewireouts(xem);
    ptr1(weight_cnt) = floor(getwireoutvalue(xem, hex2dec('21'))/16);%4bitLSM=4bitMSB
end
temp=hex2dec([kernel_ptr_lyr1;kernel_ptr_dw_lyr2;kernel_ptr_pw_lyr2])';
error_number=0;
for i=1:480
    error_number=error_number+(temp(i)~=ptr1(i));
end
x=sum(temp-ptr1);
if(abs(x))
    disp(strcat('Error-',num2str(error_number)));
else disp('No Error -- lyr1-2_ptr')
end