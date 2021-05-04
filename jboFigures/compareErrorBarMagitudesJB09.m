addpath('../functionLibrary');

close all;

x = 1:16; % Cases: 1-4 alginate: ph4 1430, 1702; ph7 1430, 1702
          %         5-8 PEG: ph4 1430, 1702; ph7 1430, 1702
          %         9-12 pHEMA: ph4 1430, 1702; ph7 1430, 1702
          %         13-16 pHEMA-coA: ph4 1430, 1702; ph7 1430, 1702

% Standard deviations for 16 cases for each of four values of N
N125 = [0.006947,0.009672,0.001134,0.000689,0.002591,0.002842,0.001381,...
    0.001062,0.002262,0.001811,0.003672,0.004042,0.001621,0.001659,...
    0.00704,0.002812];
N5 = [0.009642,0.009762,0.003545,0.000482,0.007982,0.009121,0.067462,...
    0.005948,0.00164,0.003423,0.0064,0.003012,0.002142,0.00167,0.010244,...
    0.004534];
N45 = [0.007413,0.008159,0.002228,0.001259,0.007152,0.025783,0.020467,...
    0.004187,0.006567,0.013851,0.00328,0.003989,0.065921,0.034032,...
    0.006468,0.001392];
N9 = [0.007735,0.007517,0.002454,0.000592,0.003556,0.023921,0.014895,...
    0.000137,0.006474,0.013617,0.003123,0.003688,0.068656,0.031081,...
    0.00544,0.00021];


figure
xlim([0.5 16.5]);
plot(x,N125,':or', x,N5,'-+b', x,N45,'--*g', x,N9,'-.sk');
set(gca,'FontSize',32, 'box', 'off');
xlabel('Case'); % x-axis label
ylabel('Std Dev of normalized intensity'); % y-axis label
legend('N=125', 'N=5','N=45', 'N=9', 'Location', 'Northwest');

% 95% CIs for 16 cases for each of four values of N
CIN125 = [0.001217863,0.001695576,0.000198799,0.000120787,0.000454222,...
0.000498225,0.0002421,0.000186177,0.000396546,0.000317482,0.00064373,...
0.000708594,0.000284174,0.000290836,0.001234166,0.000492965];
CIN5 = [0.008451586,0.00855677,0.00310733,0.000422492,0.006996531,...
0.007994909,0.05913305,0.005213652,0.001437523,0.003000392,0.0056116,...
0.002640134,0.001877546,0.00146382,0.008979262,0.003974226];
CIN45 = [0.002165927,0.002383893,0.000650976,0.000367854,0.002089668,...
0.007533265,0.005980039,0.001223356,0.001918743,0.004046979,0.000958349,...
0.001165504,0.019260768,0.009943454,0.001889817,0.000406714];
CIN9 = [0.005053533,0.004911107,0.00160328,0.000386773,0.002323253,...
0.015628387,0.0097314,8.95067E-05,0.00422968,0.00889644,0.00204036,...
0.002409493,0.047576181,0.020306253,0.003554133,0.0001372];

figure
set(gca,'FontSize',32, 'box', 'off');
xlim([0.5 16.5]);
plot(x,CIN125,':or', x,CIN5,'-+b', x,CIN45,'--*g', x,CIN9,'-.sk');
set(gca,'FontSize',32, 'box', 'off');
xlabel('Case'); % x-axis label
ylabel('95% CI for normalized intensity'); % y-axis label
legend('N=125', 'N=5','N=45', 'N=9', 'Location', 'Northwest');

% % alginate
% figure
% plot(x(1:4),N125(1:4),'-.or', x(1:4),N5(1:4),'-+b', x(1:4),N45(1:4),...
%     '-.*g', x(1:4),N9(1:4),'-.sk');
% title('alginate');
% 
% % peg
% figure
% plot(x(1:4),N125(5:8),'-.or', x(1:4),N5(5:8),'-+r', x(1:4),N45(5:8),...
%     '-.*b', x(1:4),N9(5:8),'-.sb');
% title('PEG');
% 
% % phe
% figure
% plot(x(1:4),N125(9:12),'-.or', x(1:4),N5(9:12),'-+r', x(1:4),N45(9:12),...
%     '-.*b', x(1:4),N9(9:12),'-.sb');
% title('pHEMA');
% 
% % phc
% figure
% plot(x(1:4),N125(13:16),'-.or', x(1:4),N5(13:16),'-+r', x(1:4),N45(13:16),...
%     '-.*b', x(1:4),N9(13:16),'-.sb');
% title('pHEMA-coA');
% 
% % stacked
% figure
% set(gca,'FontSize',20,'FontWeight','bold','box','off')
% newYlabels = {'alginate','PEG','pHEMA','pHEMA-coA'};
% y=[N125(1:4); N125(5:8); N125(9:12); N125(13:16)];
% h = stackedplot(x(1:4), y', 'DisplayLabels', newYlabels, 'FontSize', 15);