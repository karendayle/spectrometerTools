% Plot the intensity at a single wavenumber normalized by the reference 
% intensity vs time by extracting it from a set of files in different directories
% The time to use for the x axis is in the filename as
% avg-yyyy-mm-dd-mm-ss.txt. Convert this to seconds since epoch.
% Dayle Kotturi October 2018

% There are two plots to build (or two lines on one plot).
% Use the index 614 to get the intensity at 1430/cm (act. 1428.58/cm)
% NEW 11/06/2018 find the local max instead of looking at const location
global x1Min;
global x1Max;
x1Min = 591;
x1Max = 615;
% Use the index 794 to get the intensity at 1702/cm (act. 1701.95/cm)
% NEW 11/06/2018 find the local max instead of looking at const location
global x2Min;
global x2Max;
x2Min = 790;
x2Max = 797;

% IMPORTANT: This is index to reference peak. 
% No, it is not only this value that is used. Rather it is an integration
% around this point that is used for the denominator that normalizes
global xRef;
xRef = 713; % COO- at 1582
            % TO DO: read from avg*.txt file
% Colors:
global blue;
global rust;
global gold;
global purple;
global green;
global ciel; 
global cherry;
global red;
global black;
blue =    [0.0000, 0.4470, 0.7410];
rust =    [0.8500, 0.3250, 0.0980];
gold =    [0.9290, 0.6940, 0.1250];
purple =  [0.4940, 0.1840, 0.5560];
green =   [0.4660, 0.6740, 0.1880];
ciel =    [0.3010, 0.7450, 0.9330];
cherry =  [0.6350, 0.0780, 0.1840];
red =     [1.0, 0.0, 0.0];
black =   [0.0, 0.0, 0.0];
pHcolor = [0.0, 0.0, 0.0];

global numPoints;
numPoints = 1024;

global lineThickness;
lineThickness = 2;

global myDebug;
myDebug = 0;

% subtract this offset to start x axis at zero
global tRef;

%global ss; % NEW 2020/2/25
%ss=zeros(4,3,9,2);  % keep track of last norm'd ratio for 
                    % both peaks, for all segs, for all gels

myTitleFont = 30;
myLabelFont = 30; 
myTextFont = 30; 

global plotOption;
%plotOption = 1; % plot y1 and y2
%plotOption = 2; % plot y3
%plotOption = 3; % check pH sens
plotOption = 4; % do curve fitting

%global gelOption; 2020/2/19 pass it instead
global dirStem;

subDirStem1 = "1 pH7";
subDirStem2 = "2 pH4";
subDirStem3 = "3 pH10";
subDirStem4 = "4 pH7";
subDirStem5 = "5 pH10";
subDirStem6 = "6 pH4";
subDirStem7 = "7 pH10";
subDirStem8 = "8 pH7";
subDirStem9 = "9 pH4";

