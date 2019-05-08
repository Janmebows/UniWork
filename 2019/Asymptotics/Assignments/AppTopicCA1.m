%reproducibility
clear all
close all

%%Q1a
x=linspace(-5,5,10000);
epsilon = 0.05;
plot(x,tanh(x/epsilon))
hold on
plot(x,x)

hold off
legend('tanh(x/\epsilon)','x')
title('\epsilon = 0.05')
saveas(gcf,"TopicCA1Q1a.eps","epsc")

%%Q1c
%symbolically solve the equation 
%and plot against asymptotic solution

syms x
epsilon = linspace(1,0.02);
S = zeros(2,length(epsilon));
mysol = zeros(2,length(epsilon));
for i=1:length(epsilon)
    eqn = x == tanh(x/epsilon(i));
    S(1,i) = vpasolve(eqn,x,-1);
    S(2,i) = vpasolve(eqn,x,1);
    mysol(1,i) =  1 -2*exp(-2/epsilon(i)) +2*exp(-4/epsilon(i));
    mysol(2,i) =  -mysol(1,i);

end


figure
plot(epsilon,S(1,:),'b')
hold on
%HandleVisibility off makes the legend work nicely
plot(epsilon,S(2,:),'b','HandleVisibility','off')
plot(epsilon,mysol(1,:),'r')
plot(epsilon,mysol(2,:),'r','HandleVisibility','off')
%plot(epsilon,mysol)
legend("Numerical Solutions","Asymptotic Solution")
xlabel("$$\epsilon$$",'interpreter','latex')
ylabel("Solution to the equation")
saveas(gcf,"TopicCA1Q1c.eps","epsc")

%%Q2c
%obtain numeric solution
%plot it against asmptotic
[x,ynum] = ode45(@odefun,[1,0.01],[1,0]);
%we only want to plot y which is the first column of ynum
figure
plot(x,ynum(:,1),'b')
hold on
S = @(x) -0.5*(1./x +log(x));
yasymp = exp(S(x));
plot(x,yasymp,'r')
%axis([0,0.2,-1,1])
legend("Numerical solution", "Asymptotic solution")
xlabel("x")
ylabel("y")
title("Comparison of solutions for the ODE")
saveas(gcf,"TopicCA1Q2c.eps","epsc")


%%Q3c
%% 
%with epsilon = 0.1 we expect the optimal trunctation at j= 1/eps -1 = 9
epsilon = 0.1;
syms tsym
Nmax = 12;
%keep Mmax*Nmax relatively small to lower computation time
Mmax = 5;
xvals = 1:Nmax;
solvalsa=zeros(size(xvals));
solvalsb=zeros(Nmax,Mmax);
for N = 1:Nmax
    % %i've written this slightly differently and omitted the (-1) terms
    % since we are only concerned with absolute error
    erraint = int((exp(-tsym)*tsym^(N+1)/(1+(epsilon*tsym))),tsym,[0,inf]);
    erra = (epsilon).^(N+1) * erraint;
        solvalsa(N) = erra;
    for M = 0:Mmax
        errbint = int(exp(-tsym)*tsym^(N+1)...
                * ((epsilon*tsym - 1)^(M+1))/(1+0.5*(epsilon*tsym-1)) ,tsym,[0,inf]);
        errb = (epsilon).^(N+1) * (1/2)^(M+2) * errbint;
        solvalsb(N,M+1) = errb;
    end
    
 end
[minimum,index] = min(abs(solvalsa));
figure
scatter(xvals,abs(solvalsa))
hold on
textflaga = "Minimum at N = "+ num2str(index);
scatter(index,minimum,'x')
xlabel("N")
ylabel("Absolute Error")
legend("Error truncated at N", textflaga)
title("Error with N data points for $\epsilon$ = "+num2str(epsilon), 'interpreter','latex')
hold off
set(gca,'yscale','log')
saveas(gcf,"TopicCA1Q3c1.eps","epsc")


figure
semilogy(xvals,abs(solvalsb ))
xlabel("N")
ylabel("Absolute Error")    
textflagb = "Error with M = "+[0:Mmax];
legend(textflagb)
title("Effect of the expanded error form for $\epsilon$ = "+num2str(epsilon), 'interpreter','latex')
saveas(gcf,"TopicCA1Q3c2.eps","epsc")
%% 



%%Function for 2
function dy = odefun (x,y)
dy = [y(2);y(2)./x.^2 - y(1)./(4*x.^4)];
%y'' - y' x^(-2) + y/(4x^4) = 0
%y'' = y'/(x^2) - y/(4x^4)
end



