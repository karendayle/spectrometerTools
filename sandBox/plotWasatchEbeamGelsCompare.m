% Compare the gels after they come back from e-beam sterilization
% Plots are for 20210920 SR

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
colors = [ red; blue; green; black; magenta; purple; ...
    black; cherry; gold; green; rust; ciel ]; 

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

for K = 1 : 2
    switch K
        case 1 % Alginate gel
            % Multiple spectra in each subdir, but the latest one is used for plot
            dirStem = "R:\Students\Dayle\Data\Made by Waqas\Alginate\gel 2";
            % Note: first 3 do not have subdir "1\". This is correct.
            subDirStem1 = ["\HITC 1 sample 1\1\"];
            subDirStem2 = ["\HITC 1 sample 2\1\"];
            subDirStem3 = ["\HITC 1 sample 3\1\"];
            subDirStem4 = ["\HITC 2 sample 1\1\"];
            subDirStem5 = ["\HITC 2 sample 2\1\"];
            subDirStem6 = ["\HITC 2 sample 3\1\"];
            
            subDirStem7 = ["\Blank 1 sample 1\1\"];
            subDirStem8 = ["\Blank 1 sample 2\1\"];
            subDirStem9 = ["\Blank 1 sample 3\1\"];
            subDirStem10 = ["\Blank 2 sample 1\1\"];
            subDirStem11 = ["\Blank 2 sample 2\1\"];
            subDirStem12 = ["\Blank 2 sample 3\1\"];
        case 2 % 15% BSA XLD gel
            % Multiple spectra in each subdir, but the latest one is used for plot
            dirStem = "R:\Students\Dayle\Data\Made by Waqas\other\gel 8";
            subDirStem1 = ["\BSA 1 sample 1\1\"];
            subDirStem2 = ["\BSA 1 sample 2\1\"];
            subDirStem3 = ["\BSA 1 sample 3\1\"];
            subDirStem4 = ["\BSA 2 sample 1\1\"];
            subDirStem5 = ["\BSA 2 sample 2\1\"];
            subDirStem6 = ["\BSA 2 sample 3\1\"];
            
            subDirStem7 = ["\Blank 1 sample 1\1\"];
            subDirStem8 = ["\Blank 1 sample 2\1\"];
            subDirStem9 = ["\Blank 1 sample 3\1\"];
            subDirStem10 = ["\Blank 2 sample 1\1\"];
            subDirStem11 = ["\Blank 2 sample 2\1\"];
            subDirStem12 = ["\Blank 2 sample 3\1\"];
    end
      
    figure % First plot everything for one gel type
    for J = 1 : 12 % all 15 averages are in the same folder
        switch J % This is pain but subDirStems can't be in a 2D 
                 % array b/c the strings have to be the same length
                 % for that
            case 1
                str_dir_to_search = dirStem + subDirStem1; 
            case 2
                str_dir_to_search = dirStem + subDirStem2; 
            case 3
                str_dir_to_search = dirStem + subDirStem3; 
            case 4
                str_dir_to_search = dirStem + subDirStem4;
            case 5
                str_dir_to_search = dirStem + subDirStem5; 
            case 6
                str_dir_to_search = dirStem + subDirStem6; 
            case 7
                str_dir_to_search = dirStem + subDirStem7; 
            case 8
                str_dir_to_search = dirStem + subDirStem8;
            case 9
                str_dir_to_search = dirStem + subDirStem9; 
            case 10
                str_dir_to_search = dirStem + subDirStem10; 
            case 11
                str_dir_to_search = dirStem + subDirStem11;
            case 12
                str_dir_to_search = dirStem + subDirStem12;
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
            if J < 7
                plot(thisdata1(1,:), f, 'Color', colors(J,:));
            else
                plot(thisdata1(1,:), f, 'Color', black);
            end
            grid on
            hold on
            if K == 1 
                title('Alginate','FontSize',30);
            else
                if K == 2
                    title('15% BSA XLD','FontSize',30);
                end
            end
            set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
            xlim([xMin xMax]);
        end
        
    end
    % set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
    xlabel('Wavenumber (cm^-^1)'); % x-axis label
    ylabel('Intensity (a.u.)'); % y-axis label
    % legend('August', 'September');
    
    % Now focus deeper
    figure % Second, look only where the HITC is
    for J = 1 : 6 
        switch J % This is pain but subDirStems can't be in a 2D 
                 % array b/c the strings have to be the same length
                 % for that
            case 1
                str_dir_to_search = dirStem + subDirStem1; 
            case 2
                str_dir_to_search = dirStem + subDirStem2; 
            case 3
                str_dir_to_search = dirStem + subDirStem3; 
            case 4
                str_dir_to_search = dirStem + subDirStem4;
            case 5
                str_dir_to_search = dirStem + subDirStem5; 
            case 6
                str_dir_to_search = dirStem + subDirStem6; 
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

            % This nested if necessary to set legend correctly
            if J == 1 && I == 1
                h1 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
            else
                if J == 2 && I == 1
                    h2 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                else
                    if J == 3 && I == 1
                        h3 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                    else
                        if J == 4 && I == 1
                            h4 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                        else
                            if J == 5 && I == 1
                                h5 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                            else
                                if J == 6 && I == 1
                                    h6 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                                else
                                    plot(thisdata1(1,:), f, 'Color', colors(J,:));
                                end
                             end
                        end
                    end
                end
            end

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
        end
        
    end
    % set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
    xlabel('Wavenumber (cm^-^1)'); % x-axis label
    ylabel('Intensity (a.u.)'); % y-axis label
    legend([h1(1), h2(1), h3(1), h4(1), h5(1), h6(1)],...
        'cylinder sample 1', 'cylinder sample 2', 'cylinder sample 3', ...
        'disc sample 1', 'disc sample 2', 'disc sample 3');
    
    figure % Blank only

    for J = 7 : 12 % Third, look only at the blanks
        switch J % This is pain but subDirStems can't be in a 2D 
                 % array b/c the strings have to be the same length
                 % for that
            case 7
                str_dir_to_search = dirStem + subDirStem7; 
            case 8
                str_dir_to_search = dirStem + subDirStem8;
            case 9
                str_dir_to_search = dirStem + subDirStem9; 
            case 10
                str_dir_to_search = dirStem + subDirStem10; 
            case 11
                str_dir_to_search = dirStem + subDirStem11;
            case 12
                str_dir_to_search = dirStem + subDirStem12;
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

            % This nested if necessary to set legend correctly
            if J == 7 && I == 1
                h1 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
            else
                if J == 8 && I == 1
                    h2 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                else
                    if J == 9 && I == 1
                        h3 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                    else
                        if J == 10 && I == 1
                            h4 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                        else
                            if J == 11 && I == 1
                                h5 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                            else
                                if J == 12 && I == 1
                                    h6 = plot(thisdata1(1,:), f, 'Color', colors(J,:));
                                else
                                    plot(thisdata1(1,:), f, 'Color', colors(J,:));
                                end
                             end
                        end
                    end
                end
            end

            grid on
            hold on
            if K == 1 
                title('Blank alginate','FontSize',30);
            else
                if K == 2
                    title('Blank 15% BSA XLD','FontSize',30);
                end
            end
            set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
            xlim([xMin xMax]);
        end
        
    end
    % set(gca,'FontSize',15,'FontWeight','bold','box','off'); % used for title and label
    xlabel('Wavenumber (cm^-^1)'); % x-axis label
    ylabel('Intensity (a.u.)'); % y-axis label
    legend([h1(1), h2(1), h3(1), h4(1), h5(1), h6(1)],...
        'cylinder sample 1', 'cylinder sample 2', 'cylinder sample 3', ...
        'disc sample 1', 'disc sample 2', 'disc sample 3');
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