for gelOption = 1:1
    Kmin = 2;
    Kmax = 9;
    % Do for each dataset
    figure
    
    switch gelOption
      case 1 % alginate time series 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch1 flowcell all\";
        tRef = datenum(2019, 12, 10, 14, 1, 8);
        myTitle = '54nm MBA AuNPs MCs alginate gel12 punch1 flowcell';
        %gel = 1; series = 1; not now 
      case 2  % alginate time series 2
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch2 flowcell1 1000ms integ\";
        tRef = datenum(2020, 1, 10, 13, 45, 1);
        myTitle = '54nm MBA AuNPs MCs alginate gel12 punch2 flowcell';
        %gel = 1; series = 2; not now 
      case 3 % alginate time series 3
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\Alginate\gel 12\punch3 flowcell1\";
        tRef = datenum(2020, 1, 12, 16, 15, 57);
        myTitle = '54nm MBA AuNPs MCs alginate gel12 punch3 flowcell';
        %gel = 1; series = 3; not now 
        
      case 4 % PEG time series 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\PEG\gel 3\1\";
        tRef = datenum(2018, 12, 28, 16, 34, 5);
        myTitle = '54nm MBA AuNPs MCs PEG gel3 punch1 flowcell';
        %gel = 2; series = 1; not now 
      % add PEG time series 2 and 3
      
      case 5 % pHEMA time series 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 1\2\";
        tRef = datenum(2018, 12, 30, 16, 1, 17);
        myTitle = '54nm MBA AuNPs MCs pHEMA gel1 punch1 flowcell'; 
        %gel = 3; series = 1; not now 
      case 6 % pHEMA time series 2
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\punch1 flowcell1\";
        tRef = datenum(2020, 1, 25, 17, 10, 17); 
        myTitle = '54nm MBA AuNPs MCs pHEMA gel13 punch1 flowcell';
        %gel = 3; series = 2; not now 
      case 7 % pHEMA time series 3
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA\gel 13\punch2 flowcell1 300ms\";
        tRef = datenum(2020, 2, 1, 17, 54, 20);
        myTitle = '54nm MBA AuNPs MCs pHEMA gel13 punch2 flowcell';
        %gel = 3; series = 3; not now 
        
      case 8 % pHEMA/coAc  time series 1
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 3\4\"; 
        tRef = datenum(2019, 01, 26, 16, 28, 6);
        myTitle = '54nm MBA AuNPs MCs pHEMA coAc gel3 punch4 flowcell';
        %gel = 4; series = 1; not now 
        Kmax = 8; % special case b/c final pH4 is missing!
      case 9 % add pHEMA/coAc  time series 2
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\punch1 flowcell1\";
        tRef = datenum(2020, 1, 27, 12, 27, 47); 
        myTitle = '54nm MBA AuNPs MCs pHEMA coAc gel14 punch1 flowcell';
        %gel = 4; series = 2; not now 
      case 10 % pHEMA/coAc time series 3
        dirStem = "R:\Students\Dayle\Data\Made by Sureyya\pHEMA coAcrylamide\gel 14\punch2 flowcell1\";
        tRef = datenum(2020, 2, 3, 19, 50, 17);
        myTitle = '54nm MBA AuNPs MCs pHEMA coAc gel14 punch2 flowcell';
        %gel = 4; series = 3; not now 
    end
    
    for K = Kmin:Kmax
        switch K
            case 1
                pHcolor = green;
                num1 = myPlot(subDirStem1, pHcolor, 0, gelOption, K);
                %fprintf('Case 1: %d spectra plotted in green\n', num1);
            case 2
                pHcolor = red;
                num2 = myPlot(subDirStem2, pHcolor, 0, gelOption, K);
                %fprintf('Case 2: %d spectra plotted in red\n', num2);            
            case 3
                pHcolor = blue;
                num3 = myPlot(subDirStem3, pHcolor, 0, gelOption, K);
                %fprintf('Case 3: %d spectra plotted in blue\n', num3);
            case 4
                pHcolor = green;
                num4 = myPlot(subDirStem4, pHcolor, 0, gelOption, K);
                %fprintf('Case 4: %d spectra plotted in green\n', num4);    
            case 5
                pHcolor = blue;
                num5 = myPlot(subDirStem5, pHcolor, 0, gelOption, K);
                %fprintf('Case 5: %d spectra plotted in blue\n', num5);
            case 6
                pHcolor = red;
                num6 = myPlot(subDirStem6, pHcolor, 0, gelOption, K);
                %fprintf('Case 6: %d spectra plotted in red\n', num6); 
            case 7
                pHcolor = blue;
                num7 = myPlot(subDirStem7, pHcolor, 0, gelOption, K);
                %fprintf('Case 7: %d spectra plotted in blue\n', num7);
            case 8
                pHcolor = green;
                num8 = myPlot(subDirStem8, pHcolor, 0, gelOption, K);
                %fprintf('Case 8: %d spectra plotted in green\n', num8);
            case 9
                pHcolor = red;
                num9 = myPlot(subDirStem9, pHcolor, 0, gelOption, K);
                %fprintf('Case 9: %d spectra plotted in red\n', num9);
        end
    end    

    if plotOption == 1
        if gelOption == 1 || gelOption == 2 || gelOption == 4
            y = 0.24;
            deltaY = 0.02;
            x = 2.5;
        else
            if gelOption == 3
                y = 0.325;
                deltaY = 0.02;
                x = 32;
            end
        end
    else
        if gelOption == 1
            y = 8.9;
            deltaY = 0.25;
            x = 0.25;
        else
            y = 8.9;
            deltaY = 0.1;
            x = 7;
        end   
    end
    % limit height of the exponential curves that get drawn
