% This script plots 20220508 dataset for MBA under a 2mm thick phantom

addpath('../../functionLibrary');

close all; % close all plots from previous runs

% RGB
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];
magenta = [1.0, 0.0, 1.0];
punchColor = [red; green; ciel; purple; gold];
numPoints = 1024;
autoSave = 0;

% Extract the 1584 peak intensities from the three avg*.txt files
% for all offsets (0-4mm) when MBA is under 1 phantom.
% There will be a total of 3x5=15 intensities to plot for depth=0.5mm
% Repeat the above for the other depths: 1.0mm, 1.5mm, 2.0mm (future) and
% possibly 0.0mm (for completeness).

numDepth = 1; % depth = 0.5, 1.0, 1.5 mm
numOffset = 5; % uncovered 0 offset, then covered with offset = 0.0-4.0mm
numAvg = 3; % each measurement consists of 3 averaged spectra
for L = 1:numDepth 
    switch L
        case 1 % depth = 0mm uncovered
            for K = 1:numOffset
                switch K
                    case 1
                        dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2mmphant 0mm 2s\1";
                    case 2
                        dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2mmphant 1mm 2s\1"; 
                    case 3
                        dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2mmphant 2mm 2s\1";
                    case 4
                        dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2mmphant 3mm 2s\1";
                    case 5
                        dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2mmphant 4mm 2s\1";
                end
                            
                str_dir_to_search = dirStem; % args need to be strings
                dir_to_search = char(str_dir_to_search);
                txtpattern = fullfile(dir_to_search, 'avg*.txt');
                dinfo = dir(txtpattern);         
                for (I = 1 : length(dinfo))
                    thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                    fileID = fopen(thisfilename,'r');
                    [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
                    fclose(fileID);
                    % Returns trend as 'e' and baseline corrected signal as 'f'
                    [e, f] = correctBaseline(thisdata1(2,:)');  
                    intensityPeak1(L,K,I) = f(406); % MBA 1072 cm-1 peak
                    intensityPeak2(L,K,I) = f(714); % MBA 1584 cm-1 peak
                    intensityPeak3(L,K,I) = f(108); % phantom peak
                end
            end
    end
end

if autoSave
    FigH = figure('Position', get(0, 'Screensize'));
else
    figure
end

depth = [2];
% plot intensities vs depth, using color to identify the offset and marker
% to identify the peak
for L=1:numDepth
    for K=1:numOffset
        for I=1:numAvg
            plot(depth(L)-0.05, intensityPeak1(L,K,I), 's', ...
                'Color', punchColor(K,:), 'MarkerSize',30, ...
                'LineWidth', 2);
            hold on
            plot(depth(L), intensityPeak2(L,K,I), 'o', ...
                'Color', punchColor(K,:), 'MarkerSize',30, ...
                'LineWidth', 2);
            hold on
            plot(depth(L)+0.05, intensityPeak3(L,K,I), '^', ...
                'Color', punchColor(K,:), 'MarkerSize',30, ...
                'LineWidth', 2);
            hold on
        end
    end
end
xlim([0 2.5]);
% ylim([0 2000]);
myTextFont = 30;
myTextFont2 = 35;
xlabel('Depth below surface to top of target (mm)', 'FontSize', myTextFont); % x-axis label
ylabel('Intensity (A.U.)', 'FontSize', myTextFont); % y-axis label
y = 170; 
x = 0.1; 
deltaY = 7;
% label laser output power used
% text(x, y, 'Laser output power: 100 mW', 'Color', black, 'FontSize', myTextFont);
% y = y - deltaY;
% % legend explaining color, marker
% text(x, y, 'MBA peak at 1072 cm-1: square', 'Color', black, 'FontSize', myTextFont);
% y = y - deltaY;
% text(x, y, 'MBA peak at 1584 cm-1: circle', 'Color', black, 'FontSize', myTextFont);
% y = y - deltaY;
% text(x, y, 'Phantom peak at 487 cm-1: triangle', 'Color', black, 'FontSize', myTextFont);
% y = y - deltaY;
text(x, y, 'Detector offset from excitation:', 'Color', black, 'FontSize', myTextFont);
y = y - deltaY;
x = x + 0.02;
text(x, y, '0 mm', 'Color', punchColor(1,:), 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, '1 mm', 'Color', punchColor(2,:), 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, '2 mm', 'Color', punchColor(3,:), 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, '3 mm', 'Color', punchColor(4,:), 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, '4 mm', 'Color', punchColor(5,:), 'FontSize', myTextFont);

set(gca,'FontSize',myTextFont2,'FontWeight','bold','box','off');

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