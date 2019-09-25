%Make plots less repulsive
set(groot, 'DefaultLineLineWidth', 1, ...
    'DefaultAxesLineWidth', 1, ...
    'DefaultAxesFontSize', 12, ...
    'DefaultTextFontSize', 12, ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultColorbarTickLabelInterpreter', 'latex', ...
    'DefaultAxesTickLabelInterpreter','latex');
close all
clear all
%intersection curves (observation)
t = linspace(0,4*pi)
plot(t,t -sin(t))
hold on
plot(t,5*(1-cos(t)))

%solve the nonlinear equation for theta ...
%(guesses based on observation)
t1 = fzero(@(t) 1 - 5/(t-sin(t))*(1-cos(t)),4)
t2 = fzero(@(t) 1 - 5/(t-sin(t))*(1-cos(t)),8)
t3 = fzero(@(t) 1 - 5/(t-sin(t))*(1-cos(t)),10)
%get kappa from the theta solutions
k1 = 5/(t1 - sin(t1))
k2 = 5/(t2 - sin(t2))
k3 = 5/(t3 - sin(t3))

%add them to plot to check
scatter(t1,t1-sin(t1))
scatter(t2,t2-sin(t2))
scatter(t3,t3-sin(t3))
saveas(gcf,'IntersectionPlot.eps','epsc')
%parametric solutions to plot
x = @(k,t) k*(t-sin(t));
y = @(k,t) 2 - k*(1-cos(t))
T = @(k,t1) sqrt(k)/sqrt(9.807) * t1;
%first sol
theta1 = linspace(0,t1);
figure
plot(x(k1,theta1),y(k1,theta1))
T1 = T(k1,t1)
title("T = " + num2str(T1))
saveas(gcf,'Sol1.eps','epsc')
%second sol
theta2 = linspace(0,t2);
figure
plot(x(k1,theta2),y(k1,theta2))
T2 = T(k2,t2)
title("T = " + num2str(T2))
saveas(gcf,'Sol2.eps','epsc')

%third sol
theta3 = linspace(0,t3);
figure
plot(x(k1,theta3),y(k1,theta3))
T3 =T(k3,t3)
title("T = " + num2str(T3))
saveas(gcf,'Sol3.eps','epsc')