function read_weight_1and2(xem, weights_mem1, weights_mem2)
%% read weight mem
weight1 = zeros(1,16);
weight2 = zeros(1,16);
error_weight2 = 0;
spi_config(xem, 58, 40); %connect data to parallel_out
spi_config(xem, 63, 2); %rd_en
for weight_cnt=1:16
    spi_config(xem, 61, weight_cnt-1); %rd_addr
    updatewireouts(xem);
    weight1(weight_cnt) = getwireoutvalue(xem, hex2dec('21'));
end
temp1=hex2dec(weights_mem1)';
x=sum(temp1-weight1);
if(abs(x)) 
    disp('Error -- weight1')
else disp('No Error -- weight1')
end

spi_config(xem, 58, 41);
spi_config(xem, 64, 2);
for weight_cnt=1:16
    spi_config(xem, 62, weight_cnt-1);    
    updatewireouts(xem);
    weight2(weight_cnt) = getwireoutvalue(xem, hex2dec('21'));
end
% temp=hex2dec(weights_mem2)';
% x=sum(temp-weight2);
% if(abs(x))
%     disp('Error')
% else disp('No Error')
% end
for i=1:16
    if weight2 ~= hex2dec(weights_mem2(i))
        fprintf('Error -- weight2: weigh2_din[%d] = 0x%s, weigh2_dout[%d] = 0x%s\n', i, weights_mem2{i}, i, num2str(dec2hex(weight2(i))));
        error_weight2=1;
    end
end
if error_weight2==0
    disp('No Error -- weight2')
end