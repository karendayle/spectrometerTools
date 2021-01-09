% Initial version: Plot the intensity at a single wavenumber normalized by the reference 
% intensity vs time by extracting it from a set of files in different directories
% The time to use for the x axis is in the filename as
% avg-yyyy-mm-dd-mm-ss.txt. Convert this to seconds since epoch.

% Modified version:
% 1) compare transition speeds based on slopes 
% 2) extract final value for each segment for comparison across samples,
%    across gel types and to compare to values in static buffer
% 3) MJM doesn't like slope value as measure of transition speed, he wants
%    time constants. Also, no need to distinguish the between the 3 time series 
%    for each samples gel type. Combine them and plot all gel types on same plot.

% Dayle Kotturi August 2020

% There are two plots to build (or two lines on one plot).
% Use the index 614 to get the intensity at 1430/cm (act. 1428.58/cm)
% NEW 11/06/2018 find the local max instead of looking at const location
global x1Min;
global x1Max;
x1Min = 591;
x1Max = 615;
% Use the index 794 to get the intensity at 1702/cm (act. 1701.95/cm)
% NEW 11/06/2018 find the local max instead of looking at const location
global x2Min;
global x2Max;
x2Min = 790;
x2Max = 797;

% IMPORTANT: This is index to reference peak. 
% No, it is not only this value that is used. Rather it is an integration
% around this point that is used for the denominator that normalizes
global xRef;
xRef = 713; % COO- at 1582
            % TO DO: read from avg*.txt file
% Colors:
global blue;
global rust;
global gold;
global purple;
global green;
global ciel; 
global cherry;
global red;
global black;
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];
pHcolor = [0.0, 0.0, 0.0];

global numPoints;
numPoints = 1024;

global nPoints;
global lastPoints;

global lineThickness;
lineThickness = 2;

global myDebug;
myDebug = 0;

% subtract this offset to start x axis at zero
global tRef;

%global ss; % NEW 2020/2/25
%ss=zeros(4,3,9,2);  % keep track of last norm'd ratio for 
                    % both peaks, for all segs, for all gels
global myTitleFont;
global myLabelFont;
global myTextFont;
myTitleFont = 30;
myLabelFont = 30; 
myTextFont = 30; 

global plotOption;
%plotOption = 1; % plot y1 and y2. 20200805: extract last val of each segment
%plotOption = 2; % plot y3
%plotOption = 3; % check pH sens
plotOption = 4; % do curve fitting. Set value for lastPoints (line ~510) to
% adjust how many points at the end of the segment are used

global dirStem;

global vals; % a multi dimensional array to hold the curve fitting results
global endVals; % a multi dim'l array to hold the endpts of all segments
global speedVals; % a multi dim'l array to hold the initial slopes of 
                  % each segment

global myTitle;
myTitle = [ ...
    "54nm MBA AuNPs MCs alginate gel12 punch1 flowcell", ...
    "54nm MBA AuNPs MCs alginate gel12 punch2 flowcell", ...
    "54nm MBA AuNPs MCs alginate gel12 punch3 flowcell", ...
    "54nm MBA AuNPs MCs PEG gel3 punch1 flowcell", ...
    "54nm MBA AuNPs MCs PEG gel15 punch1 flowcell", ...
    "54nm MBA AuNPs MCs PEG gel16 punch1 flowcell", ...
    "54nm MBA AuNPs MCs pHEMA gel1 punch1 flowcell", ...
    "54nm MBA AuNPs MCs pHEMA gel13 punch1 flowcell", ...
    "54nm MBA AuNPs MCs pHEMA gel13 punch2 flowcell", ...
    "54nm MBA AuNPs MCs pHEMA coAc gel3 punch4 flowcell", ...
    "54nm MBA AuNPs MCs pHEMA coAc gel14 punch1 flowcell", ...
    "54nm MBA AuNPs MCs pHEMA coAc gel14 punch2 flowcell" ...
    ];
