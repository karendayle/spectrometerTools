Yout1 =  msbackadj(thisdata1(:,1), thisdata1(:,2));
Yout2 =  msbackadj(thisdata2(:,1), thisdata2(:,2));
Yout3 =  msbackadj(thisdata3(:,1), thisdata3(:,2));
plot(thisdata1(:,1),Yout1,'blue',thisdata2(:,1),Yout2,'red',thisdata3(:,1),Yout3, 'magenta' );
legend(subDirStem1, subDirStem2, subDirStem3);
xlabel('Wavenumber (cm^-1)'); % x-axis label
ylabel('Ratiometric with ref = max intensity'); % y-axis label
title('Baseline corrected');
