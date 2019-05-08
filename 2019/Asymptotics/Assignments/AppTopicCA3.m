%%
%%1c
epsilon = 0.1;
%obtain a numerical solution to the bvp
solinit1=bvpinit(linspace(0,1,11),[0 1]);
sol1=bvp4c(@(x,y)BVPODE1(x,y,epsilon),@boundaries1,solinit1);
xout1=linspace(0,1,1001);
yout1=deval(sol1,xout1);

plot(xout1,yout1(1,:))

saveas(gcf,"TopicCA3Q1.eps",'epsc')
%%
%%2
epsilon = 0.1;
%numerical solution to the bvp
solinit2=bvpinit(linspace(-2,2,11),[0 1]);
sol2=bvp4c(@(x,y)BVPODE2(x,y,epsilon),@boundaries2,solinit2);
xout2=linspace(-2,2,1001);
yout2=deval(sol2,xout2);

plot(xout2,yout2(1,:))
saveas(gcf,"TopicCA3Q2.eps",'epsc')



%%%FUNCTIONS
function res=boundaries1(ya,yb)
res=[ya(1)-1;yb(1)-1];
end
function dy=BVPODE1(x,y,epsilon)
dy=zeros(2,1);
dy(1)=y(2);
dy(2)=(1/epsilon)*(-(cosh(x)*y(2))-y(1));
end


function res=boundaries2(ya,yb)
res=[ya(1)+4;yb(1)-2];
end
function dy=BVPODE2(x,y,epsilon)
dy=zeros(2,1);
dy(1)=y(2);
dy(2)=(1/epsilon)*(-x*y(2)-x*y(1));
end