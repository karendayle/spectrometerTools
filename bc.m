function bc(tics)

lambda=1e8; 
p=0.001; 
d=2;
prog.chroms=tics;
prog.point=1;

%prog.temp_tic=asysm(tics(1,:)',lambda,p,d);
prog.temp_tic=asysm(tics,lambda,p,d);
prog.temp_tic=prog.temp_tic';

figure

axe_superimpose=axes('position',[0.1 0.55 0.7 0.35]);  
%plot(axe_superimpose,tics(1,:));
plot(axe_superimpose,tics);
hold(axe_superimpose,'on');
plot(axe_superimpose,prog.temp_tic,'r');
hold(axe_superimpose,'off');

axe_bc=axes('position',[0.1 0.1 0.7 0.35]);
%plot(axe_bc,tics(1,:)-prog.temp_tic);
plot(axe_bc,tics(:)-prog.temp_tic(:)); % kdk: this works but why do I need
                                       % the ':'?
%tics
%prog.temp_tic