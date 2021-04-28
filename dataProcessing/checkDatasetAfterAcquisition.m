% Plot the dark, raw and avg *.txt files for a given top level directory.
% Use to check a dataset

% Dayle Kotturi April 2021
close all;
xMin = 950;
xMax = 1800;
numPoints = 1024;
% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
% CHOOSE (specify) the array of datasets
% dir_to_search = 'C:\Users\dayle.kotturi\Documents\Data\SORS1';

% This not permitted, length of strings must match. Can do them 1 at a time
dir_to_search = ...
    ['R:\Students\Dayle\Data\Made by Waqas\Blank gels\gel 1\blank\1'...
%       ; ...
%      'R:\Students\Dayle\Data\Made by Waqas\Blank gels\gel 4\blank2\1'...
%      ; ...
%      'R:\Students\Dayle\Data\Made by Waqas\Blank gels\gel 4\blank3\1'...
];
% dir_to_search = ...
%     ['R:\Students\Dayle\Data\Made by Waqas\Blank gels\gel 4\redo blank1\1'; ...
%      'R:\Students\Dayle\Data\Made by Waqas\Blank gels\gel 4\redo blank2\1'; ...
%      'R:\Students\Dayle\Data\Made by Waqas\Blank gels\gel 4\redo blank3\1'];
 
% CHOOSE whether or not to save plots to file automatically
savePlotsToFile = 1;

[numDatasets, ~] = size(dir_to_search);

for L = 1:numDatasets
    % 1. PLOT THE DARK
    txtpattern = fullfile(dir_to_search(L,:), 'dark*.txt');
    dinfo = dir(txtpattern);

    if savePlotsToFile == 1
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    for K = 1 : length(dinfo)
      thisfilename = fullfile(dir_to_search(L,:), dinfo(K).name); % just the name
      fileID = fopen(thisfilename,'r');
      [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
      fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );

      % do something with the data
      plot(thisdata(1,:), thisdata(2,:));
      hold on
%       pause(1);
    end
    myTitle = sprintf('dark spectrum for %s', dir_to_search(L,:));
    title(myTitle);
    xlim([xMin xMax]);
    xlabel('Wavenumber (cm^-^1)'); % x-axis label
    ylabel('Intensity (Arbitrary Units)'); % y-axis label
    set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
    plotFile = sprintf('dataset %d dark', L);
    if savePlotsToFile == 1
        saveMyPlot(FigH, plotFile);
    end

    % 2. PLOT THE RAW SPECTRA, 2 DIFFERENT WAYS
    txtpattern = fullfile(dir_to_search(L,:), 'raw*.txt');
    dinfo = dir(txtpattern);
    
    if savePlotsToFile == 1
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    
    for K = 1 : length(dinfo)
      thisfilename = fullfile(dir_to_search(L,:), dinfo(K).name); % just the name
      fileID = fopen(thisfilename,'r');
      [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
      fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );

      % do something with the data
      plot(thisdata(1,:), thisdata(2,:));
      hold on
%       pause(1);
    end
    myTitle = sprintf('All raw spectra for %s', dir_to_search(L,:));
    xlim([xMin xMax]);
    title(myTitle);
    xlabel('Wavenumber (cm^-^1)'); % x-axis label
    ylabel('Intensity (Arbitrary Units)'); % y-axis label
    plotFile = sprintf('dataset %d raw', L);
    if savePlotsToFile == 1
        saveMyPlot(FigH, plotFile);
    end

    txtpattern = fullfile(dir_to_search(L,:), 'raw*.txt');
    dinfo = dir(txtpattern);
    
    if savePlotsToFile == 1
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    
    for K = 1 : length(dinfo)
      thisfilename = fullfile(dir_to_search(L,:), dinfo(K).name); % just the name
      fileID = fopen(thisfilename,'r');
      [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
      fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );

      % do something with the data
      for II = 1:1024
          z(II) = K;
      end
      plot3(thisdata(1,:),z,thisdata(2,:));
      hold on
%       pause(1);
    end
    myTitle = sprintf('3D of all raw spectra for %s', dir_to_search(L,:));
    title(myTitle);
    xlabel('Wavenumber (cm^-^1)'); % x-axis label
    ylabel('Spectrum #'); % y-axis label
    zlabel('Intensity (Arbitrary Units)'); % z-axis label
    set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
    plotFile = sprintf('dataset %d raw 3D', L);
    if savePlotsToFile == 1
        saveMyPlot(FigH, plotFile);
    end

    % 3. PLOT THE AVG SPECTRA, 2 DIFFERENT WAYS
    txtpattern = fullfile(dir_to_search(L,:), 'avg*.txt');
    dinfo = dir(txtpattern);
    
    if savePlotsToFile == 1
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    
    for K = 1:length(dinfo)
      thisfilename = fullfile(dir_to_search(L,:), dinfo(K).name); % just the name
      fileID = fopen(thisfilename,'r');
      [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
      fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );

      % do something with the data
      plot(thisdata(1,:), thisdata(2,:));
      hold on
%       pause(1);
    end
    myTitle = sprintf('All avg spectra for %s', dir_to_search(L,:));
    set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
    title(myTitle);
    xlim([xMin xMax]);
    xlabel('Wavenumber (cm^-^1)'); % x-axis label
    ylabel('Intensity (Arbitrary Units)'); % y-axis label
    plotFile = sprintf('dataset %d avg', L);
    if savePlotsToFile == 1
        saveMyPlot(FigH, plotFile);
    end

    txtpattern = fullfile(dir_to_search(L,:), 'avg*.txt');
    dinfo = dir(txtpattern);
    
    if savePlotsToFile == 1
        FigH = figure('Position', get(0, 'Screensize'));
    else
        figure
    end
    
    for K = 1 : length(dinfo)
      thisfilename = fullfile(dir_to_search(L,:), dinfo(K).name); % just the name
      fileID = fopen(thisfilename,'r');
      [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
      fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );

      % do something with the data
      for II = 1:1024
          z(II) = K;
      end
      plot3(thisdata(1,:),z,thisdata(2,:));
      hold on
%       pause(1);
    end
    myTitle = sprintf('3D of all avg spectra for %s', dir_to_search(L,:));
    set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
    xlim([xMin xMax]);
    title(myTitle);
    xlabel('Wavenumber (cm^-^1)'); % x-axis label
    ylabel('Measurement #'); % y-axis label
    zlabel('Intensity (Arbitrary Units)'); % z-axis label
    plotFile = sprintf('dataset %d avg 3D', L);
    if savePlotsToFile == 1
        saveMyPlot(FigH, plotFile);
    end
end

% Plot each spectrum (intensity vs wavenumber in a new color overtop

% Q: how to build up to a given number of spectra, say 10, and then drop
% the oldest, i.e. erase. Is this best done by re-drawing plots 2-9 and
% then the new 10th one instead of "erasing" plot 1?

function g = saveMyPlot(FigH, myTitle)
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlot = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlot, 'png');
    g = 1;
end