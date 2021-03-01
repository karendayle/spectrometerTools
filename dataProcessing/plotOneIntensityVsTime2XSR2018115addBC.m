% Plot the intensity at a single wavenumber normalized by the reference 
% intensity vs time by extracting it from a set of files in different directories
% The time to use for the x axis is in the filename as
% avg-yyyy-mm-dd-mm-ss.txt. Convert this to seconds since epoch.
% Dayle Kotturi October 2018

% There are two plots to build (or two lines on one plot).
% Use the index 614 to get the intensity at 1430/cm (act. 1428.58/cm)
global x1;
x1 = 614;
% Use the index 794 to get the intensity at 1702/cm (act. 1701.95/cm)
global x2;
x2 = 794;
% Use the index 409 to get the intensity at the reference peak, 1078/cm,
% ring breathing
global xRef;
xRef = 409;
% These indices could be modified slightly and results compared.

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

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
global dirStem;
%dirStem = "H:\Documents\Data\Embedded hydrogel study\flow through 2X v2\";
dirStem = "Z:\Documents\Data\flow through 2X\"; % Analyzing using remote Matlab client
subDirStem1 = "1 cont pH7 2X";
subDirStem2 = "2 cont pH4 2X";
subDirStem3 = "3 cont pH7 2X";
subDirStem4 = "4 cont pH8.5 2X";
subDirStem5 = "5 cont pH8.5 2X";
subDirStem6 = "6 cont pH7 2X";
subDirStem7 = "7 cont pH4 2X";
subDirStem8 = "8 cont pH4 2X";
subDirStem9 = "9 cont pH4 2X";
subDirStem10 = "10 cont pH4 2X";
subDirStem11 = "11 cont pH4 2X";

thisData1 = zeros(2, numPoints, 'double');
thisData2 = zeros(2, numPoints, 'double');
thisData3 = zeros(2, numPoints, 'double');
thisData4 = zeros(2, numPoints, 'double');
thisData5 = zeros(2, numPoints, 'double');
thisData6 = zeros(2, numPoints, 'double');
thisData7 = zeros(2, numPoints, 'double');
thisData8 = zeros(2, numPoints, 'double');
thisData9 = zeros(2, numPoints, 'double');
thisData10 = zeros(2, numPoints, 'double');
thisData11 = zeros(2, numPoints, 'double');

global myDebug;
myDebug = 0;

% subtract this offset 
global tRef;
tRef = datenum(2018, 9, 27, 0,0, 0);

figure 

global myTitleFont;
global myLabelFont;
myTitleFont = 30;
myLabelFont = 20;

for K = 1:11
    switch K
        case 1
            %xRef = 409; % default
            pHcolor = green;
            num1 = myPlot(subDirStem1, thisData1, pHcolor);
            fprintf('Case 1: %d spectra plotted in green\n', num1);
        case 2
            %xRef = 416;
            pHcolor = red;
            num2 = myPlot(subDirStem2, thisData2, pHcolor);
            fprintf('Case 2: %d spectra plotted in red\n', num2);
        case 3
            %xRef = 416;
            pHcolor = green;
            num3 = myPlot(subDirStem3, thisData3, pHcolor);
            fprintf('Case 3: %d spectra plotted in green\n', num3);            
        case 4
            pHcolor = ciel;
            num4 = myPlot(subDirStem4, thisData4, pHcolor);
            fprintf('Case 4: %d spectra plotted in ciel\n', num4);
        case 5
            pHcolor = ciel;
            num5 = myPlot(subDirStem5, thisData5, pHcolor);
            fprintf('Case 5: %d spectra plotted in ciel\n', num5);
        case 6
            pHcolor = green;
            num6 = myPlot(subDirStem6, thisData6, pHcolor);
            fprintf('Case 6: %d spectra plotted in green\n', num6);
        case 7
            pHcolor = red;
            num7 = myPlot(subDirStem7, thisData7, pHcolor);
            fprintf('Case 7: %d spectra plotted in red\n', num7)
        case 8
            pHcolor = red;
            num8 = myPlot(subDirStem8, thisData8, pHcolor);
            fprintf('Case 8: %d spectra plotted in red\n', num8)
        case 9
            pHcolor = red;
            num9 = myPlot(subDirStem9, thisData9, pHcolor);
            fprintf('Case 9: %d spectra plotted in red\n', num9)
        case 10
            pHcolor = red;
            num10 = myPlot(subDirStem10, thisData10, pHcolor);
            fprintf('Case 10: %d spectra plotted in red\n', num10)
        case 11
            pHcolor = red;
            num11 = myPlot(subDirStem11, thisData11, pHcolor);
            fprintf('Case 11: %d spectra plotted in red\n', num11)
    end
