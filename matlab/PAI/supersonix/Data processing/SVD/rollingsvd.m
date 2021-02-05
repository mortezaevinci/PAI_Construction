function [pseudoinvq,u,sv,v] = rollingsvd(IOraw,P)
% SVD per transducer, per transducer per plane, or original
%   output = compiled pseudoinvq and singular values(sv)
%

v2struct(P)

u = []; v = []; sv = []; 

% For fewer time indices
if twindow > 0
    numpoints = length(twindow(1):twindow(2));
else
    numpoints = ceil(numofpoints/pta);
end

numofvoxels = xsize*ysize*zsize;

if strcmp(P.opt,'transducer') == 1
% SVD PER TRANSDUCER

% Use this when not enough memory
% tic
% pseudoinvq = sonixpseudopertrans(P);
% toc

% Preallocate
sv = zeros(numpoints,numoftra,'single');
uv = zeros(numpoints,numpoints,numoftra,'single');
vv = zeros(numofvoxels,numpoints,numoftra,'single');
pseudoinvq = zeros(xsize*ysize*planes,numpoints,numoftra,'single');

% Per transducer
tic
for i = 1:numoftra
    % QSVD
    [u,s,v] = qsvd(double(abs(squeeze(IOraw(:,:,i)))'),etol); %rectify                       

    [m,~] = size(s);                    
    t1 = padarray(diag(s),[numpoints-m 0],'post');
    t2 = padarray(u,[0 numpoints-m],'post');
    t3 = padarray(v,[0 numpoints-m],'post');

    % Store USV                
    sv(:,i) = t1;
    uv(:,:,i) = t2;
    vv(:,:,i) = t3;
    
    % Regularize singular values
    x = s(1,1); 
    thresh = regularize*x;
    s(s<thresh) = 0;    

    % Pseudoinverse of singular values
    sinv = qpinv(s);
%     sinv = zeros(sz,sz);
%     sinv(logical(eye(nnz(s)))) = 1./(diag(s(1:nnz(s),1:nnz(s))));
%     sinv = (sinv');      
    
%     % Place sv along diagonal of matrix        
%     sz = length(sv);
%     s = zeros(sz,sz);
%     s(logical(eye(sz))) = sv;                

    %%% TODO: Filter singular vectors (threshold/smooth) specifically u 
    
    pq = v*sinv*u';    

    % Threshold
%     pq((abs(pq/max(abs(pq)))<(threshperc/100)))=0;

    % Pseudoinverse
    pseudoinvq(:,:,i) = pq;    
end
toc
pseudoinvq = reshape(pseudoinvq,numofvoxels,[]);

elseif strcmp(opt,'original') == 1
% SVD ORIGINAL (if enough memory)
tic
% load(P.file.IOfile,'IOraw')
[u,sv,v]=qsvd(double(IOraw)',etol); 
% clear IOraw

% Regularize
if regularize > 0
    [m,~] = size(sv); sv(round(numofvoxels*regularize):m, round(numofvoxels*regularize):m)=zeros;
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
pseudoinvq =(v)*(s112t_invq)*(u');
toc

else
    disp('Error: select proper SVD option (original or transducer)');
    return;
end