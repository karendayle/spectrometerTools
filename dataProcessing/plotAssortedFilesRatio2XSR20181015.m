% Plot files in different directories
% Dayle Kotturi June 2018

% Colors:
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
dirStem = "H:\Documents\Data\Embedded hydrogel study\flow through 2X v2\";
subDirStem1 = "pH4 first overnight run";
subDirStem2 = "pH7 aborted due to leakage";

%refWaveNumber = 1074.26; % at index 407 - read from file, same for all 3
refIndex = 409; % index where the reference peak is 
                %(ring breathing near 1078 cm^-1
                % TO DO: read from avg*.txt file
numPoints = 1024;
thisdata1 = zeros(2, numPoints, 'double');
thisdata2 = zeros(2, numPoints, 'double');


offset = 300;
denominator1 = 1; % default. Used if refIndex is 0
denominator2 = 1; % default. Used if refIndex is 0

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure 
xMin = 900;
xMax = 2000;
xlim([xMin xMax]);
%ylim([yMin yMax]);
myFont = 30;

% initialize color
lineColor = red;

for K = 1:1
    maxIntensity = 0; % set initial value
    if (K == 1)
      str_dir_to_search = dirStem + subDirStem1; % args need to be strings
      % This function only in 2018b:
      %dir_to_search = convertContainedStringsToChars(str_dir_to_search);
      %How do I get it to char array for fullfile?
      dir_to_search = char(str_dir_to_search);
      txtpattern = fullfile(dir_to_search, 'avg*.txt');
      dinfo = dir(txtpattern); 
      
      for I = 1 : length(dinfo)
          thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
          % 09/29/2018 "load" no longer works when add'l fields
          % appended at end. Need to only read 102
          %thisdata2 = load(thisfilename); %load just this file
          fileID = fopen(thisfilename,'r');
          [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
          % max is FYI, not used. Could be compared to a threshold to
          % detect that signal is bad.
          fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
              thisfilename, max(thisdata1(2,:)) );
          fclose(fileID);
          
          % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
          % REFERENCE INDEX
          
          % 1. Correct the baseline BEFORE calculating denominator + normalizing
          % Returns trend as 'e' and baseline corrected signal as 'f'
          [e, f] = correctBaseline(thisdata1(2,:)');    
          
          % 2. Ratiometric
          % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
          % on either side of refWaveNumber. This maps to: 1 - 11 total
          % intensities used to calculate the denominator.
          if (refIndex ~= 0) 
              numPointsEachSide = 2;
              denominator1 = getDenominator(refIndex, ...
              numPointsEachSide, ...
              numPoints, f(:));
          end
          fprintf('denominator = %g at index: %d\n', denominator1, refIndex);
          
          % 3. NEW 10/4/18: Normalize what is plotted
          normalized = f/denominator1;
          
          % change to plot starting at index 400
          %plot the trend: 
          %plot(thisdata1(1,offset:end), f(offset:end), 'Color', red);
          %plot(thisdata1(1,offset:end), e(offset:end), 'cyan');
          %plot(thisdata1(1,offset:end), normalized(offset:end), 'Color', blue);
          % plot just the corrected signal
          plot(thisdata1(1,offset:end), normalized(offset:end), 'Color', lineColor);
          xlim([xMin xMax]);
          hold on
          %pause(1);
          newColor = lineColor - [0.005*I, 0., 0.];
          if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
              lineColor = newColor;
          end
      end
    else
        if (K == 2)
            lineColor = green;
            str_dir_to_search = dirStem + subDirStem2;
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern);
            for I = 1 : length(dinfo)
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                % 09/29/2018 "load" no longer works when add'l fields
                % appended at end. Need to only read 1024 lines
                %thisdata2 = load(thisfilename); %load just this file
                fileID = fopen(thisfilename,'r');
                [thisdata2] = fscanf(fileID, '%g %g', [2 numPoints]);
                fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                    thisfilename, max(thisdata2(2,:)) );
                if (max(thisdata2(2,:)) > maxIntensity) % maybe not needed
                    maxIntensity = max(thisdata2(2,:));
                end
                %thisdata2 = thisdata2';
                fclose(fileID);
                
                % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                % REFERENCE INDEX

                % 1. Correct the baseline BEFORE calculating denominator + normalizing
                % Returns trend as 'e' and baseline corrected signal as 'f'
                [e, f] = correctBaseline(thisdata2(2,:)');    

                % 2. Ratiometric
                % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                % on either side of refWaveNumber. This maps to: 1 - 11 total
                % intensities used to calculate the denominator.
                if (refIndex ~= 0) 
                    numPointsEachSide = 2;
                    denominator2 = getDenominator(refIndex, ...
                    numPointsEachSide, ...
                    numPoints, f(:));
                end
                fprintf('denominator = %g at index: %d\n', denominator2, refIndex);

                % 3. NEW 10/4/18: Normalize what is plotted
                normalized = f/denominator2;

                % change to plot starting at index 400
                % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
                % plot just the corrected signal
                plot(thisdata2(1,offset:end), normalized(offset:end), 'Color', lineColor);
                xlim([xMin xMax]);
                %legend(subDirStem1);
                hold on
                pause(1);
                newColor = lineColor - [0.005*I, 0., 0.];
                if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
                    lineColor = newColor;
                end
            end
        else
            if (K == 3)
                str_dir_to_search = dirStem + subDirStem3;
                dir_to_search = char(str_dir_to_search);
                txtpattern = fullfile(dir_to_search, 'avg*.txt');
                dinfo= dir(txtpattern);
                for (I = 1 : length(dinfo))
                    thisfilename = fullfile(dir_to_search, dinfo(I).name); 
                    % 09/29/2018 "load" no longer works when add'l fields
                    % appended at end. Need to only read 1024 lines
                    %thisdata2 = load(thisfilename); %load just this file
                    fileID = fopen(thisfilename,'r');
                    [thisdata3] = fscanf(fileID, '%g %g', [2 numPoints]);
                    fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                        thisfilename, max(thisdata3(2,:)) );
                    if (max(thisdata3(2,:)) > maxIntensity)
                        maxIntensity = max(thisdata3(2,:));
                    end
                    %thisdata3 = thisdata3';
                    fclose(fileID);
                    
                    % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                    % REFERENCE INDEX

                    % 1. Correct the baseline BEFORE calculating denominator + normalizing
                    % Returns trend as 'e' and baseline corrected signal as 'f'
                    [e, f] = correctBaseline(thisdata3(2,:)');    

                    % 2. Ratiometric
                    % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                    % on either side of refWaveNumber. This maps to: 1 - 11 total
                    % intensities used to calculate the denominator.
                    if (refIndex ~= 0) 
                        numPointsEachSide = 2;
                        denominator3 = getDenominator(refIndex, ...
                        numPointsEachSide, ...
                        numPoints, f(:));
                    end
                    fprintf('denominator = %g at index: %d\n', denominator3, refIndex);

                    % 3. NEW 10/4/18: Normalize what is plotted
                    normalized = f/denominator3;

                    % change to plot starting at index 400
                    % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
                    % plot just the corrected signal
                    plot(thisdata3(1,offset:end), normalized(offset:end), 'Color', lineColor);
                    xlim([xMin xMax]);
                    hold on
                    pause(1);
                    newColor = lineColor - [0.005*I, 0., 0.];
                    if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
                        lineColor = newColor;
                    end
                end
            else
                if (K == 4)
                    str_dir_to_search = dirStem + subDirStem4;
                    dir_to_search = char(str_dir_to_search);
                    txtpattern = fullfile(dir_to_search, 'avg*.txt');
                    dinfo= dir(txtpattern);
                    for (I = 1 : length(dinfo))
                        thisfilename = fullfile(dir_to_search, dinfo(I).name); 
                        % 09/29/2018 "load" no longer works when add'l fields
                        % appended at end. Need to only read 1024 lines
                        %thisdata2 = load(thisfilename); %load just this file
                        fileID = fopen(thisfilename,'r');
                        [thisdata4] = fscanf(fileID, '%g %g', [2 numPoints]);
                        fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                            thisfilename, max(thisdata4(2,:)) );
                        %thisdata4 = thisdata4';
                        fclose(fileID);

                        % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                        % REFERENCE INDEX

                        % 1. Correct the baseline BEFORE calculating denominator + normalizing
                        % Returns trend as 'e' and baseline corrected signal as 'f'
                        [e, f] = correctBaseline(thisdata4(2,:)');    

                        % 2. Ratiometric
                        % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                        % on either side of refWaveNumber. This maps to: 1 - 11 total
                        % intensities used to calculate the denominator.
                        if (refIndex ~= 0) 
                            numPointsEachSide = 2;
                            denominator4 = getDenominator(refIndex, ...
                            numPointsEachSide, ...
                            numPoints, f(:));
                        end
                        fprintf('denominator = %g at index: %d\n', denominator4, refIndex);

                        % 3. NEW 10/4/18: Normalize what is plotted
                        normalized = f/denominator4;

                        % change to plot starting at index 400
                        % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
                        % plot just the corrected signal
                        plot(thisdata4(1,offset:end), normalized(offset:end), 'Color', lineColor);
                        xlim([xMin xMax]);
                        %legend(subDirStem1);
                        hold on
                        pause(1);
                        newColor = lineColor - [0.005*I, 0., 0.];
                        if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
                            lineColor = newColor;
                        end
                    end
                else
                    if (K == 5)
                        str_dir_to_search = dirStem + subDirStem5;
                        dir_to_search = char(str_dir_to_search);
                        txtpattern = fullfile(dir_to_search, 'avg*.txt');
                        dinfo= dir(txtpattern);
                        for (I = 1 : length(dinfo))
                            thisfilename = fullfile(dir_to_search, dinfo(I).name); 
                            % 09/29/2018 "load" no longer works when add'l fields
                            % appended at end. Need to only read 1024 lines
                            %thisdata2 = load(thisfilename); %load just this file
                            fileID = fopen(thisfilename,'r');
                            [thisdata5] = fscanf(fileID, '%g %g', [2 numPoints]);
                            fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                                thisfilename, max(thisdata5(2,:)) );
                            if (max(thisdata5(2,:)) > maxIntensity)
                                maxIntensity = max(thisdata5(2,:));
                            end
                            %thisdata5 = thisdata5';
                            fclose(fileID);

                            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                            % REFERENCE INDEX

                            % 1. Correct the baseline BEFORE calculating denominator + normalizing
                            % Returns trend as 'e' and baseline corrected signal as 'f'
                            [e, f] = correctBaseline(thisdata5(2,:)');    

                            % 2. Ratiometric
                            % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                            % on either side of refWaveNumber. This maps to: 1 - 11 total
                            % intensities used to calculate the denominator.
                            if (refIndex ~= 0) 
                                numPointsEachSide = 2;
                                denominator5 = getDenominator(refIndex, ...
                                numPointsEachSide, ...
                                numPoints, f(:));
                            end
                            fprintf('denominator = %g at index: %d\n', denominator5, refIndex);

                            % 3. NEW 10/4/18: Normalize what is plotted
                            normalized = f/denominator5;

                            % change to plot starting at index 400
                            % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
                            % plot just the corrected signal
                            plot(thisdata5(1,offset:end), normalized(offset:end), 'Color', lineColor);
                            xlim([xMin xMax]);
                            %legend(subDirStem1);
                            hold on
                            pause(1);
                            newColor = lineColor - [0.005*I, 0., 0.];
                            if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
                                lineColor = newColor;
                            end
                        end
                    else
                        if (K == 6)
                            str_dir_to_search = dirStem + subDirStem6;
                            dir_to_search = char(str_dir_to_search);
                            txtpattern = fullfile(dir_to_search, 'avg*.txt');
                            dinfo= dir(txtpattern);
                            for (I = 1 : length(dinfo))
                                thisfilename = fullfile(dir_to_search, dinfo(I).name); 
                                % 09/29/2018 "load" no longer works when add'l fields
                                % appended at end. Need to only read 1024 lines
                                %thisdata2 = load(thisfilename); %load just this file
                                fileID = fopen(thisfilename,'r');
                                [thisdata6] = fscanf(fileID, '%g %g', [2 numPoints]);
                                fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                                    thisfilename, max(thisdata6(2,:)) );
                                if (max(thisdata6(2,:)) > maxIntensity)
                                    maxIntensity = max(thisdata6(2,:));
                                end
                                %thisdata6 = thisdata6';
                                fclose(fileID);

                                % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                                % REFERENCE INDEX

                                % 1. Correct the baseline BEFORE calculating denominator + normalizing
                                % Returns trend as 'e' and baseline corrected signal as 'f'
                                [e, f] = correctBaseline(thisdata6(2,:)');    

                                % 2. Ratiometric
                                % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                                % on either side of refWaveNumber. This maps to: 1 - 11 total
                                % intensities used to calculate the denominator.
                                if (refIndex ~= 0) 
                                    numPointsEachSide = 2;
                                    denominator6 = getDenominator(refIndex, ...
                                    numPointsEachSide, ...
                                    numPoints, f(:));
                                end
                                fprintf('denominator = %g at index: %d\n', denominator6, refIndex);

                                % 3. NEW 10/4/18: Normalize what is plotted
                                normalized = f/denominator6;

                                % change to plot starting at index 400
                                % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
                                % plot just the corrected signal
                                plot(thisdata6(1,offset:end), normalized(offset:end), 'Color', lineColor);
                                xlim([xMin xMax]);
                                %legend(subDirStem1);
                                hold on
                                pause(1);
                                newColor = lineColor - [0.005*I, 0., 0.];
                                if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
                                    lineColor = newColor;
                                end
                            end
                        else
%                            if (K == 7)
%                                 lineColor = green;
%                                 str_dir_to_search = dirStem + subDirStem7;
%                                 dir_to_search = char(str_dir_to_search);
%                                 txtpattern = fullfile(dir_to_search, 'avg*.txt');
%                                 dinfo= dir(txtpattern);
%                                 for (I = 1 : length(dinfo))
%                                     thisfilename = fullfile(dir_to_search, dinfo(I).name); 
%                                     % 09/29/2018 "load" no longer works when add'l fields
%                                     % appended at end. Need to only read 1024 lines
%                                     %thisdata2 = load(thisfilename); %load just this file
%                                     fileID = fopen(thisfilename,'r');
%                                     [thisdata7] = fscanf(fileID, '%g %g', [2 numPoints]);
%                                     fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
%                                         thisfilename, max(thisdata7(2,:)) );
%                                     if (max(thisdata7(2,:)) > maxIntensity)
%                                         maxIntensity = max(thisdata7(2,:));
%                                     end
%                                     %thisdata7 = thisdata7';
%                                     fclose(fileID);
% 
%                                     % 10/7/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
%                                     % REFERENCE INDEX
% 
%                                     % 1. Correct the baseline BEFORE calculating denominator + normalizing
%                                     % Returns trend as 'e' and baseline corrected signal as 'f'
%                                     [e, f] = correctBaseline(thisdata7(2,:)');    
% 
%                                     % 2. Ratiometric
%                                     % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
%                                     % on either side of refWaveNumber. This maps to: 1 - 11 total
%                                     % intensities used to calculate the denominator.
%                                     if (refIndex ~= 0) 
%                                         numPointsEachSide = 2;
%                                         denominator7 = getDenominator(refIndex, ...
%                                         numPointsEachSide, ...
%                                         numPoints, f(:));
%                                     end
%                                     fprintf('denominator = %g at index: %d\n', denominator7, refIndex);
% 
%                                     % 3. NEW 10/4/18: Normalize what is plotted
%                                     normalized = f/denominator7;
% 
%                                     % change to plot starting at index 400
%                                     % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
%                                     % plot just the corrected signal
%                                     plot(thisdata7(1,offset:end), normalized(offset:end), 'Color', lineColor);
%                                     xlim([xMin xMax]);
%                                     %legend(subDirStem1);
%                                     hold on
%                                     pause(1);
%                                     newColor = lineColor - [0.005*I, 0., 0.];
%                                     if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
%                                         lineColor = newColor;
%                                     end
%                                end
%                            else
%                                if (K == 8)
%                                     str_dir_to_search = dirStem + subDirStem8;
%                                     dir_to_search = char(str_dir_to_search);
%                                     txtpattern = fullfile(dir_to_search, 'avg*.txt');
%                                     dinfo= dir(txtpattern);
%                                     for (I = 1 : length(dinfo))
%                                         thisfilename = fullfile(dir_to_search, dinfo(I).name); 
%                                         % 09/29/2018 "load" no longer works when add'l fields
%                                         % appended at end. Need to only read 1024 lines
%                                         %thisdata2 = load(thisfilename); %load just this file
%                                         fileID = fopen(thisfilename,'r');
%                                         [thisdata8] = fscanf(fileID, '%g %g', [2 numPoints]);
%                                         fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
%                                             thisfilename, max(thisdata8(2,:)) );
%                                         if (max(thisdata8(2,:)) > maxIntensity)
%                                             maxIntensity = max(thisdata8(2,:));
%                                         end
%                                         %thisdata8 = thisdata8';
%                                         fclose(fileID);
% 
%                                         % 10/7/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
%                                         % REFERENCE INDEX
% 
%                                         % 1. Correct the baseline BEFORE calculating denominator + normalizing
%                                         % Returns trend as 'e' and baseline corrected signal as 'f'
%                                         [e, f] = correctBaseline(thisdata8(2,:)');    
% 
%                                         % 2. Ratiometric
%                                         % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
%                                         % on either side of refWaveNumber. This maps to: 1 - 11 total
%                                         % intensities used to calculate the denominator.
%                                         if (refIndex ~= 0) 
%                                             numPointsEachSide = 2;
%                                             denominator8 = getDenominator(refIndex, ...
%                                             numPointsEachSide, ...
%                                             numPoints, f(:));
%                                         end
%                                         fprintf('denominator = %g at index: %d\n', denominator8, refIndex);
% 
%                                         % 3. NEW 10/4/18: Normalize what is plotted
%                                         normalized = f/denominator8;
% 
%                                         % change to plot starting at index 400
%                                         % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
%                                         % plot just the corrected signal
%                                         plot(thisdata8(1,offset:end), normalized(offset:end), 'Color', lineColor);
%                                         xlim([xMin xMax]);
%                                         %legend(subDirStem1);
%                                         hold on
%                                         pause(1);
%                                         newColor = lineColor - [0.005*I, 0., 0.];
%                                         if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
%                                             lineColor = newColor;
%                                         end
%                                    end
%                                else
                                    if (K == 9)
                                        lineColor = green;
                                        str_dir_to_search = dirStem + subDirStem9;
                                        dir_to_search = char(str_dir_to_search);
                                        txtpattern = fullfile(dir_to_search, 'avg*.txt');
                                        dinfo= dir(txtpattern);
                                        for (I = 1 : length(dinfo))
                                            thisfilename = fullfile(dir_to_search, dinfo(I).name); 
                                            % 09/29/2018 "load" no longer works when add'l fields
                                            % appended at end. Need to only read 1024 lines
                                            %thisdata2 = load(thisfilename); %load just this file
                                            fileID = fopen(thisfilename,'r');
                                            [thisdata9] = fscanf(fileID, '%g %g', [2 numPoints]);
                                            fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                                                thisfilename, max(thisdata9(2,:)) );
                                            if (max(thisdata9(2,:)) > maxIntensity)
                                                maxIntensity = max(thisdata9(2,:));
                                            end
                                            %thisdata9 = thisdata9';
                                            fclose(fileID);

                                            % 10/7/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                                            % REFERENCE INDEX

                                            % 1. Correct the baseline BEFORE calculating denominator + normalizing
                                            % Returns trend as 'e' and baseline corrected signal as 'f'
                                            [e, f] = correctBaseline(thisdata9(2,:)');    

                                            % 2. Ratiometric
                                            % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                                            % on either side of refWaveNumber. This maps to: 1 - 11 total
                                            % intensities used to calculate the denominator.
                                            if (refIndex ~= 0) 
                                                numPointsEachSide = 2;
                                                denominator9 = getDenominator(refIndex, ...
                                                numPointsEachSide, ...
                                                numPoints, f(:));
                                            end
                                            fprintf('denominator = %g at index: %d\n', denominator9, refIndex);

                                            % 3. NEW 10/4/18: Normalize what is plotted
                                            normalized = f/denominator9;

                                            % change to plot starting at index 400
                                            % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
                                            % plot just the corrected signal
                                            plot(thisdata9(1,offset:end), normalized(offset:end), 'Color', lineColor);
                                            xlim([xMin xMax]);
                                            hold on
                                            pause(1);
                                            newColor = lineColor - [0.005*I, 0., 0.];
                                            if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
                                                lineColor = newColor;
                                            end
                                        end
                                    else
                                        if (K == 10)
                                            lineColor = blue;
                                            str_dir_to_search = dirStem + subDirStem10;
                                            dir_to_search = char(str_dir_to_search);
                                            txtpattern = fullfile(dir_to_search, 'avg*.txt');
                                            dinfo= dir(txtpattern);
                                            for (I = 1 : length(dinfo))
                                                thisfilename = fullfile(dir_to_search, dinfo(I).name); 
                                                % 09/29/2018 "load" no longer works when add'l fields
                                                % appended at end. Need to only read 1024 lines
                                                %thisdata2 = load(thisfilename); %load just this file
                                                fileID = fopen(thisfilename,'r');
                                                [thisdata10] = fscanf(fileID, '%g %g', [2 numPoints]);
                                                fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                                                    thisfilename, max(thisdata10(2,:)) );
                                                if (max(thisdata10(2,:)) > maxIntensity)
                                                    maxIntensity = max(thisdata10(2,:));
                                                end
                                                %thisdata10 = thisdata10';
                                                fclose(fileID);

                                                % 10/7/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                                                % REFERENCE INDEX

                                                % 1. Correct the baseline BEFORE calculating denominator + normalizing
                                                % Returns trend as 'e' and baseline corrected signal as 'f'
                                                [e, f] = correctBaseline(thisdata10(2,:)');    

                                                % 2. Ratiometric
                                                % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                                                % on either side of refWaveNumber. This maps to: 1 - 11 total
                                                % intensities used to calculate the denominator.
                                                if (refIndex ~= 0) 
                                                    numPointsEachSide = 2;
                                                    denominator10 = getDenominator(refIndex, ...
                                                    numPointsEachSide, ...
                                                    numPoints, f(:));
                                                end
                                                fprintf('denominator = %g at index: %d\n', denominator10, refIndex);

                                                % 3. NEW 10/4/18: Normalize what is plotted
                                                normalized = f/denominator10;

                                                % change to plot starting at index 400
                                                % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
                                                % plot just the corrected signal
                                                plot(thisdata10(1,offset:end), normalized(offset:end), 'Color', lineColor);
                                                xlim([xMin xMax]);
                                                hold on
                                                pause(1);
                                                newColor = lineColor - [0.005*I, 0., 0.];
                                                if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
                                                    lineColor = newColor;
                                                end
                                            end
                                        else
                                            if (K == 11)
                                                str_dir_to_search = dirStem + subDirStem11;
                                                dir_to_search = char(str_dir_to_search);
                                                txtpattern = fullfile(dir_to_search, 'avg*.txt');
                                                dinfo= dir(txtpattern);
                                                for (I = 1 : length(dinfo))
                                                    thisfilename = fullfile(dir_to_search, dinfo(I).name); 
                                                    % 09/29/2018 "load" no longer works when add'l fields
                                                    % appended at end. Need to only read 1024 lines
                                                    %thisdata2 = load(thisfilename); %load just this file
                                                    fileID = fopen(thisfilename,'r');
                                                    [thisdata11] = fscanf(fileID, '%g %g', [2 numPoints]);
                                                    fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                                                        thisfilename, max(thisdata11(2,:)) );
                                                    if (max(thisdata11(2,:)) > maxIntensity)
                                                        maxIntensity = max(thisdata11(2,:));
                                                    end
                                                    %thisdata11 = thisdata11';
                                                    fclose(fileID);

                                                    % 10/7/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
                                                    % REFERENCE INDEX

                                                    % 1. Correct the baseline BEFORE calculating denominator + normalizing
                                                    % Returns trend as 'e' and baseline corrected signal as 'f'
                                                    [e, f] = correctBaseline(thisdata11(2,:)');    

                                                    % 2. Ratiometric
                                                    % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
                                                    % on either side of refWaveNumber. This maps to: 1 - 11 total
                                                    % intensities used to calculate the denominator.
                                                    if (refIndex ~= 0) 
                                                        numPointsEachSide = 2;
                                                        denominator11 = getDenominator(refIndex, ...
                                                        numPointsEachSide, ...
                                                        numPoints, f(:));
                                                    end
                                                    fprintf('denominator = %g at index: %d\n', denominator11, refIndex);

                                                    % 3. NEW 10/4/18: Normalize what is plotted
                                                    normalized = f/denominator11;

                                                    % change to plot starting at index 400
                                                    % plot the trend: plot(thisdata1(1,offset:end), e(offset:end), 'cyan', thisdata1(1,offset:end), f(offset:end), 'blue');
                                                    % plot just the corrected signal
                                                    plot(thisdata11(1,offset:end), normalized(offset:end), 'Color', lineColor);
                                                    xlim([xMin xMax]);
                                                    hold on
                                                    pause(1);
                                                    newColor = lineColor - [0.005*I, 0., 0.];
                                                    if (newColor(1) > 0.) && (newColor(2) > 0.) && (newColor(3) > 0.)
                                                        lineColor = newColor;
                                                    end
                                                end
                                            end
                                        end
                                    end
%                                end
%                            end
                        end
                    end
                end
            end
        end
    end
end
y = 1.3;
text(1710, y, 'Laser Power = 0.375 Max');
y = y - 0.1;
text(1710, y, '5 second integration time per acq');
y = y - 0.1;
text(1710, y, 'Each spectra average of 5 acqs');
y = y - 0.1;
text(1750, y, 'pH 4');
text(1710, y, '_____', 'Color', red);
%y = y - 0.1;
%text(1750, y, 'pH 7');
%text(1710, y, '_____', 'Color', green);
%y = y - 0.1;
%text(1750, y, 'pH 8.5');
%text(1710, y, '_____', 'Color', blue);

% Since ratiometric, use 1.0 for maxIntensity
maxIntensity = 1.0;

%% YHY peaks
% A0 = [1013 1013]; % x vector
% B0 = [0 maxIntensity];   % y vector
% A1 = [1078 1078]; % x vector
% B1 = [0 maxIntensity];   % y vector
% A2 = [1143 1143]; % x vector, pH sensitive
% B2 = [0 maxIntensity];   % y vector
% A3 = [1182, 1182];% x vector
% B3 = [0 maxIntensity];   % y vector
% A4 = [1430 1430]; % x vector, pH sensitive
% B4 = [0 maxIntensity];   % y vector
% A5 = [1481 1481]; % x vector
% B5 = [0 maxIntensity];   % y vector
% A6 = [1587 1587]; % x vector
% B6 = [0 maxIntensity];   % y vector
% A7 = [1702 1702]; % x vector, pH sensitive
% B7 = [0 maxIntensity];   % y vector
% 
% plot(A0, B0, 'black', A1, B1, 'black', A2, B2, 'red', ...
%     A3, B3, 'black', A4, B4, 'red', A5, B5, 'black', A6, B6, 'black', ...
%     A7, B7, 'red');
hold off
title('Ratiometric continuous real-time MBA AuNPs gel 2X in MES 10 minutes apart', 'FontSize', myFont);
xlabel('Wavenumber (cm^-1)', 'FontSize', myFont); % x-axis label
ylabel('Arbitrary Units (A.U.)/Ring-breathing at 1078 cm^-1', 'FontSize', myFont); % y-axis label
%legend(subDirStem1, subDirStem2, subDirStem3, '1013', '1078', '1143', '1182', '1430', ...
%    '1481', '1587', '1702');
% Plot each spectrum (intensity vs wavenumber in a new color overtop

% Q: how to build up to a given number of spectra, say 10, and then drop
% the oldest, i.e. erase. Is this best done by re-drawing plots 2-9 and
% then the new 10th one instead of "erasing" plot 1?

function d = getDenominator(closestRef, numPointsEachSide, numPoints, spectrum)
    % use the closestRef as the x-value of the center point of the peak
    % sum the points from x=(closestRef - numPointsIntegrated) to 
    % x=(closestRef + numPointsIntegrated) and then divide by number of
    % points to average and scale it.
    
    fprintf('getDenominator with numPointsEachSide = %d\n', ...
        numPointsEachSide);
    
    % check that numPointsIntegrated is in range
    lowEnd = closestRef - numPointsEachSide;
    if (lowEnd < 1) 
        fprintf('low end of number of points integrated is out of range');
    end
    highEnd = closestRef + numPointsEachSide;
    if (highEnd > numPoints)
        fprintf('high end of number of points integrated is out of range');
    end
    
    sum = 0;
    fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
        numPointsEachSide);
    startIndex = closestRef - numPointsEachSide;
    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(startIndex);
        fprintf('index: %d, spectrum: %g\n', startIndex, spectrum(startIndex));
        startIndex = startIndex + 1;
    end
    denominator = sum/numPointsToIntegrate;
    fprintf('denominator: %g\n', denominator);
    d = denominator;
end

function [e f] = correctBaseline(tics)
    lambda=1e4; % smoothing parameter
    p=0.001; % asymmetry parameter
    d=2;
    %prog.chroms=tics;
    %prog.point=1;

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