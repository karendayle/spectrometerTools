% plot output voltage after photodiode vs supplied laser diode power
% use V_RB = 3V and R_L = 10KOhm
% data from notebook 2021/07/08
% for 20210713 SR
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

% Vin (V), Vout (V), Iout (mA), (Iout*R_L) using R_L = 10 kohm. 
R_L = 10.e3;
data1 = [ 0.0, 12.5e-3, 0., (0.e-3*R_L); ...
    1.0, 12.3e-3, 0., (0.e-3*R_L); 2.0, 3.38, 3.43, (3.43e-3*R_L); ...
    2.5, 3.45, 3.47, (3.47e-3*R_L); 3.0, 3.44, 3.46, (3.46e-3*R_L); ...
    3.5, 3.44, 3.46, (3.46e-3*R_L); ...
    4.0, 3.44, 3.47, (3.47e-3*R_L); 4.5, 3.44, 3.47, (3.47e-3*R_L); ...
    5.0, 3.44, 3.46, (3.46e-3*R_L); 5.5, 3.44, 3.46, (3.46e-3*R_L); ...
    6.0, 3.44, 3.46, (3.46e-3*R_L) ];


figure
% Vout
plot(data1(:,1), data1(:,2),'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);

set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured Vout vs supplied laser diode voltage, with V_R_B = 3V');
xlabel('Voltage supplied to laser diode (V)'); % x-axis label
ylabel('Vout (V)'); % y-axis label
legend('R_L = 10 kohm','Location','southeast');

% Iout
figure
plot(data1(:,1), data1(:,3),'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);

set(gca,'FontSize', myTextFont)
set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured output current vs supplied laser diode voltage, with V_R_B = 3V');
xlabel('Voltage supplied to laser diode (V)'); % x-axis label
ylabel('I_o_u_t (mA)'); % y-axis label
legend('R_L = 10 kohm','Location','southeast');

% Iout * R_L
figure
plot(data1(:,1), data1(:,4),'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);

set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured current * load resistor vs laser diode voltage, with V_R_B = 3V');
xlabel('Voltage supplied to laser diode (V)'); % x-axis label
ylabel('I_o_u_t * R_L (V)'); % y-axis label
legend('R_L = 10 kohm','Location','northwest');


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