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
xMin = 1; % make this 6 to show only the common cases, 1 to show all 8
xMax = 8;
yMin = 0;
yMax = 3000; % make this 1200 when xMin is 6, 3000 when xMin is 1

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

[ST1avg,ST1stdDev] = getAverageAndStdDev(ST1data2iPhone, ST1data3iPhone, ST1data4iPhone);

% ST1 plot
figure %1
% Vout
x = 1:1:8;
% plot(x, ST1data1mm,'-o','MarkerSize',10,...
%     'MarkerEdgeColor',red,...
%     'MarkerFaceColor',[1 .6 .6]);
% hold on
% plot(x, ST1data2iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',green,...
%     'MarkerFaceColor',[.6 1 .6]);
% hold on
% plot(x, ST1data3iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',blue,...
%     'MarkerFaceColor',[.6 .6 1]);
% hold on
% plot(x, ST1data4iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',purple,...
%     'MarkerFaceColor',magenta);
% hold on
%NEW 9/21/2023
plot(x, ST1avg,'-s','MarkerSize',10,...
    'MarkerEdgeColor',black,...
    'MarkerFaceColor',black);
hold on
%errorbar(x,ST1avg(isfinite(ST1avg)),ST1stdDev,'Color',black); %unable to draw line when NaN
%values present
Num = length(ST1avg);
for i = 1 : Num
  data = ST1avg(i);
  good = not(isnan(data));
  if good 
      errorbar(x(i), data, ST1stdDev(i), '-s', 'Color',black);
      hold on;
  end
end
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout vs supplied laser diode voltage, with V_R_B = 3V');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
% lgd = legend('ST1 dataset 1','ST1 dataset 2','ST1 dataset 3', ...
%     'ST1 dataset 4', ...
%     'Location','northwest');
lgd = legend('ST1 avg dataset', ...
    'Location','northwest');
title(lgd,'Legend')
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
[US1avg,US1stdDev] = getAverageAndStdDev(US1data0iPhone, US1data1iPhone, US1data2iPhone);

% plot US1
figure %2
% Vout
x = 1:1:8;
% plot(x, US1data0iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',red,...
%     'MarkerFaceColor',[1 .6 .6]);
% hold on
% plot(x, US1data1iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',green,...
%     'MarkerFaceColor',[.6 1 .6]);
% hold on
% plot(x, US1data2iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',blue,...
%     'MarkerFaceColor',[.6 .6 1]);
% hold on
% plot(x, US1data3iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',purple,...
%     'MarkerFaceColor',magenta);
% hold on
% plot(x, US1data4iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',ciel,...
%     'MarkerFaceColor',green);
% hold on
% plot(x, US1data5iPhone,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',gold,...
%     'MarkerFaceColor',blue);
% hold on
%NEW 9/21/2023
plot(x, US1avg,'-s','MarkerSize',10,...
    'MarkerEdgeColor',black,...
    'MarkerFaceColor',black);
hold on
%errorbar(x,US1avg(isfinite(US1avg)),US1stdDev,'Color',black); %unable to draw line when NaN
%values present
Num = length(US1avg);
for i = 1 : Num
  data = US1avg(i);
  good = not(isnan(data));
  if good 
      errorbar(x(i), data, US1stdDev(i), '-s', 'Color',black);
      hold on;
  end
end
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout using u-shaped config and different setups');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('US1 offset 0', 'US1 offset 1', 'US1 offset 2', ...
    'US1 offset 3', 'US1 offset 4', 'US1 offset 5', ...
    'Location', 'northeast');
title(lgd,'Legend')
set(gca,'box','off');
ax = gca; % current axes
ax.FontSize = myTextFont;
ax.FontWeight = 'bold';
% ax.TickDir = 'out';
% ax.TickLength = [0.02 0.02];
ax.XLim = [xMin xMax];
ax.YLim = [yMin yMax];
ax.XTick = xMin:1:xMax;
% ax.XTick = unique( round(ax.XTick) ); ALTERNATE APPROACH
% end of US1

