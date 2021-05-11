% plot voltage across photodiode vs supplied laser diode power
% data from notebook 2021/04/30
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

data1 = [ 0.0, 0.361; 0.5, 0.361; 1.0, 0.361; 1.5, 0.361; 2.0, 0.361; ...
    2.5, 0.361; 3.0, 0.439; 3.1, 0.443; 3.2, 0.441; 3.3, 0.460; ...
    3.4, 0.463; 3.5, 0.460; 3.6, 0.470; 3.7, 0.472; 3.8, 0.475; ...
    3.9, 0.480; 4.0, 0.486; 4.1, 0.489; 4.2, 0.492; 4.3, 0.495; ...
    4.4, 0.499; 4.5, 0.496; 4.6, 0.488; 4.7, 0.481; 4.8, 0.484; ...
    4.9, 0.493; 5.0, 0.483 ];
data2 = [ 0.0, 0.361; 0.5, 0.361; 1.0, 0.361; 1.5, 0.361; 2.0, 0.361; ...
    2.5, 0.361; 3.0, 0.436; 3.1, 0.447; 3.2, 0.456; 3.3, 0.474; ...
    3.4, 0.454; 3.5, 0.467; 3.6, 0.462; 3.7, 0.480; 3.8, 0.476; ...
    3.9, 0.492; 4.0, 0.492; 4.1, 0.490; 4.2, 0.492; 4.3, 0.496; ...
    4.4, 0.496; 4.5, 0.500; 4.6, 0.500; 4.7, 0.503; 4.8, 0.505; ...
    4.9, 0.509; 5.0, 0.502 ];

plot(data1(:,1), data1(:,2),'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(data2(:,1), data2(:,2),'-o','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured photodiode (PD) voltage vs supplied laser diode voltage');
xlabel('Voltage supplied to laser diode (V)'); % x-axis label
ylabel('Voltage across PD (V)'); % y-axis label
legend('ambient light present','ambient light reduced','Location','southeast');
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