% Wasatch Continuous Spectra with real-time analysis
%
% Based on WasatchContDiffAvg.m from July 2018, now adding in the 
% post processing, updating the plots after each new acquisition
% so that post processing is not needed
%
% Modify to use less memory. For unknown reasons Windows7 PC with 8GB
% RAM runs out of memory about 2 hours of running this script.
%
% Dayle Kotturi November 2019

% -------------------------------------------------------------------------
addpath('../functionLibrary');

% % Variables. Might need to change depending on what you want to do.
%waitBetweenAverages = 55; % Acquire one averaged 5 sec integ per minute
%waitBetweenAverages = 30.; % Acquire one averaged sample 0.5 minutes apart
waitBetweenAverages = 0.; % Acquire one averaged sample 0 minutes apart
countBetweenPlots = 5; % Draw one out of every five averages
counter = 0;
%increment = 60; % up from 30 for 2020
increment = 3; % for static tests
% integrationTimeMS = 1000; %was 1000 before power jumped to 80 mW 
%integrationTimeMS = 100; %use when power jumped to 80 mW 
integrationTimeMS = 2000; %trying to get SORS to depth of >=1.5mm
laserPowerFraction = 1.011;
closestRef = 0;
refWaveNumber = 0;
numIter = 5; % number of spectra to average 

% -------------------------------------------------------------------------
% Global Variables. Used in main and functions. May need to change
% depending on what you want to do.
global x
global pixels
global xMin
global xMax
global yMax1
global yMax2

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
global studyPath % Set in createDirAndSubDirs
global studyName
global subdirs;
global subdirMax;
% subdirs = ["1 pH7", "2 pH4", "3 pH10", "4 pH7", "5 pH10", "6 pH4", ...
%     "7 pH10", "8 pH7", "9 pH4"];
subdirs = ["1", "2", "3", "4", "5", "6", ...
    "7", "8", "9"];
subdirMax = length(subdirs);
global gelTypeName;
global gelNumber;

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
global lineThickness; %%% KDK FIX 12/12/2018
lineThickness = 2; %%% KDK FIX 12/12/2018
global offset;
offset = 30;
global tRef;
tRef = 0;
% -------------------------------------------------------------------------
% Fixed. Don't change these ever.
true = 1;
false = 0;
global numPoints;
numPoints = 1024; % fixed. Based on physical char of spectrometer grating
% to avoid array changing size every time it's assigned in the loop

% allocating memory once only and reusing it is not enough to stop PC 
% from running out of memory, so delete old figures before redrawing new
% ones
global f1;
global f2;
global f3;

myTextFont = 15;
myFont = 30;
% Statically declaring array sizes to save resources needed to do
% dynamic allocation
%darkData = zeros(1, numPoints, 'double'); % Hmmm. Need this again
%12/12/2018 -- out again 6/26/2020 with new matlab, new version of dll
global darkData; % make this global 6/26/2020
spectrumData = zeros(1, numPoints, 'double');
lastSpectrumData = zeros(1, numPoints, 'double');
lastAvgData = zeros(1, numPoints, 'double');
difference = zeros(1, numPoints, 'double');
differenceBetweenAverages = zeros(1, numPoints, 'double');
x = zeros(1, numPoints, 'double'); % While does x STILL end up as 1x1 sometimes?
denominator = zeros(1, 6, 'double'); % calculate denominators based on an
                                     % increasing number of points
% 2019/11/28 new. moved from plotAllSubdirs to save memory
global sum;
global avg;
global sumSq;
global thisdata;
sum = zeros(1, numPoints, 'double');
avg = zeros(1, numPoints, 'double');
sumSq = zeros(1, numPoints, 'double');
thisdata = zeros(2, numPoints, 'double');

startTimeSet = false;

% load the DLL
% 32 bit dll: NET.addAssembly('C:\Program Files (x86)\Wasatch Photonics\Wasatch.NET\WasatchNET.dll');
% 64 bit dll: 
dll = NET.addAssembly('C:\Program Files\Wasatch Photonics\Wasatch.NET\WasatchNET.dll'); % FIX PATH DEPENDENCY

% get a handle to the Driver Singleton
driver = WasatchNET.Driver.getInstance();

