% Import PS.csv as a nx2 table

% DON'T:
%plot(PS(:,1), PS(:,2))
%Error using tabular/plot
%Too many input arguments.

% DO:
plot(PS{:,1}, PS{:,2})
