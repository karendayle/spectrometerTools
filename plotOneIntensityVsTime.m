% Plot the intensity at a single wavenumber normalized by the reference 
% intensity vs time by extracting it from a set of files in different directories
% The time to use for the x axis is in the filename as
% avg-yyyy-mm-dd-mm-ss.txt. Convert this to seconds since epoch.

% There are two plots to build (or two lines on one plot).
% Use the index 614 to get the intensity at 1430 cm^-1 (act. 1428.58 cm^-1)
x1 = 614;
% Use the index 794 to get the intensity at 1702 cm^-1 (act. 1701.95 cm^-1)
x2 = 794;
% Use the index 409 to get the intensity at the reference peak, 1078 cm^-1,
% ring breathing
xRef = 409;
% These indices could be modified slightly and results compared.

% Dayle Kotturi October 2018

% Colors:
global blue;
global rust;
global gold;
global purple;
global green;
global ciel; 
global cherry;
global red;
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
dirStem = "H:\Documents\Data\Embedded hydrogel study\flow through PNIPAM\";
subDirStem1 = "pH4 1 cont 4 hrs 24 meas 10 min separ";
subDirStem2 = "pH4 2 cont check signal 1 meas";
subDirStem3 = "pH4 3 cont 4.5 hrs 27 meas 10 min separ";
subDirStem4 = "pH7 1 cont 4 28 meas 10 min separ";
subDirStem5 = "pH7 2 cont 2.4 hrs 15 meas 10 min separ";
subDirStem6 = "pH8.5 1 cont 3.5 hrs 20 meas 10 min separ";
subDirStem7 = "pH8.5 2 cont 2.25 hrs 14 meas 10 min separ";
numPoints = 1024;
thisData1 = zeros(2, numPoints, 'double');
thisData2 = zeros(2, numPoints, 'double');
thisData3 = zeros(2, numPoints, 'double');
thisData4 = zeros(2, numPoints, 'double');
thisData5 = zeros(2, numPoints, 'double');
thisData6 = zeros(2, numPoints, 'double');
thisData7 = zeros(2, numPoints, 'double');

offset = 300;

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure 
xMin = 900;
xMax = 2000;

% initialize color
lineColor = red;

% subtract this offset 
% myRefDate = '2018-10-01'
% tRef = datenum(myRefDate, 'yyyy-MM-dd'); % why does 2018-09-01 give same value?
% fprintf('CHECK date %s has time %10.4f\n', myRefDate, tRef);
% myRefDate = '2018-09-01'
% tRef = datenum(myRefDate, 'yyyy-MM-dd'); % why does 2018-09-01 give same value?
% fprintf('CHECK date %s has time %10.4f\n', myRefDate, tRef);
% % try another way
% myDateNum = datenum(2018, 09, 01, 10, 0, 0);
% fprintf('CHECK date 2018-09-01 10:00:00 has time %10.4f\n', myDateNum);
% myDateNum = datenum(2018, 10, 01, 10, 0, 0);
% fprintf('CHECK date 2018-09-01 10:00:00 has time %10.4f\n', myDateNum);
%this latter way looks better. the time is in days and the two calls are 30
%days apart: CHECK date 2018-09-01 10:00:00 has time 737304.4167
%            CHECK date 2018-10-01 10:00:00 has time 737334.4167
% So work with this approach for tRef and also further below
tRef = datenum(2018, 10, 01, 0, 0, 0);

for K = 1:7
%for K = 1:3 % pH4
%for K = 4:5 % pH7
%for K = 6:7 % pH8.5

    switch K
        case 1
            g = myPlot(dirStem, subDirStem1, thisData1, tRef, numPoints, x1, x2, xRef);
        case 2
            g = myPlot(dirStem, subDirStem2, thisData2, tRef, numPoints, x1, x2, xRef);
        case 3
            g = myPlot(dirStem, subDirStem3, thisData3, tRef, numPoints, x1, x2, xRef);               
        case 4
            g = myPlot(dirStem, subDirStem4, thisData4, tRef, numPoints, x1, x2, xRef);
        case 5
            g = myPlot(dirStem, subDirStem5, thisData5, tRef, numPoints, x1, x2, xRef);
        case 6
            g = myPlot(dirStem, subDirStem6, thisData6, tRef, numPoints, x1, x2, xRef);
        case 7
            g = myPlot(dirStem, subDirStem7, thisData7, tRef, numPoints, x1, x2, xRef);
    end
end    
% y = 1.3;
% text(1710, y, 'Laser Power = 0.375 Max');
% y = y - 0.1;
% text(1710, y, '5 second integration time per acq');
% y = y - 0.1;
% text(1710, y, 'Each spectra average of 5 acqs');
% y = y - 0.1;
% text(1750, y, 'pH 4');
% text(1710, y, '_____', 'Color', red);
% y = y - 0.1;
% text(1750, y, 'pH 7');
% text(1710, y, '_____', 'Color', green);
% y = y - 0.1;
% text(1750, y, 'pH 8.5');
% text(1710, y, '_____', 'Color', blue);

hold off
title('Normalized intensity at pH-sensitive peaks vs time');
xlabel('Time in days from epoch'); % x-axis label
ylabel('Arbitrary Units (A.U.)/Intensity of ring-breathing at 1078 cm^-1'); % y-axis label

function g = myPlot(dirStem, subDirStem, thisData, tRef, numPoints, xRef, x1, x2)
    global blue;
    global rust;
    global gold;
    global purple;
    global green;
    global ciel; 
    global cherry;
    global red;
        
    str_dir_to_search = dirStem + subDirStem; % args need to be strings
    % This function only in 2018b:
    %dir_to_search = convertContainedStringsToChars(str_dir_to_search);
    %How do I get it to char array for fullfile?
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
        denominator = thisdata(2, xRef);
        y1(I) = thisdata(2, x1)/denominator;
        y2(I) = thisdata(2, x2)/denominator;
        fclose(fileID);
    end
    % Now have points for the 1430 plot at t,y1 and for the 1702 plot at t,y2
    plot(t,y1,'-o', 'Color', red);
    hold on;
    plot(t,y2,'-o', 'Color', blue);
    hold on;
    g = 1;
end