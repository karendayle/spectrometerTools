% Draw from scratch since Matlab has no hatched fill option
% Based on https://www.mathworks.com/matlabcentral/answers/3701-textures-for-bar-plots
% Dayle Kotturi 2020/10/17

figure
barHeights = [3 4 5; 6 7 8];
B = bar(barHeights);

xd = get(B,'xdata');
yd = get(B,'ydata');
bw = get(B,'barwidth');
% default barwidth is 0.8
% B.barwidth = 1.; this doesn't work
% This is done by grouping the y values with semi colons btw groups


% Now generalize it in a loop
[rows, cols] = size(barHeights);
for i = 1:cols
    % Bar i
    % draw the slanted lines that go all the way across
    for ii = 1:yd(i)*2-1
        x1 = xd(i)-bw/2;
        x2 = xd(i)+bw/2;
        y1 = (ii-1)/2;
        y2 = 1+(ii-1)/2;
        fprintf ('%d-%d. bw=%f x1=%f x2=%f y1=%f y2=%f\n', i, ii, bw, x1, x2, y1, y2);
        line(xd(i)+[-bw bw]/2,[0 1]+(ii-1)/2,'linewidth',5,'color','k');
    end
    fprintf ('\n');
    % draw the partial slanted line at the top
    line(xd(i)+[-bw/2 0],[yd(i)-0.5 yd(i)],'linewidth',5,'color','k');
    % draw the partial slanted line at the bottom
    line(xd(i)+[0 bw/2],[0 .5],'linewidth',5,'color','k');
end