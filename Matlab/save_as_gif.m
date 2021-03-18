function save_as_gif(i, i0, fig, tpf, filename)
%%%% this function is to save figure as a gif file
%%%% put this function in a loop where i is the index
%%%% i: index of the loop
%%%% i0: initial value of i
%%%% fig: the handle of figure
%%%% tpf: time duration per frame if there is no other delay in the loop, e.g. 0.3
%%%% filename: filename to be saved, e.g. 'mygif.gif'

% fig = figure;
% subplot(1, 2, 1);
% subplot(1, 2, 2);
frame = getframe(fig);

im=frame2im(frame);
[I,map]=rgb2ind(im, 256);
if i == i0
    imwrite(I, map, filename, 'gif', 'Loopcount', Inf, 'DelayTime', tpf);%??Loopcount???Inf?????????????
else
    imwrite(I, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', tpf);
end

