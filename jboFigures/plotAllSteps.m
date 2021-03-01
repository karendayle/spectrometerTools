

close all; % close all plots from previous runs
numPoints = 1024;
autoSave = 1;
for step = 1:12
    switch step
        case 1
            myTitle = 'Step 1 MBA on AuNPs';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA on NPs 3\";
            thisfilename = dirStem + "1\dark-2020-10-05-22-10-13.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-22-10-31.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-22-10-33.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-22-10-50.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

        case 2
            myTitle = 'Step 2 MBA AuNPs into NaCO3';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA NPs into NaCO3 1\";
            thisfilename = dirStem + "1\dark-2020-10-05-22-18-33.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-22-18-41.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-22-18-43.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-22-19-00.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

        case 3
            myTitle = 'Step 3 MBA AuNPs with NaCO3 and CaCl';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA NPs into NaCO3 CaCl 1\";
            thisfilename = dirStem + "1\dark-2020-10-05-22-23-57.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-22-24-14.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-22-24-16.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-22-24-33.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 4
            myTitle = 'Step 4 First wash with NaCO3';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\first wash 1\";
            thisfilename = dirStem + "1\dark-2020-10-05-22-37-26.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-22-37-42.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-22-37-44.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-22-38-00.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 5
            myTitle = 'Step 5 After first bilayer PDADMAC and PSS';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\after first bilayer 1\";
            thisfilename = dirStem + "1\dark-2020-10-05-22-45-04.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-22-45-16.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-22-45-18.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-22-45-36.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 6
            myTitle = 'Step 6 After five bilayers';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\after five bilayers 1\";
            thisfilename = dirStem + "1\dark-2020-10-05-22-50-02.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-22-50-32.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-22-50-34.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-22-50-51.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 7
            myTitle = 'Step 7 After ten bilayers';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\after ten bilayers 1\";
            thisfilename = dirStem + "1\dark-2020-10-05-22-56-15.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-22-56-53.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-22-56-55.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-22-57-12.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 8
            myTitle = 'Step 8 After first wash';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\after first wash\";
            thisfilename = dirStem + "1\dark-2020-10-05-23-01-33.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-23-01-43.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-23-01-45.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-23-02-02.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 9
            myTitle = 'Step 9 After third wash and into 10mM pH7';
            % Two sets were acquired "third wash 1" and "third wash 2".
            % Filenames need to match dataset
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\third wash 1\";
%            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\third wash 2\";
            thisfilename = dirStem + "1\dark-2020-10-05-23-06-30.txt";
