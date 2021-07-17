% plot output voltage after photodiode vs supplied laser diode power
% use 3 different load resistors
% data from notebook 2021/07/05
% for 20210706 SR
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
data1 = [ 0.0, 0.0, 0., (0.e-3*R_L); ...
    1.0, 3.9e-3, 0., (0.e-3*R_L); 2.0, 3.9e-3, 0., (0.e-3*R_L); ...
    2.5, 4.7e-3, 0., (0.e-3*R_L); 3.0, 2.4, 0.24, (0.24e-3*R_L); ...
    3.5, 5.91, 0.64, (0.64e-3*R_L); ...
    4.0, 5.99, 1.04, (1.04e-3*R_L); 4.5, 6.02, 1.46, (1.46e-3*R_L); ...
    5.0, 6.02, 1.47, (1.47e-3*R_L); 5.5, 6.02, 1.46, (1.46e-3*R_L); ...
    6.0, 6.02, 1.45, (1.45e-3*R_L) ];

% Vin, Vout, Iout, (Iout*R_L) using R_L = 100 kohm.
R_L = 100.e3;
data2 = [ 0.0, 4.6e-3, 0., (0.0e-3*R_L); 1.0, 4.7e-3, 0., (0.e-3*R_L); ...
    2.0, 4.6e-3, 0., (0.e-3*R_L); ...
    2.5, 10.4e-3, 0., (0.e-3*R_L); 3.0, 6.55, 0.29, (0.29e-3*R_L); ...
    3.5, 6.59, 0.71, (0.71e-3*R_L); ...
    4.0, 6.61, 1.11, (1.11e-3*R_L); 4.5, 6.63, 1.58, (1.58e-3*R_L); ...
    5.0, 6.63, 1.58, (1.58e-3*R_L); 5.5, 6.63, 1.58, (1.58e-3*R_L); ...
    6.0, 6.63, 1.56, (1.56e-3*R_L) ];

% Vin, Vout, Iout, (Iout*R_L) using R_L = 1 Mohm.
R_L = 1.e6;
data3 = [ 0.0, 45.3e-3, 0., (0.e-3*R_L); ...
    1.0, 46.2e-3, 0., (0.e-3*R_L); 2.0, 45.4e-3, 0., (0.e-3*R_L); ...
    2.5, 102.7e-3, 0., (0.e-3*R_L); 3.0, 6.61, 0.31, (0.31e-3*R_L); ...
    3.5, 6.66, 0.63, (0.63e-3*R_L); ...
    4.0, 6.68, 1.10, (1.10e-3*R_L); 4.5, 6.69, 1.47, (1.47e-3*R_L); ...
    5.0, 6.69, 1.46, (1.46e-3*R_L); 5.5, 6.69, 1.46, (1.46e-3*R_L); ...
    6.0, 6.69, 1.44, (1.44e-3*R_L) ];

figure
% Vout
plot(data1(:,1), data1(:,2),'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(data2(:,1), data2(:,2),'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6  1]);
hold on
plot(data3(:,1), data3(:,2),'-^','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured Vout vs supplied laser diode voltage, with V_R_B = 6V');
xlabel('Voltage supplied to laser diode (V)'); % x-axis label
ylabel('Vout (V)'); % y-axis label
legend('R_L = 10 kohm','R_L = 100 kohm', ...
    'R_L = 1 Mohm','Location','southeast');

% Iout
figure
plot(data1(:,1), data1(:,3),'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(data2(:,1), data2(:,3),'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(data3(:,1), data3(:,3),'-^','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
set(gca,'FontSize', myTextFont)
set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured output current vs supplied laser diode voltage, with V_R_B = 6V');
xlabel('Voltage supplied to laser diode (V)'); % x-axis label
ylabel('I_o_u_t (mA)'); % y-axis label
legend('R_L = 10 kohm','R_L = 100 kohm 1', ...
    'R_L = 1 Mohm','Location','southeast');

% Iout * R_L
figure
plot(data1(:,1), data1(:,4),'-o','MarkerSize',10,...
    'MarkerEdgeColor',red,...
    'MarkerFaceColor',[1 .6 .6]);
hold on
plot(data2(:,1), data2(:,4),'-s','MarkerSize',10,...
    'MarkerEdgeColor',blue,...
    'MarkerFaceColor',[.6 .6 1]);
hold on
plot(data3(:,1), data3(:,4),'-^','MarkerSize',10,...
    'MarkerEdgeColor',green,...
    'MarkerFaceColor',[.6 1 .6]);
set(gca,'FontSize', myTextFont); % has no effect on tick label size
title('Measured current * load resistor vs laser diode voltage, with V_R_B = 6V');
xlabel('Voltage supplied to laser diode (V)'); % x-axis label
ylabel('I_o_u_t * R_L (V)'); % y-axis label
legend('R_L = 10 kohm','R_L = 100 kohm 1', ...
    'R_L = 1 Mohm','Location','northwest');


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