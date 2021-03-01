for gel = 1:4
    for series = 1:3
        for pH = 1:9
            for peak = 1:2
                for coeff = 1:6
                    a = gel*1000+series*100+peak*10+pH+0.1;
                    a_low = gel*1000+series*100+peak*10+pH+0.2;
                    a_high = gel*1000+series*100+peak*10+pH+0.3;
                    b = gel*1000+series*100+peak*10+pH+0.4;
                    b_low = gel*1000+series*100+peak*10+pH+0.5;
                    b_high = gel*1000+series*100+peak*10+pH+0.6;
                    
                    vals(gel, series, pH, peak, 1) = a;
                    vals(gel, series, pH, peak, 2) = a_low;
                    vals(gel, series, pH, peak, 3) = a_high;
                    vals(gel, series, pH, peak, 4) = b;
                    vals(gel, series, pH, peak, 5) = b_low;
                    vals(gel, series, pH, peak, 6) = b_high;
                end
                fprintf('%f %f %f %f %f %f\n', a, a_low, a_high, b, b_low, b_high);
            end
        end
    end
end

% compare all the pH 4  values: these are in pH= 2, 6, 9
for gel = 1:4
    for series = 1:3        
        for peak = 1:2
            for coeff = 1:3:6
                % compare vals(gel,series,2,peak,coeff) to vals(gel,series,6,peak,coeff)
                % and to vals(gel,series,9,peak,coeff)
                fprintf('PH4 plot: %f with error bars low %f and high %f\n', vals(gel, series, 2, peak, coeff), ...
                    vals(gel, series, 2, peak, coeff+1), ...
                    vals(gel, series, 2, peak, coeff+2));
                fprintf('     and: %f with error bars low %f and high %f\n', vals(gel, series, 6, peak, coeff), ...
                    vals(gel, series, 6, peak, coeff+1), ...
                    vals(gel, series, 6, peak, coeff+2));
                fprintf('     and: %f with error bars low %f and high %f\n', vals(gel, series, 9, peak, coeff), ...
                    vals(gel, series, 9, peak, coeff+1), ...
                    vals(gel, series, 9, peak, coeff+2));
                
                figure
                xPH4 = [ 2 6 9 ];
                yPH4 = [vals(gel, series, 2, peak, coeff) ...
                    vals(gel, series, 6, peak, coeff) ...
                    vals(gel, series, 9, peak, coeff)];
                negErrPH4 = [vals(gel, series, 2, peak, coeff+1) ...
                    vals(gel, series, 6, peak, coeff+1) ...
                    vals(gel, series, 9, peak, coeff+1)];
                posErrPH4 = [vals(gel, series, 2, peak, coeff+2) ...
                    vals(gel, series, 6, peak, coeff+2) ...
                    vals(gel, series, 9, peak, coeff+2)];
                %plot(xAllPH, yPH4, '-o');
                errorbar(xAllPH, yPH4, negErrPH4, posErrPH4, '-o');
            end
        end
    end
end
        
% compare all the pH 7  values: these are in pH= 1, 4, 8
for gel = 1:4
    for series = 1:3
        for peak = 1:2
            for coeff = 1:3:6
                % compare vals(gel,series,1,peak,coeff) to vals(gel,series,4,peak,coeff)
                % and to vals(gel,series,8,peak,coeff)
                fprintf('PH7 plot: %f with error bars low %f and high %f\n', vals(gel, series, 1, peak, coeff), ...
                    vals(gel, series, 1, peak, coeff+1), ...
                    vals(gel, series, 1, peak, coeff+2));
                fprintf('     and: %f with error bars low %f and high %f\n', vals(gel, series, 4, peak, coeff), ...
                    vals(gel, series, 4, peak, coeff+1), ...
                    vals(gel, series, 4, peak, coeff+2));
                fprintf('     and: %f with error bars low %f and high %f\n', vals(gel, series, 8, peak, coeff), ...
                    vals(gel, series, 8, peak, coeff+1), ...
                    vals(gel, series, 8, peak, coeff+2));
            end
        end
    end
end

% compare all the pH 10 values: these are in pH= 3, 5, 7
for gel = 1:4
    for series = 1:3
        for peak = 1:2
            for coeff = 1:3:6
                % compare vals(gel,series,3,peak,coeff) to vals(gel,series,5,peak,coeff)
                % and to vals(gel,series,7,peak,coeff)
                fprintf('PH10 plot: %f with error bars low %f and high %f\n', vals(gel, series, 3, peak, coeff), ...
                    vals(gel, series, 3, peak, coeff+1), ...
                    vals(gel, series, 3, peak, coeff+2));
                fprintf('      and: %f with error bars low %f and high %f\n', vals(gel, series, 5, peak, coeff), ...
                    vals(gel, series, 5, peak, coeff+1), ...
                    vals(gel, series, 5, peak, coeff+2));
                fprintf('      and: %f with error bars low %f and high %f\n', vals(gel, series, 7, peak, coeff), ...
                    vals(gel, series, 7, peak, coeff+1), ...
                    vals(gel, series, 7, peak, coeff+2));
            end
        end
    end
end

    

    