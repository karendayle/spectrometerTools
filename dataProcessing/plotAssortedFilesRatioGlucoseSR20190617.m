% Plot files in different directories
% Dayle Kotturi October 2018

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

% Change next lines to what you want to plot
global plotOption;
%plotOption = 1; % alg gox1
%plotOption = 2; % alg gox2 1 hour soak, punch8 data for 400mg/dL data is
%missing
plotOption = 3; % alg gox2 overnight soak

% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
global dirStem

if plotOption == 1
    dirStem = "H:\Documents\Data\Made by Sureyya\Alginate\alg gox3\flowRate\";
    subDirStem1 = "1 4mLmin";
    subDirStem2 = "2 3mLmin";
    subDirStem3 = "3 2mLmin";
    subDirStem4 = "4 1mLmin";
    subDirStem5 = "5 0mLmin";
else
    if plotOption == 2
        dirStem = "H:\Documents\Data\Made by Sureyya\Alginate\alg gox2\";
        subDirStem1 = "punch4 0mgdL";
        subDirStem2 = "punch5 100mgdL";
        subDirStem3 = "punch6 200mgdL";
        subDirStem4 = "punch7 300mgdL";
        subDirStem5 = "punch8 400mgdL";
    else
        if plotOption == 3
            %dirStem = "C:\Users\karen\Documents\Data\Recovery2\";
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\alg gox2\";
            subDirStem1 = "punch4 0mgdL nextday";
            subDirStem2 = "punch5 100mgdL nextday";
            subDirStem3 = "punch6 200mgdL nextday";
            subDirStem4 = "punch7 300mgdL nextday";
            subDirStem5 = "punch8 400mgdL nextday";
        end
    end
end

global lineThickness;
lineThickness = 2;
global numPoints;
numPoints = 1024;

global xRef;
xRef = 713; % index where the reference peak is 
                % COO- at 1582
                % TO DO: read from avg*.txt file

global offset;
offset = 300;

global xMin;
global xMax;
global yMin;
global yMax;
xMin = 950;
xMax = 1800;
yMin = 0;
yMax = 20.0;
myFont = 30;

global myDebug;
myDebug = 0;

% Make them all the same for legibility
myTitleFont = 30;
myLabelFont = 30;
myTextFont = 30;

figure 

for K = 1:5

    switch K
        case 1
            pHcolor = green;
            num1 = myPlot(subDirStem1, pHcolor);
            fprintf('Case 1: %d spectra plotted in green\n', num1);            
        case 2
            pHcolor = gold;
            num2 = myPlot(subDirStem2, pHcolor);
            fprintf('Case 1: %d spectra plotted in gold\n', num2);
        case 3
            pHcolor = rust;
            num3 = myPlot(subDirStem3, pHcolor);
            fprintf('Case 3: %d spectra plotted in rust\n', num3);
        case 4
            pHcolor = red;
            num4 = myPlot(subDirStem4, pHcolor);
            fprintf('Case 4: %d spectra plotted in red\n', num4);
        case 5
            pHcolor = cherry;
            num5 = myPlot(subDirStem5, pHcolor);
            fprintf('Case 5: %d spectra plotted in cherry\n', num5);                       
    end
end   
ylim([0. 1.2])
y = 0.9; 
x = 1200; 
deltaY = 0.1;

if plotOption == 1
    y = 0.9; 
    x = 1200;
    deltaY = 0.1;
    text(x, y, '4 mL/min', 'Color', green, 'FontSize', myTextFont);
    text(x, y, '________', 'Color', green, 'FontSize', myTextFont);
    y = y - deltaY;
    text(x, y, '3 mL/min', 'Color', gold, 'FontSize', myTextFont);
    text(x, y, '________', 'Color', gold, 'FontSize', myTextFont);
    y = y - deltaY;
    text(x, y, '2 mL/min', 'Color', rust, 'FontSize', myTextFont);
    text(x, y, '________', 'Color', rust, 'FontSize', myTextFont);
    y = y - deltaY;
    text(x, y, '1 mL/min', 'Color', red, 'FontSize', myTextFont);
    text(x, y, '________', 'Color', red, 'FontSize', myTextFont);
    y = y - deltaY;
    text(x, y, '0 mL/min', 'Color', cherry, 'FontSize', myTextFont);
    text(x, y, '________', 'Color', cherry, 'FontSize', myTextFont);
    y = y - deltaY;
else
    if plotOption == 2
        y = 0.9; 
        x = 1200;
        deltaY = 0.1;
        text(x, y, 'Punch4 0 mg/dL', 'Color', green, 'FontSize', myTextFont);
        text(x, y, '______________', 'Color', green, 'FontSize', myTextFont);
        y = y - deltaY;
        text(x, y, 'Punch5 100 mg/dL', 'Color', gold, 'FontSize', myTextFont);
        text(x, y, '________________', 'Color', gold, 'FontSize', myTextFont);
        y = y - deltaY;
        text(x, y, 'Punch6 200 mg/dL', 'Color', rust, 'FontSize', myTextFont);
        text(x, y, '________________', 'Color', rust, 'FontSize', myTextFont);
        y = y - deltaY;
        text(x, y, 'Punch7 300 mg/dL', 'Color', red, 'FontSize', myTextFont);
        text(x, y, '________________', 'Color', red, 'FontSize', myTextFont);

