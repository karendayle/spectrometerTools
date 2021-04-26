% Plot the dark, raw and avg *.txt files for a given top level directory.
% Use to check a dataset

% Dayle Kotturi April 2021

numPoints = 1024;
% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
% CHOOSE (specify) the top level directory of the dataset
% dir_to_search = 'C:\Users\dayle.kotturi\Documents\Data\SORS1';
%dir_to_search = 'R:\Students\Dayle\Data\Made by Waqas\Blank gels\gel 4\blank3\1';
dir_to_search = 'R:\BMEN\McShane_Mike\Students\Dayle\Data\Made by Waqas\other\gel 4\redo blank3\1';

% 1. PLOT THE DARK
txtpattern = fullfile(dir_to_search, 'dark*.txt');
dinfo = dir(txtpattern);
figure
for K = 1 : length(dinfo)
  thisfilename = fullfile(dir_to_search, dinfo(K).name); % just the name
  fileID = fopen(thisfilename,'r');
  [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
  fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );
  
  % do something with the data
  plot(thisdata(1,:), thisdata(2,:));
  hold on
  pause(1);
end
myTitle = sprintf('dark spectrum for %s', dir_to_search);
title(myTitle);

% 2. PLOT THE RAW SPECTRA, 2 DIFFERENT WAYS
txtpattern = fullfile(dir_to_search, 'raw*.txt');
dinfo = dir(txtpattern);
figure
for K = 1 : length(dinfo)
  thisfilename = fullfile(dir_to_search, dinfo(K).name); % just the name
  fileID = fopen(thisfilename,'r');
  [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
  fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );
  
  % do something with the data
  plot(thisdata(1,:), thisdata(2,:));
  hold on
  pause(1);
end
myTitle = sprintf('All raw spectra for %s', dir_to_search);
title(myTitle);

txtpattern = fullfile(dir_to_search, 'raw*.txt');
dinfo = dir(txtpattern);
figure
for K = 1 : length(dinfo)
  thisfilename = fullfile(dir_to_search, dinfo(K).name); % just the name
  fileID = fopen(thisfilename,'r');
  [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
  fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );
  
  % do something with the data
  for II = 1:1024
      z(II) = K;
  end
  plot3(thisdata(1,:),z,thisdata(2,:));
  hold on
  pause(1);
end
myTitle = sprintf('3D of all raw spectra for %s', dir_to_search);
title(myTitle);

% 2. PLOT THE AVG SPECTRA, 2 DIFFERENT WAYS
txtpattern = fullfile(dir_to_search, 'avg*.txt');
dinfo = dir(txtpattern);
figure
for K = 1 : length(dinfo)
  thisfilename = fullfile(dir_to_search, dinfo(K).name); % just the name
  fileID = fopen(thisfilename,'r');
  [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
  fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );
  
  % do something with the data
  plot(thisdata(1,:), thisdata(2,:));
  hold on
  pause(1);
end
myTitle = sprintf('All avg spectra for %s', dir_to_search);
title(myTitle);

txtpattern = fullfile(dir_to_search, 'avg*.txt');
dinfo = dir(txtpattern);
figure
for K = 1 : length(dinfo)
  thisfilename = fullfile(dir_to_search, dinfo(K).name); % just the name
  fileID = fopen(thisfilename,'r');
  [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
  fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );
  
  % do something with the data
  for II = 1:1024
      z(II) = K;
  end
  plot3(thisdata(1,:),z,thisdata(2,:));
  hold on
  pause(1);
end
myTitle = sprintf('3D of all avg spectra for %s', dir_to_search);
title(myTitle);

% Plot each spectrum (intensity vs wavenumber in a new color overtop

% Q: how to build up to a given number of spectra, say 10, and then drop
% the oldest, i.e. erase. Is this best done by re-drawing plots 2-9 and
% then the new 10th one instead of "erasing" plot 1?