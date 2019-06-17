function boolean = ProposalConstraints(vals,min,max)
%
%OUTPUT:
%boolean - true if the boundary constraints are broken 
boolean = any(vals < min | vals > max);
  
end