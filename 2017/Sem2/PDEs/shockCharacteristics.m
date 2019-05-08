%Shock on a traffic density problem
%Andrew Martin
%a1704466

%function handles to make life easier
rho = @(p) 125 - (abs(p)>=4)*100 - (abs(p)<=4).*abs(p)*25; 
rho0 = @(p)(1-rho(p)/150).*(1-rho(p)/300); 
t = linspace(0,4);
%Generate a group of points as initial car positions
s=linspace(-10,5,25);
i = 1:length(s);
j = 1:length(t);
%Makes the vectorisation easier
[S,T] = meshgrid(s,t);
x(j,i)=S(j,i) + rho0(S(j,i)).*T(j,i);
%Plot of different initial positions
plot(x,t)
axis([-5,5,0,4])
title('Characteristics for cars with initial density \rho_0')
xlabel('x(km)')
ylabel('t(minutes)')
t=0:4;
s = linspace(-5,5);
[S,T] = meshgrid(s,t);
i = 1:length(s);
j = 1:length(t);
x2(j,i)=S(j,i) + rho0(S(j,i)).*T(j,i);
figure
plot(x2',rho(S)')
legend('time = 0','time = 1', 'time = 2', 'time = 3' , 'time = 4')
xlabel('distance x(km)')
ylabel("density \rho(x) (cars/km)")
axis([-5,5,min(rho(s))-5,max(rho(s))+5])
title('Density predictions')
