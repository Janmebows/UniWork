function heatnon
% Compute solutions of nonlinear PDE via finite differences
global j x;
nPoints=16;
x=linspace(0,1,nPoints)';
j=2:nPoints-1;
u0=rand(size(x));
[t,u]=ode15s(@dudt,[0 0.4],u0(j));

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
ut=(-u(j-1)+u(j+1))  u(j).*(u(j-1)-2*u(j)+u(j+1))/dx)/dx;
end
%--------------------------------------------------
function ua=uleft(t)
ua=zeros(size(t));
end
%--------------------------------------------------
function ub=uright(t)
ub=zeros(size(t));
end
