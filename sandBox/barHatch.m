% figure
barHeights = [3 4 5]
firstBarLHSX = 0.75
B = bar(barHeights,firstBarLHSX)

xd = get(B,'xdata')
yd = get(B,'ydata')
bw = get(B,'barwidth')

% % Bar 1
% % draw the slanted lines that go all the way across
% for ii = 1:yd(1)*2-1
%     line(xd(1)+[-bw bw]/2,[0 1]+(ii-1)/2,'linewidth',5,'color','k')
% end
% % draw the partial slanted line at the top
% line(xd(1)+[-bw/2 0],[yd(1)-0.5 yd(1)],'linewidth',5,'color','k')
% % draw the partial slanted line at the bottom
% line(xd(1)+[0 bw/2],[0 .5],'linewidth',5,'color','k')
% 
% % Bar 2
% % draw the slanted lines that go all the way across
% for ii = 1:yd(2)*2-1
%     line(xd(2)+[-bw bw]/2,[0 1]+(ii-1)/2,'linewidth',5,'color','k')
% end
% % draw the partial slanted line at the top
% line(xd(2)+[-bw/2 0],[yd(2)-0.5 yd(2)],'linewidth',5,'color','k')
% % draw the partial slanted line at the bottom
% line(xd(2)+[0 bw/2],[0 .5],'linewidth',5,'color','k')
% 
% % Bar 3
% % draw the slanted lines that go all the way across
% for ii = 1:yd(3)*2-1
%     line(xd(3)+[-bw bw]/2,[0 1]+(ii-1)/2,'linewidth',5,'color','k')
% end
% % draw the partial slanted line at the top
% line(xd(3)+[-bw/2 0],[yd(3)-0.5 yd(3)],'linewidth',5,'color','k')
% % draw the partial slanted line at the bottom
% line(xd(3)+[0 bw/2],[0 .5],'linewidth',5,'color','k')

for i = 1:3
    % Bar i
    % draw the slanted lines that go all the way across
    for ii = 1:yd(i)*2-1
        line(xd(i)+[-bw bw]/2,[0 1]+(ii-1)/2,'linewidth',5,'color','k')
    end
    % draw the partial slanted line at the top
    line(xd(i)+[-bw/2 0],[yd(i)-0.5 yd(i)],'linewidth',5,'color','k')
    % draw the partial slanted line at the bottom
    line(xd(i)+[0 bw/2],[0 .5],'linewidth',5,'color','k')
end