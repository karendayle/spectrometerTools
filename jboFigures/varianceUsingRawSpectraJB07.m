% varianceUsingRawSpectraJB07.m
% Dayle Kotturi Jan 2021

% For the intensity vs pH plots of 4 types of gels in static solution,
% which are also used by JB05 script to compare static vs dynamic results,
% let's see how small the std dev is when calculated using the full set
% of raw spectra. Note: there may be some confusion around this but here
% there is nothing re: 95% CI being used for the error bars. 

% 1. Repeat for all gel types
% 2.    At each pH level
% 3.        Zero the sums
% 4.        For each of 5 punches
% 5.            Read in all spectra (25), "spectrum = raw - dark"
% 6.            Add spectrum to running sum
% 7.            Add spectrum^2 to running sum of sqs
% 8.      Calculate std dev from sum, sum of sqs and N=125

% Note: the figs produced by this script aren't imported into JBO docx or
% the Supp Mat. If they need to be, then the legend (see JB02 figs7 and 8)
% could be added to define the symbols. Also range s/b changed to be 3.5-8

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
% 2021/02/12 NEW save the arrays of averages and standard devs
% for all gel types, J, so that plotSteadyandDynStatesJB05 
% can read these values in
global myAlgY1AllPunches
global myAlgY1AllPunchesStdDev
global myAlgY2AllPunches
global myAlgY2AllPunchesStdDev
global myPEGY1AllPunches
global myPEGY1AllPunchesStdDev
global myPEGY2AllPunches
global myPEGY2AllPunchesStdDev
global myHEMAY1AllPunches
global myHEMAY1AllPunchesStdDev
global myHEMAY2AllPunches
global myHEMAY2AllPunchesStdDev
global myHEMACoY1AllPunches
global myHEMACoY1AllPunchesStdDev
global myHEMACoY2AllPunches
global myHEMACoY2AllPunchesStdDev

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

close all;

dirStem = [ ...
    "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 17\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 18\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 19\", ...
    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 20\" ...
    ];  

subDirStem = [ ...
    "pH4 punch", "pH4.5 punch", "pH5 punch", ...
    "pH5.5 punch", "pH6 punch", "pH6.5 punch", ...
    "pH7 punch", "pH7.5 punch" ...
    ];

for peak = 1:2 % this is outer loop in order to make 1 figure for each pk
    FigH = figure('Position', get(0, 'Screensize'));
    for gel = 1:4
        for pHLevel = 1:8
            % read 25 spectra, the full set used to create 5 avgs
            % note 1 spectrum = raw - dark
            totalNum = prepPlotData(gel, pHLevel, peak);
        end
    end
    xlabel('pH level'); % x-axis label
    ylabel('Normalized Intensity (A.U.)'); % y-axis label
    % set(gca,'FontSize',32,'FontWeight','bold','box','off'); % used for title and label
    set(gca,'FontSize',32,'box','off'); % 2021/02/17 rm bold
    %saveMyPlot(FigH, myTitle); 2021/02/27 myTitle is undefined
end

% 2021/02/12 NEW save the arrays of averages and standard devs
% for all gel types, J, so that plotSteadyandDynStatesJB05 
% can read these values in. TO DO: record N
saveMyData();

