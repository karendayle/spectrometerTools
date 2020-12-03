    close all;
    
    % plot exponential: y = a*exp(b*x)
    % First, a demo
    % use a =  1, b = -1 for approaching steady state from above
    % use a = -1, b = -1 for approaching steady state from below
    a = [1 -1];
    b = [-1 -1];
    
    xstart = 0.1;
    xinc = 0.1;
    xend = 10;
    x = xstart:xinc:xend;
    for i = 1:2
        y = a(i) * exp(b(i) * x);
        plotExponentialCurve(a(i), b(i), x, y, xstart, xinc, xend, 0, 0, 0, i);
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
                y = a * exp(b * x);
                n = n + 1;
                plotExponentialCurve(a, b, x, y, xstart, xinc, xend, i, j, k, 1430);
                
%                 % 1702 cm-1 peak
%                 a = vals(i, j, k, 2, 1);
%                 b = vals(i, j, k, 2, 2);
%                 y = a * exp(b * x);
%                 plotExponentialCurve(a, b, x, y, xstart, xinc, xend, i, j, k, 1702);            
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
        plotExponentialCurve(avgPH4a, avgPH4b, x, y, xstart, xinc, xend, i, 0, 0, 1430);
        y = avgPH7a * exp(avgPH7b * x);
        plotExponentialCurve(avgPH7a, avgPH7b, x, y, xstart, xinc, xend, i, 0, 0, 1430);
        y = avgPH10a * exp(avgPH10b * x);
        plotExponentialCurve(avgPH10a, avgPH10b, x, y, xstart, xinc, xend, i, 0, 0, 1430);
    end
    
    function a = plotExponentialCurve(a, b, x, y, xstart, xinc, xend, ...
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
        
        figure
        % semilogx(x, y1,'-o', 'Color', red);
        % hold on;
        
        myColor = getPH(segment);
        plot(x, y,'-o', 'Color', myColor);
        if gel > 0
            myTitle = sprintf(...
                'gel%d series%d seg%d peak%d: y = %.2f * exp(%.2f * x), x = %.1f:%.1f:%.1f', ...
                gel, series, segment, peak, a, b, xstart, xinc, xend);
        else
            myTitle  = sprintf(...
                'example: y = %.2f * exp(%.2f * x), x = %.1f:%.1f:%.1f', ...
                a, b, xstart, xinc, xend);
        end
        title(myTitle);
        yLabel = 'y';
        xLabel = 'x';
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