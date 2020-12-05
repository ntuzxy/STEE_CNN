function showImage(img,rp,lineWidth,color) 
%img:img = imread(IMGNAME) 
%rp:[num_obj,Xstart_1,Ystart_1,Xstop_1,Ystop_1,Xstart_2,Ystart_2,Xstop_2,Ystop_2,...]
%lineWidth: 2 
%color:	RGB Triplet, eg. [1,0,0] or Color Name, eg. red(r) or Hexadecimal
%Color Code, eg. '#FF0000'
%rectangle('Position',[Xstart,Ystartt,Xwidth,Yheight],'LineWidth',4,'EdgeColor','r');
imshow(img) 
for i=1:rp(1)
    rectangle('Position',[rp(4*i-2),rp(4*i-1),rp(4*i)-rp(4*i-2),rp(4*i+1)-rp(4*i-1)],'LineWidth',lineWidth,'EdgeColor',color);
% pause; 
end