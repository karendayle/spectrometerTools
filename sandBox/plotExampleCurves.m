    % plot exponential: y = a*exp(b*x) and also log: ln y = ln a + bx
    % 12/15/2020 New: plot 2nd exponential:
    % y = a(1 - exp(b*x)) and also log:
    % ln y = ln a - ln a - bx 
    %      = -bx

    % use a =  1, b = -1 for approaching steady state from above
    % use a = -1, b = -1 for approaching steady state from below
    a = [1 -1 1 -1 24.559167 0.5 -0.5];
    b = [-1 -1 1 1 -0.238257 -0.5 -0.5];

    global figNumber;
    figNumber = 1;
    close all;
    
    xstart = 0.1;
    xinc = 0.1;
    xend = 10;
    x = xstart:xinc:xend;
    for i = 5:5 % choose the coefficients a and b 
        for myPlotType = 1:4:8
            switch myPlotType
                case 1
                    y = a(i) * exp(x/b(i));
                case {2, 3, 4}
                    y = log(a(i)) + b(i) * x;
                case 5
                    y = a(i)*(1 - exp(x/b(i)));
                case {6, 7, 8}
                    y = -1 * b(i) * x;
            end
            
            y
            plotCurve(myPlotType, a(i), b(i), x, y, xstart, xinc, xend, 0, 0, 0, i);
        end
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
        % FigH = figure('Position', get(0, 'Screensize')); % Full screen
        % plot
        FigH = figure();
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
    % Note to Waqas: Change the path in next line
    dirStem = "C:\Users\karen\Documents\Data\";
    subDir = "Plots\";
    plotDirStem = sprintf("%s%s", dirStem, subDir);
    myPlotName = sprintf('%s%s', plotDirStem, myTitle);
    saveas(FigH, myPlotName, 'png');
    g = 1;
end