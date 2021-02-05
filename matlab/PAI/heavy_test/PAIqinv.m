%modified by Morteza Heydari Araghi

function qinv = PAIqinv(IO,PAIheader)

io2=size(IO,2);

% For fewer time indices
if PAIheader.twindow > 0
    numpoints = length(twindow(1):twindow(2));
else
    numpoints = ceil(PAIheader.numofpoints/PAIheader.pta);
end

%% SVD ORIGINAL 



[u,sv,v]=qsvd(double(IO),PAIheader.etol); clear IO;

u = single(u);
sv = single(sv);
v = single(v);
    [m,~] = size(sv);
    
% Regularize
if PAIheader.svdRegulation > 0
    [m,~] = size(sv); sv(round(io2*PAIheader.svdRegulation):m, round(io2*PAIheader.svdRegulation):m)=zeros;
end

%Pseudoinverse of S
s112t_invq = qpinv(sv);
% s112t_invq = zeros(m,m);
% s112t_invq(logical(eye(nnz(sv)))) = 1./(diag(sv(1:round(numofvoxels*reg)-1,1:round(numofvoxels*reg)-1)));
% s112t_invq = s112t_invq';

% u = single(u);
% sv = single(sv);
% v = single(v);

%Compute pseudoinverse of imaging operator per transducer
qinv =(v)*(s112t_invq)*(u');



end