% Plots the streamline pattern for the Stuart vortex.

close all
clear all

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

% Create grid points in spherical coordinate system for a < r < 8a,
% 0 <= t <= pi and phi = 0, then evaluate stream function.

[r, t] = meshgrid(linspace(a, 8*a, 50), linspace(0, pi, 100));
z = r.*cos(t);
x = r.*sin(t);
psi = 0.5*U*sin(t).^2.*(r.^2 - a^3./r);

% Create contour plot

contour(z, x, psi, linspace(1e-6, 10, 30))
axis equal
axis([-4*a, 4*a, 0, 4*a])
xlabel('$z$')
ylabel('$x$')
c = colorbar;
ylabel(c, '$\psi$', 'Interpreter', 'Latex');
set(gcf, 'units', 'inches', 'position', [4 4 6 3])
print('t3q1.eps', '-depsc')

