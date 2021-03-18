% visualize
if exist('t_hw', 'var') && ishold % clear text if (it's already exit and the figure is hold)
    t_hw.String = '';
    t_sw.String = '';
else %initialize figure and text if (the text is not exit [first-time run] or the figure is closed)
    close(); % ishold command will create a figure, colse it
    fig = figure;
    subplot(1, 2, 1); axis off;
    subplot(1, 2, 2); axis off;
    hold on;
    text(0,0.72,'HW:');
    text(0.5,0.72,'SW:');
    t_hw = text(0,0.5,'');
    t_sw = text(0.5,0.5,'');
end

%%
figure_number = 1;
x      = 150;   % Screen position
y      = 0;   % Screen position
width  = 1500; % Width of figure
height = 1000; % Height of figure (by default in pixels)

figure('Position', [x y width height]);