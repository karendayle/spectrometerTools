% plotRatiosOfTimeSeriesJB03.m
% This script makes the time series plots for the 4 gel types (3 series)

% Plot the intensity at a single wavenumber normalized by the reference 
% intensity vs time by extracting it from a set of files in different directories
% The time to use for the x axis is in the filename as
% avg-yyyy-mm-dd-mm-ss.txt. Convert this to seconds since epoch.

% Adapting this in a new way:
% 1) to compare transition speeds based on slopes 
% 2) extracting final value for each segment for comparison across samples,
%    across gel types and to compare to values in static buffer
% Dayle Kotturi August 2020

addpath('../functionLibrary');

% CHOOSE plotOption
global plotOption;
%plotOption = 1; % plot y1 and y2. 20200805: extract last val of each segment
%plotOption = 2; % plot y3
%plotOption = 3; % check pH sens
plotOption = 4; % do curve fitting. Set value for lastPoints (line ~510) to
% adjust how many points at the end of the segment are used

% There are two plots to build (or two lines on one plot).
% Use the index 614 to get the intensity at 1430/cm (act. 1428.58/cm)
% Find the local max instead of looking at const location
global x1Min
global x1Max
x1Min = 591;
x1Max = 615;
% Use the index 794 to get the intensity at 1702/cm (act. 1701.95/cm)
% Find the local max instead of looking at const location
global x2Min
global x2Max
x2Min = 790;
x2Max = 797;

% IMPORTANT: This is index to reference peak. 
% No, it is not only this value that is used. Rather it is an integration
% around this point that is used for the denominator that normalizes
global xRef
xRef = 713; % COO- at 1582
            % TO DO: read from avg*.txt file
% Colors:
global blue
global rust
global gold
global purple
global green
global ciel
global cherry
global red
global black
global magenta
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
pHcolor = [0.0, 0.0, 0.0];

global numPoints;
numPoints = 1024;

global nPoints;

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

global dirStem;

global vals; % a multi dimensional array to hold the curve fitting results
global endVals; % a multi dim'l array to hold the endpts of all segments
global speedVals; % a multi dim'l array to hold the initial slopes of 
                  % each segment
global myXValues;
myXValues = [];

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

close all; % clean slate

% Do for each dataset 1:12
for gelOption = 1:12
    Kmin = 1;
    Kmax = 9; %20210106
    if plotOption == 4
