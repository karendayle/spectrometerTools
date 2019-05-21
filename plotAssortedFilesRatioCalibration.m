% Plot files in different directories
% Dayle Kotturi January 2019

% Colors:
global black;
global purple;
global blue;
global ciel;
global green;
global rust;
global gold;
global red;
global cherry;
global magenta;

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

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
global dirStem
%dirStem = "H:\Documents\Data\Made by Sureyya\Alginate\gel 4\calibration\";
%subDirStem1 = "1 pH4";
%subDirStem2 = "2 pH7";
%subDirStem3 = "3 pH3.5";
%subDirStem4 = "4 pH3.0";
%subDirStem5 = "5 pH4.5";
%subDirStem6 = "6 pH5.0";
%subDirStem7 = "7 pH5.5";
%subDirStem8 = "8 pH6.0";
%subDirStem9 = "8a pH6.5";
%subDirStem10 = "9 pH7.5";

%dirStem = "H:\Documents\Data\Made by Sureyya\Alginate\gel 4\calibration3\";
%subDirStem1 = "1 pH4";
%subDirStem2 = "2 pH7";
%subDirStem3 = "3 pH10";
%subDirStem4 = "4 pH8";
%subDirStem5 = "5 pH5";
%subDirStem6 = "6 pH3";
%subDirStem7 = "7 pH6";
%subDirStem8 = "8 pH9";

%dirStem = "H:\Documents\Data\Made by Sureyya\PEG\gel 3\calibration-merge 2-4\";
%subDirStem1 = "1 pH4";
%subDirStem2 = "2 pH7";
%subDirStem3 = "3 pH10 again";
%subDirStem4 = "4 pH8 25 msmts before abort";
%subDirStem5 = "5 pH5";
%subDirStem6 = "6 pH3";
%subDirStem7 = "7 pH6";
%subDirStem8 = "8 pH9";

%dirStem = "H:\Documents\Data\Made by Sureyya\pHEMA\gel 2\calibration2\";
%subDirStem1 = "1 pH4";
%subDirStem2 = "2 pH7";
%subDirStem3 = "3 pH10";
%subDirStem4 = "4 pH8";
%subDirStem5 = "5 pH5";
%subDirStem6 = "6 pH3";
%subDirStem7 = "7 pH6";
%subDirStem8 = "8 pH9";

dirStem = "H:\Documents\Data\Made by Sureyya\pHEMA coAcrylamide\gel 3\calibration\";
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

global numPoints;
numPoints = 1024;

global xRef;
xRef = 713; % index where the reference peak is 
                % COO- at 1582
                % TO DO: read from avg*.txt file

global offset;
offset = 300;

global xMin;
global xMax;
global yMin;
global yMax;
xMin = 950;
xMax = 1800;
yMin = 0;
yMax = 20.0;
myFont = 30;
myTextFont = 32;

global myDebug;
myDebug = 0;

figure 

%for K = 1:9
for K = 1:8
    switch K
        %case 1 % pH4
        %    pHcolor = red;
        %    num1 = myPlot(subDirStem1, pHcolor);
        %    fprintf('Case 1: %d spectra plotted in red\n', num1);
        %case 2 % pH7
        %    pHcolor = green;
        %    num2 = myPlot(subDirStem2, pHcolor);
        %    fprintf('Case 2: %d spectra plotted in green\n', num2);            
        %case 3 % pH3.5
        %    pHcolor = cherry;
        %    num3 = myPlot(subDirStem3, pHcolor);
        %    fprintf('Case 3: %d spectra plotted in cherry\n', num3);
        %case 4 % pH3.0
        %    pHcolor = magenta;
        %    num4 = myPlot(subDirStem4, pHcolor);
        %    fprintf('Case 4: %d spectra plotted in magenta\n', num4);
        %case 5 % pH4.5
        %    pHcolor = gold;
        %    num5 = myPlot(subDirStem5, pHcolor);
        %    fprintf('Case 5: %d spectra plotted in gold\n', num5);            
        %case 6 % pH5.0
        %    pHcolor = rust;
        %    num6 = myPlot(subDirStem6, pHcolor);
        %    fprintf('Case 6: %d spectra plotted in rust\n', num6);
        %case 7 % pH 5.5
        %    pHcolor = black;
        %    num7 = myPlot(subDirStem7, pHcolor);
        %    fprintf('Case 7: %d spectra plotted in black\n', num7);
        %case 8 % pH 6.0
        %    pHcolor = purple;
        %    num8 = myPlot(subDirStem8, pHcolor);
        %    fprintf('Case 8: %d spectra plotted in purple\n', num8);            
        %case 9 % pH6.5
        %    pHcolor = ciel;
        %    num9 = myPlot(subDirStem9, pHcolor);
        %    fprintf('Case 9: %d spectra plotted in ciel\n', num9);
        %case 10 % pH7.5
        %    pHcolor = blue;
        %    num10 = myPlot(subDirStem10, pHcolor);
        %    fprintf('Case 10: %d spectra plotted in blue\n', num10);
                       
        case 1 % pH4
            pHcolor = red;
            num1 = myPlot(subDirStem1, pHcolor);
            fprintf('Case 1: %d spectra plotted in red\n', num1);
        case 2 % pH7
            pHcolor = green;
            num2 = myPlot(subDirStem2, pHcolor);
            fprintf('Case 2: %d spectra plotted in green\n', num2);            
        case 3 % pH10
            pHcolor = purple;
            num3 = myPlot(subDirStem3, pHcolor);
            fprintf('Case 3: %d spectra plotted in purple\n', num3);
        case 4 % pH8
            pHcolor = ciel;
            num4 = myPlot(subDirStem4, pHcolor);
            fprintf('Case 4: %d spectra plotted in ciel\n', num4);
        case 5 % pH5
            pHcolor = rust;
            num5 = myPlot(subDirStem5, pHcolor);
            fprintf('Case 5: %d spectra plotted in rust\n', num5);            
        case 6 % pH3
            pHcolor = cherry;
            num6 = myPlot(subDirStem6, pHcolor);
            fprintf('Case 6: %d spectra plotted in cherry\n', num6);
        case 7 % pH6
            pHcolor = gold;
            num7 = myPlot(subDirStem7, pHcolor);
            fprintf('Case 7: %d spectra plotted in gold\n', num7);
        case 8 % pH9
            pHcolor = blue;
            num8 = myPlot(subDirStem8, pHcolor);
            fprintf('Case 8: %d spectra plotted in blue\n', num8);
    end
    pause(1);
