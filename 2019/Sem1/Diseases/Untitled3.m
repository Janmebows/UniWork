npoints = 10;
[x,y] = meshgrid(linspace(0.01,3,npoints));
for k = linspace(1,10)
    for u = linspace(1,100)
    dx = 1 - x - 4*x.*y./(u + x.^2);
    dy = y - 4*k*x.*y./(u + x.^2);    
    %start at 0.1 since we are dividing by x
    highresx= linspace(0.1,1);
    nx = 0.25 * (u./highresx + highresx - u - highresx.^2);
    ny1 = ones(1,npoints) * 2*k + sqrt(4*k^2 - u);
    ny2 = ones(1,npoints) * 2*k - sqrt(4*k^2 - u);

    quiver(x,y,dx,dy)
    hold on
    %x nullcline
    plot(highresx,nx,'g')
    %y nullclines
    plot(x(1,:),zeros(1,npoints),'r')
    if(imag(ny1)==0)
    plot(ny1,y(:,1),'r')
    plot(ny2,y(:,1),'r')
    end
    titlestr= "u = " + num2str(u) + " k = " + num2str(k);
    title(titlestr)
    %%
    %%Sumedh
    %odes 
    hatDot = @(t, hat)  [1 - hat(1) - (4*hat(1).*hat(2))/(u + hat(1).^2); hat(2) - (4*k*hat(1).*hat(2))./(u + hat(1).^2)];

    
    [t, solns] = ode45(hatDot, [0 10], [1; 2]);
    plot(solns(:,1), solns(:,2), 'b')
    [t, solns] = ode45(hatDot, [0 10], [0; 0.1]);
    plot(solns(:,1), solns(:,2), 'b')

    hold off
    xlabel("Dimensionless Concentration Iodine")
    ylabel("Dimensionless Concentration Chlorine dioxide")
    axis([0,3,0,3])
    drawnow()
    pause(0.001)
    end
end


