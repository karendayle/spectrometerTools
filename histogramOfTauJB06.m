% Dayle Kotturi January 2021

%% kdk: Clear previous plots

close all

taus1430 = [];
taus1702 = [];
global tally
global tallyByGel
global autoSave
autosave = 0; % 1 to save plots to files, 0 to do this manually

% 0-1, 1-10, 10-100, 100-1000, >1000
tally = [0, 0, 0, 0, 0, 0; ... 
         0, 0, 0, 0, 0, 0]; 

for gel = 1:4 % all gel types
    for series = 1:3 % all series for each gel
        for K = 1:9 % all pH segments in each series
            tau1430 = 1.0/(vals(gel, series, K, 1, 4));
            addToTally(tau1430, 1);
            taus1430 = [taus1430; tau1430];

            tau1702 = 1/(vals(gel, series, K, 2, 4));
            taus1702 = [taus1702; tau1702];
            addToTally(tau1702, 2);
        end
    end
end

if autoSave
    FigH = figure('Position', get(0, 'Screensize'));
else
    figure
end
histogram(abs(taus1430), 1000);
title('Distribution of tau over gels, series and segments', 'FontSize', myTitleFont);
xlabel('Time (hours)', 'FontSize', myLabelFont); % x-axis label
ylabel('Number of time constants for 1430 cm-1 peak', 'FontSize', myLabelFont); % y-axis label
if autoSave
    saveMyPlot(FigH, 'taus for 1430 peak');
end

if autoSave
    FigH = figure('Position', get(0, 'Screensize'));
else
    figure
end
histogram(abs(taus1702), 1000);
title('Distribution of tau over gels, series and segments', 'FontSize', myTitleFont);
xlabel('Time (hours)', 'FontSize', myLabelFont); % x-axis label
ylabel('Number of time constants for 1702 cm-1 peak', 'FontSize', myLabelFont); % y-axis label
if autoSave
    saveMyPlot(FigH, 'taus for 1702 peak');
end

if autoSave
    FigH = figure('Position', get(0, 'Screensize'));
else
    figure
end
tallyGroups = [tally(1,1), tally(2,1); tally(1,2), tally(2,2); ...
    tally(1,3), tally(2,3); tally(1,4), tally(2,4); tally(1,5), ...
    tally(2,5); tally(1,6), tally(2,6);];
a = bar(tallyGroups, 'FaceColor','w');
fillBarsWithHatchedLines(a, tallyGroups);

title('Distribution of tau over gels, series and segments', 'FontSize', myTitleFont);
xlabel('Value of Tau (hr)', 'FontSize', myLabelFont); % x-axis label
ylabel('Number of time constants', 'FontSize', myLabelFont); % y-axis label
fname = {'<1';'<10';'<100';'<1000';'<10000';'>=10000'};
set(gca, 'XTick', 1:length(fname),'XTickLabel',fname);
set(gca, 'FontSize', 30,'FontWeight','bold','box','off');
if autoSave
    saveMyPlot(FigH, 'distribution of combined taus');
end

taus1 = [];
taus2 = [];
taus3 = [];
taus4 = [];
% 0-1, 1-10, 10-100, 100-1000, >1000
tallyByGel(:,:,1) = [0, 0, 0, 0, 0, 0; ... 
         0, 0, 0, 0, 0, 0; ...
         0, 0, 0, 0, 0, 0; ... 
         0, 0, 0, 0, 0, 0]; 
tallyByGel(:,:,2) = [0, 0, 0, 0, 0, 0; ... 
         0, 0, 0, 0, 0, 0; ...
         0, 0, 0, 0, 0, 0; ... 
         0, 0, 0, 0, 0, 0]; 
for gel = 1:4 % one gel at a time, the 1430 peak only
    for series = 1:3 % all series for each gel
        for K = 1:9 % all pH segments in each series
            switch gel
                case 1
                    tau = 1.0/(vals(gel, series, K, 1, 4));
                    addToTallyByGel(tau, gel, 1);
                    tau = 1.0/(vals(gel, series, K, 2, 4));
                    addToTallyByGel(tau, gel, 2);
%                     taus1 = [taus1; tau];
                case 2
                    tau = 1.0/(vals(gel, series, K, 1, 4));
                    addToTallyByGel(tau, gel, 1);
