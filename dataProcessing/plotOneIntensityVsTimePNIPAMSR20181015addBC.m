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

global numPoints;
numPoints = 1024;

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
%dirStem = "H:\Documents\Data\Embedded hydrogel study\flow through PNIPAM\";
dirStem = "Z:\Documents\Data\flow through PNIPAM\"; % Analyzing using remote Matlab client
subDirStem1 = "pH4 1 cont 4 hrs 24 meas 10 min separ";
subDirStem2 = "pH4 2 cont check signal 1 meas";
subDirStem3 = "pH4 3 cont 4.5 hrs 27 meas 10 min separ";
subDirStem4 = "pH7 1 cont 4 28 meas 10 min separ";
subDirStem5 = "pH7 2 cont 2.4 hrs 15 meas 10 min separ";
subDirStem6 = "pH8.5 1 cont 3.5 hrs 20 meas 10 min separ";
subDirStem7 = "pH8.5 2 cont 2.25 hrs 14 meas 10 min separ";

%refWaveNumber = 1074.26; % at index 407 - read from file, same for all 3
refIndex = 409; % index where the reference peak is 
                %(ring breathing near 1078 cm^-1
                % TO DO: read from avg*.txt file

thisdata1 = zeros(2, numPoints, 'double');
thisdata2 = zeros(2, numPoints, 'double');
thisdata3 = zeros(2, numPoints, 'double');
thisdata4 = zeros(2, numPoints, 'double');
thisdata5 = zeros(2, numPoints, 'double');
thisdata6 = zeros(2, numPoints, 'double');
thisdata7 = zeros(2, numPoints, 'double');

offset = 300;
denominator1 = 1; % default. Used if refIndex is 0
denominator2 = 1; % default. Used if refIndex is 0
denominator3 = 1; % default. Used if refIndex is 0
denominator4 = 1; % default. Used if refIndex is 0
denominator5 = 1; % default. Used if refIndex is 0
denominator6 = 1; % default. Used if refIndex is 0
denominator7 = 1; % default. Used if refIndex is 0

% subtract this offset 
global tRef;
tRef = datenum(2018, 10, 1, 0,0, 0);

figure 
xMin = 900;
xMax = 2000;
%xlim([xMin xMax]); % needs to go after plot cmd
%ylim([yMin yMax]);

% initialize color
lineColor = red;

for K = 1:7
    switch K
        case 1
            %xRef = 409; % default
            pHcolor = red;
            num1 = myPlot(subDirStem1, thisData1, pHcolor);
            fprintf('Case 1: %d spectra plotted in red\n', num1);
        case 2
            %xRef = 416;
            pHcolor = red;
            num2 = myPlot(subDirStem2, thisData2, pHcolor);
            fprintf('Case 2: %d spectra plotted in red\n', num2);
        case 3
            %xRef = 416;
            pHcolor = red;
            num3 = myPlot(subDirStem3, thisData3, pHcolor);
            fprintf('Case 3: %d spectra plotted in red\n', num3);            
        case 4
            pHcolor = green;
            num4 = myPlot(subDirStem4, thisData4, pHcolor);
            fprintf('Case 4: %d spectra plotted in green\n', num4);
        case 5
            pHcolor = green;
            num5 = myPlot(subDirStem5, thisData5, pHcolor);
            fprintf('Case 5: %d spectra plotted in green\n', num5);
        case 6
            pHcolor = ciel;
            num6 = myPlot(subDirStem6, thisData6, pHcolor);
            fprintf('Case 6: %d spectra plotted in ciel\n', num6);
        case 7
            pHcolor = ciel;
            num7 = myPlot(subDirStem7, thisData7, pHcolor);
            fprintf('Case 7: %d spectra plotted in ciel\n', num7)
    end
end    
y = 0.24;
x = 1.6;
deltaY = 0.01;
deltaX = 0.6;
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
title('Normalized intensity at pH-sensitive peaks vs time in PNIPAM gel', ...
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
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    