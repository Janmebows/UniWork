function FloodedRC
% Compute solutions of linear shallow water PDEs with
% finite differences AJR, 16/9/2016
% Use staggered grid v=(u1,h2,u3,h4,...,uN)
% Adapted by Andrew Martin a1704466 for a flooded rivere channel
global x g d u h
g=10;
nPoints=31; % should be odd for the BCs
x=linspace(0,30,nPoints)';
d=1.5*ones(size(x)) -((x<8) + (x>22));%sets all points to 1.5 and subtracts 1 from the flood plains
u=3:2:nPoints-1;% index of u points
h=2:2:nPoints-1;% index of h points
v0=zeros(size(x));
[t,v]=ode15s(@dvdt,[0 5],v0(2:end-1));
v=[uleft(t) v uright(t)];
small=1e-6;
%v=v(h)
fun=@(w) dvdt(0,v0(2:nPoints-1)+small*w)/small;
[vec,dia] = eigs(fun,nPoints-2,nPoints-2);
vec = abs(vec);
i=1:2:length(t);% only plot selected times
surf(x(h),t(i),v(i,h),v(i,h+1))
xlabel('space x'),ylabel('time t'),zlabel('h(x,t)')
colorbar
print -depsc2 shallowlin
%--------------------------------------------------
function vt=dvdt(t,v)
global x g d u h
dx=x(3)-x(1);
v=[uleft(t);v;uright(t)];
vt=nan(size(x));
vt(h)=-(d(h+1).*v(h+1)-d(h-1).*v(h-1))/dx;
vt(u)=-g*(v(u+1)-v(u-1))/dx;
vt=vt(2:end-1);
%-------------------------------------------------
function u=uleft(t)
u=zeros(size(t));
function u=uright(t)
u=zeros(size(t));