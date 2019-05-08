function heat
% Compute solutions of heat PDE with finite differences

global j x;
nPoints=11;
x=linspace(0,1,nPoints)';
j=2:nPoints-1;

%initial condition
u0=6*x.*(1-x);


[t,u]=ode15s(@dudt,[0 0.2],u0(j));
u=[uleft(t) u uright(t)];
surf(x,t,u);
xlabel("space x");
ylabel("time t");
zlabel("u(x,t)");
end
%--------------------------------------------------
function ut=dudt(t,u)
global j x;
dx=x(2)-x(1);
u=[uleft(t);u;uright(t)];
ut=(u(j-1)-2*u(j)+u(j+1))/dx^2;
end
%--------------------------------------------------
function ua=uleft(t)
ua=zeros(size(t));
end
%--------------------------------------------------
function ub=uright(t)
ub=zeros(size(t));
end