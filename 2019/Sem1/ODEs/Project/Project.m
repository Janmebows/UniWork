
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


saveplots = 1;
npoints = 10;
[x,y] = meshgrid(linspace(0,10));
%less refined grid for quiver
smol_x = x(1:5:end,1:5:end);
smol_y = y(1:5:end,1:5:end);
figure
for c=[1,5,10]
    for b=[1,5,10]
        %%%DEs - for quiver plot
        dx = c - smol_x - 4.*smol_x.*smol_y./(1+smol_x.^2);
        dy = b*smol_x.*(1 - smol_y./(1+smol_x.^2));
        
        quiver(smol_x,smol_y,dx,dy)
        
        %%%NULLCLINES
        eta_x = 0.25 * (-x(1,:).^2 + c*x(1,:) - 1 + c./x(1,:));
        eta_y1 = 1+x(1,:).^2;
        eta_y2 = zeros(length(y(:,1)));
        
        %plot nullclines
        %green is x, red is y
        hold on
        plot(x(1,:),eta_x,'-.g')
        plot(x(1,:),eta_y1,'-.r')
        plot(eta_y2,y(:,1),'-.r',"HandleVisibility",'off')
        
        
        %%%FIXED POINT
        plot(c/5,1+c^2/25,'bx')
        axis([0,10,0,10])
        
        
        %%%EXAMPLE PATHS
        %ode system
        hatDot = @(t, hat)  [c - hat(1) - (4*hat(1).*hat(2))./(1 + hat(1).^2); b*hat(1) - (b*hat(1).*hat(2))./(1 + hat(1).^2)];     

        tspan = [0 10];
        %solutions
        [~, solns] = ode45(hatDot, tspan, [1; 2]); %finite start values close concentration values
        plot(solns(:,1), solns(:,2), 'Color',[1/2,2/3,0])
        [~, solns] = ode45(hatDot, tspan, [0; 0]); %almost 0 start value
        plot(solns(:,1), solns(:,2), 'Color',[0,1,0])
        [~, solns] = ode45(hatDot, tspan, [8; 0]); %huge difference1
        plot(solns(:,1), solns(:,2), 'Color',[1,0,0])
        [~, solns] = ode45(hatDot, tspan, [3; 10]); %high along the y nullcline
        plot(solns(:,1), solns(:,2), 'Color',[7/13,6/13,3/13])
        [~, solns] = ode45(hatDot, tspan, [0; 8]); %huge difference2
        plot(solns(:,1), solns(:,2), 'Color',[0,0,1])
        
        
        %plot labelling
        titlestr = "Phase portrait with $$c = " + num2str(c) + ", b = $$" + num2str(b);
        title(titlestr)
        legend("Vector field", "$$\eta_x$$", "$$\eta_y$$","Fixed point", "1,2","0,0","8,0","3,10","0,8")

        hold off
        %save the plots if saveplots ==1
        xlabel("Dimensionless Concentration Iodine")
        ylabel("Dimensionless Concentration Chlorine dioxide")
        drawnow
        if saveplots
            filestr = "ODEsProjectPlot_C"+num2str(c)+"B"+num2str(b)+".eps";
            saveas(gcf,filestr,'epsc')
        end
        pause
    end
end
%%
%Syms way to calculate the jacobian
syms x y b c
%jacobian
J =  [-1-(4*y-4*x^2*y)/((1+x^2)^2),-4*x/(1+x^2);b*(1-(y-x^2*y)/((1+x^2)^2)),-b*x/(1+x^2)];
%sub in the fixed point
J = subs(J,x,c/5)
J = subs(J,y,1+(c^2/25))
det(J)
trace(J)
eig(J)
