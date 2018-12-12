% Wasatch Continuous Spectra with real-time analysis
%
% Based on WasatchContDiffAvg.m from July 2018, now adding in the 
% post processing, updating the plots after each new acquisition
% so that post processing is not needed
%
% Dayle Kotturi December 2018

% -------------------------------------------------------------------------
% Variables. Might need to change depending on what you want to do.
%waitBetweenAverages = 55; % Acquire one averaged 5 sec integ per minute
waitBetweenAverages = 120; % Acquire one averaged sample 2 minutes apart
countBetweenPlots = 1; % Draw one out of every five averages
counter = 0;
increment = 2;
integrationTimeMS = 5000;
xMin = 950;
xMax = 1800; % SP says to cutoff here 11/7/2018
yMin = 0;
yMax = 12000;
laserPowerFraction = 0.332;
closestRef = 0;
refWaveNumber = 0;
numIter = 5; % number of spectra to average 
% -------------------------------------------------------------------------
% Global Variables. Used in main and functions. May need to change
% depending on what you want to do.
global studyName % Set in createDirAndSubDirs
global subdirs;
global subdirMax;
subdirs = ["1 pH7", "2 pH4", "3 pH10", "4 pH7", "5 pH10", "6 pH4", ...
    "7 pH10", "8 pH7", "9 pH4"];
subdirMax = length(subdirs);
% -------------------------------------------------------------------------
% Fixed. Don't change these ever.
true = 1;
false = 0;
numPoints = 1024; % fixed. Based on physical char of spectrometer grating
% to avoid array changing size every time it's assigned in the loop
% Colors:
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840]

% Statically declaring array sizes to save resources needed to do
% dynamic allocation
%darkData = zeros(1, numPoints, 'double');
spectrumData = zeros(1, numPoints, 'double');
lastSpectrumData = zeros(1, numPoints, 'double');
lastAvgData = zeros(1, numPoints, 'double');
%rawData = zeros(1, numPoints, 'double');
difference = zeros(1, numPoints, 'double');
differenceBetweenAverages = zeros(1, numPoints, 'double');
x = zeros(1, numPoints, 'double'); 
avg = zeros(1, numPoints, 'double');
denominator = zeros(1, 6, 'double'); % calculate denominators based on an
                                     % increasing number of points

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
    fprintf('Success'); % studyName should now be set
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

