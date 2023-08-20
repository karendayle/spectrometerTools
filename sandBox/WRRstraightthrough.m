% plot WRR photodiode's output voltage vs test case for all datasets
% for 20210901 SR
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

% 8/4 dataset
data1mm     = [274.8,  541,     208.1,  274.1,  273.8,  15.1          ];

% 8/17 dataset
data2mm     = [336.1,  3680,    244.4,  307.4,  267.0,  94.5          ];
data2iPhone = [360,    3300,    260,    330,    270,    110           ];

%8/18 dataset - circuitry optimized onto 1 breadboard
data3mm     = [248.1,  3413,    241.5,  289.7,  289.3,  16.2,  509];
data3iPhone = [272.31, 3299.19, 277.15, 320.65, 319.85, 48.34, 541.41 ];

%8/18 dataset - circuitry moved back to 2 breadboards
data4mm     = [359.3,  3345,    257.5,  295.3,  293.8,  18.2,  1002    ];
data4iPhone = [367.38, 3299.19, 273.93, 311.79, 307.76, 31.42, 1004.66];

figure
% Vout
x = 1:1:6;
plot(x, data1mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, data2mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, data2iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
x = 1:1:7;
plot(x, data3mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, data3iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, data4mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on
plot(x, data4iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout vs supplied laser diode voltage, with V_R_B = 3V');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('1','2','3','4','5','6','7','Location','northwest');
title(lgd,'Dataset')

% REPEAT without 2nd value to improve resolution
% 8/4 dataset
data1mm     = [274.8,  208.1,  274.1,  273.8,  15.1          ];

% 8/17 dataset
data2mm     = [336.1,  244.4,  307.4,  267.0,  94.5          ];
data2iPhone = [360,    260,    330,    270,    110           ];

%8/18 dataset - circuitry optimized onto 1 breadboard
data3mm     = [248.1,  241.5,  289.7,  289.3,  16.2,  509];
data3iPhone = [272.31, 277.15, 320.65, 319.85, 48.34, 541.41 ];

%8/18 dataset - circuitry moved back to 2 breadboards
data4mm     = [359.3,  257.5,  295.3,  293.8,  18.2,  1002    ];
data4iPhone = [367.38, 273.93, 311.79, 307.76, 31.42, 1004.66];

figure
% Vout
x = 1:1:5;
plot(x, data1mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, data2mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, data2iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
x = 1:1:6;
plot(x, data3mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, data3iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, data4mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on
plot(x, data4iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout vs supplied laser diode voltage, with V_R_B = 3V');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('1','2','3','4','5','6','7','Location','northwest');
title(lgd,'Dataset')

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