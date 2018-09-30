% Plot files in different directories
% Dayle Kotturi June 2018

% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
% IMPORTANT: dirStem needs trailing backslash
dirStem = "H:\Documents\Data\flow through\";
%subDirStem1 = "pH4 dried 2";
%subDirStem2 = "pH7 dried 2";
%subDirStem3 = "pH10 dried 2";
%subDirStem1 = "pH4-2500";
%subDirStem2 = "pH7-2500";
%subDirStem3 = "pH10-2500";
%subDirStem1 = "MES pH7 solution B";
%subDirStem2 = "MES pH7 solution C";
%subDirStem3 = "MES pH7 solution D";
subDirStem1 = "flow through cont pH4 2X";
subDirStem2 = "flow through cont pH7 2X 2";
subDirStem3 = "flow through cont pH8.5 2X";
%refWaveNumber = 1074.26; % at index 407 - read from file, same for all 3
refIndex = 407; % index where the reference peak is 
                %(ring breathing near 1078 cm^-1
numPoints = 1024;
thisdata1 = zeros(2, numPoints, 'double');
thisdata2 = zeros(2, numPoints, 'double');
thisdata3 = zeros(2, numPoints, 'double');
offset = 400;

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure 
xMin = 1063;
xMax = 1800;
xlim([xMin xMax]);
%ylim([yMin yMax]);
for K = 1 : 3
    maxIntensity = 0; % set initial value
    if (K == 1)
      str_dir_to_search = dirStem + subDirStem1; % args need to be strings
      % UGH, this function only in 2018b. 
      %dir_to_search = convertContainedStringsToChars(str_dir_to_search);
      %How do I get it to char array for fullfile?
      dir_to_search = char(str_dir_to_search);
      txtpattern = fullfile(dir_to_search, 'avg*.txt');
      dinfo = dir(txtpattern); % TO FIX: this returns a list of files and
                               % I am handling them as if there is only 1
      for I = 1 : length(dinfo)
          thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
          % 09/29/2018 "load" no longer works when add'l fields
          % appended at end. Need to only read 1024 lines
          %thisdata2 = load(thisfilename); %load just this file
          fileID = fopen(thisfilename,'r');
          [thisdata1] = fscanf(fileID, '%g %g', [2 numPoints]);
          fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
              thisfilename, max(thisdata1(2,:)) );
          if (max(thisdata1(2,:)) > maxIntensity)
              maxIntensity = max(thisdata1(2,:));
          end
          %thisdata1 = thisdata1';
          fclose(fileID);
          %Ratiometric
          denominator1 = thisdata1(2,refIndex);
          % change to plot starting at index 400
          plot(thisdata1(1,offset:end), thisdata1(2,offset:end)/denominator1, 'blue');
          %legend(subDirStem1);
          hold on
      end
    else
        if (K == 2)
            str_dir_to_search = dirStem + subDirStem2;
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'avg*.txt');
            dinfo = dir(txtpattern);
            for (I = 1 : length(dinfo))
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                % 09/29/2018 "load" no longer works when add'l fields
                % appended at end. Need to only read 1024 lines
                %thisdata2 = load(thisfilename); %load just this file
                fileID = fopen(thisfilename,'r');
                [thisdata2] = fscanf(fileID, '%g %g', [2 numPoints]);
                fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                    thisfilename, max(thisdata2(2,:)) );
                if (max(thisdata2(2,:)) > maxIntensity)
                    maxIntensity = max(thisdata2(2,:));
                end
                %thisdata2 = thisdata2';
                fclose(fileID);
                %Ratiometric
                denominator2 = thisdata2(2,refIndex); 
                plot(thisdata2(1,offset:end), thisdata2(2,offset:end)/denominator2, 'green');
                %legend(subDirStem2);
                hold on
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
                    %Ratiometric
                    denominator3 = thisdata3(2,refIndex); % make this thisdata1 for 1 ref
                    plot(thisdata3(1,offset:end), thisdata3(2,offset:end)/denominator3, 'magenta');
                    %legend(subDirStem3);
                    hold on
                end
            end
        end
    end

end

% Since ratiometric, use 1.0 for maxIntensity
maxIntensity = 1.0;

% YHY peaks
A0 = [1013 1013]; % x vector
B0 = [0 maxIntensity];   % y vector
A1 = [1078 1078]; % x vector
B1 = [0 maxIntensity];   % y vector
A2 = [1143 1143]; % x vector, pH sensitive
B2 = [0 maxIntensity];   % y vector
A3 = [1182, 1182];% x vector
B3 = [0 maxIntensity];   % y vector
A4 = [1430 1430]; % x vector, pH sensitive
B4 = [0 maxIntensity];   % y vector
A5 = [1481 1481]; % x vector
B5 = [0 maxIntensity];   % y vector
A6 = [1587 1587]; % x vector
B6 = [0 maxIntensity];   % y vector
A7 = [1702 1702]; % x vector, pH sensitive
B7 = [0 maxIntensity];   % y vector

plot(A0, B0, 'black', A1, B1, 'black', A2, B2, 'red', ...
    A3, B3, 'black', A4, B4, 'red', A5, B5, 'black', A6, B6, 'black', ...
    A7, B7, 'red');
hold off
title('Ratiometric ' + subDirStem1 + ', ' + subDirStem2 + ' and ' + ...
    subDirStem3);
xlabel('Wavenumber (cm^-1)'); % x-axis label
ylabel('Arbitrary Units (A.U.)/Intensity of ring-breathing at 1078 cm^-1'); % y-axis label
%legend(subDirStem1, subDirStem2, subDirStem3, '1013', '1078', '1143', '1182', '1430', ...
%    '1481', '1587', '1702');
% Plot each spectrum (intensity vs wavenumber in a new color overtop

% Q: how to build up to a given number of spectra, say 10, and then drop
% the oldest, i.e. erase. Is this best done by re-drawing plots 2-9 and
% then the new 10th one instead of "erasing" plot 1?