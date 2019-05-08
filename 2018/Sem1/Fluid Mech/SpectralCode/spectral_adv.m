% SPECTRAL_ADV solves the one-dimensional advection
% equation using Fourier pseudospectral method.
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

f = @(x) exp(-100*(x-1).^2);
[x, t, u] = solve_adv(128, 32, 1, 0.01, 4*pi, f, 'numerical physical');

waterfall(x, t, u)
xlabel('$x$')
ylabel('$t$')
zlabel('$u(x,t)$')
box on
axis vis3d
set(gcf, 'units', 'inches', 'position', [4 4 4 4])
%print(fileout, '-depsc')

    function [x, t, u] = solve_adv(N, nt, c, nu, T, f, soln)

    % SOLVE_ADV solves the advection equation on a
    % 2*pi-periodic domain.
    %
    % Inputs:
    %   N - number of collocation points.
    %   nt - number of times for output.
    %   c - advection velocity.
    %   T - final time.
    %   f - function handle specifying IC.
    %   soln - 'analytic serial', 'analytic vector'
    %          'numerical wave', 'numerical physical'.
    %
    % Outputs:
    %   t - row vector containing output times.
    %   x - row vector containing grid points.
    %   u - matrix containing solution at t(j)
    %       in row u(j,:).

    % Set up grid and initial condition.

    dx = 2*pi/N;
    x = dx*(0:N-1);
    k = [0:N/2-1 0 -N/2 + 1 : -1];
    ik = 1i*[0:N/2-1 0 -N/2+1:-1];
    
    t = linspace(0, T, nt);
    fh = fft(f(x));

    % Calculate the solution.

    tic;
    switch soln

        case 'analytic serial'

            % Serial calculation of analytic solution.

            u = zeros(nt, N);
            for j = 1:nt
                uh = fh.*exp(-c*ik*t(j));
                u(j,:) = ifft(uh, 'symmetric');
            end

        case 'analytic vector'

            % Vectorized calculation of analytic solution. By
            % default, IFFT acts along columns of uh. But the
            % Fourier coefficients at time t(j) are stored in
            % the row uh(j,:). The optional arguments "[], 2"
            % ensure the IFFT is calculated along the rows.

            uh = exp(-c*(t')*ik).*fh(ones(nt,1),:);
            u = ifft(uh, [], 2, 'symmetric');

        case 'numerical wave'

            % Numerical solution in wavenumber space. ODE45
            % requires the Fourier coefficients uh and
            % derivatives duhdt to be column vectors. The row
            % vector ik is transposed into a column vector
            % using (ik.'). Warning: (ik') calculates the
            % *conjugate* transpose! ODE45 outputs the solution
            % at time t(j) in row uh(j,:).

            duhdt = @(t, uh) -c*(ik.').*uh;
            [~, uh] = ode45(duhdt, t, fh);
            u = ifft(uh, [], 2, 'symmetric');

        case 'numerical physical'

            % Numerical solution in physical space.

            dudt = @(t, u) ifft((-c*(ik.') - nu*k'.^2).*fft(u),'symmetric');
            [~, u] = ode45(dudt, t, f(x));

    end
    toc

    % Compare with exact solution u(x,t) = f(x-c*t).

    %[xx, tt] = meshgrid(x, t);
    %err = u - f(mod(xx - c*tt, 2*pi));
    %fprintf('The error is %g.\n', norm(err, 2))

    end
