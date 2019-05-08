%Consistency
close all
clear all

%values given
N=2000;
c = 0.91;
q = 0.75;

beta = c * q;
gamma = 0.68;

%model for i
%two cases, one for the given beta, gamma, and one with them swapped
%the latter won't be used until part iv
didt = @(t,i,params) params(1) .* i .*(1-i) - params(2) .* i;
i0 = 1/N;
i02  = 1/4;
params1=[beta,gamma];
params2=[gamma,beta];



i = linspace(0,1);
%%Q1 part iii
%%phase lines for stability
figure
plot(i,didt(0,i,params1))
hold on
plot([0,1],[0,0],':k')
xlabel('$$i$$','interpreter','latex')
ylabel('$$didt$$','interpreter','latex')
axis([0,0.8,-0.2,0.2])
title('Phase Line analysis of $\frac{di}{dt}$','interpreter','latex')
saveas(gcf,'TopicBA1Q1c.eps','epsc')



%%Q1 part iv
%%numerically solve the DE
%I could have used a for loop for the plots 
%but hardcoded scripts are the best
options=[];
[t1,sol1] = ode45(didt,[0,20],i0,options,params1);
[t2,sol2] = ode45(didt,[0,20],i02,options,params2);
figure
subplot(2,1,1)
plot(t1,sol1)
title(['$\beta =$ ',num2str(params1(1)),'$, \gamma =$ ',num2str(params1(2)), ', $i_0 =$ ',num2str(i0)],'interpreter','latex')
xlabel('$$t$$','interpreter','latex')
ylabel('$$i$$','interpreter','latex')
subplot(2,1,2)
plot(t2,sol2)
title(['$\beta =$ ',num2str(params2(1)),'$, \gamma =$ ',num2str(params2(2)), ', $i_0 =$ ',num2str(i02)],'interpreter','latex')
xlabel('$$t$$','interpreter','latex')
ylabel('$$i$$','interpreter','latex')

saveas(gcf,'TopicBA1Q1d.eps','epsc')


%%Q1 part v

C3= (beta-gamma)/i0 - beta;
bg = beta-gamma;


i = bg./(C3*exp(-t1*bg)+beta);
figure
plot(t1,i,':r')
hold on
plot(t1,sol1,'-.b')
title(['$\beta =$ ',num2str(params1(1)),'$, \gamma =$ ',num2str(params1(2)), ', $i_0 =$ ',num2str(i0)],'interpreter','latex')
xlabel('$$t$$','interpreter','latex')
ylabel('$$i$$','interpreter','latex')
legend('Explicit ODE solution','Numeric ODE solution')
saveas(gcf,'TopicBA1Q1e.eps','epsc')
figure
plot(t1,N*abs(i-sol1))
xlabel('$$t$$','interpreter','latex')
ylabel('Approximation Error')
saveas(gcf,'TopicBA1Q1e2.eps','epsc')
hold off

%%Q2 part ii
%Plot the approximations
phi = @(rho,s0,alpha)atanh((1/alpha)*((s0/rho) - 1));
rapprox = @(t,rho,s0,alpha)rho^2/s0 * (s0/rho -1) + alpha*rho^2/s0 * tanh(gamma*alpha*t/2 - phi(rho,s0,alpha));
sapprox = @(t,rho,s0,alpha)s0*exp(-1/rho *rapprox(t,rho,s0,alpha));
iapprox = @(t,rho,s0,alpha) 1- rapprox(t,rho,s0,alpha) - sapprox(t,rho,s0,alpha);

alpha = @(rho,s0)sqrt(2*s0*(1/rho)^2*(1-s0) + (s0*(1/rho) - 1)^2);




figure
title('Approximation of the SIR model')
subplot(2,1,1)
hold on
s01 = 1-i0;
rho1 = gamma/beta;
alpha1 = alpha(rho1,s01);
plot(t1,iapprox(t1,rho1,s01,alpha1))
plot(t1,rapprox(t1,rho1,s01,alpha1))
title(['$\rho =$ ',num2str(rho1),', $i_0 =$ ',num2str(i0)],'interpreter','latex')
xlabel('$$t$$','interpreter','latex')
legend('i', 'r')
hold off

subplot(2,1,2)
hold on
s02 = 1-i02;
rho2 = beta/gamma;
alpha2 = alpha(rho2,s02);
plot(t2,iapprox(t2,rho2,s02,alpha2))
plot(t2,rapprox(t2,rho2,s02,alpha2))
title(['$\rho =$ ',num2str(rho2),', $i_0 =$ ',num2str(i02)],'interpreter','latex')
xlabel('$$t$$','interpreter','latex')
legend('i', 'r')
hold off
saveas(gcf,'TopicBA1Q2b','epsc')



