clear all 
close all
%%Q1

epsilon = 0.1;
[t,yNumeric] = ode45(@Q1OscillatorEqn,[0,500],[1,0],[],epsilon);
T = t*epsilon;
R = 1./sqrt(0.75*T+1);
theta = 0;
yAsymp = R .* cos(t + theta);
plot(t,yNumeric(:,1),'b')
hold on
plot(t,yAsymp,'--r')
hold off
xlabel('t')
ylabel('y')
legend("Numeric Solution","Multiple Scales Solution")
title('Oscillator Equation Solutions')
saveas(gcf,'TopicCA4Q1.eps','epsc')

%%
%%Q2
%obtain symbolic solutions
syms y0(t) y1(t) R phi F T
y0 = R*cos(t+phi);
y0 = subs(y0,R,2*exp(T/2)/(sqrt(F+exp(T))));
y0t = diff(y0,t);
y0tT = simplify(diff(y0t,T));
y1eqn = simplify(diff(y1,t,2) + y1 == -2*y0tT  - (y0^2-1)*y0t);

y1 = simplify(dsolve(y1eqn));
latex(y1)

%y0TT = diff(y0,T,2)
y0T = diff(y0,T);
% y1T = diff(y1,T)
y1t = diff(y1,t);
%derivative condition
alpha0 = solve(subs(subs(subs(subs(y1t + y0T,t,0),T,0),phi,0),F,3)==0)
%IC 
beta0 = solve(subs(subs(subs(subs(y1,t,0),T,0),phi,0),F,3) ==0)



syms tau F(tau) phi(tau) alpha(tau) beta(tau) C4 C5 

%y1 = subs(subs(subs(subs(y1,C4,alpha),C5,beta),phi,phi),F,F)
y1 = subs(subs(y1,C4,alpha),C5,beta);

%Why does this line throw an error????
% y0 = subs(subs(y0,F,F),phi,phi)
%guess ill hard code it
y0 = (2*exp(T/2)*cos(phi + t))/(exp(T) + F)^(1/2);
y0TT = diff(y0,T,T);
y0ttau = diff(y0,t,tau);
y0T = diff(y0,T);
y1t = diff(y1,t);
y1tT = diff(y1,t,T);
% y0ttau = 
y2RHS =  - y0TT - 2*y0ttau- 2*y0ttau...
    - y0*y0T + y0T - y0^2*y1t + y1t - 2*y1tT;

% assume(T>0)
% assume(exp(T) + F(tau) ~=0)
% assume(tau>0)
temp = combine(expand(simplify(y2RHS)),'sincos');
collection = collect(temp,{'sin' 'cos'});
latex(collection)
syms c
collection = subs(collection,F,3);
c = -1/16 - exp(T)/(8*(exp(T)+3)^(1/2)) + 3*exp(2*T)/(16*(exp(T)+3)^(5/2))


%%
%plot solutions
% close all

epsilon = 0.05;
[t,yNumeric] = ode45(@Q2VanderPol,[0,100],[1,0],[],epsilon);
figure
plot(t,yNumeric(:,1),'r')
hold on
R = @(t) 2*exp(epsilon*t/2)./(sqrt(3+exp(epsilon*t)));

c =@(T) -1/16 - exp(T)./(8*(exp(T)+3).^(1/2)) + 3*exp(2*T)./(16*(exp(T)+3).^(5/2))
phi = @(t) epsilon^2*t.*(-1/16 - exp(epsilon*t)./(8*(exp(epsilon*t)+3).^(1/2)) + 3*exp(2*epsilon*t)./(16*(exp(epsilon*t)+3).^(3/2)))
yAsymp =@(t) R(t).*cos(t + phi(t))
plot(t,yAsymp(t),'-.b')


xlabel('t')
ylabel('y')
legend("Numeric Solution","Multiple Scales Solution")
title("Van der Pol Oscillator Solutions, \epsilon = "+num2str(epsilon))
saveas(gcf,"TopicCA4Q2.eps",'epsc')


function dy = Q1OscillatorEqn(t,y,epsilon)

dy = [y(2);-y(1) - epsilon*(y(2)^3)];

end
function dy = Q2VanderPol(t,y,epsilon)

dy = [y(2);-epsilon*(y(1)^2 - 1)*y(2) - y(1)];
end
