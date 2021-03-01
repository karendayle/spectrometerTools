global f1;
global f2;

for i=1:10
    if ishghandle(f1) 
        close(f1);
    end
    f1=figure;
    xlabel('Wavenumber (cm^-1)'); % x-axis label
    ylabel('Arbitrary Units (A.U.)'); % y-axis label
    set(gca,'FontSize',16,'FontWeight','bold','box','off')
    pause(1);
end
