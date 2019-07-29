close all
clear all

xi=linspace(-4,4,21);
eta=linspace(-1,4,21);
[xim,etam]=meshgrid(xi,eta);
t=xim + 1i*etam;
phi=@(t) 2*1i*t.*(1-t.^2/6 +3i*t/4);
s0=surf(xim,etam,real(phi(t)));
% set(s0,'facealpha',0.5);
xlabel('\xi')
ylabel('\eta')
zlabel('Re(\phi)')
hold on
%plot saddles
scatter3([0,0],[1,2],[real(phi(1i)), real(phi(2i))],'k','filled')
ss = linspace(-1,4,101)
xieq1 = sqrt(3*(ss-1).*(ss-2));
xieq2 = - xieq1;
plot3(xieq1,ss,real(phi(xieq1+1i*ss )),'r','linewidth',3)
plot3(xieq2,ss,real(phi(xieq2+1i*ss)),'g','linewidth',3)


title("Real part")
axis([-4,4,-1,4,-inf,inf])
view([-30 60])
hold off
saveas(gcf,"TopicCA5Q1real.eps",'epsc')
%Confirm the imaginary part is good
figure
surf(xim,etam,imag(phi(t)))
hold on
scatter3([0,0],[1,2],[imag(phi(1i)), imag(phi(2i))],'k','filled')
plot3(xieq1,ss,imag(phi(xieq1+1i*ss )),'r','linewidth',3)
plot3(xieq2,ss,imag(phi(xieq2+1i*ss)),'g','linewidth',3)


hold off
axis([-4,4,-1,4,-inf,inf])
view([0,90])
xlabel('\xi')
ylabel('\eta')
zlabel('Im(\phi)')
title("Imaginary part")

saveas(gcf,"TopicCA5Q1imag.eps",'epsc')


%path
s0=surf(xim,etam,real(phi(t)));
xlabel('\xi')
ylabel('\eta')
zlabel('Re(\phi)')
hold on
%plot saddles
scatter3([0,0],[1,2],[real(phi(1i)), real(phi(2i))],'k','filled')
%ss = linspace(-1,4,101)

ss1 = linspace(-1,1,101)
ss2 = linspace(1,-1,101);
xieq1 = sqrt(3*(ss1-1).*(ss1-2));
xieq2 = -sqrt(3*(ss2-1).*(ss2-2));
plot3(xieq1,ss1,real(phi(xieq1+1i*ss1)),'g','linewidth',3)
plot3(xieq2,ss2,real(phi(xieq2+1i*ss2)),'g','linewidth',3)
hold off
axis([-4,4,-1,4,-inf,inf])
view([0,90])
xlabel('\xi')
ylabel('\eta')
title("Path through Re(\phi)")

saveas(gcf,"TopicCA5Q1path.eps",'epsc')


%%
%Question 2


close all
clear all
xi=linspace(-2,2,21);
eta=linspace(-1,3,21);
[xim,etam]=meshgrid(xi,eta);
t=xim + 1i*etam;
phi=@(t) -4*t.^2 + 5i*t - 1i*t.^3;
surf(xim,etam,real(phi(t)));
xlabel('\xi')
ylabel('\eta')
zlabel('Re(\phi)')
hold on
%end points
scatter3([-1,1],[0,0],[real(phi(-1)), real(phi(1))],'k','filled')

%plot saddles
scatter3([0,0],[1,5/3],[real(phi(1i)), real(phi((5/3)*1i))],'k','filled')
ss = linspace(0,1,101);
xieq1 = sqrt(-8*ss + 5 + 3*ss.^2);
xieq2 = -xieq1;
plot3(xieq1,ss,real(phi(xieq1 + 1i*ss)),'r','linewidth',3)
plot3(xieq2,ss,real(phi(xieq2 + 1i*ss)),'g','linewidth',3)

axis([-2,2,-1,3,-inf,inf])
view([-30 60])
hold off
saveas(gcf,"TopicCA5Q2real.eps",'epsc')
%Confirm the imaginary part is good
figure
surf(xim,etam,imag(phi(t)))
hold on
scatter3([-1,1],[0,0],[imag(phi(-1)), imag(phi(1))],'k','filled')

scatter3([0,0],[1,(5/3)],[imag(phi(1i)), imag(phi((5/3)*1i))],'k','filled')
plot3(xieq1,ss,imag(phi(xieq1 +1i*ss)),'r','linewidth',3)
plot3(xieq2,ss,imag(phi(xieq2+1i*ss)),'g','linewidth',3)

hold off
axis([-2,2,-1,3,-inf,inf])
view([0,90])
xlabel('\xi')
ylabel('\eta')
zlabel('Im(\phi)')

saveas(gcf,"TopicCA5Q2imag.eps",'epsc')

%plot the chosen path
figure
surf(xim,etam,real(phi(t)));
hold on
%saddles and endpoints
scatter3([-1,1],[0,0],[real(phi(-1)), real(phi(1))],'k','filled')
scatter3([0,0],[1,(5/3)],[real(phi(1i)), real(phi((5/3)*1i))],'k','filled')

%paths
plot3(xieq1,ss,real(phi(xieq1 + 1i*ss)),'g','linewidth',3)
plot3(xieq2,ss,real(phi(xieq2 + 1i*ss)),'g','linewidth',3)

xi = linspace(-1,-2);
eta = (4*xi +sqrt(xi.*(3*xi.^3 + xi - 12)))./(3*xi);
plot3(xi,eta,real(phi(xi+1i*eta)),'g','linewidth',3)
xi = linspace(1,2);
eta = (4*xi -sqrt(xi.*(3*xi.^3 + xi + 12)))./(3*xi);
plot3(xi,eta,real(phi(xi+1i*eta)),'g','linewidth',3)

hold off
axis([-2,2,-1,3,-inf,inf])
view([0,90])
xlabel('\xi')
ylabel('\eta')
title('Path through Re(\phi)')
saveas(gcf,"TopicCA5Q2path.eps",'epsc')

