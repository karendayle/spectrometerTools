r2 = lactate';
%r2 = lactate_bg';
% Define number of columns to average
AVG_COLS = 9;
% Dimension over which to average
DIM = 2; % Columns
% Use filter to calculate the moving average across EVERY combination of columns
r_moving_avg = filter(ones(1,AVG_COLS)/AVG_COLS,1,r2,[],DIM);
% Grab only the column averages that were actually wanted
r_avg = r_moving_avg(:,AVG_COLS:AVG_COLS:end);
y2_avg=r_avg';
%lactate_avg_bg=asysm(y2_avg, 1e5, 0.001, 2)
%lactate_bg=asysm(lactate, 1e5, 0.001, 2)
figure
%plot(X',lactate_avg_bg)
plot(X',y2_avg)