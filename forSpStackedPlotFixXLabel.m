% Fixes the superscript in the x axis label
% 
% Note: this script generates a warning because it is accessing 
% hidden properties, but that is the only way to make it work,
% given the implementation of stackedplot, at least in Matlab 2019 version
%
% Dayle Kotturi                  2020/08/31

figure
x=[1 2 3];
y=[4 5 6; 7 8 9; 10 11 12];
h = stackedplot(x,y');

% index 3 to access this XLabel because there are 3 stacked plots.
% If there are more, then match it.
axesProps = struct(h.AxesProperties(3));  
axesProps.Axes.XLabel.Interpreter = 'tex';

% Careful of case here. xlabel != XLabel
h.xlabel('Wavenumber cm^{-1}');





