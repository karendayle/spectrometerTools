% start with some curves
x=1:100;
for a=5
    for b=5
        y1=a*exp(-1.*x/b);
        figure
        plot(x,y1);
        myTitle = sprintf('y=a*exp(-x/b), a=%f, b=%f', a,b);
        title(myTitle);
        xlabel('x');
        ylabel('y');

        y2=1-a*exp(-1.*x/b); % SHAPE FOR 1702 PEAK TIME SERIES
        figure
        plot(x,y2);
        myTitle = sprintf('y=1-a*exp(-x/b), a=%f, b=%f', a,b);
        title(myTitle);
        xlabel('x');
        ylabel('y');
    end
end

% now play with y1 and y2 and try to fit them to a model
%result1 = curveFitting(x, 0, y1, 1, [0.01 0.01]);
%result2 = curveFitting(x, 0, y2, 2, [0.01 0.01]);

% see which starting points work to find the correct coeffs a and b
result3 = curveFitting(x, 0, y1, 1, [0.01 0.01]); % no
pause(1);
result3 = curveFitting(x, 0, y1, 1, [0.05 0.05]); % no
pause(1);
result3 = curveFitting(x, 0, y1, 1, [0.07 0.07]); % yes
pause(1);
result3 = curveFitting(x, 0, y1, 1, [0.1 0.1]); % yes
pause(1);
result3 = curveFitting(x, 0, y1, 1, [1.0 0.01]); % no
pause(1);
result3 = curveFitting(x, 0, y1, 1, [1.0 1.0]); % yes
pause(1);
% give it first point of dataset
result3 = curveFitting(x, 0, y1, 1, [1.0 4.0937]); % yes
pause(1);

%result4 = curveFitting(x, 0, y2, 1, [0.01 0.01]);
%pause(1);

function j = curveFitting(t, offset, y, model, startPoint)
    % To avoid this error: "NaN computed by model function, fitting cannot continue.
    % Try using or tightening upper and lower bounds on coefficients.", do not set
    % start point to 0. 
    % Ref=https://www.mathworks.com/matlabcentral/answers/132082-curve-fitting-toolbox-error
    switch model
        case 1
            % it's like discharging capacitor
            g = fittype('a*exp(-1*x/b)');
        case 2
            % it's like charging capacitor
            g = fittype('1 - a*exp(-1*x/b)');
     end

    xCurve = (t-offset)';
    yCurve = y';
    % xCurve and yCurve are both nx1 row-column form 
    % StartPoint wants 2 points for this type of fit
    f0 = fit(xCurve,yCurve,g,'StartPoint',startPoint);

    % set the range to draw the exponential curve
    numRows = size(xCurve,1);
    startXX = xCurve(1);
    finishXX = xCurve(numRows);
    xx = linspace(startXX, finishXX, numRows);
    figure
    plot(xCurve,yCurve,'o',xx,f0(xx));
    myTitle = sprintf('use start point [%f %f]', startPoint);
    title(myTitle);
    fprintf('a=%f, b=%f\n', f0.a, f0.b);
    j = f0;
end