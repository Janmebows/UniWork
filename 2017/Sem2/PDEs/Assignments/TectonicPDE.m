%% B
function TectonicPDE
global h j
nPoints = 30;
L = 2*pi;
x=linspace(0,L,nPoints)';
h = x(2)-x(1);
j = 2:nPoints-1;


u0 = -1+2*rand(1,nPoints); %uniform dist of random vars -1,1 
[t,u] = ode15s(@deriv,[0 10],u0(j));
u=[ubound(t) u ubound(t )];
surf(x,t,u)
xlabel('space x'),ylabel('time t' ),zlabel('u(x,t)' )


%% C
u0 = sin(x);
func = @(u) deriv(0,u);
sol1 = fsolve(func,u0(j));
plot(x,[0;sol1;0]);
title('Initial condition sin(x)')

u0 = x.^2;
sol2 = fsolve(func,u0(j));

u0 = (x+1).^(1/2);
sol3 = fsolve(func,u0(j));

%% D
smol = 1e-6;
func = @(v) deriv(0,sol1+smol*v)/smol;
[v,d] = eigs(func,nPoints-2,nPoints-2) ;
d=diag(d);
dmin=d(1:3)
dmax =d(end-2:end)


end



function ut=deriv(t,u)
global h j
r=1.5;
u=[ubound(t); u;ubound(t)];

ux = [0;(u(j+1)-u(j-1))/(2*h);0];
v = [0;(u(j-1)-2*u(j)+u(j+1))/(h^2);0];
vxx = [0;(v(j-1)-2*v(j)+v(j+1))/(h^2);0];


ut=((30/7)*u(j).^2 - r).*v(j)+(-34/231).*vxx(j)+60/7*u(j).*ux(j).^2;
end
function ua=ubound(t)
ua=zeros(size(t));
end

