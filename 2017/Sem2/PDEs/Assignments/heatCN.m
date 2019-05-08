function heatCN
% Compute solutions of heat PDE with Crank-Nicholson
% AJR, 9/9/2014
%Adapted for Schrodinger equation by Andrew Martin
%1704466
%16/10/17
nPoints=61; % number of spatial grid points
x=linspace(-4,4,nPoints)';
j=2:nPoints-1;
h=x(2)-x(1); % space step of grid
nTimes=51; % number of time steps
t=linspace(0,1,nTimes);
tau=t(2)-t(1); % time step
% storage and initial condition
u=nan(nPoints,nTimes);
u(:,1)=sech(2*(x+2.6));
V = tau/i *(4-x(j).^2).^2;
% sparse matrix of the CN scheme
s= i*tau/h^2;
A=sparse(j,j,2*(1+s)-V,nPoints,nPoints) ...
+sparse(j,j-1,-s,nPoints,nPoints) ...
+sparse(j,j+1,-s,nPoints,nPoints) ...
+sparse([1 nPoints],[1 nPoints],1,nPoints,nPoints);
%spy(A)
condA=condest(A); % check condition number not large
for l=1:nTimes-1 % time step loop
rhs=[uleft(t(l+1))
s*u(j-1,l)+2*(1-s)*u(j,l)+s*u(j+1,l)+(V.*u(j,l))
uright(t(l+1))];
u(:,l+1)=A\rhs; % solve linear eqns A.u=rhs
end
%figure
surf(t,x,abs(u),angle(u))
xlabel('time t'),ylabel('space x'),zlabel('|\psi(x,t)|')
C = colorbar;
C.Label.String = "arg(\psi)";
%axis([0 1 -4 4 0 2 ])
%--------------------------------------------------
function ua=uleft(t), ua=zeros(size(t));
function ub=uright(t), ub=zeros(size(t));