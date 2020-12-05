function dummy(xem)
ycor=[3 4 5 9 19 11];
for j=1:6
    y=57344+ycor(j);
    datay=dec2hex(y,4);
    out=65000;
    while (out ~=y)
        writeconfig(xem,datay, '8E')
        pause(0.01)
        out=readconfig(xem, '8E');
    end
    out=readconfig_hex(xem, '8E')
    dummy=[300 301 302 303 304];
    sizeXcoordinate=size(dummy,2);
    for i=1:sizeXcoordinate
        x=57344+dummy(i);
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