%                     taus2 = [taus2; tau];
                    tau = 1.0/(vals(gel, series, K, 2, 4));
                    addToTallyByGel(tau, gel, 2);
                case 3
                    tau = 1.0/(vals(gel, series, K, 1, 4));
                    addToTallyByGel(tau, gel, 1);
%                     taus3 = [taus3; tau];
                    tau = 1.0/(vals(gel, series, K, 2, 4));
                    addToTallyByGel(tau, gel, 2);
                case 4
                    tau = 1.0/(vals(gel, series, K, 1, 4));
                    addToTallyByGel(tau, gel, 1);
%                     taus4 = [taus4; tau];
                    tau = 1.0/(vals(gel, series, K, 2, 4));
                    addToTallyByGel(tau, gel, 2);
            end
        end
    end
    
    if autoSave
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    switch gel
        case 1
            myArray = tallyByGel(1,:,:);
            myArray = reshape(myArray,6,2);
            a = bar(myArray, 'FaceColor','w');
            fillBarsWithHatchedLines(a, myArray);
            title('Alginate: distribution of tau over series and segments', 'FontSize', myTitleFont);
        case 2
            myArray = tallyByGel(2,:,:);
            myArray = reshape(myArray,6,2);
            a = bar(myArray, 'FaceColor','w');
            fillBarsWithHatchedLines(a, myArray);
            title('PEG: distribution of tau over series and segments', 'FontSize', myTitleFont);
        case 3
            myArray = tallyByGel(3,:,:);
            myArray = reshape(myArray,6,2);
            a = bar(myArray, 'FaceColor','w');
            fillBarsWithHatchedLines(a, myArray);
            title('pHEMA: distribution of tau over series and segments', 'FontSize', myTitleFont);
        case 4
            myArray = tallyByGel(4,:,:);
            myArray = reshape(myArray,6,2);
            a = bar(myArray, 'FaceColor','w');
            fillBarsWithHatchedLines(a, myArray);
            title('pHEMA/coA: distribution of tau over series and segments', 'FontSize', myTitleFont);
    end
    xlabel('Value of Tau (hr)', 'FontSize', myLabelFont); % x-axis label
    ylabel('Number of time constants', 'FontSize', myLabelFont); % y-axis label
    fname = {'<1';'<10';'<100';'<1000';'<10000';'>=10000'};
    set(gca, 'XTick', 1:length(fname),'XTickLabel',fname);
    set(gca, 'FontSize', 30,'FontWeight','bold','box','off');
    myTitle = sprintf('taus for gel %d', gel);
    if autoSave
        saveMyPlot(FigH, myTitle);
    end
end
%end main portion

function a = addToTally(tau, row)
global tally;
    if tau < 1.0
        tally(row, 1) = tally(row, 1) + 1;
    else 
        if tau < 10.0
            tally(row, 2) = tally(row, 2) + 1;
        else
            if tau < 100.0
                tally(row, 3) = tally(row, 3) + 1;
            else
                if tau < 1000.0
                    tally(row, 4) = tally(row, 4) + 1;
                else
                    if tau < 10000.0
                        tally(row, 5) = tally(row, 5) + 1;
                    else
                        tally(row, 6) = tally(row, 6) + 1;
                    end
                end
            end
        end
    end                 
    a = 1;
end

function a = addToTallyByGel(tau, gel, peak)
global tallyByGel

    if tau < 1.0
        tallyByGel(gel, 1, peak) = tallyByGel(gel, 1, peak) + 1;
    else 
        if tau < 10.0
            tallyByGel(gel, 2, peak) = tallyByGel(gel, 2, peak) + 1;
        else
            if tau < 100.0
                tallyByGel(gel, 3, peak) = tallyByGel(gel, 3, peak) + 1;
            else
                if tau < 1000.0
                    tallyByGel(gel, 4, peak) = tallyByGel(gel, 4, peak) + 1;
                else
                    if tau < 10000.0
                        tallyByGel(gel, 5, peak) = tallyByGel(gel, 5, peak) + 1;
                    else
                        tallyByGel(gel, 6, peak) = tallyByGel(gel, 6, peak) + 1;
                    end
                end
            end
        end
    end                 
    a = 1;
end

function k = fillBarsWithHatchedLines(B, yd)
    bw = 0.23; % deduce by trial and error plotting over actual drawn bar

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