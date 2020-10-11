close all
clear all

x = linspace(0,6);
plot(x,x.^2 - 6*x +1,'k')
hold on
plot((3 + 2 *sqrt(2)),0,'gx')
plot((3 - 2 *sqrt(2)),0,'bx')
xlabel('\beta \delta')
grid on
saveas(gcf,'bdregion.eps','epsc')

figure
beta = linspace(0,1);
delta = linspace(1,50);

%plot beta = delta
plot(beta,1./delta,'k')
%plot the last condition
hold on
%fimplicit(@(beta,delta) delta.^2.*beta.^2 - 6*delta.*beta + 1,[0,1,1,50])
dbplus= (3 + 2 *sqrt(2))./delta;
dbminus= (3 - 2 *sqrt(2))./delta;
plot(beta,dbplus,'g')
plot(beta,dbminus,'b')

axis([0,1,0,inf])
xlabel('\beta')
ylabel('\delta')
grid on
saveas(gcf,'betaVdelta.eps','epsc')

