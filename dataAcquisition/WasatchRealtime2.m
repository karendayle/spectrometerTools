% Wasatch Continuous Spectra with real-time analysis
%
% Based on WasatchContDiffAvg.m from July 2018, now adding in the 
% post processing, updating the plots after each new acquisition
% so that post processing is not needed
%
% Dayle Kotturi December 2018

% -------------------------------------------------------------------------
% % Variables. Might need to change depending on what you want to do.
%waitBetweenAverages = 55; % Acquire one averaged 5 sec integ per minute
waitBetweenAverages = 120; % Acquire one averaged sample 2 minutes apart
countBetweenPlots = 1; % Draw one out of every five averages
counter = 0;
increment = 2;
integrationTimeMS = 5000;
laserPowerFraction = 0.332;
closestRef = 0;
refWaveNumber = 0;
numIter = 5; % number of spectra to average 

% -------------------------------------------------------------------------
% Global Variables. Used in main and functions. May need to change
% depending on what you want to do.
global x;
global pixels;
global xMin; % KDK FIX 12/12/2018 next 4 lines
global xMax;
global yMin;
global yMax;
xMin = 950;
xMax = 1800; % SP says to cutoff here 11/7/2018
yMin = 0;
yMax = 12000;
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
global studyName % Set in createDirAndSubDirs
global subdirs;
global subdirMax;
subdirs = ["1 pH7", "2 pH4", "3 pH10", "4 pH7", "5 pH10", "6 pH4", ...
    "7 pH10", "8 pH7", "9 pH4"];
subdirMax = length(subdirs);
global gelTypeName;

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
global lineThickness; % KDK FIX 12/12/2018
lineThickness = 2; % KDK FIX 12/12/2018
global offset;
offset = 300;
% -------------------------------------------------------------------------
% Fixed. Don't change these ever.
true = 1;
false = 0;
global numPoints; %%% KDK FIX 12/12/2018
numPoints = 1024; % fixed. Based on physical char of spectrometer grating
% to avoid array changing size every time it's assigned in the loop
myTextFont = 15;
myFont = 30;
% Statically declaring array sizes to save resources needed to do
% dynamic allocation
darkData = zeros(1, numPoints, 'double'); % Hmmm. Need this again 12/12/2018
spectrumData = zeros(1, numPoints, 'double');
lastSpectrumData = zeros(1, numPoints, 'double');
lastAvgData = zeros(1, numPoints, 'double');
%rawData = zeros(1, numPoints, 'double');
difference = zeros(1, numPoints, 'double');
differenceBetweenAverages = zeros(1, numPoints, 'double');
x = zeros(1, numPoints, 'double'); % While does x STILL end up as 1x1 sometimes?
avg = zeros(1, numPoints, 'double');
denominator = zeros(1, 6, 'double'); % calculate denominators based on an
                                     % increasing number of points
subdirNumber = 1;  
                                  
    dir1 = '../../Data/Made by Sureyya/'; % just use relative directory
                                          % skip use of pwd for now
    studyName = strcat(dir1, 'Alginate', '/', 'gel 4', '/', 'study1');

                figure % Make the ratiometric average spectra plot

                for K = 1:9
                    switch K
                        case {1,4,8}
                            pHcolor = green;
                            num1 = plotAllSubDirs(strcat(studyName, '/', subdirs(K)), pHcolor);
                            fprintf('Case %d: %d spectra plotted in green\n', K, num1);
                        case {2,6,9}
                            pHcolor = red;
                            num2 = plotAllSubDirs(strcat(studyName, '/', subdirs(K)), pHcolor);
                            fprintf('Case %d: %d spectra plotted in red\n', K, num2);
                        case {3,5,7}
                            pHcolor = blue;
                            num3 = plotAllSubDirs(strcat(studyName, '/', subdirs(K)), pHcolor);
                            fprintf('Case %d: %d spectra plotted in blue\n', K, num3);
                    end
                end
                
