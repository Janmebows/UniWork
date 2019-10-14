close all

%params
a =6;
b = 10;
A = 1;
eps = 0.01;
vstarmin = (1 + a - sqrt(a^2-a+1))/3;
vstarmax = (1 + a + sqrt(a^2-a+1))/3;
vstar = (vstarmax +vstarmin)/2;
%IExt as found in the question
Iext = b*vstar - A*vstar*(a-vstar)*(vstar-1);
params.eps =eps;
params.A = A;
params.b = b;
params.a = a;
params.Iext = Iext;

w = linspace(-3,10);
v = linspace(-3,10);
plot(w,b*v);
hold on
plot(w,Iext + A*v.*(a-v).*(v-1) - w)


[t,x] = ode45(@(t,x) FNDE(t,x,params),[0,10],[vstarmax-eps;5]);

plot(x(:,1),x(:,2))
scatter(vstarmax-eps,5,'HandleVisibility','off')

axis([-2,7,-50,50])

xlabel("v")
ylabel("w")
legend(["v nullcline","w nullcline","Example path"])
saveas(gcf, 'A2Q2.eps','epsc')






%q5b
P = linspace(-10,10);
N = linspace(-10,10);
c = 5;
figure

%N nullclines red
plot(N,zeros(size(N)), 'r-')
hold on
plot(zeros(size(P)),P, 'r-','HandleVisibility','off')
fimplicit(@(N,P) -P.*(c+P)./N + N-1,'b-')
axis([-5,5,-1-c,2])
xlabel('N(z)')
ylabel('P(z)')
legend(["N nullclines","P nullclines"])
saveas(gcf,'A2Q5.eps','epsc')
%DE system for q2
function out= FNDE(t,x,params)
v = x(1);
w = x(2);
eps = params.eps;
A = params.A;
a = params.a;
b = params.b;
Iext = params.Iext;
dvdt = (Iext + A*v.*(a-v).*(v-1) - w)/eps;
dwdt = b*v - w;
out = [dvdt;dwdt];

end
