% Plot pH vs intensity using the calibration curve study data as input.
% Details:
% Get points from files in different directories. 
% Go after just the pH-sensitive part of the spectra.
% Q: How wide is the bandwidth of the area under the curve?
% A: Match it to the range of the BP filters used by the Raman reader.
% Calculate the std dev for each point based on the set of 5 avg*.txt files
% (which are already averages of 5 themselves) and use stddev for error bars
% First, make plots for each of the gels (#17, 18, 19,20) made 6/3/2020
% Dayle Kotturi June 2020, time of COVID

% Colors:
global black;
global purple;
global blue;
global ciel;
global green;
global rust;
global gold;
global red;
global cherry;
global magenta;

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

global myX
global myY1
global myY2
global myErr1
global myErr2

% The paths to each hydrogel type and gel number
% This script deals with the four gels made on 6/3/2020 by SP
global dirStem

newGels = 1; % set to 0 to use old gels and 1 to use new gels
if newGels 
    dirStem = [ ...
        "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 17\", ...
        "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 18\", ...
        "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 19\", ...
        "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 20\" ...
        ];
    myTitle = [ ...
        "54nm MBA AuNPs in alginate gel#17 in static buffer for 1 hour", ...
        "54nm MBA AuNPs in PEG gel#18 in static buffer for 1 hour", ...
        "54nm MBA AuNPs in pHEMA gel#19 in static buffer for 1 hour", ...
        "54nm MBA AuNPs in pHEMA/coAc gel#20 in static buffer for 1 hour" ...
        ];
else
    dirStem = [ ...
        "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\", ...
        "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 16\", ...
        "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\", ...
        "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\" ...
        ];
    myTitle = [ ...
        "54nm MBA AuNPs in alginate gel#12 in static buffer for 1 hour", ...
        "54nm MBA AuNPs in PEG gel#16 in static buffer for 1 hour", ...
        "54nm MBA AuNPs in pHEMA gel#13 in static buffer for 1 hour", ...
        "54nm MBA AuNPs in pHEMA/coAc gel#14 in static buffer for 1 hour" ...
        ];
end
subDirStem = [ ...
    "pH4 punch", "pH4.5 punch", "pH5 punch", ...
    "pH5.5 punch", "pH6 punch", "pH6.5 punch", ...
    "pH7 punch", "pH7.5 punch" ...
    ];

% global labels
% labels = {'1','2','3','4','5'};

global lineThickness;
lineThickness = 2;
global numPoints;
numPoints = 1024;
global numPointsEachSide;
numPointsEachSide = 2;

% % Use the index 713 to get the intensity at the reference peak, is COO-
% at 1582/cm. Note that the numPointsEachSide is used to take the area 
% under the curve around the center point xRef
global xRef;
xRef = 713; 
% Use the index 614 to get the intensity at 1430/cm (act. 1428.58/cm)
global x1;
x1 = 614;
% Use the index 794 to get the intensity at 1702/cm (act. 1701.95/cm)
global x2;
x2 = 794;

global xMin;
global xMax;
global yMin;
global yMax;
xMin = 950;
xMax = 1800;
yMin = 0;
yMax = 20.0;
myTextFont = 30;

global myDebug;
myDebug = 0;

for J=1:4
    myX = zeros(1, 8, 'double');
    myY1 = zeros(1, 8, 'double');
    myY2 = zeros(1, 8, 'double');
    myErr1 = zeros(1, 8, 'double');
    myErr2 = zeros(1, 8, 'double'); 
    
    figure % one plot for each gel
    
    if newGels 
        maxM = 5; % all punches 1-5 of new gels
    else
        maxM = 1; % 1a of old gels
    end
    
    for M =1:maxM 
        for K = 1:8 % all pH levels 4, 4.5, ..., 7.5
            if newGels
                subDirWithPunch = subDirStem(K) + M + "\1";
                numSpectra(K) = prepPlotData(J, subDirWithPunch, K, ...
                    punchColor(M,:), M);
            else
                subDirWithPunch = subDirStem(K) + "1a" + "\1";
                numSpectra(K) = prepPlotData(J, subDirWithPunch, K, ...
                    punchColor(6,:), M);
            end
            fprintf('Case %d: %d spectra\n', K, numSpectra(K));    
        end 

        % store these arrays to be able to make a combined plot for all
        % gels later
        if J == 1 && M == 1
            allX = myX; % Use the same set of x values for all gels
        end
        
        switch J
            case 1
                if M == 1
                    allAlgY1 = myY1; % Put the first gel's values into a row
                    allAlgErr1 = myErr1;
                    allAlgY2 = myY2;
                    allAlgErr2 = myErr2;
                else
                    allAlgY1 = [allAlgY1; myY1]; % Append the other gels' in subsequent rows
                    allAlgErr1 = [allAlgErr1; myErr1];
                    allAlgY2 = [allAlgY2; myY2];
                    allAlgErr2 = [allAlgErr2; myErr2];
                end
            case 2
                if M == 1
                    allPEGY1 = myY1; % Put the first gel's values into a row
                    allPEGErr1 = myErr1;
                    allPEGY2 = myY2;
                    allPEGErr2 = myErr2;
                else
                    allPEGY1 = [allPEGY1; myY1]; % Append the other gels' in subsequent rows
                    allPEGErr1 = [allPEGErr1; myErr1];
                    allPEGY2 = [allPEGY2; myY2];
                    allPEGErr2 = [allPEGErr2; myErr2];
                end
            case 3
                if M == 1
                    allHEMAY1 = myY1; % Put the first gel's values into a row
                    allHEMAErr1 = myErr1;
                    allHEMAY2 = myY2;
                    allHEMAErr2 = myErr2;
                else
                    allHEMAY1 = [allHEMAY1; myY1]; % Append the other gels' in subsequent rows
                    allHEMAErr1 = [allHEMAErr1; myErr1];
                    allHEMAY2 = [allHEMAY2; myY2];
                    allHEMAErr2 = [allHEMAErr2; myErr2];
                end
            case 4
                if M == 1
                    allHEMACoY1 = myY1; % Put the first gel's values into a row
                    allHEMACoErr1 = myErr1;
                    allHEMACoY2 = myY2;
                    allHEMACoErr2 = myErr2;
                else
                    allHEMACoY1 = [allHEMACoY1; myY1]; % Append the other gels' in subsequent rows
                    allHEMACoErr1 = [allHEMACoErr1; myErr1];
                    allHEMACoY2 = [allHEMACoY2; myY2];
                    allHEMACoErr2 = [allHEMACoErr2; myErr2];
                end
        end
    
        % Now for the table of values for gel comparison
        % get min, max, delta and %delta 
        switch J % fill the correct array based on the type of gel
            case 1
                myAlgY1Min(M) = min(allAlgY1(M,:));    
                myAlgY1Max(M) = max(allAlgY1(M,:));
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

    title(myTitle(J), 'FontSize', myTextFont);
    xlabel('pH', 'FontSize', myTextFont); % x-axis label
    ylabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
    set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
    y = 0.19; 
    x = 3.6;
    deltaY = 0.01;
    text(x, y, 'circles = 1430 cm^-1 peak', 'Color', black, 'FontSize', myTextFont);
    text(x, y, '_____', 'Color', black, 'FontSize', myTextFont);
    y = y - deltaY;
    text(x, y, 'squares = 1702 cm^-1 peak', 'Color', black, 'FontSize', myTextFont);
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

% New, per 6/19 MJM comments
% 7/1 TO DO: combine the punches
figure % Put all of the 1430/cm curves on one plot

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
                plot(allX, allPEGY1(M,:), '-o', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allPEGY1(M,:), allPEGErr1(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 3
            for M = 1:maxM
                plot(allX, allHEMAY1(M,:), '-o', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allHEMAY1(M,:), allHEMAErr1(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 4
            for M = 1:maxM
                plot(allX, allHEMACoY1(M,:), '-o', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allHEMACoY1(M,:), allHEMACoErr1(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
    end
end

title('1430 cm-1 normalized peak for all punches of all gels', 'FontSize', myTextFont);
xlabel('pH', 'FontSize', myTextFont); % x-axis label
ylabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
xlim([3.5 8]);
ylim([0. 0.25]);
y = 0.25; 
x = 4.1;
deltaY = 0.02;
text(x, y, 'alginate', 'Color', red, 'FontSize', myTextFont);
text(x, y, '______', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'PEG', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pHEMA', 'Color', green, 'FontSize', myTextFont);
text(x, y, '_______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pHEMA/coAc', 'Color', purple, 'FontSize', myTextFont);
text(x, y, '___________', 'Color', purple, 'FontSize', myTextFont);

% 7/1 TO DO: combine the punches
figure % Put all of the 170%2/cm curves on one plot
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
                plot(allX, allPEGY2(M,:), '-o', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allPEGY2(M,:), allPEGErr2(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 3
            for M = 1:maxM
                plot(allX, allHEMAY2(M,:), '-o', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allHEMAY2(M,:), allHEMAErr2(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
        case 4
            for M = 1:maxM
                plot(allX, allHEMACoY2(M,:), '-o', 'LineStyle','none', ...
                    'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
                hold on;
                errorbar(allX, allHEMACoY2(M,:), allHEMACoErr2(M,:), 'LineStyle','none', ...
                    'Color', black,'linewidth', 2);
                hold on;
            end
    end
end

title('1702 cm-1 normalized peak for all punches of all gels', 'FontSize', myTextFont);
xlabel('pH', 'FontSize', myTextFont); % x-axis label
ylabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
xlim([3.5 8]);
ylim([0. 0.25]);
y = 0.2; 
x = 6.5;
deltaY = 0.015;
text(x, y, 'alginate', 'Color', red, 'FontSize', myTextFont);
text(x, y, '______', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'PEG', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pHEMA', 'Color', green, 'FontSize', myTextFont);
text(x, y, '_______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pHEMA/coAc', 'Color', purple, 'FontSize', myTextFont);
text(x, y, '___________', 'Color', purple, 'FontSize', myTextFont);

% From this point on, condense the data for all punches down to average
% and std dev for each gel type
% Compute the average and std dev of the punches of each gel
% This is only meaningful when number of punches > 1
% As written, this std dev is ignoring the variance in the 5 averaged msmts
% Want to plot these with err bars
%fprintf('Averages and Std Dev over all punches at each pH: 4, 4.5, ..., 7.5\n');
for K = 1:8
    a = getAverageAndStdDev(allAlgY1(:,K));
    myAlgY1allPunches(K) = a(1);
    myAlgY1allPunchesStdDev(K) = a(2);
    fprintf('pH(%d) alg 1430/cm %.3f %.3f\n', K, myAlgY1allPunches(K), myAlgY1allPunchesStdDev(K));
        
    a = getAverageAndStdDev(allAlgY2(:,K));
    myAlgY2allPunches(K) = a(1);
    myAlgY2allPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) alg 1702/cm %.3f %.3f\n', K, myAlgY2allPunches(K), myAlgY2allPunchesStdDev(K));
    
    a = getAverageAndStdDev(allPEGY1(:,K));
    myPEGY1allPunches(K) = a(1);
    myPEGY1allPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) peg 1430/cm %.3f %.3f\n', K, myPEGY1allPunches(K), myPEGY1allPunchesStdDev(K));
        
    a = getAverageAndStdDev(allPEGY2(:,K));
    myPEGY2allPunches(K) = a(1);
    myPEGY2allPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) peg 1702/cm %.3f %.3f\n', K, myPEGY2allPunches(K), myPEGY2allPunchesStdDev(K));
    
    a = getAverageAndStdDev(allHEMAY1(:,K));
    myHEMAY1allPunches(K) = a(1);
    myHEMAY1allPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) pHE 1430/cm %.3f %.3f\n', K, myHEMAY1allPunches(K), myHEMAY1allPunchesStdDev(K));
        
    a = getAverageAndStdDev(allHEMAY2(:,K));
    myHEMAY2allPunches(K) = a(1);
    myHEMAY2allPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) pHE 1702/cm %.3f %.3f\n', K, myHEMAY2allPunches(K), myHEMAY2allPunchesStdDev(K));
    
    a = getAverageAndStdDev(allHEMACoY1(:,K));
    myHEMACoY1allPunches(K) = a(1);
    myHEMACoY1allPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) pHC 1430/cm %.3f %.3f\n', K, myHEMACoY1allPunches(K), myHEMACoY1allPunchesStdDev(K));
        
    a = getAverageAndStdDev(allHEMACoY2(:,K));
    myHEMACoY2allPunches(K) = a(1);
    myHEMACoY2allPunchesStdDev(K) = a(2);
    %fprintf('pH(%d) pHC 1702/cm %.3f %.3f\n', K, myHEMACoY2allPunches(K), myHEMACoY2allPunchesStdDev(K));
end

fprintf('Averages and Std Dev over all punches at each pH: 4, 4.5, ..., 7.5\n');
sumVarAlgPk1 = 0;
sumVarPegPk1 = 0;
sumVarpHEPk1 = 0;
sumVarpHCPk1 = 0;
sumVarAlgPk2 = 0;
sumVarPegPk2 = 0;
sumVarpHEPk2 = 0;
sumVarpHCPk2 = 0;
for K = 1:8
    fprintf('alg 1430/cm pH(%d) %.3f %.3f\n', K, myAlgY1allPunches(K), myAlgY1allPunchesStdDev(K));
    sumVarAlgPk1 = sumVarAlgPk1 + myAlgY1allPunchesStdDev(K);
end        
for K = 1:8
    fprintf('alg 1702/cm pH(%d) %.3f %.3f\n', K, myAlgY2allPunches(K), myAlgY2allPunchesStdDev(K));
    sumVarAlgPk2 = sumVarAlgPk2 + myAlgY2allPunchesStdDev(K);
end 
for K = 1:8
    fprintf('peg 1430/cm pH(%d) %.3f %.3f\n', K, myPEGY1allPunches(K), myPEGY1allPunchesStdDev(K));
    sumVarPegPk1 = sumVarPegPk1 + myPEGY1allPunchesStdDev(K);
end 
for K = 1:8    
    fprintf('peg 1702/cm pH(%d) %.3f %.3f\n', K, myPEGY2allPunches(K), myPEGY2allPunchesStdDev(K));
    sumVarPegPk2 = sumVarPegPk2 + myPEGY2allPunchesStdDev(K);
end
for K = 1:8 
    fprintf('pHE 1430/cm pH(%d) %.3f %.3f\n', K, myHEMAY1allPunches(K), myHEMAY1allPunchesStdDev(K));
    sumVarpHEPk1 = sumVarpHEPk1 + myHEMAY1allPunchesStdDev(K);
end       
for K = 1:8
    fprintf('pHE 1702/cm pH(%d) %.3f %.3f\n', K, myHEMAY2allPunches(K), myHEMAY2allPunchesStdDev(K));
    sumVarpHEPk2 = sumVarpHEPk2 + myHEMAY2allPunchesStdDev(K);
end   
for K = 1:8
    fprintf('pHC 1430/cm pH(%d) %.3f %.3f\n', K, myHEMACoY1allPunches(K), myHEMACoY1allPunchesStdDev(K));
    sumVarpHCPk1 = sumVarpHCPk1 + myHEMACoY1allPunchesStdDev(K);
end        
for K = 1:8
    fprintf('pHC 1702/cm pH(%d) %.3f %.3f\n', K, myHEMACoY2allPunches(K), myHEMACoY2allPunchesStdDev(K));
    sumVarpHCPk2 = sumVarpHCPk2 + myHEMACoY2allPunchesStdDev(K);
end

fprintf('sum of std devs for all pH levels\n');
fprintf('alg 1430/cm %.3f 1702/cm %.3f\n', sumVarAlgPk1, sumVarAlgPk2);
fprintf('peg 1430/cm %.3f 1702/cm %.3f\n', sumVarPegPk1, sumVarPegPk2);
fprintf('pHE 1430/cm %.3f 1702/cm %.3f\n', sumVarpHEPk1, sumVarpHEPk2);
fprintf('pHC 1430/cm %.3f 1702/cm %.3f\n', sumVarpHCPk1, sumVarpHCPk2);

% Plot the averages of the punches with their std dev on one plot for all
% gel types
figure
for J = 1:4
    switch J
        case 1         
            plot(allX, myAlgY1allPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myAlgY1allPunches, myAlgY1allPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
        case 2
            plot(allX, myPEGY1allPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myPEGY1allPunches, myPEGY1allPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;        
        case 3
            plot(allX, myHEMAY1allPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myHEMAY1allPunches, myHEMAY1allPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
        case 4
            plot(allX,  myHEMACoY1allPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX,  myHEMACoY1allPunches,  myHEMACoY1allPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
    end 
end
title('1430 cm-1 normalized peak average and std dev of all punches of all gels', 'FontSize', myTextFont);
xlabel('pH', 'FontSize', myTextFont); % x-axis label
ylabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
xlim([3.5 8]);
ylim([0. 0.25]);
y = 0.25; 
x = 4.1;
deltaY = 0.02;
text(x, y, 'alginate', 'Color', red, 'FontSize', myTextFont);
text(x, y, '______', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'PEG', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pHEMA', 'Color', green, 'FontSize', myTextFont);
text(x, y, '_______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pHEMA/coAc', 'Color', purple, 'FontSize', myTextFont);
text(x, y, '___________', 'Color', purple, 'FontSize', myTextFont);

figure
for J = 1:4
    switch J
        case 1         
            plot(allX, myAlgY2allPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myAlgY2allPunches, myAlgY2allPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
        case 2
            plot(allX, myPEGY2allPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myPEGY2allPunches, myPEGY2allPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;        
        case 3
            plot(allX, myHEMAY2allPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX, myHEMAY2allPunches, myHEMAY2allPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
        case 4
            plot(allX,  myHEMACoY2allPunches, '-o', 'LineStyle','none', ...
                'MarkerSize', 30, 'Color', myColor(J,:), 'linewidth', 2);
            hold on;
            errorbar(allX,  myHEMACoY2allPunches,  myHEMACoY2allPunchesStdDev, 'LineStyle','none', ...
                'Color', black,'linewidth', 2);
            hold on;
    end 
end
title('1702 cm-1 normalized peak for average and std dev of all punches of all gels', 'FontSize', myTextFont);
xlabel('pH', 'FontSize', myTextFont); % x-axis label
ylabel('Normalized Intensity', 'FontSize', myTextFont); % y-axis label
set(gca,'FontSize',myTextFont,'FontWeight','bold','box','off')
xlim([3.5 8]);
ylim([0. 0.25]);
y = 0.2; 
x = 6.5;
deltaY = 0.015;
text(x, y, 'alginate', 'Color', red, 'FontSize', myTextFont);
text(x, y, '______', 'Color', red, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'PEG', 'Color', blue, 'FontSize', myTextFont);
text(x, y, '____', 'Color', blue, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pHEMA', 'Color', green, 'FontSize', myTextFont);
text(x, y, '_______', 'Color', green, 'FontSize', myTextFont);
y = y - deltaY;
text(x, y, 'pHEMA/coAc', 'Color', purple, 'FontSize', myTextFont);
text(x, y, '___________', 'Color', purple, 'FontSize', myTextFont);

% Extract min, max and delta from the arrays of averaged values of all
% punches. Put these values in an additional row of the matrix created 
% for the individual punches
for J = 1:4
    % Now for the table of values for gel comparison
    % get min, max, delta and %delta 
    switch J % fill the correct array based on the type of gel
        case 1
            myAlgY1Min(maxM+1) = min(myAlgY1allPunches);    
            myAlgY1Max(maxM+1) = max(myAlgY1allPunches);
            myAlgY1Delta(maxM+1) = myAlgY1Max(maxM+1) - myAlgY1Min(maxM+1);
            myAlgY1PercentDelta(maxM+1) = myAlgY1Delta(maxM+1)/myAlgY1Min(maxM+1)*100.;
            myAlgY2Min(maxM+1) = min(myAlgY2allPunches);    
            myAlgY2Max(maxM+1) = max(myAlgY2allPunches);
            myAlgY2Delta(maxM+1) = myAlgY2Max(maxM+1) - myAlgY2Min(maxM+1);
            myAlgY2PercentDelta(maxM+1) = myAlgY2Delta(maxM+1)/myAlgY2Min(maxM+1)*100.;
        case 2
            myPEGY1Min(maxM+1) = min(myPEGY1allPunches);    
            myPEGY1Max(maxM+1) = max(myPEGY1allPunches);
            myPEGY1Delta(maxM+1) = myPEGY1Max(maxM+1) - myPEGY1Min(maxM+1);
            myPEGY1PercentDelta(maxM+1) = myPEGY1Delta(maxM+1)/myPEGY1Min(maxM+1)*100.;
            myPEGY2Min(maxM+1) = min(myPEGY2allPunches);    
            myPEGY2Max(maxM+1) = max(myPEGY2allPunches);
            myPEGY2Delta(maxM+1) = myPEGY2Max(maxM+1) - myPEGY2Min(maxM+1);
            myPEGY2PercentDelta(maxM+1) = myPEGY2Delta(maxM+1)/myPEGY2Min(maxM+1)*100.;
        case 3                
            myHEMAY1Min(maxM+1) = min(myHEMAY1allPunches);    
            myHEMAY1Max(maxM+1) = max(myHEMAY1allPunches);
            myHEMAY1Delta(maxM+1) = myHEMAY1Max(maxM+1) - myHEMAY1Min(maxM+1);
            myHEMAY1PercentDelta(maxM+1) = myHEMAY1Delta(maxM+1)/myHEMAY1Min(maxM+1)*100.;
            myHEMAY2Min(maxM+1) = min(myHEMAY2allPunches);    
            myHEMAY2Max(maxM+1) = max(myHEMAY2allPunches);
            myHEMAY2Delta(maxM+1) = myHEMAY2Max(maxM+1) - myHEMAY2Min(maxM+1);
            myHEMAY2PercentDelta(maxM+1) = myHEMAY2Delta(maxM+1)/myHEMAY2Min(maxM+1)*100.;        
        case 4
            myHEMACoY1Min(maxM+1) = min(myHEMACoY1allPunches);    
            myHEMACoY1Max(maxM+1) = max(myHEMACoY1allPunches);
            myHEMACoY1Delta(maxM+1) = myHEMACoY1Max(maxM+1) - myHEMACoY1Min(maxM+1);
            myHEMACoY1PercentDelta(maxM+1) = myHEMACoY1Delta(maxM+1)/myHEMACoY1Min(maxM+1)*100.;
            myHEMACoY2Min(maxM+1) = min(myHEMACoY2allPunches);    
            myHEMACoY2Max(maxM+1) = max(myHEMACoY2allPunches);
            myHEMACoY2Delta(maxM+1) = myHEMACoY2Max(maxM+1) - myHEMACoY2Min(maxM+1);
            myHEMACoY2PercentDelta(maxM+1) = myHEMACoY2Delta(maxM+1)/myHEMACoY2Min(maxM+1)*100.;
    end
end

for M=1:maxM+1
    fprintf('%.3f %.3f %.3f %.3f\n', myAlgY1Min(M), myAlgY1Max(M), myAlgY1Delta(M), myAlgY1PercentDelta(M));
end
for M=1:maxM+1
    fprintf('%.3f %.3f %.3f %.3f\n', myAlgY2Min(M), myAlgY2Max(M), myAlgY2Delta(M), myAlgY2PercentDelta(M));
end
for M=1:maxM+1
    fprintf('%.3f %.3f %.3f %.3f\n', myPEGY1Min(M), myPEGY1Max(M), myPEGY1Delta(M), myPEGY1PercentDelta(M));
end
for M=1:maxM+1
    fprintf('%.3f %.3f %.3f %.3f\n', myPEGY2Min(M), myPEGY2Max(M), myPEGY2Delta(M), myPEGY2PercentDelta(M));
end
for M=1:maxM+1
    fprintf('%.3f %.3f %.3f %.3f\n', myHEMAY1Min(M), myHEMAY1Max(M), myHEMAY1Delta(M), myHEMAY1PercentDelta(M));
end
for M=1:maxM+1
    fprintf('%.3f %.3f %.3f %.3f\n', myHEMAY2Min(M), myHEMAY2Max(M), myHEMAY2Delta(M), myHEMAY2PercentDelta(M));
end
for M=1:maxM+1
    fprintf('%.3f %.3f %.3f %.3f\n', myHEMACoY1Min(M), myHEMACoY1Max(M), myHEMACoY1Delta(M), myHEMACoY1PercentDelta(M));
end
for M=1:maxM+1
    fprintf('%.3f %.3f %.3f %.3f\n', myHEMACoY2Min(M), myHEMACoY2Max(M), myHEMACoY2Delta(M), myHEMACoY2PercentDelta(M));
end
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
        fprintf('getDenominator with numPointsEachSide = %d\n', ...
            numPointsEachSide);
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
    if myDebug 
        fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
            numPointsEachSide);
    end

    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(lowEnd + i - 1);
        if myDebug
            fprintf('index: %d, spectrum: %g\n', i, spectrum(lowEnd + i - 1));
        end
    end
    areaUnderCurve = sum/numPointsToIntegrate; % HERE IS THE SCALING
    if myDebug
        fprintf('areaUnderCurve: %g\n', areaUnderCurve);
    end
    d = areaUnderCurve;
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

function g = prepPlotData(J, subDirStem, K, myColor, M)
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
%     global labels
    
    sum1 = 0;
    sum2 = 0;
    sumSq1 = 0;
    sumSq2 = 0;
    thisdata = zeros(2, numPoints, 'double');   
%     str_dir_to_search = dirStem + subDirStem; % args need to be strings
%     dir_to_search = char(str_dir_to_search);
    dir_to_search = dirStem(J) + subDirStem; % this seems to work in 2019
    txtpattern = fullfile(dir_to_search, 'avg*.txt'); % this looks fine
    dinfo = dir(txtpattern); % why is this null array?
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');  
            
            % 1.5 Only consider a narrow band of the spectrum 
            numerator1 = getAreaUnderCurve(x1, f(:));
            numerator2 = getAreaUnderCurve(x2, f(:));

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
                fprintf('denominator = %g at index: %d\n', denominator1, xRef);
            end

            % 3. NEW 10/4/18: Normalize what is plotted
            normalized1= numerator1/denominator;
            normalized2= numerator2/denominator;
            
            sum1 = sum1 + normalized1;
            sum2 = sum2 + normalized2;
        end
        
        % calculate average
        avg1 = sum1/numberOfSpectra;
        avg2 = sum2/numberOfSpectra;
        
        % second pass on dataset to get (each point - average)^2
        % for standard deviation, need 
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            fclose(fileID);

            % 10/5/2018: ORDER MATTERS FOR NORMALIZED PLOT TO BE 1 AT
            % REFERENCE INDEX

            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)');  
            
            % 1.5 Only consider a narrow band of the spectrum 
            numerator1 = getAreaUnderCurve(x1, f(:));
            numerator2 = getAreaUnderCurve(x2, f(:));   
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
                fprintf('denominator = %g at index: %d\n', denominator1, xRef);
            end

            % 3. Normalize what is plotted
            normalized1 = numerator1/denominator;
            normalized2 = numerator2/denominator;
            
            % 4. Add to the sum of the squares
            sumSq1 = sumSq1 + (normalized1 - avg1).^2; 
            sumSq2 = sumSq2 + (normalized2 - avg2).^2; 
        end
        
        % 5. Compute standard deviation at each index of the averaged spectra 
        stdDev1 = sqrt(sumSq1/numberOfSpectra);
        stdDev2 = sqrt(sumSq2/numberOfSpectra);
            
        % Build up arrays to plot later
        global myX
        global myY1
        global myY2
        global myErr1
        global myErr2
        
        myX(K) = pH(K);
        myY1(K) = normalized1;
        myErr1(K) = stdDev1;
        myY2(K) = normalized2;
        myErr2(K) = stdDev2;

        %xlim([xMin xMax]);
        %ylim([yMin yMax]);
        %hold on
        %fprintf('%d\n', I);
        %pause(5);
        
        % part 1: do the 1430 cm-1 plot 6/30/2020: don't color based on
        % 'K'. Color based on punch number.
        plot(myX(K), myY1(K), '-o', 'LineStyle','none', 'MarkerSize', ...
            30, 'Color', myColor, 'linewidth', 2); 
        hold on
        % https://blogs.mathworks.com/pick/2017/10/13/labeling-data-points/
        %labelpoints(myX(K), myY1(K), labels(M),'SE',0.2,1)
        %hold on
        errorbar(myX(K), myY1(K), myErr1(K), 'LineStyle','none', ...
            'Color', black, 'linewidth', 2);
        hold on

        % part 2: do the 1702 cm-1 plot
        plot(myX(K), myY2(K), '-s', 'LineStyle','none', 'MarkerSize', ...
            30, 'Color', myColor, 'linewidth', 2); 
        hold on
        errorbar(myX(K), myY2(K), myErr2(K), 'LineStyle','none', ...
            'Color', black,'linewidth', 2);
        hold on
        
        xlim([3.5 8])
        ylim([0. max(myY1(K),0.2)]);
    end
    g = numberOfSpectra;
end

function h = getAverageAndStdDev(dataPoints)
        %Pass in array of points
        myN = length(dataPoints);
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
  