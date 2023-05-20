blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];

close all;
plot(Wavelength(1:101), opto850BP(1:101), 'Color', ciel, 'LineWidth', 2)
hold on
plot(Wavelength(1:101), thor850BP(1:101), 'Color', rust, 'LineWidth', 2)
hold on
plot(Wavelength(1:101), thor850LL(1:101), 'Color', green, 'LineWidth', 2)
hold on
plot(Wavelength(1:101), thor860BP(1:101), 'Color', purple, 'LineWidth', 2)
hold on
plot(Wavelength(1:101), thor880BP(1:101), 'Color', blue, 'LineWidth', 2)
hold on
plot(Wavelength(1:101), thor890orig(1:101), 'Color', red, 'LineWidth', 2)
hold on
plot(Wavelength(1:101), thor890spare(1:101), 'Color', gold, 'LineWidth', 2)
hold on
plot(Wavelength(1:101), thor900(1:101), 'Color', black, 'LineWidth', 2)

myTextFont = 20;
title('');
xlabel('Wavelength (nm)', 'FontSize', myTextFont); % x-axis label
ylabel('Transmittance (%)', 'FontSize', myTextFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold') % want box,'box','off')
% set(gca,'Xtick',0:10:100)
% set(gca,'XtickLabel',Wavelength)

y = 80; 
x = 800; 
deltaY = 10;
text(x, y, 'opto850BP', 'Color', ciel, 'FontSize', myTextFont);
text(x, y, '_________', 'Color', ciel, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'thor850BP', 'Color', rust, 'FontSize', myTextFont);
text(x, y, '_________', 'Color', rust, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'thor850LL', 'Color', green, 'FontSize', myTextFont);
text(x, y, '_________', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'thor860BP', 'Color', purple, 'FontSize', myTextFont);
text(x, y, '_________', 'Color', purple, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'thor880BP', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '_________', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'thor890BP1', 'Color', red, 'FontSize', myTextFont);
text(x, y, '__________', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'thor890BP2', 'Color', gold, 'FontSize', myTextFont);
text(x, y, '__________', 'Color', gold, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'thor900BP', 'Color', black, 'FontSize', myTextFont);
text(x, y, '_________', 'Color', black, 'FontSize', myTextFont);
hold off
