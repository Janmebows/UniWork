% SPECTRAL_BURGERS solves Burgers equation in physical space 
% using the Fourier pseudospectral method.
%
% Trent Mattner
% 01/04/2018

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

fileout = '../Figures/spectral_burgers_alias.eps';

A=25;
B=18.75;
C=12.5;
f = @(x) (3*A^2 * sech(A * 0.5 * (x-0.5)).^2) + (3*B^2 * sech(B * 0.5 * (x-1)).^2) + (3 * C^2 * sech(C* 0.5 * (x-2)).^2);
[x, t, u] = solve_kdv(128, 32, -1, 10, f);
        
waterfall(x, t, u)
xlabel('$x$')
ylabel('$t$')
zlabel('$u(x,t)$')
box on
axis vis3d
view([25 30])
set(gcf, 'units', 'inches', 'position', [4 4 4 4])
%print(fileout, '-depsc')

function [x, t, u] = solve_kdv(N, nt, nu, T, f)

% SOLVE_BURGERS solves Burgers equation on a
% 2*pi-periodic domain.
%
% Inputs:
%   N - number of collocation points.
%   nt - number of times for output.
%   nu - viscosity.
%   T - final time.
%   f - function handle specifying IC.
%
% Outputs:
%   t - row vector containing output times.
%   x - row vector containing grid points.
%   u - matrix containing solution at t(j)
%       in row u(j,:).

% Set up grid.

dx = 2*pi/N;
x = dx*(0:N-1);
ik = 1i*[0:N/2-1 0 -N/2+1:-1]';
k2 = [0:N/2 -N/2+1:-1]'.^2;
t = linspace(0, T, nt);

% Numerical solution in physical space.

[~, u] = ode45(@burgers, t, f(x));

    function dudt = burgers(t, u)
        
        uh = fft(u);
        ux = ifft(ik.*uh, 'symmetric');
        uxxx = ifft((ik).^3.*uh, 'symmetric');
        dudt = -u.*ux + nu*uxxx;
        
    end

end