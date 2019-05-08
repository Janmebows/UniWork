% Physically solves periodic solutions for
% the Kuramoto-Sivashinsky equation 
% Uses spectral methods
%
% edited from SPECTRAL_BURGERS 
% original author: 
% Trent Mattner
% Edited by:
% Andrew Martin
% 24/05/2018

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


for L=[3,12,14,15,20,60]
s=rng('shuffle');
N=6*L;
alpha = 2*pi / L;
f = @(x) 0.01*(2*rand(size(x))-1);
[x, t, u] = solve_kdv(N,alpha, 1000, 400, f);

%Label plots
fig = figure ;
contourf(x, t, u, 'EdgeColor','none')
c=colorbar();
c.Label.String = 'u';
xlabel('$x$')
ylabel('$t$')
zlabel('$u(x,t)$')
title(['Kuramoto-Sivashinsky Solution for $L=$' num2str(L)])
box on
%Just print them out so I have them for reference
saveas(fig,['A4KSL' num2str(L) '.jpg'])
end
function [x, t, u] = solve_kdv(N,alpha, nt, T, f)

% kurasiva solves Kuramoto-Sivashinsky equation on a
% 2*pi-periodic domain.
%
% Inputs:
%   N - number of collocation points.
%   nt - number of times for output.
%   T - final time.
%   f - function handle specifying IC.
%
% Outputs:
%   t - row vector containing output times.
%   x - row vector containing grid points.
%   u - matrix containing solution at t(j)
%       in row u(j,:).

% Set up grid.

h = 2*pi/N;
x = h*(0:N-1);
ik = 1i*[0:N/2-1 0 -N/2+1:-1]';
k2 = -[0:N/2 -N/2+1:-1]'.^2;
k4 = k2.^2;
t = linspace(0, T, nt);
% Numerical solution in physical space.

[~, u] = ode15s(@kurasiva, t, f(x));

    function dudt = kurasiva(t, u)
        
        uh = fft(u);
        ux = ifft(ik.*uh, 'symmetric');
        uxx = ifft(k2.*uh , 'symmetric');
        ux4 = ifft(k4.*uh, 'symmetric');
        dudt = -alpha*u.*ux -alpha^2*uxx - alpha^4 * ux4;
        
    end

end