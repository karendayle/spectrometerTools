% import data from spectrum*.txt into VarName1 and VarName2 as 
% IMPORTED DATA -> OutputType ->column vectors
Yout = msbackadj(VarName1, VarName2);
plot(VarName1,VarName2,'red', VarName1,Yout,'blue');
ylabel('Arbitrary Units (A.U.)'); % y-axis label
xlabel('Wavenumber (cm^-1)'); % x-axis label
title ('Baseline Correction Applied');
legend('blue = baseline corrected','red = original','Location','northoutside');