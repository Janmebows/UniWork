%Assignment2 Plot Code
%Plots the streamfunction found in assignment 2 question 3
%for given t and nu
%Andrew Martin
%1704466
%5/04/2018
clear all
close all
x = linspace(-2*pi,2*pi);
y = x;
[X,Y] = meshgrid(x,y);
nu = 1;
t=0;
psi = -exp(-2*nu*t).* cos(X).* cos(Y);
contour(X,Y,psi,1000)
title("Streamlines using streamfunction \psi")
xlabel("x")
ylabel("y")
yticks(-2*pi:pi/2:2*pi)
xticks(-2*pi:pi/2:2*pi)
xticklabels({'-2\pi','-3\pi/2','-\pi','-\pi/2','0','\pi/2','\pi','3\pi/2','2\pi'})
yticklabels({'-2\pi','-3\pi/2','-\pi','-\pi/2','0','\pi/2','\pi','3\pi/2','2\pi'})
legend("\nu =" + nu)
c= colorbar;
ylabel(c,'\psi');







%%Animation stuff
animation = VideoWriter('A2Anim.avi');
open(animation);

for t=linspace(0,0.5,10)
    psi = -exp(-2*nu*t).* cos(X).* cos(Y);
    contour(X,Y,psi,30)
    xlabel("x")
    ylabel("y")
    yticks(-2*pi:pi/2:2*pi)
    xticks(-2*pi:pi/2:2*pi)
    xticklabels({'-2\pi','-3\pi/2','-\pi','-\pi/2','0','\pi/2','\pi','3\pi/2','2\pi'})
    yticklabels({'-2\pi','-3\pi/2','-\pi','-\pi/2','0','\pi/2','\pi','3\pi/2','2\pi'})
    legend("\nu =" + nu)
    c= colorbar;
    %caxis([-0.2,0.2])
    ylabel(c,'\psi');
    hold on
    drawnow
    writeVideo(animation, getframe(gcf));
end
close(animation)