subDirStem1 = "1 pH7";
subDirStem2 = "2 pH4";
subDirStem3 = "3 pH10";
subDirStem4 = "4 pH7";
subDirStem5 = "5 pH10";
subDirStem6 = "6 pH4";
subDirStem7 = "7 pH10";
subDirStem8 = "8 pH7";
subDirStem9 = "9 pH4";

    %% kdk: Clear previous plots

    close all

    taus1430 = [];
    taus1702 = [];

    Kmin = 1;
    Kmax = 9;
    if plotOption == 4
        offset = -24; % 2020/3/16 new
    else
        offset = 0;
    end
    
    FigH = figure('Position', get(0, 'Screensize'));
    for gel = 1:4
        for series = 1:3
            for K = Kmin:Kmax
                tau1430 = 1.0/(vals(gel, series, K, 1, 4));
                taus1430 = [taus1430; tau1430];
                
                tau1702 = 1/(vals(gel, series, K, 2, 4));
                taus1702 = [taus1702; tau1702];           
            end
        end
    end
    histogram(taus1430);
    histogram(taus1702);
    
    title(myTitle(gelOption), 'FontSize', myTitleFont);
    
    myXlabel = sprintf('Time (hours)');
    xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
    if plotOption == 1 || plotOption == 4
        ylabel('Normalized Intensity', ...
            'FontSize', myLabelFont); % y-axis label
    else
        ylabel('Intensity at 1430cm^-^1(A.U.)/Intensity at 1702cm^-^1(A.U.)', ...
            'FontSize', myLabelFont); % y-axis label
    end

    % 20201201 New
    saveMyPlot(FigH, myTitle(gelOption));

%end main portion

function d = getDenominator(closestRef, numPointsEachSide, numPoints, spectrum)
    global myDebug;
    % use the closestRef as the x-value of the center point of the peak
    % sum the points from x=(closestRef - numPointsIntegrated) to 
    % x=(closestRef + numPointsIntegrated) and then divide by number of
    % points to average and scale it.
    
    if myDebug 
        fprintf('getDenominator with numPointsEachSide = %d\n', ...
            numPointsEachSide);
    end
    
    % check that numPointsIntegrated is in range
    lowEnd = closestRef - numPointsEachSide;
    if (lowEnd < 1) 
        fprintf('low end of number of points integrated is out of range');
    end
    highEnd = closestRef + numPointsEachSide;
    if (highEnd > numPoints)
        fprintf('high end of number of points integrated is out of range');
    end
    
    sum = 0;
    if myDebug 
        fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
            numPointsEachSide);
    end
    startIndex = closestRef - numPointsEachSide;
    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(startIndex);
        if myDebug
            fprintf('index: %d, spectrum: %g\n', startIndex, spectrum(startIndex));
        end
        startIndex = startIndex + 1;
    end
    denominator = sum/numPointsToIntegrate;
    if myDebug
        fprintf('denominator: %g\n', denominator);
    end
    d = denominator;
end

function [e f] = correctBaseline(tics)
    lambda=1e4; % smoothing parameter
    p=0.001; % asymmetry parameter
    d=2;

    % asym: Baseline estimation with asymmetric least squares using weighted
    % smoothing with a finite difference penalty.
    %   signals: signal, each column represents one signal
    %   lambda: smoothing parameter (generally 1e5 to 1e8)
    %   p: asymmetry parameter (generally 0.001)
    %   d: order of differences in penalty (generally 2)
    temp_tic=asysm(tics,lambda,p,d);
    trend=temp_tic';
    modified=tics(:)-temp_tic(:);
    e = trend;
    f = modified';
end

function h = localPeak(range)
    h = max(range);
end


function p = getPeak(mySubIter)
    switch(mySubIter)
        case 1
            p = 1430;
        case 2
            p = 1702;
        case other
            p = -1;
    end
