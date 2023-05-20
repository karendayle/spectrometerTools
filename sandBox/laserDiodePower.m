% plot laser power meter readings vs supplied laser diode power
% data from lab notebook 2021/04/05
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

data = [ 1.0, 0.007e-3; 2.0, 0.004e-3; 3.0, 3.63; 3.5, 11.66; 4.0, 19.3; ...
    4.5, 27.0; 5.0, 27.2; 5.5, 27.0; 6.0, 26.4; 2.5, 1.70e-3; 3.0, 3.95; ...
    3.5, 11.87; 4.0, 18.9; 4.5, 27.6; 5.0, 27.6];
plot(data(:,1), data(:,2),'o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured laser diode output power vs supplied voltage');
xlabel('Voltage (V)'); % x-axis label
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