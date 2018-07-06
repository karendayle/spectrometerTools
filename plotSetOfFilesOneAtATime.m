% Draw an animated plot showing spectra changing over time

% Dayle Kotturi June 2018

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
dir_to_search = 'C:\Users\dayle.kotturi\Documents\Data\MPy 0.500 power 5 sec integraton MAYBE signal - make a movie';
txtpattern = fullfile(dir_to_search, '*.txt');
dinfo = dir(txtpattern);
for K = 1 : length(dinfo)
  thisfilename = fullfile(dir_to_search, dinfo(K).name); % just the name
  thisdata = load(thisfilename); %load just this file
  fprintf( 'File #%d, "%s", maximum value was: %g\n', K, thisfilename, max(thisdata(:)) );
  
  % do something with the data
  plot(thisdata(:,1), thisdata(:,2))
  pause(1);
end
xlabel('Wavenumber (cm^-1)'); % x-axis label
ylabel('Arbitrary Units (A.U.)'); % y-axis label
% Plot each spectrum (intensity vs wavenumber in a new color overtop

% Q: how to build up to a given number of spectra, say 10, and then drop
% the oldest, i.e. erase. Is this best done by re-drawing plots 2-9 and
% then the new 10th one instead of "erasing" plot 1?