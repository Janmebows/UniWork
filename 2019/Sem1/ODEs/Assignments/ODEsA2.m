%%Q1a
close all
x = linspace(-1,3);
r = log(1+x) -x;
figure
hold on
plot(r(x<0),x(x<0),'b')
plot(r(x>0),x(x>0),':b')
plot(0,0,'xb')
xlabel('r')
ylabel('x')
title("Bifurcations for problem 1")
legend(["Stable branch","Unstable branch","Bifurcation"])
grid on
saveas(gcf,"ODEsA2Q1a.eps","epsc")
%%Q1b
figure 
hold on
r = linspace(0,2);
plot([min(r),1],[0,0],':b')
plot([1,max(r)],[0,0],'b')
plot(r(r<1),1-1./r(r<1),'b','HandleVisibility','off')
plot(r(r>1),1-1./r(r>1),':b','HandleVisibility','off')
plot(1,0,'xb')
axis([-inf,inf,-2,2])
title("Bifurcations for problem 2")
legend(["Stable branch","Unstable branch","Bifurcation"])
xlabel('r')
ylabel('x')
grid on
saveas(gcf,"ODEsA2Q1b.eps","epsc")


%%Q1c

figure
hold on
plot([-0.5,0],[0,0],'b')
plot([0,0.5],[0,0],':b')
x = linspace(0,0.5);
%handlevisibility off makes the legend clean
plot(x,0.5*sqrt(x),'b','HandleVisibility','off')
plot(x,-0.5*sqrt(x),'b','HandleVisibility','off')
plot(0,0,'xb')
title("Bifurcations for problem 3")
legend(["Stable branch","Unstable branch","Bifurcation"])
xlabel('r')
ylabel('x')
grid on
saveas(gcf,"ODEsA2Q1c.eps","epsc")

%%Q2ai

% r = 0.4;
% [t,x] = meshgrid(linspace(0,5,20));
% f = -r.*x + (x.^2)./(1+x.^2);

% figure
% for s=linspace(0,0.2)
%     %f = f+s;
%     f = s-r.*x + (x.^2)./(1+x.^2);
%     df = f./(sqrt(f.^2 + ones(size(ftakes)).^2));
%     dt = ones(size(ftakes))./(sqrt(f.^2 + ones(size(ftakes)).^2));
%     quiver(t,x,dt,df)
%     drawnow
%     pause(0.05)
% end
%%Q2aii
syms x
%obtain approximate numerical solutions
%for the bifurcation
r= 0.4;
approxxbar = fsolve(@(x) -r + 2*x/((1+x^2)^2), 0.2)
approxsbar = r*approxxbar - (approxxbar^2)/(1+approxxbar^2)
%max value of x after increasing s to 0.2
maxx=fsolve(@(x) 0.2 - r*x + (x.^2)./(1+x.^2), 2.5)


x = linspace(-0.1,3,500);

figure
hold on
xsq = x.^2;
for s=[0,approxsbar,0.2]
dx = s - r*x + (xsq)./(1+xsq);
plot(x,dx)
end
legend(["s=0","s="+num2str(approxsbar),"s=0.2"])
xlabel("x")
ylabel("$$\frac{dx}{d\tau}$$",'interpreter','latex')
title('Effect of s on $$\frac{dx}{d\tau}$$','interpreter','latex') 
grid on
saveas(gcf,"ODEsA2Q2a.eps","epsc")
%%Q2bii
r = 2*x./((xsq + 1).^2);
s =  xsq.*(1 - xsq)./((xsq+1).^2);

figure
hold on
plot(r,s)
plot([0.4,0.4],[0,0.12],':b')
xlabel('r(x)')
ylabel('s(x)')
axis([0,0.8,0,0.12])
text(0.35,0.02,"Bi-stable")
text(0.2,0.06,"Unstable")
text(0.65,0.05,"Stable")
saveas(gcf,"ODEsA2Q2b.eps","epsc")