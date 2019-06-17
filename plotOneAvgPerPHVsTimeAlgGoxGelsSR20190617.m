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

global plotOption;
plotOption = 1; % plot y1 and y2
%plotOption = 2; % plot y3
%plotOption = 3; % check pH sens

%global gelOption;
%gelOption = 1;
gelOption = 2;
%gelOption = 3; % gox1 check pH sens
%gelOption = 4; % gox2 check pH sens

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
global dirStem;
if gelOption == 1
    dirStem = "H:\Documents\Data\Made by Sureyya\Alginate\alg gox3\flowRate\";
else
    if gelOption == 2
        dirStem = "H:\Documents\Data\Made by Sureyya\Alginate\alg gox3\stopStart\";
    else
        if gelOption == 3
            dirStem = "H:\Documents\Data\Made by Sureyya\Alginate\gel 7\400mgdL again\";
%         else
%             dirStem = "H:\Documents\Data\Made by Sureyya\Alginate\alg gox2\TrisPH3.5\"
        end
    end
end

if gelOption == 1
    subDirStem1 = "1 4mLmin";
    subDirStem2 = "2 3mLmin";
    subDirStem3 = "3 2mLmin";
    subDirStem4 = "4 1mLmin";
    subDirStem5 = "5 0mLmin";
    Kmin = 1;
    Kmax = 5;
else
    if gelOption == 2
        subDirStem1 = "1 400mgdL 0mLmin"; % stop
        subDirStem2 = "2 400mgdL 1mLmin"; % start 
        subDirStem3 = "3 400mgdL 0mLmin"; % stop
        subDirStem4 = "4 testing in pH3.5Tris"; % start drive to pH3.5
        subDirStem5 = "5 400mgdL at 4mLmin 0613 1518to1640"; %start drive to stay acidic 
        subDirStem6 = "6 0mgdL at 4mLmin 0613 1648to1823"; % start drive to neutral
        subDirStem7 = "7 400mgdL at 4mLmin 0613 1832to2245"; % start drive to acidic (fails)
        subDirStem8 = "8 400mgdL at 0mLmin 0613to0614"; % stop to let acid pool
        subDirStem9 = "9 0mgdL at 4mLmin"; % drive to neutral
        subDirStem10 = "10 400mgdL at 4mLmin"; % drive to acidic
        subDirStem11 = "11 400mgdL 0mLmin"; % stop to let acid pool
        subDirStem12 = "12 0mgdL 4mLmin"; % drive to neutral
        subDirStem13 = "13 400mgdL 4mLmin"; % drive to acidic
        subDirStem14 = "14 400mgdL 0mLmin"; % stop to let acid pool
        Kmin = 5;
        Kmax = 14;
    else
        subDirStem1 = "1 0mLmin";
        Kmin = 1;
        Kmax = 1;
    end

     
% || gelOption == 4
%         subDirStem1 = "pH3.5 tris";
%         Kmax = 1;
%     end
end

global lineThickness;
lineThickness = 2;

global myDebug;
myDebug = 0;

figure 

% subtract this offset 
global tRef;
if gelOption == 1
    tRef = datenum(2019, 6, 11, 15, 4, 44);
else
    if gelOption == 2
        %tRef = datenum(2019, 6, 12, 10, 50, 48); % when Kmin=1
        tRef = datenum(2019, 6, 13, 15, 17, 59); % when Kmin=5
%     else
%         if gelOption == 3
%             tRef = datenum(2019, 6, 7, 13, 25, 31);
%         else
%             tRef = datenum(2019, 6, 8, 11, 52, 48);
%         end
    end
end

myTitleFont = 30;
myLabelFont = 20;
myTextFont = 15;