end    
y = 0.95;
x = 4.5;
deltaY = 0.05;
deltaX = 0.5;
text(x, y, 'Line color', 'Color', black, 'FontSize', myLabelFont);
text(x+deltaX, y, 'Plot symbol', 'Color', black, 'FontSize', myLabelFont);

y = y - deltaY;
text(x, y, 'pH 4', 'Color', red, 'FontSize', myLabelFont);
text(x, y, '_____', 'Color', red, 'FontSize', myLabelFont);
text(x+deltaX, y, 'o = 1430/cm', 'Color', black, 'FontSize', myLabelFont);

y = y - deltaY;
text(x, y, 'pH 7', 'Color', green, 'FontSize', myLabelFont);
text(x, y, '_____', 'Color', green, 'FontSize', myLabelFont);
text(x+deltaX, y, '* = 1702/cm', 'Color', black, 'FontSize', myLabelFont);

y = y - deltaY;
text(x, y, 'pH 8.5', 'Color', ciel,'FontSize', myLabelFont);
text(x, y, '_____', 'Color', ciel, 'FontSize', myLabelFont);

y = y - deltaY;
text(x, y, 'pH 10', 'Color', blue,'FontSize', myLabelFont);
text(x, y, '_____', 'Color', blue, 'FontSize', myLabelFont);

hold off
title('Normalized intensity at pH-sensitive peaks vs time in 2X gel', ...
    'FontSize', myTitleFont);
myXlabel = sprintf('Time in days from %s', datestr(tRef));
xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
ylabel('Intensity (A.U.)/Intensity of ring-breathing at 1078/cm (A.U.)', ...
    'FontSize', myLabelFont); % y-axis label
    
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

function g = myPlot(subDirStem, thisData, myColor)
    global blue;
    global rust;
    global gold;
    global purple;
    global green;
    global ciel; 
    global cherry;
    global red;
    global dirStem;
    global numPoints;
    global x1;
    global x2;
    global xRef;
    global tRef;
    global myDebug;
    
    str_dir_to_search = dirStem + subDirStem; % args need to be strings
    dir_to_search = char(str_dir_to_search)
    txtpattern = fullfile(dir_to_search, 'avg*.txt');
    dinfo = dir(txtpattern); 
    for I = 1 : length(dinfo)
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
        % THIS IS THE WEIRD BEHAVIOR THAT TOOK TIME TO FIGURE OUT 9OCT+10OCT
        % Create the dateTime variable. Hours, minutes, seconds are
        % ignored so add them in after as fraction of a day
        % This method doesn't work. See above at tRef setting
        %dateTime = char(strcat(myYear, '-', myMonth, '-', myDay));
        % Use tRef just to deal with smaller numbers
        %t1 = datenum(dateTime, 'yyyy-MM-dd') - tRef;
        %t(I) = t1 + ((myH + myMi/60 + myS/3600))/24;
        % NEW 10/10/2018
        t(I) = datenum(myY, myMo, myD, myH, myMi, myS) - tRef;
        fprintf...
            ('CHECK %d file %2d-%2d-%2d-%2d-%2d-%2d has time %10.4f\n',...
            I, myY, myMo, myD, myH, myMi, myS, t(I));
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
        
        y1(I) = f(x1)/denominator;
        y2(I) = f(x2)/denominator;

        %y1(I) = thisdata(2, x1)/denominator;
        %y2(I) = thisdata(2, x2)/denominator;
        %y3(I) = denominator; % NEW Oct. 17th to look for jumps in ref
        fclose(fileID);
    end
    
    % Now have points for the 1430 plot at t,y1 and for the 1702 plot at t,y2
    plot(t,y1,'-o', 'Color', myColor);
    hold on;
    plot(t,y2,'-*', 'Color', myColor); % Could vary darkness to distinguish
    hold on;
    %plot(t,y3,'-*', 'Color', rust);
    g = 1;
end
