function x = jacobi(A,b)
D=1./diag(A);
x=zeros(size(b));
tol =1.0e-6;
maxiterations = 1000;
for i = 1:maxiterations 
r=A*x-b;
x=x-D.*r;
   if norm(r) < tol
       return
   end
end
warning('YOU DONE FUCKED IT THIS AINT GON WORK BOIIII');
end