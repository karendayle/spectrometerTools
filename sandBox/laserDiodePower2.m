% plot laser power meter readings vs supplied 100 mW laser diode (new!) power
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

% dot pattern laser diode tip
data1 = [ 1.0, 0.063e-3; 1.1, 0.249e-3; 1.2, 0.130e-3; 1.3, 0.606e-3;...
    1.4, 2.32e-3; 1.5, 1.135e-3; 1.6, 2.42e-3; 1.7, 3.03e-3; ...
    1.8, 24.2e-3; 1.9, 60.3e-3; 2.0, 11.5; 2.0, 20.3; 2.1, 52.0; ...
    2.1, 48.3; 2.2, 37.7; 2.2, 56.5; 2.3, 62.8; 2.3, 63.2; 2.4 66.2; ...
    2.4, 65.6; 2.5, 65.6; 2.5, 65.7; 2.6, 66.0; 2.7, 66.5; 2.8, 65.6; ...
    2.9, 66.6; 3.0, 66.2; 3.0, 65.7 ];
plot(data1(:,1), data1(:,2),'o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
% line pattern laser diode tip
data2 = [ 1.0, 0.053e-3; 1.1, 0.041e-3; 1.2, 0.085-3; 1.3, 0.114e-3;...
    1.4, 0.86e-3; 1.5, 0.932e-3; 1.6, 1.36e-3; 1.7, 3.07e-3; ...
    1.8, 19.2e-3; 1.9, 40.1e-3; 2.0, 8.23; 2.1, 43.8; ...
    2.2, 56.1; 2.3, 58.4; 2.4 62.2; ...
    2.5, 63.6;  2.6, 64.1; 2.7, 64.7; 2.8, 63.; ...
    2.9, 63.8; 3.0, 64.0 ];
plot(data2(:,1), data2(:,2),'s','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
hold on
% cross pattern laser diode tip
data3 = [ 1.0, 0.985e-3; 1.1, 0.050e-3; 1.2, 0.34-3; 1.3, 0.4e-3;...
    1.4, 1.049e-3; 1.5, 1.57e-3; 1.6, 2.61e-3; 1.7, 3.55e-3; ...
    1.8, 22.4e-3; 1.9, 34.5e-3; 2.0, 10.27; 2.1, 38.1; ...
    2.2, 58.5; 2.3, 64.6; 2.4 69.5; ...
    2.5, 69.5;  2.6, 69.9; 2.7, 69.7; 2.8, 70.4; ...
    2.9, 70.3; 3.0, 70.4 ];
plot(data3(:,1), data3(:,2),'x','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured laser diode output power vs supplied voltage, with V_R_B = 9V');
xlabel('Voltage (V)'); % x-axis label
ylabel('Power (mW)'); % y-axis label
leg = legend('show');
title(leg,'Laser diode pattern')
legend('dot','line','cross','Location','southeast');

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