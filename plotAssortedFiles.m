% Plot files in different directories

% Dayle Kotturi June 2018

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
figure % without this, no plots are drawn
for K = 1 : 3
  if (K == 1)
      dir_to_search = 'H:\Documents\Data\pH4 dried 2';
      txtpattern = fullfile(dir_to_search, 'spectrum*.txt');
      dinfo = dir(txtpattern); % TO FIX: this returns a list of files
                               % and I am handling them as if there is only
                               % 1
      for (I = 1 : length(dinfo))
          thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
          thisdata1 = load(thisfilename); %load just this file
          fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
              thisfilename, max(thisdata1(:)) );
      end
  else if (K == 2) 
      dir_to_search = 'H:\Documents\Data\pH7 dried 2';
      txtpattern = fullfile(dir_to_search, 'spectrum*.txt');
      dinfo = dir(txtpattern);
      thisfilename = fullfile(dir_to_search, dinfo.name); % just the name
      thisdata2 = load(thisfilename); %load just this file
      fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
          thisfilename, max(thisdata2(:)) );
  else if (K == 3) 
      dir_to_search = 'H:\Documents\Data\pH10 dried 2';
      txtpattern = fullfile(dir_to_search, 'spectrum*.txt');
      dinfo= dir(txtpattern);
      thisfilename = fullfile(dir_to_search, dinfo.name); % just the name
      thisdata3 = load(thisfilename); %load just this file
      fprintf( 'File #%d, "%s", maximum value was: %g\n', K, ...
          thisfilename, max(thisdata3(:)) );
      end
  end
  end

end

% YHY peaks
A0 = [1013 1013]; % x vector
B0 = [0 15000];   % y vector
A1 = [1078 1078]; % x vector
B1 = [0 15000];   % y vector
A2 = [1143 1143]; % x vector, pH sensitive
B2 = [0 15000];   % y vector
A3 = [1182, 1182];% x vector
B3 = [0 15000];   % y vector
A4 = [1430 1430]; % x vector, pH sensitive
B4 = [0 15000];   % y vector
A5 = [1481 1481]; % x vector
B5 = [0 15000];   % y vector
A6 = [1587 1587]; % x vector
B6 = [0 15000];   % y vector
A7 = [1702 1702]; % x vector, pH sensitive
B7 = [0 15000];   % y vector
plot(thisdata1(:,1), thisdata1(:,2), 'blue', thisdata2(:,1), ...
    thisdata2(:,2), 'cyan', thisdata3(:,1), thisdata3(:,2), 'magenta', ...
    A0, B0, 'blue', A1, B1, 'blue', A2, B2, 'green', ...
    A3, B3, 'blue', A4, B4, 'green', A5, B5, 'blue', A6, B6, 'blue', ...
    A7, B7, 'green');
xlabel('Wavenumber (cm^-1)'); % x-axis label
ylabel('Arbitrary Units (A.U.)'); % y-axis label
legend('pH4', 'pH7', 'pH10', '1013', '1078', '1143', '1182', '1430', '1481', '1587', '1702');
% Plot each spectrum (intensity vs wavenumber in a new color overtop

% Q: how to build up to a given number of spectra, say 10, and then drop
% the oldest, i.e. erase. Is this best done by re-drawing plots 2-9 and
% then the new 10th one instead of "erasing" plot 1?