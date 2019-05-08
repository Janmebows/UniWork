function Q = SIGeneratorNaive(N,beta,gamma)

Q = zeros(N+1,N+1);
for i = 1:N-1
    Q(i+1,i+2) = beta*i*(N-i)/(N-1);
    Q(i+1,i) = gamma*i; 
end
    
Q(N+1,N) = N * gamma;

Q = Q - diag(sum(Q,2));
end