end

% Plot the coefficients of the log fit. Ideally, the values
% should be the same for the 3 segments at a single pH level.
function q = plotVals()
    % Colors:
    global blue;
    global rust;
    global gold;
    global purple;
    global green;
    global ciel; 
    global cherry;
    global red;
    global black;
    global vals
    global nPoints;
    global lastPoints;

    % compare all the pH 4  values: these are in pH= 2, 6, 9
    for peak = 1:2
        for coeff = 1:3:6
            FigH = figure('Position', get(0, 'Screensize'));
            switch peak
                case 1
                    mySgTitle = sprintf('1430 cm-1 pk ');
                case 2
                    mySgTitle = sprintf('1702 cm-1 pk');
            end
            switch coeff
                case 1
                    mySgTitle = strcat(mySgTitle, ' coeff a');
                case 4
                    mySgTitle = strcat(mySgTitle, ' coeff b');
            end
            
            % sgtitle(mySgTitle); not for prelim

%             for gel = 1:4
%                 for series = 1:3
            for gel = 1:1 % for prelim
                for series = 1:3 % for prelim
                    set(gca,'FontSize', 30); % this doesn't work
                    %subplot(4,3,(gel-1)*3 + series); not for prelim

                    % pH 4
                    xPH4 = [ 2 6 9 ];
                    yPH4 = [vals(gel, series, 2, peak, coeff) ...
                        vals(gel, series, 6, peak, coeff) ...
                        vals(gel, series, 9, peak, coeff)];
                    % 2020/12/01 New: average the pH4 values
                    avgPH4(series) = mean(yPH4, 'all');
                    % error bars are relative to data point, not absolute,
                    % so need to convert them from absolute
                    negErr1 = vals(gel, series, 2, peak, coeff) - ...
                        vals(gel, series, 2, peak, coeff+1);
                    negErr2 = vals(gel, series, 6, peak, coeff) - ...
                        vals(gel, series, 6, peak, coeff+1);
                    negErr3 = vals(gel, series, 9, peak, coeff) - ...
                        vals(gel, series, 9, peak, coeff+1);
                    % put them in an array
                    negErrPH4 = [negErr1 negErr2 negErr3];
                    
                    posErr1 = vals(gel, series, 2, peak, coeff+2) - ...
                        vals(gel, series, 2, peak, coeff);
                    posErr2 = vals(gel, series, 6, peak, coeff+2) - ...
                        vals(gel, series, 6, peak, coeff);
                    posErr3 = vals(gel, series, 9, peak, coeff+2) - ...
                        vals(gel, series, 9, peak, coeff);
                    % put them in an array
                    posErrPH4 = [posErr1 posErr2 posErr3];

                    errorbar(xPH4, yPH4, negErrPH4, posErrPH4, '-o', 'Color', red);
                    hold on;
                    
                    % New 2020/12/1 label the series and the average 
                    myLabel = sprintf ("%d", series);
                    text(xPH4(3)+0.1, yPH4(3), myLabel, 'Color', red, 'FontSize', 20);
                    hold on;
                    plot(9., avgPH4(series), '-o', 'Color', red);
                    hold on;
                    myLabel = sprintf("avg %d", series);
                    text(9.1, avgPH4(series), myLabel, 'Color', red, 'FontSize', 20);
                    hold on;
                    
                    % pH 7
                    xPH7 = [ 1 4 8 ];
                    yPH7 = [vals(gel, series, 1, peak, coeff) ...
                        vals(gel, series, 4, peak, coeff) ...
                        vals(gel, series, 8, peak, coeff)];
                    % 2020/12/01 New: average the pH7 values
                    avgPH7(series) = mean(yPH7, 'all');
                    % error bars are relative to data point, not absolute,
                    % so need to convert them from absolute
                    negErr1 = vals(gel, series, 1, peak, coeff) - ...
                        vals(gel, series, 1, peak, coeff+1);
                    negErr2 = vals(gel, series, 4, peak, coeff) - ...
                        vals(gel, series, 4, peak, coeff+1);
                    negErr3 = vals(gel, series, 8, peak, coeff) - ...
                        vals(gel, series, 8, peak, coeff+1);
                    % put them in an array
                    negErrPH7 = [negErr1 negErr2 negErr3];
                    
                    posErr1 = vals(gel, series, 1, peak, coeff+2) - ...
                        vals(gel, series, 1, peak, coeff);
                    posErr2 = vals(gel, series, 4, peak, coeff+2) - ...
                        vals(gel, series, 4, peak, coeff);
                    posErr3 = vals(gel, series, 8, peak, coeff+2) - ...
                        vals(gel, series, 8, peak, coeff);
                    % put them in an array
                    posErrPH7 = [posErr1 posErr2 posErr3];
                    
                    errorbar(xPH7, yPH7, negErrPH7, posErrPH7, '-o', 'Color', green);
                    hold on;
                    
                    % New 2020/12/1 label the series
                    myLabel = sprintf("avg %d", series);
                    text(xPH7(3)+0.1, yPH7(3), myLabel, 'Color', green, 'FontSize', 20);
                    hold on;
                    plot(0., avgPH7(series), '-o', 'Color', green);
                    hold on;
                    myLabel = sprintf ("avg");
                    text(9.1, avgPH7(series), myLabel, 'Color', green, 'FontSize', 20);
                    hold on;
                    
                    % pH 10
                    xPH10 = [ 3 5 7 ];
                    yPH10 = [vals(gel, series, 3, peak, coeff) ...
                        vals(gel, series, 5, peak, coeff) ...
                        vals(gel, series, 7, peak, coeff)];
                    % 2020/12/01 New: average the pH10 values
                    avgPH10(series) = mean(yPH10, 'all');
                    % error bars are relative to data point, not absolute,
                    % so need to convert them from absolute
                    negErr1 = vals(gel, series, 3, peak, coeff) - ...
                        vals(gel, series, 3, peak, coeff+1);
                    negErr2 = vals(gel, series, 5, peak, coeff) - ...
                        vals(gel, series, 5, peak, coeff+1);
                    negErr3 = vals(gel, series, 7, peak, coeff) - ...
                        vals(gel, series, 7, peak, coeff+1);
                    % put them in an array
                    negErrPH10 = [negErr1 negErr2 negErr3];
                    
                    posErr1 = vals(gel, series, 3, peak, coeff+2) - ...
                        vals(gel, series, 3, peak, coeff);
                    posErr2 = vals(gel, series, 5, peak, coeff+2) - ...
                        vals(gel, series, 5, peak, coeff);
                    posErr3 = vals(gel, series, 7, peak, coeff+2) - ...
                        vals(gel, series, 7, peak, coeff);
                    % put them in an array
                    posErrPH10 = [posErr1 posErr2 posErr3];
                    %plot(xAllPH, yPH4, '-o');
                    errorbar(xPH10, yPH10, negErrPH10, posErrPH10, '-o', 'Color', blue);
                    
                    % New 2020/12/1 label the series
                    myLabel = sprintf("avg %d", series);
                    text(xPH10(3)+0.1, yPH10(3), myLabel, 'Color', blue, 'FontSize', 20);
                    hold on;
                    plot(9., avgPH10(series), '-o', 'Color', blue);
                    hold on;
                    myLabel = sprintf ("avg");
                    text(9.1, avgPH10(series), myLabel, 'Color', blue, 'FontSize', 20);
                    hold on;
                    
                    myTitle = sprintf('gel %d all series using last %d points of each segment', gel, lastPoints);
                    %myTitle = sprintf('alginate gel12 punch1 using last %d points of each segment', lastPoints);
                    title(myTitle,'FontSize',30);
                    set(gca,'FontSize', 30); % this works
                    xlim([0 10]);
                    xlabel('pH buffer segment', 'FontSize', 30);
                    ylabel(mySgTitle, 'FontSize', 30);
                end
                % 2020/12/01 New: average over all series
                overallAvgPH4(gel, peak, coeff) = mean(avgPH4, 'all');
                overallAvgPH7(gel, peak, coeff) = mean(avgPH7, 'all');
                overallAvgPH10(gel, peak, coeff) = mean(avgPH10, 'all');
                plot(10., overallAvgPH4(gel, coeff), '-o', 'Color', red);
                hold on;
                myLabel = sprintf ("AVG");
                text(10.1, overallAvgPH4(gel, peak, coeff), myLabel, 'Color', red, 'FontSize', 20);
                hold on;
                plot(10., overallAvgPH7(gel, peak, coeff), '-o', 'Color', green);
                hold on;
                myLabel = sprintf ("AVG");
                text(10.1, overallAvgPH7(gel, peak, coeff), myLabel, 'Color', green, 'FontSize', 20);
                hold on;
                plot(10., overallAvgPH10(gel, peak, coeff), '-o', 'Color', blue);
                hold on;
                myLabel = sprintf ("AVG");
                text(10.1, overallAvgPH10(gel, peak, coeff), myLabel, 'Color', blue, 'FontSize', 20);
                hold on;
                
                % 2020/12/01 New: save to file
                saveMyPlot(FigH, myTitle);
            end
        end
        % 2020/12/02 New: draw the logarithmic curve using the 
        % overall average values, eg. y = a + b*log(x) 
        FigH = figure('Position', get(0, 'Screensize'));
        % do I need to set x array?
        x = logspace(-1,2);

        y1 = overallAvgPH4(1, peak, 1) + overallAvgPH4(1, peak, 4) * x;
        y2 = overallAvgPH7(1, peak, 1) + overallAvgPH7(1, peak, 4) * x;
        y3 = overallAvgPH10(1, peak, 1) + overallAvgPH10(1, peak, 4) * x;
        lineThickness = 2;
        if peak == 1
            title('1430 cm-1 peak');
        else
            title('1702 cm-1 peak');
        end
        semilogx(x, y1,'-o', 'Color', red, 'LineWidth', lineThickness);
        hold on;
        semilogx(x, y2,'-o', 'Color', green, 'LineWidth', lineThickness);
        hold on;
        semilogx(x, y3,'-o', 'Color', blue, 'LineWidth', lineThickness);
        hold on;
        saveMyPlot(FigH, myTitle);
    end
    q = 1;
