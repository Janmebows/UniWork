% SPECTRAL_DIFF computes Fourier pseudospectral derivatives.
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
    'DefaultAxesTickLabelInterpreter','latex');

% Set up grid and data.
  
N = 10;
dx = 2*pi/N;
x = dx*(0:N-1);
u = exp(sin(x));

% Create the vector i*k for wavenumbers
% from k = -N/2+1 ... N/2-1. Replace wavenumber
% N/2 with zero for first (odd) derivative.

ik = 1i*[0:N/2-1 0 -N/2+1:-1];

% Create the vector (ik)^2 = -k^2 for wavenumbers
% from k = -N/2+1 ... N/2.

k2 = [0:N/2 -N/2+1:-1].^2;

% First derivative.

uh = fft(u);
uxh = ik.*uh;
ux = ifft(uxh, 'symmetric');

% Second derivative.

uh = fft(u);
uxxh = -k2.*uh;
uxx = ifft(uxxh, 'symmetric');

% Exact derivatives.

xe = linspace(0, 2*pi, 100);
uxe = cos(xe).*exp(sin(xe));
uxxe = -sin(xe).*exp(sin(xe)) + cos(xe).^2.*exp(sin(xe));  

% Plot exact and estimated first derivative.

figure
plot(xe, uxe, '-k', x, ux, 'ok')
xlabel('$x$')
ylabel('$u$')
title('$u''(x)$')
axis([0 2*pi -1.5 1.5])
axis square
grid on
set(gcf, 'units', 'inches', 'position', [4 4 4 4])
print -depsc ../Figures/spectral_ux.eps

% Plot exact and estimated second derivative.

figure
plot(xe, uxxe, '-k', x, uxx, 'ok')
xlabel('$x$')
ylabel('$u$')
title('$u''''(x)$')
axis([0 2*pi -3 3])
axis square
grid on
set(gcf, 'units', 'inches', 'position', [4 4 4 4])
print -depsc ../Figures/spectral_uxx.eps