%     if plotOption == 4
%         ylim([0. 0.35]);
%         y = 4.9;
%         deltaY = 0.25;
%     end

%     % YES for SRs, NO for pubs
%     text(x, y, 'o = local peak near 1430 cm^-^1', 'Color', black, 'FontSize', myTextFont);
%     y = y - deltaY;
%     text(x, y, '+ = local peak near 1702 cm^-^1', 'Color', black, 'FontSize', myTextFont);
%     y = y - deltaY;
%     hold off
    
    title(myTitle, 'FontSize', myTitleFont);
    
    myXlabel = sprintf('Time (hours)');
    xlabel(myXlabel, 'FontSize', myLabelFont); % x-axis label
    if plotOption == 1 || plotOption == 4
        ylabel('Normalized Intensity', ...
            'FontSize', myLabelFont); % y-axis label
    else
        ylabel('Intensity at 1430cm^-^1(A.U.)/Intensity at 1702cm^-^1(A.U.)', ...
            'FontSize', myLabelFont); % y-axis label
    end
end

function d = getDenominator(closestRef, numPointsEachSide, numPoints, spectrum)
    global myDebug;
    % use the closestRef as the x-value of the center point of the peak
    % sum the points from x=(closestRef - numPointsIntegrated) to 
    % x=(closestRef + numPointsIntegrated) and then divide by number of
    % points to average and scale it.
    
    if myDebug 
        fprintf('getDenominator with numPointsEachSide = %d\n', ...
            numPointsEachSide);
    end
    
    % check that numPointsIntegrated is in range
    lowEnd = closestRef - numPointsEachSide;
    if (lowEnd < 1) 
        fprintf('low end of number of points integrated is out of range');
    end
    highEnd = closestRef + numPointsEachSide;
    if (highEnd > numPoints)
        fprintf('high end of number of points integrated is out of range');
    end
    
    sum = 0;
    if myDebug 
        fprintf('closestRef: %d, numPointsEachSide: %d\n', closestRef, ...
            numPointsEachSide);
    end
    startIndex = closestRef - numPointsEachSide;
    numPointsToIntegrate = 1 + (2 * numPointsEachSide);
    for i = 1 : numPointsToIntegrate
        sum = sum + spectrum(startIndex);
        if myDebug
            fprintf('index: %d, spectrum: %g\n', startIndex, spectrum(startIndex));
        end
        startIndex = startIndex + 1;
    end
    denominator = sum/numPointsToIntegrate;
    if myDebug
        fprintf('denominator: %g\n', denominator);
    end
    d = denominator;
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

function g = myPlot(subDirStem, myColor, offset, gelOption, K)
    global blue;
    global rust;
    global gold;
    global purple;
    global green;
    global ciel; 
    global cherry;
    global red;
    global black;
    global dirStem;
    global numPoints;
    global x1Min;
    global x1Max;
    global x2Min;
    global x2Max;
    global xRef;
    global tRef;
    global myDebug;
    global lineThickness;
    global plotOption;
%    global ss;
    
