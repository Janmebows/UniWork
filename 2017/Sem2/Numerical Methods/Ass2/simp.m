function [I, h] = simp(func, a, b, n)
%Simpson integration
%simp calculates an approximation of the integral of func from [a,b] using
%n equi-spaced points
%INPUT
%func - function to integrate over
%a - left point
%b - right point
%Output
%I - the integral of the function.
%h - the distance between any two points
%Andrew Martin
%a1704466
%28/8/2017
h = (b - a)/(n - 1);
tj=a+(0:n-1)*h;
for i=1:n
fj(i,:) = func(tj(i)); % Value at each point according to Simpson's
end
fj=fj';
I = (h/3)*(fj(:,1)' + 4*sum(fj(:,2:2:n-1)') + 2* sum(fj(:,3:2:n-2)') + fj(:,end)');
end

