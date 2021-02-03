% varianceUsingRawDynSpectraJB08.m
% Dayle Kotturi Feb 2021

% Sim to varianceUsingRawSpectra7, now do it for the time series values,
% this time parsing the time series data -- at the end of pH4 and pH7 
% segments only. This would change N from 3 series * 3 segments at pH * 1 
% final value = 9 for each peak to N=45. 

% 1. Find the code that retrieved the end values of every pH4 and pH7
% segment in the 12 time series
% 2. Modify this code to read the last 5 spectra instead

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
global dirStem
global subDirStem
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
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0., 0.0, 0.0];
magenta = [1.0, 0.0, 1.0];

pH = [ 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5 ];
numPoints = 1024;
numPointsEachSide = 2;
xRef = 713; % COO- at 1582
% Use the index 614 to get the intensity at 1430/cm (act. 1428.58/cm)
x1 = 614;
% Use the index 794 to get the intensity at 1702/cm (act. 1701.95/cm)
x2 = 794;

% Clean up to begin
close all;

% from JB04
global myTitle
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

global subDir
subDir = [ "1 pH7", "2 pH4", "3 pH10", "4 pH7", "5 pH10","6 pH4", ...
    "7 pH10", "8 pH7", "9 pH4" ];

% TO DO: MORE HERE. Get the end point values for each segment. Instead of 1 single
% value for 1430 and 1702, read in all 5 spectra.

% Use JB07 as skeleton but needs modifying. Instead of 4 gels, 5
% punches, 2 peaks, now there are 4 gels, 3 series, 3 pH levels, 3 segments
% per pH and 2 peaks
for peak = 1:2 % this is outer loop in order to make 1 figure for each pk
    FigH = figure('Position', get(0, 'Screensize'));
    for gel = 1:4
        for pHLevel = 1:3
            % inside prepPlotData, do for all series and all segments
            % Check: should peak really be outside?
            totalNum = prepPlotData(gel, pHLevel, peak);
        end
    end
    xlabel('pH level'); % x-axis label
    ylabel('Normalized Intensity (A.U.)'); % y-axis label
    set(gca,'FontSize',32,'FontWeight','bold','box','off'); % used for title and label
    myTitle = sprintf('gel%d', gel);
    saveMyPlot(FigH, myTitle);
end

