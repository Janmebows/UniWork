%Q1c
b = 3.59
c = 4.17
a1 = b* hypergeom([-1/2,1],3/2,1 - c^2/b^2);
a2 = c* hypergeom([-1/2,1/2],3/2,1 - b^2/c^2);
A = 2*pi*b * gamma(1)*gamma(1/2)/gamma(3/2) * (a1 + a2)
eta = 70./A
%%
%Q2
%solve the BCs symbolically
syms r(z) c b
r(z) = c*cosh((z + b)/c);
cond = [r(0) == 9; r(10) == 10];
sol = solve(cond);
%only labelling these so that they print out
B = sol.b
C = sol.c

r(z) = subs(r,b,sol.b);
r(z) = subs(r,c,sol.c);


rfunc = matlabFunction(r);
z = linspace(0,10);
close all
plot(rfunc(z),z);
hold on
plot(-rfunc(z),z);
axis([-10,10,0,9])
xlabel("r")
ylabel("z")
saveas(gcf,'A4Plot.ep','epsc')
%%
%q3 verification
syms lambda
mat = [2*(1-lambda/6), 8/3 - 5*lambda/12 ; 8/3 - 5*lambda/12 , 2*(2-4*lambda/15)]
lambda = double(solve(det(mat)==0))
