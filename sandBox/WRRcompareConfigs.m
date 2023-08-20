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

close all;
% start of ST1
% w/o 2nd value to improve resolution, without mm data unless that's all there is
% 8/4 dataset
data1mm     = [274.8,  208.1,  274.1,  273.8,  15.1          ];
% 8/17 dataset
data2iPhone = [360,    260,    330,    270,    110           ];
%8/18 dataset - circuitry optimized onto 1 breadboard
data3iPhone = [272.31, 277.15, 320.65, 319.85, 48.34, 541.41 ];
%8/18 dataset - circuitry moved back to 2 breadboards
data4iPhone = [367.38, 273.93, 311.79, 307.76, 31.42, 1004.66];

% ST1 plot
figure
% Vout
x = 1:1:5;
plot(x, data1mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, data2iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
x = 1:1:6;
plot(x, data3iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, data4iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout vs supplied laser diode voltage, with V_R_B = 3V');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('ST1 dataset 1','ST1 dataset 2','ST1 dataset 3', ...
    'ST1 dataset 4','ST1 dataset 5','ST1 dataset 6','ST1 dataset 7', ...
    'Location','northwest');
title(lgd,'Dataset')

% end of ST1

% start of US1
% 0-mm-offset case only
% 9/7 dataset: case 1: depth = 0 mm, offset = 0 mm
%data0mm     = [110,  44,     89,  71,  284,  143,  156,  72       ];
data0iPhone = [114,  64,    113,  95,  298,  190,  210, 128       ];

% plot US1
figure
% Vout
x = 1:1:8;
plot(x, data0iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout using u-shaped config and different setups');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('US1 dataset 1', 'Location', 'northeast');
title(lgd,'Offset')

% end of US1

% start of US2 (get values from table 5-5)
US2data1 = [ 2049., 60., 135. 3., 1910., 262., 224., 10. ];
US2data2 = [ 1275., 97., 170., 2., 2546., 893., 837., 6.];
US2data3 = [ 2002., 100., 315., 4., 2527., 545., 417., 6. ];

% plot US2
figure
% Vout
x = 1:1:8;
plot(x, US2data1,'-s','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, US2data2,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, US2data3,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout using u-shaped config and different setups');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('US2 dataset 1', 'US2 dataset 2', 'US2 dataset 3', ...
    'Location', 'northeast');
title(lgd,'Offset')
% end of US2

% start of US3
US3data1 = [ 1615., 60., 235., 0., 2478., 93., 208., 10. ];
US3data2 = [ 1673., 39., 124., 3., 2425., 116., 364., 3. ];
US3data3 = [ 1917., 68., 125., 3., 2495., 224., 444., 11. ];

% plot US3
figure
% Vout
x = 1:1:8;
plot(x, US3data1,'-s','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, US3data2,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, US3data3,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout using u-shaped config and different setups');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('US3 dataset 1', 'US3 dataset 2', 'US3 dataset 3', ...
    'Location', 'northeast');
title(lgd,'Offset')
% end of US3

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