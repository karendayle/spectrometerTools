% 20221221 Dayle 

% Ref: https://www.jmp.com/en_us/statistics-knowledge-portal/t-test/two-sample-t-test.html
% Two-sample t-test assumptions
% To conduct a valid test:
% Data values must be independent. Measurements for one observation do not affect measurements for any other observation.
% Data in each group must be obtained via a random sample from the population.
% Data in each group are normally distributed. There are ways to check.
% Data values are continuous.
% The variances for the two independent groups are equal. There are ways to
% check.
% 
% Given two populations, the null hypothesis says that the means are the
% same at the alpha — Significance level, where alpha = 0.05 (default) | scalar value in the range (0,1)
% h = 0 indicates that ttest2 does not reject the null hypothesis at the default 5% significance level. 
% h = 1 says that the null hypothesis is rejected

x = [0.04, 0.037, 0.05, 0.03, 0.035, 0.036, 0.041, 0.029, 0.045, 0.051];
y = [0.200, 0.216, 0.175, 0.300, 0.189, 0.267, 0.333, 0.198, 0.222, 0.23];

% Ref: https://www.mathworks.com/help/stats/ttest2.html
[h,p,ci,stats] = ttest2(x,y)
