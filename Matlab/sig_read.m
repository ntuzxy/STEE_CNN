image90=bin_image{95}.frame;
FPGA_Config(xem,'C:\Users\sumon\Desktop\XEM3010_050620\OpalKelly3010_Verilog\working_dir\testing_top_11_0_44.bit');
%% reset
setwireinvalue(xem,hex2dec('05'),0,hex2dec('ffff'));updatewireins(xem);
setwireinvalue(xem,hex2dec('07'),0,hex2dec('ffff'));updatewireins(xem);
setwireinvalue(xem,hex2dec('07'),1,hex2dec('ffff'));updatewireins(xem);
disp('reset done')
%% config writinng: clear all
for i=128:144
    hex_addr=dec2hex(i,2);
    data_hex='0000';
    data=0;
    out=65000;
    while (out ~=data)
        writeconfig(xem,data_hex, hex_addr)
        %pause(0.01)
        out=readconfig(xem, hex_addr);
    end
    out
    out1=readconfig_hex(xem, hex_addr)
end
disp('config clear done')
% end of config write
%% Burst enable 
%burst enble for external write
%sel_empty=1; burst_ensel==1, burst_enext—1, busy_ext =0, mfilter_5=0, y_scale=11, x_scale=10 max_height= 7’h50;
%1110_0111_0101_0000
data_hex='E750';
data=hex2dec(data_hex);
out=65000;
while (out ~=data)
        writeconfig(xem,data_hex, '8D')
        out=readconfig(xem, '8D')
end
out=readconfig_hex(xem, '8D')
%% enable RP1
data_hex='4000';
data=hex2dec(data_hex);
out=65000;
while (out ~=data)
        writeconfig(xem,data_hex, '8A')
%         %pause(1)
        out=readconfig(xem, '8A');
end
out=readconfig_hex(xem, '8A')
%% write SRAM memory
for j=0:1:179
    y=57344+j;
    datay=dec2hex(y,4);
    out=65000;
    while (out ~=y)
        writeconfig(xem,datay, '8E')
%         %pause(0.01)
        out=readconfig(xem, '8E');
    end
    out=readconfig_hex(xem, '8E')
    xCoordinate=find(image90(j+1,:)==1);
    sizeXcoordinate=size(xCoordinate,2);
    if(sizeXcoordinate>0) 
        for i=1:sizeXcoordinate
            x=57344+xCoordinate(i)-1;
            datax=dec2hex(x,4);
            out =65000;
            while (out ~=x)
                writeconfig(xem,datax, '8F')
                out=readconfig(xem, '8F');
            end
            out=readconfig_hex(xem, '8F')
            i
        end
    end 

x=57344;
datax=dec2hex(x,4);
out =65000;
while (out ~=x)
writeconfig(xem,datax, '8F')
    out=readconfig(xem, '8F');
end
out=readconfig_hex(xem, '8F')
end
%%
%dummy object 
dummy(xem)
%% burst disable
data_hex='C750';
data=hex2dec(data_hex);
out=65000;
while (out ~=data)
        writeconfig(xem,data_hex, '8D')
        out=readconfig(xem, '8D');
end
out=readconfig_hex(xem, '8D')
%% read memory
%pause(1)
setwireinvalue(xem,hex2dec('05'),1,hex2dec('ffff'));updatewireins(xem);
setwireinvalue(xem,hex2dec('05'),0,hex2dec('ffff'));updatewireins(xem);
disp('read SRAM')
%%
x=57856;
datax=dec2hex(x,4);
out =65000;
while (out ~=x)
writeconfig(xem,datax, '8F')
    out=readconfig(xem, '8F');
end
out=readconfig_hex(xem, '8F')
pause(1)

%%
sramData=[];
for rowAddress=0:44
    setwireinvalue(xem,hex2dec('04'),rowAddress,hex2dec('ffff'));updatewireins(xem);
    for columnAddress=1:15
        setwireinvalue(xem,hex2dec('06'),columnAddress,hex2dec('ffff'));updatewireins(xem);
        updatewireouts(xem); data=dec2bin(getwireoutvalue(xem, hex2dec('22')),16);
        for i=1:16
            sramData(rowAddress+1,(columnAddress-1)*16+i)=str2num(data(i));
        end
    end
    rowAddress
end
%% 00 state[0] on sig1 and state [1] on sig2
x=0;
datax=dec2hex(x,4);
out =65000;
while (out ~=x)
writeconfig(xem,datax, '8F')
    out=readconfig(xem, '8F');
end
out=readconfig_hex(xem, '8F')
%% state[2] on sig1 and state [3] on sig2
%datax=dec2hex(x,4);
datax='2400'
x=hex2dec(datax)
out =65000;
while (out ~=x)
writeconfig(xem,datax, '8F')
    out=readconfig(xem, '8F');
end
out=readconfig_hex(xem, '8F')
%% state[4] on sig1 and write state on sig2
%datax=dec2hex(x,4);
datax='4800'
x=hex2dec(datax)
out =65000;
while (out ~=x)
writeconfig(xem,datax, '8F')
    out=readconfig(xem, '8F');
end
out=readconfig_hex(xem, '8F')
%%
setwireinvalue(xem,hex2dec('05'),1,hex2dec('ffff'));updatewireins(xem);