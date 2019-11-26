
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
green =   [0.4660, 0.6740, 0.1880];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];

myTextFont = 55;
figure
% Read off main plot at x=1430.19 cm^-1 for all y
y = [ 0.18573, 0.16502, 0.033594, 0.031751, 0.023905 ];
x = [ 0, 100, 200, 300. 400 ];
%scatter(x,y,'*','SizeData',100);
scatter(x(1),y(1),500,green,'filled');
hold on
scatter(x(2),y(2),500,gold,'filled');
scatter(x(3),y(3),500,rust,'filled');
scatter(x(4),y(4),500,red,'filled');
scatter(x(5),y(5),500,cherry,'filled');
title('');
xlabel('Glucose Concentration (mg/dL)', 'FontSize', myLabelFont); % x-axis label
ylabel('Normalized Intensity', 'FontSize', myLabelFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
set(gca,'Xtick',0:100:400)
set(gca,'XtickLabel',x(1:end))
hold off