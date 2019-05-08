function EstProb = Repairman2(istate,endstate, T, numsims)
%Repairman2
%Simulates the repairman problem for 2 machines
%%Inputs:
%istate - initial state of the markov chain takes values (0,1,2)
%endstate - state to consider on termination, takes values (0,1,2)
%T - duration for markov chain simulation T must be positive or the program
%will terminate
%numsims - Number of repetitions for the simulation (restarting at time 0)
%must be at least 1, must be an integer

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
        %cases for the 3 states
        if state == 0
            t = t + exprnd(30);
            ts = [ts; t];
            state = 1;
            ss = [ss; state];
        elseif state == 1
            t = t + exprnd(1/((1/10) + (1/60)));
            ts = [ts; t];
            if rand < (1/10)/((1/10) + (1/60))
                state = 0;
            else
                state = 2;
            end
            ss = [ss; state];
        else
            t = t + exprnd(10);
            ts = [ts; t];
            state = 1;
            ss = [ss; state];
        end
    end
    if ss(end-1) == endstate
        counter = counter + 1;
    end
    plot(si, counter/si, 'o')
end
EstProb = counter/si;