function g = prepPlotData(gel, pHLevel, peak)
    global blue
    global rust
    global gold
    global purple
    global green
    global ciel
    global cherry
    global red
    global black
    global dirStem
    global subDirStem
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
    global subDir
    
    % Use pHLevel to get actual segment number from segment
    switch pHLevel
        case 1                 % pH 4
            pHValue = 4;
            pH = [ 2 6 9 ];
        case 2                 % pH 7
            pHValue = 7;
            pH = [ 1 4 8 ];
        case 3                 % pH 10
            pHValue = 10;
            pH = [ 3 5 7 ];
    end
    
    % Important: this avg and std dev calculation is over all 3 segments
    for series = 1:3
        switch gel
            case 1 % alginate
                switch series
                    case 1 % alginate time series 1
                        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch1 flowcell all\";
                        tRef = datenum(2019, 12, 10, 14, 1, 8);
                    case 2  % alginate time series 2
                        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch2 flowcell1 1000ms integ\";
                        tRef = datenum(2020, 1, 10, 13, 45, 1);
                    case 3 % alginate time series 3
                        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch3 flowcell1\";
                        tRef = datenum(2020, 1, 12, 16, 15, 57);
                end
                  
              case 2 % PEG
                  switch series
                      case 1 % PEG time series 1
                          dirStem = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 3\1\";
                          tRef = datenum(2018, 12, 28, 16, 34, 5);
                      case 2 % PEG time series 2
                          dirStem = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 15\";
                            tRef = datenum(2020, 3, 14, 21, 22, 41);
                      case 3 % PEG time series 3
                          dirStem = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 16\punch1 flowcell all\";
                          tRef = datenum(2020, 3, 17, 15, 38, 43);
                  end
                  
            case 3 % pHEMA
                switch series
                    case 1 % pHEMA time series 1
                        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 1\2\";
                        tRef = datenum(2018, 12, 30, 16, 1, 17);
                    case 2 % pHEMA time series 2 -- needs special handling b/c there are
                         % 2 add'l dirs for 3 pH10 and 4 pH7
                         dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\punch1 flowcell1\";
                         tRef = datenum(2020, 1, 25, 17, 10, 17); 
                    case 3 % pHEMA time series 3
                        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\punch2 flowcell1 300ms\";
                        tRef = datenum(2020, 2, 1, 17, 54, 20);
                end
                
            case 4 % pHEMA/coA
                switch series
                    case 1 % pHEMA/coAc  time series 1
                        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 3\4\"; 
                        tRef = datenum(2019, 01, 26, 16, 28, 6);
                        Kmax = 8; % special case b/c final pH4 is missing!
                    case 2 % add pHEMA/coAc  time series 2
                        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\punch1 flowcell1\";
                        tRef = datenum(2020, 1, 27, 12, 27, 47); 
                    case 3 % pHEMA/coAc time series 3
                        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\punch2 flowcell1\";
                        tRef = datenum(2020, 2, 3, 19, 50, 17);
                end
        end

        sum1 = 0;
        sum2 = 0;
        sumSq1 = 0;
        sumSq2 = 0;
        thisdata = zeros(2, numPoints, 'double');
        numberOfSpectraAllSegments = 0;

        for segment = 1:3
            % read the last 5 spectra taken for this segment
            dir_to_search = dirStem + subDir(pH(segment));
            txtpattern = fullfile(dir_to_search, 'spectrum*.txt');
            dinfo = dir(txtpattern); % why is this null array?

            numberOfSpectra = length(dinfo);
            if numberOfSpectra > 0
                % Take only the last 5
                startAtNumber = numberOfSpectra - 4;
                if startAtNumber < 0
                    fprintf('Error: fewer than 5 files found');
                else
                    numberOfSpectraAllSegments = ...
                        numberOfSpectraAllSegments + 5;
                    % first pass on dataset, to get array of average spectra
                    for I = 1 : numberOfSpectra          
                        if I >= startAtNumber
                            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                            fileID = fopen(thisfilename,'r');
                            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
                            fclose(fileID);

                            % ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                            % REFERENCE INDEX

                            % 1. Correct the baseline BEFORE calculating denominator + normalizing
                            % Returns trend as 'e' and baseline corrected signal as 'f'
                            [e, f] = correctBaseline(thisdata(2,:)');  

                            % 1.5 Only consider a narrow band of the spectrum 
                            numerator1 = getAreaUnderCurve(x1, f(:));
                            numerator2 = getAreaUnderCurve(x2, f(:));

                            % 2. Ratiometric
                            % Calculate the denominator using a window of 0 - 5 points
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

                            sum1 = sum1 + normalized1;
                            sum2 = sum2 + normalized2;
                        end
                    end
                end
            end
        end
    end % first pass
      
    % calculate average
    avg1 = sum1/numberOfSpectraAllSegments;
    avg2 = sum2/numberOfSpectraAllSegments;

    % second pass on dataset to get (each point - average)^2
    for series = 1:3
        for segment = 1:3 
            for I = 1 : numberOfSpectra
                % Take only the last 5
                if I >= startAtNumber
                    thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                    fileID = fopen(thisfilename,'r');
                    [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
                    fclose(fileID);

                    % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                    % REFERENCE INDEX

                    % 1. Correct the baseline BEFORE calculating denominator + normalizing
                    % Returns trend as 'e' and baseline corrected signal as 'f'
                    [~, f] = correctBaseline(thisdata(2,:)');  

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
            end
        end
    end
        
    % 5. Compute standard deviation at each index of the averaged spectra 
    stdDev1 = sqrt(sumSq1/numberOfSpectraAllSegments);
    stdDev2 = sqrt(sumSq2/numberOfSpectraAllSegments);

    punchColor = [ red;  blue; green; purple ]; % %TO DO: NOT punches
    markersAll = [ '-o'; '-s';  '-^'; '-p'];
    myX(pHLevel) = pH(segment); % TO DO - sth wrong here. this s/n be pHLevel, but?
    myY1(pHLevel) = normalized1;
    myErr1(pHLevel) = stdDev1;
    myY2(pHLevel) = normalized2;
    myErr2(pHLevel) = stdDev2;

    switch peak
        case 1
            % part 1: do the 1430 cm-1 plot 6/30/2020: don't color based on
            % 'K'. Color based on punch number.
            plot(myX(pHLevel), myY1(pHLevel), markersAll(gel,:), 'LineStyle','none', 'MarkerSize', ...
            30, 'Color', punchColor(gel,:), 'linewidth', 2); 
            hold on
            % https://blogs.mathworks.com/pick/2017/10/13/labeling-data-points/
            %labelpoints(myX(K), myY1(K), labels(M),'SE',0.2,1)
            %hold on
            errorbar(myX(pHLevel), myY1(pHLevel), myErr1(pHLevel), 'LineStyle','none', ...
            'Color', black, 'linewidth', 2);
            hold on
    
        case 2
            % part 2: do the 1702 cm-1 plot
            plot(myX(pHLevel), myY2(pHLevel), markersAll(gel,:), 'LineStyle','none', 'MarkerSize', ...
                30, 'Color', punchColor(gel,:), 'linewidth', 2); 
            hold on
            errorbar(myX(pHLevel), myY2(pHLevel), myErr2(pHLevel), 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on
    end
    
    switch peak
        case 1
            fprintf('gel%d: seg%d: pk:1430 N=%d avg=%f stddev=%f\n', ...
                gel, pHValue, numberOfSpectraAllSegments, myY1(pHLevel), myErr1(pHLevel));
        case 2
            fprintf('gel%d: seg%d: pk:1702 N=%d avg=%f stddev=%f\n', ...
                gel, pHValue, numberOfSpectraAllSegments, myY2(pHLevel), myErr2(pHLevel));  
    end
    g = numberOfSpectraAllSegments;
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
    
    % check length of spectrum
    % This is a bit late to be checking this, but it's really just
    % an extra caution in case spectrum < 1024 points, which should
    % never be the case unless data collected was interrupted.
    if length(spectrum) < (lowEnd + numPointsToIntegrate - 1)
        fprintf('length of spectrum is %d', length(spectrum));
    else
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

function g = saveMyPlot(FigH, myTitle)
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlot = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlot, 'png');
    g = 1;
end

