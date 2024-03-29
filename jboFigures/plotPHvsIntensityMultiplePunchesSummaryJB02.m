% Plot pH vs intensity using the calibration curve study data as input.
% Details:
% Get points from files in different directories. 
% Go after just the pH-sensitive part of the spectra.
% Q: How wide is the bandwidth of the area under the curve?
% A: Match it to the range of the BP filters used by the Raman reader.
% Calculate the std dev for each point based on the set of 5 avg*.txt files
% (which are already averages of 5 themselves) and use stddev for error bars
% First, make plots for each of the gels (#17, 18, 19,20) made 6/3/2020

% Dayle Kotturi July 2020, time of COVID
% Modifications from JBO1 script:
% 1. first time automating xlim, ylim and x,y position of legends from
% range of plotted data
% 2. change xRef, x1 and x2 global values to go back and forth between
% plotting 1430, 1702 raw peaks, normalized peaks and plotting
% 1072, 1582 raw, normalized peaks
% Make a switch for JB01 (1430, 1702 pks) and JB02 (1072 and 1582 pks)
% Figure out why/how minY can be > maxY
% Make deltaY = factor * (max Y - min Y), instead of just max Y
% On plots with all gel types, use unique markers per gel
% Add tiny amount to upper ylim to allow entire marker (and not just its 
% center to fit

% TO DO save plots to file

addpath('../functionLibrary');

% CHOOSE set to 0 to use old gels and 1 to use new gels
newGels = 1;

% IF using old gels (i.e. newGels = 0), then 
% CHOOSE between datasets
% at beginning (1) or end (2) of June 2020
global dataset
dataset = 2;

% CHOOSE between using single numerator value or average of local area 
% under the curve. 1 = average, 2 = single
global numeratorType
numeratorType = 1;

global peakSet
% CHOOSE: Change this to change which peaks are plotted
% Set to 1 for 1430 & 1702, normalized by 1582 peak; 
% Set to 2 for 1072 & 1582, normalized by each other.
peakSet = 1; 
% CHOOSE xRef to specify normalized peak to use,
% Set to zero to specify that you don't want normalization 

global xRef
% Use the index 713 to get the intensity at the reference peak, COO-,
% at 1582/cm. Note that the numPointsEachSide is used to take the area 
% under the curve around the center point xRef
xRef = 713;
%xRef = 715; % was 713 for all analysis prior to 7/9/2020
%xRef = 406; % the 1072 "ref" peak
%xRef = 0;

% Colors:
global black
global purple
global blue
global ciel
global green
global rust
global gold
global red
global cherry
global magenta

% RGB
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
punchColor = [ magenta; rust; gold; ciel; purple; black ];

global pH
pH = [ 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5 ];

% global myX
% global myY1
% global myY2
% global myErr1
% global myErr2

% The paths to each hydrogel type and gel number
% This script deals with the four gels made on 6/3/2020 by SP
global dirStem

% 2021/02/16 NEW to match JB07 output
global allAlgY1
global allAlgErr1
global allAlgY2
global allAlgNum
global allAlgDenom
global allAlgErr2
global allPEGY1
global allPEGErr1
global allPEGY2
global allPEGErr2
global allPEGNum
global allPEGDenom
global allHEMAY1
global allHEMAErr1
global allHEMAY2
global allHEMAErr2
global allHEMANum
global allHEMADenom
global allHEMACoY1
global allHEMACoErr1
global allHEMACoY2
global allHEMACoErr2
global allHEMACoNum
global allHEMACoDenom

close all; % clean the slate

switch newGels
    case 0
        switch dataset
            case 1
                dirStem = [ ...
                    "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\calib curve study 2\", ...
                    "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 16\", ...
                    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\", ...
                    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\" ...
                    ];
            case 2
                dirStem = [ ...
                    "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\", ...
                    "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 16\", ...
                    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\", ...
                    "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\" ...
                    ];
        end
        myTitle = [ ...
            "54nm MBA AuNPs in alg gel#12 in static buffer for 1 hour", ...
            "54nm MBA AuNPs in PEG gel#16 in static buffer for 1 hour", ...
            "54nm MBA AuNPs in pHEMA gel#13 in static buffer for 1 hour", ...
            "54nm MBA AuNPs in pHEMA/coAc gel#14 in static buffer for 1 hour" ...
            ];
    case 1
        dirStem = [ ...
            "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 17\", ...
            "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 18\", ...
            "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 19\", ...
            "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 20\" ...
            ];
        myTitle = [ ...
            "54nm MBA AuNPs in alg gel#17 in static buffer for 1 hour", ...
            "54nm MBA AuNPs in PEG gel#18 in static buffer for 1 hour", ...
            "54nm MBA AuNPs in pHEMA gel#19 in static buffer for 1 hour", ...
            "54nm MBA AuNPs in pHEMA/coAc gel#20 in static buffer for 1 hour" ...
            ];
end

switch dataset
    case 1
        % 20210405 matching how plotAssortedFilesRatioCalibrationOldGels.m works
        subDirStem = [ ...
            "calib pH4", "calib pH4.5", "calib pH5", ...
            "calib pH5.5", "calib pH6", "calib pH6.5", ...
            "calib pH7", "calib pH7.5" ...
            ];
    case 2
        subDirStem = [ ...
            "pH4 punch", "pH4.5 punch", "pH5 punch", ...
            "pH5.5 punch", "pH6 punch", "pH6.5 punch", ...
            "pH7 punch", "pH7.5 punch" ...
            ];
end
global lineThickness;
lineThickness = 2;
global numPoints;
numPoints = 1024;
global numPointsEachSide;
numPointsEachSide = 2; %20210405 increase this (2->5) to see the effect

global x1;
global x2;
switch peakSet
    case 1
        % Common case
        % 1) Use the index 614 to get the intensity at 1430/cm (act. 1428.58/cm)
        x1 = 614;
        % 2) Use the index 794 to get the intensity at 1702/cm (act. 1701.95/cm)
        x2 = 794;
    case 2
        % Alternative case 
        % Instead of pulling out the 1430 and 1702 pH sensitive peaks, 
        % use the two reference peaks: the 1072 and the 1582 peaks
        x1 = 406; % the 1072 "ref" peak
        x2 = xRef; % the 1582 "ref" peak
end

global xMin
global xMax
global yMin
global yMax
xMin = 950;
xMax = 1800;
yMin = 0;
yMax = 20.0;
myTextFont = 30;

global myDebug;
myDebug = 0;

% 7/16/2020 New for automatic sizing of axes and positioning of legend
% Min and max values of each gel

minY1 = zeros(1, 4, 'double');
minY2 = zeros(1, 4, 'double');
maxX  = zeros(1, 4, 'double');
maxY1 = zeros(1, 4, 'double');
maxY2 = zeros(1, 4, 'double');
% 2021/03/31 two pbs here: first, HEMA and HEMACo are missing, 
% second, this is wrong num of rows for oldGels. 2021/04/01 fix this up
switch newGels
    case 0
        allAlgY1   = zeros(1, 8, 'double');
        allAlgErr1 = zeros(1, 8, 'double');
        allAlgY2   = zeros(1, 8, 'double');
        allAlgErr2 = zeros(1, 8, 'double');
        allAlgNum  = zeros(1, 8, 'double');
        allPEGY1   = zeros(1, 8, 'double');
        allPEGErr1 = zeros(1, 8, 'double');
        allPEGY2   = zeros(1, 8, 'double');
        allPEGErr2 = zeros(1, 8, 'double');
        allPEGNum  = zeros(1, 8, 'double');
        allHEMAY1   = zeros(1, 8, 'double');
        allHEMAErr1 = zeros(1, 8, 'double');
        allHEMAY2   = zeros(1, 8, 'double');
        allHEMAErr2 = zeros(1, 8, 'double');
        allHEMANum  = zeros(1, 8, 'double');
        allHEMACoY1   = zeros(1, 8, 'double');
        allHEMACoErr1 = zeros(1, 8, 'double');
        allHEMACoY2   = zeros(1, 8, 'double');
        allHEMACoErr2 = zeros(1, 8, 'double');
        allHEMACoNum  = zeros(1, 8, 'double');
    case 1
        allAlgY1   = zeros(5, 8, 'double'); % 2021/03/05 may not matter
        allAlgErr1 = zeros(5, 8, 'double');
        allAlgY2   = zeros(5, 8, 'double');
        allAlgErr2 = zeros(5, 8, 'double');
        allAlgNum  = zeros(5, 8, 'double');
        allPEGY1   = zeros(5, 8, 'double');
        allPEGErr1 = zeros(5, 8, 'double');
        allPEGY2   = zeros(5, 8, 'double');
        allPEGErr2 = zeros(5, 8, 'double');
        allPEGNum  = zeros(5, 8, 'double');
        allHEMAY1   = zeros(5, 8, 'double');
        allHEMAErr1 = zeros(5, 8, 'double');
        allHEMAY2   = zeros(5, 8, 'double');
        allHEMAErr2 = zeros(5, 8, 'double');
        allHEMANum  = zeros(5, 8, 'double');
        allHEMACoY1   = zeros(5, 8, 'double');
        allHEMACoErr1 = zeros(5, 8, 'double');
        allHEMACoY2   = zeros(5, 8, 'double');
        allHEMACoErr2 = zeros(5, 8, 'double');
        allHEMACoNum  = zeros(5, 8, 'double');
