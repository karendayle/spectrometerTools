% Plot dataset for six types of blank gels in different directories
% Dayle Kotturi April 2021
close all;

addpath('../functionLibrary'); % provide path to asym

% Colors:
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
colors = [ red; blue; green; black; magenta; ciel ];

xMin = 950;
xMax = 1800;
numPoints = 1024;
thisdata1 = zeros(2, numPoints, 'double'); 

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
dirStem = "R:\Students\Dayle\Data\Made By Waqas\Blank gels\gel ";
subDirStem = ["\blank\1\", "\blank2\1\", "\blank3\1\" ];
% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure % without this, no plots are drawn
for K = 1 : 6
    subplot(6,1,K)
    for J = 1 : 3
        str_dir_to_search = dirStem + string(K) + subDirStem(J); % args need to be strings
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
            plot(thisdata1(1,:), f, 'Color', colors(K,:));
            hold on;
            xlim([xMin xMax]);
        end
    end
end
set(gca,'FontSize',30,'FontWeight','bold','box','off'); % used for title and label
title('Raman spectra of 6 types of blank gels using Wasatch');
xlabel('Wavenumber (cm^-^1)'); % x-axis label
ylabel('Arbitrary Units (A.U.)'); % y-axis label


deltaY = 100;
x = 1500; y = 1300;
text(x, y, 'Sample thickness', 'Color', colors(4,:), 'FontSize', 30);
y = y - deltaY;
text(x, y, '0.020"', 'Color', colors(1,:), 'FontSize', 30);
y = y - deltaY;
text(x, y, '0.010"', 'Color', colors(2,:), 'FontSize', 30);
y = y - deltaY;
text(x, y, '0.005"', 'Color', colors(3,:), 'FontSize', 30);

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