% enumerate any connected spectrometers
numberOfSpectrometers = driver.openAllSpectrometers();
fprintf('%d spectrometers found.\n', numberOfSpectrometers);
if numberOfSpectrometers <= 0
	return % stop execution if spectrometer is off or disconnected
end

% open the first spectrometer found
spectrometer = driver.getSpectrometer(0);

% access some key properties
pixels = spectrometer.pixels;
modelName = char(spectrometer.model);
serialNum = char(spectrometer.serialNumber);
wavelengths = spectrometer.wavelengths;
laserWavelengthNM = 785.0;
wavenumbers = WasatchNET.Util.wavelengthsToWavenumbers(... 
    laserWavelengthNM, wavelengths);

% this should not be necessary but it helps to make wavenumber into 1x1024
% array instead of 1x1.
for i = 1:pixels
    x(i) = wavenumbers(i);
end

% display summary
fprintf('Found %s %s with %d pixels (%.2f, %.2fnm)\n', ...
    modelName, serialNum, pixels, ...
    wavelengths(1), wavelengths(wavelengths.Length));

%%% NEW: Prompt for study name, append it to path, check it doesn't
%%% exist, then create it and its subdirs
returnCode = createDirAndSubDirs();
if returnCode == 1
    fprintf('Success'); % studyPath should now be set
else if returnCode == -1
        fprintf('Failure');
        return;
    else
        fprintf('Unrecognized return code: %d\n', returnCode);
        return;
    end
end

% NEW: THESE PATHS ARE NO LONGER CONSTANT. THEY NEED studyName embedded 
% AS WELL AS THE SUBDIR THAT IS CHANGING OVER TIME 
% Initialize the stems to the first subdir

% next: make this optional so you can see the peak unaltered and THEN enter
% the index
prompt = '\nEnter wavenumber (cm^-1) to use for reference intensity (0 to skip)> ';
refWaveNumber = input(prompt);
closestRef = 0; % set default value to begin
if (refWaveNumber ~= 0) 
    for i = 1:(pixels-1)
        % There is likely no exact match. Just find the value closest to
        % requested
        if ((wavenumbers(i) <= refWaveNumber) && (wavenumbers(i+1) > refWaveNumber))
            % store i as the place 
            closestRef = i;
            fprintf("reference is at %d\n", closestRef);
        end
        %fprintf("%d %g %g \n", i, wavenumbers(i), spectrumData(i)); 
        % use notepad++ to see this is 1 value per line for 1024 lines
    end 
    %prompt = '\nEnter number of points on each side of reference to integrate> ';
    %numPointsEachSide = input(prompt);
end

firstTime = true;
firstAverage = true;

% take a "dark" of the background without the sample to be able to subtract
% it from each spectrum
prompt = '\nEnter 0 to proceed without dark, 1 to take dark now, 2 to read dark from a file, 4 to take dark and exit> ';
myAns1 = input(prompt);

if ((myAns1 == 1) || (myAns1 == 4))
    prompt = '\nEnter 1 when ready to take dark> ';
    myAns2 = input(prompt);
    if (myAns2 == 1)
        fprintf("1. Taking dark...");
        darkData = takeSpectrum(numPoints, spectrometer, integrationTimeMS);
        
        % check. for debugging. 1024 values are there. Just not vis in
        % workspace ?! 
        for i=1:numPoints
            fprintf('darkData(%d)=%d\n', i, darkData(i));
        end
        
        % Note that where dark is subtracted, it isn't being
        % subtracted from the normalized signal, only the raw signal
        darkStem = strcat(studyPath, '/', subdirs(1), '/dark-%s.txt');
        darkFilename = writeSpectrumToFile(darkData, darkStem,...
            0, 0, zeros(1, 6, 'double'), 0);
    end
else 
    if (myAns1 == 0)
        fprintf('1. Skipping dark, using all zeros');
    else
        if (myAns1 == 2) % GET RID OF THIS CASE. NOT USING THIS.
            fileID = -1;
            errmsg = '';
            while fileID < 0 
                disp(errmsg);
                filename = input ('3. Open file in C:\\Users\dayle.kotturi\\Documents\\Data\\Official Dark: ', ...
                    's');
                [fileID,errmsg] = fopen(fullfile ... % FIX PATH DEPENDENCY OR REMOVE
                    ('C:\Users\dayle.kotturi\Documents\Data\Official Dark', ...
                    filename), 'r');
            end
            
            % read the values into the array "dark"
            i = 1;
            while (~feof(fileID))
                darkData = fgetl(fileID);
                disp(darkData);
                i = i + 1;
            end
            
            % check for overflow
            if (i > (numPoints + 1))
                fprintf('Dark array exceeds expected %d values', numPoints);
            end
            fclose(fileID);
        end
    end    
