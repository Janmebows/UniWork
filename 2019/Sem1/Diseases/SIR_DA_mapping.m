function Z = SIR_DA_mapping(N)
%SIR_DA_mapping(N) returns a matrix corresponding to
%[number of infection events, number of recovery events]
%For a population of size N
%N - population size for the model (must be a positive integer)
%for any given row:
%I = z1-z2
%S = N-z1-2z2

%bad input handling
if(N<= 0) 
    error("N must be a positive integer")
end
%number of rows for Z
K = (N+1) * (N+2)/2;
Z = zeros(K,2);
%row indexer for z
i = 1;
for z2 = 0:N
    for z1 = z2:N
        Z(i,:) = [z1,z2];
        i=i+1;
    end
end

end

