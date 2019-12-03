
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];

myTextFont = 55;
figure
% Read off main plot at x=1430.19 cm^-1 for all y
y = [ 3, 4, 5, 6, 7, 8, 9, 10 ];
x = [ 0.0738, 0.1425, 0.1488, 0.1283, 0.1971, 0.1921, 0.2434, 0.2488 ];
%y_upperLim = [0.002097 0.004208 0.001858 0.002292 0.003534]; %read off aoomed in fig2
%y_lowerLim = [-0.002097 0.004208 -0.001858 -0.002292 -0.003534];
%scatter(x,y,'*','SizeData',100);
scatter(x(1),y(1),500,cherry,'filled');
hold on
scatter(x(2),y(2),500,red,'filled');
scatter(x(3),y(3),500,rust,'filled');
scatter(x(4),y(4),500,gold,'filled');
scatter(x(5),y(5),500,green,'filled');
scatter(x(6),y(6),500,ciel,'filled');
scatter(x(7),y(7),500,blue,'filled');
scatter(x(8),y(8),500,purple,'filled');

% plot stdDev as the array of error bars on the plot...    
%errorbar( x,y,y_upperLim, 'LineStyle','none', 'Color', black);

title('');
ylabel('pH', 'FontSize', myTextFont); % x-axis label
xlabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
set(gca,'Xtick',0:0.05:0.3)
set(gca,'XtickLabel',x(1:end))
hold off