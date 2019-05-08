function kdv
% Compute solutions of Korteweg-de Vries PDE
% with perdiodic boundary conditions.

global x;
nPoints=80;
x=linspace(0,40,nPoints+1); x=x(1:nPoints)';
u0=2+x.^2.*(1-x/4).^2.*(x<4);
[t,u]=ode15s(@dudt,[0 2],u0);

surf(x,t,u)
xlabel("space x");
ylabel("time t");
zlabel("u(x,t)");
end
%--------------------------------------------------
function ut=dudt(~,u)
global x;
dx=x(2)-x(1);
u=[u;u;u];
j=(1:length(x))+length(x);
ut=-3*(-u(j-1).^2+u(j+1).^2)/(2*dx) ...
-(-u(j-2)+2*u(j-1)-2*u(j+1)+u(j+2))/(2*dx^3) ;
end