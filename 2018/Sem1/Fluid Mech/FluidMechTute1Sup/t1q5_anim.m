% Animates streamlines, pathline and streakline from T1, Q5 numerically.

close all
clear all

% Define Eulerian velocity in T1, Q5. The definition used here allows us to
% do multiple particles. The positions of each particle are stored in a
% column vector with elements
%
% [x(1), x(2), ..., x(n), y(1), y(2), ..., y(n)]'
%
% The velocities are stored in the same way.

w = 1;
u = @(t, x) [ sin(w*t - w*x(end/2+1:end)); ones(size(x(1:end/2))) ];

% Loop through times and write to movie. The VideoWriter command has a 
% number of options. If you're operating system supports it, 
% I'd recommend 'MPEG-4'.

vid = VideoWriter('t1q5.avi');
open(vid);
for T = 0.05:0.05:3*pi

    % Streamlines. Here n streamlines are calculated. The vector x0
    % contains the initial points on each streamline. These are evenly
    % spaced along the x-axis.

    n = 25;
    x0 = [linspace(-6, 6, n)'; zeros(n, 1)];
    s = linspace(0, 8, 100);
    [s, x] = ode45(@(s, x) u(T, x), s, x0);
    plot(x(:,1:end/2), x(:,end/2+1:end), '-k')
    hold on

    % Pathline

    x0 = [0; 0];
    t = linspace(T, T+10, 100);
    [t, x] = ode45(u, t, x0);
    plot(x(:,1), x(:,2), 'r-')

    % Streakline
    
    n = 50;
    dt = T/n;
    ts = (0:n-1)*dt;
    xs = zeros(n, 1);
    ys = zeros(n, 1);
    for k = 1:n
        [t, x] = ode45(u, [ts(k), T], x0);
        xs(k) = x(end,1);
        ys(k) = x(end,2);
    end
    plot(xs, ys, 'b-')
    hold off

    box on
    grid on
    axis([-4 4 0 8])
    yticks(0:2:8)
    xticks(-4:2:4)
    axis square
    xlabel('x')
    ylabel('y')   
    drawnow
    writeVideo(vid, getframe(gcf));
end
close(vid);