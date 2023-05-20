% plot laser power meter readings vs supplied laser diode power
% data from lab notebook 2021/05/24
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
% original data from 05/04
data1 = [ 1.0, 0.007e-3; 2.0, 0.004e-3; 3.0, 3.63; 3.5, 11.66; 4.0, 19.3; ...
    4.5, 27.0; 5.0, 27.2; 5.5, 27.0; 6.0, 26.4; 2.5, 1.70e-3; 3.0, 3.95; ...
    3.5, 11.87; 4.0, 18.9; 4.5, 27.6; 5.0, 27.6];
% 05/24 data first column. This is without BP filter, but with power meter
% 1 cm away from laser diode tip
data2 = [ 1.0, 0.351e-3; 2.0, 0.343e-3; 2.5, 0.384e-3; 3.0, 1.111; 3.5, ...
    3.41; 4.0, 5.74; 4.5, 7.98; 5.0, 8.00; 5.5, 7.98; 6.0, 7.95];
% 05/24 data second column. This is with BP filter, and with power meter
% 1 cm away from laser diode tip
data3 = [ 1.0, 0.111e-3; 2.0, 0.111e-3; 2.5, 0.119e-3; 3.0, 0.152; 3.5, ...
    0.397; 4.0, 0.714; 4.5, 1.003; 5.0, 1.013; 5.5, 1.012; 6.0, 1.008];
% 05/24 data third column. This is with BP filter, and with power meter
% 1 cm away from laser diode tip
data4 = [ 1.0, 0.109e-3; 2.0, 0.109e-3; 2.5, 0.140e-3; 3.0, 0.199; 3.5, ...
    0.403; 4.0, 0.771; 4.5, 1.032; 5.0, 1.074; 5.5, 1.072; 6.0, 1.068];

plot(data1(:,1), data1(:,2),'o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
pause (1)
plot(data2(:,1), data2(:,2),'o','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
pause (1)
plot(data3(:,1), data3(:,2),'o','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
pause (1)
plot(data4(:,1), data4(:,2),'o','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',purple);
set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured laser diode output power vs supplied voltage');
xlabel('Voltage (V)'); % x-axis label
ylabel('Power (mW)'); % y-axis label
leg = legend('show');
title(leg,'Measurement location')
legend('at diode','1 cm away','1 cm away after filter side 1',...
    '1 cm away after filter side 2','Location','northwest');
% legend('1 cm away','1 cm away after filter side 1',...
%     '1 cm away after filter side 2','Location','northwest');

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