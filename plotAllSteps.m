numPoints = 1024;

% dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA AuNPs 2\"; sample 1
% dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA AuNPs 19\"; % sample 2
dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA AuNPs 20\"; % sample 3
% load(dirStem + 'matlabDark.mat');
load(dirStem + 'matlabE.mat');
load(dirStem + 'matlabF.mat');
load(dirStem + 'matlabNormalized.mat');
% load(dirStem + 'matlabRaw.mat');

% thisfilename = dirStem + "1\dark-2020-09-22-22-23-24.txt"; sample 1
% thisfilename = dirStem + "1\dark-2020-09-30-20-56-11.txt"; % sample 2
thisfilename = dirStem + "1\dark-2020-09-30-21-06-44.txt"; % sample 3
fileID = fopen(thisfilename,'r');
[dark] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% thisfilename = dirStem + "1\rawSpectrum-2020-09-22-22-23-30.txt"; sample 1
% thisfilename = dirStem + "1\rawSpectrum-2020-09-30-20-56-29.txt"; % sample 2
thisfilename = dirStem + "1\rawSpectrum-2020-09-30-21-06-50.txt"; % sample
%3
fileID = fopen(thisfilename,'r');
[raw] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% thisfilename = dirStem + "1\spectrum-2020-09-22-22-23-32.txt"; sample 1
% thisfilename = dirStem + "1\spectrum-2020-09-30-20-56-31.txt"; % sample 2
thisfilename = dirStem + "1\spectrum-2020-09-30-21-06-52.txt"; % sample 3
fileID = fopen(thisfilename,'r');
[spec] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% figure
% plot(dark(1,:), dark(2,:));
% figure
% plot(raw(1,:), raw(2,:));
% hold on;
% plot(spec(1,:), spec(2,:));
% 
% figure
% plot(spec(1,:), normalized(1,:));
% hold on;
% plot(spec(1,:), e(1,:));
% hold on;
% plot(spec(1,:), f(:,1));

figure

set(gca,'FontSize', 20);
newYlabels = {'dark','raw','raw-dark','normalized','trend','norm-trend'};
y=[dark(2,:); raw(2,:); spec(2,:); normalized(1,:); e(1,:); (f(:,1))'];
h = stackedplot(dark(1,:),y','Title','MBA with AuNPs in pH7 solution', ...
    'DisplayLabels',newYlabels, 'FontSize', 20);
axesProps = struct(h.AxesProperties(6));  
axesProps.Axes.XLabel.Interpreter = 'tex';
h.xlabel('Wavenumber cm^{-1}');
