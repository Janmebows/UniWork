clear all;
close all;

fsode = @(x,y,beta) [ y(2); y(3); -y(1)*y(3) - beta*(1 - y(2).^2)];
fsbc = @(ya,yb) [ ya(1), ya(2), yb(2) - 1 ];
fsinit = @(x) [ -2 + x + exp(-x); 1 - exp(-x); exp(-x) ];

a = 0;
b = 8;
solinit = bvpinit(linspace(a,b,10), fsinit);

%for beta = 0:-0.002:-0.198
beta = 0;
sol = bvp4c(@(x,y) fsode(x,y,beta), fsbc, solinit);
solinit = bvpinit(sol, [a,b]);
%end

x = linspace(a, b, 100);
y = deval(sol, x);
plot(x, y(2,:))
d = x(end)-y(1,end)