% start of US2 (get values from table 5-5)
US2data1 = [ 2049., 60., 135. 3., 1910., 262., 224., 10. ];
US2data2 = [ 1275., 97., 170., 2., 2546., 893., 837., 6.];
US2data3 = [ 2002., 100., 315., 4., 2527., 545., 417., 6. ];
[US2avg,US2stdDev] = getAverageAndStdDev(US2data1, US2data2, US2data3);

% plot US2
figure %3
% Vout
x = 1:1:8;
% plot(x, US2data1,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',red,...
%     'MarkerFaceColor',[1 .6 .6]);
% hold on
% plot(x, US2data2,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',green,...
%     'MarkerFaceColor',[.6 1 .6]);
% hold on
% plot(x, US2data3,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',blue,...
%     'MarkerFaceColor',[.6 .6 1]);
% hold on
%NEW 9/21/2023
plot(x, US2avg,'-s','MarkerSize',10,...
    'MarkerEdgeColor',black,...
    'MarkerFaceColor',black);
hold on
%errorbar(x,US2avg(isfinite(US2avg)),US2stdDev,'Color',black); %unable to draw line when NaN
%values present
Num = length(US2avg);
for i = 1 : Num
  data = US2avg(i);
  good = not(isnan(data));
  if good 
      errorbar(x(i), data, US2stdDev(i), '-s', 'Color',black);
      hold on;
  end
end
hold on

set(gca,'FontSize', myTextFont); % has no effect on tick label size
% title('Measured Vout using u-shaped config and different setups');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('US2 dataset 1', 'US2 dataset 2', 'US2 dataset 3', ...
    'Location', 'northeast');
title(lgd,'Legend')
set(gca,'box','off');
ax = gca; % current axes
ax.FontSize = myTextFont;
ax.FontWeight = 'bold';
% ax.TickDir = 'out';
% ax.TickLength = [0.02 0.02];
ax.XLim = [xMin xMax];
ax.YLim = [yMin yMax];
ax.XTick = xMin:1:xMax;
% ax.XTick = unique( round(ax.XTick) ); ALTERNATE APPROACH
% end of US2

% start of US3
US3data1 = [ 1615., 60., 235., 0., 2478.,  93., 208., 10.];
US3data2 = [ 1673., 39., 124., 3., 2425., 116., 364.,  3.];
US3data3 = [ 1917., 68., 125., 3., 2495., 224., 444., 11.];
[US3avg,US3stdDev] = getAverageAndStdDev(US3data1, US3data2, US3data3);

% plot US3
figure %4
% Vout
x = 1:1:8;
% plot(x, US3data1,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',red,...
%     'MarkerFaceColor',[1 .6 .6]);
% hold on
% plot(x, US3data2,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',green,...
%     'MarkerFaceColor',[.6 1 .6]);
% hold on
% plot(x, US3data3,'-s','MarkerSize',10,...
%     'MarkerEdgeColor',blue,...
%     'MarkerFaceColor',[.6 .6 1]);
% hold on
%NEW 9/21/2023
plot(x, US3avg,'-s','MarkerSize',10,...
    'MarkerEdgeColor',black,...
    'MarkerFaceColor',black);
hold on
%errorbar(x,US3avg(isfinite(US3avg)),US3stdDev,'Color',black); %unable to draw line when NaN
%values present
Num = length(US3avg);
for i = 1 : Num
  data = US3avg(i);
  good = not(isnan(data));
  if good 
      errorbar(x(i),data,US3stdDev(i),'-s','Color',blue);
      hold on;
  end
end
hold on

% title('Measured Vout using u-shaped config and different setups');
xlabel('Case number'); % x-axis label
ylabel('Vout (mV)'); % y-axis label
lgd = legend('US3 dataset 1', 'US3 dataset 2', 'US3 dataset 3', ...
    'Location', 'northeast');
