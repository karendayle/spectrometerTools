% Plot the intensity at a single wavenumber normalized by the reference 
% intensity vs time by extracting it from a set of files in different directories
% The time to use for the x axis is in the filename as
% avg-yyyy-mm-dd-mm-ss.txt. Convert this to seconds since epoch.
% Dayle Kotturi October 2018

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

global lastY1;
lastY1 = zeros(1, 8, 'double');
global lastY2;
lastY2 = zeros(1, 8, 'double');

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
global dirStem;
dirStem = "C:\Users\karen\Documents\Data\Made by Sureyya\pHEMA coAcrylamide\gel 3\calibration\"; % Analyzing using remote Matlab client
dirStem = "H:\Documents\Data\Made by Sureyya\pHEMA coAcrylamide\gel 3\calibration\"; % Analyzing using lab desktop
subDirStem1 = "1 pH4";
subDirStem2 = "2 pH7";
subDirStem3 = "3 pH10";
subDirStem4 = "4 pH8";
subDirStem5 = "5 pH5";
subDirStem6 = "6 pH3";
subDirStem7 = "7 pH6";
subDirStem8 = "8 pH9";

global lineThickness;
lineThickness = 2;

global myDebug;
myDebug = 0;

figure 

% subtract this offset 
global tRef;
tRef = datenum(2019, 5, 11, 19, 35, 00);

myTitleFont = 30;
myLabelFont = 20;
myTextFont = 15;

for K = 1:8
    % The numbering of cases is weird now because data was collected
    % in the order: pH4,7,10,8,5,3,6,9 and because I want to plot the 
    % "lastY*" values sequentially: pH3,4,5,6,7,8,9,10, this is required
    switch K
        case 2
            pHcolor = red;
            num1 = myPlot(subDirStem1, pHcolor, 4, K);
            fprintf('Case 2: %d spectra plotted in red\n', num1);
        case 5
            pHcolor = green;
            num2 = myPlot(subDirStem2, pHcolor, 7, K);
            fprintf('Case 5: %d spectra plotted in green\n', num2);            
        case 8
            pHcolor = purple;
            num3 = myPlot(subDirStem3, pHcolor, 10, K);
            fprintf('Case 8: %d spectra plotted in purple\n', num3);
        case 6
            pHcolor = ciel;
            num4 = myPlot(subDirStem4, pHcolor, 8, K);
            fprintf('Case 6: %d spectra plotted in ciel\n', num4);
        case 3
            pHcolor = rust;
            num5 = myPlot(subDirStem5, pHcolor, 5, K);
            fprintf('Case 3: %d spectra plotted in rust\n', num5);            
        case 1
            pHcolor = cherry;
            num6 = myPlot(subDirStem6, pHcolor, 3, K);
            fprintf('Case 1: %d spectra plotted in cherry\n', num6);
        case 4
            pHcolor = gold;
            num7 = myPlot(subDirStem7, pHcolor, 6, K);
            fprintf('Case 4: %d spectra plotted in gold\n', num7);
        case 7
            pHcolor = blue;
            num8 = myPlot(subDirStem8, pHcolor, 9, K);
            fprintf('Case 7: %d spectra plotted in blue\n', num8);            
    end
end    
   
y = 4.9; %pHEMA coAc
x = 3.1;
deltaY = 0.01;

% text(x, y, 'o = local peak near 1430 cm^-^1', 'Color', black, 'FontSize', myTextFont);
% y = y - deltaY;
% text(x, y, '+ = local peak near 1702 cm^-^1', 'Color', black, 'FontSize', myTextFont);
text(x, y, '* = local peak near 1430 cm^-^1/local peak near 1702 cm^-^1', 'Color', black, 'FontSize', myTextFont);
xAxis=[3 4 5 6 7 8 9 10];
% plot(xAxis, lastY1, 'Color', black);
% plot(xAxis, lastY2, 'Color', black);
plot(xAxis, lastY3, 'Color', black);

hold off
title('Ratiometric continuous real-time of 86 nm spheres in pHEMA coAc gel 3 in flowcell', ...
    'FontSize', myTitleFont);
myXlabel = sprintf('pH Level');
xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
ylabel('Intensity (A.U.)/Intensity at 1582 cm^-^1 (A.U.)', ...
    'FontSize', myLabelFont); % y-axis label
set(gca,'FontSize',16,'FontWeight','bold','box','off')
    
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

function g = myPlot(subDirStem, myColor, pH, J)
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
    global lastY1;
    global lastY2;
    global lastY3;
    
%     sumY1 = 0;
%     sumY2 = 0;
%     avgY1 = 0;
%     avgY2 = 0;
%     sumSqY1 = 0;
%     sumSqY2 = 0;
    
    str_dir_to_search = dirStem + subDirStem; % args need to be strings
    dir_to_search = char(str_dir_to_search)
    txtpattern = fullfile(dir_to_search, 'avg*.txt');
    dinfo = dir(txtpattern); 
    thisdata = zeros(2, numPoints, 'double');
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
        % TO DO: add if stmt to ensure numberOfSpectra > 0
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name            
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            % NEW 10/18 - base corr not done in 10/15/18 SR. This could explain
            % the lack of steady state...
            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)'); 
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
            fprintf('local max near 1430/cm is %g\n', x1LocalPeak);
            fprintf('local max near 1702/cm is %g\n', x2LocalPeak);       
            y1(I) = x1LocalPeak/denominator;
            y2(I) = x2LocalPeak/denominator;
            y3(I) = x1LocalPeak/x2LocalPeak;
            
%             offset = 2; % array starts at 1, pH starts at 3
            if (I==numberOfSpectra)
                lastY1(J) = y1(I);
                lastY2(J) = y2(I);
                lastY3(J) = y3(I);
            end

            fclose(fileID);
%             sumY1 = sumY1 + y1(I);
%             sumY2 = sumY2 + y2(I);
        end
    
%         % calculate average as part of std dev calculation
%         avgY1 = sumY1/numberOfSpectra;
%         avgY2 = sumY2/numberOfSpectra;
%         sumSqY1 = 0;
%         sumSqY2 = 0;
%         
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
%     plot(pH,y1,'-o', 'Color', myColor, 'LineWidth', lineThickness);
%     hold on;
%     plot(pH,y2,'-+', 'Color', myColor, 'LineWidth', lineThickness);
%     hold on;
    plot(pH,y3,'-*', 'Color', myColor, 'LineWidth', lineThickness);
    hold on;
%     plot(pH,lastY1(J),'-o', 'Color', black, 'LineWidth', lineThickness);
%     hold on;
%     plot(pH,lastY2(J),'-+', 'Color', black, 'LineWidth', lineThickness);
%     hold on;
    plot(pH,lastY3(J),'-*', 'Color', black, 'LineWidth', lineThickness);
    hold on;
    g = 1;
end

function h = localPeak(range)
    h = max(range);
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     