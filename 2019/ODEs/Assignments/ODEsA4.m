close all
clear all

%Make plots less repulsive
set(groot, 'DefaultLineLineWidth', 1, ...
    'DefaultAxesLineWidth', 1, ...
    'DefaultAxesFontSize', 12, ...
    'DefaultTextFontSize', 12, ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultColorbarTickLabelInterpreter', 'latex', ...
    'DefaultAxesTickLabelInterpreter','latex');


%%1a
%calculate picard iterates of the DE
%y' = x-y+1, y(1) = 2
syms x s
yp = 2
for k=1:3
   yp =2+ int(s-yp+1,s,1,x)
end    


%%1b
%verify solution using sym
syms y(x)
eqn = diff(y,x,1) == x - y +1;
%solve the DE with IC y(1)=2
y = dsolve(eqn, y(1)==2)
taylor(y)

%compare taylor solution to picard

%try statement in case i've already ran this section

yp = matlabFunction(yp);

y = matlabFunction(y);
x = linspace(0,5);
plot(x,yp(x))
hold on 
plot(x,y(x))
xlabel("$$x$$")
legend("Picard solution","Taylor solution")
saveas(gcf,"ODEsA4Q1b,eps",'epsc')
%%
%%2a
%solve the system Ax=b for the coefficients 
%x = [a0;a1;a2;a3]
syms h
A = [1, 1,   1,   1;
     0, 1,   2,   3;
     0, 1/2, 4/2, 9/2;
     0, 1/6, 8/6, 27/6];
 b = [0;0;0;1/h^3];
aVals = A\b
sum(aVals)

%%
%%3b

vals = zeros(1,1000);
h = zeros(1,1000);
for nPts =1:1000
   x = FrogLeap(nPts,1);
   vals(nPts) = x(end);
   h(nPts) = 1/nPts;
end
err = abs(vals - exp(-1));
plot(log(h),log(err))
xlabel("$$log(h)$$")
ylabel("$$log(err)$$")
saveas(gcf,"ODEsA4Q3b.eps",'epsc')

%%
%%3c
npts = 1000;
endTime = 100;

x = FrogLeap(npts,endTime);

t = linspace(1,endTime,npts);
xAnalytic= exp(-t);
plot(log(t),log(xAnalytic),':b')
hold on
plot(log(t),log(x),'r')
axis([0,5,-inf,inf])

xlabel("$$log(t)$$")
ylabel("$$log(x)$$")
legend("Analytic Solution","Leapfrog solution",'location','Northwest')
saveas(gcf,"ODEsA4Q3c.eps",'epsc')
hold off

plot(t,x,'r')
axis([80,100,-inf,inf])

xlabel("$$t$$")
ylabel("$$x$$")
saveas(gcf,"ODEsA4Q3c2.eps",'epsc')
hold off



function x = FrogLeap(npts,endTime)

h = endTime/npts;
x = zeros(1,npts);
%matlab uses 1 based indexing so x0 == x(1)
x(1) = 1;
x(2) = (1-h)*x(1);
for n = 3:npts    
    x(n) = x(n-2) - 2*h*x(n-1); 
end
end