end

% CHOOSE set of gels to plot 1=alg, 2=PEGm 3=pHEMA, 4=pHEMAcoA
for J=1:4   
    figure % Figure #1-4: one plot for each gel, showing x1 and x2, with or
           % without norm'n (depends on xRef).
    
    if newGels 
        maxM = 5; % all punches 1-5 of new gels
    else
        maxM = 1; % 1a of old gels
    end
    
    for M =1:maxM 
        for K = 1:8 % all pH levels 4, 4.5, ..., 7.5 2021/03/05 moved lower
             if newGels
                subDirWithPunch = subDirStem(K) + M + "\1";
                % Go get the avg and std dev for both peaks for one punch and pH
                [a, b, c, d, e, numSpectra, g] = prepPlotData(J, subDirWithPunch, K, ...
                    punchColor(M,:), M);
             else
                 switch dataset
                     case 1
                        % 20210405 matching how plotAssortedFilesRatioCalibrationOldGels.m works
                        subDirWithPunch = subDirStem(K) + "\1";
                     case 2
                        subDirWithPunch = subDirStem(K) + "1a" + "\1";
                 end
                 % Go get the avg and std dev for both peaks for one punch and pH
                 [a, b, c, d, e, numSpectra, g] = prepPlotData(J, subDirWithPunch, K, ...
                     punchColor(6,:), M);
             end
            if myDebug
                fprintf('Case %d: %d spectra\n', K, numSpectra);  
            end
        
            % store these arrays to be able to make a combined plot for all
            % gels later

            minX = 4.;
            maxX = 7.5;
            
            allX(K) = a;
            switch J
                case 1
                    allAlgY1(M,K) = b; % Put the first gels' values into a row
                    allAlgErr1(M,K) = c;
                    allAlgY2(M,K) = d;
                    allAlgErr2(M,K) = e;
                    allAlgNum(M,K) = numSpectra;
                    allAlgDenom(M,K) = g;
                case 2
                    allPEGY1(M,K) = b; % Put the first gels' values into a row
                    allPEGErr1(M,K) = c;
                    allPEGY2(M,K) = d;
                    allPEGErr2(M,K) = e;
                    allPEGNum(M,K) = numSpectra;
                    allPEGDenom(M,K) = g;
                case 3
                    allHEMAY1(M,K) = b; % Put the first gels' values into a row
                    allHEMAErr1(M,K) = c;
                    allHEMAY2(M,K) = d;
                    allHEMAErr2(M,K) = e;
                    allHEMANum(M,K) = numSpectra;
                    allHEMADenom(M,K) = g;
                case 4
                    allHEMACoY1(M,K) = b; % Put the first gels' values into a row
                    allHEMACoErr1(M,K) = c;
                    allHEMACoY2(M,K) = d;
                    allHEMACoErr2(M,K) = e;
                    allHEMACoNum(M,K) = numSpectra;
                    allHEMACoDenom(M,K) = g;
            end
        end
        
        % Now for the table of values for gel comparison
        % get min, max, delta and %delta 
        switch J % fill the correct array based on the type of gel
            case 1
                myAlgY1Min(M) = min(allAlgY1(M,:));    
                myAlgY1Max(M) = max(allAlgY1(M,:)); % 7/16/2020 can't I just use this max?
                myAlgY1Delta(M) = myAlgY1Max(M) - myAlgY1Min(M);
                myAlgY1PercentDelta(M) = myAlgY1Delta(M)/myAlgY1Min(M)*100.;
                myAlgY2Min(M) = min(allAlgY2(M,:));    
                myAlgY2Max(M) = max(allAlgY2(M,:));
                myAlgY2Delta(M) = myAlgY2Max(M) - myAlgY2Min(M);
                myAlgY2PercentDelta(M) = myAlgY2Delta(M)/myAlgY2Min(M)*100.;
            case 2
                myPEGY1Min(M) = min(allPEGY1(M,:));    
                myPEGY1Max(M) = max(allPEGY1(M,:));
                myPEGY1Delta(M) = myPEGY1Max(M) - myPEGY1Min(M);
                myPEGY1PercentDelta(M) = myPEGY1Delta(M)/myPEGY1Min(M)*100.;
                myPEGY2Min(M) = min(allPEGY2(M,:));    
                myPEGY2Max(M) = max(allPEGY2(M,:));
                myPEGY2Delta(M) = myPEGY2Max(M) - myPEGY2Min(M);
                myPEGY2PercentDelta(M) = myPEGY2Delta(M)/myPEGY2Min(M)*100.;
            case 3                
                myHEMAY1Min(M) = min(allHEMAY1(M,:));    
                myHEMAY1Max(M) = max(allHEMAY1(M,:));
                myHEMAY1Delta(M) = myHEMAY1Max(M) - myHEMAY1Min(M);
                myHEMAY1PercentDelta(M) = myHEMAY1Delta(M)/myHEMAY1Min(M)*100.;
                myHEMAY2Min(M) = min(allHEMAY2(M,:));    
                myHEMAY2Max(M) = max(allHEMAY2(M,:));
                myHEMAY2Delta(M) = myHEMAY2Max(M) - myHEMAY2Min(M);
                myHEMAY2PercentDelta(M) = myHEMAY2Delta(M)/myHEMAY2Min(M)*100.;
            case 4
                myHEMACoY1Min(M) = min(allHEMACoY1(M,:));    
                myHEMACoY1Max(M) = max(allHEMACoY1(M,:));
                myHEMACoY1Delta(M) = myHEMACoY1Max(M) - myHEMACoY1Min(M);
                myHEMACoY1PercentDelta(M) = myHEMACoY1Delta(M)/myHEMACoY1Min(M)*100.;
                myHEMACoY2Min(M) = min(allHEMACoY2(M,:));    
                myHEMACoY2Max(M) = max(allHEMACoY2(M,:));
                myHEMACoY2Delta(M) = myHEMACoY2Max(M) - myHEMACoY2Min(M);
                myHEMACoY2PercentDelta(M) = myHEMACoY2Delta(M)/myHEMACoY2Min(M)*100.;
        end
    end
    
    % 7/16/2020 New, for automatic plot axes sizing
    switch J
        case 1
            minY1(J) = min(myAlgY1Min);
            minY2(J) = min(myAlgY2Min);
            maxY1(J) = max(myAlgY1Max);
            maxY2(J) = max(myAlgY2Max);
        case 2
            minY1(J) = min(myPEGY1Min);
            minY2(J) = min(myPEGY2Min);
            maxY1(J) = max(myPEGY1Max);
            maxY2(J) = max(myPEGY2Max);
        case 3
            minY1(J) = min(myHEMAY1Min);
            minY2(J) = min(myHEMAY2Min);
            maxY1(J) = max(myHEMAY1Max);
            maxY2(J) = max(myHEMAY2Max);
        case 4
            minY1(J) = min(myHEMACoY1Min);
            minY2(J) = min(myHEMACoY2Min);
            maxY1(J) = max(myHEMACoY1Max);
            maxY2(J) = max(myHEMACoY2Max);
    end

    title(myTitle(J), 'FontSize', myTextFont);
    % 7/16/2020 only say "normalized" when xRef ~= 0
    if (xRef ~= 0) 
        %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
        ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
    else
        ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont);
    end
        xlabel('pH', 'FontSize', myTextFont);
    %set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
    set(gca,'FontSize',myTextFont,'box','off'); % 2021/02/18 rm bold

    % 7/16/2020 New, automatic sizing
    xlim([minX-0.5 maxX+0.5]);
    ylim([0.99 * min(minY1(J),minY2(J)) 1.01 * max(maxY1(J),maxY2(J))]);
    y = 0.95 * (max(maxY1(J), maxY2(J)) - min(minY1(J), minY2(J))) + ...
        min(minY1(J), minY2(J));
    deltaY = 0.1 * (max(maxY1(J), maxY2(J)) - min(minY1(J), minY2(J)));
    x = 1.01 * (minX - 0.5);
    switch peakSet
        case 1
            % JB01
            text(x, y, 'circles = 1430 cm^-^1 peak', 'Color', black, 'FontSize', myTextFont);
        case 2
            % JB02
            text(x, y, 'circles = 1072 cm^-^1 peak', 'Color', black, 'FontSize', myTextFont);
    end
    text(x, y, '_____', 'Color', black, 'FontSize', myTextFont);
    y = y - deltaY;
    switch peakSet
        case 1
            % JB01
            text(x, y, 'squares = 1702 cm^-^1 peak', 'Color', black, 'FontSize', myTextFont);
        case 2
            % JB02
            text(x, y, 'squares = 1582 cm^-^1 peak', 'Color', black, 'FontSize', myTextFont);
    end
    text(x, y, '______', 'Color', black, 'FontSize', myTextFont);
    y = y - deltaY;

    if newGels
        text(x, y, 'punch 1', 'Color', punchColor(1,:), 'FontSize', myTextFont);
        text(x, y, '_______', 'Color', punchColor(1,:), 'FontSize', myTextFont);
        y = y - deltaY;
        text(x, y, 'punch 2', 'Color', punchColor(2,:), 'FontSize', myTextFont);
        text(x, y, '_______', 'Color', punchColor(2,:), 'FontSize', myTextFont);
        y = y - deltaY;
        text(x, y, 'punch 3', 'Color', punchColor(3,:), 'FontSize', myTextFont);
        text(x, y, '_______', 'Color', punchColor(3,:), 'FontSize', myTextFont);
        y = y - deltaY;
        text(x, y, 'punch 4', 'Color', punchColor(4,:), 'FontSize', myTextFont);
        text(x, y, '_______', 'Color', punchColor(4,:), 'FontSize', myTextFont);
        y = y - deltaY;
        text(x, y, 'punch 5', 'Color', punchColor(5,:), 'FontSize', myTextFont);
        text(x, y, '_______', 'Color', punchColor(5,:), 'FontSize', myTextFont);
        y = y - deltaY;
    else
        text(x, y, 'punch 1a', 'Color', punchColor(6,:), 'FontSize', myTextFont);
        text(x, y, '________', 'Color', punchColor(6,:), 'FontSize', myTextFont);
    end
