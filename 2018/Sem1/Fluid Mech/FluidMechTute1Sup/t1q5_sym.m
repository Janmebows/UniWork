% Finds streamline, pathline and streaklines symbolically.

clear all
close all

% Define Eulerian velocity in T1, Q5.

syms u(x, y, t) v(x, y, t) w
u(x, y, t) = sin(w*t - w*y)
v(x, y, t) = 1

% Pathlines

syms X(t) Y(t) X0 Y0
odes = [diff(X, t) == u(X, Y, t), ...
        diff(Y, t) == v(X, Y, t)];
ics = [X(0) == X0, Y(0) == Y0];
[X(t), Y(t)] = dsolve(odes, ics)

% Streaklines

syms xs ys tau
sol = solve([xs == X(tau), ys == Y(tau)], [X0, Y0]);
xx(tau) = subs(X(t), [X0, Y0], [sol.X0, sol.Y0])
yy(tau) = subs(Y(t), [X0, Y0], [sol.X0, sol.Y0])

% Streamlines

syms x(s) y(s) x0 y0
odes = [diff(x, s) == u(x, y, t), ...
        diff(y, s) == v(x, y, t)];
ics = [x(0) == x0, y(0) == y0];
[x(s), y(s)] = dsolve(odes, ics)

% Part (a)

stream = simplify(subs([x(s), y(s)], [x0, y0, t], [0, 0, pi/2/w]))

% Part(b)

syms T
sol = solve([0 == X(T), 0 == Y(T)], [X0, Y0]);
path = simplify(subs([X(t), Y(t)], [X0, Y0], [sol.X0, sol.Y0]))
path = subs(path, T, pi/2/w);

% Part (c)

streak = simplify(subs([xx(tau), yy(tau)], [xs, ys, t], [0, 0, pi/2/w]))

% Put w = 1 for plotting

w = 1; 
stream = subs(stream);
path = subs(path);
streak = subs(streak);
hold on
fplot(stream(1), stream(2), [0 3*pi])
fplot(path(1), path(2), [0 2*pi])
fplot(streak(1), streak(2), [0 pi/2])
hold off
box on
grid on
axis([-4 4 0 8])
yticks(0:2:8)
xticks(-4:2:4)
axis square
legend('Streamline', 'Pathline', 'Streakline')
legend boxoff
xlabel('x')
ylabel('y')

