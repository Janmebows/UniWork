%Better plots
set(groot, 'DefaultLineLineWidth', 1, ...
    'DefaultAxesLineWidth', 1, ...
    'DefaultAxesFontSize', 12, ...
    'DefaultTextFontSize', 12, ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultColorbarTickLabelInterpreter', 'latex', ...
    'DefaultAxesTickLabelInterpreter','latex');

%%Q2b
close all
clear all
epsilon = 0.2;
k =1;
[x,y] = meshgrid(linspace(0,4*pi/k),linspace(-1.1,1.1));
hplus = 1 + epsilon*cos(k*x);
hminus = -hplus;
psi0 = 0.5*(1-y.^2);
psi1 = cos(k*x).*cosh(k*y)/(cosh(k));
psi2 =((1-k*tanh(k))/cosh(2*k))*cosh(2*k*y).*(cos(k*x).^2) ;
psi = psi0 + epsilon*psi1 + epsilon^2*psi2;
contourf(x,y,psi)%,'Edgecolor','none')
hold on
plot(x(1,:),hplus(1,:),':k')
plot(x(1,:),hminus(1,:),':k')
xlabel("x")
ylabel("y")
titlestr = "Filled Contour of $$\psi$$, with $$k=$$"+num2str(k) ...
    + " and $$\epsilon=$$" +num2str(epsilon);
title(titlestr)
colorbar
hold off
saveas(gcf,"TopicCA2Q2a.eps",'epsc')
%%
%%streamlines
close all

figure
title("Streamline plots")
subplot(2,2,1)
bunchaplots(1,0.2,gcf);
subplot(2,2,2)
bunchaplots(1,0.01,gcf);
subplot(2,2,3)
bunchaplots(0.5,0.2,gcf);
subplot(2,2,4)
bunchaplots(0.5,0.01,gcf);
saveas(gcf,"TopicCA2Q2b.eps",'epsc')

function out = bunchaplots(k,epsilon,fig)
[x,y] = meshgrid(linspace(-pi,4*pi,20),linspace(-1.5,1.5,20));
u0 =@(x,y) -y;
u1 =@(x,y) k*(cos(k*x).*sinh(k*y)/(cosh(k)));
u2 =@(x,y) 2*k* ((1-k*tanh(k))/cosh(2*k))*sinh(2*k*y).*(cos(k*x).^2);

u=@(x,y) u0(x,y) + epsilon*u1(x,y) + epsilon^2 *u2(x,y);

v1 =@(x,y) -k *(sin(k*x).*cosh(k*y)/(cosh(k)));
v2 =@(x,y) -2*k*(((1-k*tanh(k))/cosh(2*k))*cosh(2*k*y).*sin(k*x).*cos(k*x));
v =@(x,y) -(epsilon*v1(x,y) + epsilon^2 *v2(x,y));

quiver(x,y,u(x,y),v(x,y),"HandleVisibility",'off') 
hold on
hplus = 1 + epsilon*cos(k*x);
hminus = -hplus;

plot(x(1,:),hplus(1,:),':k',"HandleVisibility",'off') 
plot(x(1,:),hminus(1,:),':k',"HandleVisibility",'off') 

%random normal path
[temp1,temp2] = ode45(@(t,a)odesys(t,a,k,epsilon),[0,25],[0,-0.8]);
plot(temp2(:,1),temp2(:,2))
%a closed loop
[temp1,temp2] = ode45(@(t,a)odesys(t,a,k,epsilon),[0,40],[0.5*pi/k,-0.2]);
plot(temp2(:,1),temp2(:,2))
%edge case1
[temp1,temp2] = ode45(@(t,a)odesys(t,a,k,epsilon),[0,25],[-2*pi/k,-1-epsilon]);
plot(temp2(:,1),temp2(:,2))
%edge case2
[temp1,temp2] = ode45(@(t,a)odesys(t,a,k,epsilon),[0,25],[4*pi/k,1 + epsilon]);
plot(temp2(:,1),temp2(:,2))
%stagnant point
plot(0:pi/k:4*pi/k,zeros(size(0:pi/k:4*pi/k)),'xk')
title("k = "+num2str(k) + ", $\epsilon$ = " +num2str(epsilon)) 
axis([-pi,4*pi,-1-epsilon,1+epsilon])
hold off
out=gcf;
end
function uv = odesys(t,a,k,epsilon)
x = a(1);
y = a(2);
u0 =@(x,y) -y;
u1 =@(x,y) k*(cos(k*x).*sinh(k*y)/(cosh(k)));
u2 =@(x,y) 2*k* ((1-k*tanh(k))/cosh(2*k))*sinh(2*k*y).*(cos(k*x).^2);

u= u0(x,y) + epsilon*u1(x,y) + epsilon^2 *u2(x,y);
v1 =@(x,y) -k *(sin(k*x).*cosh(k*y)/(cosh(k)));
v2 =@(x,y) -2*k*(((1-k*tanh(k))/cosh(2*k))*cosh(2*k*y).*sin(k*x).*cos(k*x));

v = -(epsilon*v1(x,y) + epsilon^2 *v2(x,y));

uv = [u;v];
end