%                 % TO DO: figure out the coords for labels from the data
%                 y = 1.1;
%                 x = 1200;
%                 deltaY = 0.1;
%                 %deltaX = 100;
%                 text(x, y, 'pH4', 'Color', red, 'FontSize', myTextFont);
%                 text(x, y, '___', 'Color', red, 'FontSize', myTextFont);
%                 %text(x + deltaX, y, 'Laser Power = 19.4 mW', 'FontSize', myTextFont);
%                 y = y - deltaY;
%                 text(x, y, 'pH7', 'Color', green, 'FontSize', myTextFont);
%                 text(x, y, '___', 'Color', green, 'FontSize', myTextFont);
%                 %text(x + deltaX, y, '5 second integration time per acq', 'FontSize', myTextFont);
%                 y = y - deltaY;
%                 text(x, y, 'pH10', 'Color', blue, 'FontSize', myTextFont);
%                 text(x, y, '____', 'Color', blue);
%                 %text(x + deltaX, y, 'Each spectra average of 5 acqs', 'FontSize', myTextFont);
%                 y = y - deltaY;
%                 %text(x, y, 'four', 'Color', black, 'FontSize', myTextFont);
%                 %text(x, y, '_____', 'Color', black, 'FontSize', myTextFont);
%                 %text(x + deltaX, y, 'Normalized using 5 points around ref peak', 'FontSize', myTextFont);
%                 y = y - deltaY;
%                 %text(x + deltaX, y, 'Displaying average spectrum', 'FontSize', myTextFont);
                
                %hold off
                myTitle = sprintf('%s ratiommetric spectra', gelTypeName);
                title(myTitle, 'FontSize', myFont);
                xlabel('Wavenumber (cm^-^1)', 'FontSize', myFont); % x-axis label
                ylabel('Arbitrary Units (A.U.)', 'FontSize', myFont); % y-axis label
                set(gca,'FontSize',16,'FontWeight','bold','box','off')
                % Plot each spectrum (intensity vs wavenumber in a new color overtop
                
                % ---------------------------------------------------------
                % 12/12/2018 NEW: Here is where we do what used to be the 
                % time series post-processing

                figure 

                % subtract this offset
                global tRef;
                tRef = datenum(2018, 11, 24, 19, 28, 50); % TBD FIX ME
                
                myTitleFont = 30;
                myLabelFont = 20;
                myTextFont = 15;
                
                for K = 1:9
                    switch K
                        case {1,4,8}
                            pHcolor = green;
                            num1 = plotTimeSeries(strcat(studyName, '/', subdirs(K)), pHcolor);
                            fprintf('Case 1: %d spectra plotted in green\n', num1);
                        case {2,6,9}
                            pHcolor = red;
                            num2 = plotTimeSeries(strcat(studyName, '/', subdirs(K)), pHcolor);
                            fprintf('Case 2: %d spectra plotted in red\n', num2);
                        case {3,5,7}
                            pHcolor = blue;
                            num3 = plotTimeSeries(strcat(studyName, '/', subdirs(K)), pHcolor);
                            fprintf('Case 3: %d spectra plotted in blue\n', num3);
                    end
                end
                
                %hold off
                myTitle = sprintf('%s time series', gelTypeName);
                title(myTitle, 'FontSize', myFont);
                myXlabel = sprintf('Time in hours from %s', datestr(tRef));
                xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
                ylabel('Intensity (A.U.)/Intensity at 1582 cm^-^1 (A.U.)', ...
                    'FontSize', myLabelFont); % y-axis label
                set(gca,'FontSize',16,'FontWeight','bold','box','off');
                
                % prepare for next iteration
                for i = 1:pixels
                    lastAvgData(i) = avg(i);
                end
            
             
            
            % Check: does user want to repeat another increment or change
            % to next subdir
            prompt = '\nTake another set (Y) or switch pH (N)?> ';
            myAns3 = input(prompt, 's');
            if myAns3 == 'Y'
                fprintf('Continuing with another set of %d measurements at same pH\n', ...
                    subdirNumber);
                % Reset loop counter
                loopCounter = 1;
            else
                if myAns3 == 'N'
                    prompt = '\nChange pH buffer and enter 1 when ready> ';
                    myAns4 = input(prompt);  
                    if (myAns4 == 1)
                        subdirNumber = subdirNumber + 1;
                        fprintf("Switching to write to subdir %d\n", ...
                            subdirNumber);
                        % Don't reset loop counter yet. Use the fact it is >
                        % increment to break out of inner while loop
                    else
                        fprintf('Unrecognized input: %d\n', myAns4);
                    end
                end
            end

function a = takeSpectrum(numPoints, spectrometer, integrationTimeMS)
    %spectrum = zeros(1, numPoints, 'double'); should not be necessary
    global pixels;
    spectrum = zeros(1, numPoints, 'double');
    
    % get a spectrum
    spectrometer.integrationTimeMS = integrationTimeMS;
    spectrum = spectrometer.getSpectrum(); % 6/19 pb is here. nothing 
    pixels = spectrometer.pixels;
    if (pixels > numPoints)
        fprintf('Number of pixels, %d, exceeds expected, %d\n', pixels, ...
            numPoints);
    else 
        fprintf('takeSpectrum retrieved %d pixels\n', pixels);
    end
    a = spectrum;
end

function b = writeSpectrumToFile(myData, stem, refWaveNumber,...
    closestRef, denominator, laserPowerFraction)
    global x;
    global pixels;
    
    % myData could be different things: dark, raw, spectrum, scaled
    % spectrum. 

    fprintf('Check x array length: %d\n', length(x)); % This is reported as 1x1024
    %size(myData) % This is reported as 1x1
    %size(denominator)
    
    % create a data file from the current date and time
    filename = sprintf(stem, datestr(now,'yyyy-mm-dd-HH-MM-SS'));
    [fileID,errmsg] = fopen(filename,'w');
    fprintf('%s opened for write with status: %s\n', filename, errmsg);
      
    % write the number of pixels first (to help the read routine)
    
    % write the spectrum to file before it is overwritten
    for i = 1:pixels
        fprintf(fileID, '%g %g \n', x(i), myData(i));
        % use notepad++ to see this is 1 value per line for 1024 lines
        %fprintf(fileID, "%g %g\n", wavenumbers(i), spectrum(i)); 
        % use notepad++ to see that this is all 1024 values on one line!
    end 
    
    % append additional fields (so it can change over time
    % without changing where data is in the file)
    fprintf(fileID, '%g refWaveNumber\n', refWaveNumber);
    fprintf(fileID, '%g closestRef\n', closestRef);
    %fprintf(fileID, '%g numPointsEachSide\n', numPointsEachSide);
    fprintf(fileID, '%g %g %g %g %g %g denominators\n', ...
        denominator(1), denominator(2), denominator(3), ...
        denominator(4), denominator(5), denominator(6));
    fprintf(fileID, '%g laser power as fraction of full power\n', ...
        laserPowerFraction);
    
    % cleanup
    fclose(fileID);
    b = filename;
end

function c = plotSpectrum(firstTime, ...
    wavenumbers, dark, rawSpectrum, spectrum, difference, ...
    denominator, isAveragedSpectrum, acq)
xMin = 950;
xMax = 1800; % SP says to cutoff here 11/7/2018
% local function to graph the spectrum
    if isAveragedSpectrum
        figure('Name','Averaged from 5 integrations');
    else
        myTitle=sprintf('Acquisition %d', acq);
        figure('Name',myTitle);
    end
    
    subplot(2,4,1)
    %plot(wavelengths, spectrum, 'blue');
    plot(wavenumbers, spectrum, 'blue');
    if isAveragedSpectrum
        title('Average of 5 acquisitions');
    else
        title('Raw - Dark');
    end
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('Arbitrary Units (A.U.)'); % y-axis label
    set(gca,'FontSize',16,'FontWeight','bold','box','off')
    xlim([xMin xMax]); 
    
    if (denominator(3) ~= 0)
    % Plot the normalized data
        normalized = spectrum/denominator(3);
        subplot(2,4,2)
        plot(wavenumbers, normalized, 'magenta');
        title('Ratiometric with N=5');
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('(A.U.)/(A.U.)'); % y-axis label
        set(gca,'FontSize',16,'FontWeight','bold','box','off')
        xlim([xMin xMax]);
    else
        normalized = spectrum;
    end

    [e f] = correctBaseline(normalized');
    subplot(2,4,3)
    plot(wavenumbers, e, 'cyan', wavenumbers, f, 'green');
    title('Baseline Corrected');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('(A.U.)/(A.U.)'); % y-axis label;
    set(gca,'FontSize',16,'FontWeight','bold','box','off')
    legend('removed trend', 'result');
    xlim([xMin xMax]);
    
    if (firstTime == false)
    % if not firstTime, do the plot the difference
        subplot(2,4,4)
        plot(wavenumbers, difference, 'red');
        title('Difference to previous');
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('Arbitrary Units (A.U.)'); % y-axis label
        set(gca,'FontSize',16,'FontWeight','bold','box','off')
        xlim([xMin xMax]);
    end
    
    if ~isAveragedSpectrum 
        subplot(2,4,5)
        plot(wavenumbers, rawSpectrum, 'green');
        title('Raw');
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('Arbitrary Units (A.U.)'); % y-axis label;
        xlim([xMin xMax]);
        
        subplot(2,4,6)
        %plot(wavelengths, dark, 'black');
        plot(wavenumbers, dark, 'black');
        title('Dark');
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('Arbitrary Units (A.U.)'); % y-axis label
        xlim([xMin xMax]);
        
        % plot of denom vs N
        subplot(2,4,7)
        plot([1 3 5 7 9 11], denominator);
        title('Denominator = fn(N points)');
        xlabel('Number of points'); % x-axis label
        ylabel('Denominator for ratio (A.U.)'); % y-axis label
        xlim([xMin xMax]);
    end
    
    % Additional plots, could be commented out
%     figure
%     myTitle = sprintf('Denominator = fn(N points)');
%     title(myTitle);
%     subplot(2,3,1)
%     plot(wavenumbers, spectrum/denominator(1), 'red');
%     xlabel('Wavenumber (cm^-1)'); % x-axis label
%     ylabel('(A.U.)/(A.U.)'); % y-axis label
%     myLegend = sprintf('denom=%g(1)', denominator(1));
%     legend(myLegend);
%     
%     subplot(2,3,2)
%     plot(wavenumbers, spectrum/denominator(2), 'blue');
%     xlabel('Wavenumber (cm^-1)'); % x-axis label
%     ylabel('(A.U.)/(A.U.)'); % y-axis label
%     myLegend = sprintf('denom=%g(3)', denominator(2));
%     legend(myLegend);
%     
%     subplot(2,3,3)
%     plot(wavenumbers, spectrum/denominator(3), 'magenta');
%     xlabel('Wavenumber (cm^-1)'); % x-axis label
%     ylabel('(A.U.)/(A.U.)'); % y-axis label
%     myLegend = sprintf('denom=%g(5)', denominator(3));
%     legend(myLegend);
%         
%     subplot(2,3,4)
%     plot(wavenumbers, spectrum/denominator(4), 'green');
%     xlabel('Wavenumber (cm^-1)'); % x-axis label
%     ylabel('(A.U.)/(A.U.)'); % y-axis label
%     myLegend = sprintf('denom=%g(7)', denominator(4));
%     legend(myLegend);
%     
%     subplot(2,3,5)
%     plot(wavenumbers, spectrum/denominator(5), 'black');
%     xlabel('Wavenumber (cm^-1)'); % x-axis label
%     ylabel('(A.U.)/(A.U.)'); % y-axis label
%     myLegend = sprintf('denom=%g(9)', denominator(5));
%     legend(myLegend);
%     
%     subplot(2,3,6)
%     plot(wavenumbers, spectrum/denominator(6), 'cyan');
%     xlabel('Wavenumber (cm^-1)'); % x-axis label
%     ylabel('(A.U.)/(A.U.)'); % y-axis label
%     myLegend = sprintf('denom=%g(11)', denominator(6));
%     legend(myLegend);
        
    c=1;
end

function d = getDenominator(closestRef, numPointsEachSide, numPoints, spectrum)
    % use the closestRef as the x-value of the center point of the peak
    % sum the points from x=(closestRef - numPointsIntegrated) to 
    % x=(closestRef + numPointsIntegrated) and then divide by number of
    % points to average and scale it.
    
    %fprintf('getDenominator with numPointsEachSide = %d\n', ...
    %    numPointsEachSide);
    
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
    %fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
    %    numPointsEachSide);
    startIndex = closestRef - numPointsEachSide;
    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(startIndex);
        % fprintf('index: %d, spectrum: %g\n', startIndex, spectrum(startIndex));
        startIndex = startIndex + 1;
    end
    denominator = sum/numPointsToIntegrate;
    % fprintf('denominator: %g\n', denominator);
    d = denominator;
end

function [e f] = correctBaseline(tics)
    lambda=1e4; % smoothing parameter
    p=0.001; % asymmetry parameter
    d=2;
    %prog.chroms=tics;
    %prog.point=1;

    % asym: Baseline estimation with asymmetric least squares using weighted
    % smoothing with a finite difference penalty.
    %   signals: signal, each column represents one signal
    %   lambda: smoothing parameter (generally 1e5 to 1e8)
    %   p: asymmetry parameter (generally 0.001)
    %   d: order of differences in penalty (generally 2)
    %prog.temp_tic=asysm(tics(1,:)',lambda,p,d);
    %prog.temp_tic=asysm(tics,lambda,p,d);
    temp_tic=asysm(tics,lambda,p,d);
    %prog.temp_tic=prog.temp_tic';
    trend=temp_tic';
    modified=tics(:)-temp_tic(:);
    e = trend;
    f = modified;
end

function g = createDirAndSubDirs()
    global studyName;
    global subdirs;
    global subdirMax;
    global gelTypeName;
    pwd % not used
    prompt = '\nIs this study: Alginate (1), PEG (2) or polyHEMAcoAc (3)?>';
    gelType = input(prompt);
    % Switch on gelType and add to path
    switch gelType
        case 1
            gelTypeName = 'Alginate';
        case 2
            gelTypeName = 'PEG';
        case 3
            gelTypeName = 'polyHEMA coAcrylamide';
    end
    
    prompt = '\nEnter gel#>';
    gelNumber = input(prompt);
    gelInstance = sprintf('gel %d/', gelNumber);
    
    prompt = '\nEnter study name> ';
    dir2 = input(prompt, 's');
    
    % Now put it all together
    dir1 = '../../Data/Made by Sureyya/'; % just use relative directory
                                          % skip use of pwd for now
    studyName = strcat(dir1, gelTypeName, '/', gelInstance, dir2);
    if ~exist(studyName, 'dir')
        [status, msg, msgID] = mkdir(studyName); % Make all intermediate dirs?
        if status == 1 % keep going
            s = strcat(studyName, '/');
            % Make the subdirs inside 's'
            sumStatus = 0;
            for i = 1:subdirMax
                sub = strcat(s, subdirs(i));
                fprintf('Make directory %s\n', sub);
                % mkdir(s1) works at the cmd line, but via script, error is:
                % Error using mkdir. Argument must contain a character vector.
                [status, msg, msgID] = mkdir(char(sub));
                sumStatus = sumStatus + status;
            end

            if sumStatus == 9
                g = 1;
            else
                fprintf('Result from making all subdirs: %d\n', sumStatus);
                g = -1;
            end
        else
            fprintf('%s\n', msg);
            g = status;
        end
    else
        fprintf('directory: %s exists. Choose another name.', s);
        g = -1;
    end
end

function g = plotAllSubDirs(subDirStem, myColor)
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
    global studyName;
    global subdirs;
    
    tic;
    
    sum = zeros(1, numPoints, 'double');
    avg = zeros(1, numPoints, 'double');
    sumSq = zeros(1, numPoints, 'double');
    thisdata = zeros(2, numPoints, 'double');
    
    txtpattern = fullfile(char(subDirStem), 'avg*.txt');
    dinfo = dir(txtpattern);
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(char(subDirStem), dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');    

            % OOPS. It's weird but it looks like e is 1x1024 and f is 1024x1024 12/13/2018
            f = f';
            
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
            
            sum = sum + normalized; % OOPS. why is sum 1024x1024?
        end
        
        % calculate average % OOPS. avg is ending up as 1024x1024 after this!
        avg = sum/numberOfSpectra;
        
        % second pass on dataset to get (each point - average)^2
        % for standard deviation, need 
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(char(subDirStem), dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');    
            
            f = f';

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
        %hold on
        %fprintf('%d\n', I);
        %pause(1);
    end
    g = numberOfSpectra;
    fprintf('Spectral plot ');
    toc;
end

function h = plotTimeSeries(subDirStem, myColor)
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
    
    tic;
    
    sumY1 = 0;
    sumY2 = 0;
    avgY1 = 0;
    avgY2 = 0;
    sumSqY1 = 0;
    sumSqY2 = 0;
    
    txtpattern = fullfile(char(subDirStem), 'avg*.txt');
    dinfo = dir(txtpattern); 
    thisdata = zeros(2, numPoints, 'double');
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
        % TO DO: add if stmt to ensure numberOfSpectra > 0
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(char(subDirStem), dinfo(I).name); % just the name            
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
            f(x1Min:x1Max)
            x1LocalPeak = localPeak(f(x1Min:x1Max));
            x2LocalPeak = localPeak(f(x2Min:x2Max));
            fprintf('local max near 1430/cm is %g\n', x1LocalPeak);
            fprintf('local max near 1702/cm is %g\n', x2LocalPeak);       

            y1(I) = x1LocalPeak/denominator;
            y2(I) = x2LocalPeak/denominator;

            %y1(I) = thisdata(2, x1)/denominator;
            %y2(I) = thisdata(2, x2)/denominator;
            %y3(I) = denominator; % NEW Oct. 17th to look for jumps in ref
            fclose(fileID);
            sumY1 = sumY1 + y1(I);
            sumY2 = sumY2 + y2(I);
        end
    
        % calculate average 
        avgY1 = sumY1/numberOfSpectra
        avgY2 = sumY2/numberOfSpectra
        sumSqY1 = 0;
        sumSqY2 = 0;
        
        % second pass on dataset to get (each point - average)^2
        % for standard deviation, need 
        for I = 1 : numberOfSpectra            
            % 4. Add to the sum of the squares
            sumSqY1 = sumSqY1 + (y1(I) - avgY1).^2;
            sumSqY2 = sumSqY2 + (y2(I) - avgY2).^2;
        end
    
        % 5. Compute standard deviation at each index of the averaged spectra 
        stdDevY1 = sqrt(sumSqY1/numberOfSpectra);
        stdDevY2 = sqrt(sumSqY2/numberOfSpectra);

        for J=1:numberOfSpectra
            avgArrayY1(J) = avgY1;
            avgArrayY2(J) = avgY2;
            stdDevArrayY1(J) = stdDevY1;
            stdDevArrayY2(J) = stdDevY2;
        end

    %     % Now have points for the 1430 plot at t,y1 and for the 1702 plot at t,y2
    %     Either:
    %     errorbar(t, avgArrayY1, stdDevArrayY1, '-o', 'Color', purple);
    %     errorbar(t, avgArrayY2, stdDevArrayY2, '-*', 'Color', purple);
    %     hold on;
    %     Or:
        plot(t,y1,'-o', 'Color', myColor, 'LineWidth', lineThickness);
        hold on;
        plot(t,y2,'-+', 'Color', myColor, 'LineWidth', lineThickness);
        hold on;
        h = 1;
    else
        fprintf('No files in this directory: %s\n', subDirStem);
        h = 1;
    end
    fprintf('Time plot ');
    toc;
end

function h = localPeak(range)
    h = max(range);
end
