% 2/27/2020 dayle play with natural log curve fitting
% start with some curves
x=1:100;
for a=5
    for b=5
        y1=a+b*log(x);
        figure
        plot(x,y1);
        myTitle = sprintf('a+b*log(x), a=%f, b=%f', a,b);
        title(myTitle);
        xlabel('x');
        ylabel('y');
        
        figure
        semilogx(x,y1); % straight
        myTitle = sprintf('semilogx: a+b*log(x), a=%f, b=%f', a,b); 
        title(myTitle);
        xlabel('x');
        ylabel('y');
        
        figure
        loglog(x,y1);
        myTitle = sprintf('loglog: a+b*log(x), a=%f, b=%f', a,b);
        title(myTitle);
        xlabel('x');
        ylabel('y');
        
%         y2=1-a*exp(-1.*x/b); % SHAPE FOR 1702 PEAK TIME SERIES
%         figure
%         plot(x,y2);
%         myTitle = sprintf('y=1-a*exp(-x/b), a=%f, b=%f', a,b);
%         title(myTitle);
%         xlabel('x');
%         ylabel('y');
    end
end

% now play with y1 and y2 and try to fit them to a model
%result1 = curveFitting(x, 0, y1, 1, [0.01 0.01]);
%result2 = curveFitting(x, 0, y2, 2, [0.01 0.01]);

% see which starting points work to find the correct coeffs a and b
result3 = curveFitting(x, 0, y1, 1, [1 5]); % no
pause(1);
% result3 = curveFitting(x, 0, y1, 1, [0.05 0.05]); % no
% pause(1);
% result3 = curveFitting(x, 0, y1, 1, [0.07 0.07]); % yes
% pause(1);
% result3 = curveFitting(x, 0, y1, 1, [0.1 0.1]); % yes
% pause(1);
% result3 = curveFitting(x, 0, y1, 1, [1.0 0.01]); % no
% pause(1);
% result3 = curveFitting(x, 0, y1, 1, [1.0 1.0]); % yes
% pause(1);
% % give it first point of dataset
% result3 = curveFitting(x, 0, y1, 1, [1.0 4.0937]); % yes
% pause(1);

%result4 = curveFitting(x, 0, y2, 1, [0.01 0.01]);
%pause(1);

function j = curveFitting(t, offset, y, model, startPoint)

    xCurve = (t-offset)';
    yCurve = y';
    myfittype=fittype('a +b*log(x)',...
    'dependent', {'y'}, 'independent',{'x'},...
    'coefficients', {'a','b'});
    f0=fit(xCurve,yCurve,myfittype,'StartPoint',startPoint);

%     xCurve = (t-offset)';
%     yCurve = y';
%     % xCurve and yCurve are both nx1 row-column form 
%     % StartPoint wants 2 points for this type of fit
%     f0 = fit(xCurve,yCurve,g,'StartPoint',startPoint);
% 
    % set the range to draw the exponential curve
    numRows = size(xCurve,1);
    startXX = xCurve(1);
    finishXX = xCurve(numRows);
    xx = linspace(startXX, finishXX, numRows);
    figure
    semilogx(xCurve,yCurve,'o',xx,f0(xx));
    myTitle = sprintf('use start point [%f %f]', startPoint);
    title(myTitle);
    fprintf('curve fitting results for model y=a+b*log(x):  a=%f, b=%f\n', f0.a, f0.b);
    j = f0;
end