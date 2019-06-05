%%
%%1c
close all
clear all
epsilon = 0.1;
%obtain a numerical solution to the bvp
solinit1=bvpinit(linspace(0,1,11),[0 1]);
sol1=bvp4c(@(x,y)BVPODE1(x,y,epsilon),@boundaries1,solinit1);
xout1=linspace(0,1,1001);
yout1=deval(sol1,xout1);

plot(xout1,yout1(1,:),'--k')
hold on
%my solutions
x = linspace(0,1);
xstar = 0;
X = xstar + x/epsilon;
a = exp(-2*atan(tanh(1/2)));
youter = a*exp(2*atan(tanh(x/2)));
A = 1- exp(-2*atan(tanh(1/2)));
yinner = A*exp(-X) + 1-A;
ycomp= youter + yinner -a;

%WKB solution
u0 = a*exp(2*atan(tanh(x/2)));
F = sinh(x);
v0 = 1-a;
ywkb = u0 + exp(-F/epsilon).*v0;


plot(x,youter,'r')
plot(x,yinner,'b')
plot(x,ycomp,'g')
plot(x,ywkb,'-.m')
hold off
xlabel('x')
ylabel('y')
axis([0,1,0.5,1])
legend("Numerical Solution","Inner Solution",...
    "Outer Solution","Composite Solution","WKB Solution")
saveas(gcf,"TopicCA3Q1.eps",'epsc')
%%
%%2
epsilon = 0.01;
%numerical solution to the bvp
solinit2=bvpinit(linspace(-2,2,11),[0 1]);
sol2=bvp4c(@(x,y)BVPODE2(x,y,epsilon),@boundaries2,solinit2);
xout2=linspace(-2,2,1001);
yout2=deval(sol2,xout2);
figure
plot(xout2,yout2(1,:))
hold on
%my solutions
x = linspace(-2,2);
yL = -4*exp(-2)*exp(-x);
yR = 2*exp(2)*exp(-x);
%inner sol
a = exp(2) + 2*exp(-2);
b = exp(2) -2*exp(-2);
X = x/epsilon;

Y = a*erf(X/sqrt(2)) + b;
plot(x,yL)
plot(x,yR)
plot(x,Y)
hold off
axis([-2,2,-4,16])
legend("Numerical solution","$$y_{left}$$","$$y_{right}$$",...
    "$$Y_{inner}$$",'interpreter','latex')
saveas(gcf,"TopicCA3Q2.eps",'epsc')


%%%FUNCTIONS
function res=boundaries1(ya,yb)
res=[ya(1)-1;yb(1)-1];
end
function dy=BVPODE1(x,y,epsilon)
dy=zeros(2,1);
dy(1)=y(2);
dy(2)=(1/epsilon)*(-(cosh(x)*y(2))+y(1));
end


function res=boundaries2(ya,yb)
res=[ya(1)+4;yb(1)-2];
end
function dy=BVPODE2(x,y,epsilon)
dy=zeros(2,1);
dy(1)=y(2);
dy(2)=(1/epsilon)*(-x*y(2)-x*y(1));
end