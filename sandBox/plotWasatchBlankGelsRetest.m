% Plot dataset for blank gel #2 in different directories
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
% Multiple spectra in each subdir, but the latest one is used for plot
dirStem = "R:\Students\Dayle\Data\Made by Waqas\Blank gels\gel ";
subDirStem = ["\retest\retest 15 percent BSA 1\1\", "\retest\retest 15 percent BSA 2\1\", "\retest\retest 15 percent BSA 3\1\" ];
gelType = ["GAC admix", "15%BSA XLD", "20%BSA XLD", ...
    "10%G:10%BSA", "15%G:5%BSA", "19%G:1%BSA"];
% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure % without this, no plots are drawn
for K = 2 : 2
%     subplot(6,1,K)
    for J = 1 : 3
        str_dir_to_search = dirStem + string(K) + subDirStem(J); % args need to be strings
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
            plot(thisdata1(1,:), f, 'Color', colors(J,:));
            grid on
            hold on
            if K == 1 
                title('Raman spectra of 6 types of blank gels using Wasatch','FontSize',30);
            end
            set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
            xlim([xMin xMax]);
            yStr = sprintf("%s", gelType(K));
            ylabel(yStr,'FontSize',30); % y-axis label
        end
    end
end
% set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
xlabel('Wavenumber (cm^-^1)'); % x-axis label


for K = 2 : 2
    figure % without this, no plots are drawn
    for J = 1 : 3
        for II = 1:1024
            z(II) = J;
        end
        if K == 4
            subDirStem = ["\redo blank1\1\", "\redo blank2\1\", "\redo blank3\1\" ];
        end
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
            % plot(thisdata1(1,:),f);
            for II = 1:1024
                z(II) = J;
            end
            plot3(thisdata1(1,:),z,f,'Color',colors(J,:));
            hold on

            myTitle = sprintf('Raman spectra of of gel: %s', gelType(K));
            title(myTitle,'FontSize',30);

            set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
            xlim([xMin xMax]);
            zStr = sprintf("%s", gelType(K));
            zlabel('Intensity (Arbitrary Units)','FontSize',15); % y-axis label
            ylabel('Measurement #','FontSize',15);
            yticks([1 2 3])
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
