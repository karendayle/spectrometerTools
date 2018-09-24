% Wasatch Continuous Spectra with Difference calculation and plot intensity as a
% ratio over a user selected wavenumber TO DO: UPDATE
%
% Based on WasatchDemo.m from Wasatch Photonics
%
% Dayle Kotturi July 2018
%
% Optionally take a dark at the start of every run. Store it. Subtract it from 
% each subsequent spectra. What is hard about this is that the sample is in
% the flowcell, screwed in with 12 screws and a liquid seal. Ideally, the
% "dark" would be the flowcell, sealed and screwed together without the
% sample. When the sample is just sitting on quartz, it is easier. Assuming
% quartz homogeneous, slide can just be repositioned to move sample out of
% laser line.

% Add possibility of using a dark from file instead of taking it at the
% start of the run. This feature is needed when a dark cannot be taken
% because the sample is sealed inside the flowcell. Once per day or per
% run, the flowcell full of fluid could be sensed to create a new dark.

% Ratiometric part...
% Prompt user for the wavenumber of the intensity to use as the
% denominator.

true = 1;
false = 0;
numPoints = 1024; % fixed. Based on physical char of spectrometer grating
% to avoid array changing size every time it's assigned in the loop
%darkData = zeros(1, numPoints, 'double');
spectrumData = zeros(1, numPoints, 'double');
lastSpectrumData = zeros(1, numPoints, 'double');
%rawData = zeros(1, numPoints, 'double');
difference = zeros(1, numPoints, 'double');
x = zeros(1, numPoints, 'double'); 
avg = zeros(1, numPoints, 'double');
integrationTimeMS = 5000;
xMin = 0;
xMax = 1800;
yMin = 0;
yMax = 12000;
darkStem = '../../Data/dark-%s.txt';
rawStem = '../../Data/rawSpectrum-%s.txt';
dataStem = '../../Data/spectrum-%s.txt';
avgStem = '../../Data/avg-%s.txt';
numIter = 5; % number of spectra to average 
%numPointsEachSide = 0; % number of points used on either side of
% reference wavenumber to integrate for the denominator of normalized
% spectrum
laserPowerFraction = 0.333;
closestRef = 0;
refWaveNumber = 0;
denominator = zeros(1, 6, 'double'); % calculate denominators based on an
                                     % increasing number of points
% load the DLL
% 32 bit dll: NET.addAssembly('C:\Program Files (x86)\Wasatch Photonics\Wasatch.NET\WasatchNET.dll');
% 64 bit dll: 
dll = NET.addAssembly('C:\Program Files\Wasatch Photonics\Wasatch.NET\WasatchNET.dll');

% get a handle to the Driver Singleton
driver = WasatchNET.Driver.getInstance();

