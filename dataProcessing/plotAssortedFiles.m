% Plot files in different directories
% Dayle Kotturi June 2018

addpath('../functionLibrary');

% Colors:
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];

numPoints = 1024;
thisdata1 = zeros(2, numPoints, 'double'); 

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
%dirStem = "H:\Documents\Data\";
%dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 10\static test extremes on quartz\";
%dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\after ten bilayers 1\";
dirStem = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 18\retest punch 1\";
%subDirStem1 = "1 0mgdL";
%subDirStem1 = "2 1809.6mgdL";
%subDirStem1 = "3 1809.6mgdL longer";
subDirStem1 = "1";

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure % without this, no plots are drawn
for K = 1 : 1
    if (K == 1)
      str_dir_to_search = dirStem + subDirStem1; % args need to be strings
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
          %plot(thisdata1(1,:), thisdata1(2,:), 'green'); % drift obvious
          %plot(thisdata1(1,:), f, 'green'); % drift not obvious
          plot(thisdata1(1,:), f)
          pause(5);
          hold on;
      end
    end
end

% title(subDirStem1);
xlabel('Raman shift (cm^-1)'); % x-axis label
ylabel('Intensity (a.u.)'); % y-axis label
%legend('pH7');

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
    %prog.temp_tic=asysm(tics(1,:)',lambda,p,d);
    %prog.temp_tic=asysm(tics,lambda,p,d);
    temp_tic=asysm(tics,lambda,p,d);
    %prog.temp_tic=prog.temp_tic';
    trend=temp_tic';
    modified=tics(:)-temp_tic(:);
    e = trend;
    f = modified';
end
