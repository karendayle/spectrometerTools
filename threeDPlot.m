x = -2:0.25:2;
[X,Y] = meshgrid(x);
Z = X.*exp(-X.^2-Y.^2);
contour3(X,Y,Z,30)

%x = -2:.2:2;
%y = -2:.25:2;
%z = -2:.16:2;

%contour3(x,y,z);

%[x,y,z] = meshgrid(x,y,z);
%v = x.*exp(-x.^2-y.^2-z.^2);

%xslice = [-1.2,.8,2];    % location of y-z planes
%yslice = 2;              % location of x-z plane
%zslice = [-2,0];         % location of x-y planes

%slice(x,y,z,v,xslice,yslice,zslice)
%xlabel('x')
%ylabel('y')
%zlabel('z')