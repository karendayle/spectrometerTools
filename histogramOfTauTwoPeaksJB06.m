% Dayle Kotturi January 2021
% input=loads vals saved by plotRatiosOfTimeSeriesJB03
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
teal =    [0.2, 0.6, 0.5];

%% kdk: Clear previous plots
close all

% get the input
load ('Data\vals.mat');

global tallyByGel

global autoSave
autoSave = 1; % CHOOSE 1 to save plots to files, 0 to do this manually

% Bins are: 0-10m, 10m-1h, 1h-1d, >1d
tallyByGel = [ ...
    0, 0, 0, 0, 0, 0, 0, 0; % bin1, all gels, 2 pks each
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0 ];

for gel = 1:4 % one gel at a time
    for series = 1:3 % all series for each gel
        for segment = 1:9 % all pH segments in each series
            tau = 1.0/(vals(gel, series, segment, 1, 4)); % 1430 peak
            addToTallyByGel(tau, gel, 1);
            addToTallyByPH(tau, gel, getPHValue(segment), 1);
            tau = 1.0/(vals(gel, series, segment, 2, 4)); % 1702 peak
            addToTallyByGel(tau, gel, 2);
            addToTallyByPH(tau, gel, getPHValue(segment), 2);
        end
    end
end

% set up one plot
if autoSave
    FigH = figure('Position', get(0, 'Screensize'));
else
    figure
end

myArray = reshape(tallyByGel,4,8);
% This is the trick to get the groupings correct
myX = [1, 1, 1, 1, 1, 1, 1, 1; ...
    2, 2, 2, 2, 2, 2, 2, 2; ...
    3, 3, 3, 3, 3, 3, 3, 3; ...
    4, 4, 4, 4, 4, 4, 4, 4];

%OLD a = bar(myX, myArray, 'FaceColor','w');
% THIS COLORS EACH BAR DIFFERENTLY a = bar(myX, myArray);
a = bar(myX, myArray);
% color by gel
a(1).FaceColor = gold; % alginate
a(2).FaceColor = gold;
a(3).FaceColor = teal; % PEG
a(4).FaceColor = teal;
a(5).FaceColor = rust; % pHEMA
a(6).FaceColor = rust;
a(7).FaceColor = blue; % pHEMA/coA
a(8).FaceColor = blue;
% want all the 1702 peaks to have the hatched lines
fillBarsWithHatchedLines(a, myArray); 

myLabelFont = 30;
xlabel('Time constant, tau', 'FontSize', myLabelFont); % x-axis label
ylabel('Number of time constants', 'FontSize', myLabelFont); % y-axis label
fname = {'<10 min';'<1 hour';'<1 day';'>1 day'}; % FIX! 
set(gca, 'XTick', 1:length(fname),'XTickLabel',fname);
set(gca, 'FontSize', 30,'FontWeight','bold','box','off');
myTitle = sprintf('taus for both peaks');
if autoSave
    saveMyPlot(FigH, myTitle);
end
%end main portion

% determine bin# from tau
function a = addToTallyByGel(tau, gel, peak)
    global tallyByGel
    
    if tau < (1.0/6.0)
        bin = 1;
    else 
        if tau < 1.0
            bin = 2;
        else
            if tau < 24.0
                bin = 3;
            else
                bin = 4;
            end
        end
    end 
    % OLD: offset = gel + (bin - 1) * 4; 
    % OLD: tallyByGel(peak, offset) = tallyByGel(peak, offset) + 1;
    % 2021/02/01
    offset = (gel - 1) * 2 + peak; 
    tallyByGel(bin, offset) = tallyByGel(bin, offset) + 1;
    fprintf('bin%d gel%d peak%d tau=%f gets added to tally(%d,%d)\n', ...
    bin, gel, peak, tau, bin, offset);
    a = 1;
end

function b = getPHValue(segment)
    switch segment
        case { 2, 6, 9 }
            pHValue = 4;
        case { 1, 4, 8 }
            pHValue = 7;
        case { 3, 5, 7 }
            pHValue = 10;
    end
    b = pHValue;
end

function c = addToTallyByPH(tau, gel, pHValue, peak)
% START HERE
    c = 1;
end

function k = fillBarsWithHatchedLines(B, yd)
    bw = 0.08; % deduce by trial and error plotting over actual drawn bar
    
    % helpful: https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
    for ib = 1:numel(B)
        % important: xData is has the center pts of each bar of group 1 in
        % row 1 and the center pt of each bar of group 2 in row 2
        xData(:,ib) = B(ib).XData+B(ib).XOffset;
        [rows, cols] = size(xData);
        fprintf('rows %d cols %d\n', rows, cols);
    end

    % Now generalize it in a loop
    [rows, cols] = size(yd);
    for i = 1:rows
        for j = 2:2:cols
            % draw the slanted lines that go all the way across
            y1 = 0; 
            y2 = 0;
            ymax = yd(i,j); 
            fprintf('row %d, col %d: %f', i, j, ymax);
            % this is the only "weakpoint". The dy depends on ymax value,
            % so the hatchline spacing will vary across bars. This could be
            % changed by using same dy for all bars, but the range of k needs
            % to change as well
            %dy = (ymax - y1)/10;
            %fprintf('dy is %f', dy);
            %dy = 0.004; % standardize on this for all bars
            dy = 0.025 * max(yd(:,j)); % standardize on this for all bars based on max
            maxK = ceil(ymax/dy); 
            for k = 1:maxK
                x1 = xData(i,j) - bw/2;
                x2 = xData(i,j) + bw/2;
                y2 = y2 + dy;
                % don't draw a line that exceeds ymax
                % use eqn of a line to find a new x2
                if (y2 > ymax)
                    m = dy/bw;
                    b = y1 - m*x1;
                    y2 = ymax;
                    x2 = (y2 - b)/m;
                end
                fprintf ('%d-%d.%d bw=%f x1=%f x2=%f y1=%f y2=%f\n', i, j, k, bw, x1, x2, y1, y2);
                line([x1 x2], [y1 y2],'linewidth',1,'color','k');
                y1 = y1 + dy;
            end
        end
    end
    k = 1;
end

function g = saveMyPlot(FigH, myTitle)
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlotName = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlotName, 'jpg');
    g = 1;
end