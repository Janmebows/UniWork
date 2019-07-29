% [t,N]=Tute1_ConstYield(N0,tf,y)
%
% School of Mathematical Sciences, Uni Adelaide
%
% INPUTS:
%
% tf is the final time to which the simulation is computed
% N0 is the initial population size (non-dim)
% y is the constant fishing rate (non-dim)

function Tute1_ConstYield(tf,N0,y)

if ~exist('tf','var'); tf = 3; end
if ~exist('N0','var'); N0 = 0.3; end
if ~exist('y','var');  y  = 0.2; end

do_2a=1; do_2b=1;

%% Q2a
if do_2a
fig=1;
figure(fig); set(gca,'box','on'); hold on

[t,N]=ode45(@(t,n) RHS(t,n,y),[0,tf],N0);
plot(t,N,'b','linewidth',2); 
if imag(0.5*(1+sqrt(1-4*y)))==0
 Nast = 0.5*(1-sqrt(1-4*y));
 plot(t,Nast+0*t,'r--','linewidth',2)
 Nast = 0.5*(1+sqrt(1-4*y));
 plot(t,Nast+0*t,'k--','linewidth',2)
else
 Nast=0; 
end
set(gca,'ylim',[0,max([1.5*Nast,max(N)])])
xlabel('t_*','fontsize',20)
ylabel('N_*','fontsize',20)
title(['N_0=' num2str(N0) '; y=' num2str(y)],'fontsize',20)
end

%% Q2b
if do_2b
fig=2;
figure(fig); set(gca,'box','on'); hold on

Nmin = 0; tmin = 0;
Nmax = 2; tmax = tf; 

axis([Nmin Nmax tmin tmax]); 

[N,T] = meshgrid(linspace(Nmin,Nmax,21),linspace(Nmin,tmax,21));

xlabel('$\hat{N}$','interpreter','latex','fontsize',15);
ylabel('$\hat{t}$','interpreter','latex','fontsize',15);

dN = RHS(T,N,y);
dt = 1+0*dN;

quiver(N,T,dN,dt,'k');

 % Normalise
 dN = dN./sqrt(dN.^2+dt.^2);
 dt = dt./sqrt(dN.^2+dt.^2);
 quiver(N,T,dN,dt,'k');

N0=0.1;
[t,N]=ode45(@(t,n) RHS(t,n,y),[0,tf],N0);
plot(N,t,'r','linewidth',2);

N0=0.8;
[t,N]=ode45(@(t,n) RHS(t,n,y),[0,tf],N0);
plot(N,t,'m','linewidth',2);

if imag(0.5*(1+sqrt(1-4*y)))==0
 Nast = 0.5*(1+sqrt(1-4*y));
 plot(Nast+0*t,t,'k--','linewidth',2);
end

end

return

%% Subfunction

function dNdt=RHS(t,N,y)
dNdt=N.*(1-N)-y;
return