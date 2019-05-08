%%Q2 part d 
%Plot stream function for two line vortices in a uniform flow
%7/06/2018
%Andrew Martin
set(groot, 'DefaultLineLineWidth', 1, ...
    'DefaultAxesLineWidth', 1, ...
    'DefaultAxesFontSize', 12, ...
    'DefaultTextFontSize', 12, ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultColorbarTickLabelInterpreter', 'latex', ...
    'DefaultAxesTickLabelInterpreter','latex');
% Parameters
gamma = 1;
d = 1;

[x,y] = meshgrid(linspace(-2*d,2*d),linspace(-2*d,2*d));
psi = gamma/(2*pi) *(y/(2*d) - 0.5* log(x.^2 + (y+d).^2) + 0.5 * log(x.^2 + (y-d).^2));


% Create contour plot
contour(x,y,psi,100)
axis equal
axis([-2*d, 2*d, -2*d, 2*d])
xlabel('$x$')
ylabel('$y$')
c = colorbar;
ylabel(c, '$\psi$', 'Interpreter', 'Latex');
hold on 
plot([-1,1]*d*sqrt(3),0,'rx')
title('Stream Function with stagnation points marked')