function g = prepPlotData(J, K, peak)
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
    
    sum1 = 0;
    sum2 = 0;
    sumSq1 = 0;
    sumSq2 = 0;
    thisdata = zeros(2, numPoints, 'double');
    numberOfSpectraAllPunches = 0;
    
    % Important: this avg and std dev calculation is over all 5 punches,
    for punch = 1:5
        subDir = sprintf('%s%d/1/', subDirStem(K), punch);
        dir_to_search = dirStem(J) + subDir; % this seems to work in 2019
        txtpattern = fullfile(dir_to_search, 'spectrum*.txt'); % this looks fine
        dinfo = dir(txtpattern); % why is this null array?

        numberOfSpectra = length(dinfo);
        if numberOfSpectra > 0
            if numberOfSpectra > 25
                fprintf('punch%d has %d spectra\n', punch, numberOfSpectra);
            end
            numberOfSpectraAllPunches = numberOfSpectraAllPunches + numberOfSpectra;
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
        end
    end % first pass for all five punches
        
    % calculate average
    avg1 = sum1/numberOfSpectraAllPunches;
    avg2 = sum2/numberOfSpectraAllPunches;

    for punch = 1:5
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
        
    % 5. Compute standard deviation at each index of the averaged spectra 
    stdDev1 = sqrt(sumSq1/numberOfSpectraAllPunches);
    stdDev2 = sqrt(sumSq2/numberOfSpectraAllPunches);

    punchColor = [ red;  blue; green; purple ];
    markersAll = [ '-o'; '-s';  '-^'; '-p'];
    myX(K) = pH(K);
    myY1(K) = normalized1;
    myErr1(K) = stdDev1;
    myY2(K) = normalized2;
    myErr2(K) = stdDev2;
    
    % 2021/02/12 NEW save the arrays of averages and standard devs
    % for all gel types, J, so that plotSteadyandDynStatesJB05 
    % can read these values in
    global myAlgY1AllPunches
    global myAlgY1AllPunchesStdDev
    global myAlgY2AllPunches
    global myAlgY2AllPunchesStdDev
    global myPEGY1AllPunches
    global myPEGY1AllPunchesStdDev
    global myPEGY2AllPunches
    global myPEGY2AllPunchesStdDev
    global myHEMAY1AllPunches
    global myHEMAY1AllPunchesStdDev
    global myHEMAY2AllPunches
    global myHEMAY2AllPunchesStdDev
    global myHEMACoY1AllPunches
    global myHEMACoY1AllPunchesStdDev
    global myHEMACoY2AllPunches
    global myHEMACoY2AllPunchesStdDev   
    
    switch J
        case 1
            myAlgY1AllPunches(K) = myY1(K);
            myAlgY1AllPunchesStdDev(K)  = myErr1(K);
            myAlgY2AllPunches(K) = myY2(K);
            myAlgY2AllPunchesStdDev(K)  = myErr2(K);
        case 2
            myPEGY1AllPunches(K) = myY1(K);
            myPEGY1AllPunchesStdDev(K)  = myErr1(K);
            myPEGY2AllPunches(K) = myY2(K);
            myPEGY2AllPunchesStdDev(K)  = myErr2(K);
        case 3
            myHEMAY1AllPunches(K) = myY1(K);
            myHEMAY1AllPunchesStdDev(K)  = myErr1(K);
            myHEMAY2AllPunches(K) = myY2(K);
            myHEMAY2AllPunchesStdDev(K)  = myErr2(K);
        case 4
            myHEMACoY1AllPunches(K) = myY1(K);
            myHEMACoY1AllPunchesStdDev(K)  = myErr1(K);
            myHEMACoY2AllPunches(K) = myY2(K);
            myHEMACoY2AllPunchesStdDev(K)  = myErr2(K);    
    end

    switch peak
        case 1
            % part 1: do the 1430 cm-1 plot 6/30/2020: don't color based on
            % 'K'. Color based on punch number.
            plot(myX(K), myY1(K), markersAll(J,:), 'LineStyle','none', 'MarkerSize', ...
            30, 'Color', punchColor(J,:), 'linewidth', 2); 
            hold on
            % https://blogs.mathworks.com/pick/2017/10/13/labeling-data-points/
            %labelpoints(myX(K), myY1(K), labels(M),'SE',0.2,1)
            %hold on
            errorbar(myX(K), myY1(K), myErr1(K), 'LineStyle','none', ...
            'Color', black, 'linewidth', 2);
            hold on
    
        case 2
            % part 2: do the 1702 cm-1 plot
            plot(myX(K), myY2(K), markersAll(J,:), 'LineStyle','none', 'MarkerSize', ...
                30, 'Color', punchColor(J,:), 'linewidth', 2); 
            hold on
            errorbar(myX(K), myY2(K), myErr2(K), 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on
    end
    
    switch peak
        case 1
            %fprintf('gel%d: pH%f: pk:1430 N=%d avg=%f stddev=%f\n', ...
            %    J, pH(K), numberOfSpectraAllPunches, myY1(K), myErr1(K));
            fprintf('%f\n', myErr1(K));
        case 2
            %fprintf('gel%d: pH%f: pk:1702 N=%d avg=%f stddev=%f\n', ...
            %    J, pH(K), numberOfSpectraAllPunches, myY2(K), myErr2(K));
            fprintf('%f\n', myErr2(K));
    end
    g = numberOfSpectraAllPunches;
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

function h = saveMyData()
    % 2021/02/12 NEW save the arrays of averages and standard devs
    % for all gel types, J, so that plotSteadyandDynStatesJB05 
    % can read these values in
    global myAlgY1AllPunches
    global myAlgY1AllPunchesStdDev
    global myAlgY2AllPunches
    global myAlgY2AllPunchesStdDev
    global myPEGY1AllPunches
    global myPEGY1AllPunchesStdDev
    global myPEGY2AllPunches
    global myPEGY2AllPunchesStdDev
    global myHEMAY1AllPunches
    global myHEMAY1AllPunchesStdDev
    global myHEMAY2AllPunches
    global myHEMAY2AllPunchesStdDev
    global myHEMACoY1AllPunches
    global myHEMACoY1AllPunchesStdDev
    global myHEMACoY2AllPunches
    global myHEMACoY2AllPunchesStdDev
    
    dirStem = 'Data\'; % make these files part of the repo
    for ii = 1:16
        switch ii
            case 1
                myArray = myAlgY1AllPunches;
                myVariable = 'myAlgY1AllPunches';
            case 2
                myArray = myAlgY1AllPunchesStdDev;
                myVariable = 'myAlgY1AllPunchesStdDev';
            case 3
                myArray = myAlgY2AllPunches;
                myVariable = 'myAlgY2AllPunches';
            case 4
                myArray = myAlgY2AllPunchesStdDev;
                myVariable = 'myAlgY2AllPunchesStdDev';
            case 5
                myArray = myPEGY1AllPunches;
                myVariable = 'myPEGY1AllPunches';
            case 6
                myArray = myPEGY1AllPunchesStdDev;
                myVariable = 'myPEGY1AllPunchesStdDev';
            case 7
                myArray = myPEGY2AllPunches;
                myVariable = 'myPEGY2AllPunches';
            case 8
                myArray = myPEGY2AllPunchesStdDev;
                myVariable = 'myPEGY2AllPunchesStdDev';
            case 9
                myArray = myHEMAY1AllPunches;
                myVariable = 'myHEMAY1AllPunches';
            case 10
                myArray = myHEMAY1AllPunchesStdDev;
                myVariable = 'myHEMAY1AllPunchesStdDev';
            case 11
                myArray = myHEMAY2AllPunches;
                myVariable = 'myHEMAY2AllPunches';
            case 12
                myArray = myHEMAY2AllPunchesStdDev;
                myVariable = 'myHEMAY2AllPunchesStdDev';
            case 13
                myArray = myHEMACoY1AllPunches;
                myVariable = 'myHEMACoY1AllPunches';
            case 14
                myArray = myHEMACoY1AllPunchesStdDev;
                myVariable = 'myHEMACoY1AllPunchesStdDev';
            case 15
                myArray = myHEMACoY2AllPunches;
                myVariable = 'myHEMACoY2AllPunches';
            case 16
                myArray = myHEMACoY2AllPunchesStdDev; 
                myVariable = 'myHEMACoY2AllPunchesStdDev';
        end    
        myFilename = sprintf('%s%sRaw.mat', dirStem, myVariable);
        save(myFilename, myVariable);
    end
    h = 1;
end