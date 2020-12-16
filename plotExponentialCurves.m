    global figNumber;
    figNumber = 1;
    close all;
    
    % plot exponential: y = a*exp(b*x) and also log: ln y = ln a + bx
    % 12/15/2020 New: plot 2nd exponential:
    % y = a(1 - exp(b*x)) and also log:
    % ln y = ln a - ln a - bx 
    %      = -bx
    
    % First, a demo
    % use a =  1, b = -1 for approaching steady state from above
    % use a = -1, b = -1 for approaching steady state from below
    a = [1 -1 1 -1 0.5 -0.5];
    b = [-1 -1 1 1 -0.5 -0.5];
    
    xstart = 0.1;
    xinc = 0.1;
    xend = 10;
    x = xstart:xinc:xend;
    for i = 1:4 % up to 6
        for myPlotType = 1:8
            switch myPlotType
                case 1
                    y = a(i) * exp(b(i) * x);
                case {2, 3, 4}
                    y = log(a(i)) + b(i) * x;
                case 5
                    y = a(i)*(1 - exp(b(i) * x));
                case {6, 7, 8}
                    y = -1 * b(i) * x;
            end
            plotCurve(myPlotType, a(i), b(i), x, y, xstart, xinc, xend, 0, 0, 0, i);
        end
    end
    
    % Second, show the results for 4 gels, 3 series, ...
    data = load('saveVals.mat');
    vals = data.vals;
    
    for i = 1:1
        sumPH4a = 0;
        sumPH4b = 0;
        sumPH7a = 0;
        sumPH7b = 0;
        sumPH10a = 0;
        sumPH10b = 0;
        n = 0;
        for j = 1:3
            for k = 1:9
                % 1430 cm-1 peak
                a = vals(i, j, k, 1, 1);
                b = vals(i, j, k, 1, 2);
                switch(k)
                    case {1, 4, 8}
                        sumPH7a = sumPH7a + a;
                        sumPH7b = sumPH7b + b;
                    case {2, 6, 9}
                        sumPH4a = sumPH4a + a;
                        sumPH4b = sumPH4b + b;
                    case {3, 5, 7}
                        sumPH10a = sumPH10a + a;
                        sumPH10b = sumPH10b + b;
                end
                
                for myPlotType = 1:8
                    switch myPlotType
                        case 1
                            y = a * exp(b*x);
                        case {2, 3, 4}
                            y = log(a) + b*x;
                        case 5
                            y = a*(1 - exp(b*x));
                        case {6, 7, 8}
                            y = -1 * b*x;
                    end
                    plotCurve(myPlotType, a, b, x, y, xstart, xinc, xend, i, j, k, 1430);
                