end

% New, per 6/19 MJM comments: combine the punches
% TO DO use different markers for gel type
figure % Figure #5: put all of the punches of all of the gels' x1 curves on
       % one plot, with or without norm'n (depends on xRef).
       
myColor = [ red; blue; green; purple ];
for J = 1:4
    switch J
        case 1
            for M = 1:maxM
                plot(allX, allAlgY1(M,:), '-o', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allAlgY1(M,:), allAlgErr1(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 2
            for M = 1:maxM
                plot(allX, allPEGY1(M,:), '-h', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allPEGY1(M,:), allPEGErr1(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 3
            for M = 1:maxM
                plot(allX, allHEMAY1(M,:), '-^', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allHEMAY1(M,:), allHEMAErr1(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 4
            for M = 1:maxM
                plot(allX, allHEMACoY1(M,:), '-s', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allHEMACoY1(M,:), allHEMACoErr1(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
    end
end

switch peakSet
    case 1
        % JB01 case:
        % 7/16/2020 only say "normalized" when xRef ~= 0
        if (xRef ~= 0) 
            title('1430 cm^-^1 normalized peak average for all punches of all gels', 'FontSize', myTextFont)
            %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
            ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
        else
            title('1430 cm^-^1 peak average for all punches of all gels', 'FontSize', myTextFont)
            ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont);
        end
    case 2
        % JB02 case:
        % 7/16/2020 only say "normalized" when xRef ~= 0
        if (xRef ~= 0) 
            title('1072 cm^-^1 normalized peak average for all punches of all gels', 'FontSize', myTextFont)
            %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
            ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
        else
            title('1072 cm^-^1 peak average for all punches of all gels', 'FontSize', myTextFont)
            ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont); 
        end
end

xlabel('pH', 'FontSize', myTextFont); % x-axis label
%set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
set(gca,'FontSize',myTextFont,'box','off'); % 2021/02/18 rm bold

% 7/16/2020 New, automatic sizing
xlim([minX-0.5 maxX+0.5]);
ylim([0.99 * min(minY1) 1.01 * max(maxY1)]);
y = 0.95 * (max(maxY1) - min(minY1)) + min(minY1);
deltaY = 0.1 * (max(maxY1) - min(minY1));
x = 0.9 * (maxX + 0.5);
deltaX = 0.1;
plot(x, y, '-o', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', red, 'linewidth', 2);
text(x + deltaX, y, 'alginate', 'Color', red, 'FontSize', myTextFont);
%text(x + deltaX, y, '______', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-h', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', blue, 'linewidth', 2);
text(x + deltaX, y, 'PEG', 'Color', blue, 'FontSize', myTextFont);
%text(x + deltaX, y, '____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-^', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', green, 'linewidth', 2);
text(x + deltaX, y, 'pHEMA', 'Color', green, 'FontSize', myTextFont);
%text(x + deltaX, y, '_______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-s', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', purple, 'linewidth', 2);
text(x + deltaX, y, 'pHEMA/coAc', 'Color', purple, 'FontSize', myTextFont);
%text(x + deltaX, y, '___________', 'Color', purple, 'FontSize', myTextFont);

figure % Figure #6: put all of the punches of all of the gels' x2 curves on
       % one plot, with or without norm'n (depends on xRef).
% TO DO use different markers for gel type
for J = 1:4
    switch J
        case 1
            for M = 1:maxM
                plot(allX, allAlgY2(M,:), '-o', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allAlgY2(M,:), allAlgErr2(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 2
            for M = 1:maxM
                plot(allX, allPEGY2(M,:), '-h', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allPEGY2(M,:), allPEGErr2(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 3
            for M = 1:maxM
                plot(allX, allHEMAY2(M,:), '-^', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allHEMAY2(M,:), allHEMAErr2(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 4
            for M = 1:maxM
                plot(allX, allHEMACoY2(M,:), '-s', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allHEMACoY2(M,:), allHEMACoErr2(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
    end
end
switch peakSet
    case 1
        % JB01 case:
        % % 7/16/2020 only say "normalized" when xRef ~= 0
        if (xRef ~= 0) 
            title('1702 cm^-^1 normalized peak average for all punches of all gels', 'FontSize', myTextFont)
            %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
            ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
        else
            title('1702 cm^-^1 peak average for all punches of all gels', 'FontSize', myTextFont)
            ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont);
        end
    case 2
        % JB02 case:
        % 7/16/2020 only say "normalized" when xRef ~= 0
        if (xRef ~= 0) 
            title('1582 cm^-^1 normalized peak average for all punches of all gels', 'FontSize', myTextFont)
            %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
            ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
        else
            title('1582 cm^-^1 peak average for all punches of all gels', 'FontSize', myTextFont)
            ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont);
        end
end
xlabel('pH', 'FontSize', myTextFont); % x-axis label
%set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
set(gca,'FontSize',myTextFont,'box','off'); % 2021/02/18 rm bold

% 7/16/2020 New, automatic sizing
xlim([minX-0.5 maxX+0.5]);
ylim([0.99 * min(minY2) 1.01 * max(maxY2)]);
y = 0.95 * (max(maxY2) - min(minY2)) + min(minY2);
deltaY = 0.1 * (max(maxY2) - min(minY2));
x = 0.9 * (maxX + 0.5);
deltaX = 0.1;
plot(x, y, '-o', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', red, 'linewidth', 2);
text(x + deltaX, y, 'alginate', 'Color', red, 'FontSize', myTextFont);
text(x + deltaX, y, '______', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-h', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', blue, 'linewidth', 2);
text(x + deltaX, y, 'PEG', 'Color', blue, 'FontSize', myTextFont);
text(x + deltaX, y, '____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-^', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', green, 'linewidth', 2);
text(x + deltaX, y, 'pHEMA', 'Color', green, 'FontSize', myTextFont);
text(x + deltaX, y, '_______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-s', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', purple, 'linewidth', 2);
text(x + deltaX, y, 'pHEMA/coAc', 'Color', purple, 'FontSize', myTextFont);
text(x + deltaX, y, '___________', 'Color', purple, 'FontSize', myTextFont);

%--------------------------------------------------------------------------
% From this point on, condense the data for all punches down to average
% and std dev for each gel type
% Compute the average and std dev of the punches of each gel
% This is only meaningful when number of punches > 1
% As written, this std dev is ignoring the variance in the 5 averaged msmts
% Want to plot these with err bars
% fprintf('Averages and Std Dev over all punches at each pH: 4, 4.5, ..., 7.5\n');
global myAlgY1AllPunches
global myAlgY1AllPunchesStdDev
global myAlgY2AllPunches
global myAlgY2AllPunchesStdDev
global myAlgNum
global myPEGY1AllPunches
global myPEGY1AllPunchesStdDev
global myPEGY2AllPunches
global myPEGY2AllPunchesStdDev
global myPEGNum
global myHEMAY1AllPunches
global myHEMAY1AllPunchesStdDev
global myHEMAY2AllPunches
global myHEMAY2AllPunchesStdDev
global myHEMANum
global myHEMACoY1AllPunches
global myHEMACoY1AllPunchesStdDev
global myHEMACoY2AllPunches
global myHEMACoY2AllPunchesStdDev
global myHEMACoNum

for K = 1:8
    [ nrows, ~ ] = size(allAlgY1);
    a = getAverageAndStdDev(allAlgY1(:,K));
    myAlgY1AllPunches(K) = a(1);
    myAlgY1AllPunchesStdDev(K) = a(2);
    myAlgNum(K) = nrows; % sum(allAlgNum(:,K));
    %fprintf('pH(%d) alg 1430/cm %.3f %.3f\n', K, myAlgY1AllPunches(K), myAlgY1AllPunchesStdDev(K));
        
    a = getAverageAndStdDev(allAlgY2(:,K));
    myAlgY2AllPunches(K) = a(1);
    myAlgY2AllPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) alg 1702/cm %.3f %.3f\n', K, myAlgY2AllPunches(K), myAlgY2AllPunchesStdDev(K));
    
    a = getAverageAndStdDev(allPEGY1(:,K));
    myPEGY1AllPunches(K) = a(1);
    myPEGY1AllPunchesStdDev(K) = a(2);
    myPEGNum(K) = nrows; % sum(allPEGNum(:,K));
    %fprintf('pH(%d) peg 1430/cm %.3f %.3f\n', K, myPEGY1AllPunches(K), myPEGY1AllPunchesStdDev(K));
        
    a = getAverageAndStdDev(allPEGY2(:,K));
    myPEGY2AllPunches(K) = a(1);
    myPEGY2AllPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) peg 1702/cm %.3f %.3f\n', K, myPEGY2AllPunches(K), myPEGY2AllPunchesStdDev(K));
    
    a = getAverageAndStdDev(allHEMAY1(:,K));
    myHEMAY1AllPunches(K) = a(1);
    myHEMAY1AllPunchesStdDev(K) = a(2);
    myHEMANum(K) = nrows; % sum(allHEMANum(:,K));
    %fprintf('pH(%d) pHE 1430/cm %.3f %.3f\n', K, myHEMAY1AllPunches(K), myHEMAY1AllPunchesStdDev(K));
        
    a = getAverageAndStdDev(allHEMAY2(:,K));
    myHEMAY2AllPunches(K) = a(1);
    myHEMAY2AllPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) pHE 1702/cm %.3f %.3f\n', K, myHEMAY2AllPunches(K), myHEMAY2AllPunchesStdDev(K));
    
    a = getAverageAndStdDev(allHEMACoY1(:,K));
    myHEMACoY1AllPunches(K) = a(1);
    myHEMACoY1AllPunchesStdDev(K) = a(2);
    myHEMACoNum(K) = nrows; % sum(allHEMACoNum(:,K));
    %fprintf('pH(%d) pHC 1430/cm %.3f %.3f\n', K, myHEMACoY1AllPunches(K), myHEMACoY1AllPunchesStdDev(K));
        
    a = getAverageAndStdDev(allHEMACoY2(:,K));
    myHEMACoY2AllPunches(K) = a(1);
    myHEMACoY2AllPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) pHC 1702/cm %.3f %.3f\n', K, myHEMACoY2AllPunches(K), myHEMACoY2AllPunchesStdDev(K));
end

% fprintf('Averages and Std Dev over all punches at each pH: 4, 4.5, ..., 7.5\n');
sumVarAlgPk1 = 0;
sumVarPegPk1 = 0;
sumVarpHEPk1 = 0;
sumVarpHCPk1 = 0;
sumVarAlgPk2 = 0;
sumVarPegPk2 = 0;
sumVarpHEPk2 = 0;
sumVarpHCPk2 = 0;
for K = 1:8
    %fprintf('alg 1430/cm pH(%d) %.3f %.3f\n', K, myAlgY1AllPunches(K), myAlgY1AllPunchesStdDev(K));
    sumVarAlgPk1 = sumVarAlgPk1 + myAlgY1AllPunchesStdDev(K);
end        
for K = 1:8
    %fprintf('alg 1702/cm pH(%d) %.3f %.3f\n', K, myAlgY2AllPunches(K), myAlgY2AllPunchesStdDev(K));
    sumVarAlgPk2 = sumVarAlgPk2 + myAlgY2AllPunchesStdDev(K);
end 
for K = 1:8
    %fprintf('peg 1430/cm pH(%d) %.3f %.3f\n', K, myPEGY1AllPunches(K), myPEGY1AllPunchesStdDev(K));
    sumVarPegPk1 = sumVarPegPk1 + myPEGY1AllPunchesStdDev(K);
end 
for K = 1:8    
    %fprintf('peg 1702/cm pH(%d) %.3f %.3f\n', K, myPEGY2AllPunches(K), myPEGY2AllPunchesStdDev(K));
    sumVarPegPk2 = sumVarPegPk2 + myPEGY2AllPunchesStdDev(K);
end
for K = 1:8 
    %fprintf('pHE 1430/cm pH(%d) %.3f %.3f\n', K, myHEMAY1AllPunches(K), myHEMAY1AllPunchesStdDev(K));
    sumVarpHEPk1 = sumVarpHEPk1 + myHEMAY1AllPunchesStdDev(K);
end       
for K = 1:8
    %fprintf('pHE 1702/cm pH(%d) %.3f %.3f\n', K, myHEMAY2AllPunches(K), myHEMAY2AllPunchesStdDev(K));
    sumVarpHEPk2 = sumVarpHEPk2 + myHEMAY2AllPunchesStdDev(K);
end   
for K = 1:8
    %fprintf('pHC 1430/cm pH(%d) %.3f %.3f\n', K, myHEMACoY1AllPunches(K), myHEMACoY1AllPunchesStdDev(K));
    sumVarpHCPk1 = sumVarpHCPk1 + myHEMACoY1AllPunchesStdDev(K);
end        
for K = 1:8
    %fprintf('pHC 1702/cm pH(%d) %.3f %.3f\n', K, myHEMACoY2AllPunches(K), myHEMACoY2AllPunchesStdDev(K));
    sumVarpHCPk2 = sumVarpHCPk2 + myHEMACoY2AllPunchesStdDev(K);
end

% fprintf('sum of std devs for all pH levels\n');
% switch peakSet
%     case 1
%         fprintf('alg 1430/cm %.3f 1702/cm %.3f\n', sumVarAlgPk1, sumVarAlgPk2);
%         fprintf('peg 1430/cm %.3f 1702/cm %.3f\n', sumVarPegPk1, sumVarPegPk2);
%         fprintf('pHE 1430/cm %.3f 1702/cm %.3f\n', sumVarpHEPk1, sumVarpHEPk2);
%         fprintf('pHC 1430/cm %.3f 1702/cm %.3f\n', sumVarpHCPk1, sumVarpHCPk2);
%     case 2
%         fprintf('alg 1072/cm %.3f 1582/cm %.3f\n', sumVarAlgPk1, sumVarAlgPk2);
%         fprintf('peg 1072/cm %.3f 1582/cm %.3f\n', sumVarPegPk1, sumVarPegPk2);
%         fprintf('pHE 1072/cm %.3f 1582/cm %.3f\n', sumVarpHEPk1, sumVarpHEPk2);
%         fprintf('pHC 1072/cm %.3f 1582/cm %.3f\n', sumVarpHCPk1, sumVarpHCPk2);
% end

% Plot the averages of the punches with their std dev on one plot for all
% gel types
FigH = figure('Position', get(0, 'Screensize')); 
       % Figure #7: put the avg of the punches of all of the gels' x1
       % curves on one plot, with or without norm'n (depends on xRef).
       % 2021/02/18 This is JBO figure 4a
for J = 1:4
    switch J
        case 1         
            plot(allX, myAlgY1AllPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myAlgY1AllPunches, myAlgY1AllPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
        case 2
            plot(allX, myPEGY1AllPunches, '-h', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myPEGY1AllPunches, myPEGY1AllPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;        
        case 3
            plot(allX, myHEMAY1AllPunches, '-^', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myHEMAY1AllPunches, myHEMAY1AllPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
        case 4
            plot(allX,  myHEMACoY1AllPunches, '-s', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX,  myHEMACoY1AllPunches,  myHEMACoY1AllPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
    end 
end

switch peakSet
    case 1
        % JB01:
        % 7/16/2020 only say "normalized" when xRef ~= 0
        if (xRef ~= 0) 
            % 2021/02/18 out for final JBO version
            % title('1430 cm^-^1 normalized peak average and std dev of all punches of all gels', 'FontSize', myTextFont)
            %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
            ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
        else
            title('1430 cm^-^1 peak average and std dev of all punches of all gels', 'FontSize', myTextFont)
            ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont);
        end
    case 2
        % JB02:
        % 7/16/2020 only say "normalized" when xRef ~= 0
        if (xRef ~= 0) 
            % 2021/02/20 out for final JBO version
            % title('1072 cm^-^1 normalized peak average and std dev of all punches of all gels', 'FontSize', myTextFont)
            %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
            ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
        else
            title('1072 cm^-^1 peak average and std dev of all punches of all gels', 'FontSize', myTextFont)
            ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont);
        end
end
xlabel('pH', 'FontSize', myTextFont); % x-axis label

%set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
set(gca,'FontSize',myTextFont,'box','off'); % 2021/02/18 rm bold

% 2020/07/16 New, automatic sizing
% 2021/02/19 Fix the range for both 1430 and 1702 plots
xlim([minX-0.5 maxX+0.5]);
max1 = max(maxY1);
max2 = max(maxY2);
maxOverall = max(max1, max2);
min1 = min(minY1);
min2 = min(minY2);
minOverall = min(min1, min2);
if (minOverall > maxOverall) % 2020/07/20 WHY IS THIS NECESSARY? 
    ylim([(0.99*maxOverall) (1.01*minOverall)]);
else
    ylim([(0.99*minOverall) (1.01*maxOverall)]);
end
y = 0.95 * (maxOverall - minOverall) + minOverall;
deltaY = 0.1 * (maxOverall - minOverall);

switch newGels
    case 0
        switch peakSet % the shape of the curve is different ...
            case 1
                switch dataset
                    case 1
                        x = 5.5;
                    case 2
                        x = minX - 0.25; % old gels legend must be a bit more left
                end
            case 2
                x = 5.5; % ... and the 1072 ref pk
        end
    case 1
        switch peakSet % the shape of the curve is different ...
            case 1
                x = minX; % ... for the 1430 pk
            case 2
                x = 0.8 * (maxX + 0.5); % ... and the 1072 ref pk
        end
end

deltaX = 0.1;
plot(x, y, '-o', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', red, 'linewidth', 2);
text(deltaX  + x, y, 'alginate', 'Color', red, 'FontSize', myTextFont);
%text(deltaX  + x, y, '______', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-h', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', blue, 'linewidth', 2);
text(deltaX  + x, y, 'PEG', 'Color', blue, 'FontSize', myTextFont);
%text(deltaX  + x, y, '____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-^', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', green, 'linewidth', 2);
text(deltaX  + x, y, 'pHEMA', 'Color', green, 'FontSize', myTextFont);
%text(deltaX  + x, y, '_______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-s', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', purple, 'linewidth', 2);
text(deltaX  + x, y, 'pHEMA/coAc', 'Color', purple, 'FontSize', myTextFont);
%text(deltaX  + x, y, '___________', 'Color', purple, 'FontSize', myTextFont);

% Set myTitle based on the chosen parameters
switch newGels
    case 0 % use aged gels
        switch peakSet
            case 1 % pH-sensitive peaks
                switch dataset
                    case 1
                        myTitle = 'Figure 4a beg of June 2020';
                    case 2
                        myTitle = 'Figure 4a end of June 2020';
                end
            case 2 % reference peaks
                switch dataset
                    case 1
                        myTitle = 'Figure S13a beg of June 2020';
                    case 2
                        myTitle = 'Figure S13a end of June 2020';
                end
        end
    case 1 % use new gels
        switch peakSet
            case 1 % pH-sensitive peaks
                myTitle = 'Figure 3a';
            case 2
                myTitle = 'Figure S13a';
        end
end
saveMyPlot(FigH, myTitle);

FigH = figure('Position', get(0, 'Screensize')); 
       % Figure #8: put the avg of the punches of all of the gels' x2
       % curves on one plot, with or without norm'n (depends on xRef)
       % 2021/02/18 This is JBO figure 4b
for J = 1:4
    switch J
        case 1         
            plot(allX, myAlgY2AllPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myAlgY2AllPunches, myAlgY2AllPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
        case 2
            plot(allX, myPEGY2AllPunches, '-h', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myPEGY2AllPunches, myPEGY2AllPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;        
        case 3
            plot(allX, myHEMAY2AllPunches, '-^', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myHEMAY2AllPunches, myHEMAY2AllPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
        case 4
            plot(allX, myHEMACoY2AllPunches, '-s', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myHEMACoY2AllPunches, myHEMACoY2AllPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
    end 
end

switch peakSet
    case 1
        % JB01:
        % 7/16/2020 only say "normalized" when xRef ~= 0
        if (xRef ~= 0) 
            % 2021/02/18 out for final JBO version
            % title('1702 cm^-^1 normalized peak average and std dev of all punches of all gels', 'FontSize', myTextFont)
            %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
            ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
        else
            title('1702 cm^-^1 peak average and std dev of all punches of all gels', 'FontSize', myTextFont)
            ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont);
        end
    case 2
        % JB02:
        % 7/16/2020 only say "normalized" when xRef ~= 0
        if (xRef ~= 0) 
            % 2021/02/18 out for final JBO version
            % title('1582 cm^-^1 normalized peak average and std dev of all punches of all gels', 'FontSize', myTextFont)
            %ylabel({'Normalized intensity'; '(a.u.)'}, 'FontSize', myTextFont);
            ylabel('Normalized intensity (a.u.)', 'FontSize', myTextFont);
        else
            title('1582 cm^-^1 peak average and std dev of all punches of all gels', 'FontSize', myTextFont)
            ylabel({'Raw intensity'; '(a.u.)'}, 'FontSize', myTextFont);
        end
end

xlabel('pH', 'FontSize', myTextFont); % x-axis label
%set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
set(gca,'FontSize',myTextFont,'box','off'); % 2021/02/18 rm bold

% 2020/07/16 New, automatic sizing. 
% 2021/02/19 There is a problem. When Y2 vals
% are actually lower than Y1, then this cuts them off.
% 2021/02/19 Fix the range for both 1430 and 1702 plots
xlim([minX-0.5 maxX+0.5]);
max1 = max(maxY1);
max2 = max(maxY2);
maxOverall = max(max1, max2);
min1 = min(minY1);
min2 = min(minY2);
minOverall = min(min1, min2);
if (minOverall > maxOverall)  
    ylim([(0.99*maxOverall) (1.01*minOverall)]);
else
    ylim([(0.99*minOverall) (1.01*maxOverall)]);
end
y = 0.95 * (maxOverall - minOverall) + minOverall;
deltaY = 0.1 * (maxOverall - minOverall);

switch peakSet % the shape of the curve is different ...
    case 1
        x = 0.8 * (maxX + 0.5); % ... for the 1430 pk
    case 2
        x = minX; % ... and the 1072 ref pk
end

deltaX = 0.1;

plot(x, y, '-o', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', red, 'linewidth', 2);
text(x + deltaX, y, 'alginate', 'Color', red, 'FontSize', myTextFont);
%text(x + deltaX, y, '______', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-h', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', blue, 'linewidth', 2);
text(x + deltaX, y, 'PEG', 'Color', blue, 'FontSize', myTextFont);
%text(x + deltaX, y, '____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-^', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', green, 'linewidth', 2);
text(x + deltaX, y, 'pHEMA', 'Color', green, 'FontSize', myTextFont);
%text(x + deltaX, y, '_______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
plot(x, y, '-s', 'LineStyle','none', ...
    'MarkerSize', 30, 'Color', purple, 'linewidth', 2);
text(x + deltaX, y, 'pHEMA/coAc', 'Color', purple, 'FontSize', myTextFont);
%text(x + deltaX, y, '___________', 'Color', purple, 'FontSize', myTextFont);

% Set myTitle based on the chosen parameters
switch newGels
    case 0
        switch peakSet % the shape of the curve is different ...
            case 1
                x = 0.8 * (maxX + 0.5); % ... for the 1430 pk
                switch dataset
                    case 1
                        myTitle = 'Figure 4b beg of June 2020';
                    case 2
                        myTitle = 'Figure 4b end of June 2020'; 
                end  
            case 2
                x = minX; % ... and the 1072 ref pk
                switch dataset
                    case 1
                        myTitle = 'Figure S13b beg of June 2020';
                    case 2
                        myTitle = 'Figure S13b end of June 2020'; 
                end
        end
   
    case 1
        switch peakSet
            case 1 % pH-sensitive peaks
                myTitle = 'Figure 3b';
            case 2
                myTitle = 'Figure S13b';
        end
end
saveMyPlot(FigH, myTitle);

% Figures are done. Now finish off calculating the values for the table.
% Extract min, max and delta from the arrays of averaged values of all
% punches. Put these values in an additional row of the matrix created 
% for the individual punches
for J = 1:4
    % Now for the table of values for gel comparison
    % get min, max, delta and %delta 
    switch J % fill the correct array based on the type of gel
        case 1
            myAlgY1Min(maxM+1) = min(myAlgY1AllPunches);
            myAlgY1Max(maxM+1) = max(myAlgY1AllPunches);
            myAlgY1Delta(maxM+1) = myAlgY1Max(maxM+1) - myAlgY1Min(maxM+1);
            myAlgY1PercentDelta(maxM+1) = myAlgY1Delta(maxM+1)/myAlgY1Min(maxM+1)*100.;
            myAlgY2Min(maxM+1) = min(myAlgY2AllPunches);
            myAlgY2Max(maxM+1) = max(myAlgY2AllPunches);
            myAlgY2Delta(maxM+1) = myAlgY2Max(maxM+1) - myAlgY2Min(maxM+1);
            myAlgY2PercentDelta(maxM+1) = myAlgY2Delta(maxM+1)/myAlgY2Min(maxM+1)*100.;
        case 2
            myPEGY1Min(maxM+1) = min(myPEGY1AllPunches);  
            myPEGY1Max(maxM+1) = max(myPEGY1AllPunches);
            myPEGY1Delta(maxM+1) = myPEGY1Max(maxM+1) - myPEGY1Min(maxM+1);
            myPEGY1PercentDelta(maxM+1) = myPEGY1Delta(maxM+1)/myPEGY1Min(maxM+1)*100.;
            myPEGY2Min(maxM+1) = min(myPEGY2AllPunches); 
            myPEGY2Max(maxM+1) = max(myPEGY2AllPunches);
            myPEGY2Delta(maxM+1) = myPEGY2Max(maxM+1) - myPEGY2Min(maxM+1);
            myPEGY2PercentDelta(maxM+1) = myPEGY2Delta(maxM+1)/myPEGY2Min(maxM+1)*100.;
        case 3                
            myHEMAY1Min(maxM+1) = min(myHEMAY1AllPunches);
            myHEMAY1Max(maxM+1) = max(myHEMAY1AllPunches);
            myHEMAY1Delta(maxM+1) = myHEMAY1Max(maxM+1) - myHEMAY1Min(maxM+1);
            myHEMAY1PercentDelta(maxM+1) = myHEMAY1Delta(maxM+1)/myHEMAY1Min(maxM+1)*100.;
            myHEMAY2Min(maxM+1) = min(myHEMAY2AllPunches);  
            myHEMAY2Max(maxM+1) = max(myHEMAY2AllPunches);
            myHEMAY2Delta(maxM+1) = myHEMAY2Max(maxM+1) - myHEMAY2Min(maxM+1);
            myHEMAY2PercentDelta(maxM+1) = myHEMAY2Delta(maxM+1)/myHEMAY2Min(maxM+1)*100.;        
        case 4
            myHEMACoY1Min(maxM+1) = min(myHEMACoY1AllPunches);   
            myHEMACoY1Max(maxM+1) = max(myHEMACoY1AllPunches);
            myHEMACoY1Delta(maxM+1) = myHEMACoY1Max(maxM+1) - myHEMACoY1Min(maxM+1);
            myHEMACoY1PercentDelta(maxM+1) = myHEMACoY1Delta(maxM+1)/myHEMACoY1Min(maxM+1)*100.;
            myHEMACoY2Min(maxM+1) = min(myHEMACoY2AllPunches);
            myHEMACoY2Max(maxM+1) = max(myHEMACoY2AllPunches);
            myHEMACoY2Delta(maxM+1) = myHEMACoY2Max(maxM+1) - myHEMACoY2Min(maxM+1);
            myHEMACoY2PercentDelta(maxM+1) = myHEMACoY2Delta(maxM+1)/myHEMACoY2Min(maxM+1)*100.;
    end
end

for M=1:maxM+1
    fprintf('Alg Y1 %.3f %.3f %.3f %.3f\n', myAlgY1Min(M), myAlgY1Max(M), myAlgY1Delta(M), myAlgY1PercentDelta(M));
end
for M=1:maxM+1
    fprintf('Alg Y2 %.3f %.3f %.3f %.3f\n', myAlgY2Min(M), myAlgY2Max(M), myAlgY2Delta(M), myAlgY2PercentDelta(M));
end
for M=1:maxM+1
    fprintf('PEG Y1 %.3f %.3f %.3f %.3f\n', myPEGY1Min(M), myPEGY1Max(M), myPEGY1Delta(M), myPEGY1PercentDelta(M));
end
for M=1:maxM+1
    fprintf('PEG Y2 %.3f %.3f %.3f %.3f\n', myPEGY2Min(M), myPEGY2Max(M), myPEGY2Delta(M), myPEGY2PercentDelta(M));
end
for M=1:maxM+1
    fprintf('pHEMA Y1 %.3f %.3f %.3f %.3f\n', myHEMAY1Min(M), myHEMAY1Max(M), myHEMAY1Delta(M), myHEMAY1PercentDelta(M));
end
for M=1:maxM+1
    fprintf('pHEMA Y2 %.3f %.3f %.3f %.3f\n', myHEMAY2Min(M), myHEMAY2Max(M), myHEMAY2Delta(M), myHEMAY2PercentDelta(M));
end
for M=1:maxM+1
    fprintf('pHEMACo Y1 %.3f %.3f %.3f %.3f\n', myHEMACoY1Min(M), myHEMACoY1Max(M), myHEMACoY1Delta(M), myHEMACoY1PercentDelta(M));
end
for M=1:maxM+1
    fprintf('pHEMACo Y2 %.3f %.3f %.3f %.3f\n', myHEMACoY2Min(M), myHEMACoY2Max(M), myHEMACoY2Delta(M), myHEMACoY2PercentDelta(M));
end

% 2021/02/16 NEW adding this just as was done to JB07
% save the arrays of averages and standard devs
% for all gel types, J, so that plotSteadyandDynStatesJB05 
% can read these values in
printMyData();
saveMyData();

% end of main program

function d = getAreaUnderCurve(xCenter, spectrum)
    global numPointsEachSide;
    global numPoints;
    global myDebug;
    % use x as the x-value of the center point of the peak
    % sum the points from x=(xCenter - numPointsIntegrated) to 
    % x=(xCenter + numPointsIntegrated) and then divide by number of
    % points to average and scale it.
    
    if myDebug 
        fprintf('getAreaUnderCurve with numPointsEachSide=%d centered at %d\n', ...
            numPointsEachSide, xCenter);
    end
    
    % check that numPointsIntegrated is in range
    lowEnd = xCenter - numPointsEachSide;
    if (lowEnd < 1) 
        fprintf('low end of number of points integrated is out of range');
    end
    highEnd = xCenter + numPointsEachSide;
    if (highEnd > numPoints)
        fprintf('high end of number of points integrated is out of range');
    end
    
    sum = 0;

    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(lowEnd + i - 1);
        if myDebug
            fprintf('index: %d, spectrum: %g\n', i, spectrum(lowEnd + i - 1));
        end
    end
    averageHeight = sum/numPointsToIntegrate; % HERE IS THE SCALING
    if myDebug
        fprintf('average height of all points around ref: %g\n', averageHeight);
    end
    d = averageHeight;
end

function [e f] = correctBaseline(tics)
    lambda=1e4; % smoothing parameter
    p=0.001; % asymmetry parameter
    d=2;
    % asym: Baseline estimation with asymmetric least squares using weighted
    % smoothing with a finite difference penalty.
    %   signals: signal, each column represents one signal
    %   lambda: smoothing parameter (generally 1e5 to 1e8)
    %   p: asymmetry parameter (generally 0.001)
    %   d: order of differences in penalty (generally 2)
    temp_tic=asysm(tics,lambda,p,d);
    trend=temp_tic';
    modified=tics(:)-temp_tic(:);
    e = trend;
    f = modified';
end   

function [a, b, c, d, e, f, g] = prepPlotData(J, subDirStem, K, myColor, M)
    global blue
    global rust
    global gold
    global purple
    global green
    global ciel
    global cherry
    global red
    global black
    global dirStem
    global numPoints
    global x1
    global x2
    global xRef
    global tRef
    global xMin
    global xMax
    global yMin
    global yMax
    global myDebug
    global lineThickness
    global numPointsEachSide
    global pH
    global peakSet
    global numeratorType
    
    if myDebug 
        fprintf('reset sums\n');
    end
    sum1 = 0;
    sum2 = 0;
    sumSq1 = 0;
    sumSq2 = 0;
    thisdata = zeros(2, numPoints, 'double');   
%     str_dir_to_search = dirStem + subDirStem; % args need to be strings
%     dir_to_search = char(str_dir_to_search);
    dir_to_search = dirStem(J) + subDirStem; % this seems to work in 2019
    txtpattern = fullfile(dir_to_search, 'avg*.txt'); % this looks fine
    dinfo = dir(txtpattern);
    if myDebug 
        fprintf('first pass\n');
    end
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            fprintf('Parsing %s\n', thisfilename);
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            if myDebug 
                fprintf('process %s\n', thisfilename);
            end
            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');  
            
            % 1.5 Only consider a narrow band of the spectrum
            switch numeratorType
                case 1
                    numerator1 = getAreaUnderCurve(x1, f(:));
                    numerator2 = getAreaUnderCurve(x2, f(:));
                case 2
                    % 20210405 matching how plotAssortedFilesRatioCalibrationOldGels.m works
                    numerator1 = f(x1);
                    numerator2 = f(x2);
            end
            
            % 2. Ratiometric
            % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
            % on either side of refWaveNumber. This maps to: 1 - 11 total
            % intensities used to calculate the denominator.
            if (xRef ~= 0) 
                denominator = getAreaUnderCurve(xRef, f(:));
            else
                denominator = 1;
            end
            if myDebug
                fprintf('gel%d: pH%d pk:%d denominator = %g at index: %d\n', J, K, M, denominator, xRef);
            end

            % 3. NEW 10/4/18: Normalize what is plotted
            switch peakSet
                case 1
                    normalized1 = numerator1/denominator;
                    normalized2 = numerator2/denominator;
                case 2 
                    normalized1 = numerator1/numerator2;
                    normalized2 = numerator2/numerator1;
            end
            
            sum1 = sum1 + normalized1;
            sum2 = sum2 + normalized2;
        end
        
        % calculate average
        avg1 = sum1/numberOfSpectra;
        avg2 = sum2/numberOfSpectra;
        if myDebug 
            fprintf('avgs based on %d spectra\n', numberOfSpectra);
        end
        
        % second pass on dataset to get (each point - average)^2
        % for standard deviation, need 
        if myDebug 
            fprintf('second pass\n');
        end
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);
            if myDebug 
                fprintf('process %s\n', thisfilename);
            end
            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');  
            
            % 1.5 Only consider a narrow band of the spectrum
            switch numeratorType
                case 1
                    numerator1 = getAreaUnderCurve(x1, f(:));
                    numerator2 = getAreaUnderCurve(x2, f(:));
                case 2
                    % 20210405 matching how plotAssortedFilesRatioCalibrationOldGels.m works
                    numerator1 = f(x1);
                    numerator2 = f(x2);
            end
            
            % 2. Ratiometric
            % NEW 10/4/18: Calculate the denominator using a window of 0 - 5 points
            % on either side of refWaveNumber. This maps to: 1 - 11 total
            % intensities used to calculate the denominator.
            if (xRef ~= 0) 
                denominator = getAreaUnderCurve(xRef, f(:));
            else
                denominator = 1;
            end
            if myDebug
                fprintf('gel%d: pH%d pk:%d denominator = %g at index: %d\n', J, K, M, denominator, xRef);
            end

            % 3. Normalize what is plotted
            switch peakSet
                case 1
                    normalized1 = numerator1/denominator;
                    normalized2 = numerator2/denominator;
                case 2 
                    normalized1 = numerator1/numerator2;
                    normalized2 = numerator2/numerator1;
            end
            
            % 4. Add to the sum of the squares
            sumSq1 = sumSq1 + (normalized1 - avg1).^2; 
            sumSq2 = sumSq2 + (normalized2 - avg2).^2; 
        end
        
        % 5. Compute standard deviation at each index of the averaged spectra 
        stdDev1 = sqrt(sumSq1/numberOfSpectra);
        stdDev2 = sqrt(sumSq2/numberOfSpectra);
        if myDebug 
            fprintf('std dev based on %d spectra\n', numberOfSpectra);
        end
                
        a = pH(K);
        b = normalized1;
        c = stdDev1;
        d = normalized2;
        e = stdDev2;
        f = numberOfSpectra;
        g = denominator;

        fprintf...
            ('Gel%d Case %d: results for %s: N=%d %f %f %f %f\n', ...
            J, K, subDirStem, f, b, c, d, e);
        
        % part 1: do the 1430 cm-1 plot 6/30/2020: don't color based on
        % 'K'. Color based on punch number.
        plot(a, b, '-o', 'LineStyle','none', 'MarkerSize', ...
            30, 'Color', myColor, 'linewidth', 2);
        hold on
        % https://blogs.mathworks.com/pick/2017/10/13/labeling-data-points/
        %labelpoints(myX(K), myY1(K), labels(M),'SE',0.2,1)
        %hold on
        errorbar(a, b, c, 'LineStyle','none', ...
            'Color', black, 'linewidth', 2);
        hold on

        % part 2: do the 1702 cm-1 plot
        plot(a, d, '-s', 'LineStyle','none', 'MarkerSize', ...
            30, 'Color', myColor, 'linewidth', 2); 
        hold on
        errorbar(a, d, e, 'LineStyle','none', ...
            'Color', black,'linewidth', 2);
        hold on
        
    end
end

function h = getAverageAndStdDev(dataPoints)
        %Pass in array of points
        myN = length(dataPoints); % 2021/03/05 FOUND STH. This is 5 for alg but 8 for PEG
        mySum = 0;
        mySumSq = 0;
        for I = 1 : myN
            mySum = mySum + dataPoints(I);
        end
        % calculate average
        myAvg = mySum/myN;
        
        % second pass on dataset to get (each point - average)^2
        % for standard deviation, need 
        for I = 1 : myN
            % 4. Add to the sum of the squares
            mySumSq = mySumSq + (dataPoints(I) - myAvg).^2; 
        end
        
        % 5. Compute standard deviation at each index of the averaged spectra 
        myStdDev = sqrt(mySumSq/myN);

        h = [ myAvg, myStdDev ];
end

function j = saveMyData()
    % 2021/02/16 NEW adding this just as was done to JB07
    % save the arrays of averages and standard devs
    % for all gel types, J, so that plotSteadyandDynStatesJB05 
    % can read these values in
    global myAlgY1AllPunches
    global myAlgY1AllPunchesStdDev
    global myAlgY2AllPunches
    global myAlgY2AllPunchesStdDev
    global myPEGY1AllPunches
    global myPEGY1AllPunchesStdDev
    global myPEGY2AllPunches
    global myPEGY2AllPunchesStdDev
    global myHEMAY1AllPunches
    global myHEMAY1AllPunchesStdDev
    global myHEMAY2AllPunches
    global myHEMAY2AllPunchesStdDev
    global myHEMACoY1AllPunches
    global myHEMACoY1AllPunchesStdDev
    global myHEMACoY2AllPunches
    global myHEMACoY2AllPunchesStdDev
    
    dirStem = '../Data/'; % save .mat files to the repo
    for ii = 1:16
        switch ii
            case 1
                myArray = myAlgY1AllPunches;
                myVariable = 'myAlgY1AllPunches';
            case 2
                myArray = myAlgY1AllPunchesStdDev;
                myVariable = 'myAlgY1AllPunchesStdDev';
            case 3
                myArray = myAlgY2AllPunches;
                myVariable = 'myAlgY2AllPunches';
            case 4
                myArray = myAlgY2AllPunchesStdDev;
                myVariable = 'myAlgY2AllPunchesStdDev';
            case 5
                myArray = myPEGY1AllPunches;
                myVariable = 'myPEGY1AllPunches';
            case 6
                myArray = myPEGY1AllPunchesStdDev;
                myVariable = 'myPEGY1AllPunchesStdDev';
            case 7
                myArray = myPEGY2AllPunches;
                myVariable = 'myPEGY2AllPunches';
            case 8
                myArray = myPEGY2AllPunchesStdDev;
                myVariable = 'myPEGY2AllPunchesStdDev';
            case 9
                myArray = myHEMAY1AllPunches;
                myVariable = 'myHEMAY1AllPunches';
            case 10
                myArray = myHEMAY1AllPunchesStdDev;
                myVariable = 'myHEMAY1AllPunchesStdDev';
            case 11
                myArray = myHEMAY2AllPunches;
                myVariable = 'myHEMAY2AllPunches';
            case 12
                myArray = myHEMAY2AllPunchesStdDev;
                myVariable = 'myHEMAY2AllPunchesStdDev';
            case 13
                myArray = myHEMACoY1AllPunches;
                myVariable = 'myHEMACoY1AllPunches';
            case 14
                myArray = myHEMACoY1AllPunchesStdDev;
                myVariable = 'myHEMACoY1AllPunchesStdDev';
            case 15
                myArray = myHEMACoY2AllPunches;
                myVariable = 'myHEMACoY2AllPunches';
            case 16
                myArray = myHEMACoY2AllPunchesStdDev; 
                myVariable = 'myHEMACoY2AllPunchesStdDev';
        end    
        myFilename = sprintf('%s%sAvgs.mat', dirStem, myVariable);
        save(myFilename, myVariable);
    end
    j = 1;
end

% 2021/02/16 for comparison to output of JB07
function k = printMyData()
global myAlgY1AllPunches
global myAlgY1AllPunchesStdDev
global myAlgY2AllPunches
global myAlgY2AllPunchesStdDev
global myAlgNum
global myPEGY1AllPunches
global myPEGY1AllPunchesStdDev
global myPEGY2AllPunches
global myPEGY2AllPunchesStdDev
global myPEGNum
global myHEMAY1AllPunches
global myHEMAY1AllPunchesStdDev
global myHEMAY2AllPunches
global myHEMAY2AllPunchesStdDev
global myHEMANum
global myHEMACoY1AllPunches
global myHEMACoY1AllPunchesStdDev
global myHEMACoY2AllPunches
global myHEMACoY2AllPunchesStdDev
global myHEMACoNum
pH = [ 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5 ];

    for peak = 1:2
        for J = 1:4
            for K = 1:8
                % use a switch to set the Y1, Err1, Y2, Err2 arrays
                % so that printing done for all via the same statement
                switch J
                    % 2021/3/5 I SEE IT. THESE S/B allPunches, not all
                    case 1
                        myY1(K) = myAlgY1AllPunches(K);
                        myErr1(K) = myAlgY1AllPunchesStdDev(K);
                        myY2(K) = myAlgY2AllPunches(K);
                        myErr2(K) = myAlgY2AllPunchesStdDev(K);
                        numberOfSpectraAllPunches = myAlgNum(K);
                    case 2
                        myY1(K) = myPEGY1AllPunches(K);
                        myErr1(K) = myPEGY1AllPunchesStdDev(K);
                        myY2(K) = myPEGY2AllPunches(K);
                        myErr2(K) = myPEGY2AllPunchesStdDev(K);
                        numberOfSpectraAllPunches = myPEGNum(K);
                    case 3
                        myY1(K) = myHEMAY1AllPunches(K);
                        myErr1(K) = myHEMAY1AllPunchesStdDev(K);
                        myY2(K) = myHEMAY2AllPunches(K);
                        myErr2(K) = myHEMAY2AllPunchesStdDev(K);
                        numberOfSpectraAllPunches = myHEMANum(K);
                    case 4
                        myY1(K) = myHEMACoY1AllPunches(K);
                        myErr1(K) = myHEMACoY1AllPunchesStdDev(K);
                        myY2(K) = myHEMACoY2AllPunches(K);
                        myErr2(K) = myHEMACoY2AllPunchesStdDev(K);
                        numberOfSpectraAllPunches = myHEMACoNum(K);
                end        

                % This matches JB07 output fmt
                switch peak
                    case 1
                        fprintf('gel%d: pH%f: pk:1430 N=%d avg=%f stddev=%f\n', ...
                           J, pH(K), numberOfSpectraAllPunches, myY1(K), myErr1(K));
                        %fprintf('%f\n', myErr1(K));

                    case 2
                        fprintf('gel%d: pH%f: pk:1702 N=%d avg=%f stddev=%f\n', ...
                            J, pH(K), numberOfSpectraAllPunches, myY2(K), myErr2(K)); 
                        %fprintf('%f\n', myErr2(K));
                end
            end
        end
    end
    k = 1;
end

function g = saveMyPlot(FigH, myTitle)
global plotOption
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlotName = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlotName, 'png');
    g = 1;
end
  