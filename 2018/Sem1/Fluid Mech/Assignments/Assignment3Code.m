%%Q1 part d
%streamfunction in a for 0<=r<=a
%and streamfnction in c for 0<=r<=4a
set(groot, 'DefaultLineLineWidth', 1, ...
    'DefaultAxesLineWidth', 1, ...
    'DefaultAxesFontSize', 12, ...
    'DefaultTextFontSize', 12, ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultColorbarTickLabelInterpreter', 'latex', ...
    'DefaultAxesTickLabelInterpreter','latex');
% Parameters
a = 1;
U = 1;

[r1,theta] = meshgrid(linspace(0,a),linspace(0,2*pi));
[r2,~] = meshgrid(linspace(a,4*a),linspace(0,2*pi));
psi1= (-3/2) *  (U/2) * sin(theta).^2 *(r1.^2 - r1.^4/a^2);
psi2= 0.5 * U * r2.^2 .*(1- a^3./r2.^3).*sin(theta).^2;




% Create grid points in spherical coordinate system
z1 = r1.*cos(theta);
x1 = r1.*sin(theta);
z2 = r2.*cos(theta);
x2 = r2.*sin(theta);



% Create contour plot
contour(z1,x1,psi1, linspace(1e-6, 10, 30))
hold on
contour(z2,x2,psi2, linspace(1e-6, 10, 30))
axis equal
axis([-4*a, 4*a, -4*a, 4*a])
xlabel('$z$')
ylabel('$x$')
c = colorbar;
ylabel(c, '$\psi$', 'Interpreter', 'Latex');
set(gcf, 'units', 'inches', 'position', [4 4 6 3])



%%Q2 part f

yhat = linspace(0,1);
that1 = linspace(0,1);
