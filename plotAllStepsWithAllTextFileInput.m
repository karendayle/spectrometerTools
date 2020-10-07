numPoints = 1024;

sample = 3; % This is the only one with e.txt, f.txt and norm.txt files written
            % (after bug fixing)
switch sample
    case 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA on NPs 1\"; 
    case 2
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA on NPs 2\";
    case 3
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA on NPs 3\";
end

% Continue using files specific to sample 3
thisfilename = dirStem + "1\dark-2020-10-05-22-10-13.txt";

fileID = fopen(thisfilename,'r');
[dark] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% There are 5 raw spectrums (to make one avg); just plot the first one
thisfilename = dirStem + "1\rawSpectrum-2020-10-05-22-10-31.txt";
fileID = fopen(thisfilename,'r');
[raw] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% There are 5 spectrums (to make one avg); just plot the first one
thisfilename = dirStem + "1\spectrum-2020-10-05-22-10-33.txt";
fileID = fopen(thisfilename,'r');
[spec] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% Now get the average
thisfilename = dirStem + "1\avg-2020-10-05-22-10-50.txt";
fileID = fopen(thisfilename,'r');
[avg] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% Now get the trend
thisfilename = dirStem + "1\e-2020-10-05-22-10-50.txt";
fileID = fopen(thisfilename,'r');
[e] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% Now get the corrected 
thisfilename = dirStem + "1\f-2020-10-05-22-10-51.txt";
fileID = fopen(thisfilename,'r');
[f] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

% Now get the corrected 
thisfilename = dirStem + "1\norm-2020-10-05-22-10-52.txt";
fileID = fopen(thisfilename,'r');
[normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
fclose(fileID);

figure
set(gca,'FontSize', 20);
newYlabels = {'dark','raw','raw-dark','avg','normalized','trend','norm-trend'};
y=[dark(2,:); raw(2,:); spec(2,:); avg(2,:); normalized(2,:); e(2,:); f(2,:)];
h = stackedplot(dark(1,:),y','Title','MBA with AuNPs in pH7 solution', ...
    'DisplayLabels',newYlabels, 'FontSize', 20);

axesProps = struct(h.AxesProperties(5));  
axesProps.Axes.XLabel.Interpreter = 'tex';
axesProps.Axes.YLim = [0 1.4];

axesProps = struct(h.AxesProperties(6));  
axesProps.Axes.XLabel.Interpreter = 'tex';
axesProps.Axes.YLim = [0 1.4];

axesProps = struct(h.AxesProperties(7));  
axesProps.Axes.XLabel.Interpreter = 'tex';
axesProps.Axes.YLim = [0 1.4];
h.xlabel('Wavenumber cm^{-1}'); % affects the last plot, here it's #6
