
%%Code for Modelling with ODEs Assignment 1
%Andrew Martin
%21/3/2019

%Just for variable consistency
%and to close all the plots (this should produce 3)
close all
clear all

%%1a
%plot G(V)
%give some values to H and V0 so it can be plotted
%lets use those given for 3
H = 7;
V0= 6;
G = @(V) H*V./(V0+V);
V = linspace(0,100);
figure
plot(V,G(V));
title(['Grazing term for H = ',num2str(H),', V_0 = ',num2str(V0)])
xlabel('V')
ylabel('G(V)')
saveas(gcf,'ODEA1Q1a.eps','epsc')



%%3c
%phaselines
k=1;
v0=3;
dvhat = @(vhat) vhat.*(1- vhat/k) - (vhat./(v0+vhat));
%include a little bit to the left of 0 to demonstrate nature
vhat = linspace(-.2,1);
    figure
    plot(vhat,dvhat(vhat))
    hold on
    plot([-1,1],[0,0],':k')
    plot([0,0],[-1,1], ':k')
    axis([-0.2,1,-0.15,0.15])
    title('Phase Line analysis of Fixed points')
    xlabel('$$\hat{V}$$','interpreter','latex')
    ylabel ...
    ('$$\hat{V}\left(1- \frac{\hat{V}}{k}\right) - \frac{\hat{V}}{v_0 + \hat{V}}$$',...
    'interpreter','latex')

    %lets use quiver to plot the phase lines
    %Trying not to hard code this too much
    vstar=[0,-1+sqrt(3)];
    arrowsize = 0.2;
    x = [vstar,vstar] + 0.5*arrowsize *[0,-1,0,1];
    y = zeros(1,4);
    u = [-1,1,1,-1];
    v = zeros(1,4);
    quiver(x,y,u,v,arrowsize)

    hold off
    saveas(gcf,'ODEA1Q3c.eps','epsc')
    
    
    
%%3d
%use quiver to plot the vector field
%control the number of vectors to plot
%too many or too few is illegible...
numvpoints = 25;
numtpoints = 20;
vregion = linspace(-.2,1.2,numvpoints);
tregion = linspace(0,10,numtpoints);
[v,t] = meshgrid(vregion,tregion);

%generate the dv and dt, and normalise so the plot doesn't look awful
DVHAT = repmat(dvhat(vregion),numtpoints,1);
dt = ones(size(DVHAT));
DVHAT =DVHAT./(sqrt(DVHAT.^2 +dt.^2));
dt = dt./(sqrt(DVHAT.^2 +dt.^2));

    %plotting
    figure
    hold on
    %there is no change in t wrt V - hence zeros
    quiver(t,v,dt,DVHAT);
    xlabel('$$\hat{t}$$','interpreter','latex')
    ylabel('$$\hat{V}$$','interpreter','latex')
    title('Quiver plot of the vector field')
    axis([0,10,-.1,1.1])
    saveas(gcf,'ODEA1Q3d.eps','epsc')
    %no hold off since we want the quiver plot for 3e



%%3e
%solve dVhat numerically and plot at least
%2 solutions on the vector field to show 
%stability/instability of the fixed points

%new dvhat definition to include t (for ode45)
dvhatdt = @(t,vhat) vhat.*(1- vhat/k) - (vhat./(v0+vhat));

%first numerical solution with initial value 0.1
vat0 = 0.1;
[t,Vhat] = ode45(dvhatdt,[0,10],vat0);
    plot(t,Vhat)
    
%second numerical solution with initial value 0.8
vat0 = 0.8;
[t,Vhat] = ode45(dvhatdt,[0,10],vat0);
    plot(t,Vhat)
    legend('Vector Field','$$\hat{V}(0) = 0.1$$',...
    '$$\hat{V}(0) = 0.8$$','interpreter','latex')
    title('Quiver and plot $\hat{V}$ for different initial values',...
    'interpreter','latex'  )

    hold off
    saveas(gcf,'ODEA1Q3e.eps','epsc')