title(lgd,'Legend')
set(gca,'box','off');
ax = gca; % current axes
ax.FontSize = myTextFont;
ax.FontWeight = 'bold';
% ax.TickDir = 'out';
% ax.TickLength = [0.02 0.02];
ax.XLim = [xMin xMax];
ax.YLim = [yMin yMax];
ax.XTick = xMin:1:xMax;
% ax.XTick = unique( round(ax.XTick) ); ALTERNATE APPROACH
% end of US3

% 4 subplots ST1, US1, US2, US3 in one figure
fig = figure; %5
subplot(4,1,1);
x = 1:1:8;
%NEW 9/21/2023
plot(x, ST1avg,'-s','MarkerSize',5,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',blue);
hold on
%errorbar(x,ST1avg(isfinite(ST1avg)),ST1stdDev,'Color',black); %unable to draw line when NaN
%values present
Num = length(ST1avg);
for i = 1 : Num
  data = ST1avg(i);
  good = not(isnan(data));
  if good 
      errorbar(x(i),data,ST1stdDev(i),'-s','Color',blue);
      hold on;
  end
end
hold on
set(gca,'box','off');
ax = gca; % current axes
ax.FontSize = myTextFont;
ax.FontWeight = 'bold';
% ax.TickDir = 'out';
% ax.TickLength = [0.02 0.02];
ax.XLim = [xMin xMax];
ax.YLim = [yMin yMax];
ax.XTick = xMin:1:xMax;

% Evaluate success
good1 = not(isnan(ST1avg(6)));
good2 = not(isnan(ST1avg(7)));
good3 = not(isnan(ST1avg(8)));
if good1 && good2 && good3 
    refPeakMagTest(1) = abs(ST1avg(6)-ST1avg(7))/ST1avg(6)
    zeroPeakTest(1) = ST1avg(8)
    refPeak1Above10xNoise(1) = ST1avg(6)
    refPeak2Above10xNoise(1) = ST1avg(7)
end

subplot(4,1,2); 
x = 1:1:8;
%NEW 9/21/2023
plot(x, US1avg,'-s','MarkerSize',5,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',blue);
hold on
%errorbar(x,US1avg(isfinite(US1avg)),US1stdDev,'Color',black); %unable to draw line when NaN
%values present
Num = length(US1avg);
for i = 1 : Num
  data = US1avg(i);
  good = not(isnan(data));
  if good 
      errorbar(x(i),data,US1stdDev(i),'-s','Color',blue);
      hold on;
  end
end
hold on
set(gca,'box','off');
ax = gca; % current axes
ax.FontSize = myTextFont;
ax.FontWeight = 'bold';
% ax.TickDir = 'out';
% ax.TickLength = [0.02 0.02];
ax.XLim = [xMin xMax];
ax.YLim = [yMin yMax];
ax.XTick = xMin:1:xMax;

% Evaluate success
% good1 = not(isnan(US1avg(6)));
% good2 = not(isnan(US1avg(7)));
% good3 = not(isnan(US1avg(8)));
% if good1 && good2 && good3 
%     refPeakMagTest(2) = abs(US1avg(6)-US1avg(7))/US1avg(6)
%     zeroPeakTest(2) = US1avg(8)
%     refPeak1Above10xNoise(2) = US1avg(6)
%     refPeak2Above10xNoise(2) = US1avg(7)
% end

% Evaluate success using only 0-mm offset dataset
good1 = not(isnan(US1data0iPhone(6)));
good2 = not(isnan(US1data0iPhone(7)));
good3 = not(isnan(US1data0iPhone(8)));
if good1 && good2 && good3 
    refPeakMagTest(2) = abs(US1data0iPhone(6)-US1data0iPhone(7))/US1data0iPhone(6)
    zeroPeakTest(2) = US1data0iPhone(8)
    refPeak1Above10xNoise(2) = US1data0iPhone(6)
    refPeak2Above10xNoise(2) = US1data0iPhone(7)
end

subplot(4,1,3);
x = 1:1:8;
%NEW 9/21/2023
plot(x, US2avg,'-s','MarkerSize',5,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',blue);
hold on
%errorbar(x,US2avg(isfinite(US2avg)),US2stdDev,'Color',black); %unable to draw line when NaN
%values present
Num = length(US2avg);
for i = 1 : Num
  data = US2avg(i);
  good = not(isnan(data));
  if good 
      errorbar(x(i),data,US2stdDev(i),'-s','Color',blue);
      hold on;
  end
end
hold on
set(gca,'box','off');
ax = gca; % current axes
ax.FontSize = myTextFont;
ax.FontWeight = 'bold';
% ax.TickDir = 'out';
% ax.TickLength = [0.02 0.02];
ax.XLim = [xMin xMax];
ax.YLim = [yMin yMax];
ax.XTick = xMin:1:xMax;

% Evaluate success
good1 = not(isnan(US2avg(6)));
good2 = not(isnan(US2avg(7)));
good3 = not(isnan(US2avg(8)));
if good1 && good2 && good3 
    refPeakMagTest(3) = abs(US2avg(6)-US2avg(7))/US2avg(6)
    zeroPeakTest(3) = US2avg(8)
    refPeak1Above10xNoise(3) = US2avg(6)
    refPeak2Above10xNoise(3) = US2avg(7)
end

subplot(4,1,4); 
x = 1:1:8;
%NEW 9/21/2023
plot(x, US3avg,'-s','MarkerSize',5,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',blue);
hold on
%errorbar(x,US3avg(isfinite(US3avg)),US3stdDev,'Color',black); %unable to draw line when NaN
%values present
Num = length(US3avg);
for i = 1 : Num
  data = US3avg(i);
  good = not(isnan(data));
  if good 
      errorbar(x(i),data,US3stdDev(i),'-s','Color',blue);
      hold on;
  end
end
hold on
set(gca,'box','off');
ax = gca; % current axes
ax.FontSize = myTextFont;
ax.FontWeight = 'bold';
% ax.TickDir = 'out';
% ax.TickLength = [0.02 0.02];
ax.XLim = [xMin xMax];
ax.YLim = [yMin yMax];
ax.XTick = xMin:1:xMax;

% Evaluate success
good1 = not(isnan(US3avg(6)));
good2 = not(isnan(US3avg(7)));
good3 = not(isnan(US3avg(8)));
if good1 && good2 && good3 
    refPeakMagTest(4) = abs(US3avg(6)-US3avg(7))/US3avg(6)
    zeroPeakTest(4) = US3avg(8)
    refPeak1Above10xNoise(4) = US3avg(6)
    refPeak2Above10xNoise(4) = US3avg(7)
end


% Set up the global labels (one for all the subplots)
han=axes(fig,'visible','off');
han.XLabel.Visible='on';
han.YLabel.Visible='on';
han.FontSize = myTextFont;
han.FontWeight = 'bold';
xlabel(han,'Case number');
ylabel(han,'Vout (mV)');

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

function [ myAvg, myStdDev ] = getAverageAndStdDev(dataPoints1, dataPoints2, dataPoints3)
    % 9/21/2023 Important - we are calculating the average and std dev 
    % across the datasets, not along the arrays of points. 
    % i.e., the output is an array of averages and std dev of each
    % point in the arrays
    numDatasets = 3;
    %Pass in 3 arrays of points
    myN = length(dataPoints1);
        % calculate averages
    for I = 1:myN
        myAvg(I) = (dataPoints1(I) + dataPoints2(I)+ dataPoints3(I))/numDatasets;
    end

    % second pass on dataset to get (each point - average)^2
    % for standard deviation, need 
    for I = 1:myN
        % 4. Add to the sum of the squares
        mySumSq(I) = ((dataPoints1(I) - myAvg(I))^2) + ...
        ((dataPoints2(I) - myAvg(I))^2) + ... 
        ((dataPoints3(I) - myAvg(I))^2); 
        % 5. Compute standard deviation at each index of the averaged spectra 
        myStdDev(I) = sqrt(mySumSq(I)/numDatasets);
    end
end