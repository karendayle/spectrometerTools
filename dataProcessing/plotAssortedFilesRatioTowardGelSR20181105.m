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
%dirStem = "H:\Documents\Data\Made by Sureyya\Toward the gel\";
%dirStem = "Z:\Documents\Data\Made by Sureyya\Toward the gel\"; % Analyzing using remote Matlab client
dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Toward the gel\";
subDirStem1 = "NPs in wellplate";
subDirStem2 = "NPs pH4 in wellplate";
subDirStem3 = "NPs pH7 in wellplate";
subDirStem4 = "NPs pH10 in wellplate";
subDirStem5 = "Just MCs";

global numPoints;
numPoints = 1024;

thisData1 = zeros(2, numPoints, 'double');
thisData2 = zeros(2, numPoints, 'double');
thisData3 = zeros(2, numPoints, 'double');
thisData4 = zeros(2, numPoints, 'double');
thisData5 = zeros(2, numPoints, 'double');

global xRef;
xRef = 713; % index where the reference peak is 
                % COO- at 1582
                % TO DO: read from avg*.txt file

thisdata1 = zeros(2, numPoints, 'double');

global offset;
offset = 300;

global xMin;
global xMax;
global yMin;
global yMax;
xMin = 950;
xMax = 2000;
yMin = 0;
yMax = 1.5;
myFont = 30;

global myDebug;
myDebug = 0;

figure 

for K = 2:4
    switch K
        case 1
            %xRef = 409; % default
            pHcolor = black;
            num1 = myPlot(subDirStem1, thisData1, pHcolor);
            fprintf('Case 1: %d spectra plotted in black\n', num1);
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
            pHcolor = blue;
            num4 = myPlot(subDirStem4, thisData4, pHcolor);
            fprintf('Case 4: %d spectra plotted in blue\n', num4);
        case 5
            pHcolor = rust;
            num5 = myPlot(subDirStem5, thisData5, pHcolor);
            fprintf('Case 5: %d spectra plotted in rust\n', num5);
        case 6
            pHcolor = blue;
            num6 = myPlot(subDirStem6, thisData6, pHcolor);
            fprintf('Case 6: %d spectra plotted in blue\n', num6);
    end
end    

% TO DO: figure out the coords for labels from the data
y = 1.3;
x = 1710;
deltaY = 0.1;
deltaX = 80;
text(x, y, 'pH 4', 'Color', red);
text(x, y, '_____', 'Color', red);
text(x + deltaX, y, 'Laser Power = 0.375 Max');
y = y - deltaY;
text(x, y, 'pH 7', 'Color', green);
text(x, y, '_____', 'Color', green);
text(x + deltaX, y, '5 second integration time per acq');
y = y - deltaY;
text(x, y, 'pH 10', 'Color', blue);
text(x, y, '_____', 'Color', blue);
text(x + deltaX, y, 'Each spectra average of 5 acqs');
y = y - deltaY;
text(x, y, 'no buffer', 'Color', black);
text(x, y, '_____', 'Color', black);
y = y - deltaY;
text(x, y, 'in uCapsules', 'Color', rust);
text(x, y, '_____', 'Color', rust);

hold off
title('Ratiometric continuous real-time of sample 54 nm spheres', 'FontSize', myFont);
xlabel('Wavenumber (cm^-^1)', 'FontSize', myFont); % x-axis label
ylabel('Arbitrary Units (A.U.)/Intensity at 1582 cm^-^1 (A.U.)', 'FontSize', myFont); % y-axis label
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
    global offset;
    global xMin;
    global xMax;
    global yMin;
    global yMax;
    global myDebug;
        
    str_dir_to_search = dirStem + subDirStem; % args need to be strings
    dir_to_search = char(str_dir_to_search);
    txtpattern = fullfile(dir_to_search, 'avg*.txt');
    dinfo = dir(txtpattern); 
    
    numberOfSpectra = length(dinfo);
      
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
        end
        if myDebug
            fprintf('denominator = %g at index: %d\n', denominator1, xRef);
        end
          
        % 3. NEW 10/4/18: Normalize what is plotted
        normalized = f/denominator1;
          
        % change to plot starting at index 400
        %plot the trend: 
        %plot(thisdata1(1,offset:end), f(offset:end), 'Color', red);
        %plot(thisdata1(1,offset:end), e(offset:end), 'cyan');
        %plot(thisdata1(1,offset:end), normalized(offset:end), 'Color', blue);
        % plot just the corrected signal
        plot(thisdata(1,offset:end), normalized(offset:end), 'Color', myColor);
        xlim([xMin xMax]);
        ylim([yMin yMax]);
        hold on
        fprintf('%d\n', I);
        %pause(1);
        newColor = myColor - [0.005*I, 0., 0.];
        if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
            lineColor = newColor;
        end
    end
    g = numberOfSpectra;
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  