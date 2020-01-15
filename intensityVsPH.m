
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];

myTextFont = 35; % was 55 for pub;

% Read off main plot at x=1430.19 cm^-1 for all y
%dataset 2019/01/31
y1 = [ 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5 7, 7.5 ];
x1 = [ 0.024543, 0.025863, 0.049305, 0.037095, 0.082391, 0.084093, 0.16251, 0.21508, 0.23708, 0.26556 ];
%dataset 2019/05/24
y2 = [ 3, 4, 5, 6, 7, 8, 9, 10 ];
x2 = [ 0.0738, 0.078871, 0.1488, 0.1283, 0.1921, 0.1921, 0.2434, 0.2488 ];
%dataset gel#12 2019/11/26
y3 = [ 4.57, 5.29, 8.87 ];
x3 = [ 0.081127, 0.24678, 0.28157];
%dataset gel #122019/11/29
y4 = [ 4.38, 4.76, 8.64 ];
x4 = [ 0.092353, 0.093542, 0.28159];
%dataset gel #12 2019/12/15
y5 = [ 4.41, 4.73, 8.03 ];
x5 = [ 0.09214, 0.09534, 0.27484 ];

figure
scatter(x1,y1,500,ciel,'filled');
hold on
scatter(x2,y2,500,black,'filled');
hold on
scatter(x3,y3,500,blue,'filled');
hold on
scatter(x4,y4,500,purple,'filled');
hold on
scatter(x5,y5,500,green,'filled');
title('');
ylabel('pH', 'FontSize', myTextFont); % x-axis label
xlabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
set(gca,'Xtick',0:0.1:0.3)
%set(gca,'XtickLabel',x(1:end))
y = 9.5; 
x = 0.01; 
deltaY = 1;
text(x, y, 'gel 4 (2019/1/31 age=1 month)', 'Color', ciel, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', ciel, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'gel 4 (2019/5/24 age=5 months)', 'Color', black, 'FontSize', myTextFont);
text(x, y, '______', 'Color', black, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'gel 12 (2019/12/15 age=1 month)', 'Color', green, 'FontSize', myTextFont);
text(x, y, '______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'gel 12 (2019/11/29 age=12 days)', 'Color', purple, 'FontSize', myTextFont);
text(x, y, '______', 'Color', purple, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'gel 12 (2019/11/26 age=9 days)', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '______', 'Color', blue, 'FontSize', myTextFont);
hold off

% Now plot the other way around
figure
scatter(y1,x1,500,ciel,'filled');
hold on
scatter(y2,x2,500,black,'filled');
hold on
scatter(y3,x3,500,blue,'filled');
hold on
scatter(y4,x4,500,purple,'filled');
hold on
scatter(y5,x5,500,green,'filled');
title('');
xlabel('pH', 'FontSize', myTextFont); % x-axis label
ylabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
set(gca,'Xtick',0:1:10)
%set(gca,'XtickLabel',x(1:end))
y = 0.3; 
x = 3.0; 
deltaY = 0.03;
text(x, y, 'gel 4 (2019/1/31 age=1 month)', 'Color', ciel, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', ciel, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'gel 4 (2019/5/24 age=5 months)', 'Color', black, 'FontSize', myTextFont);
text(x, y, '______', 'Color', black, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'gel 12 (2019/12/15 age=1 month)', 'Color', green, 'FontSize', myTextFont);
text(x, y, '______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'gel 12 (2019/11/29 age=12 days)', 'Color', purple, 'FontSize', myTextFont);
text(x, y, '______', 'Color', purple, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'gel 12 (2019/11/26 age=9 days)', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '______', 'Color', blue, 'FontSize', myTextFont);
hold off