%             thisfilename = dirStem + "1\dark-2020-10-05-23-10-15.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-05-23-06-40.txt";
%             thisfilename = dirStem + "1\rawSpectrum-2020-10-05-23-10-26.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-05-23-06-42.txt";
%             thisfilename = dirStem + "1\spectrum-2020-10-05-23-10-28.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-05-23-06-59.txt";
%             thisfilename = dirStem + "1\avg-2020-10-05-23-10-44.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 10
            myTitle = 'Step 10 In alginate gel at pH7';
            % Two sets were acquired "third wash 1" and "third wash 2".
            % Filenames need to match dataset
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\in gel 2 5000ms integ\";
            thisfilename = dirStem + "1\dark-2020-10-14-21-31-32.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-14-21-31-43.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-14-21-31-45.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-14-21-32-19.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 11
            myTitle = 'Additional plot with ethanol';
            % Two sets were acquired "third wash 1" and "third wash 2".
            % Filenames need to match dataset
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\ethanol 3 5000 ms integ\";
            thisfilename = dirStem + "1\dark-2020-10-15-22-16-58.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-15-22-17-12.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-15-22-17-15.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-15-22-17-50.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID); 
            
        case 12
            myTitle = 'Additional Plot without ethanol';
            % Two sets were acquired "third wash 1" and "third wash 2".
            % Filenames need to match dataset
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\no ethanol 1 5000 ms integ\";
            thisfilename = dirStem + "1\dark-2020-10-15-22-07-26.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\rawSpectrum-2020-10-15-22-07-38.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\spectrum-2020-10-15-22-07-40.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\avg-2020-10-15-22-08-14.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID); 
    end
    
    % Fix the mistake that normalization was done before baseline
    % correction. This applies ONLY to the 20201005 dataset
    
    %1. Use avg spectrum as input and do baseline correction
    [e f] = correctBaseline(avg(2,:)'); % input was normalized'
    %2. Use baseline corrected spectrum as input and normalize it.
    refWaveNumber = 1582;
    numPoints = 1024;
    
    closestRef = 0; % set default value to begin
    % Determine closestRef
    if (refWaveNumber ~= 0) 
        for i = 1:(numPoints-1)
            % There is likely no exact match. Just find the value closest to
            % requested
            if ((avg(1,i) <= refWaveNumber) && (avg(1,i+1) > refWaveNumber))
                % store i as the place 
                closestRef = i;
                fprintf("reference is at %d\n", closestRef);
            end
        end 
    end
    
    % Calculate the denominator for the average
    if (refWaveNumber ~= 0)
        % numPointsEachSide = 0; % use this if you want norm'd max = 1
        numPointsEachSide = 2;   % use this if you want more points
        denominator = getDenominator(closestRef, ...
            numPointsEachSide, numPoints, avg);
    else
        denominator = 1.0;
    end
    if (denominator ~= 0)
        % Plot the normalized data
        normalized = f/denominator;
    else
        normalized = f; % 20201007 Fixed. numerator was spectrum
    end
    % 20201019 Since 5 points under the curve are used for the
    % normalization, need to normalize one more time to get vertical
    % range = [0,1]
    normalized = normalized/max(normalized);
    %3. Good to keep going!

    if autoSave
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    
    % old set(gca,'FontSize', 20);
    set(gca,'FontSize',20,'FontWeight','bold','box','off') % 2021/02/15
    newYlabels = {'dark','raw','raw-dark','avg','baseline','avg-baseline','normalized'};
    y=[dark(2,:); raw(2,:); spec(2,:); avg(2,:); e(1,:); f(:)'; normalized(:)';];
    h = stackedplot(dark(1,:), y', ...
        'DisplayLabels', newYlabels, 'FontSize', 15);
    if (step < 11)
        n(step,:) = normalized(:)';
    end
    
    axesProps = struct(h.AxesProperties(7));  
    axesProps.Axes.XLabel.Interpreter = 'tex';
    axesProps.Axes.YLim = [0 (max(normalized))]; % maybe round upwards?
    h.xlabel('Wavenumber (cm^{-1})'); % affects the last plot, here it's #6
    h.XLimits = [950 1800]; % 2021/02/14 adding limits
    saveMyPlot(FigH, myTitle);
end

% Put the normalized plots from all steps on a single plot
% Helpful: https://www.mathworks.com/matlabcentral/answers/486898-change-yticks-using-a-stacked-plot
% Maybe better as subplot
if autoSave
    FigH = figure('Position', get(0, 'Screensize'));
else
    figure
end 
myTitle = 'Normalized spectra for all steps';
% 2021/02/15 FontWeight is not a property of stackedplot and so errors
% out if passed in (below). Here, it is allowed but ignored by stackedplot
set(gca,'FontSize',20,'FontWeight','bold','box','off');
newYlabels = {'Step 1:','Step 2:','Step 3:','Step 4:','Step 5:','Step 6:', 'Step 7:','Step 8:','Step 9:','Step 10:'};
h = stackedplot(dark(1,:)', n', ...
    'DisplayLabels', newYlabels, 'FontSize', 15); % applied to both labels and tick labels
for i = 1:numel(h.AxesProperties)
    h.AxesProperties(i).YLimits = [0 1];
    h.XLimits = [950 1800]; % 2021/02/14 adding limits
    if i == numel(h.AxesProperties)
        axesProps = struct(h.AxesProperties(i));  
        axesProps.Axes.XLabel.Interpreter = 'tex';
        h.xlabel('Wavenumber (cm^{-1})'); % 2021/02/14 superscript not working
    end
end
saveMyPlot(FigH, myTitle);

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

function g = saveMyPlot(FigH, myTitle)
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlot = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlot, 'png');
    g = 1;
end