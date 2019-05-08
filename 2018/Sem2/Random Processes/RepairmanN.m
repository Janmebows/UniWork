function EstProb = RepairmanN(istate,endstate, T, numsims,N)
%RepairmanN
%Simulates the repairman problem for N machines
%%Inputs:
%istate - initial state of the markov chain takes values (0,1,2)
%endstate - state to consider on termination, takes values (0,1,2)
%T - duration for markov chain simulation T must be positive or the program
%will terminate
%numsims - Number of repetitions for the simulation (restarting at time 0)
%must be at least 1, must be an integer
%N - number of machines
%%Output:
%EstProb - the probability of reaching endstate based on the number of
%simulations

figure
hold
counter = 0;

%sim number
for si = 1:numsims
    %initialise time and timestep to 0
    t = 0;
    ts = 0;
    %Initial state is state
    state = istate;
    ss = istate;
    %Repeat until we exit the allowed time
    while t < T
        %if all machines are working
        if state == 0
            t = t + exprnd(30);
            ts = [ts; t];
            state = 1;
            ss = [ss; state];
        elseif state== N
            t = t + exprnd(10);
            state = state-1;
            ts = [ts; t];
            ss = [ss; state];
        else
            t = t + exprnd(1/((1/10) + (1/60)));
            ts = [ts; t];
            if rand < (1/10)/((1/10) + (1/60))
                state = state-1;
            else
                state = state +1;
            end
            ss = [ss; state];

        end
    end
    if ss(end-1) == endstate
        counter = counter + 1;
    end
    plot(si, counter/si, 'o')
end
EstProb = counter/si;