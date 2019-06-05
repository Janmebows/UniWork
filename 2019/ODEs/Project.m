npoints = 10;
[x,y] = meshgrid(linspace(0.01,5,npoints));
for k = linspace(0.1,5,30)
    for u = linspace(0.1,10,30)
    dx = 1 - x - 4*x.*y./(u + x.^2);
    dy = y - 4*k*x.*y./(u + x.^2);
    %start at 0.1 since we are dividing by x
    highresx = linspace(0.1,5);
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
    
    %odes 
    hatDot = @(t, hat)  [1 - hat(1) - (4*hat(1).*hat(2))/(u + hat(1).^2); hat(2) - (4*k*hat(1).*hat(2))./(u + hat(1).^2)];

    tspan = [0 10];
    %solutions
    [t, solns] = ode45(hatDot, tspan, [1; 2]);
    plot(solns(:,1), solns(:,2), 'b')
    [t, solns] = ode45(hatDot, tspan, [0; 0.1]);
    plot(solns(:,1), solns(:,2), 'b')
    [t, solns] = ode45(hatDot, tspan, [0.1; 0]); %new
    plot(solns(:,1), solns(:,2), 'b')
    
    fp1x = 1; fp1y = 0;
    
    fp2x = 2*k - sqrt(4*k^2 - u);
    fp2y = k*(-2*k  + sqrt(4*k^2 - u) + 1);
    
    fp3x = 2*k + sqrt(4*k^2 - u);
    fp3y = k*(-2*k  - sqrt(4*k^2 - u) + 1);
    if(u <= 4*k^2)
    plot(fp2x, fp2y, '*', 'MarkerSize', 5, 'MarkerEdgeColor', 'red'), 
    plot(fp1x, fp1y, '*', 'MarkerSize', 5, 'MarkerEdgeColor', 'red');
    end
    %%Instead of everything from fp1x ... plot(fp1x...)
    %xsolPos = 2*k+sqrt(4*k^2-u);
    %xsolNeg =2*k-sqrt(4*k^2-u);
    %plot(xsolPos,0.25*(u/xsolPos + xsolPos - u - xsolPos^2),'kx')
    %plot(xsolNeg,0.25*(u/xsolNeg + xsolNeg - u - xsolNeg^2),'kx')
    
    
    hold off
    xlabel("Dimensionless Concentration Iodine")
    ylabel("Dimensionless Concentration Chlorine dioxide")
    axis([0,5,0,5])
    drawnow()
    pause
    end
end

%%
%%bifurcations
figure
k = linspace(0,10);
plot(k,4*k.^2,':')

%%Random sym shit
syms y x u k 
yeq = 0.25 *(u/x + x - u - x^2);
ypos=subs(yeq,x,2*k+sqrt(4*k^2-u));
solve(ypos==y)
yneg=subs(yeq,x,2*k-sqrt(4*k^2-u));
solve(yneg==y,u)

