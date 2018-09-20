% Dayle Kotturi September 2018
% Run this function at matlab prompt passing it a matrix of spectrum per
% row, with the intensities in the columns
function bc(tics)

lambda=1e6; % smoothing parameter
p=0.001; % asymmetry parameter
d=2;
prog.chroms=tics;
prog.point=1;

% asym: Baseline estimation with asymmetric least squares using weighted
% smoothing with a finite difference penalty.
%   signals: signal, each column represents one signal
%   lambda: smoothing parameter (generally 1e5 to 1e8)
%   p: asymmetry parameter (generally 0.001)
%   d: order of differences in penalty (generally 2)
%prog.temp_tic=asysm(tics(1,:)',lambda,p,d);
prog.temp_tic=asysm(tics,lambda,p,d);
prog.temp_tic=prog.temp_tic';

figure

%axe_superimpose=axes('position',[0.1 0.55 0.7 0.35]);  
%plot(axe_superimpose,tics(1,:));
plot(tics,'red');
title ('Baseline Correction with asysm');
hold('on');
%plot(axe_superimpose,prog.temp_tic,'magenta');
plot(prog.temp_tic,'magenta');
%hold(axe_superimpose,'off');

%axe_bc=axes('position',[0.1 0.1 0.7 0.35]);
%plot(axe_bc,tics(1,:)-prog.temp_tic);
%plot(axe_bc,tics(:)-prog.temp_tic(:)); % kdk: this works but why do I need
                                       % the ':'?
%plot(axe_superimpose,tics(:)-prog.temp_tic(:));
plot(tics(:)-prog.temp_tic(:),'blue');  
title ('Baseline Correction with asysm');
legend('original spectrum','detected trend','baseline corrected','Location','northoutside');
xlabel('index'); % x-axis label
ylabel('Arbitrary Units (A.U.)/Intensity of ring-breathing at 1074 cm^-1'); % y-axis label
hold('off'); %new

% debug by uncommenting 
%tics
%prog.temp_tic

% Compare to method of msbackadj:
figure
[m,n] = size(tics);
VarName1 = linspace(0,m,m); % make an array with m values from 0 to m
size(VarName1)
size(tics)
Yout = msbackadj(VarName1', tics);
plot(VarName1,tics,'red', VarName1,Yout,'black');
xlabel('index'); % x-axis label
ylabel('Arbitrary Units (A.U.)/Intensity of ring-breathing at 1074 cm^-1'); % y-axis label
title ('Baseline Correction with msbackadj');
legend('original spectrum','baseline corrected','Location','northoutside');

% Calculate the difference
error = (tics(:)-prog.temp_tic(:)) - Yout;
figure
plot(VarName1,tics(:)-prog.temp_tic(:), 'blue', VarName1,Yout,'black', VarName1,error,'green');
title ('Difference in baseline correction methods');
legend('asysm','msbackadj','asysm-msbackadj','Location','northoutside');
xlabel('index'); % x-axis label
ylabel('Arbitrary Units (A.U.)/Intensity of ring-breathing at 1074 cm^-1'); % y-axis label
% Next: return result: tics(:)-prog.temp_tic(:) as an array to calling
% program