for K = Kmin:Kmax

    switch K
        case 1
            pHcolor = red;
            num1 = myPlot(subDirStem1, pHcolor, 0);
            fprintf('Case 1: %d spectra plotted in green\n', num1);
        case 2
            pHcolor = green;
            num2 = myPlot(subDirStem2, pHcolor, 0);
            fprintf('Case 2: %d spectra plotted in gold\n', num2);            
        case 3
            pHcolor = red;
            num3 = myPlot(subDirStem3, pHcolor, 0);
            fprintf('Case 3: %d spectra plotted in red\n', num3);
        case 4
            pHcolor = black;
            num4 = myPlot(subDirStem4, pHcolor, 0);
            fprintf('Case 4: %d spectra plotted in black\n', num4);
        case 5
            pHcolor = blue;
            num5 = myPlot(subDirStem5, pHcolor, 0);
            fprintf('Case 5: %d spectra plotted in blue\n', num5);  
        case 6
            pHcolor = gold;
            num6 = myPlot(subDirStem6, pHcolor, 0);
            fprintf('Case 6: %d spectra plotted in gold\n', num6);
        case 7
            pHcolor = blue;
            num7 = myPlot(subDirStem7, pHcolor, 0);
            fprintf('Case 7: %d spectra plotted in blue\n', num7);
        case 8
            pHcolor = red;
            num8 = myPlot(subDirStem8, pHcolor, 0);
            fprintf('Case 8: %d spectra plotted in red\n', num8); 
        case 9
            pHcolor = gold;
            num9 = myPlot(subDirStem9, pHcolor, 0);
            fprintf('Case 9: %d spectra plotted in gold\n', num9);
        case 10
            pHcolor = blue;
            num10 = myPlot(subDirStem10, pHcolor, 0);
            fprintf('Case 10: %d spectra plotted in blue\n', num10);
        case 11
            pHcolor = red;
            num11 = myPlot(subDirStem11, pHcolor, 0);
            fprintf('Case 11: %d spectra plotted in red\n', num11);
        case 12
            pHcolor = gold;
            num12 = myPlot(subDirStem12, pHcolor, 40);
            fprintf('Case 12: %d spectra plotted in gold\n', num12);
        case 13
            pHcolor = blue;
            num13 = myPlot(subDirStem13, pHcolor, 40);
            fprintf('Case 13: %d spectra plotted in blue\n', num13);
        case 14
            pHcolor = red;
            num14 = myPlot(subDirStem14, pHcolor, 40);
            fprintf('Case 14: %d spectra plotted in red\n', num14);
    end
end    
   
if plotOption == 1
    if gelOption == 1
        y = 0.2;
        deltaY = 0.02;
        x = 0.25;
    else
        if gelOption == 2
            y = 0.215;
            deltaY = 0.01;
            x = 43;
        else
            y = 0.21;
            deltaY = 0.01;
            x = 0.1;
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

text(x, y, '400mg/dL glucose at 0mL/min (flow stopped)', 'Color', red, 'FontSize', myTextFont);
text(x, y, '_____________________________________', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, '400mg/dL glucose at 4mL/min (flow pumping)', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '_____________________________________', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, '0mg/dL glucose at 4mL/min (flow pumping)', 'Color', gold, 'FontSize', myTextFont);
text(x, y, '___________________________________', 'Color', gold, 'FontSize', myTextFont);
y = y - deltaY;

if plotOption == 1
    text(x, y, 'o = local peak near 1430cm^-^1', 'Color', black, 'FontSize', myTextFont);
    y = y - deltaY;
    text(x, y, '+ = local peak near 1702cm^-^1', 'Color', black, 'FontSize', myTextFont);
% else
%     text(x, y, '. = peak near 1430cm^-^1/peak near 1702cm^-^1', 'Color', black, 'FontSize', myTextFont);
end

hold off
if gelOption == 1 || gelOption == 3
    title('54nm MBA Au NPs in alginate GOx gel#3 in flowcell with 400mg/dL glucose at various rates', ...
        'FontSize', myTitleFont);
else
    if gelOption == 2 || gelOption == 4
        title('54nm MBA Au NPs in alginate GOx gel#3 in flowcell with stop/start flow', ...
            'FontSize', myTitleFont);
    end
end
myXlabel = sprintf('Time (hours)');
xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
if plotOption == 1
    ylabel('Intensity (A.U.)/Intensity at 1582 cm^-^1 (A.U.)', ...
        'FontSize', myLabelFont); % y-axis label
else
    ylabel('Intensity at 1430cm^-^1(A.U.)/Intensity at 1702cm^-^1(A.U.)', ...
        'FontSize', myLabelFont); % y-axis label
end
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

function g = myPlot(subDirStem, myColor, offset)
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

            % NEW 11/6/2018: since peaks at 1430 and 1702/cm red-, blueshift
            % as function of pH, find the local max in the area
            x1LocalPeak = localPeak(f(x1Min:x1Max));
            x2LocalPeak = localPeak(f(x2Min:x2Max));
            fprintf('local max near 1430/cm is %g\n', x1LocalPeak);
            fprintf('local max near 1702/cm is %g\n', x2LocalPeak);       

            y1(I) = x1LocalPeak/denominator;
            y2(I) = x2LocalPeak/denominator;
            y3(I) = y1(I)/y2(I);

            fclose(fileID);
%             sumY1 = sumY1 + y1(I);
%             sumY2 = sumY2 + y2(I);
        end
    
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
    if plotOption == 1 || plotOption == 3
        plot(t-offset,y1,'-o', 'Color', myColor, 'LineWidth', lineThickness);
        hold on;
        plot(t-offset,y2,'-+', 'Color', myColor, 'LineWidth', lineThickness);
    else
        if plotOption == 2
            plot(t-offset,y3,'-*', 'Color', myColor, 'LineWidth', lineThickness);
        end
    end
    hold on;
    g = 1;
end

function h = localPeak(range)
    h = max(range);
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     