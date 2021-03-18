function results_show(img_pos, img_neg, rp, classout_hardware, classout_software)
% % show info: image, RP box, classout confidence  
% % put this function in a loop for video demo

%% put this part before the loop
%     fig = figure(1);
%     hold on;
%%
    %class
%     class = {'car', 'bus', 'van', 'bike', 'other'};
    class = {'Other', 'Car', 'Bus', 'TruckVan', 'Bike'};
    X = categorical(class);
    colors = {'red','green','blue','cyan',...
                'magenta','yellow','red','green'};

    %image (resize from 320x240 to 230x180 to show)
    X_SIZE = 320;
    Y_SIZE = 240;
    WIDTH = 240;
    HIGHT = 180;
    img_data_pos = zeros(HIGHT,WIDTH);
    img_data_neg = zeros(HIGHT,WIDTH);
    for j=1:HIGHT
        for i=1:WIDTH
            img_data_pos(j,i) = img_pos((j-1)*X_SIZE+i);
            img_data_neg(j,i) = img_neg((j-1)*X_SIZE+i);
        end
    end
    
    %plot image
%     fig = figure(1);
    subplot(8,4,[1,2,5,6]); %image_pos
%     imagesc(img_data_pos);
    imshow(img_data_pos); axis on;
%     title(['Current Image: ',cats{classID}]);
    title('Postive Image');
    subplot(8,4,[3,4,7,8]); %image_neg
%     imagesc(img_data_neg);
    imshow(img_data_neg); axis on;
%     title(['Current Image: ',cats{classID}]);
    title('Negtive Image');
    
    %plot bounding box
    region_num = rp(1);
    for i = 1:region_num
        A= [rp(4*i-2),rp(4*i-1),rp(4*i)-rp(4*i-2),rp(4*i+1)-rp(4*i-1)]; %bounding box (x,y,w,h)
        subplot(8,4,[1,2,5,6]);
        rectangle('Position',A,'EdgeColor',colors{i});
        subplot(8,4,[3,4,7,8]);
        rectangle('Position',A,'EdgeColor',colors{i});
    end
    
    %plot class confidence
    for j = 13:24 % clear subplot
        delete(subplot(8,4,j));
    end
    for kk = 1:region_num
        if (kk<=4)
            subplot(8,4,12+kk);
        else
            subplot(8,4,16+kk);
        end
        
        hwcc = classout_hardware(:,kk);
        swcc = classout_software(:,kk);
%         sm_conf_hw = softmax(hwcc);
%         sm_conf_sw = softmax(swcc);
        %%%% NOTE: softmax function would give wrong results in same cases
        sm_conf_hw = exp(hwcc)/sum(exp(hwcc));
        sm_conf_sw = exp(swcc)/sum(exp(swcc));

%         B = bar(X,[sm_conf_hw,sm_conf_sw],colors{kk});
        B = bar([sm_conf_hw,sm_conf_sw],colors{kk});
        set(B(2),'FaceAlpha',.25);
        set(gca,'ylim',[0,1],'ytick',(0:0.5:1));
        set(gca,'XTickLabel',class);
        set(gca,'XTickLabelRotation',45);
        str = sprintf('RP %d',kk);
        title(str);
    end
end