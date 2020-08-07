% RGB
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
punchColor = [ red; cherry; magenta; black; rust; gold; green; ciel ];
pHLabel = [ 'pH4.0'; 'pH4.5'; 'pH5.0'; 'pH5.5'; 'pH6.0'; 'pH6.5'; 'pH7.0'; 'pH7.5' ];

load('myAlgY1AllPunches.mat');
figure
for i = 1:8
    line([0,9],[myAlgY1allPunches(i),myAlgY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(7.5,myAlgY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
end
title('alginate steady state targets for 1430cm-1');
xlabel('pH buffer segment', 'FontSize', 30);
ylabel('Normalized Intensity', 'FontSize', 30);

% repeat for 3 other gels types
load('myPEGY1AllPunches.mat');
figure
for i = 1:8
    line([0,9],[myPEGY1allPunches(i),myPEGY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(7.5,myPEGY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
end
title('PEG steady state targets for 1430cm-1');
xlabel('pH buffer segment', 'FontSize', 30);
ylabel('Normalized Intensity', 'FontSize', 30);
load('myHEMAY1AllPunches.mat');
figure
for i = 1:8
    line([0,9],[myHEMAY1allPunches(i),myHEMAY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(7.5,myHEMAY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
end
title('HEMA steady state targets for 1430cm-1');
xlabel('pH buffer segment', 'FontSize', 30);
ylabel('Normalized Intensity', 'FontSize', 30);

load('myHEMACoY1AllPunches.mat');
figure
for i = 1:8
    line([0,9],[myHEMACoY1allPunches(i),myHEMACoY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(7.5,myHEMACoY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
end
title('HEMACo steady state targets for 1430cm-1');
xlabel('pH buffer segment', 'FontSize', 30);
ylabel('Normalized Intensity', 'FontSize', 30);