%                   TO DO later if needed
%                   1702 cm-1 peak
%                   a = vals(i, j, k, 2, 1);
%                   b = vals(i, j, k, 2, 2);
%                   y = a * exp(b * x);
%                   plotCurve(plotType, a, b, x, y, xstart, xinc, xend, i, j, k, 1702);
                end
                n = n + 1;
                end
            pause(1);
            
        end
        n = 9; % fix
        avgPH4a = sumPH4a/n;
        avgPH4b = sumPH4b/n;
        avgPH7a = sumPH7a/n;
        avgPH7b = sumPH7b/n;
        avgPH10a = sumPH10a/n;
        avgPH10b = sumPH10b/n;
        y = avgPH4a * exp(avgPH4b * x);
        plotCurve(1, avgPH4a, avgPH4b, x, y, xstart, xinc, xend, i, 0, 0, 1430);
        y = avgPH7a * exp(avgPH7b * x);
        plotCurve(1, avgPH7a, avgPH7b, x, y, xstart, xinc, xend, i, 0, 0, 1430);
        y = avgPH10a * exp(avgPH10b * x);
        plotCurve(1, avgPH10a, avgPH10b, x, y, xstart, xinc, xend, i, 0, 0, 1430);
    end
    
    function a = plotCurve(myPlotType, a, b, x, y, xstart, xinc, xend, ...
        gel, series, segment, peak)
        global blue
        global red
        global green
        global black
        blue =    [0.0000, 0.4470, 0.7410];
        rust =    [0.8500, 0.3250, 0.0980];
        gold =    [0.9290, 0.6940, 0.1250];
        purple =  [0.4940, 0.1840, 0.5560];
        green =   [0.4660, 0.6740, 0.1880];
        ciel =    [0.3010, 0.7450, 0.9330];
        cherry =  [0.6350, 0.0780, 0.1840];
        red =     [1.0, 0.0, 0.0];
        black =   [0.0, 0.0, 0.0];
        global figNumber;
        
        myColor = getPH(segment);
        FigH = figure('Position', get(0, 'Screensize'));
        myTitle = "";
        myFileTitle = "";
        
        switch myPlotType
            case {1,5}
                plot(x, y,'-o', 'Color', myColor);
                xlabel('x', 'FontSize', 30); % x-axis label
                ylabel('y', 'FontSize', 30); % y-axis label
            case {2,6} %options: CHOOSE ONE (actually do all 3)
                loglog(x, y,'-o', 'Color', myColor);
                xlabel('log x', 'FontSize', 30); % x-axis label
                ylabel('log y', 'FontSize', 30); % y-axis label
            case {3,7}
                semilogy(x, y,'-o', 'Color', myColor);
                xlabel('x', 'FontSize', 30); % x-axis label
                ylabel('log y', 'FontSize', 30); % y-axis label
            case {4,8}
                semilogx(x, y,'-o', 'Color', myColor);
                xlabel('log x', 'FontSize', 30); % x-axis label
                ylabel('y', 'FontSize', 30); % y-axis label
        end

        if gel > 0
            switch myPlotType
                case 1
                    myTitle = sprintf(...
                        'gel%d series%d seg%d peak%d: y = %.2f * exp(%.2f * x), x = %.1f:%.1f:%.1f', ...
                        gel, series, segment, peak, a, b, xstart, xinc, xend);
                    myFileTitle = sprintf('gel%d series%d seg%d peak%d', ...
                        gel, series, segment, peak);
                case 2
                    myTitle = sprintf(...
                        'gel%d series%d seg%d peak%d: ln(y) = ln(%.2f) + %.2f * x, x = %.1f:%.1f:%.1f', ...
                        gel, series, segment, peak, a, b, xstart, xinc, xend);
                    myFileTitle = sprintf('gel%d series%d seg%d peak%d', ...
                        gel, series, segment, peak);
                case 3
                    myTitle = sprintf(...
                        'gel%d series%d seg%d peak%d: y = %.2f(1 - exp(%.2f * x)), x = %.1f:%.1f:%.1f', ...
                        gel, series, segment, peak, a, b, xstart, xinc, xend);
                    myFileTitle = sprintf('gel%d series%d seg%d peak%d', ...
                        gel, series, segment, peak);
                case 4
                    myTitle = sprintf(...
                        'gel%d series%d seg%d peak%d: ln(y) = %.2f * x, x = %.1f:%.1f:%.1f', ...
                        gel, series, segment, peak, a, b, xstart, xinc, xend);
                    myFileTitle = sprintf('gel%d series%d seg%d peak%d', ...
                        gel, series, segment, peak);
            end
        else
            switch myPlotType
                case 1
                    myTitle  = sprintf(...
                        'example %d: y = %.2f * exp(%.2f * x), x = %.1f:%.1f:%.1f', ...
                        figNumber, a, b, xstart, xinc, xend);
                case {2, 3, 4}
                    myTitle  = sprintf(...
                        'example %d: ln(y) = ln(%.2f) + %.2f * x, x = %.1f:%.1f:%.1f', ...
                        figNumber, a, b, xstart, xinc, xend);
                case 5
                    myTitle  = sprintf(...
                        'example %d: y = %.2f * (1 - exp(%.2f * x)), x = %.1f:%.1f:%.1f', ...
                        figNumber, a, b, xstart, xinc, xend);
                case {6, 7, 8}
                    myTitle  = sprintf(...
                        'example %d: ln(y) = %.2f * x, x = %.1f:%.1f:%.1f', ...
                        figNumber, b, xstart, xinc, xend);
            end

        end
        title(myTitle, 'FontSize', 30);
        myFileTitle = sprintf('example %d', figNumber);
        figNumber = figNumber + 1;
        
        ax = gca; % these 2 lines work IFF you put them here, instead
                  % of earlier, when the figure is assigned
        ax.XAxis.FontSize = 30; %for x-axis 
        ax.YAxis.FontSize = 30; %for y-axis 
        saveMyPlot(FigH, myFileTitle);
        a = 1;
    end
    
function m = getPH(iter)
    global blue
    global red
    global green
    global black
    
    m = black;
    switch(iter)
        case {1, 4, 8}
            m = green;
        case {2, 6, 9}
            m = red;
        case {3, 5, 7}
            m = blue;
    end
end

function g = saveMyPlot(FigH, myTitle)
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlotName = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlotName, 'png');
    g = 1;
end