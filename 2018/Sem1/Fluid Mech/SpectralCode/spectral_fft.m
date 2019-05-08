% SPECTRAL_FFT computes Fourier coefficients.
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

N = 8;
dx = 2*pi/N;
x = dx*(0:N-1);
u = cos(3*x);

% Plot the Fourier coefficients vs wavenumber. The 
% wavenumbers need to be in the same order as the 
% Fourier coefficients:
%
% uh_0, ..., uh_N/2, uh_-N/2+1, ..., uh_-1.
%
% We also need to be mindful that fft calculates 
% N times the Fourier coefficients.

k = [0:N/2, -N/2+1:-1];
uh = fft(u);
figure
plot(k, real(uh)/N, 'ob', k, imag(uh)/N, 'or')
xlabel('$k$')
ylabel('$\hat{u}_k$')
axis square
grid on
set(gcf, 'units', 'inches', 'position', [4 4 4 4])
print -depsc ../Figures/spectral_dft.eps

% Recover the original data by taking the IDFT of uh.
% Since the original u is conjugate symmetric, we
% pass the optional argument 'symmetric' to IFFT,
% which is faster and ensures the output is real.

u = ifft(uh, 'symmetric');
figure
plot(x, u, 'ok', x, cos(3*x), 'xk')
norm(u - cos(3*x))

hold on
x = linspace(0, 2*pi, 100);
plot(x, cos(3*x), '-k')
hold off
xlabel('$x$')
ylabel('$u$')
axis square
grid on
set(gcf, 'units', 'inches', 'position', [4 4 4 4])
print -depsc ../Figures/spectral_idft.eps
