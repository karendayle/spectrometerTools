set(h,'LineWidth',2)
legend('0.1mM','0.5mM','1mM','5mM','10mM','Location','northwest')
set(legend,'Color','none');
axis('tight')
set(gcf,'Color',[1 1 1])
xlabel('Frequency (cm^-^1)')
ylabel('Normalised Absorbance (Arb.)')
set(gca,'FontSize',16,'FontWeight','bold','box','off')
title ('Fmoc A Conc Study')
ax=gca;
line=ax.LineWidth
ax.LineWidth=2
ax.XDir='reverse'
%ax.XLim=[1550 1725]