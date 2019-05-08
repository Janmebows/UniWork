function F=besselint(t,x,nu)
%Bessel function integration
%Inputs
%t - vector of equispaced values over [0,pi]
%x - vector of equispaced values in some interval [0,L]
%nu - integer value for the particular bessel function
%Outputs
%F - matrix containing the integrand at all combinations of x and t
%Andrew Martin
%a1704466
%28/8/2017


[X,T] = meshgrid(x,t);
F=cos(nu*T -X.*sin(T))/pi;

end