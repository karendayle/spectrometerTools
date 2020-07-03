% Plot pH vs intensity using the calibration curve study data as input.
% Details:
% Get points from files in different directories. 
% Go after just the pH-sensitive part of the spectra.
% Q: How wide is the bandwidth of the area under the curve?
% A: Match it to the range of the BP filters used by the Raman reader.
% Calculate the std dev for each point based on the set of 5 avg*.txt files
% (which are already averages of 5 themselves) and use stddev for error bars
% First, make plots for each of the gels (#17, 18, 19,20) made 6/3/2020
% Dayle Kotturi June 2020, time of COVID

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

global pH
pH = [ 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5 ];

global myX
global myY1
global myY2
global myErr1
global myErr2

% The paths to each hydrogel type and gel number
% This script deals with the four gels made on 6/3/2020 by SP
global dirStem

dirStem1 = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 17\";
dirStem2 = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 18\";
dirStem3 = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 19\";
dirStem4 = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 20\";

% These are common to all gels
subDirStem1 = "calib pH4\1";
subDirStem2 = "calib pH4.5\1";
subDirStem3 = "calib pH5\1";
subDirStem4 = "calib pH5.5\1";
subDirStem5 = "calib pH6\1";
subDirStem6 = "calib pH6.5\1";
subDirStem7 = "calib pH7\1";
subDirStem8 = "calib pH7.5\1";

global lineThickness;
lineThickness = 2;
global numPoints;
numPoints = 1024;
global numPointsEachSide;
numPointsEachSide = 2;

% % Use the index 713 to get the intensity at the reference peak, is COO-
% at 1582/cm. Note that the numPointsEachSide is used to take the area 
% under the curve around the center point xRef
global xRef;
xRef = 713; 
% Use the index 614 to get the intensity at 1430/cm (act. 1428.58/cm)
global x1;
x1 = 614;
% Use the index 794 to get the intensity at 1702/cm (act. 1701.95/cm)
global x2;
x2 = 794;

global xMin;
global xMax;
global yMin;
global yMax;
xMin = 950;
xMax = 1800;
yMin = 0;
yMax = 20.0;
myTextFont = 30;

global myDebug;
myDebug = 0;
 
for J =1:4
    myX = zeros(1, 8, 'double');
    myY1 = zeros(1, 8, 'double');
    myY2 = zeros(1, 8, 'double');
    myErr1 = zeros(1, 8, 'double');
    myErr2 = zeros(1, 8, 'double'); 
    
    switch J
        case 1
            dirStem = dirStem1;
            myTitle = '54nm MBA AuNPs in alginate gel#17 in static buffer for 1 hour';
        case 2
            dirStem = dirStem2;
            myTitle = '54nm MBA AuNPs in PEG gel#18 in static buffer for 1 hour'
        case 3
            dirStem = dirStem3;
            myTitle = '54nm MBA AuNPs in pHEMA gel#19 in static buffer for 1 hour'
        case 4
            dirStem = dirStem4;
            myTitle = '54nm MBA AuNPs in pHEMA/coAc gel#20 in static buffer for 1 hour'
    end
    for K = 1:8
        switch K
            case 1
                pHcolor = black;
                num1 = prepPlotData(subDirStem1, K);
                fprintf('Case 1: %d spectra\n', num1);            
            case 2
                pHcolor = magenta;
                num2 = prepPlotData(subDirStem2, K);
                fprintf('Case 2: %d spectra\n', num2);
            case 3
                pHcolor = cherry;
                num3 = prepPlotData(subDirStem3, K);
                fprintf('Case 3: %d spectra\n', num3);
            case 4
                pHcolor = red;
                num4 = prepPlotData(subDirStem4, K);
                fprintf('Case 4: %d spectra\n', num4);
            case 5
                pHcolor = rust;
                % special case for pHEMA
                if J==3
                    num5 = prepPlotData("calib pH6 repeat2\1", K);
                else
                    num5 = prepPlotData(subDirStem5, K);
                end
                fprintf('Case 5: %d spectra\n', num5);
            case 6
                pHcolor = gold;
                num6 = prepPlotData(subDirStem6, K);
                fprintf('Case 6: %d spectra\n', num6);
            case 7
                pHcolor = green;
                num7 = prepPlotData(subDirStem7, K);
                fprintf('Case 7: %d spectra\n', num7);
            case 8
                pHcolor = ciel;
                num8 = prepPlotData(subDirStem8, K);
                fprintf('Case 8: %d spectra\n', num8);  
        end

    end 
    figure
    errorbar(myX, myY1, myErr1, 'Color', red); % 1430/cm 
    xlim([4 7.5]);
    ylim([0. 0.2]);
    hold on
    errorbar(myX, myY2, myErr2, 'Color', blue); % 1702/cm
    xlim([4 7.5]);
    ylim([0. 0.2]);

    title(myTitle, 'FontSize', myTextFont);
    xlabel('pH', 'FontSize', myTextFont); % x-axis label
    ylabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
    set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
    
    y = 0.18; 
    x = 4.1;
    deltaY = 0.02;
    text(x, y, '1430 cm^-1 peak', 'Color', red, 'FontSize', myTextFont);
    text(x, y, '_____________', 'Color', red, 'FontSize', myTextFont);
    y = y - deltaY;
    text(x, y, '1702 cm^-1 peak', 'Color', blue, 'FontSize', myTextFont);
    text(x, y, '_____________', 'Color', blue, 'FontSize', myTextFont);
    y = y - deltaY;
    myStr = sprintf('using %d points under the each peak',numPointsEachSide * 2 + 1);
    text(x, y, myStr, 'FontSize', myTextFont);
end

function d = getAreaUnderCurve(xCenter, spectrum)
    global numPointsEachSide;
    global numPoints;
    global myDebug;
    % use x as the x-value of the center point of the peak
    % sum the points from x=(xCenter - numPointsIntegrated) to 
    % x=(xCenter + numPointsIntegrated) and then divide by number of
    % points to average and scale it.
    
    if myDebug 
        fprintf('getDenominator with numPointsEachSide = %d\n', ...
            numPointsEachSide);
    end
    
    % check that numPointsIntegrated is in range
    lowEnd = xCenter - numPointsEachSide;
    if (lowEnd < 1) 
        fprintf('low end of number of points integrated is out of range');
    end
    highEnd = xCenter + numPointsEachSide;
    if (highEnd > numPoints)
        fprintf('high end of number of points integrated is out of range');
    end
    
    sum = 0;
    if myDebug 
        fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
            numPointsEachSide);
    end

    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(lowEnd + i - 1);
        if myDebug
            fprintf('index: %d, spectrum: %g\n', i, spectrum(lowEnd + i - 1));
        end
    end
    areaUnderCurve = sum/numPointsToIntegrate; % HERE IS THE SCALING
    if myDebug
        fprintf('areaUnderCurve: %g\n', areaUnderCurve);
    end
    d = areaUnderCurve;
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

