% RGB
global blue;
global rust;
global gold;
global purple;
global green;
global ciel;
global cherry;
global red;
global black;
global magenta;
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];
magenta = [1.0, 0.0, 1.0];
punchColor = [ red; cherry; magenta; black; rust; gold; green; ciel ];
pHLabel = [ 'pH4.0'; 'pH4.5'; 'pH5.0'; 'pH5.5'; 'pH6.0'; 'pH6.5'; 'pH7.0'; 'pH7.5' ];
% Use the colors to match the pH values (4=red, 7=green, 10=blue)
global myColor1;
global myColor2;
myColor1 = [ green; red; blue; green; blue; red; blue; green; red ];
myColor2 = [ gold; cherry; ciel; gold; ciel; cherry; ciel; gold; cherry ];
global markers;
% for the 3 punches:
markers = [ '-o'; '-^'; '-s'];
global markersAll;
% all the symbols that Matlab has:
markersAll = [ '-o'; '-p'; '-s'; '-d'; '-^'; '-v'; '->'; '-<'; '-x'; '-h'; '-+'; '-*'; '-.'];

% 0. Load the final values of both peaks for each segment of all time
% series
load('Data/endVals.mat');
global endVals
global ssVals

% 1. Alginate
load('Data/myAlgY1AllPunches.mat');
load('Data/myAlgY1AllPunchesStdDev.mat');
figure % 1.1
text(9.5,myAlgY1allPunches(8)+0.03,'Steady State', 'Color', black, ...
    'FontSize', 20);
