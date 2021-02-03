
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
    global vals
    global nPoints;
    global lastPoints;
%% kdk: Clear previous plots

close all

    % compare all the pH 4  values: these are in pH= 2, 6, 9
    for peak = 1:2
        for coeff = 1:3:6
            FigH = figure('Position', get(0, 'Screensize'));
            switch peak
                case 1
                    mySgTitle = sprintf('1430 cm-1 pk ');
                case 2
                    mySgTitle = sprintf('1702 cm-1 pk');
            end
            switch coeff
                case 1
                    mySgTitle = strcat(mySgTitle, ' coeff a');
                case 4
                    mySgTitle = strcat(mySgTitle, ' coeff b');
            end

            for gel = 1:1
                for series = 1:3
                    % pH 4
                    xPH4 = [ 2 6 9 ];
                    yPH4 = [vals(gel, series, 2, peak, coeff) ...
                        vals(gel, series, 6, peak, coeff) ...
                        vals(gel, series, 9, peak, coeff)];
                    % 2020/12/01 New: average the pH4 values
                    avgPH4(series) = mean(yPH4, 'all');

                    % New 2020/12/1 label the series and the average 
                    myLabel = sprintf ("%d", series);
                    text(xPH4(3)+0.1, yPH4(3), myLabel, 'Color', red, 'FontSize', 20);
                    hold on;
                    plot(9., avgPH4(series), '-o', 'Color', red);
                    hold on;
                    myLabel = sprintf("avg %d", series);
                    text(9.1, avgPH4(series), myLabel, 'Color', red, 'FontSize', 20);
                    hold on;
                    
                    % pH 7
                    xPH7 = [ 1 4 8 ];
                    yPH7 = [vals(gel, series, 1, peak, coeff) ...
                        vals(gel, series, 4, peak, coeff) ...
                        vals(gel, series, 8, peak, coeff)];
                    % 2020/12/01 New: average the pH7 values
                    avgPH7(series) = mean(yPH7, 'all');
                    
                    % New 2020/12/1 label the series
                    myLabel = sprintf("avg %d", series);
                    text(xPH7(3)+0.1, yPH7(3), myLabel, 'Color', green, 'FontSize', 20);
                    hold on;
                    plot(0., avgPH7(series), '-o', 'Color', green);
                    hold on;
                    myLabel = sprintf ("avg");
                    text(9.1, avgPH7(series), myLabel, 'Color', green, 'FontSize', 20);
                    hold on;
                    
                    % pH 10
                    xPH10 = [ 3 5 7 ];
                    yPH10 = [vals(gel, series, 3, peak, coeff) ...
                        vals(gel, series, 5, peak, coeff) ...
                        vals(gel, series, 7, peak, coeff)];
                    % 2020/12/01 New: average the pH10 values
                    avgPH10(series) = mean(yPH10, 'all');
                    
                    % New 2020/12/1 label the series
                    myLabel = sprintf("avg %d", series);
                    text(xPH10(3)+0.1, yPH10(3), myLabel, 'Color', blue, 'FontSize', 20);
                    hold on;
                    plot(9., avgPH10(series), '-o', 'Color', blue);
                    hold on;
                    myLabel = sprintf ("avg");
                    text(9.1, avgPH10(series), myLabel, 'Color', blue, 'FontSize', 20);
                    hold on;
                    
                    myTitle = sprintf('gel %d all series using last %d points of each segment', gel, lastPoints);
                    %myTitle = sprintf('alginate gel12 punch1 using last %d points of each segment', lastPoints);
                    title(myTitle,'FontSize',30);
                    set(gca,'FontSize', 30); % this works
                    xlim([0 10]);
                    xlabel('pH buffer segment', 'FontSize', 30);
                    ylabel(mySgTitle, 'FontSize', 30);
                end
                % 2020/12/01 New: average over all series
                % Note that only coeff = 1 and 4 are used for a and b,
                % resp.
                overallAvgPH4(gel, peak, coeff) = mean(avgPH4, 'all');
                overallAvgPH7(gel, peak, coeff) = mean(avgPH7, 'all');
                overallAvgPH10(gel, peak, coeff) = mean(avgPH10, 'all');
                plot(10., overallAvgPH4(gel, coeff), '-o', 'Color', red);
                hold on;
                myLabel = sprintf ("AVG");
                text(10.1, overallAvgPH4(gel, peak, coeff), myLabel, 'Color', red, 'FontSize', 20);
                hold on;
                plot(10., overallAvgPH7(gel, peak, coeff), '-o', 'Color', green);
                hold on;
                myLabel = sprintf ("AVG");
                text(10.1, overallAvgPH7(gel, peak, coeff), myLabel, 'Color', green, 'FontSize', 20);
                hold on;
                plot(10., overallAvgPH10(gel, peak, coeff), '-o', 'Color', blue);
                hold on;
                myLabel = sprintf ("AVG");
                text(10.1, overallAvgPH10(gel, peak, coeff), myLabel, 'Color', blue, 'FontSize', 20);
                hold on;
                
                % 2020/12/01 New: save to file
%                saveMyPlot(FigH, myTitle);
            end
        end
        % 2020/12/02 New: draw the logarithmic curve using the 
        % overall average values, eg. y = a + b*log(x) 
        FigH = figure('Position', get(0, 'Screensize'));
        % logarithmic
        % x = logspace(-1,2);
        % y1 = overallAvgPH4(1, peak, 1) + overallAvgPH4(1, peak, 4) * x;
        % y2 = overallAvgPH7(1, peak, 1) + overallAvgPH7(1, peak, 4) * x;
        % y3 = overallAvgPH10(1, peak, 1) + overallAvgPH10(1, peak, 4) * x;
        
        % exponential: y = a*exp(b*x)
        x = 0.1:0.1:2; % 2020/12/02 what should this be?
        % 2020/12/02: why do I need -1*, at least for the 1702 peak?
        if peak == 1
            factor = 1;
        else
            factor = -1;
        end
        y1 = overallAvgPH4(gel, peak, 1) * exp(factor*overallAvgPH4(1, peak, 4) * x);
        y2 = overallAvgPH7(gel, peak, 1) * exp(factor*overallAvgPH7(1, peak, 4) * x);
        y3 = overallAvgPH10(gel, peak, 1) * exp(factor*overallAvgPH10(1, peak, 4) * x);
        
        lineThickness = 2;
        if peak == 1
            title('1430 cm-1 peak');
        else
            title('1702 cm-1 peak');
        end
        % semilogx(x, y1,'-o', 'Color', red, 'LineWidth', lineThickness);
        % hold on;
        % semilogx(x, y2,'-o', 'Color', green, 'LineWidth', lineThickness);
        % hold on;
        % semilogx(x, y3,'-o', 'Color', blue, 'LineWidth', lineThickness);
        % hold on;
        plot(x, y1,'-o', 'Color', red, 'LineWidth', lineThickness);
        hold on;
        plot(x, y2,'-o', 'Color', green, 'LineWidth', lineThickness);
        hold on;
        plot(x, y3,'-o', 'Color', blue, 'LineWidth', lineThickness);
        hold on;
    end
