% 3D plots of SORS data
% Dayle Kotturi April 2022

addpath('../../functionLibrary');

close all;

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
punchColor = [red; gold; green; ciel; blue ];
myTextFont = 30;
numPoints = 1024;
thisdata1 = zeros(2, numPoints, 'double'); 

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% dirStem = "R:\BMEN\McShane_Mike\Students\Dayle\Data\SORS with new probe\";
dirStem = "R:\Students\Dayle\Data\SORS\PEG\gel 18\";
subDirStem = [ "MBA thicker cover 0 mm\1", "MBA thicker cover 1 mm\1", ...
    "MBA thicker cover 2 mm\1", "MBA thicker cover 3 mm\1", ...
    "MBA thicker cover 4 mm\1" ];

h = gobjects(6); % not required, but more efficient
Kstart = 1;
Kend = 5;
% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure % without this, no plots are drawn
for K = Kstart : Kend
    
    str_dir_to_search = dirStem + subDirStem(K); % args need to be strings
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
          
%           h(K) = plot(thisdata1(1,:), f, 'Color', punchColor(K,:));
%           set(h(K),'LineWidth',1.5);
   
%           x1 = repmat(thisdata1(1:numPoints)',6,1)';
%           y1 = repmat(f',1,numPoints)'; % use LUT to get actual analyte conc
%           z1 = I; 
%           x1 = thisdata1(1:numPoints);
          z1 = f;
          
          for J = 1:numPoints
              x1(J) = thisdata1(1,J);
              y1(J) = K-1;
          end
          plot3(x1, y1, z1, 'Color', punchColor(K,:));
          pause(1);
          hold on;
    end
    
    ylabel('offset (mm)'); 
    zlabel('Intensity (A.U.)');
    grid on
    myTitle = sprintf('PEG gel#18 punch#4 under Phantoms 1 and 10');
    title(myTitle);
        
end

% set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
% title('PEG gel#18 punch#4 under Phantoms 1 and 10', 'FontSize', myTextFont);
% xlabel('Raman Shift (cm^-1)', 'FontSize', myTextFont); % x-axis label
% ylabel('Intensity (A.U.)', 'FontSize', myTextFont); % y-axis label
% zlabel('Offset', 'FontSize', myTextFont);
% % legend doesn't get colors automatically b/c there are > 1 spectrum per K
% % value
% % legend([ h(1), h(2), h(3), h(4), h(5) ], ...
% %     '0 mm offset', '1 mm offset', ...
% %     '2 mm offset', '3 mm offset', ...
% %     '4 mm offset' );
% 
% % repeat but now normalize
% figure % without this, no plots are drawn
% for K = Kstart : Kend
% 
%       str_dir_to_search = dirStem + subDirStem(K); % args need to be strings
%       dir_to_search = char(str_dir_to_search);
%       txtpattern = fullfile(dir_to_search, 'avg*.txt');
%       dinfo = dir(txtpattern); % TO FIX: this returns a list of files and
%                                % I am handling them as if there is only 1
%       for (I = 1 : length(dinfo))
%           thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
%           fileID = fopen(thisfilename,'r');
%           [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
%           fclose(fileID);
%           % Returns trend as 'e' and baseline corrected signal as 'f'
%           [e, f] = correctBaseline(thisdata1(2,:)');          
%           h(K) = plot(thisdata1(1,:), f/max(f), 'Color', punchColor(K,:));
%           set(h(K),'LineWidth',1.5);
%           pause(1);
%           hold on;
%       
%     end
% end
% 
% set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
% title('PEG gel#18 punch#4 under Phantoms 1 and 10', 'FontSize', myTextFont);
% xlabel('Raman Shift (cm^-1)', 'FontSize', myTextFont); % x-axis label
% ylabel('Normalized Intensity (A.U.)', 'FontSize', myTextFont); % y-axis label
% % legend doesn't get colors automatically b/c there are > 1 spectrum per K
% % value
% legend([ h(1), h(2), h(3), h(4), h(5) ], ...
%     '0 mm offset', '1 mm offset', ...
%     '2 mm offset', '3 mm offset', ...
%     '4 mm offset' );

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