% enumerate any connected spectrometers
numberOfSpectrometers = driver.openAllSpectrometers();
fprintf('%d spectrometers found.\n', numberOfSpectrometers);
if numberOfSpectrometers <= 0
	return
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
        if (myAns1 == 2)
            fileID = -1;
            errmsg = '';
            while fileID < 0 
                disp(errmsg);
                filename = input ('3. Open file in C:\\Users\dayle.kotturi\\Documents\\Data\\Official Dark: ', ...
                    's');
                [fileID,errmsg] = fopen(fullfile ...
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
    end

    % main acquisition loop
    for j = 1:numIter
        fprintf("\n2. Taking spectrum...");
        rawData = takeSpectrum(numPoints, spectrometer, integrationTimeMS);
        rawFilename = writeSpectrumToFile(pixels, x, rawData, rawStem, ...
            refWaveNumber, closestRef, zeros(1,6,'double'), ...
            laserPowerFraction);
        %pause(59.9); %regular continuous mode for 100 ms integration
        pause(10); % for 15 second acquisition interval with 5 second integration
        
        fprintf("3. Subtracting dark (can be all zeros if no dark given)...");
        % instead of taking a spectrum, we are calculating it from previous
        for i = 1:pixels
            spectrumData(i) = rawData(i) - darkData(i);
            avg(i) = avg(i) + spectrumData(i);
        end
        
        % new: call getDenominator here.
        % Calculate the denominator using a window of 0 - 5 points
        % on either side of refWaveNumber. This maps to: 1 - 11 total
        % intensities used to calculate the denominator.
        for i = 1:6
            numPointsEachSide = i - 1;
            denominator(i) = getDenominator(closestRef, ...
                numPointsEachSide, ...
                numPoints, spectrumData);
        end
        
        % IMPORTANT: write the unnormalized data and the denom to file,
        % not the normalized data. Okay, it doesn't have to be this way,
        % just a decision.
        spectrumFilename = writeSpectrumToFile(pixels, x, ...
            spectrumData, dataStem,  refWaveNumber, closestRef, ...
            denominator, laserPowerFraction);
        if (firstTime == false)
            for i = 1:pixels
                difference(i) = spectrumData(i) - lastSpectrumData(i);
            end
        else
            difference = zeros();
        end
        
        % plot this iteration
        plotStatus = plotSpectrum(firstTime, xMin, xMax, yMin, yMax, ...
            wavelengths, x, darkData, rawData, spectrumData, ...
            difference, spectrumFilename, denominator);
        
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
    for i=1:pixels % BUG FIX: 9/24: this was numIter, and so explains
                   % why the first 5 points were smaller magnitude
        avg(i) = avg(i)/numIter;
    end
    
    % Calculate the denominator for the average
    % NEW 9/24: instead of just writing the denom of the last spectrum
    for i = 1:6
        numPointsEachSide = i - 1;
        denominator(i) = getDenominator(closestRef, ...
            numPointsEachSide, numPoints, avg);
    end
    
    avgFilename = writeSpectrumToFile(pixels, x, avg, avgStem, ...
        refWaveNumber, closestRef, denominator, ...
        laserPowerFraction);

    % Plot the average spectra of numIter acquisitions
    plotStatus = plotSpectrum(firstTime, xMin, xMax, yMin, yMax, ...
        wavelengths, x, darkData, rawData, avg, ...
        difference, avgFilename, denominator);
end

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

function c = plotSpectrum(firstTime, xMin, xMax, yMin, yMax, ...
    wavelengths, wavenumbers, dark, rawSpectrum, spectrum, difference, ...
    specFilename, denominator)
% local function to graph the spectrum
    title(specFilename); % put filename of spectrum on the plot for traceability
    figure
    subplot(2,2,1)
    %plot(wavelengths, spectrum, 'blue', wavelengths, difference, 'red');
    %plot(wavenumbers, spectrum, 'blue', wavenumbers, difference, 'red');
    plot(wavenumbers, rawSpectrum, 'green');
    title('Raw');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('Arbitrary Units (A.U.)'); % y-axis label
    %legend('blue = intensity','red = difference','Location','northoutside');
    %legend('green = raw intensity','Location','northoutside');
    %xlim([xMin xMax]);
    %ylim([yMin yMax]);
    
    subplot(2,2,2)
    %plot(wavelengths, dark, 'black');
    plot(wavenumbers, dark, 'black');
    title('Dark');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('Arbitrary Units (A.U.)'); % y-axis label
    %legend('black = intensity of dark','Location','northoutside');
    %xlim([xMin xMax]);
    %ylim([yMin yMax]);
    
    subplot(2,2,3)
    %plot(wavelengths, spectrum, 'blue');
    plot(wavenumbers, spectrum, 'blue');
    title('Raw - Dark');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('Arbitrary Units (A.U.)'); % y-axis label
    %xlim([xMin xMax]);
    %ylim([yMin yMax]);
    
    %if (firstTime == false)
    % if not firstTime, do the plot the difference
    %    subplot(2,2,4)
    %    %plot(wavelengths, difference, 'red');
    %    plot(wavenumbers, difference, 'red');
    %    title('Difference to previous');
    %    xlabel('Wavenumber (cm^-1)'); % x-axis label
    %    ylabel('Arbitrary Units (A.U.)'); % y-axis label
    %    %xlim([xMin xMax]);
    %    %ylim([yMin yMax]);
    %end
    
    if (denominator(1) ~= 0)
    % Plot the normalized data
        subplot(2,2,4)
        %plot(wavelengths, spectrum/denominator, 'red');
        plot(wavenumbers, spectrum/denominator(1), 'red', ...
            wavenumbers, spectrum/denominator(2), 'blue', ...
            wavenumbers, spectrum/denominator(3), 'black', ...
            wavenumbers, spectrum/denominator(4), 'green', ...
            wavenumbers, spectrum/denominator(5), 'magenta', ...
            wavenumbers, spectrum/denominator(6), 'cyan');
        myTitle = sprintf('Ratiometric with denominator based on different #points');
        title(myTitle);
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('(A.U.)/(A.U.)'); % y-axis label
        %xlim([xMin xMax]);
        %ylim([yMin yMax]);
        legend('1 point','3 points','5 points','7 points','9 points', ...
            '11 points');
    end
    
    figure
    myTitle = sprintf('Ratiometric with denominator based on different #points');
    title(myTitle);
    subplot(2,2,1)
    plot(wavenumbers, spectrum/denominator(1), 'red');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('(A.U.)/(A.U.)'); % y-axis label
    myLegend = sprintf('denom %g from 1 point under curve', denominator(1));
    legend(myLegend);
    
    subplot(2,2,2)
    plot(wavenumbers, spectrum/denominator(2), 'blue');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('(A.U.)/(A.U.)'); % y-axis label
    myLegend = sprintf('denom %g from 3 points under curve', denominator(2));
    legend(myLegend);
    
    subplot(2,2,3)
    plot(wavenumbers, spectrum/denominator(3), 'black');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('(A.U.)/(A.U.)'); % y-axis labellegend('denom from 5 points under curve');
    myLegend = sprintf('denom %g from 5 points under curve', denominator(3));
    legend(myLegend);
        
    subplot(2,2,4)
    plot(wavenumbers, spectrum/denominator(4), 'green');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('(A.U.)/(A.U.)'); % y-axis labellegend('denom from 7 points under curve');
    myLegend = sprintf('denom %g from 7 points under curve', denominator(4));
    legend(myLegend);
    
    
    figure
    title('Ratiometric with denominator based on different #points');
    subplot(2,2,1)
    plot(wavenumbers, spectrum/denominator(5), 'magenta');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('(A.U.)/(A.U.)'); % y-axis label
    myLegend = sprintf('denom %g from 9 points under curve', denominator(5));
    legend(myLegend);
    
    subplot(2,2,2)
    plot(wavenumbers, spectrum/denominator(6), 'cyan');
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('(A.U.)/(A.U.)'); % y-axis label
    myLegend = sprintf('denom %g from 11 points under curve', denominator(6));
    legend(myLegend);
    
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
