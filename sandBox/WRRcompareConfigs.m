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
myTextFont = 10;
xMin = 6;
xMax = 8;
yMin = 0;
yMax = 1200;

close all;
% start of ST1
% w/o 2nd value to improve resolution, without mm data unless that's all there is
% 8/4 dataset
data1mm     = [274.8,  208.1,  274.1,  273.8,  15.1           ];
% 8/17 dataset
data2iPhone = [360,    260,    330,    270,    110            ];
%8/18 dataset - circuitry optimized onto 1 breadboard
data3iPhone = [272.31, 277.15, 320.65, 319.85,  48.34,  541.41];
%8/18 dataset - circuitry moved back to 2 breadboards
data4iPhone = [367.38, 273.93, 311.79, 307.76,  31.42, 1004.66];

% Reordered to match US* cases
%orig data1mm     = [274.8,  208.1,  274.1,  273.8,  15.1          ];
%WHY ONLY 5? NO 890.
ST1data1mm     = [NaN,  274.8,  NaN, NaN, NaN, 208.1,   NaN, 15.1  ];
%orig data2iPhone = [360,    260,    330,    270,    110           ];
ST1data2iPhone = [NaN, 360, NaN, NaN, NaN,    260,     NaN, 110    ];
%orig data3iPhone = [272.31, 277.15, 320.65, 319.85, 48.34, 541.41 ];
ST1data3iPhone = [NaN, 272.31, NaN, NaN, NaN, 277.15, 541.41, 48.34];
%orig data4iPhone = [367.38->6, 273.93->2, 311.79->x, 307.76->x, 31.42->8, 1004.66->7];
%transition data4iPhone = [0,  273.93->2, 0, 0, 0, 367.38->6, 1004.66->7, 31.42->8]; DON'T WANT TO PLOT 0s
ST1data4iPhone = [NaN,  273.93, NaN, NaN, NaN, 367.38, 1004.66, 31.42];

% ST1 plot
figure
% Vout
x = 1:1:8;
plot(x, ST1data1mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, ST1data2iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, ST1data3iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, ST1data4iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on
set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout vs supplied laser diode voltage, with V_R_B = 3V');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('ST1 dataset 1','ST1 dataset 2','ST1 dataset 3', ...
    'ST1 dataset 4', ...
    'Location','northwest');
title(lgd,'Legend')
%xlim([xMin xMax]); % without this, ST1 starts at x=2
%ylim([yMin yMax]);
%axes('Xlim', [xMin xMax], 'XTick', xMin:1:xMax);
ax = gca;
ax.XTick = unique( round(ax.XTick) );
% end of ST1

% start of US1
% 9/7 dataset: case 1: depth = 0 mm, offset = 0 mm
US1data0iPhone = [114,  64,    113,  95,  298,  190,  210, 128       ];
US1data1iPhone = [547,   52,   143, 152,  930,  241,  242, 213       ];
US1data2iPhone = [1217, 230,   274, 116,  554,  370,  100, 520       ];
% 9/13 REDO dataset: case 4: depth = 0 mm, offset = 3 mm
US1data3iPhone = [380,   76,   135,  22,  435,   50,  58,  64        ];
% 9/13 REDO dataset: case 5: depth = 0 mm, offset = 4 mm
US1data4iPhone = [470,   45,    83,  32,  830,   46, 144,  32        ];
US1data5iPhone = [940,   66,    71,  54,  630,   65, 120,  58        ];
% plot US1
figure
% Vout
x = 1:1:8;
plot(x, US1data0iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, US1data1iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, US1data2iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, US1data3iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on
plot(x, US1data4iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',ciel,...
    'MarkerFaceColor',green);
hold on
plot(x, US1data5iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',gold,...
    'MarkerFaceColor',blue);
hold on
set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout using u-shaped config and different setups');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('US1 offset 0', 'US1 offset 1', 'US1 offset 2', ...
    'US1 offset 3', 'US1 offset 4', 'US1 offset 5', ...
    'Location', 'northeast');
title(lgd,'Legend')
xlim([xMin xMax]);
ylim([yMin yMax]);
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
title(lgd,'Legend')
xlim([1 8]); % without this, ST1 starts at x=2
xlim([xMin xMax]);
ylim([yMin yMax]);
% end of US2

% start of US3
US3data1 = [ 1615., 60., 235., 0., 2478.,  93., 208., 10.];
US3data2 = [ 1673., 39., 124., 3., 2425., 116., 364.,  3.];
US3data3 = [ 1917., 68., 125., 3., 2495., 224., 444., 11.];
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
title(lgd,'Legend')
xlim([xMin xMax]);
ylim([yMin yMax]);
% end of US3

% stacked plot
% figure
% set(gca,'FontSize',20,'FontWeight','bold','box','off') % 2021/02/15
% newYlabels = {'ST1','US1','US2','US3'};
% y=[ST1data1mm(:); US1data0iPhone(:); US2data1(:); US3data1(:);];
% h = stackedplot(x, y', ...
%     'DisplayLabels', newYlabels, 'FontSize', 15);
% 
% hold on
% y=[ST1data2iPhone(:); US1data1iPhone(:); US2data2(:); US3data3(:);];
% h = stackedplot(x, y', ...
%     'DisplayLabels', newYlabels, 'FontSize', 15);

% subplots
fig = figure;
subplot(4,1,1);
x = 1:1:8;
plot(x, ST1data1mm,'-o','MarkerSize',10,'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, ST1data2iPhone,'-s','MarkerSize',10,'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, ST1data3iPhone,'-s','MarkerSize',10,'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, ST1data4iPhone,'-s','MarkerSize',10,'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on
%set(gca,'FontSize', myTextFont); % has no effect on tick label size
set(gca,'FontSize', myTextFont,'FontWeight','bold','box','off')
% title('Measured Vout vs supplied laser diode voltage, with V_R_B = 3V');
xlim([xMin xMax]);
ylim([yMin yMax]);

subplot(4,1,2); 
x = 1:1:8;
plot(x, US1data0iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, US1data1iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, US1data2iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, US1data3iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on
plot(x, US1data4iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',ciel,...
    'MarkerFaceColor',green);
hold on
plot(x, US1data5iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',gold,...
    'MarkerFaceColor',blue);
hold on
%set(gca,'FontSize', myTextFont); % has no effect on tick label size
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
xlim([xMin xMax]);
ylim([yMin yMax]);

subplot(4,1,3);
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
% set(gca,'FontSize', myTextFont); % has no effect on tick label size
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
xlim([xMin xMax]);
ylim([yMin yMax]);

subplot(4,1,4); 
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

% title('Measured Vout using u-shaped config and different setups');
% xlabel('Case number'); % x-axis label
%ylabel('Vout (mV)'); % y-axis label
% lgd = legend('US3 dataset 1', 'US3 dataset 2', 'US3 dataset 3', ...
%     'Location', 'northeast');
% title(lgd,'Legend')
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off');
xlim([xMin xMax]);
ylim([yMin yMax]);

han=axes(fig,'visible','off');
han.XLabel.Visible='on';
han.YLabel.Visible='on';
xlabel(han,'Case number');
ylabel(han,'Vout (mV)');
% ax = gca;
% ax.XTick = unique( round(ax.XTick) );
% han.XTick = unique( round(han.XTick) );
% curtick = get(gca, 'xTick');
% xticks(unique(round(curtick)));
a = axis;
axis([xMin xMax yMin yMax]);
set(gca, 'XTick', xMin:xMax)

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