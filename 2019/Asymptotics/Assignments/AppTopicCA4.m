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
epsilon = 0.01;
[t,yNumeric] = ode45(@Q2VanderPol,[0,100],[1,0],[],epsilon);
plot(t,yNumeric(:,1))
xlabel('t')
ylabel('y')
legend("Numeric Solution","Multiple Scales Solution")
title('Van der Pol Oscillator Solutions')

%%
%obtain symbolic solutions

%syms y0(t,T,tau) y1(t,T,tau) y2(t,T,tau) theta(T,tau) R(T,tau) t T tau
%y0 = R*cos(t+theta)
%y1eqn = diff(y1,t,2) + 2*diff(diff(y0,t,1),T,1)+y0^2*diff(y0,t,1) - diff(y0,t,1) + y1 ==0

syms t tau y0(t) y1(t,T,tau) y2(t,T,tau) R(T,tau) theta(T,tau)
dy0 = diff(y0,t);
ddy0 = diff(y0,t,2);
eqn0 = ddy0 + y0 ==0;
cond0= [y0(0)==1, dy0(0) ==0];
y0(t) = dsolve(eqn0,cond0)
y0(t,T,tau) = R*y0(t+theta)
eqn1 =diff(y1,t,2) + 2*diff(y0,t,T) + y0^2* diff(y0,t) - diff(y0,t) + y1 ==0












function dy = Q1OscillatorEqn(t,y,epsilon)

dy = [y(2);-y(1) - epsilon*(y(2)^3)];

end
function dy = Q2VanderPol(t,y,epsilon)

dy = [y(2);-epsilon*(y(1)^2 - 1)*y(2) - y(1)];
end
