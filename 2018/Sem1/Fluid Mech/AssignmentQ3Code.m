%%%%Question 3%%%%

clear all
close all
a=0.75;
b=0.25;
c = -1;
n=20;
T=10;
theta = linspace(0,pi,n);
phi = linspace(0,2*pi,n);
u = @(t,x) [a*x(1);b*x(2);c*x(3)];

%%%INITIAL CONDITION PLOT - SPHERE

figure

for(i=1:n)
    for(j=1:n)
        x0 =  [sin(theta(i)).*cos(phi(j));sin(theta(i)).*sin(phi(j));cos(theta(i))];
        scatter3(x0(1),x0(2),x0(3),3,[0,0,1],'filled');%blue
        hold on
        
    end
end
axis square
title('No deformation - Initial condition')
legend('Initial case')
xlabel('x')
ylabel('y')
zlabel('z')

%%%FIRST CASE

figure

for(i=1:n)
    for(j=1:n)
        x0 =  [sin(theta(i)).*cos(phi(j));sin(theta(i)).*sin(phi(j));cos(theta(i))];
        scatter3(x0(1),x0(2),x0(3),3,[0,0,1],'filled');%blue
        t = linspace(0, T, n);
        [t, x] = ode45(u, t, x0);
        hold on
        scatter3(x(end,1),x(end,2),x(end,3),3,[1,0,0],'filled'); %red
        
    end
end
axis square
title('First case deformation with time')
legend('Initial t=0','t=10')
    xlabel('x')
    ylabel('y')
    zlabel('z')

    
    
    
%%%SECOND CASE
a=1.25;
b=-0.25;
c = -1;
u = @(t,x) [a*x(1);b*x(2);c*x(3)];
figure

for(i=1:n)
    
    for(j=1:n)
        x0 =  [sin(theta(i)).*cos(phi(j));sin(theta(i)).*sin(phi(j));cos(theta(i))];
        scatter3(x0(1),x0(2),x0(3),3,[0,0,1],'filled');%blue
        t = linspace(0, T, n);
        [t, x] = ode45(u, t, x0);
        hold on
        scatter3(x(end,1),x(end,2),x(end,3),3,[0,1,0],'filled'); %green
        
    end

end
title('Second case deformation with time')
legend('Initial t=0','t=10')
axis square
    xlabel('x')
    ylabel('y')
    zlabel('z')

