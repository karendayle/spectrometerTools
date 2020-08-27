% RGB
global blue;
global rust;
global gold;
global purple;
global green;
global ciel;
global cherry;
global red;
global black;
global magenta;
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
% Use the colors to match the pH values (4=red, 7=green, 10=blue)
global myColor1;
global myColor2;
myColor1 = [ green; red; blue; green; blue; red; blue; green; red ];
myColor2 = [ gold; cherry; ciel; gold; ciel; cherry; ciel; gold; cherry ];
global markers;
% all the symbols that Matlab has:
% [ '-o' '-+' '-*' '-.' '-x' '-s' '-d' '-^' '-v' '->' '-<' '-p' '-h'];
markers = [ '-o'; '-^'; '-s']; 
global absValue
absValue = 0; % 0 = plot signed slope; 1 = plot absolute value of slope
myTitle = [ ...
    "Alginate", ...
    "PEG", ...
    "pHEMA", ...
    "pHEMA/coAc" ...
    ];

% Load the final values of both peaks for each segment of all time
% series
load('Data/speedVals.mat');
global speedVals

for i = 1:4
    plotSpeedVals(myTitle(i),i);
    calcTotalSlope(i);
end

function a = plotSpeedVals(theTitle,gel)
    global speedVals;
    global myColor1;
    global myColor2;
    global markers;
    global absValue;
    global black;
    
    figure    
    for punch = 1:3
        for segment = 1:9
            %index = ((gel-1)*3)+punch;
            value = speedVals(gel, punch, segment, 1);
            if absValue
                value = abs(value);
            end
            plot(segment, value, ...
                markers(punch,:), 'LineStyle','none', ...
                'MarkerSize', 30, ...
                'Color', myColor1(segment,:), 'linewidth', 2);
            hold on;
        end 
    end
    title(theTitle, 'FontSize', 30);
    xlabel('Segment of flow cell study', 'FontSize', 30);
    
    if absValue 
        ylim([0. 0.25]);
        ylabel('Abs val of slope of 1st 5 msmts of segment', 'FontSize', 30);
    else
        line([0,10],[0,0], 'Color', black);
        ylim([-0.25 0.25]);
        ylabel('Slope of 1st 5 msmts of segment', 'FontSize', 30);
    end
    xlim([0 10]);
    set(gca,'FontSize',30,'FontWeight','bold','box','off')
    a = 1;
end

function b = calcTotalSlope(gel)
    global speedVals
    pH4Segments = [2 6 9];
    pH7Segments = [1 4 8];
    pH10Segments = [3 5 7];
    
    sumPk1 = 0; sumPk1Ph4 = 0; sumPk1Ph7 = 0; sumPk1Ph10 = 0;
    sumPk2 = 0; sumPk2Ph4 = 0; sumPk2Ph7 = 0; sumPk2Ph10 = 0;
    fprintf('resetting sums to zero for gel %d\n', gel);
    for punch = 1:3
        for segment = 1:9
            if (segment == pH4Segments(1) || segment == pH4Segments(2) ...
                    || segment == pH4Segments(3))
                sumPk1Ph4 = sumPk1Ph4 + abs(speedVals(gel, punch, segment, 1));
                sumPk2Ph4 = sumPk2Ph4 + abs(speedVals(gel, punch, segment, 2));
            end
            if (segment == pH7Segments(1) || segment == pH7Segments(2) ...
                    || segment == pH7Segments(3))
                sumPk1Ph7 = sumPk1Ph7 + abs(speedVals(gel, punch, segment, 1));
                sumPk2Ph7 = sumPk2Ph7 + abs(speedVals(gel, punch, segment, 2));
            end
            if (segment == pH10Segments(1) || segment == pH10Segments(2) ...
                    || segment == pH10Segments(3))
                sumPk1Ph10 = sumPk1Ph10 + abs(speedVals(gel, punch, segment, 1));
                sumPk2Ph10 = sumPk2Ph10 + abs(speedVals(gel, punch, segment, 2));
            end
            sumPk1 = sumPk1 + abs(speedVals(gel, punch, segment, 1));
            sumPk2 = sumPk2 + abs(speedVals(gel, punch, segment, 2));
%             fprintf('adding %f to sum of peak 1 values\n', abs(speedVals(gel, punch, segment, 1))); 
%             fprintf('adding %f to sum of peak 2 values\n', abs(speedVals(gel, punch, segment, 2))); 
        end
    end
    fprintf('total for gel %d peak 1 is %f\n', gel, sumPk1);
    fprintf('    with components: pH4=%f, pH7=%f, pH10=%f\n', sumPk1Ph4, sumPk1Ph7, sumPk1Ph10);
    fprintf('total for gel %d peak 2 is %f\n', gel, sumPk2);
    fprintf('    with components: pH4=%f, pH7=%f, pH10=%f\n', sumPk2Ph4, sumPk2Ph7, sumPk2Ph10);
    b = 1;
end