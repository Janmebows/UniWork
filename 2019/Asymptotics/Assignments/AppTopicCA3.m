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

plot(xout1,yout1(1,:),'k')
hold on
%my solutions
x = linspace(0,1);
a = exp(-2*atan(tanh(1/2)));
youter = a*exp(2*atan(tanh(x/2)));
A = 0;
yinner = A*exp(x)+ (1-A)*exp(-x);
plot(x,youter,'r')
plot(x,yinner,'b')
hold off
saveas(gcf,"TopicCA3Q1.eps",'epsc')
%%
%%2
epsilon = 0.1;
%numerical solution to the bvp
solinit2=bvpinit(linspace(-2,2,11),[0 1]);
sol2=bvp4c(@(x,y)BVPODE2(x,y,epsilon),@boundaries2,solinit2);
xout2=linspace(-2,2,1001);
yout2=deval(sol2,xout2);
figure
plot(xout2,yout2(1,:))
hold on
x = linspace(-2,2);
xstar = -2;
yL = -4*exp(-2)*exp(-x);
yR = 2*exp(2)*exp(-x);
Y = 1*exp(-xstar*x) +0;
plot(x,yL)
plot(x,yR)
%plot(x,Y)
saveas(gcf,"TopicCA3Q2.eps",'epsc')
axis([-2,2,-4,10])


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