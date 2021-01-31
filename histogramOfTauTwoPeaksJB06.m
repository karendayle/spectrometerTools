% Dayle Kotturi January 2021
% input=loads vals saved by plotRatiosOfTimeSeriesJB03
%% kdk: Clear previous plots
close all

% get the input
load ('Data\vals.mat');

global tallyByGel

global autoSave
autosave = 0; % CHOOSE 1 to save plots to files, 0 to do this manually

% 0-10m, 10m-1h, 1h-1d, >1d
% First row: the 1430 peaks
% Second row:  the 1702 peaks
tallyByGel = [ ...
         0, 0, 0, 0, ... % all gels (alg, PEG, pHEMA, pHE-coA) for bin #1
         0, 0, 0, 0, ... % all gels for bin #2
         0, 0, 0, 0, ... % all gels for bin #3
         0, 0, 0, 0; ...  % all gels for bin #4
         0, 0, 0, 0, ... % all gels for bin #1
         0, 0, 0, 0, ... % all gels for bin #2
         0, 0, 0, 0, ... % all gels for bin #3
         0, 0, 0, 0];    % all gels for bin #4

for gel = 1:4 % one gel at a time
    for series = 1:3 % all series for each gel
        for segment = 1:9 % all pH segments in each series
            tau = 1.0/(vals(gel, series, segment, 1, 4)); % 1430 peak
            addToTallyByGel(tau, gel, 1);
            tau = 1.0/(vals(gel, series, segment, 2, 4)); % 1702 peak
            addToTallyByGel(tau, gel, 2);
        end
    end
end

% set up one plot
if autoSave
    FigH = figure('Position', get(0, 'Screensize'));
else
    figure
end

for ii = 1:2
    myArray = tallyByGel(ii,:);
    myArray = reshape(myArray,4,4);
    % idea is to manually set the x coords for each peak
    % so that they appear interleaved. set breakpoint at hold on
    % to see the orer it gets drawn
    switch ii
        case 1
            myX = [1, 2, 3, 4; 6, 7, 8, 9; 11, 12, 13, 14; 16, 17, 18, 19];
        case 2
            myX = [1.5, 2.5, 3.5, 4.5; 6.5, 7.5, 8.5, 9.5; 11.5, 12.5, ...
                13.5, 14.5; 16.5, 17.5, 18.5, 19.5];
    end
                
    a = bar(myX, myArray, 'FaceColor','w');
    %fillBarsWithHatchedLines(a, myArray, ii);
    hold on;
end
myLabelFont = 30;
xlabel('Value of Tau (hr)', 'FontSize', myLabelFont); % x-axis label
ylabel('Number of time constants', 'FontSize', myLabelFont); % y-axis label
fname = {'<10m';'<1h';'<1d';'>1d'}; % FIX! 
set(gca, 'XTick', 1:length(fname),'XTickLabel',fname);
set(gca, 'FontSize', 30,'FontWeight','bold','box','off');
myTitle = sprintf('taus for both peaks');
if autoSave
    saveMyPlot(FigH, myTitle);
end
%end main portion

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
    offset = gel + (bin - 1) * 4; 
    tallyByGel(peak, offset) = tallyByGel(peak, offset) + 1;
    fprintf('peak%d bin%d gel%d tau=%f gets added to tally(%d,%d)\n', ...
    peak, bin, gel, tau, peak, offset);
    a = 1;
end

function k = fillBarsWithHatchedLines(B, yd, iter)
    bw = 0.15; % deduce by trial and error plotting over actual drawn bar

    % helpful: https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
    for ib = 1:numel(B)
        % important: xData is has the center pts of each bar of group 1 in
        % row 1 and the center pt of each bar of group 2 in row 2
        xData(:,ib) = B(ib).XData+B(ib).XOffset;
    end

    % Now generalize it in a loop
    [rows, cols] = size(yd);
    for i = 1:rows
        
        for j = 1:2:cols
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
            dy = 0.05 * max(yd(:,j)); % standardize on this for all bars based on max
            maxK = ceil(ymax/dy); 
            for k = 1:maxK
                switch iter
                    case 1
                        x1 = xData(i,j) - bw/4;
                        x2 = xData(i,j) + bw/4;
                    case 2
                        x1 = xData(i,j) - bw/4 + bw/2;
                        x2 = xData(i,j) + bw/4 + bw/2;
                end
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