%     sumY1 = 0;
%     sumY2 = 0;
%     avgY1 = 0;
%     avgY2 = 0;
%     sumSqY1 = 0;
%     sumSqY2 = 0;
    
    str_dir_to_search = dirStem + subDirStem; % args need to be strings
    dir_to_search = char(str_dir_to_search); % 2020/2/19 add comma
    txtpattern = fullfile(dir_to_search, 'avg*.txt');
    dinfo = dir(txtpattern); 
    thisdata = zeros(2, numPoints, 'double');
    
    numberOfSpectra = length(dinfo);
    if numberOfSpectra > 0
        % first pass on dataset, to get array of average spectra
        % TO DO: add if stmt to ensure numberOfSpectra > 0
        for I = 1 : numberOfSpectra
            thisfilename = fullfile(dir_to_search, dinfo(I).name); % just the name            
            % NEW 10/8/2018: extract time from filename
            S = string(thisfilename); 
            newStr1 = extractAfter(S,"avg-");
            dateWithHyphens = extractBefore(newStr1,".txt");
            % No, it would be too easy if this worked
            %t1 = datetime(dateWithHyphens,'Format','yyyy-MM-dd-hh-mm-ss');
            [myYear, remain] = strtok(dateWithHyphens, '-');
            [myMonth, remain] = strtok(remain, '-');
            [myDay, remain] = strtok(remain, '-');
            [myHour, remain] = strtok(remain, '-');
            [myMinute, remain] = strtok(remain, '-');
            [mySecond, remain] = strtok(remain, '-');
            % These are strings, need to make them numbers,
            % by, sigh, first making them char arrays
            % which wasn't by the way necessary with 2018a.
            % sigh again.
            myY = str2num(char(myYear));
            myMo = str2num(char(myMonth));
            myD = str2num(char(myDay));
            myH = str2num(char(myHour));
            myMi = str2num(char(myMinute));
            myS = str2num(char(mySecond));
            t(I) = (datenum(myY, myMo, myD, myH, myMi, myS) - tRef)*24.;
            %fprintf...
            %    ('CHECK %d file %2d-%2d-%2d-%2d-%2d-%2d has time %10.4f\n',...
            %    I, myY, myMo, myD, myH, myMi, myS, t(I));
            fileID = fopen(thisfilename,'r');
            [thisdata] = fscanf(fileID, '%g %g', [2 numPoints]);
            % NEW 10/18 - base corr not done in 10/15/18 SR. This could explain
            % the lack of steady state...
            % 1. Correct the baseline BEFORE calculating denominator + normalizing
            % Returns trend as 'e' and baseline corrected signal as 'f'
            [e, f] = correctBaseline(thisdata(2,:)'); 
            % OLDER denominator = thisdata(2, xRef);
            % OLD denominator = f(xRef);
            % NEW 10/20/2018
            denominator = 1; % default
            if (xRef ~= 0) 
                numPointsEachSide = 2; % TO DO: This could be increased
                denominator = getDenominator(xRef, numPointsEachSide, ...
                    numPoints, f(:));
            end
            if myDebug
                fprintf('denominator = %g at index: %d\n', denominator1, xRef);
            end

            % NEW 11/6/2018: since peaks at 1430 and 1702/cm red-, blueshift
            % as function of pH, find the local max in the area
            x1LocalPeak = localPeak(f(x1Min:x1Max));
            x2LocalPeak = localPeak(f(x2Min:x2Max));
            %fprintf('local max near 1430/cm is %g\n', x1LocalPeak);
            %fprintf('local max near 1702/cm is %g\n', x2LocalPeak);       

            y1(I) = x1LocalPeak/denominator;
            y2(I) = x2LocalPeak/denominator;
            y3(I) = y1(I)/y2(I);

            fclose(fileID);
%             sumY1 = sumY1 + y1(I);
%             sumY2 = sumY2 + y2(I);
        end
        
%        ss(gel, series, K, 1) = y1(numberOfSpectra);
%        ss(gel, series, K, 1) = y2(numberOfSpectra);
        
%         % calculate average 
%         avgY1 = sumY1/numberOfSpectra
%         avgY2 = sumY2/numberOfSpectra
%         sumSqY1 = 0;
%         sumSqY2 = 0;
        
%         % second pass on dataset to get (each point - average)^2
%         % for standard deviation, need 
%         for I = 1 : numberOfSpectra            
%             % 4. Add to the sum of the squares
%             sumSqY1 = sumSqY1 + (y1(I) - avgY1).^2;
%             sumSqY2 = sumSqY2 + (y2(I) - avgY2).^2;
%         end
    end
    
%     % 5. Compute standard deviation at each index of the averaged spectra 
%     stdDevY1 = sqrt(sumSqY1/numberOfSpectra);
%     stdDevY2 = sqrt(sumSqY2/numberOfSpectra);
%     
%     for J=1:numberOfSpectra
%         avgArrayY1(J) = avgY1;
%         avgArrayY2(J) = avgY2;
%         stdDevArrayY1(J) = stdDevY1;
%         stdDevArrayY2(J) = stdDevY2;
%     end
    
%     % Now have points for the 1430 plot at t,y1 and for the 1702 plot at t,y2
%     Either:
%     errorbar(t, avgArrayY1, stdDevArrayY1, '-o', 'Color', purple);
%     errorbar(t, avgArrayY2, stdDevArrayY2, '-*', 'Color', purple);
%     hold on;
%     Or:
    if plotOption == 1 || plotOption == 3
        plot(t-offset,y1,'-o', 'Color', myColor, 'LineWidth', lineThickness);
        hold on;
        plot(t-offset,y2,'-+', 'Color', myColor, 'LineWidth', lineThickness);
    else
        if plotOption == 2
            plot(t-offset,y3,'-*', 'Color', myColor, 'LineWidth', lineThickness);
        else
            if plotOption == 4 % do curve fitting
                semilogx(t-offset,y1,'-o', 'Color', myColor, 'LineWidth', lineThickness); % new
                %ylim([0. 0.35]);
                hold on;
                
                % fit exponential curve to y1 and plot it
                result = curveFitting(t, offset, y1, myColor, K, 1);
                rc = parseCurveFittingObject(gelOption, K, 1, result);
                ylim([0. 0.35]);
                hold on;         
                
                semilogx(t-offset,y2,'-+', 'Color', myColor, 'LineWidth', lineThickness);
                ylim([0. 0.35]);
                hold on;
                
                % fit exponential curve to y2 and plot it
                result = curveFitting(t, offset, y2, myColor, K, 2);
                rc = parseCurveFittingObject(gelOption, K, 2, result);
                ylim([0. 0.35]);
                hold on;
            end
        end
    end
    hold on;
    g = 1;
end

function h = localPeak(range)
    h = max(range);
end

function j = curveFitting(t, offset, y, myColor, myIter, mySubIter)

% To avoid this error: "NaN computed by model function, fitting cannot continue.
% Try using or tightening upper and lower bounds on coefficients.", do not set
% start point to 0. 
% Ref=https://www.mathworks.com/matlabcentral/answers/132082-curve-fitting-toolbox-error
    % fit exponential curve to y1
    %curveFit(t-offset,y,myColor);
%     if (mySubIter == 1) 
%         % for 1430 peak time series
%         switch myIter
%             case {1,2,4,6,8,9}
%                 % when pH goes from H to L, it's like discharging capacitor
%                 g = fittype('a*exp(-1*x/b)');
%             case {3,5,7}
%                 % when pH goes from L to H, it's like charging capacitor
%                 g = fittype('1 - a*exp(-1*x/b)');
%         end
%     else
%         if (mySubIter == 2)
%             % for 1702 peak time series
%             switch myIter
%                 case {1,2,4,6,8,9}
%                     % when pH goes from L to H, it's like charging capacitor
%                     g = fittype('1 - a*exp(-1*x/b)');
%                 case {3,5,7}
%                     % when pH goes from H to L, it's like discharging capacitor
%                     g = fittype('a*exp(-1*x/b)');
%             end       
%         end
%     end
    
    % don't allow exact zeros
    xStart = (t(1)-offset);
    yStart = y(1);
    if xStart == 0.
        xStart = 0.01;
    end
    if yStart == 0.
        yStart = 0.01;
    end
    startPoint = [xStart yStart];
    xCurve = (t-offset)';
    yCurve = y';
    % xCurve and yCurve are both nx1 row-column form 
    % StartPoint wants 2 points for this type of fit
    %OLD f0 = fit(xCurve,yCurve,g,'StartPoint',startPoint);
    
    %NEW -- this model works when data is curve like charging cap
    %    but it does not plot as straight line
    %    -- this fails for the first pH7 segment
    myfittype=fittype('a + b*log(x)',...
    'dependent', {'y'}, 'independent',{'x'},...
    'coefficients', {'a','b'});
    f0=fit(xCurve,yCurve,myfittype,'StartPoint',startPoint);
    %END NEW
    
    % set the range to draw the exponential curve
    numRows = size(xCurve,1);
    startXX = xCurve(1) - 10.;
    finishXX = xCurve(numRows) + 10;
    xx = linspace(startXX, finishXX, numRows);
    semilogx(xCurve,yCurve,'o',xx,f0(xx), 'Color', myColor);
    j = f0;
end

function k = parseCurveFittingObject(gelOption, myIter, mySubIter, f0)
    % 2020/2/8 since confidence intervals are inaccessible as fields, convert val to 
    % string and parse them out
    % ref: 
    % https://www.mathworks.com/help/matlab/ref/matlab.unittest.diagnostics.constraintdiagnostic.getdisplayablestring.html
    str = matlab.unittest.diagnostics.ConstraintDiagnostic.getDisplayableString(f0);
    %fprintf(str);
    remain = str;
    segments = strings(0);
    while (remain ~= "")
        [token,remain] = strtok(remain, '(');
        segments = [segments; token];
    end
    
    % For case of fittype e^-t/RC ONLY,
    % confidence intervals are in segments(5) and (6)
    if length(segments) == 6
        remain = segments(5);
        [aLow,remain] = strtok(remain, ',');
        % remain contains the ',' and a space and THEN value we want
        [comma,remain] = strtok(remain);
        [aHigh,remain] = strtok(remain, ')');
        % now aLow and aHigh are correct, but string type
        aLow = double(aLow);
        aHigh = double(aHigh);
    
        remain = segments(6);
        [bLow,remain] = strtok(remain, ',');
    	% remain contains the ',' and a space and THEN value we want
        [comma,remain] = strtok(remain);
        [bHigh,remain] = strtok(remain, ')');
        % now bLow and bHigh are correct, but string type
        aLow = double(aLow);
        aHigh = double(aHigh);
        bLow = double(bLow);
        bHigh = double(bHigh);
        
        % 2020/2/27 need to check these for invalid CI
    else
        % For case of fittype 1-e^-t/RC,
        % confidence intervals are NOT in segments(5) and (6)
        % and segments array only has 4 elements
        aLow = 0;
        aHigh = 0;
        bLow = 0;
        bHigh = 0;
    end
    pHStr = getPH(myIter);
    gelStr = getGel(gelOption);
    peak = getPeak(mySubIter);
    fprintf('%s-%d-%s-%d: a=%f (%f, %f), b=%f (%f, %f)\n', gelStr, myIter, pHStr, peak, ...
        f0.a, aLow, aHigh, f0.b, bLow, bHigh);
    k = 1;
end

function m = getPH(iter)
    switch(iter)
        case {1, 4, 8}
            m = 'pH7';
        case {2, 6, 9}
            m = 'pH4';
        case {3, 5, 7}
            m = 'pH10';
        case other
            m = 'error';
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
function n = getGel(gelOption)
    switch(gelOption)
        case {1,2,3}
            n = 'alginate';
        case {4}
            n = 'PEG';
        case {5,6,7}
            n = 'pHEMA';
        case {8,9,10}
            n = 'pHEMA/coAc';
        case other
            n = 'error';
    end
end

function p = getPeak(mySubIter)
    switch(mySubIter)
        case 1
            p = 1430;
        case 2
            p = 1702;
        case other
            p = -1;
    end
end