end

if (myAns1 ~= 4)
    % done with dark, ready for sample
    prompt = '\nEnter 1 when laser is on> ';
    myAns2 = input(prompt);
    if (myAns2 == 1)
        fprintf('Continuing on... Dark will be subtracted from each spectrum');

        subdirNumber = 1; % initialize
        
        % Go through filling the subdirs with the files
        while subdirNumber <= subdirMax
            fprintf('Top of loop: subdirNumber is %d. Taking %d measurements.\n', ...
                subdirNumber, increment);
            stem = strcat(studyPath, '/', subdirs(subdirNumber));
            rawStem = strcat(stem, '/rawSpectrum-%s.txt');
            dataStem = strcat(stem, '/spectrum-%s.txt');
            avgStem = strcat(stem, '/avg-%s.txt');
            yMax1 = 0; % initialize
            yMax2 = 0; % initialize
            
            loopCounter = 1;
            while (1)
                fprintf("loop %d", loopCounter);
                %%% EG: Take ~1 hour worth of measurements, then prompt to
                %%% repeat or switch the pH (and the dir that is used for the
                %%% files
                % main acquisition loop. Average the spectra of numIter acquisitions
                for j = 1:numIter
                    fprintf("\n2. Taking spectrum %d of %d...", j, numIter);
                    rawData = takeSpectrum(numPoints, spectrometer, integrationTimeMS);
                    rawFilename = writeSpectrumToFile(rawData, rawStem, ...
                        refWaveNumber, closestRef, zeros(1,6,'double'), ...
                        laserPowerFraction);
                    pause(3); % for 6 second acquisition interval with 5 second integration
                    
                    fprintf("3. Subtracting dark (can be all zeros if no dark given)...");
                    % instead of taking a spectrum, we are calculating it from previous
                    for i = 1:pixels
                        spectrumData(i) = rawData(i) - darkData(i);
                        %6/26/2020 why always negative? 
                        %spectrumData(i) = darkData(i) - rawData(i);
                        avg(i) = avg(i) + spectrumData(i);
                    end
                    
                    % Calculate the denominator using a window of 0 - 5 points
                    % on either side of refWaveNumber. This maps to: 1 - 11 total
                    % intensities used to calculate the denominator.
                    if (refWaveNumber ~= 0)
                        for i = 1:6
                            numPointsEachSide = i - 1;
                            denominator(i) = getDenominator(closestRef, ...
                                numPointsEachSide, ...
                                numPoints, spectrumData);
                        end
                    end
                    
                    % Write the spectrum data, the array of
                    % denominators et al to file.
                    spectrumFilename = writeSpectrumToFile(...
                        spectrumData, dataStem,  refWaveNumber, closestRef, ...
                        denominator, laserPowerFraction);
                    if (firstTime == false)
                        for i = 1:pixels
                            difference(i) = spectrumData(i) - lastSpectrumData(i);
                        end
                    end
                    
                    % plot this iteration: Too many plots. Just plot averages
                    plotStatus = plotSpectrum(firstTime, ...
                        x, ...                         %darkData, 
                        rawData, spectrumData, ...
                        difference, denominator, 0, j);
                    
                    % prepare for next iteration
                    for i = 1:pixels
                        lastSpectrumData(i) = spectrumData(i);
                    end
                    
                    % clear flag for all iterations > 1
                    if (firstTime == true)
                        firstTime = false;
                    end
                end
                
                % Average the numIter acquisitions
                for i=1:pixels
                    avg(i) = avg(i)/numIter;
                end
                
                if (refWaveNumber ~= 0)
                    % Calculate the denominator for the average
                    for i = 1:6
                        numPointsEachSide = i - 1;
                        denominator(i) = getDenominator(closestRef, ...
                            numPointsEachSide, numPoints, avg);
                    end
                else
                    for i = 1:6
                        denominator(i) = 1.0;
                    end
                end
                
                avgFilename = writeSpectrumToFile(avg, avgStem, ...
                    refWaveNumber, closestRef, denominator, ...
                    laserPowerFraction);
                
                if (firstAverage == false)
                    for i = 1:pixels
                        differenceBetweenAverages(i) = avg(i) - lastAvgData(i);
                    end
                end
                % Too many plots
                % Plot the average spectra of numIter acquisitions
                %%if mod(counter,countBetweenPlots) == 0
                    plotStatus = plotSpectrum(firstAverage, ...
                        x, ...                        %darkData, 
                        rawData, avg, ...
                        differenceBetweenAverages, denominator, 1, 0);
                %%end
                counter = counter + 1;
                
                % 1/26/2020 delete last figure of this type first
                if ishghandle(f1) 
                    close(f1);
                end
                f1= figure % Make the ratiometric average spectra plot
                % ---------------------------------------------------------
                % 12/12/2018 NEW: Here is where we do what used to be the post-
                % processing
                for K = 1:5
                    switch K
                        case {1}
                            pHcolor = green;
                            num1 = plotAllSubDirs(strcat(studyPath, '/', subdirs(K)), pHcolor);
                            %fprintf('Case %d: %d spectra plotted in green\n', K, num1);
                        case {2}
                            pHcolor = red;
                            num2 = plotAllSubDirs(strcat(studyPath, '/', subdirs(K)), pHcolor);
                            %fprintf('Case %d: %d spectra plotted in red\n', K, num2);
                        case {3}
                            pHcolor = blue;
                            num3 = plotAllSubDirs(strcat(studyPath, '/', subdirs(K)), pHcolor);
                            %fprintf('Case %d: %d spectra plotted in blue\n', K, num3);
                        case {4}
                            pHcolor = purple;
                            num4 = plotAllSubDirs(strcat(studyPath, '/', subdirs(K)), pHcolor);
                            %fprintf('Case %d: %d spectra plotted in blue\n', K, num4);
                        case {5}
                            pHcolor = rust;
                            num5 = plotAllSubDirs(strcat(studyPath, '/', subdirs(K)), pHcolor);
                            %fprintf('Case %d: %d spectra plotted in blue\n', K, num5);
                    end
                end
                
                yPlot = yMax1;
                xPlot = xMin;
                deltaYPlot = yMax1/10;
                
                hold off
                myTitle = sprintf('%s gel #%d study %s ratiometric spectra', gelTypeName, gelNumber, studyName);
                title(myTitle, 'FontSize', myFont);
                xlabel('Wavenumber (cm^-^1)', 'FontSize', myFont); % x-axis label
                ylabel('Arbitrary Units (A.U.)', 'FontSize', myFont); % y-axis label
                set(gca,'FontSize',16,'FontWeight','bold','box','off')
                % Plot each spectrum (intensity vs wavenumber in a new color overtop
                
                % 1/26/2020 delete last figure of this type first
                if ishghandle(f2) 
                    close(f2);
                end
%                 % ---------------------------------------------------------
%                 % 12/12/2018 NEW: Here is where we do what used to be the 
%                 % time series post-processing
%                 f2 = figure 
% 
%                 % subtract this offset -- first time only
%                 if startTimeSet == false
%                     myStr = datestr(now,'yyyy-mm-dd-HH-MM-SS');
%                     [myYear, remain] = strtok(myStr, '-');
%                     [myMonth, remain] = strtok(remain, '-');
%                     [myDay, remain] = strtok(remain, '-');
%                     [myHour, remain] = strtok(remain, '-');
%                     [myMinute, remain] = strtok(remain, '-');
%                     [mySecond, remain] = strtok(remain, '-');
%                     % These are strings, need to make them numbers,
%                     % by, sigh, first making them char arrays
%                     % which wasn't by the way necessary with 2018a.
%                     % sigh again.
%                     myY = str2num(char(myYear));
%                     myMo = str2num(char(myMonth));
%                     myD = str2num(char(myDay));
%                     myH = str2num(char(myHour));
%                     myMi = str2num(char(myMinute));
%                     myS = str2num(char(mySecond));
%                     tRef = datenum(myY, myMo, myD, myH, myMi, myS);
%                     fprintf("*****tRef is %g*****\n", tRef);
%                     startTimeSet = true;
%                 end
%                 
%                 myTitleFont = 30;
%                 myLabelFont = 20;
%                 myTextFont = 15;
%                 
%                 for K = 1:5
%                     switch K
%                         case {1}
%                             pHcolor = green;
%                             num1 = plotTimeSeries(strcat(studyPath, '/', subdirs(K)), pHcolor);
%                             fprintf('Case 1: %d spectra plotted in green\n', num1);
%                         case {2}
%                             pHcolor = red;
%                             num2 = plotTimeSeries(strcat(studyPath, '/', subdirs(K)), pHcolor);
%                             fprintf('Case 2: %d spectra plotted in red\n', num2);
%                         case {3}
%                             pHcolor = blue;
%                             num3 = plotTimeSeries(strcat(studyPath, '/', subdirs(K)), pHcolor);
%                             fprintf('Case 3: %d spectra plotted in blue\n', num3);
%                         case {4}
%                             pHcolor = purple;
%                             num4 = plotTimeSeries(strcat(studyPath, '/', subdirs(K)), pHcolor);
%                             fprintf('Case 3: %d spectra plotted in purple\n', num4);
%                         case {5}
%                             pHcolor = rust;
%                             num5 = plotTimeSeries(strcat(studyPath, '/', subdirs(K)), pHcolor);
%                             fprintf('Case 3: %d spectra plotted in rust\n', num5);
%                     end
%                 end
%                            
%                 yPlot = yMax2;
%                 xPlot = 0;  % Ahh, this was my mistake. Overwriting my array of x values
%                 deltaYPlot = yMax2/10;
%                 %deltaXPlot = 0.2;
%                 %text(xPlot + deltaXPlot, yPlot, 'Each spoint average of 5 acqs', 'FontSize', myTextFont);
%                 %yPlot = yPlot - deltaYPlot;
%                 %text(xPlot + deltaXPlot, yPlot, 'Normalized using 5 points around ref peak', 'FontSize', myTextFont);
%                 %yPlot = y - deltaYPlot;
%                 %text(xPlot, yPlot, 'avg with std dev', 'Color', purple, 'FontSize', myTextFont);
%                 %text(xPlot, yPlot, '_____', 'Color', purple, 'FontSize', myTextFont);
%                 %yPlot = yPlot - deltaYPlot;
%                 %text(xPlot + deltaXPlot, yPlot, 'o = local peak near 1430 cm^-^1', 'Color', black, 'FontSize', myTextFont);
%                 %yPlot = yPlot - deltaYPlot;
%                 %text(xPlot + deltaXPlot, yPlot, '+ = local peak near 1702 cm^-^1', 'Color', black, 'FontSize', myTextFont);
%                 
%                 hold off
%                 myTitle = sprintf('%s gel #%d study %s time series', gelTypeName, gelNumber, studyName);
%                 title(myTitle, 'FontSize', myFont);
%                 myXlabel = sprintf('Time in hours from %s', datestr(tRef));
%                 xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
%                 ylabel('Intensity (A.U.)/Intensity at 1582 cm^-^1 (A.U.)', ...
%                     'FontSize', myLabelFont); % y-axis label
%                 set(gca,'FontSize',16,'FontWeight','bold','box','off')
% 
                % prepare for next iteration
                for i = 1:pixels
                    lastAvgData(i) = avg(i);
                end
                
                % clear flag for all iterations > 1
                if (firstAverage == true)
                    firstAverage = false;
                end
                
                pause(waitBetweenAverages);
                loopCounter = loopCounter + 1;
            end % while (1) 
        end % while subdirNumber <= subdirMax
    end % if (myAns2 == 1)
end % if (myAns1 ~= 4)

function a = takeSpectrum(numPoints, spectrometer, integrationTimeMS)
    global pixels;
    %spectrum = zeros(1, numPoints, 'double'); % DK 2019/11/28 BAD? comment
    %out 6/26/2020
    
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
    wavenumbers, ...    %dark, 
    rawSpectrum, spectrum, difference, ...
    denominator, isAveragedSpectrum, acq)
global f3
global darkData
global xMin
global xMax
xMin = 400;
xMax = 1600; % match the HITC values in the Nature paper
% Direct Detection of Unamplified Pathogen RNA in Blood Lysate
% using an Integrated Lab-in-a-Stick Device and Ultrabright SERS
% Nanorattles
% 1/26/2020 delete last figure of this type first
if ishghandle(f3) 
    close(f3);
end
% local function to graph the spectrum
    if isAveragedSpectrum
        f3 = figure('Name','Averaged from 5 integrations');
    else
        myTitle=sprintf('Acquisition %d', acq);
        f3 = figure('Name',myTitle);
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
        plot(wavenumbers, darkData, 'black');
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
    global studyPath;
    global subdirs;
    global subdirMax;
    global gelTypeName;
    global gelNumber;
    pwd % not used
    prompt = '\nIs this study: Alginate (1), PEG (2), pHEMA (3), pHEMAcoAc (4) or other(5)?>';
    gelType = input(prompt);
    % Switch on gelType and add to path
    switch gelType
        case 1
            gelTypeName = 'Alginate';
        case 2
            gelTypeName = 'PEG';
        case 3
            gelTypeName = 'pHEMA';
        case 4
            gelTypeName = 'pHEMA coAcrylamide';
        case 5
            gelTypeName = 'other';
    end
    
    prompt = '\nEnter gel#>';
    gelNumber = input(prompt);
    gelInstance = sprintf('gel %d/', gelNumber);
    
    prompt = '\nEnter study name> ';
    studyName = input(prompt, 's');
    
    % Now put it all together
    dir1 = '../../../Data/SORS/'; % old location (network drive)
    %dir1 = '../../../Data/Made by Waqas/'; % old location (network drive)
    %dir1 = 'C:/ExperimentalData/Dayle/Data/Made by Sureyya/'; % local
    studyPath = strcat(dir1, gelTypeName, '/', gelInstance, studyName);
    if ~exist(studyPath, 'dir')
        [status, msg, msgID] = mkdir(studyPath); % Make all intermediate dirs?
        if status == 1 % keep going
            s = strcat(studyPath, '/');
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

            if sumStatus == subdirMax
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
        fprintf('directory: %s exists. Choose another name.', studyPath);
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
    global yMax1;
    global myDebug;
    global lineThickness;
    global studyPath;
    global subdirs;
    
    % New, to save mem by only declaring once
    global sum;
    global avg;
    global sumSq;
    global thisdata;
    
    tic;

    % DK 2019/11/28 move allocation of these arrays to top and just set
    % values to all zero here, to save memory 
    sum(:) = 0;
    avg(:) = 0;
    sumSq(:) = 0;
    thisdata(:) = 0;
    
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
            f = f'; % FIX required so that avg doesn't end up 1024x1024       

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
            thisfilename = fullfile(char(subDirStem), dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');    
            f = f'; % FIX required so that avg doesn't end up 1024x1024  
            
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
            
        % plot the corrected signal -- DK 2019/11/28 is this the place to
        % limit?
        plot(thisdata(1,offset:end), normalized(offset:end), 'Color', myColor, ...
            'LineWidth', lineThickness);
        
        % update the global variable used to position the legend on plot
        yMax = max(normalized(offset:end));
        if yMax > yMax1
            yMax1 = yMax;
        end
        
        % Now plot stdDev as the array of error bars on the plot...    
        %errorbar(thisdata(1,offset:end), normalized(offset:end), ...
        %    stdDev(offset:end), 'Color', myColor);
        xlim([xMin xMax]);
        hold on
        fprintf('%d\n', I);
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
    global yMax2;
    global thisdata; % DK 2019/11/28 new that it is global to save mem
    tic;
    
    sumY1 = 0;
    sumY2 = 0;
    avgY1 = 0;
    avgY2 = 0;
    sumSqY1 = 0;
    sumSqY2 = 0;
    
    txtpattern = fullfile(char(subDirStem), 'avg*.txt');
    dinfo = dir(txtpattern); 
    %thisdata = zeros(2, numPoints, 'double'); OLD, BAD
    thisdata(:,:) = 0; % DK 2019/11/28 NEW, GOOD
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
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
            
            % update the global variable used to position the legend on plot
            if y1(I) > yMax2
                yMax2 = y1(I);
            end
            if y2(I) > yMax2
                yMax2 = y2(I);
            end
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
  