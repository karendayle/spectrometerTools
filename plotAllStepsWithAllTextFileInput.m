numPoints = 1024;

for step = 1:9
    switch step
        case 1
            myTitle = 'Step 1: MBA on AuNPs';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\MBA on NPs 3\";
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

        case 2
            myTitle = 'Step 2: MBA AuNPs into NaCO3';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\\";
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the trend
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [e] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [f] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

        case 3
            myTitle = 'Step 3: MBA AuNPs with NaCO3 and CaCl';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\\";
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the trend
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [e] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [f] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 4
            myTitle = 'Step 4: First wash with NaCO3';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\\";
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the trend
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [e] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [f] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 5
            myTitle = 'Step 5: After first bilayer PDADMAC/PSS';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\\";
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the trend
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [e] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [f] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 6
            myTitle = 'Step 6: After five bilayers';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\\";
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the trend
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [e] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [f] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 7
            myTitle = 'Step 7: After ten bilayers';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\\";
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the trend
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [e] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [f] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 8
            myTitle = 'Step 8: After first wash';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\\";
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the trend
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [e] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [f] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
        case 9
            myTitle = 'Step 9: After third wash and into 10mM pH7';
            dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 0\\";
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [dark] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 raw spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [raw] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % There are 5 spectrums (to make one avg); just plot the first one
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [spec] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the average
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [avg] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the trend
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [e] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [f] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            % Now get the corrected 
            thisfilename = dirStem + "1\.txt";
            fileID = fopen(thisfilename,'r');
            [normalized] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            
    end
end


figure
set(gca,'FontSize', 20);
newYlabels = {'dark','raw','raw-dark','avg','normalized','trend','norm-trend'};
y=[dark(2,:); raw(2,:); spec(2,:); avg(2,:); normalized(2,:); e(2,:); f(2,:)];
h = stackedplot(dark(1,:), y', 'Title', myTitle, ...
    'DisplayLabels', newYlabels, 'FontSize', 20);

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
