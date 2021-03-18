function visualize_v2(img_pos, img_neg, rp, class_out, path1,path2, t_hw,t_sw) 
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
%SW results
region_num = rp(1);
classout_from_software = zeros(5, region_num); %5 classes
for i=0:rp(1)-1
    classout_from_software(:,i+1) = load([path1,path2,'/',num2str(i),'_final_output.txt']);
end
%RP position & results annotation
label_hw = cell(region_num,1);
label_sw = cell(region_num,1);
position = zeros(region_num,4); %bounding box (x,y,w,h)
for i=1:rp(1)
    sm_conf_hw = softmax(hex2sdec(class_out(:,i),32));
    sm_conf_sw = softmax(classout_from_software(:,i));
    [conf_hw,idx_hw] = max(sm_conf_hw);
    [conf_sw,idx_sw] = max(sm_conf_sw);
    label_hw(i) = strcat(class(idx_hw), ': ', num2str(conf_hw*100), '%');
    label_sw(i) = strcat(class(idx_sw), ': ', num2str(conf_sw*100), '%');
    position(i,1:4) = [rp(4*i-2),rp(4*i-1),rp(4*i)-rp(4*i-2),rp(4*i+1)-rp(4*i-1)];
end

%annotation
frame = insertObjectAnnotation(img_data_pos,'rectangle',position,label_hw);
subplot(1, 2, 1);
imshow(frame); axis on; %axis([0,240,0,180])

subplot(1, 2, 2); axis off;
t_hw.String = label_hw;
t_sw.String = label_sw;

% pause(0.5)
% set(t_hw,'Visible','off');
% set(t_sw,'Visible','off');
