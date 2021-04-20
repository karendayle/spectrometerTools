% ref https://www.mathworks.com/support/search.html/answers/99728-is-it-possible-to-turn-off-or-suppress-the-x-y-or-z-axis-in-a-plot.html?fq[]=asset_type_name:answer&fq[]=category:stats/exploratory-data-analysis&page=1
% Example of how to turn off the X-axis in the
% top subplot.
% Define some data
x = linspace(0,8*pi,100);
y1 = sin(x);
y2 = cos(x);
% Create the plots
ax(1) = subplot(211);
plot(x,y1)
ax(2) = subplot(212);
plot(x,y1)
% Set the X-axis tick locations and limits of
% each plot to the same values
% set(ax,'XTick',get(ax(1),'XTick'), ...
%      'XLim',get(ax(1),'XLim'))
% Turn off the X-tick labels in the top axes
set(ax(1),'XTickLabel','')
% Set the color of the X-axis in the top axes
% to the axes background color
set(ax(1),'XColor',get(gca,'Color'))
% Turn off the box so that only the left 
% vertical axis and bottom axis are drawn
% set(ax,'box','off')
xlabel('so there');