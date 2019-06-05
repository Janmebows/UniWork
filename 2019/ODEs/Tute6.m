close all
fn = @(x,y) -100*(y-cos(x)+sin(x)/100);
x = [0,1];
%NON-STIFF
y0 = 1;
if(false)
[xout45,yout45] = ode45(fn,x,y0);
[xout23,yout23] = ode23(fn,x,y0);
[xout113,yout113] = ode113(fn,x,y0);
[xout15s,yout15s] = ode15s(fn,x,y0);
[xout23s,yout23s] = ode23s(fn,x,y0);
[xout23t,yout23t] = ode23t(fn,x,y0);
[xout23tb,yout23tb] = ode23tb(fn,x,y0);
end
%STIFF VERSION
y0=0;
if(true)
[Sxout45,Syout45] = ode45(fn,x,y0);
[Sxout23,Syout23] = ode23(fn,x,y0);
[Sxout113,Syout113] = ode113(fn,x,y0);
[Sxout15s,Syout15s] = ode15s(fn,x,y0);
[Sxout23s,Syout23s] = ode23s(fn,x,y0);
[Sxout23t,Syout23t] = ode23t(fn,x,y0);
[Sxout23tb,Syout23tb] = ode23tb(fn,x,y0);
end
% plot(Sxout45,Syout45,'ok')
% plot(Sxout23,Syout23,'ob')
% plot(Sxout113,Syout113,'or')
% plot(Sxout15s,Syout15s,'oy')
% plot(Sxout23s,Syout23s,'om')
% plot(Sxout23t,Syout23t,'og')
% plot(Sxout23tb,Syout23tb,'oc')

%%%For the stiff one
%%%%ode23s gives the least points, 
%%%suggesting it is the most stable solver

syms y(x)
eqn = diff(y,x) == -100*(y-cos(x)+sin(x)/100);
y0 = dsolve(eqn,y(0)==0)
y1 = dsolve(eqn,y(0)==1)
y0 = matlabFunction(y0)
y1 = matlabFunction(y1)
x = linspace(0,1)
 plot(x,y0(x)) 
% plot(x,y1(x))/
ERR45 = abs(Syout45 - y0(Sxout45))
ERR23 = abs(Syout23 - y0(Sxout23))
ERR113 = abs(Syout113 - y0(Sxout113))
ERR15s = abs(Syout15s - y0(Sxout15s))
ERR23s = abs(Syout23s - y0(Sxout23s))
ERR23t = abs(Syout23t - y0(Sxout23t))
ERR23tb= abs(Syout23tb- y0(Sxout23tb))
figure
hold on
plot(Sxout45,ERR45,'color',[0.2,0.2,0.02])
plot(Sxout23,ERR23,'k')
plot(Sxout113,ERR113,'g')
plot(Sxout15s,ERR15s,'r')
plot(Sxout23s,ERR23s,'b')
plot(Sxout23t,ERR23t,'c')
plot(Sxout23tb,ERR23tb,'y')