%size(wavenumbers); % This is misleading b/c it is 1x1
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
        %for i=1:numPoints
        %    fprintf('darkData(%d)=%d\n', i, darkData(i));
        %end
        
        % Note that where dark is subtracted, it isn't being
        % subtracted from the normalized signal, only the raw signal
        darkFilename = writeSpectrumToFile(pixels, x, darkData, darkStem,...
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

        subdirNumber = 1;
        
        % Go through filling the subdirs with the files
        while subdirNumber <= subdirMax
            fprintf('Top of loop: subdirNumber is %d. Taking %d measurements.\n', ...
                subdirNumber, increment);
            
            darkStem = strcat(studyName, '/', subdirs(subdirNumber), '/dark-%s.txt');
            rawStem = strcat(studyName, '/', subdirs(subdirNumber), '/rawSpectrum-%s.txt');
            dataStem = strcat(studyName, '/', subdirs(subdirNumber), '/spectrum-%s.txt');
            avgStem = strcat(studyName, '/', subdirs(subdirNumber), '/avg-%s.txt');
            
            loopCounter = 1;
            while (loopCounter <= increment)
                %%% EG: Take ~1 hour worth of measurements, then prompt to
                %%% repeat or switch the pH (and the dir that is used for the
                %%% files
                % main acquisition loop. Average the spectra of numIter acquisitions
                for j = 1:numIter
                    fprintf("\n2. Taking spectrum %d of %d...", j, numIter);
                    rawData = takeSpectrum(numPoints, spectrometer, integrationTimeMS);
                    rawFilename = writeSpectrumToFile(pixels, x, rawData, rawStem, ...
                        refWaveNumber, closestRef, zeros(1,6,'double'), ...
                        laserPowerFraction);
                    pause(1); % for 6 second acquisition interval with 5 second integration
                    
                    fprintf("3. Subtracting dark (can be all zeros if no dark given)...");
                    % instead of taking a spectrum, we are calculating it from previous
                    for i = 1:pixels
                        spectrumData(i) = rawData(i) - darkData(i);
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
                    spectrumFilename = writeSpectrumToFile(pixels, x, ...
                        spectrumData, dataStem,  refWaveNumber, closestRef, ...
                        denominator, laserPowerFraction);
                    if (firstTime == false)
                        for i = 1:pixels
                            difference(i) = spectrumData(i) - lastSpectrumData(i);
                        end
                    end
                    
                    % plot this iteration: Too many plots. Just plot averages
                    %plotStatus = plotSpectrum(firstTime, ...
                    %    x, darkData, rawData, spectrumData, ...
                    %    difference, denominator, 0, j);
                    
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
                
                avgFilename = writeSpectrumToFile(pixels, x, avg, avgStem, ...
                    refWaveNumber, closestRef, denominator, ...
                    laserPowerFraction);
                
                if (firstAverage == false)
                    for i = 1:pixels
                        differenceBetweenAverages(i) = avg(i) - lastAvgData(i);
                    end
                end
                % Too many plots
                % Plot the average spectra of numIter acquisitions
                if mod(counter,countBetweenPlots) == 0
                    plotStatus = plotSpectrum(firstAverage, ...
                        x, darkData, rawData, avg, ...
                        differenceBetweenAverages, denominator, 1, 0);
                end
                counter = counter + 1;
                
                % 12/12/2018 NEW: Here is where we do what used to be the post-
                % processing
                
                
                
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
            end % while loopCounter < increment
            
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
        end % while subdirNumber <= subdirMax
    end % if (myAns2 == 1)
end % if (myAns1 ~= 4)

function a = takeSpectrum(numPoints, spectrometer, integrationTimeMS)
    %spectrum = zeros(1, numPoints, 'double'); should not be necessary
    
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

function b = writeSpectrumToFile(pixels, x, myData, stem, refWaveNumber,...
    closestRef, denominator, laserPowerFraction)
    % myData could be different things: dark, raw, spectrum, scaled
    % spectrum. 

    %size(x) % This is reported as 1x1024
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
    
    fprintf('getDenominator with numPointsEachSide = %d\n', ...
        numPointsEachSide);
    
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
    fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
        numPointsEachSide);
    startIndex = closestRef - numPointsEachSide;
    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(startIndex);
        fprintf('index: %d, spectrum: %g\n', startIndex, spectrum(startIndex));
        startIndex = startIndex + 1;
    end
    denominator = sum/numPointsToIntegrate;
    fprintf('denominator: %g\n', denominator);
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
    pwd
    prompt = '\nIs this study: Alginate (1), PEG (2) or polyHEMAcoAc (3)?>';
    gelType = input(prompt);
    % Switch on gelType and add to path
    switch gelType
        case 1
            gelTypeName = 'alginate/';
        case 2
            gelTypeName = 'PEG/';
        case 3
            gelTypeName = 'polyHEMAcoAc/';
    end
    
    prompt = '\nEnter gel#>';
    gelNumber = input(prompt);
    gelInstance = sprintf('gel %d/', gelNumber);
    
    prompt = '\nEnter study name> ';
    dir2 = input(prompt, 's');
    
    % Now put it all together
    dir1 = '../../Data/Made by Sureyya/'; % just use relative directory
                                          % skip use of pwd for now
    studyName = strcat(dir1, gelTypeName, gelInstance, dir2);
    if ~exist(studyName, 'dir')
        [status, msg, msgID] = mkdir(studyName); % Make all intermediate dirs?
        if status == 1 % keep going
            s = strcat(studyName, '/');
            % Make the subdirs inside 's'
            sumStatus = 0;
            for i = 1,subdirMax
                sub = strcat(s, subdirs(i));
                % mkdir(s1) works at the cmd line, but via script, error is:
                % Error using mkdir. Argument must contain a character vector.
                [status, msg, msgID] = mkdir(char(sub));
                sumStatus = sumStatus + status;
            end

            status = status1 + status2 + status3 + status4 + ...
                status5 + status6 + status7 + status8 + status9;
            if sumStatus == 9
                g = 1;
            else
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