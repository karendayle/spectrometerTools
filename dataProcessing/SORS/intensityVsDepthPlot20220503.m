% To do/fix: why does it look like only 1 trace per offset is drawn?
% Answer: because the 1D arrays one, two, ..., five are overwritten each
% time another avg*.txt file is read. True for previous plots as well.

addpath('../../functionLibrary');
figure
%close all; % close all plots from previous runs

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
punchColor = [magenta; red; rust; gold; green; ciel; blue; purple; ...
    black; cherry; magenta; red; rust; gold];
numPoints = 1024;
autoSave = 0;
for K = 1:5
    switch K
        case 1
%             myTitle = 'MBA 2 phant 0 mm redo2';
            dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2 phant 0 mm redo2\1";
            str_dir_to_search = dirStem; % args need to be strings
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern); % TO FIX: this returns a list of files and
                                     % I am handling them as if there is only 1
            for (I = 1 : length(dinfo))
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                fileID = fopen(thisfilename,'r');
                [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
                fclose(fileID);
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata1(2,:)');  
                one1072 = f(406);
                one1584 = f(714);
                plot(K, one1072, 's', 'Color', punchColor(K,:));
                hold on
                plot(K, one1584, 'o', 'Color', punchColor(K,:));
                hold on
            end

        case 2
%             myTitle = 'MBA 2 phant 1 mm redo2';
            dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2 phant 1 mm redo2\1"; 
            str_dir_to_search = dirStem; % args need to be strings
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern); % TO FIX: this returns a list of files and
                                     % I am handling them as if there is only 1
            for (I = 1 : length(dinfo))
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                fileID = fopen(thisfilename,'r');
                [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
                fclose(fileID);
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata1(2,:)');  
                two1072 = f(406);
                two1584 = f(714);
                plot(K, two1072, 's', 'Color', punchColor(K,:));
                hold on
                plot(K, two1584, 'o', 'Color', punchColor(K,:));
                hold on
            end

        case 3
%             myTitle = 'MBA 2 phant 2 mm redo2';
            dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2 phant 2 mm redo2\1";
            str_dir_to_search = dirStem; % args need to be strings
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern); % TO FIX: this returns a list of files and
                                     % I am handling them as if there is only 1
            for (I = 1 : length(dinfo))
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                fileID = fopen(thisfilename,'r');
                [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
                fclose(fileID);
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata1(2,:)');     
                three1072 = f(406);
                three1584 = f(714);
                plot(K, three1072, 's', 'Color', punchColor(K,:));
                hold on
                plot(K, three1584, 'o', 'Color', punchColor(K,:));
                hold on
            end
            
        case 4
%             myTitle = 'MBA 2 phant 3 mm redo2';
            dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2 phant 3 mm redo2\1";
            str_dir_to_search = dirStem; % args need to be strings
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern); % TO FIX: this returns a list of files and
                                     % I am handling them as if there is only 1
            for (I = 1 : length(dinfo))
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                fileID = fopen(thisfilename,'r');
                [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
                fclose(fileID);
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata1(2,:)');    
                four1072 = f(406);
                four1584 = f(714);
                plot(K, four1072, 's', 'Color', punchColor(K,:));
                hold on
                plot(K, four1584, 'o', 'Color', punchColor(K,:));
                hold on
            end
            
        case 5
%             myTitle = 'MBA 2 phant 4 mm redo2';
            dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\MBA 2 phant 4 mm redo2\1";
            str_dir_to_search = dirStem; % args need to be strings
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern); % TO FIX: this returns a list of files and
                                     % I am handling them as if there is only 1
            for (I = 1 : length(dinfo))
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                fileID = fopen(thisfilename,'r');
                [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
                fclose(fileID);
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata1(2,:)');        
                five1072 = f(406);
                five1584 = f(714);
                plot(K, five1072, 's', 'Color', punchColor(K,:));
                hold on
                plot(K, five1584, 'o', 'Color', punchColor(K,:));
                hold on
            end     
            
    end
end


    if autoSave
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    
    % old set(gca,'FontSize', 20);
    set(gca,'FontSize',20,'FontWeight','bold','box','off') % 2021/02/15
%     newYlabels = {'0 mm','1 mm','2 mm','3 mm','4 mm'};
%     y=[one(:)'; two(:)'; three(:)'; four(:)'; five(:)'];
%     h = stackedplot(thisdata1(1,:), y', ...
%         'DisplayLabels', newYlabels, 'FontSize', 15);
    
%     axesProps = struct(h.AxesProperties(5));  
%     axesProps.Axes.XLabel.Interpreter = 'tex';
%     axesProps.Axes.YLim = [0 (max(normalized))]; % maybe round upwards?
%     h.xlabel('Raman shift (cm^{-1})'); % affects the last plot, here it's #6
%     h.XLimits = [950 1800]; % 2021/02/14 adding limits
% 
%     if autoSave == 1
%         saveMyPlot(FigH, myTitle);
%     end
% end
% 
% % Put the normalized plots from all steps on a single plot
% % Helpful: https://www.mathworks.com/matlabcentral/answers/486898-change-yticks-using-a-stacked-plot
% % Maybe better as subplot
% if autoSave == 1
%     FigH = figure('Position', get(0, 'Screensize'));
% else
%     figure
% end 
% myTitle = 'Normalized spectra for all steps';
% % 2021/02/15 FontWeight is not a property of stackedplot and so errors
% % out if passed in (below). Here, it is allowed but ignored by stackedplot
% set(gca,'FontSize',20,'FontWeight','bold','box','off');
% newYlabels = {'1:','2:','3:','4:','5:'};
% h = stackedplot(dark(1,:)', n', ...
%     'DisplayLabels', newYlabels, 'FontSize', 15); % applied to both labels and tick labels
% for i = 1:numel(h.AxesProperties)
%     h.AxesProperties(i).YLimits = [0 1];
%     h.XLimits = [950 1800]; % 2021/02/14 adding limits
%     if i == numel(h.AxesProperties)
%         axesProps = struct(h.AxesProperties(i));  
%         axesProps.Axes.XLabel.Interpreter = 'tex';
%         h.xlabel('Wavenumber (cm^{-1})'); % 2021/02/14 superscript not working
%     end
% end
% if autoSave == 1
%     saveMyPlot(FigH, myTitle);
% end

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