% The 400mg/dL files for 1h soak were lost so only show up to 300mg/dL
%             text(x, y, 'Punch8 400 mg/dL', 'Color', cherry, 'FontSize', myTextFont);
%             text(x, y, '________________', 'Color', cherry, 'FontSize', myTextFont);
%             y = y - deltaY;
    else   
        if plotOption == 3
            y = 1.1; 
            x = 1625;
            deltaY = 0.1;
%             text(x, y, 'Punch4 0 mg/dL', 'Color', green, 'FontSize', myTextFont);
%             text(x, y, '______________', 'Color', green, 'FontSize', myTextFont);
%             y = y - deltaY;
%             text(x, y, 'Punch5 100 mg/dL', 'Color', gold, 'FontSize', myTextFont);
%             text(x, y, '________________', 'Color', gold, 'FontSize', myTextFont);
%             y = y - deltaY;
%             text(x, y, 'Punch6 200 mg/dL', 'Color', rust, 'FontSize', myTextFont);
%             text(x, y, '________________', 'Color', rust, 'FontSize', myTextFont);
%             y = y - deltaY;
%             text(x, y, 'Punch7 300 mg/dL', 'Color', red, 'FontSize', myTextFont);
%             text(x, y, '________________', 'Color', red, 'FontSize', myTextFont);
%             y = y - deltaY;
%             text(x, y, 'Punch8 400 mg/dL', 'Color', cherry, 'FontSize', myTextFont);
%             text(x, y, '________________', 'Color', cherry, 'FontSize', myTextFont);
%             y = y - deltaY;
            % for IEEE figure
            text(x, y, '0 mg/dL', 'Color', green, 'FontSize', myTextFont);
            text(x, y, '_______', 'Color', green, 'FontSize', myTextFont);
            y = y - deltaY;
            text(x, y, '100 mg/dL', 'Color', gold, 'FontSize', myTextFont);
            text(x, y, '_________', 'Color', gold, 'FontSize', myTextFont);
            y = y - deltaY;
            text(x, y, '200 mg/dL', 'Color', rust, 'FontSize', myTextFont);
            text(x, y, '_________', 'Color', rust, 'FontSize', myTextFont);
            y = y - deltaY;
            text(x, y, '300 mg/dL', 'Color', red, 'FontSize', myTextFont);
            text(x, y, '_________', 'Color', red, 'FontSize', myTextFont);
            y = y - deltaY;
            text(x, y, '400 mg/dL', 'Color', cherry, 'FontSize', myTextFont);
            text(x, y, '_________', 'Color', cherry, 'FontSize', myTextFont);
            y = y - deltaY;
        end
    end
end
if plotOption == 2
    text(x, y, 'o = local peak near 1430cm^-^1', 'Color', black, 'FontSize', myTextFont);
    y = y - deltaY;
    text(x, y, '+ = local peak near 1702cm^-^1', 'Color', black, 'FontSize', myTextFont);
% else
%     text(x, y, '. = peak near 1430cm^-^1/peak near 1702cm^-^1', 'Color', black, 'FontSize', myTextFont);
end
hold off
if plotOption == 1
    title('54nm MBA Au NPs in alginate GOx gel#3 in flowcell with 400mg/dL glucose at various flow rates', ...
        'FontSize', myTitleFont);
else
    if plotOption == 2
        title('54nm MBA Au NPs in alginate GOx gel#2 soaked in static glucose buffer for 1 hour on quartz', ...
            'FontSize', myTitleFont);
%     else for IEEE figure
%         title('54nm MBA Au NPs in alginate GOx gel#2 soaked in static glucose buffer overnight on quartz', ...
%         'FontSize', myTitleFont);
    end
end

xlabel('Wavenumber (cm^-^1)', 'FontSize', myLabelFont); % x-axis label
ylabel('Normalized Intensity', 'FontSize', myLabelFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
% Plot each spectrum (intensity vs wavenumber in a new color overtop

% Bring in inset now
% [bottomleftcornerXposition bottomleftcornerYposition width height]
axes('pos',[.255 .4 .44 .5]); 
imshow('R:\Students\Dayle\Data\Made by Sureyya\Alginate\alg gox2\framed inset.jpg');

hold on
plot(1430.19, 0, 1430.19, 0.4);
hold off

function d = getDenominator(closestRef, numPointsEachSide, numPoints, spectrum)
    global myDebug
    % use the closestRef as the x-value of the center point of the peak
    % sum the points from x=(closestRef - numPointsIntegrated) to 
    % x=(closestRef + numPointsIntegrated) and then divide by number of
    % points to average and scale it.
    
    if myDebug 
        fprintf('getDenominator with numPointsEachSide = %d\n', ...
            numPointsEachSide);
    end
    
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
    if myDebug 
        fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
            numPointsEachSide);
    end
    startIndex = closestRef - numPointsEachSide;
    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(startIndex);
        if myDebug
            fprintf('index: %d, spectrum: %g\n', startIndex, spectrum(startIndex));
        end
        startIndex = startIndex + 1;
    end
    denominator = sum/numPointsToIntegrate;
    if myDebug
        fprintf('denominator: %g\n', denominator);
    end
    d = denominator;
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

function g = myPlot(subDirStem, myColor)
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
    
    sum = zeros(1, numPoints, 'double');
    avg = zeros(1, numPoints, 'double');
    sumSq = zeros(1, numPoints, 'double');
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
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');    

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
        hold on
        fprintf('%d\n', I);
        %pause(1);
    end
    g = numberOfSpectra;
end
  