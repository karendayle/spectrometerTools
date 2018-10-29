% Draw an animated plot showing spectra changing over time

% Dayle Kotturi June 2018

numPoints = 1024;

% Colors:

 blue =    [0.0000, 0.4470, 0.7410];
 rust =    [0.8500, 0.3250, 0.0980];
 gold =    [0.9290, 0.6940, 0.1250];
 purple =  [0.4940, 0.1840, 0.5560];
 green =   [0.4660, 0.6740, 0.1880];
 ciel =    [0.3010, 0.7450, 0.9330];
 cherry =  [0.6350, 0.0780, 0.1840];

 colors = [blue; rust; gold; purple; green; ciel; cherry];

% Read in a set of spectra from a time-series 
% Read in the name of the FOLDER.
dir_to_search = 'H:\Documents\Data\SORS-noSignal-9Trials\';
txtpattern = fullfile(dir_to_search, 'spectrum-*.txt');
dinfo = dir(txtpattern);

figure % nothing gets drawn without this

% Plot each spectrum (intensity vs wavenumber in a new color overtop
for K = 1 : length(dinfo)
  thisfilename = fullfile(dir_to_search, dinfo(K).name); % just the name
  thisdata = load(thisfilename); %load just this file
  fprintf( 'File #%d, "%s"\n', K, thisfilename );
  for j=1:1024
    fprintf( '%g %g\n', thisdata(j,1),thisdata(j,2));
  end
  
  % Animated plot  
  index = mod(K,7) + 1;
  curve=animatedline('Color', colors(index,:));
  %set(gca,'XLim',[0 2000],'YLim',[0 24000],'ZLim',[0 100]);
  
  %z = ones(1, numPoints, 'double') * K;
  
  for j=1:1024
    addpoints(curve,thisdata(j,1),thisdata(j,2),K);
    drawnow
  end
end
title('Your title here');
xlabel('Wavenumber (cm^-1)'); % x-axis label
ylabel('Arbitrary Units (A.U.)'); % y-axis label