end

% Print the last value of each segment
function r = printEndVals()
    global endVals
    fprintf('endVals\n');
    for gel = 1:4
        fprintf('gel%d\n', gel);
        for punch = 1:3
            fprintf('punch%d', punch);
            for segment = 1:9
                % 1430 peak
                fprintf('seg%d: %f ', segment, endVals(gel, punch, segment, 1));
                % 1702 peak
                %fprintf('seg%d: %f ', segment, endVals(gel, punch, segment, 2));
            end
            fprintf('\n');
        end
    end
    r = 1;
end

% Print the initial slope of each segment. Use it to compare gels for 
% which one allows the fastest transitions
function s = printSpeedVals()
    global speedVals
    fprintf('slope');
    for gel = 1:4
        fprintf('gel%d\n', gel);
        for punch = 1:3
            fprintf('punch%d', punch);
            for segment = 1:9
                % 1430 peak
                fprintf('seg%d: %f ', segment, speedVals(gel, punch, segment, 1));
                % 1702 peak
                %fprintf('seg%d: %f ', segment, speedVals(gel, punch, segment, 2));
            end
            fprintf('\n');
        end
    end
   s = 1;
end

function g = saveMyPlot(FigH, myTitle)
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlotName = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlotName, 'png');
    g = 1;
end