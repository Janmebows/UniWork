% Finds streamline, pathline and streakline from T1, Q5 numerically.

close all
clear all

% Define Eulerian velocity in T1, Q5.

w = 1;
u = @(t, x) [x(1)+sin(t); -x(2)];

% All curves pass through x0 = [0, 0] at time T = 0.5*pi/w

x0 = [0, 0];
T = 1;

% Streamline

s = linspace(0, 8, 100);
[s, x] = ode45(@(s, x) u(T, x), s, x0);
plot(x(:,1), x(:,2))
hold on

% Pathline

t = linspace(T, T + 10, 100);
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
%axis([-4 4 0 8])
%yticks(0:2:8)
%xticks(-4:2:4)
axis square
legend('Streamline', 'Pathline', 'Streakline')
legend boxoff
xlabel('x')
ylabel('y')