%         offset = -24; % 2020/3/16 new
        offset = 0; % 20210106
    else
        offset = 0;
    end
    
    % figure
    FigH = figure('Position', get(0, 'Screensize'));
    set(gca,'FontSize', myTextFont); % has no effect on tick label size
    switch gelOption
      case 1 % alginate time series 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch1 flowcell all\";
        tRef = datenum(2019, 12, 10, 14, 1, 8);
        gel = 1; series = 1;
      case 2  % alginate time series 2
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch2 flowcell1 1000ms integ\";
        tRef = datenum(2020, 1, 10, 13, 45, 1);
        gel = 1; series = 2;
      case 3 % alginate time series 3
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch3 flowcell1\";
        tRef = datenum(2020, 1, 12, 16, 15, 57);
        gel = 1; series = 3;
        
      case 4 % PEG time series 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 3\1\";
        tRef = datenum(2018, 12, 28, 16, 34, 5);
        gel = 2; series = 1;
      case 5 % PEG time series 2
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 15\";
        tRef = datenum(2020, 3, 14, 21, 22, 41);
        gel = 2; series = 2;
      case 6 % PEG time series 3 20210107 errors with 20 pts, +/-1000
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 16\punch1 flowcell all\";
        tRef = datenum(2020, 3, 17, 15, 38, 43);
        gel = 2; series = 3;
        
      case 7 % pHEMA time series 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 1\2\";
        tRef = datenum(2018, 12, 30, 16, 1, 17);
        gel = 3; series = 1;
      case 8 % pHEMA time series 2 -- needs special handling b/c there are
          % 2 add'l dirs for 3 pH10 and 4 pH7
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\punch1 flowcell1\";
        tRef = datenum(2020, 1, 25, 17, 10, 17); 
        gel = 3; series = 2; 
      case 9 % pHEMA time series 3
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\punch2 flowcell1 300ms\";
        tRef = datenum(2020, 2, 1, 17, 54, 20);
        gel = 3; series = 3;
        
      case 10 % pHEMA/coAc  time series 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 3\4\"; 
        tRef = datenum(2019, 01, 26, 16, 28, 6);
        gel = 4; series = 1;
        Kmax = 8; % special case b/c final pH4 is missing!
      case 11 % add pHEMA/coAc  time series 2
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\punch1 flowcell1\";
        tRef = datenum(2020, 1, 27, 12, 27, 47); 
        gel = 4; series = 2;
      case 12 % pHEMA/coAc time series 3
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\punch2 flowcell1\";
        tRef = datenum(2020, 2, 3, 19, 50, 17);
        gel = 4; series = 3;
    end
    
    % '-o' '-+' '-*' '-.' '-x' '-s' '-d' '-^' '-v' '->' '-<' '-p' '-h'
    pH4Marker1 = 'o';
    pH4Marker2 = '+';
    pH7Marker1 = 'v';
    pH7Marker2 = '^';
    pH10Marker1 = 'p';
    pH10Marker2 = 'h';
    for K = Kmin:Kmax
        switch K
            case 1
                pHcolor = green;
                num1 = myPlot(subDirStem1, pHcolor, pH7Marker1, pH7Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 1: %d spectra plotted in green\n', num1);
            case 2
                pHcolor = red;
                num2 = myPlot(subDirStem2, pHcolor, pH4Marker1, pH4Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 2: %d spectra plotted in red\n', num2);            
            case 3
                pHcolor = blue;
                num3 = myPlot(subDirStem3, pHcolor, pH10Marker1, pH10Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 3: %d spectra plotted in blue\n', num3);
                if gelOption == 8 % plot redo
                    offset = offset; % for the rest of gelOption 8
                    num3 = myPlot("3 pH10 redo 40 msmts", pHcolor, ...
                        pH10Marker1, pH10Marker2, ...
                    offset, gelOption, gel, series, K);
                end
            case 4
                pHcolor = green;
                if gelOption == 6 % plot part 2
                    % offset = offset; % for the rest of gelOption 6 ???
                    num4 = myPlot("4 pH7 only 29", pHcolor, pH7Marker1, pH7Marker2, ...
                    offset, gelOption, gel, series, K);
                end
                num4 = myPlot(subDirStem4, pHcolor, pH7Marker1, pH7Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 4: %d spectra plotted in green\n', num4);

                if gelOption == 8 % plot redo
                    %offset = offset; % for the rest of gelOption 8 ???
                    num3 = myPlot("4 pH7 redo", pHcolor, pH7Marker1, pH7Marker2, ...
                    offset, gelOption, gel, series, K);
                end
            case 5
                pHcolor = blue;
                num5 = myPlot(subDirStem5, pHcolor, pH10Marker1, pH10Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 5: %d spectra plotted in blue\n', num5);
            case 6
                pHcolor = red;
                num6 = myPlot(subDirStem6, pHcolor, pH4Marker1, pH4Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 6: %d spectra plotted in red\n', num6); 
            case 7
                pHcolor = blue;
                num7 = myPlot(subDirStem7, pHcolor, pH10Marker1, pH10Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 7: %d spectra plotted in blue\n', num7);
            case 8
                pHcolor = green;
                num8 = myPlot(subDirStem8, pHcolor, pH7Marker1, pH7Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 8: %d spectra plotted in green\n', num8);
            case 9
                pHcolor = red;
                num9 = myPlot(subDirStem9, pHcolor, pH4Marker1, pH4Marker2, ...
                    offset, gelOption, gel, series, K);
                %fprintf('Case 9: %d spectra plotted in red\n', num9);
        end
    end    

    if plotOption == 1
        if gelOption == 1 || gelOption == 2 || gelOption == 4
            y = 0.24;
            deltaY = 0.02;
            x = 2.5;
        else
            if gelOption == 3
                y = 0.325;
                deltaY = 0.02;
                x = 32;
            end
        end
    else
        if gelOption == 1
            y = 8.9;
            deltaY = 0.25;
            x = 0.25;
        else
            y = 8.9;
            deltaY = 0.1;
            x = 7;
        end   
    end
    % limit height of the exponential curves that get drawn
%     if plotOption == 4
%         ylim([0. 0.35]);
%         y = 4.9;
%         deltaY = 0.25;
%     end

%     % YES for SRs, NO for pubs
%     text(x, y, 'o = local peak near 1430 cm^-^1', 'Color', black, 'FontSize', myTextFont);
%     y = y - deltaY;
%     text(x, y, '+ = local peak near 1702 cm^-^1', 'Color', black, 'FontSize', myTextFont);
%     y = y - deltaY;
%     hold off
    
    % title(myTitle(gelOption), 'FontSize', myTitleFont); 2021/02/19 out
    % for final version
    myXlabel = sprintf('Time (hours)');
    xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
    if plotOption == 1 || plotOption == 4
        ylabel('Normalized Intensity', ...
            'FontSize', myLabelFont); % y-axis label
    else
        ylabel('Intensity at 1430cm^-^1(A.U.)/Intensity at 1702cm^-^1(A.U.)', ...
            'FontSize', myLabelFont); % y-axis label
    end
    saveMyPlot(FigH, myTitle(gelOption));
    pause(1);
end
if plotOption == 1
    plotEndVals(); % don't need another plot, but as a way to see
    plotSpeedVals(); % don't need another plot, but as a way to see
end
if plotOption == 4
    % 20210129 save vals so that histogramOfTauJB06 can use them
    save('Data\vals.mat', 'vals'); 
    % 2020/12/20 save myXValues so that plotExponentialCurves can use them
    save('Data\XValues.mat', 'myXValues');
    plotVals(); % can only call this if loop runs for all 12 geloptions
end
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

function g = myPlot(subDirStem, myColor, myMarker1, myMarker2, ...
    offset, gelOption, gel, series, K)
    global blue;
    global rust;
    global gold;
    global purple;
    global green;
    global ciel; 
    global cherry;
    global red;
    global black;
    global dirStem;
    global numPoints;
    global x1Min;
    global x1Max;
    global x2Min;
    global x2Max;
    global xRef;
    global tRef;
    global myDebug;
    global lineThickness;
    global plotOption;
    global vals;
    global endVals;
    global speedVals;
    global nPoints;
    global myXValues;
    
%     sumY1 = 0;
%     sumY2 = 0;
%     avgY1 = 0;
%     avgY2 = 0;
%     sumSqY1 = 0;
%     sumSqY2 = 0;
    set(gca,'FontSize', 30); % has to be here to effect tick labels
    str_dir_to_search = dirStem + subDirStem; % args need to be strings
    dir_to_search = char(str_dir_to_search); % 2020/2/19 add comma
    txtpattern = fullfile(dir_to_search, 'avg*.txt');
    dinfo = dir(txtpattern); 
    thisdata = zeros(2, numPoints, 'double');
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
        % TO DO: add if stmt to ensure numberOfSpectra > 0
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name            
            % NEW 10/8/2018: extract time from filename
            S = string(thisfilename); 
            newStr1 = extractAfter(S,"avg-");
            dateWithHyphens = extractBefore(newStr1,".txt");
            % No, it would be too easy if this worked
            %t1 = datetime(dateWithHyphens,'Format','yyyy-MM-dd-hh-mm-ss');
            [myYear, remain] = strtok(dateWithHyphens, '-');
            [myMonth, remain] = strtok(remain, '-');
            [myDay, remain] = strtok(remain, '-');
            [myHour, remain] = strtok(remain, '-');
            [myMinute, remain] = strtok(remain, '-');
            [mySecond, remain] = strtok(remain, '-');
            % These are strings, need to make them numbers,
            % by, sigh, first making them char arrays
            % which wasn't by the way necessary with 2018a.
            % sigh again.
            myY = str2num(char(myYear));
            myMo = str2num(char(myMonth));
            myD = str2num(char(myDay));
            myH = str2num(char(myHour));
            myMi = str2num(char(myMinute));
            myS = str2num(char(mySecond));
            t(I) = (datenum(myY, myMo, myD, myH, myMi, myS) - tRef)*24.;
            %fprintf...
            %    ('CHECK %d file %2d-%2d-%2d-%2d-%2d-%2d has time %10.4f\n',...
            %    I, myY, myMo, myD, myH, myMi, myS, t(I));
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            % NEW 10/18 - base corr not done in 10/15/18 SR. This could explain
            % the lack of steady state...
            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)'); 
            % OLDER denominator = thisdata(2, xRef);
            % OLD denominator = f(xRef);
            % NEW 10/20/2018
            denominator = 1; % default
            if (xRef ~= 0) 
                numPointsEachSide = 2; % TO DO: This could be increased
                denominator = getDenominator(xRef, numPointsEachSide, ...
                    numPoints, f(:));
            end
            if myDebug
                fprintf('denominator = %g at index: %d\n', denominator1, xRef);
            end

            % NEW 11/6/2018: since peaks at 1430 and 1702/cm red-, blueshift
            % as function of pH, find the local max in the area
            x1LocalPeak = localPeak(f(x1Min:x1Max));
            x2LocalPeak = localPeak(f(x2Min:x2Max));
            %fprintf('local max near 1430/cm is %g\n', x1LocalPeak);
            %fprintf('local max near 1702/cm is %g\n', x2LocalPeak);       

            y1(I) = x1LocalPeak/denominator;
            y2(I) = x2LocalPeak/denominator;
            y3(I) = y1(I)/y2(I);

            fclose(fileID);
%             sumY1 = sumY1 + y1(I);
%             sumY2 = sumY2 + y2(I);
        end
        
%        ss(gel, series, K, 1) = y1(numberOfSpectra);
%        ss(gel, series, K, 1) = y2(numberOfSpectra);
        
%         % calculate average 
%         avgY1 = sumY1/numberOfSpectra
%         avgY2 = sumY2/numberOfSpectra
%         sumSqY1 = 0;
%         sumSqY2 = 0;
        
%         % second pass on dataset to get (each point - average)^2
%         % for standard deviation, need 
%         for I = 1 : numberOfSpectra            
%             % 4. Add to the sum of the squares
%             sumSqY1 = sumSqY1 + (y1(I) - avgY1).^2;
%             sumSqY2 = sumSqY2 + (y2(I) - avgY2).^2;
%         end
    end
    
%     % 5. Compute standard deviation at each index of the averaged spectra 
%     stdDevY1 = sqrt(sumSqY1/numberOfSpectra);
%     stdDevY2 = sqrt(sumSqY2/numberOfSpectra);
%     
%     for J=1:numberOfSpectra
%         avgArrayY1(J) = avgY1;
%         avgArrayY2(J) = avgY2;
%         stdDevArrayY1(J) = stdDevY1;
%         stdDevArrayY2(J) = stdDevY2;
%     end
    
%     % Now have points for the 1430 plot at t,y1 and for the 1702 plot at t,y2
%     Either:
%     errorbar(t, avgArrayY1, stdDevArrayY1, '-o', 'Color', purple);
%     errorbar(t, avgArrayY2, stdDevArrayY2, '-*', 'Color', purple);
%     hold on;
%     Or:
    switch plotOption
        case {1,3}
            plot(t-offset,y1,myMarker1,'Color',myColor,'LineWidth',lineThickness);
            hold on;
            plot(t-offset,y2,myMarker2,'Color',myColor,'LineWidth',lineThickness);
            hold on;

            % 20200805 Store endpoint values of this segment for later
            % comparison
            % Need gel, series, segment K, y1, y2
            endVals(gel,series,K,1) = y1(numberOfSpectra);
            endVals(gel,series,K,2) = y2(numberOfSpectra);

            % 20200805 Use this as a measure to determine the gel that
            % transitions the fastest
            if numberOfSpectra >= 5
                speedVals(gel,series,K,1) = y1(5) - y1(1);
                speedVals(gel,series,K,2) = y2(5) - y2(1);
            end
        case 2
            plot(t-offset,y3,'-*','Color',myColor,'LineWidth',lineThickness);
        case 4
            % 2020/12/17 Bring this back
            % First plot the actual data
            % Plot the 1430 cm-1 normalized peak
            plot(t-offset,y1,myMarker1,'Color',myColor,'LineWidth',lineThickness); % new
            %ylim([0. 0.3]);
            hold on;
            % Plot the 1702 cm-1 normalized peak
            plot(t-offset,y2,myMarker2,'Color',myColor,'LineWidth',lineThickness);
            ylim([0. 0.3]);
            hold on;

            % Then do the curve fitting and overlay the result
            % throw away the transitioning part of the segment and just
            % take the end of the segment when steady state occurs
            lastPoints = 20; % CHOOSE THIS NUMBER
            nPoints = length(t)-lastPoints+1;

            % if there are enough points, take last N points instead of full set
            if nPoints > 0
                xSubset = t(nPoints:end); 
                
                y1 = y1(nPoints:end);
                % redraw the portion of the curve that is used to build
                % the model in black 
                result = curveFitting(xSubset,offset,y1,black,gel,series,K,1);
                rc = parseCurveFittingObject(gelOption,gel,series,K,1,result);
%                ylim([0. 0.3]);
                hold on;   

                % take last N points instead of full segment
                y2 = y2(end-lastPoints+1:end);          
                % redraw the portion of the curve that is used to build
                % the model in black 
                result = curveFitting(xSubset,offset,y2,black,gel,series,K,2);
                rc = parseCurveFittingObject(gelOption,gel,series,K,2,result);
%                ylim([0. 0.3]);
                hold on;

%             % 2020/12/16 PREP FOR NEW WAY:
%             % This part is only needed if matrix of x values needs to be
%             % stored for use by other pgms
%             % Save the arrays of x values to file for all 12 plots,
%             % then read them into plotExponentialCurves.m
%             % Note: if any segment has > 60 points, take the final 60
%             % to preserve array dims (and not cause an error)
%             [~, cols] = size(t)
%             if cols > 60
%                 xValues = t(1,cols-59:cols);
%             else
%                 if cols == 60
%                     xValues = t(1,:);    
%                 else
%                     % dataset is missing 1+ points, 
%                     % add a buffer just to preserve array shape
%                     % Note: ignore buffer values in follow on parsing
%                     xValues = t(1,:);
%                     for ii = cols+1:60
%                         xValues(ii) = -999;
%                     end
%                 end
%             end
%             myXValues = [ myXValues; xValues ];
%             counter = (gel - 1) * 3 + series;
%             fprintf('gelOption%d, seg:%d: %f\n', counter, K, xValues(1));
            end
    end       
    hold on;
    g = 1;
end

function h = localPeak(range)
    h = max(range);
end

function j = curveFitting(t,offset,y,myColor,gel,series,myIter,mySubIter)
global black
% To avoid this error: "NaN computed by model function, fitting cannot continue.
% Try using or tightening upper and lower bounds on coefficients.", do not set
% start point to 0. 
% Ref=https://www.mathworks.com/matlabcentral/answers/132082-curve-fitting-toolbox-error
    % fit exponential curve to y1
    %curveFit(t-offset,y,myColor);
    if (mySubIter == 1) 
        % for 1430 peak time series
        switch myIter
            case {1,2,4,6,8,9}
                % when pH goes from H to L, it's like discharging capacitor
                % 2020/12/17 remove -1* from the exponent
%                 g = fittype('a*exp(x/b)', ...
%                     'dependent',{'y'},'independent',{'x'}, ...
%                     'coefficients',{'a','b'});
%                 g = fittype('a*exp(b*x)', ...
%                     'dependent',{'y'},'independent',{'x'}, ...
%                     'coefficients',{'a','b'});
%                 g = fittype('a*exp(-1. * b*x)', ...
%                     'dependent',{'y'},'independent',{'x'}, ...
%                     'coefficients',{'a','b'});
                % 2020/12/30 new
                g = fittype('a*exp(-b*x)+c', ...
                        'dependent',{'y'},'independent',{'x'},...
                        'coefficients',{'a','b','c'});
            case {3,5,7}
                % when pH goes from L to H, it's like charging capacitor
                % 2020/12/17 remove -1* from the exponent
%                 g = fittype('a*(1 - exp(x/b))', ...
%                     'dependent',{'y'},'independent',{'x'}, ...
%                     'coefficients',{'a','b'});
%                 g = fittype('a*(1 - exp(b*x))', ...
%                     'dependent',{'y'},'independent',{'x'}, ...
%                     'coefficients',{'a','b'});
%                 g = fittype('a*(1 - exp(-1. * b*x))', ...
%                     'dependent',{'y'},'independent',{'x'}, ...
%                     'coefficients',{'a','b'});
                  % 2020/12/30 new
                  g = fittype('a*(1 - exp(-b*x))+c', ...
                        'dependent',{'y'},'independent',{'x'},...
                        'coefficients',{'a','b','c'});
        end
    else
        if (mySubIter == 2)
            % for 1702 peak time series
            switch myIter
                case {1,2,4,6,8,9}
                    % when pH goes from L to H, it's like charging capacitor
%                     g = fittype('a*(1 - exp(x/b))', ...
%                         'dependent',{'y'},'independent',{'x'}, ...
%                         'coefficients',{'a','b'});
%                     g = fittype('a*(1 - exp(b*x))', ...
%                         'dependent',{'y'},'independent',{'x'}, ...
%                         'coefficients',{'a','b'});
%                     g = fittype('a*(1 - exp(-1. * b*x))', ...
%                         'dependent',{'y'},'independent',{'x'}, ...
%                         'coefficients',{'a','b'});
                    % 2020/12/30 new
                    g = fittype('a*(1 - exp(-b*x))+c', ...
                        'dependent',{'y'},'independent',{'x'},...
                        'coefficients',{'a','b','c'});
                case {3,5,7}
                    % when pH goes from H to L, it's like discharging capacitor
%                     g = fittype('a*exp(x/b)', ...
%                         'dependent',{'y'},'independent',{'x'},...
%                         'coefficients',{'a','b'});
%                     g = fittype('a*exp(b*x)', ...
%                         'dependent',{'y'},'independent',{'x'},...
%                         'coefficients',{'a','b'});
%                     g = fittype('a*exp(-1. * b*x)', ...
%                         'dependent',{'y'},'independent',{'x'},...
%                         'coefficients',{'a','b'});
                    % 2020/12/30 new
                    g = fittype('a*exp(-b*x)+c', ...
                        'dependent',{'y'},'independent',{'x'},...
                        'coefficients',{'a','b','c'});
            end       
        end
    end
    
    % don't allow exact zeros
    xStart = (t(1)-offset);
    yStart = y(1);
    if xStart == 0.
        xStart = 0.01;
    end
    if yStart == 0.
        yStart = 0.01;
    end
    startPoint = [xStart yStart 0];
    xCurve = (t-offset)';
    yCurve = y';
    % xCurve and yCurve are both nx1 row-column form 
    % StartPoint wants 2 points for this type of fit
    % 2020/12/24: old: f0 = fit(xCurve,yCurve,g,'StartPoint',startPoint);
    
    % 2020/12/24: new: put startPoint in fitOptions, 
    % https://www.mathworks.com/help/curvefit/fitoptions.html
    % options = fitoptions(g);
    % 2020/12/28: actually startPoint is only for NonlinearLeastSquares
    % method, so get rid of it... not quite. Doc'n must be wrong b/c
    % it says that startPoint is missing, so it's creating an arbitrary
    % one 

    % this says 'Too many input arguments', so need to find another way...
    %f0 = fit(xCurve, yCurve, g, 'StartPoint', startPoint, options);
    % This is back to where I started (works but limits are unset)
    % and options are unused
    %f0 = fit(xCurve, yCurve, g, 'StartPoint', startPoint);
    
    % 2020/12/28: this works, but these vals are arbitrarily chosen
    % Can I narrow them to +/- 1000?
    %      Lower     - A vector of lower bounds on the coefficients to be fitted
    %                  [{[]} | vector of length the number of coefficients]
    %      Upper     - A vector of upper bounds on the coefficients to be fitted
    %                  [{[]} | vector of length the number of coefficients]
    if gel == 4 && series == 3
        % Use +/-inf for pHEMA series 3
        lower = [-inf -inf -inf ]; % 2020/12/30 new add 3rd value for 'c'
        upper = [inf inf inf]; % 2020/12/30 new add 3rd value for 'c'
    else
        if gel == 2 && series == 3
            lower = [-10000 -10000 -10000 ];
            upper = [10000 10000 10000 ];      
        else
            % Use +/-1000 for all the rest
            lower = [-1000 -1000 -1000 ]; %2021/1/7 to fix pb with pHEMA3-5-1702
            upper = [1000 1000 1000 ];    %2021/1/7 to fix pb with pHEMA3-5-1702
        end
    end
    % 2020/12/30 new error re: # start points, try without it
    f0 = fit(xCurve, yCurve, g, 'StartPoint', startPoint, 'Lower', lower, 'Upper', upper);
    % this runs but without start point, it chooses an arbitray one
    % and no model values get drawn
    % f0 = fit(xCurve, yCurve, g, 'Lower', lower, 'Upper', upper);

    y1Model = [];
    y2Model = [];
    % Now plot the modeled data as an overlay
    if (mySubIter == 1)
        % xCurve
        % for 1430 peak time series
        switch myIter
            case {1,2,4,6,8,9}
                % when pH goes from H to L, it's like discharging capacitor
                % 2020/12/17 remove -1* from the exponent
                % y1Model = f0.a*exp(xCurve/f0.b);
                % y1Model = f0.a*exp(f0.b * xCurve);
                % y1Model = f0.a*exp(-1. * f0.b * xCurve);
                % 2020/12/30 new
                %y1Model = f0.a*exp(xCurve/f0.b) + f0.c;
                y1Model = f0.a*exp(-1.*f0.b*xCurve) + f0.c;
            case {3,5,7}
                % when pH goes from L to H, it's like charging capacitor
                % 2020/12/17 remove -1* from the exponent
                % y1Model = f0.a*(1 - exp(xCurve/f0.b));
                % y1Model = f0.a*(1 - exp(f0.b * xCurve));
                % y1Model = f0.a*(1 - exp(-1 * f0.b * xCurve));
                % 2020/12/30 new
                %y1Model = f0.a*(1 - exp(xCurve/f0.b)) + f0.c;
                y1Model = f0.a*(1 - exp(-1.*f0.b*xCurve)) + f0.c;
        end
        plot(xCurve, y1Model, '-s', 'Color', black);
        % y1Model
        hold on;
    else
        if (mySubIter == 2)
            % for 1702 peak time series
            switch myIter
                case {1,2,4,6,8,9}
                    % when pH goes from L to H, it's like charging capacitor
                    % y2Model = f0.a*(1 - exp(xCurve/f0.b));
                    % y2Model = f0.a*(1 - exp(f0.b * xCurve));
                    % y2Model = f0.a*(1 - exp(-1 * f0.b * xCurve));
                    % 2020/12/30 new
                    % y2Model = f0.a*(1 - exp(xCurve/f0.b)) + f0.c;
                    y2Model = f0.a*(1 - exp(-1.*f0.b*xCurve)) + f0.c;
                case {3,5,7}
                    % when pH goes from H to L, it's like discharging capacitor
                    % 2020/12/17 remove -1* from the exponent
                    % y2Model = f0.a*exp(xCurve/f0.b);
                    % y2Model = f0.a*exp(f0.b * xCurve);
                    % y2Model = f0.a*exp(-1. * f0.b * xCurve);
                    % 2020/12/30 new
                    % y2Model = f0.a*exp(xCurve/f0.b) + f0.c;
                    y2Model = f0.a*exp(-1.*f0.b*xCurve) + f0.c;
            end
            plot(xCurve, y2Model, '-s', 'Color', black);
            % y2Model
            hold on;
        end
    end
    
    %ALTERNATE: LOGARITHMIC MODEL
    % -- this model works when data is curve like charging cap
    %    but it does not plot as straight line
    %    -- this fails for the first pH7 segment
    %myfittype=fittype('a + b*log(x)',...
    %'dependent', {'y'}, 'independent',{'x'},...
    %'coefficients', {'a','b'});
    %f0=fit(xCurve,yCurve,myfittype,'StartPoint',startPoint);
    %END
    
    % draw the portion of the actual data that is used by the model in
    % black
    % 2020/12/18 this is wrong
%     numRows = size(xCurve,1);
%     startXX = xCurve(1) - 10.;
%     finishXX = xCurve(numRows) + 10;
%     xx = linspace(startXX, finishXX, numRows);
%     plot(xCurve,yCurve,'o',xx,f0(xx), 'Color', myColor);
%     hold on;
    
    j = f0;
end

function k = parseCurveFittingObject(gelOption, gel, series, pH, peak, f0)
    global vals
    % 2020/2/8 since confidence intervals are inaccessible as fields, convert val to 
    % string and parse them out
    % ref: 
    % https://www.mathworks.com/help/matlab/ref/matlab.unittest.diagnostics.constraintdiagnostic.getdisplayablestring.html
    str = matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(f0);
    %fprintf(str);
    remain = str;
    segments = strings(0);
    while (remain ~= "")
        [token,remain] = strtok(remain, '(');
        segments = [segments; token];
    end
    
    % For case of fittype e^-t/RC ONLY,
    % a's confidence intervals are in segments(5)
    % b's confidence intervals are in segments(6)
    % c's confidence intervals are in segments(7)
    switch length(segments)
        case 5
            fprintf('5');
            aLow = 0;
            aHigh = 0;
            bLow = 0;
            bHigh = 0;
            remain = segments(5);
            [cLow,remain] = strtok(remain, ',');
            % remain contains the ',' and a space and THEN value we want
            [comma,remain] = strtok(remain);
            [cHigh,remain] = strtok(remain, ')');
            % now cLow and cHigh are correct, but string type
            cLow = double(cLow);
            cHigh = double(cHigh);
        case 6
            fprintf('6');
            aLow = 0;
            aHigh = 0;
            bLow = 0;
            bHigh = 0;
            cLow = 0;
            cHigh = 0;
        case 7
            remain = segments(5);
            [aLow,remain] = strtok(remain, ',');
            % remain contains the ',' and a space and THEN value we want
            [comma,remain] = strtok(remain);
            [aHigh,remain] = strtok(remain, ')');
            % now aLow and aHigh are correct, but string type
            aLow = double(aLow);
            aHigh = double(aHigh);

            remain = segments(6);
            [bLow,remain] = strtok(remain, ',');
            % remain contains the ',' and a space and THEN value we want
            [comma,remain] = strtok(remain);
            [bHigh,remain] = strtok(remain, ')');
            % now bLow and bHigh are correct, but string type
            bLow = double(bLow);
            bHigh = double(bHigh);

            remain = segments(7);
            [cLow,remain] = strtok(remain, ',');
            % remain contains the ',' and a space and THEN value we want
            [comma,remain] = strtok(remain);
            [cHigh,remain] = strtok(remain, ')');
            % now cLow and cHigh are correct, but string type
            cLow = double(cLow);
            cHigh = double(cHigh);
        case 8
            % For case of fittype 1-e^-t/RC,
            % confidence intervals are NOT in segments(5) and (6)
            % and segments array only has 4 elements
            % 20210108 this is not true. fix it and add c's high and low
            remain = segments(6);
            [aLow,remain] = strtok(remain, ',');
            % remain contains the ',' and a space and THEN value we want
            [comma,remain] = strtok(remain);
            [aHigh,remain] = strtok(remain, ')');
            % now aLow and aHigh are correct, but string type
            aLow = double(aLow);
            aHigh = double(aHigh);

            remain = segments(7);
            [bLow,remain] = strtok(remain, ',');
            % remain contains the ',' and a space and THEN value we want
            [comma,remain] = strtok(remain);
            [bHigh,remain] = strtok(remain, ')');
            % now bLow and bHigh are correct, but string type
            bLow = double(bLow);
            bHigh = double(bHigh);

            remain = segments(8);
            [cLow,remain] = strtok(remain, ',');
            % remain contains the ',' and a space and THEN value we want
            [comma,remain] = strtok(remain);
            [cHigh,remain] = strtok(remain, ')');
            % now cLow and cHigh are correct, but string type
            cLow = double(cLow);
            cHigh = double(cHigh);   
        
    end
    pHStr = getPH(pH);
    gelStr = getGel(gelOption);
    peakVal = getPeak(peak);
    fprintf('%s-%d-%s-%d: a=%f (%f, %f), b=%f (%f, %f) tau = %f, c = %f (%f, %f)\n', ...
        gelStr, pH, pHStr, peakVal,f0.a, aLow, aHigh, ...
        f0.b, bLow, bHigh, (1.0/f0.b), f0.c, cLow, cHigh);
    
    vals(gel, series, pH, peak, 1) = f0.a;
    vals(gel, series, pH, peak, 2) = aLow;
    vals(gel, series, pH, peak, 3) = aHigh;
    vals(gel, series, pH, peak, 4) = f0.b;
    vals(gel, series, pH, peak, 5) = bLow;
    vals(gel, series, pH, peak, 6) = bHigh;
    vals(gel, series, pH, peak, 7) = f0.c;
    vals(gel, series, pH, peak, 8) = cLow;
    vals(gel, series, pH, peak, 9) = cHigh;
    k = 1;
end

function m = getPH(iter)
    switch(iter)
        case {1, 4, 8}
            m = 'pH7';
        case {2, 6, 9}
            m = 'pH4';
        case {3, 5, 7}
            m = 'pH10';
        case other
            m = 'error';
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
function n = getGel(gelOption)
    switch(gelOption)
        case {1,2,3}
            n = 'alginate';
        case {4,5,6}
            n = 'PEG';
        case {7,8,9}
            n = 'pHEMA';
        case {10,11,12}
            n = 'pHEMA/coAc';
        case other
            n = 'error';
    end
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

    % compare all the pH 4  values: these are in pH= 2, 6, 9
    for peak = 1:2
        for coeff = 1:3:6
            % figure
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

            for gel = 1:4
                for series = 1:3
                    set(gca,'FontSize', 30); % this doesn't work
                    %subplot(4,3,(gel-1)*3 + series); not for prelim

                    % pH 4
                    xPH4 = [ 2 6 9 ];
                    yPH4 = [vals(gel, series, 2, peak, coeff) ...
                        vals(gel, series, 6, peak, coeff) ...
                        vals(gel, series, 9, peak, coeff)];
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
                    
                    % pH 7
                    xPH7 = [ 1 4 8 ];
                    yPH7 = [vals(gel, series, 1, peak, coeff) ...
                        vals(gel, series, 4, peak, coeff) ...
                        vals(gel, series, 8, peak, coeff)];
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
                    
                    % pH 10
                    xPH10 = [ 3 5 7 ];
                    yPH10 = [vals(gel, series, 3, peak, coeff) ...
                        vals(gel, series, 5, peak, coeff) ...
                        vals(gel, series, 7, peak, coeff)];
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
                    %myTitle = sprintf('gel %d series %d', gel, series);
                    myTitle = sprintf('alginate gel12 punch1 using last %d points of each segment', nPoints);
                    title(myTitle((gel - 1) * 3 + series),'FontSize',30);
                    set(gca,'FontSize', 30); % this works
                    xlim([0 10]);
                    xlabel('pH buffer segment', 'FontSize', 30);
                    ylabel(mySgTitle, 'FontSize', 30); % for prelim 
                end
            end
        end
    end
    q = 1;
end

% Plot the last value of each segment
function r = plotEndVals()
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
    global endVals;
    global myTitle;
    global myTitleFont;
    global myLabelFont;
    global myTextFont;
    % Use the colors to match the pH values (4=red, 7=green, 10=blue)
    myColor1 = [ green; red; blue; green; blue; red; blue; green; red ];
    myColor2 = [ gold; cherry; ciel; gold; ciel; cherry; ciel; gold; cherry ];
    
    markers = ...
        [ '-o' '-+' '-*' '-.' '-x' '-s' '-d' '-^' '-v' '->' '-<' '-p' '-h']; 
        % all the symbols that Matlab has
        
 
    for gel = 1:4
        %figure
        FigH = figure('Position', get(0, 'Screensize'));
        for punch = 1:3
            for segment = 1:9
%                 plot(segment, endVals(gel, punch, segment, 1), ...
%                     markers(((gel-1)*3)+punch), 'LineStyle','none', 'MarkerSize', 30, ...
%                     'Color', myColor1(segment,:), 'linewidth', 2);
                plot(segment, endVals(gel, punch, segment, 1), ...
                    markers(((gel-1)*3)+punch), 'LineStyle','none', 'MarkerSize', 35, ...
                    'Color', 'k', 'linewidth', 2);
                hold on;
%                 plot(segment, endVals(gel, punch, segment, 2), ...
%                     markers(((gel-1)*3)+punch), 'LineStyle','none', 'MarkerSize', 30, ...
%                     'Color', myColor2(segment,:), 'linewidth', 2);
                plot(segment, endVals(gel, punch, segment, 2), ...
                    markers(((gel-1)*3)+punch), 'LineStyle','none', 'MarkerSize', 35, ...
                    'Color', 'k', 'linewidth', 2);
                hold on;
            end 

        end
        % title, axes labels, legend   
        %title(myTitle(((gel-1)*3)+punch), 'FontSize', myTitleFont);
        gelNumber = sprintf('Gel %d', gel);
        title(gelNumber, 'FontSize', myTitleFont);
        myXlabel = sprintf('Segment number');
        xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
        ylabel('Normalized Intensity', ...
            'FontSize', myLabelFont); % y-axis label
    end
    r = 1;
end

% Plot the initial slope of each segment. Use it to compare gels for 
% which one allows the fastest transitions
function s = plotSpeedVals()
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
    global speedVals;
    global myTitle;
    global myTitleFont;
    global myLabelFont;
    global myTextFont;
    % Use the colors to match the pH values (4=red, 7=green, 10=blue)
    myColor1 = [ green; red; blue; green; blue; red; blue; green; red ];
    myColor2 = [ gold; cherry; ciel; gold; ciel; cherry; ciel; gold; cherry ];
    % all the symbols that Matlab has
    markers = ...
        [ '-o' '-+' '-*' '-.' '-x' '-s' '-d' '-^' '-v' '->' '-<' '-p' '-h']; 

    %figure
    FigH = figure('Position', get(0, 'Screensize'));
    for gel = 1:4
        for punch = 1:3
            for segment = 1:9
%                 plot(segment, speedVals(gel, punch, segment, 1), ...
%                     markers(((gel-1)*3)+punch), ...
%                     'LineStyle','none', 'MarkerSize', 30, ...
%                     'Color', myColor1(segment,:), 'linewidth', 2);
                plot(segment, speedVals(gel, punch, segment, 1), ...
                    markers(((gel-1)*3)+punch), ...
                    'LineStyle','none', 'MarkerSize', 30, ...
                    'Color', 'k', 'linewidth', 2);
                hold on;
%                 plot(segment, speedVals(gel, punch, segment, 2), ...
%                     markers(((gel-1)*3)+punch), 'LineStyle','none', ...
%                     'MarkerSize', 30, ...
%                     'Color', myColor2(segment,:), 'linewidth', 2);
                plot(segment, speedVals(gel, punch, segment, 2), ...
                    markers(((gel-1)*3)+punch), 'LineStyle','none', ...
                    'MarkerSize', 30, ...
                    'Color', 'k', 'linewidth', 2);
                hold on;
            end 
        end
    end
    % title, axes labels, legend   
    title(myTitle(((gel-1)*3)+punch), 'FontSize', myTitleFont);
    myXlabel = sprintf('Segment number');
    xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
    ylabel('Slope of first 5 measurements in segment', ...
        'FontSize', myLabelFont); % y-axis label
    s = 1;
end

function g = saveMyPlot(FigH, myTitle)
global plotOption
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    switch plotOption
        case {1,2,3}
            myPlotName = sprintf('%s%s', plotDirStem, myTitle);
        case 4
            myPlotName = sprintf('%s%s curve fit', plotDirStem, myTitle);
    end
    saveas(FigH, myPlotName, 'png');
    g = 1;
end