function [Q1,Q2] = SIRQ(N)
%Generate the Q matrix using the DA representation

%dim of final matrix
K = (N+1)*(N+2)/2;
Z = SIR_DA_mapping(N);

%Q1
%Q1 effectively contains the infection rates if beta = 1
%become infected with: IS/(N-1)
%I = z1-z2
%S = N-z1
qIe = (N-Z(:,1)).*(Z(:,1)-Z(:,2))/(N-1);
%positive values correspond to possible infection events
rowsI = find(qIe > 0);
%Using the DA representation, it
%moves to one state higher for infection event 
columnsI = rowsI + 1;
%grab all the non-zero elements of qIe
qI = qIe(rowsI);

Q1 = sparse(rowsI,columnsI,qI,K,K) + sparse(rowsI,rowsI,-qI,K,K);

%Q2
%Q2 is the recovery rates
%recover with I = (z1-z2)
qRe = (Z(:,1)-Z(:,2));
%positive values correspond to possible recovery events
rowsR = find(qRe >0);
%recovery event - we move down by N-Z2 
columnsR = rowsR+N-Z(rowsR,2);
qR = qRe(rowsR);
Q2 = sparse(rowsR,columnsR,qR,K,K) + sparse(rowsR,rowsR,-qR,K,K);
end
