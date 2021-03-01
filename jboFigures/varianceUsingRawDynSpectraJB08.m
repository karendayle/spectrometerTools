% varianceUsingRawDynSpectraJB08.m
% Dayle Kotturi Feb 2021

% Sim to varianceUsingRawSpectra7, now do it for the time series values,
% this time parsing the time series data -- at the end of pH4 and pH7 
% segments only. This would change N from 3 series * 3 segments at pH * 1 
% final value = 9 for each peak to N=45. 

% 1. Find the code that retrieved the end values of every pH4 and pH7
% segment in the 12 time series
% 2. Modify this code to read the last 5 spectra instead

global inputOption
% CHOOSE one of these
inputOption = 1; % use spectrum*.txt files as input
%inputOption = 2; % use av
global green
global ciel
global cherry
global red
global black
global magenta
global numPoints
global x1
global x2
global xRef
global numPointsEachSide
global endVals

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

global dirStem
dirStem = [ ...
    "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch1 flowcell all\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch2 flowcell1 1000ms integ\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch3 flowcell1\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 3\1\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 15\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 16\punch1 flowcell all\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 1\2\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\punch1 flowcell1\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\punch2 flowcell1 300ms\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 3\4\", ... 
    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\punch1 flowcell1\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\punch2 flowcell1\" ];

global subDir
subDir = [ "1 pH7", "2 pH4", "3 pH10", "4 pH7", "5 pH10","6 pH4", ...
    "7 pH10", "8 pH7", "9 pH4" ];

% Based on JB07 but modified. Instead of 4 gels, 5 punches per gel and 
% 2 peaks per punch, now there are 4 gels, 3 series per gel, 3 pH levels 
% per series, 3 segments per pH level and 2 peaks per segment
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
    % set(gca,'FontSize',32,'FontWeight','bold','box','off'); % used for title and label
    set(gca,'FontSize',32, 'box', 'off'); % 2021/02/17 rm bold
    myTitle = sprintf('gel%d', gel);
    saveMyPlot(FigH, myTitle);
    switch inputOption
        case 1
            save('Data\endValsRaw.mat', 'endVals');
        case 2
            save('Data\endValsAvgs.mat', 'endVals');
    end
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
    global numPoints
    global x1
    global x2
    global xRef
    global myDebug
    global subDir
    global endVals
    global inputOption
    
    % fprintf('top: gel%d, pHLevel%d, peak%d\n', gel, pHLevel, peak);
    
    % Use pHLevel to get actual segment number from segment
    switch pHLevel
        case 1 % pH 4
            pHValue = 4;
            pHSegments = [ 2 6 9 ];
        case 2 % pH 7
            pHValue = 7;
            pHSegments = [ 1 4 8 ];
        case 3 % pH 10
            pHValue = 10;
            pHSegments = [ 3 5 7 ];
    end
    
    sum1 = 0;
    sum2 = 0;
    sumSq1 = 0;
    sumSq2 = 0;
    thisdata = zeros(2, numPoints, 'double');
    numberOfSpectraAllSegments = 0;
    % fprintf('RESET numberOfSpectraAllSeqments = %d\n', ...
    %     numberOfSpectraAllSegments);
    
    % Important: this avg and std dev calculation is over all 3 segments
    % first pass
    for series = 1:3
        % fprintf('series%d pass1\n', series);
        
        for segment = 1:3
            offset = (gel - 1) * 3 + series;
            % fprintf('\tsegment%d\n', segment);
            % read the last 5 spectra taken for this segment
            dir_to_search = dirStem(offset) + subDir(pHSegments(segment));
            % txtpattern = fullfile(dir_to_search, 'spectrum*.txt');
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern); % why is this null array?

            numberOfSpectra = length(dinfo);
            if numberOfSpectra > 0
                % Take only the last 5 values for each segment. 
                % Instead of 1 single value for 1430 and 1702, 
                % read in all 5 spectra.
                switch inputOption
                    case 1
                        offset = 4; % when using spectrum*.txt
                    case 2
                        offset = 0; % when using avg*.txt
                end
                startAtNumber = numberOfSpectra - offset;
                if startAtNumber < 0
                    fprintf('Error: fewer than 5 files found');
                else
                    switch inputOption
                        case 1
                            addition = 5; % when using spectrum*.txt
                        case 2
                            addition = 1; % when using avg*.txt
                    end
                    numberOfSpectraAllSegments = ...
                        numberOfSpectraAllSegments + addition;
                    % fprintf('\t\tnumberOfSpectraAllSeqments = %d\n', ...
                    %     numberOfSpectraAllSegments);
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
                            % Check for error code -1
                            numerator1 = getAreaUnderCurve(x1, f(:));
                            numerator2 = getAreaUnderCurve(x2, f(:));

                            % 2. Ratiometric
                            % Calculate the denominator using a window of 0 - 5 points
                            % on either side of refWaveNumber. This maps to: 1 - 11 total
                            % intensities used to calculate the denominator.
                            if (xRef ~= 0) 
                                denominator = getAreaUnderCurve(xRef, f(:));
                                % Check for error code -1
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
        % fprintf('series%d pass2\n', series);
        for segment = 1:3 
            % fprintf('\tsegment%d\n', segment);
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
                    % Check for error code -1
                    numerator1 = getAreaUnderCurve(x1, f(:));
                    numerator2 = getAreaUnderCurve(x2, f(:));   
                    % 2. Ratiometric
                    % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                    % on either side of refWaveNumber. This maps to: 1 - 11 total
                    % intensities used to calculate the denominator.
                    if (xRef ~= 0) 
                        denominator = getAreaUnderCurve(xRef, f(:));
                        % Check for error code -1
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
    end % second pass
        
    % 5. Compute standard deviation at each index of the averaged spectra 
    stdDev1 = sqrt(sumSq1/numberOfSpectraAllSegments);
    stdDev2 = sqrt(sumSq2/numberOfSpectraAllSegments);

    % 6. Plot results for this gel, pH level and peak
    punchColor = [ red;  blue; green; purple ]; % %TO DO: NOT punches
    markersAll = [ '-o'; '-s';  '-^'; '-p'];
    myX(pHLevel) = pHValue; % TO DO - sth wrong here. this s/n be pHLevel, but?
    myY1(pHLevel) = normalized1;
    myErr1(pHLevel) = stdDev1;
    myY2(pHLevel) = normalized2;
    myErr2(pHLevel) = stdDev2;

    switch peak
        case 1
            % 1430 cm-1
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
            % 1702 cm-1
            plot(myX(pHLevel), myY2(pHLevel), markersAll(gel,:), 'LineStyle','none', 'MarkerSize', ...
                30, 'Color', punchColor(gel,:), 'linewidth', 2); 
            hold on
            errorbar(myX(pHLevel), myY2(pHLevel), myErr2(pHLevel), 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on
    end
    
    switch peak
        case 1
            % NEW 2021/02/03  
            endVals(gel, pHLevel, peak, 1) = myY1(pHLevel);
            endVals(gel, pHLevel, peak, 2) = myErr1(pHLevel);
            endVals(gel, pHLevel, peak, 3) = numberOfSpectraAllSegments;
            fprintf('gel%d: pHLevel%d: pk:1430 N=%d avg=%f stddev=%f\n', ...
                gel, pHLevel, numberOfSpectraAllSegments, myY1(pHLevel), myErr1(pHLevel));
            fprintf('%f\n', myErr1(pHLevel));
        case 2
            % NEW 2021/02/03  
            endVals(gel, pHLevel, peak) = myY2(pHLevel);
            endVals(gel, pHLevel, peak, 2) = myErr2(pHLevel);
            endVals(gel, pHLevel, peak, 3) = numberOfSpectraAllSegments;
            fprintf('gel%d: pHLevel%d: pk:1702 N=%d avg=%f stddev=%f\n', ...
                gel, pHLevel, numberOfSpectraAllSegments, myY2(pHLevel), myErr2(pHLevel));
            fprintf('%f\n', myErr2(pHLevel));
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
        fprintf('Error: length of spectrum is %d', length(spectrum));
        d = -1;
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

