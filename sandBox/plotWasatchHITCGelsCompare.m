% 1. Compare datasets HITC in alginate gel #1 from August and Sept 2021 in different directories
% 2. Compare datasets for HITC in 15% BSA XLD gel #1 from August (called
% "blind" gel back then and Sept 2021

% Dayle Kotturi Sept 2021
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
% xMin = 0;
% xMax = 2000;
numPoints = 1024;
thisdata1 = zeros(2, numPoints, 'double'); 

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.

gelType = ["Alginate", "15% BSA XLD"];

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
%figure % without this, no plots are drawn
for K = 1 : 2
    switch K
        case 1 % Alginate gel
            % Multiple spectra in each subdir, but the latest one is used for plot
            dirStem = "R:\Students\Dayle\Data\Made by Waqas\Alginate\gel 1";
            subDirStem1 = ["\HITC\1\"];
            subDirStem2 = ["\retest HITC\1\" ];
        case 2 % 15% BSA XLD gel
            % Multiple spectra in each subdir, but the latest one is used for plot
            dirStem = "R:\Students\Dayle\Data\Made by Waqas\other\gel 1";
            subDirStem1 = ["\HITC blind gel\1\"];
            subDirStem2 = ["\HITC 15 percent BSA XLD\1\" ];
    end
            
    figure
%     subplot(6,1,K)
    for L = 1 : 2 % 1 = August dataset, 2 = September dataset
        for J = 1 : 1 % all 15 averages are in the same folder
            switch L % 1 is august data, 2 is sept data
                case 1
                    str_dir_to_search = dirStem + subDirStem1(J); 
                case 2
                    str_dir_to_search = dirStem + subDirStem2(J); 
            end
            % args need to be strings
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern); 
            numSpectra = length(dinfo);
            fprintf('J=%d, numSpectra=%d\n', J, numSpectra);
            for (I = 1 : numSpectra)
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                fileID = fopen(thisfilename,'r');
                [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
                fclose(fileID);
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata1(2,:)');          
                plot(thisdata1(1,:), f, 'Color', colors(L,:));
                grid on
                hold on
                if K == 1 
                    title('HITC nanocages in alginate','FontSize',30);
                else
                    if K == 2
                        title('HITC nanocages in 15% BSA XLD','FontSize',30);
                    end
                end
                set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
                xlim([xMin xMax]);
                yStr = sprintf("%s", gelType(K));
                ylabel(yStr,'FontSize',30); % y-axis label

            end
        end
    end
end
% set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
xlabel('Wavenumber (cm^-^1)'); % x-axis label
% legend('August', 'September');

for K = 1 : 2
    switch K
        case 1 % Alginate gel
            % Multiple spectra in each subdir, but the latest one is used for plot
            dirStem = "R:\Students\Dayle\Data\Made by Waqas\Alginate\gel 1";
            subDirStem1 = ["\HITC\1\"];
            subDirStem2 = ["\retest HITC\1\" ];
        case 2 % 15% BSA XLD gel
            % Multiple spectra in each subdir, but the latest one is used for plot
            dirStem = "R:\Students\Dayle\Data\Made by Waqas\other\gel 1";
            subDirStem1 = ["\HITC blind gel\1\"];
            subDirStem2 = ["\HITC 15 percent BSA XLD\1\" ];
    end
    figure % without this, no plots are drawn
    for L = 1 : 2
        for J = 1 : 1
            for II = 1:1024
                z(II) = J;
            end
            switch L % 1 is april data, 2 is sept data
                case 1
                    str_dir_to_search = dirStem + subDirStem1(J); 
                    % args need to be strings
                case 2
                    str_dir_to_search = dirStem + subDirStem2(J); 
            end
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
                % plot(thisdata1(1,:),f);
                for II = 1:1024
                    z(II) = L;
                end
                plot3(thisdata1(1,:),z,f,'Color',colors(L,:));
                hold on

                myTitle = sprintf('Raman spectra of of gel: %s', gelType(K));
                title(myTitle,'FontSize',30);

                set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
                xlim([xMin xMax]);
                zStr = sprintf("%s", gelType(K));
                zlabel('Intensity (Arbitrary Units)','FontSize',15); % y-axis label
                ylabel('Measurement #','FontSize',15);
                yticks([1 2])
            end
        end
    end
end
% set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
xlabel('Wavenumber (cm^-^1)'); % x-axis label

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

function g = saveMyPlot(FigH, myTitle)
global plotOption
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlotName = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlotName, 'png');
    g = 1;
end
