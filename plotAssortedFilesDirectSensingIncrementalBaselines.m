% Plot direct sensing single analytes in 5 concentrations
% Multiple spectra in each subdir, use pattern matching to find them
% Average files with same analyte and concentration
% Dayle Kotturi November 2019

% Colors:
global colors;
global blue;
global rust;
global gold;
global purple;
global green;
global ciel;
global cherry;
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];

numPoints = 1024;

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
dirStem = "C:\Users\karen\Documents\Data\Direct Sensing\Single Analytes\2019-11-07\";

colors = [cherry; gold; green; blue; purple];

patterns = ["*creatinine 2.csv",...
    "*creatinine 3.csv", "*creatinine 4.csv",...
    "*creatinine 5.csv", "*creatinine 6.csv";...
    "*lactate 2.csv",...
    "*lactate 3.csv", "*lactate 4.csv",...
    "*lactate 5.csv", "*lactate 6.csv";...
    "*dopamine 2.csv",...
    "*dopamine 3.csv", "*dopamine 4.csv",...
    "*dopamine 5.csv", "*dopamine 6.csv"];

analytes = ["creatinine", "lactate", "dopamine"]; % map to J loop below

numConc = 5;
numberOfSpectra = zeros(1,numConc); % reset each iter

% REPEAT FOR ALL ANALYTES
for J = 2 : 2 % set to 1:3 to do all analytes
    sumOverall = zeros(1,numPoints); % reset each analyte
    figure % without this, no plots are drawn
    
    % FIRST PASS
    for K = 1 : 5 % 6 concentrations
        dir_to_search = char(dirStem); % args need to be strings
        txtpattern = fullfile(dir_to_search, patterns(J,K));
        dinfo = dir(txtpattern);
        sum1 = zeros(1,numPoints); % reset each iter
        
        for (I = 1 : length(dinfo))
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            [D,S,R] = xlsread(thisfilename); % the numbers go into D.
            D2 = D(18:end); % now have them in 1x1024 array

            % add to sum for average
            sum1 = sum1 + D2; % for this conc  
        end
        
        numberOfSpectra(K)= length(dinfo);
        sum1 = sum1/numberOfSpectra(K);
        sumOverall = sumOverall + sum1; % create the input for the single baseline
        [e, f] = correctBaseline(sumOverall'); % plot the trend 'e' in subplot 2,2,2
        
        subplot(2,2,1)
        plot(sum1, 'Color', colors(K,:));
        title1 = sprintf('%s averaged, but before baseline correction',analytes(J));
        title(title1);
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('Arbitrary Units (A.U.)'); % y-axis label
        str1 = sprintf('conc 2 number of spectra %d',numberOfSpectra(1));
        str2 = sprintf('conc 2 number of spectra %d',numberOfSpectra(2));
        str3 = sprintf('conc 2 number of spectra %d',numberOfSpectra(3));
        str4 = sprintf('conc 2 number of spectra %d',numberOfSpectra(4));
        str5 = sprintf('conc 2 number of spectra %d',numberOfSpectra(5));
        text(800, 1600, str1, 'Color', cherry);
        text(800, 1500, str2, 'Color', gold);
        text(800, 1400, str3, 'Color', green);
        text(800, 1300, str4, 'Color', blue);
        text(800, 1200, str5, 'Color', purple);
        hold on;
        
        subplot(2,2,2)
        plot(e, 'Color', colors(K,:)); % calculated above, once per conc
        title1 = sprintf('%s cumulative baseline over conc before divide by 5',analytes(J));
        title(title1);
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('Arbitrary Units (A.U.)'); % y-axis label
        str1 = sprintf('accumulation of %d',numberOfSpectra(1));
        str2 = sprintf('conc 2 number of spectra %d',numberOfSpectra(2));
        str3 = sprintf('conc 2 number of spectra %d',numberOfSpectra(3));
        str4 = sprintf('conc 2 number of spectra %d',numberOfSpectra(4));
        str5 = sprintf('conc 2 number of spectra %d',numberOfSpectra(5));
        text(800, 1600, str1, 'Color', cherry);
        text(800, 1500, str2, 'Color', gold);
        text(800, 1400, str3, 'Color', green);
        text(800, 1300, str4, 'Color', blue);
        text(800, 1200, str5, 'Color', purple);
        hold on;
    end
    
    % SECOND PASS 
    % THROUGH DATA NEEDED SO THAT SINGLE BASELINE CAN BE APPLIED
    for K = 1 : 5 % 6 concentrations  
        % Returns trend as 'e' and baseline corrected signal as 'f'
        [e, f] = correctBaseline(sumOverall'/5); % NOW this has overall sum
        
        dir_to_search = char(dirStem); % args need to be strings
        txtpattern = fullfile(dir_to_search, patterns(J,K));
        dinfo = dir(txtpattern);
        sum1 = zeros(1,numPoints); % reset each iter
        
        for (I = 1 : length(dinfo))
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            [D,S,R] = xlsread(thisfilename); % the numbers go into D.
            D2 = D(18:end); % now have them in 1x1024 array

            % add to sum for average
            sum1 = sum1 + D2; % for this conc  
        end
        
        sum1 = sum1/numberOfSpectra(K);
        subplot(2,2,3)
        plot(sum1-f, 'Color', colors(K,:));
        title2 = sprintf('%s averaged, baseline corrected -- common baseline for all concentrations',analytes(J));
        title(title2);
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('Arbitrary Units (A.U.)'); % y-axis label
        str1 = sprintf('conc 2 number of spectra %d',numberOfSpectra(1));
        str2 = sprintf('conc 2 number of spectra %d',numberOfSpectra(2));
        str3 = sprintf('conc 2 number of spectra %d',numberOfSpectra(3));
        str4 = sprintf('conc 2 number of spectra %d',numberOfSpectra(4));
        str5 = sprintf('conc 2 number of spectra %d',numberOfSpectra(5));
        text(800, 1600, str1, 'Color', cherry);
        text(800, 1500, str2, 'Color', gold);
        text(800, 1400, str3, 'Color', green);
        text(800, 1300, str4, 'Color', blue);
        text(800, 1200, str5, 'Color', purple);
        hold on;
        
        numberOfSpectra(K)= length(dinfo);
        sum1 = sum1/numberOfSpectra(K);
        subplot(2,2,4)
        plot(e, 'Color', colors(K,:));
        title2 = sprintf('%s overall baseline for all concentrations/5',analytes(J));
        title(title2);
        xlabel('Wavenumber (cm^-1)'); % x-axis label
        ylabel('Arbitrary Units (A.U.)'); % y-axis label
        hold on;
    end
end
function [e f] = correctBaseline(tics)
    lambda=1e5; % smoothing parameter
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