for i = 1:8
    line([0,10],[myAlgY1allPunches(i),myAlgY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(9.5,myAlgY1allPunches(i)+0.01,pHLabel(i,:), ...
        'Color', punchColor(i,:), 'FontSize', 20);
    hold on;
end
plotEndValsOnSteadyState(1);
set(gca,'FontSize', 30);
title('Alginate: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('Flow cell segment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
ssVals(1,1,1) = myAlgY1allPunches(1);
ssVals(1,1,2) = myAlgY1allPunches(7);

figure % 1.2
% 20200923 plot the static pH4 and pH7 values as a filled in markers
plotSteadyStateValues(1, 4, myAlgY1allPunches);
plotSteadyStateValues(1, 7, myAlgY1allPunches);
% 20200922 plot the end-of-segment value of pH4 and pH7 for all segments
% for all punches
plotScatterOfEndValsOnSteadyState(1);
% make it pretty
set(gca,'FontSize', 30);
title('Alginate: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('pH of flow cell environment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
xlim([3. 8.]);

figure % 1.3
% 20200923 plot the static pH4 and pH7 values as a filled in markers
plotSteadyStateValues(1, 4, myAlgY1allPunches);
plotSteadyStateValues(1, 7, myAlgY1allPunches);
% 20200923 plot the average of all end-of-segment values of pH4 and pH7 
% with std dev error bars for all segments, for all punches 
plotScatterOfAvgs(1);
% make it pretty
set(gca,'FontSize', 30);
title('Alginate: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('pH of flow cell environment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
xlim([3. 8.]);

% 2. PEG
load('Data/myPEGY1AllPunches.mat');
load('Data/myPEGY1AllPunchesStdDev.mat');
figure % 2.1
for i = 1:8
    line([0,10],[myPEGY1allPunches(i),myPEGY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(9.5,myPEGY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
    hold on;
end
plotEndValsOnSteadyState(2);
title('PEG: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('Flow cell segment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
ssVals(2,1,1) = myPEGY1allPunches(1);
ssVals(2,1,2) = myPEGY1allPunches(7);

figure % 2.2
% 20200923 plot the static pH4 and pH7 values as a filled in markers
plotSteadyStateValues(2, 4, myPEGY1allPunches);
plotSteadyStateValues(2, 7, myPEGY1allPunches);
% 20200922 plot the end-of-segment value of pH4 and pH7 for all segments
% for all punches
plotScatterOfEndValsOnSteadyState(2);
% make it pretty
set(gca,'FontSize', 30);
title('PEG: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('pH of flow cell environment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
xlim([3. 8.]);

figure % 2.3
% 20200923 plot the static pH4 and pH7 values as a filled in markers
plotSteadyStateValues(2, 4, myPEGY1allPunches);
plotSteadyStateValues(2, 7, myPEGY1allPunches);
% 20200923 plot the average of all end-of-segment values of pH4 and pH7 
% with std dev error bars for all segments, for all punches 
plotScatterOfAvgs(2);
% make it pretty
set(gca,'FontSize', 30);
title('PEG: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('pH of flow cell environment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
xlim([3. 8.]);

% 3. pHEMA
load('Data/myHEMAY1AllPunches.mat');
load('Data/myHEMAY1AllPunchesStdDev.mat');
figure % 3.1
for i = 1:8
    line([0,10],[myHEMAY1allPunches(i),myHEMAY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(9.5,myHEMAY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
    hold on;
end
plotEndValsOnSteadyState(3);
set(gca,'FontSize', 30);
title('pHEMA: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('Flow cell segment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
ssVals(3,1,1) = myHEMAY1allPunches(1);
ssVals(3,1,2) = myHEMAY1allPunches(7);

figure % 3.2
% 20200923 plot the static pH4 and pH7 values as a filled in markers
plotSteadyStateValues(3, 4, myHEMAY1allPunches);
plotSteadyStateValues(3, 7, myHEMAY1allPunches);
% 20200922 plot the end-of-segment value of pH4 and pH7 for all segments
% for all punches
plotScatterOfEndValsOnSteadyState(3);
% make it pretty
set(gca,'FontSize', 30);
title('pHEMA: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('pH of flow cell environment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
xlim([3. 8.]);

figure % 3.3
% 20200923 plot the static pH4 and pH7 values as a filled in markers
plotSteadyStateValues(3, 4, myHEMAY1allPunches);
plotSteadyStateValues(3, 7, myHEMAY1allPunches);
% 20200923 plot the average of all end-of-segment values of pH4 and pH7 
% with std dev error bars for all segments, for all punches 
plotScatterOfAvgs(3);
% make it pretty
set(gca,'FontSize', 30);
title('pHEMA: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('pH of flow cell environment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
xlim([3. 8.]);

% 4. pHEMA/coAc
load('Data/myHEMACoY1AllPunches.mat');
load('Data/myHEMACoY1AllPunchesStdDev.mat');
figure % 4.1
for i = 1:8
    line([0,10],[myHEMACoY1allPunches(i),myHEMACoY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(9.5,myHEMACoY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
    hold on;
end
plotEndValsOnSteadyState(4);
set(gca,'FontSize', 30);
title('pHEMA/coAc: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('Flow cell segment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
ssVals(4,1,1) = myHEMACoY1allPunches(1);
ssVals(4,1,2) = myHEMACoY1allPunches(7);

figure % 4.2
% 20200923 plot the static pH4 and pH7 values as a filled in markers
plotSteadyStateValues(4, 4, myHEMACoY1allPunches);
plotSteadyStateValues(4, 7, myHEMACoY1allPunches);
% 20200922 plot the end-of-segment value of pH4 and pH7 for all segments
% for all punches
plotScatterOfEndValsOnSteadyState(4);
% make it pretty
set(gca,'FontSize', 30);
title('pHEMA/coAc: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('pH of flow cell environment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm{-1} peak', 'FontSize', 30);
xlim([3. 8.]);

figure % 4.3
% 20200923 plot the static pH4 and pH7 values as a filled in markers
plotSteadyStateValues(4, 4, myHEMACoY1allPunches);
plotSteadyStateValues(4, 7, myHEMACoY1allPunches);
% 20200923 plot the average of all end-of-segment values of pH4 and pH7 
% with std dev error bars for all segments, for all punches 
plotScatterOfAvgs(4);
% make it pretty
set(gca,'FontSize', 30);
title('pHEMA/coAc: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('pH of flow cell environment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm-1 peak', 'FontSize', 30);
xlim([3. 8.]);

% Repeat for pH4 and pH7
for jj = 4:3:7
    figure
    [yDyn(1), errDyn(1)] = buildArrayForBars(1, jj);
    [yDyn(2), errDyn(2)] = buildArrayForBars(2, jj);
    [yDyn(3), errDyn(3)] = buildArrayForBars(3, jj);
    [yDyn(4), errDyn(4)] = buildArrayForBars(4, jj);
    yBar = [yDyn(1) myAlgY1allPunches(jj); yDyn(2) myPEGY1allPunches(jj); ...
        yDyn(3) myHEMAY1allPunches(jj); yDyn(4) myHEMACoY1allPunches(jj)];
    yErr = [errDyn(1) myAlgY1allPunchesStdDev(jj); errDyn(2) myPEGY1allPunchesStdDev(jj); ...
        errDyn(3) myHEMAY1allPunchesStdDev(jj); errDyn(4) myHEMACoY1allPunchesStdDev(jj)];
    plotBarOfAvgsSideBySide(yBar, yErr);
    fname = {'A';'B';'C';'D'};
    set(gca, 'XTick', 1:length(fname),'XTickLabel',fname);
    set(gca, 'FontSize', 30,'FontWeight','bold','box','off');
    myTitle = sprintf('Consistency of hydrogels at pH%d',jj);
    title(myTitle);
    xlabel('Gel type')
    ylabel('Normalized intensity of 1430 cm{-1} peak')
end

% 5. Calculate reversibility of all gels as the std dev of the final value
% of all segments of the SAME pH over all punches of a gel type
calcReversibility();

% 6. Compare the steady-state value with the dynamic value from flow cell
% study when pH is the same (eg. 3 segments of pH4 and 3 of pH7) for all
% punches. Consider only peak 1 
compareDynamicVsStaticAccuracy();

function a = plotEndValsOnSteadyState(gel)
global endVals;
global myColor1;
global myColor2;
global markers;

    for punch = 1:3
        for segment = 1:9
            %index = ((gel-1)*3)+punch;
            % 1430 cm-1 peak
            plot(segment, endVals(gel, punch, segment, 1), ...
                markers(punch,:), 'LineStyle','none', ...
                'MarkerSize', 30, ...
                'Color', myColor1(segment,:), 'linewidth', 2);
            hold on;
            % 1702 cm-1 peak
%             plot(segment, endVals(gel, punch, segment, 2), ...
%                 markers(punch,:), 'LineStyle','none', 'MarkerSize', 30, ...
%                 'Color', myColor2(segment,:), 'linewidth', 2);
%             hold on;
        end 
    end
    a = 1;
end

function b = calcReversibility()
global endVals
global vals
pH4Segments = [2 6 9];
pH7Segments = [1 4 8];
pH10Segments = [3 5 7];

    % Construct the arrays for each peak at each pH level
    for i = 1:4
        for j = 1:3
            pk1pH4 = [endVals(i, j, pH4Segments(1), 1) ...
                      endVals(i, j, pH4Segments(2), 1) ...
                      endVals(i, j, pH4Segments(3), 1)];
            pk1pH7 = [endVals(i, j, pH7Segments(1), 1) ...
                      endVals(i, j, pH7Segments(2), 1) ...
                      endVals(i, j, pH7Segments(3), 1)];
            pk1pH10 = [endVals(i, j, pH10Segments(1), 1) ...
                      endVals(i, j, pH10Segments(2), 1) ...
                      endVals(i, j, pH10Segments(3), 1)];
                  
            pk2pH4 = [endVals(i, j, pH4Segments(1), 2) ...
                      endVals(i, j, pH4Segments(2), 2) ...
                      endVals(i, j, pH4Segments(3), 2)];
            pk2pH7 = [endVals(i, j, pH7Segments(1), 2) ...
                      endVals(i, j, pH7Segments(2), 2) ...
                      endVals(i, j, pH7Segments(3), 2)];
            pk2pH10 = [endVals(i, j, pH10Segments(1), 2) ...
                      endVals(i, j, pH10Segments(2), 2) ...
                      endVals(i, j, pH10Segments(3), 2)];
        end
        
        fprintf('gel %d\n', i);
        % Calculate the std dev of each of the 6 cases
        fprintf('%.3f %.3f %.3f %.3f %.3f %.3f\n', ...
            std(pk1pH4(:)), std(pk1pH7(:)), std(pk1pH10(:)), ...
            std(pk2pH4(:)), std(pk2pH7(:)), std(pk2pH10(:)));
        
        % save for use in dynamic vs static accuracy comparison
        vals(i,1,1,:) = pk1pH4(:);
        vals(i,1,2,:) = pk1pH7(:);
        vals(i,2,1,:) = pk2pH4(:);
        vals(i,2,2,:) = pk2pH7(:);
    end
    b = 1;
end

function c = compareDynamicVsStaticAccuracy()
    global vals;
    global ssVals;
    
    for i = 1:4
        for peak = 1:1
            for pH = 1:2
                diffs(i, peak, pH) = 0;
                for seg = 1:3
%                     fprintf('diff is %.3f - %.3f\n', ...
%                         vals(i, peak, pH, seg), ...
%                         ssVals(i, peak, pH));
                    newVal = abs(vals(i, peak, pH, seg) - ssVals(i, peak, pH));
                    % Use the absolute value in order not to cancel out
                    % differences that straddle the steady state value
                    diffs(i, peak, pH) = diffs(i, peak, pH) + newVal;
                end
                fprintf('gel %d peak %d pH %d difference over all segs: %.3f\n',...
                    i, peak, pH, diffs(i, peak, pH));
            end
        end
    end
    
    c = 1;
end

function d = plotScatterOfEndValsOnSteadyState(gel)
global endVals;
global myColor1;
global myColor2;
global markers;

    for punch = 1:3
        % plot all the pH4 segments: 2, 6, 9
        pH4 = [2 6 9];
        for segment = 1:3
            %index = ((gel-1)*3)+punch;
            % 1430 cm-1 peak
            plot(4, endVals(gel, punch, pH4(segment), 1), ...
                markers(punch,:), 'LineStyle','none', ...
                'MarkerSize', 30, ...
                'Color', myColor1(pH4(segment),:), 'linewidth', 2);
            hold on;
            % 1702 cm-1 peak
%             plot(pH4(segment), endVals(gel, punch, pH4(segment), 2), ...
%                 markers(punch,:), 'LineStyle','none', 'MarkerSize', 30, ...
%                 'Color', myColor2(pH4(segment),:), 'linewidth', 2);
%             hold on;
        end 
        
        % plot all the pH7 segments: 1, 5, 8
        pH7 = [1 4 8];
        for segment = 1:3
            %index = ((gel-1)*3)+punch;
            % 1430 cm-1 peak
            plot(7, endVals(gel, punch, pH7(segment), 1), ...
                markers(punch,:), 'LineStyle','none', ...
                'MarkerSize', 30, ...
                'Color', myColor1(pH7(segment),:), 'linewidth', 2);
            hold on;
            % 1702 cm-1 peak
%             plot(pH7(segment), endVals(gel, punch, pH7(segment), 2), ...
%                 markers(punch,:), 'LineStyle','none', 'MarkerSize', 30, ...
%                 'Color', myColor2(pH7(segment),:), 'linewidth', 2);
%             hold on;
        end   
        
%         % plot all the pH10 segments: 3, 5, 7. Skip this b/c cal curves
%         % don't go past pH7.5
%         pH10 = [3 5 7];
%         for segment = 1:3
%             %index = ((gel-1)*3)+punch;
%             % 1430 cm-1 peak
%             plot(10, endVals(gel, punch, pH10(segment), 1), ...
%                 markers(punch,:), 'LineStyle','none', ...
%                 'MarkerSize', 30, ...
%                 'Color', myColor1(pH10(segment),:), 'linewidth', 2);
%             hold on;
%             % 1702 cm-1 peak
%             plot(pH10(segment), endVals(gel, punch, pH10(segment), 2), ...
%                 markers(punch,:), 'LineStyle','none', 'MarkerSize', 30, ...
%                 'Color', myColor2(pH10(segment),:), 'linewidth', 2);
%             hold on;
%         end 
    end
    d = 1;
end

function e = plotSteadyStateValues(gel, pHlevel, myY1allPunches)
    global black
    global markersAll
    
    switch pHlevel
    case 4
        % 20200923 plot the static pH4 value as a filled in black hexagon
        plot(4, myY1allPunches(1), markersAll(gel,:), 'LineStyle','none', ...
            'MarkerSize', 30, ...
            'MarkerEdgeColor', black, ...
            'MarkerFaceColor', black);
        hold on;
    case 7
        % 20200923 plot the static pH7 value as a filled in black pentagon
        plot(7, myY1allPunches(7), markersAll(gel+4,:), 'LineStyle','none', ...
            'MarkerSize', 30, ...
            'MarkerEdgeColor', black, ...
            'MarkerFaceColor', black);
        hold on;
    end
    e = 1;
end

function f = plotScatterOfAvgs(gel)
global endVals;
global myColor1;
global myColor2;
global markersAll;

    % 1430 cm-1 peak
    A = []; % build a 1D array of values to pass to built-in functions
    % sum over all 3 pH4 segments for all 3 punches (9 values)
    sumPH4 = 0;
    sumSqPH4 = 0;
    n = 9;
    for punch = 1:3
        % plot all the pH4 segments: 2, 6, 9
        pH4 = [2 6 9];
        for segment = 1:3
            A = [ A endVals(gel, punch, pH4(segment), 1)];
            sumPH4 = sumPH4 + endVals(gel, punch, pH4(segment), 1);
        end
    end
    myAvg = sumPH4/n;
    for punch = 1:3
        % plot all the pH4 segments: 2, 6, 9
        pH4 = [2 6 9];
        for segment = 1:3
            term = endVals(gel, punch, pH4(segment), 1) - myAvg;
            sumSqPH4 = sumSqPH4 + (term * term);
        end
    end
    myStdDev = sqrt(sumSqPH4/(n-1));
    
    % Compare to built in functions
    avgA = mean(A); 
    stdDevA = std(A);
    
    % check avgA = myAvg? yes
    % check stdDevA = myStdDev? yes
    
    % plot the average with std dev error bars
    errorbar(4, avgA, stdDevA, ...
        markersAll(gel,:), 'LineStyle','none', ...
        'MarkerSize', 30, ...
        'Color', myColor1(pH4(segment),:), 'linewidth', 2);
        hold on;
        
    % Now do pH7 1430 cm-1 peak, just use built-ins for this, since 
    % check passed
    A = [];
    for punch = 1:3
        % plot all the pH7 segments: 1, 4, 8
        pH7 = [1 4 8];
        for segment = 1:3
            A = [ A endVals(gel, punch, pH7(segment), 1)];
        end
    end
    avgA = mean(A); 
    stdDevA = std(A);
    % plot the average with std dev error bars
    errorbar(7, avgA, stdDevA, ...
        markersAll(gel+4,:), 'LineStyle','none', ...
        'MarkerSize', 30, ...
        'Color', myColor1(pH7(segment),:), 'linewidth', 2);
        hold on;
    f = 1;
end

% new 20201006
% 20201017 add hatched fill of all bars for static values
function h = plotBarOfAvgsSideBySide(yBar, yErr)
    global endVals;
    global myColor1;
    global myColor2;
    global markersAll;
    
    % Plot the dyn average on the left and the static average on the right
    % There are 4 groups (gels) of 2 bars each
    % Fill them with white and hatch fill the static values in later
    a = bar(yBar, 'FaceColor','w'); % This works. See 4 groups of 2 bars each
    
    % Yes, a bit silly to pass in both, but I need 'a' and it's not working
    % to extract yBar back out and doc'n not helping, so doing it this way.
    fillBarsWithHatchedLines(a, yBar);
    
    % But don't have the x data, so how to plot the errorbars?
    xd = get(a,'xdata');
    hold on;
    % make error bars a bit thicker than default
    dx = 0.15;
    b = errorbar([1-dx 1+dx; 2-dx 2+dx; 3-dx 3+dx; 4-dx 4+dx], yBar, ...
        yErr, yErr, 'linewidth', 2, 'LineStyle', 'none', 'Color', 'k');
    hold on;
    h = 1;
end

function [avgA, stdDevA] = buildArrayForBars(gel, pHlevel)
    global endVals;
    A = []; % array to build
    switch pHlevel
    case 4
        % 1430 cm-1 peak
        % sum over all 3 pH4 segments for all 3 punches (9 values)
        n = 9;
        for punch = 1:3
            % plot all the pH4 segments: 2, 6, 9
            pH4 = [2 6 9];
            for segment = 1:3
                A = [ A endVals(gel, punch, pH4(segment), 1)];
            end
        end
        avgA = mean(A); 
        stdDevA = std(A);

    case 7
        % pH7 1430 cm-1 peak
        for punch = 1:3
            % plot all the pH7 segments: 1, 4, 8
            pH7 = [1 4 8];
            for segment = 1:3
                A = [ A endVals(gel, punch, pH7(segment), 1)];
            end
        end
        avgA = mean(A); 
        stdDevA = std(A);
    end
end

function k = fillBarsWithHatchedLines(B, yd)
    bw = 0.23; % deduce by trial and error plotting over actual drawn bar

    % helpful: https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
    for ib = 1:numel(B)
        % important: xData is has the center pts of each bar of group 1 in
        % row 1 and the center pt of each bar of group 2 in row 2
        xData(:,ib) = B(ib).XData+B(ib).XOffset;
    end

    % Now generalize it in a loop
    [rows, cols] = size(yd);
    for i = 1:rows
        for j = 1:2:cols
            fprintf('row %d, col %d', i, j);
            % draw the slanted lines that go all the way across
            y1 = 0; 
            y2 = 0;
            ymax = yd(i,j); 

            % this is the only "weakpoint". The dy depends on ymax value,
            % so the hatchline spacing will vary across bars. This could be
            % changed by using same dy for all bars, but the range of k needs
            % to change as well
            %dy = (ymax - y1)/10;
            %fprintf('dy is %f', dy);
            dy = 0.004; % standardize on this for all bars
            maxK = ceil(ymax/dy); 
            for k = 1:maxK
                x1 = xData(i,j) - bw/2;
                x2 = xData(i,j) + bw/2;
                y2 = y2 + dy;
                % don't draw a line that exceeds ymax
                % use eqn of a line to find a new x2
                if (y2 > ymax)
                    m = dy/bw;
                    b = y1 - m*x1;
                    y2 = ymax;
                    x2 = (y2 - b)/m;
                end
                fprintf ('%d-%d.%d bw=%f x1=%f x2=%f y1=%f y2=%f\n', i, j, k, bw, x1, x2, y1, y2);
                line([x1 x2], [y1 y2],'linewidth',1,'color','k');
                y1 = y1 + dy;
            end
        end
    end
    k = 1;
end