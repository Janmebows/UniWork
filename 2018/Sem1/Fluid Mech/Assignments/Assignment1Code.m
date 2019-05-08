% Finds streamline, pathline and streakline numerically.

close all
clear all

% Define Eulerian velocity in T1, Q5.

u = @(t, x) [x(1)+sin(t); -x(2)];

% All curves pass through x0 = [0, 0] at time T = 0.5*pi/w

x0 = [-1/2, 2];
T = pi;

% Streamline

s = linspace(0, 8, 100);
[s, x] = ode45(@(s, x) u(T, x), s, x0);
plot(x(:,1), x(:,2))
hold on

% Pathline

t = linspace(0, pi, 100);
[t, x] = ode45(u, t, x0);
plot(x(:,1), x(:,2))

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
plot(xs, ys)
hold off

box on
grid on
axis([-3 3 0 2])
%yticks(0:2:8)
%xticks(-4:2:4)
axis square
legend('Streamline', 'Pathline', 'Streakline')
legend boxoff
title('Pathline Streamline and Streakline')
xlabel('x')
ylabel('y')


%%%%%Plot streamlines at t=0 and t=pi/2%%%%%

figure 
axis([-3 3 0 2])
hold on
T=0;
s = linspace(0, 8, 100);
[s, x] = ode45(@(s, x) u(T, x), s, x0);
plot(x(:,1), x(:,2))

T = pi/2;
s = linspace(0, 8, 100);
[s, x] = ode45(@(s, x) u(T, x), s, x0);
plot(x(:,1), x(:,2))

hold off
axis square
legend('t=0','t=pi/2')
legend boxoff
title('Streamlines at t=0 and t = pi/2')
xlabel('x')
ylabel('y')

%%%%%ANIMATED%%%%%

figure 
hold on
axis([-3 3 0 2])
for T=0:0.02:2*pi


s = linspace(0, 8, 100);
[s, x] = ode45(@(s, x) u(T, x), s, x0);
plot(x(:,1), x(:,2))
drawnow
pause(0.05)
end
hold off
axis square
title('Streamlines from t=0 to t = pi/2')
xlabel('x')
ylabel('y')

