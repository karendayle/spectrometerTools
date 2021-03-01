x = [    0.3350    0.4000    0.5000    0.6000    0.7000    0.8000    0.9000 ]
y = [ 19.4 55.8 115.1 182.2 251.5 319.4 343.9 ]

figure
plot(x,y) 
title('Measured laser power vs fraction of full power IPS Laser BioSyM Lab');
ylabel('Power (mW)')
xlabel('Fraction of full power')

%bsc fitting
%Result of bsc fitting
fraction = [0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.375 0.363 0.35 0.338 0.325]
power = 6.1e2*fraction - 1.8e2

% what fraction is 20 mW?
f = (20 + 1.8e2)/6.1e2