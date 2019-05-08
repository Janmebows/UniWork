%%Q1a
close all
x = linspace(-1,3);
rp = 1;
rm = -1;
fp = rp + x - log(1+x);
fm = rm + x - log(1+x);
f0 = x-log(1+x);
plot(x,[fp;f0;fm])
hold on
grid on
legend(["$$r = 1$$","$$r = 0$$","$$r = -1$$"],'interpreter','latex')
title("Solutions to $$r + x - log(1+x)=0$$",'interpreter','latex')
xlabel("x")
ylabel("$$f(x:r)$$",'interpreter','latex')
 syms r x
x = linspace(-1,3);
r = log(1+x) -x;
figure
hold on
plot(r(x<0),x(x<0),'b')
plot(r(x>0),x(x>0),':b')
plot(0,0,'xb')
xlabel('r(x)')
ylabel('x')
title("Bifurcations for problem 1")
legend(["Stable branch","Unstable branch","Bifurcation"])

saveas(gcf,"ODEsA2Q1a.eps","epsc")
%%Q1b
figure 
hold on
plot([-0.5,0.5],[0,0])
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
title("Bifurcations for problem 2")
legend(["Stable branch","Unstable branch","Bifurcation"])
xlabel('r(x)')
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

%%Q2bii
x = linspace(0,5);
xsq = x.^2;
r = 2*x./((xsq + 1).^2);
s =  xsq.*(1 - xsq)./((xsq+1).^2);

figure
plot(x,r)
hold on
plot(x,s)
legend(["$$r(x)$$","$$s(x)$$"],'interpreter','latex')
saveas(gcf,"ODEsA2Q2b.eps","epsc")