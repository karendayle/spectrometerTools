% Draw from scratch since Matlab has no hatched fill option
% Based on https://www.mathworks.com/matlabcentral/answers/3701-textures-for-bar-plots
% Dayle Kotturi 2020/10/17

figure

yd = [3 4 5; 6 7 8]; % dummy data
bw = 0.18; % deduce by trial and error plotting over actual drawn bar
barHeights = yd;
B = bar(barHeights);

% helpful: https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
for ib = 1:numel(B)
    % important: xData is has the center pts of each bar of group 1 in
    % row 1 and the center pt of each bar of group 2 in row 2
    xData(:,ib) = B(ib).XData+B(ib).XOffset;
end

% Now generalize it in a loop
[rows, cols] = size(barHeights);
for i = 1:rows
    for j = 1:cols
        fprintf('row %d, col %d', i, j);
        % draw the slanted lines that go all the way across
        y1 = 0; 
        ymax = yd(i,j); 
        
        % this is the only "weakpoint". The dy depends on ymax value,
        % so the hatchline spacing will vary across bars. This could be
        % changed by using same dy for all bars, but the range of k needs
        % to change as well
        dy = (ymax - y1)/10;
        for k = 1:10
            x1 = xData(i,j) - bw/2;
            x2 = xData(i,j) + bw/2;   
            % don't draw a line that exceeds ymax
            y2 = min(y1 + dy, ymax);
            fprintf ('%d-%d.%d bw=%f x1=%f x2=%f y1=%f y2=%f\n', i, j, k, bw, x1, x2, y1, y2);
            line([x1 x2], [y1 y2],'linewidth',1,'color','k');
            y1 = y1 + dy;
        end
        fprintf ('\n');
%         % draw the partial slanted line at the top
%         line(xd(i)+[-bw/2 0],[yd(i)-0.5 yd(i)],'linewidth',5,'color','k');
%         % draw the partial slanted line at the bottom
%         line(xd(i)+[0 bw/2],[0 .5],'linewidth',5,'color','k');
    end
end