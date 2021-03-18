function visualize(img_pos, img_neg, rp, class_out) 
%class
class = {'car', 'bus', 'van', 'bike', 'other'};
%image
X_SIZE = 320;
Y_SIZE = 240;
WIDTH = 240;
DEPTH = 180;
img_data_pos = zeros(DEPTH,WIDTH);
img_data_neg = zeros(DEPTH,WIDTH);
for j=1:DEPTH
    for i=1:WIDTH
        img_data_pos(j,i) = img_pos((j-1)*X_SIZE+i);
        img_data_neg(j,i) = img_neg((j-1)*X_SIZE+i);
    end
end
%RP position and label
region_num = rp(1);
label = cell(region_num,1);
position = zeros(region_num,4); %{x,y,w,h}
for i=1:region_num
    sm_conf = softmax(hex2sdec(class_out(:,i),32));
    [conf,idx] = max(sm_conf);
    label(i) = strcat(class(idx), ': ', num2str(conf*100), '%');
    position(i,1:4) = [rp(4*i-2),rp(4*i-1),rp(4*i)-rp(4*i-2),rp(4*i+1)-rp(4*i-1)];
end
%show image with annotations
frame = insertObjectAnnotation(img_data_pos,'rectangle',position,label);
imshow(frame); axis on; %axis([0,240,0,180])
