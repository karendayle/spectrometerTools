% 20210417 change stackedplot to subplot
addpath('../functionLibrary'); % provide path to asym

close all; % close all plots from previous runs
numPoints = 1024;
autoSave = 1;

for step = 1:12
    if autoSave
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    switch step
        case 1
            %myTitle = 'Step 1 MBA on AuNPs';
            myTitle = 'Figure S1';
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
            myTitle = 'Figure S2';
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
            %myTitle = 'Step 3 MBA AuNPs with NaCO3 and CaCl2';
            myTitle = 'Figure S3';
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
            %myTitle = 'Step 4 First wash with NaCO3';
            myTitle = 'Figure S4';
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
            %myTitle = 'Step 5 After first bilayer PDADMAC and PSS';
            myTitle = 'Figure S5';
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
            %myTitle = 'Step 6 After five bilayers';
            myTitle = 'Figure S6';
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
            %myTitle = 'Step 7 After ten bilayers';
            myTitle = 'Figure S7';
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
            %myTitle = 'Step 8 After first wash';
            myTitle = 'Figure S8';
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
            % myTitle = 'Step 9 After third wash and into 10mM pH7';
            myTitle = 'Figure S9';
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
            %myTitle = 'Step 10 In alginate gel at pH7';
            myTitle = 'Figure S10';
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
            % myTitle = 'Additional plot with ethanol';
            myTitle = 'Figure S11';
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
            % myTitle = 'Additional Plot without ethanol';
            myTitle = 'Figure S12';
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
    % CHOOSE one of these next two lines
    % refWaveNumber = 1582; % Use this to normalize y range to [0,1].
    refWaveNumber = 0; % Use this to skip first normalization
    
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
%                 fprintf("reference is at index %d\n", closestRef);
            end
        end 
    end
    
    % Calculate the denominator for the average
    if (refWaveNumber ~= 0)
        % numPointsEachSide = 0; % use this if you want norm'd max = 1
        numPointsEachSide = 2;   % use this if you want more points
        denominator = getDenominator(closestRef, ...
            numPointsEachSide, numPoints, avg);
        fprintf("step %d: denominator=%f\n", step, denominator);

        normalized = f/denominator;
        fprintf("step %d: max after normal'n by denom=%f\n", step, max(normalized));
    
        % 20201019 Since 5 points under the curve are used for the
        % normalization, need to normalize one more time to get vertical
        % range = [0,1]
        % Submitted version 1 of JBO paper used:
        % normalized = normalized/max(normalized);
        % but this has pb if the max is outside the final displayed range of x,
        % i.e. plot will be normalized to an unseen value and max shown will
        % be < 1. So, for version 2 of JBO paper use:
        % 340 - 865, which correspond to were raman shift 950 and 1800 are
        final = normalized/max(normalized(340:865));

        fprintf("step %d: max after normalized by max=%f\n", step, max(normalized(340:865)));
    else
        final = f;
    end
 
    %3. Good to keep going!
    % JBO version 1
    %newYlabels = {'dark','raw','raw-dark','avg','baseline','avg-base'};
    % JBO version 2
    newYlabels = {'Intensity'; '(a.u.)'};
        
    y=[dark(2,:); raw(2,:); spec(2,:); avg(2,:); e(1,:); f(:)'];

    for substep = 1:6
        ax(substep) = subplot(6,1,substep);
        plot(dark(1,:), y(substep,:)', 'LineWidth', 2);
        xlim([950 1800]);
        set(gca,'FontSize',10,'FontWeight','bold','box','off')
        hold on;
        if (step < 11)
            n(step,:) = final(:)'; % final is normalized or not, depending
                                   % on refWaveNumber
        end
        if (substep <6)
            set(ax(substep),'XTickLabel','')
            % Set the color of the X-axis in the top axes
            % to the axes background color
            set(ax(substep),'XColor',get(gca,'Color'))
            % JBO version 1
            % ylabel(newYlabels(substep),'FontSize',10,'Rotation',90);
            % TO DO Reviewer 2 wants y label = "Intensity (a.u.)" 
            ylabel(newYlabels,'FontSize',10,'Rotation',90);
        end
        if substep == 6
            % Turn off the box so that only the left 
            % vertical axis and bottom axis are drawn
            % set(ax,'box','off')
            % TO DO Reviewer 2 wants y label = "Intensity (a.u.)" 
            ylabel(newYlabels,'FontSize',10,'Rotation',90);
            xlabel('Raman shift (cm^{-1})','FontSize',15); % affects the last plot, here it's #6
        end
    end 
    saveMyPlot(FigH, myTitle);
end

% Put the normalized plots from all steps on a single plot
% Helpful: https://www.mathworks.com/matlabcentral/answers/486898-change-yticks-using-a-stacked-plot
% 2021/04/18 now as subplot
if autoSave
    FigH = figure('Position', get(0, 'Screensize'));
else
    figure
end 
%myTitle = 'Final spectra for all steps';
myTitle = 'Figure 2';
% 2021/02/15 FontWeight is not a property of stackedplot and so errors
% out if passed in (below). Here, it is allowed but ignored by stackedplot
% JBO version 1
% newYlabels = {'Step 1','Step 2','Step 3','Step 4',...
%    'Step 5','Step 6', 'Step 7','Step 8','Step 9','Step 10'};
% TODO Reviewer 2 wants these to be "Intensity (a.u.)"
newYlabels = {'Intensity';'(a.u.)'}; % JBO version 2

for step = 1:10
    h = subplot(10,1,step);
    plot(dark(1,:), n(step,:)','LineWidth',2);
    set(gca,'FontSize',10,'FontWeight','bold','box','off');
    xlim([950 1800]);
    % ylabel(newYlabels(step),'FontSize',10,'Rotation',90); JBO version 1
    ylabel(newYlabels,'FontSize',10,'Rotation',90); % JBO version 2
    if step == 10
        xlabel('Raman shift (cm^{-1})','FontSize',15); % 2021/02/14 superscript not working
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
    dirStem = "C:\Users\karen\Documents\Data\Plots\";
    subDir = "plotAllSteps\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlot = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlot, 'png');
    g = 1;
end