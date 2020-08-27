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
% all the symbols that Matlab has:
% [ '-o' '-+' '-*' '-.' '-x' '-s' '-d' '-^' '-v' '->' '-<' '-p' '-h'];
markers = [ '-o'; '-^'; '-s']; 

% 0. Load the final values of both peaks for each segment of all time
% series
load('Data/endVals.mat');
global endVals
global ssVals

% 1. Alginate
load('Data/myAlgY1AllPunches.mat');
figure
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
title('Alginate: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('Flow cell segment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm-1 peak', 'FontSize', 30);
ssVals(1,1,1) = myAlgY1allPunches(1);
ssVals(1,1,2) = myAlgY1allPunches(7);
% ssVals(1,2,1) = myAlgY2allPunches(1);
% ssVals(1,2,2) = myAlgY2allPunches(7);

% 2. PEG
load('Data/myPEGY1AllPunches.mat');
figure
for i = 1:8
    line([0,10],[myPEGY1allPunches(i),myPEGY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(9.5,myPEGY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
    hold on;
end
plotEndValsOnSteadyState(2);
title('PEG: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('Flow cell segment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm-1 peak', 'FontSize', 30);
ssVals(2,1,1) = myPEGY1allPunches(1);
ssVals(2,1,2) = myPEGY1allPunches(7);
% ssVals(2,2,1) = myPEGY2allPunches(1);
% ssVals(2,2,2) = myPEGY2allPunches(7);

% 3. pHEMA
load('Data/myHEMAY1AllPunches.mat');
figure
for i = 1:8
    line([0,10],[myHEMAY1allPunches(i),myHEMAY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(9.5,myHEMAY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
    hold on;
end
plotEndValsOnSteadyState(3);
title('pHEMA: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('Flow cell segment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm-1 peak', 'FontSize', 30);
ssVals(3,1,1) = myHEMAY1allPunches(1);
ssVals(3,1,2) = myHEMAY1allPunches(7);
% ssVals(3,2,1) = myHEMAY2allPunches(1);
% ssVals(3,2,2) = myHEMAY2allPunches(7);

% 4. pHEMA/coAc
load('Data/myHEMACoY1AllPunches.mat');
figure
for i = 1:8
    line([0,10],[myHEMACoY1allPunches(i),myHEMACoY1allPunches(i)], ...
        'Color', punchColor(i,:));
    text(9.5,myHEMACoY1allPunches(i)+0.01,pHLabel(i,:), 'Color', punchColor(i,:));
    hold on;
end
plotEndValsOnSteadyState(4);
title('pHEMA/coAc: ability of flow cell to match steady state target after 30 msmts', 'FontSize', 30);
xlabel('Flow cell segment', 'FontSize', 30);
ylabel('Normalized Intensity of 1430 cm-1 peak', 'FontSize', 30);
ssVals(4,1,1) = myHEMACoY1allPunches(1);
ssVals(4,1,2) = myHEMACoY1allPunches(7);
% ssVals(4,2,1) = myHEMACoY2allPunches(1);
% ssVals(4,2,2) = myHEMACoY2allPunches(7);

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
