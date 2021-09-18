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
myTextFont = 20;

% 9/7 dataset: case 1: depth = 0 mm, offset = 0 mm
data0mm     = [110,  44,     89,  71,  284,  143,  156,  72       ];
data0iPhone = [114,  64,    113,  95,  298,  190,  210, 128       ];

% 9/11 dataset: case 2: depth = 0 mm, offset = 1 mm
data1mm     = [525,  186,    40,  18,  882,   18,  35,  43         ];
data1iPhone = [547,   52,   143, 152,  930,  241, 242, 213         ];

% 9/11 dataset: case 3: depth = 0 mm, offset = 2 mm
data2mm     = [1140, 108,   158,  30,  168,   25,  13, 405         ];
data2iPhone = [1217, 230,   274, 116,  554,  370, 100, 520         ];

% 9/11 dataset: case 4: depth = 0 mm, offset = 3 mm
data3mm     = [749,   26,    50,  15,  255,   60, 566, 230         ];
data3iPhone = [903,  425,   180, 400,  380,  370, 780, 590         ];
% 9/13 REDO dataset: case 4: depth = 0 mm, offset = 3 mm
data3mm     = [365,   55,   112,   3,  422,   29,  35,  32         ];
data3iPhone = [380,   76,   135,  22,  435,   50,  58,  64         ];

% 9/11 dataset: case 5: depth = 0 mm, offset = 4 mm
data4mm     = [0,     11,    26,  14,  550,   40,  47,  12         ];
data4iPhone = [136,  700,   500, 550,  900,  470, 580, 390         ];
% 9/13 REDO dataset: case 4: depth = 0 mm, offset = 3 mm
data4mm     = [470,   24,    71,   7,  800,   24, 125,   9         ];
data4iPhone = [470,   45,    83,  32,  830,   46, 144,  32         ];

% 9/13 dataset: case 6: depth = 0 mm, offset = 5 mm
data5mm     = [140,   53,    64,  30,  620,   46, 100, 33          ];
data5iPhone = [940,   66,    71,  54,  630,   65, 120, 58          ];

figure
% Vout
x = 1:1:8;
plot(x, data0mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, data0iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(x, data1mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, data1iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
plot(x, data2mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, data2iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(x, data3mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on
plot(x, data3iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',purple,...
    'MarkerFaceColor',magenta);
hold on
plot(x, data4mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',ciel,...
    'MarkerFaceColor',green);
hold on
plot(x, data4iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',ciel,...
    'MarkerFaceColor',green);
hold on
plot(x, data5mm,'-o','MarkerSize',10,...
    'MarkerEdgeColor',gold,...
    'MarkerFaceColor',blue);
hold on
plot(x, data5iPhone,'-s','MarkerSize',10,...
    'MarkerEdgeColor',gold,...
    'MarkerFaceColor',blue);
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured Vout using u-shaped config and different setups');
xlabel('Subcase number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('0 mm MM','0 mm iP','1 mm MM','1 mm iP','2 mm MM','2 mm iP',...
    '3 mm MM','3 mm iP', '4 mm MM','4 mm iP','5 mm MM','5 mm iP',...
    'Location','northeast');
title(lgd,'Offset')

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