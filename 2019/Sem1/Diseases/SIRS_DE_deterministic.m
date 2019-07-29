function dIS = SIRS_DE_deterministic(t,IS,params)
I = IS(1);
S = IS(2);
N = params(1);
beta = params(2);
gamma = params(3);
mu = params(4);
dIS = [beta*I.*S/(N) - gamma*I;-beta*I.*S/(N) + mu*(N-I-S)];
end