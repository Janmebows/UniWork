function [Q1,Q2,Q] = SIRModel(N,beta,gamma)
Q = spalloc(1/2*(N+1)*(N+2), 1/2*(N+1)*(N+2), 3/2*(N+1)*(N+2));


for i= 1:N+1
    for j=1:N+1
        if i+j <= N+2)
           if i=1 && j =1
               
        end
    end
end
IndexMap = SIR_DA_MAP(N);



%Q1 = sparse

%Q2 = 

Q = beta*Q1 + gamma Q2;

end