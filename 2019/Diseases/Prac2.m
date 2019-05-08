
%%SIS Gen
I0 = 1;
beta = 3;
gamma =1;
tmax = 5;
N=5;
    ts=1;
    p0 = zeros(N+1,1);
    p0(2)=1;
    [Q1,Q2] = SISQ(N);
    Q = beta*Q1 + gamma*Q2;
    
    %ODE
    options = odeset('RelTol', 1e-6, 'AbsTol',1e-6);
    [tode,pode]= ode45(@SISfe, (0:ts:tmax),p0,options,Q);
    
    %EXPM part
    TF = expm(Q*ts);
    pexpm(1,:) = p0;
    %pmexpv(1,:) = p0;
    for i = 2:tmax/ts+1
    pexpm(i,:) = pexpm(i-1,:)*TF;
    % requires expokit
    %pmexpv(i,:) = mexpv((0:ts:tmax),Q',pmexpv(i-1,:),1e-6);
    end
    
    



function dp = SISfe(t,p,Q)
dp = Q'*p;
end

function [Q1,Q2] = SISQ(N)

rows = [1:N-1] + 1;
columnsI = rows + 1;
columnsR = rows - 1;
Q1 = sparse(rows,columnsI,[1:N-1].*(N-[1:N-1])/(N-1),N+1,N+1) +...
    sparse(rows,rows,-[1:N-1].*(N-[1:N-1])/(N-1),N+1,N+1);

Q2 = sparse(rows,columnsR, [1:N-1],N+1,N+1) +...
    sparse(rows,rows, -[1:N-1],N+1,N+1);

Q1(N+1,N) = N;
Q1(N+1,N+1) = - Q1(N+1,N);
end