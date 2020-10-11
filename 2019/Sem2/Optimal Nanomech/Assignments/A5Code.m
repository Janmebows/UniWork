close all
%Make plots less repulsive
set(groot, 'DefaultLineLineWidth', 1, ...
    'DefaultAxesLineWidth', 1, ...
    'DefaultAxesFontSize', 12, ...
    'DefaultTextFontSize', 12, ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultColorbarTickLabelInterpreter', 'latex', ...
    'DefaultAxesTickLabelInterpreter','latex');
Vl = 4*pi/3;
R = [];
r0 = [];
c = [];
figure
hold on
syms Rsym r0sym 
assume(Rsym,'real')

thetacarr = pi/3:0.01:pi;
R = zeros(size(thetacarr));
c = zeros(size(thetacarr));
r0 = zeros(size(thetacarr));
%i could vectorise this but its not worth it
for i= 1:length(thetacarr)
    thetac = thetacarr(i);
    R(i) = (Vl/(pi *(-cos(thetac)^3/3 + cos(thetac) + 2/3)))^(1/3);
    
    c(i) = -Rsol*cos(thetac);
    
    r0(i) = -Rsol*sin(thetac);
    
end
    plot(thetacarr,R,'r')
    plot(thetacarr,r0,'b')
    plot(thetacarr,c,'g')
    legend(["R","$r_0$","c"])
    xlabel("$\theta_c$")
    ylabel("Parameter Value")
    title("Parameters with $V_l = 4\pi/3$")
    grid on

    saveas(gcf,'A5q3d.eps','epsc')
