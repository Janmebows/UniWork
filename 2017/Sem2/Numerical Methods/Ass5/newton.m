function x0 = newton(func, x0, tol)
%newton approximates a zero of a function using newton approximation
%INPUTS
%func - the function of x to calculate over (FUNCTION HANDLE)
%x0   - initial guess value
%tol  - how accurate to make the solution
%OUTPUTS
%x0   - the approximated solution
h= 1e-4;
deriv = @(x) (func(x+h) -func(x));
for i = 1:100
    dx = h * func(x0)/deriv(x0);
    x0 = x0 - dx;
    if(abs(dx)<tol)
        break;
    end
end

end