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
 
% Change next 4 lines to what you want to plot
% These are used to find the spectra that get plotted.
% Multiple spectra in each subdir, but the latest one is used for plot
dirStem = "H:\Documents\Data\";
%subDirStem1 = "pH4 dried 2";
%subDirStem2 = "pH7 dried 2";
%subDirStem3 = "pH10 dried 2";
subDirStem1 = "pH4";
subDirStem2 = "pH7";
subDirStem3 = "pH10";

maxIntensity = 0; % set initial value

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure % without this, no plots are drawn
for K = 1 : 3
    if (K == 1)
      str_dir_to_search = dirStem + subDirStem1; % args need to be strings
      % UGH, this function only in 2018b. 
      %dir_to_search = convertContainedStringsToChars(str_dir_to_search);
      %How do I get it to char array for fullfile?
      dir_to_search = char(str_dir_to_search);
      txtpattern = fullfile(dir_to_search, 'spectrum*.txt');
      dinfo = dir(txtpattern); % TO FIX: this returns a list of files and
                               % I am handling them as if there is only 1
      for (I = 1 : length(dinfo))
          thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
          thisdata1 = load(thisfilename); %load just this file
          fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
              thisfilename, max(thisdata1(:)) );
          if (max(thisdata1(:)) > maxIntensity)
              maxIntensity = max(thisdata1(:));
          end
      end
    else
        if (K == 2)
            str_dir_to_search = dirStem + subDirStem2;
            dir_to_search = char(str_dir_to_search);
            txtpattern = fullfile(dir_to_search, 'spectrum*.txt');
            dinfo = dir(txtpattern);
            for (I = 1 : length(dinfo))
                thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
                thisdata2 = load(thisfilename); %load just this file
                fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
                    thisfilename, max(thisdata2(:)) );
                if (max(thisdata2(:)) > maxIntensity)
                    maxIntensity = max(thisdata2(:));
                end
            end
        else
            if (K == 3)
                str_dir_to_search = dirStem + subDirStem3;
                dir_to_search = char(str_dir_to_search);
                txtpattern = fullfile(dir_to_search, 'spectrum*.txt');
                dinfo= dir(txtpattern);
                for (I = 1 : length(dinfo))
                    thisfilename = fullfile(dir_to_search, dinfo(I).name); 
                    % just the name
                    thisdata3 = load(thisfilename); %load just this file
                    fprintf( 'File #%d, "%s", maximum value was: %g\n', ...
                        K, thisfilename, max(thisdata3(:)) );
                    if (max(thisdata3(:)) > maxIntensity)
                        maxIntensity = max(thisdata3(:));
                    end
                end
            end
        end
    end
end

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

plot(thisdata1(:,1), thisdata1(:,2), 'blue', ...
    thisdata2(:,1), thisdata2(:,2), 'red', ...
    thisdata3(:,1), thisdata3(:,2), 'magenta', ...
    A0, B0, 'black', A1, B1, 'black', A2, B2, 'green', ...
    A3, B3, 'black', A4, B4, 'green', A5, B5, 'black', A6, B6, 'black', ...
    A7, B7, 'green');
title(subDirStem1 + ', ' + subDirStem2 + ' and ' + subDirStem3);
xlabel('Wavenumber (cm^-1)'); % x-axis label
ylabel('Arbitrary Units (A.U.)'); % y-axis label
legend('pH4', 'pH7', 'pH10', '1013', '1078', '1143', '1182', '1430', ...
    '1481', '1587', '1702');
% Plot each spectrum (intensity vs wavenumber in a new color overtop

% Q: how to build up to a given number of spectra, say 10, and then drop
% the oldest, i.e. erase. Is this best done by re-drawing plots 2-9 and
% then the new 10th one instead of "erasing" plot 1?