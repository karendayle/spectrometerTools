% Plot files in different directories
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
global black;
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0., 0.0, 0.0];

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
global dirStem
dirStem = "H:\Documents\Data\Made by Sureyya\PEG\gel 3\TrizPHOnQuartz\";
%dirStem = "Z:\Documents\Data\Made by Sureyya\PEG\gel 3\TrizPHOnQuartz\"; % Analyzing using remote Matlab client
subDirStem1 = "1 pH4";
subDirStem2 = "2 pH7";
subDirStem3 = "3 pH10";

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
myTextFont = 15;

global myDebug;
myDebug = 0;

figure 

for K = 1:3
    switch K
        case 1
            pHcolor = red;
            num1 = myPlot(subDirStem1, pHcolor);
            fprintf('Case 1: %d spectra plotted in red\n', num1);
        case 2
            pHcolor = green;
            num2 = myPlot(subDirStem2, pHcolor);
            fprintf('Case 2: %d spectra plotted in green\n', num2);            
        case 3
            pHcolor = blue;
            num3 = myPlot(subDirStem3, pHcolor);
            fprintf('Case 3: %d spectra plotted in blue\n', num3);
    end
end    

% TO DO: figure out the coords for labels from the data
y = 1.1;
x = 1200;
deltaY = 0.1;
deltaX = 100;
text(x, y, 'pH4', 'Color', red, 'FontSize', myTextFont);
text(x, y, '___', 'Color', red, 'FontSize', myTextFont);
text(x + deltaX, y, 'Laser Power = 19.4 mW', 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH7', 'Color', green, 'FontSize', myTextFont);
text(x, y, '___', 'Color', green, 'FontSize', myTextFont);
text(x + deltaX, y, '5 second integration time per acq', 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pH10', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '____', 'Color', blue);
text(x + deltaX, y, 'Each spectra average of 5 acqs', 'FontSize', myTextFont);
y = y - deltaY;
%text(x, y, 'four', 'Color', black, 'FontSize', myTextFont);
%text(x, y, '_____', 'Color', black, 'FontSize', myTextFont);
text(x + deltaX, y, 'Normalized using 5 points around ref peak', 'FontSize', myTextFont);
y = y - deltaY;
text(x + deltaX, y, 'Displaying average spectrum', 'FontSize', myTextFont);

hold off
title('PEG gel 3 with 3X MCs and NPs on quartz', 'FontSize', myFont);
xlabel('Wavenumber (cm^-^1)', 'FontSize', myFont); % x-axis label
ylabel('Intensity (A.U.)/Intensity at 1582 cm^-^1 (A.U.)', ...
    'FontSize', myLabelFont); % y-axis label
set(gca,'FontSize',16,'FontWeight','bold','box','off')
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
  