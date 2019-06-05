function boolean = ProposalConstraints(vals,min,max)
%
%OUTPUT:
%boolean - true if the boundary constraints are broken 
boolean = any(vals < min | vals > max);


% %hardcoded way
% boolean  =vals(1) < 0 || vals(1) > 5 ...
%        || vals(2) < min || vals(2) > max ...
%        || vals(3) < min || vals(3) > max;
    
end