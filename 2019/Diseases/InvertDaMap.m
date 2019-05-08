function values = InvertDaMap(vec,N,includeZeroes)
%vec is a 1,N or N,1 vector with the DA mapping
%InvertDaMap extracts a vector corresponding to I for this mapping
%If includeZeroes == TRUE then the cases where Z1 - Z2 == 0 are in vec
if nargin==2
    includeZeroes=true;
end
    
Z = SIR_DA_mapping(N);
if ~includeZeroes
    ind = Z(:,1)-Z(:,2)~=0;
    Z = Z(ind,:);
end

%now use the values of the vec to getI
values =zeros(1,N);
%the ith index corresponds to I=i-1
for i=1:N+1
   indexer = Z(:,1)-Z(:,2)==i-1;
   values(i) =sum(vec(indexer));
   
end

end