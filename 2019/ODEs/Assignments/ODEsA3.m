clear all
close all

%%
%%Q1f
A = [2,-2;2,-3];
[v,lambda] = eigs(A);
%since the eigenvector doesn't care about scaling, 
%make it look nicer
v=2*v./v(1,1);
npts = 25;
[x,y] = meshgrid(linspace(-10,10,npts),linspace(-10,10,npts));
f = 2*x - 2*y;
g = 2*x - 3*y;
quiver(x,y,f,g,'HandleVisibility','off')
axis([-10,10,-10,10])
hold on
%steady and unsteady directions
quiver(v(1,1),v(2,1),-v(1,1),-v(2,1))
quiver(0,0,v(1,2),v(2,2))

%solve some example curves
t = linspace(0,5);

x = @(t,coeff) 2*coeff(1)* exp(t) + coeff(2)*exp(-2*t);
y = @(t,coeff) coeff(1)*exp(t) + coeff(2)*exp(-2*t)*2;

coeff = c1c2(0,-6);
plot(x(t,coeff),y(t,coeff),'-.')
coeff = c1c2(0,6);
plot(x(t,coeff),y(t,coeff),'-.')
coeff = c1c2(-1,-1);
plot(x(t,coeff),y(t,coeff),'-.')
coeff = c1c2(4,8);
plot(x(t,coeff),y(t,coeff),'r-.')
coeff = c1c2(2,1);
plot(x(t,coeff),y(t,coeff),'y-.')

legendlabels = ["Stable direction", ...
    "Unstable direction",...
    '$$x(0) = 0, y(0) = -6$$',...
    '$$x(0) = 0, y(0) = 6$$',...
    '$$x(0) = -1, y(0) = -1$$',...
    '$$x(0) = 4, y(0) = 8$$',...
    '$$x(0) = 2, y(0) = 1$$',...
    ];
legend(legendlabels,'location','northwest','interpreter','latex')
title("Phase portrait")
saveas(gcf,"ODEsA3Q1f.eps","epsc")

hold off

%%
%%Q2d
global alpha beta delta gamma 
alpha =1;
beta  =-1;
delta =-1; 
gamma =1;
npts=20;
[x,y] = meshgrid(linspace(0,2,npts),linspace(0,2,npts));
f = alpha*x + beta*x.*y;
g = gamma*y + delta*x.*y;

figure
quiver(x,y,f,g,'HandleVisibility','off');
hold on
plot(0,0,'xk')
plot(-gamma/delta, -alpha/beta,'xr')
xlabel("x")
ylabel("y")

plot([0,2],[-alpha/beta,-alpha/beta],':k')
plot([-gamma/delta,-gamma/delta],[0,2],':b')

%plot a couple of solution curves

[t,X] = ode45(@ode,[0,10],[0.01,0.01]);
plot(X(:,1),X(:,2))
[t,X] = ode45(@ode,[0,10],[0.1,0.05]);
plot(X(:,1),X(:,2))
[t,X] = ode45(@ode,[0,10],[0.05,0.1]);
plot(X(:,1),X(:,2))
legendlabels = ["Steady state (0,0)", ...
    "Steady State ($-\gamma/\delta,-\alpha/\beta$)",...
    "nonzero x nullcline",...
    "nonzero y nullcline",...
    '$$x(0) = 0.01, y(0) = 0.01$$',...
    '$$x(0) = 0.1, y(0) = 0.05$$',...
    '$$x(0) = 0.05, y(0) = 0.1$$'];
legend(legendlabels,'location','northeast','interpreter','latex')
title("Phase Portrait for the competitive model")
axis([-.1,2.1,-.1,2])
saveas(gcf,"ODEsA3Q2d.eps","epsc")

%%%%
%%FUNCTIONS
%%%%
%get the coefficients for Q1
function coeff = c1c2(x0,y0)
A = [2,1;1,2];
b = [x0;y0];
coeff = A\b;
end

%Q2 ODE for numerical solving 
function dx =ode(t,x)
global alpha beta delta gamma
dx = [alpha*x(1) + beta*x(1).*x(2) ; gamma*x(2) + delta*x(1).*x(2)];
end

