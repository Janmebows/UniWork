function q = Josh_FinalSize_Amended()
%using DA mapping for the SIR model
%Calcualte the final size distribution as well as the full vector p.
%code amended from
%Ross et Black
N = 100;
beta = 2/(N-1);
gamma = 1;
Psi = (N+1)*(N+2)/2;
final_size = zeros(N+1,1);
p_vec = zeros(Psi,1);
p_vec(2) = 1;
i = 1;
for Z2 = 0:N
    final_size(Z2+1) = p_vec(i);
    i = i + 1;
    for Z1 = Z2+1:N-1
        p1 = 1 / (1 - (gamma/beta)*((N-1)/(N-Z1)));
        p_vec(i+1) = p_vec(i+1)+ p_vec(i)*p1;
        p_vec(i + N - Z2) = p_vec(i + N - Z2)+ p_vec(i)*(1-p1);
        i = i + 1;
    end
    if Z2<N
        p_vec(i+N-Z2) = p_vec(i+N-Z2)+ p_vec(i);
        i = i + 1;
    end
end
bar(0:N,final_size);