end    

% TO DO: figure out the coords for labels from the data
%y = 1.95; %pHEMA
y = 1.1; %alginate, PEG, pHEMA coAc
x = 1700; %pHEMA
deltaY = 0.1; %alginate, PEG, pHEMA coAc
%deltaY = 0.2; %pHEMA
deltaX = 100;

text(x, y, 'pH10', 'Color', purple, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', purple, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH9', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH8', 'Color', ciel, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', ciel, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH7', 'Color', green, 'FontSize', myTextFont);
text(x, y, '____', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH6', 'Color', gold, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', gold, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH5', 'Color', rust, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', rust, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH4', 'Color', red, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH3', 'Color', cherry, 'FontSize', myTextFont);
text(x, y, '_____', 'Color', cherry, 'FontSize', myTextFont);
y = y - deltaY;
hold off

%title('86 nm spheres in microcapsules in alginate in flow cell');
%title('86 nm spheres in microcapsules in PEG in flow cell');
%title('86 nm spheres in microcapsules in pHEMA in flow cell');
title('86 nm spheres in microcapsules in pHEMA coAc in flow cell');

xlabel('Wavenumber (cm^-^1)'); % x-axis label
ylabel('Normalized Intensity (A.U.)'); % y-axis label
set(gca,'FontSize',32,'FontWeight','bold','box','off'); % used for title and label
% Plot each spectrum (intensity vs wavenumber in a new color overtop

function d = getDenominator(closestRef, numPointsEachSide, numPoints, spectrum)
    global myDebug
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

function g = myPlot(subDirStem, myColor)
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
    global x1;
    global x2;
    global xRef;
    global tRef;
    global offset;
    global xMin;
    global xMax;
    global yMin;
    global yMax;
    global myDebug;
    global lineThickness;
    
    sum = zeros(1, numPoints, 'double');
    avg = zeros(1, numPoints, 'double');
    sumSq = zeros(1, numPoints, 'double');
    thisdata = zeros(2, numPoints, 'double');   
    str_dir_to_search = dirStem + subDirStem; % args need to be strings
    dir_to_search = char(str_dir_to_search);
    txtpattern = fullfile(dir_to_search, 'avg*.txt');
    dinfo = dir(txtpattern); 
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');    

            % 2. Ratiometric
            % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
            % on either side of refWaveNumber. This maps to: 1 - 11 total
            % intensities used to calculate the denominator.
            if (xRef ~= 0) 
                numPointsEachSide = 2;
                denominator1 = getDenominator(xRef, numPointsEachSide, ...
                    numPoints, f(:));
            else
                denominator1 = 1;
            end
            if myDebug
                fprintf('denominator = %g at index: %d\n', denominator1, xRef);
            end

            % 3. NEW 10/4/18: Normalize what is plotted
            normalized = f/denominator1;
            
            sum = sum + normalized;
        end
        
        % calculate average
        avg = sum/numberOfSpectra;
        
        % second pass on dataset to get (each point - average)^2
        % for standard deviation, need 
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');    

            % 2. Ratiometric
            % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
            % on either side of refWaveNumber. This maps to: 1 - 11 total
            % intensities used to calculate the denominator.
            if (xRef ~= 0) 
                numPointsEachSide = 2;
                denominator1 = getDenominator(xRef, numPointsEachSide, ...
                    numPoints, f(:));
            else
                denominator1 = 1;
            end
            if myDebug
                fprintf('denominator = %g at index: %d\n', denominator1, xRef);
            end

            % 3. Normalize what is plotted
            normalized = f/denominator1;
            
            % 4. Add to the sum of the squares
            sumSq = sumSq + (normalized - avg).^2; 
        end
        
        % 5. Compute standard deviation at each index of the averaged spectra 
        stdDev = sqrt(sumSq/numberOfSpectra);
            
        % plot the corrected signal
        plot(thisdata(1,offset:end), normalized(offset:end), 'Color', myColor, ...
            'LineWidth', lineThickness);
        
        % 11/6/2018 Not needed after all
        % Now plot stdDev as the array of error bars on the plot...    
        %errorbar(thisdata(1,offset:end), normalized(offset:end), ...
        %    stdDev(offset:end), 'Color', myColor);
        xlim([xMin xMax]);
        %ylim([yMin yMax]);
        hold on
        fprintf('%d\n', I);
        %pause(1);
    end
    g = numberOfSpectra;
end
  