function g = prepPlotData(subDirStem, K)
%     global blue
%     global rust
%     global gold
%     global purple
%     global green
%     global ciel
%     global cherry
%     global red
%     global black
    global dirStem
    global numPoints
    global x1
    global x2
    global xRef
    global tRef
    global xMin
    global xMax
    global yMin
    global yMax
    global myDebug
    global lineThickness
    global numPointsEachSide
    global pH
    
    sum1 = 0;
    sum2 = 0;
    sumSq1 = 0;
    sumSq2 = 0;
    thisdata = zeros(2, numPoints, 'double');   
%     str_dir_to_search = dirStem + subDirStem; % args need to be strings
%     dir_to_search = char(str_dir_to_search);
    dir_to_search = dirStem + subDirStem; % this seems to work in 2019
    txtpattern = fullfile(dir_to_search, 'avg*.txt'); % this looks fine
    dinfo = dir(txtpattern); % why is this null array?
    
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
            
            % 1.5 Only consider a narrow band of the spectrum 
            numerator1 = getAreaUnderCurve(x1, f(:));
            numerator2 = getAreaUnderCurve(x2, f(:));

            % 2. Ratiometric
            % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
            % on either side of refWaveNumber. This maps to: 1 - 11 total
            % intensities used to calculate the denominator.
            if (xRef ~= 0) 
                denominator = getAreaUnderCurve(xRef, f(:));
            else
                denominator = 1;
            end
            if myDebug
                fprintf('denominator = %g at index: %d\n', denominator1, xRef);
            end

            % 3. NEW 10/4/18: Normalize what is plotted
            normalized1= numerator1/denominator;
            normalized2= numerator2/denominator;
            
            sum1 = sum1 + normalized1;
            sum2 = sum2 + normalized2;
        end
        
        % calculate average
        avg1 = sum1/numberOfSpectra;
        avg2 = sum2/numberOfSpectra;
        
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
            
            % 1.5 Only consider a narrow band of the spectrum 
            numerator1 = getAreaUnderCurve(x1, f(:));
            numerator2 = getAreaUnderCurve(x2, f(:));   
            % 2. Ratiometric
            % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
            % on either side of refWaveNumber. This maps to: 1 - 11 total
            % intensities used to calculate the denominator.
            if (xRef ~= 0) 
                denominator = getAreaUnderCurve(xRef, f(:));
            else
                denominator = 1;
            end
            if myDebug
                fprintf('denominator = %g at index: %d\n', denominator1, xRef);
            end

            % 3. Normalize what is plotted
            normalized1 = numerator1/denominator;
            normalized2 = numerator2/denominator;
            
            % 4. Add to the sum of the squares
            sumSq1 = sumSq1 + (normalized1 - avg1).^2; 
            sumSq2 = sumSq2 + (normalized2 - avg2).^2; 
        end
        
        % 5. Compute standard deviation at each index of the averaged spectra 
        stdDev1 = sqrt(sumSq1/numberOfSpectra);
        stdDev2 = sqrt(sumSq2/numberOfSpectra);
            
        % Build up arrays to plot later
        global myX
        global myY1
        global myY2
        global myErr1
        global myErr2
        
        myX(K) = pH(K);
        myY1(K) = normalized1;
        myErr1(K) = stdDev1;
        myY2(K) = normalized2;
        myErr2(K) = stdDev2;

        %xlim([xMin xMax]);
        %ylim([yMin yMax]);
        %hold on
        %fprintf('%d\n', I);
        %pause(5);
    end
    g = numberOfSpectra;
end
  