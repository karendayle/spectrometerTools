% plot IPS laser power readings vs distance of power meter sensor from 
% probe tip
% data from lab notebook 2021/06/10
close all;

blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];
magenta = [1.0, 0.0, 1.0];

myTextFont = 30;
figure
% original data from 6/10/2021
data1 = [ 0.0, 23.5; 0.5, 23.3; 1.0, 23.1; 2.0, 22.7; 2.5, 22.3; 3.0, 22.0 ];

plot(data1(:,1), data1(:,2),'o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);

set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('IPS laser output power dropoff with distance');
xlabel('Distance (cm)'); % x-axis label
ylabel('Power (mW)'); % y-axis label


function g = saveMyPlot(FigH, myTitle)
global plotOption
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    switch plotOption
        case {1,2,3}
            myPlotName = sprintf('%s%s', plotDirStem, myTitle);
        case 4
            myPlotName = sprintf('%s%s curve fit', plotDirStem, myTitle);
    end
    saveas(FigH, myPlotName, 'png');
    g = 1;
end