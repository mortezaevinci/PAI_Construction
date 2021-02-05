
%points   linearly independent factors (rows or columns)    qsvd
%1600       1.9s                                            45s
%3200       7.04s                                            244s    
%9600       79.8s                                            2630 s
%(almost worst case for linearly independent is square matrix since A*A' is the biggest possible)
%9600 is almost close to square here (9600 x 12240)


testname='9600';

load('\\fv\Optics_drive\mor\handheld40x40x6.mat');
%rf2=rf2(1:3200,:);

if size(rf2,1)<size(rf2,2)

tic
paa2=rf2'*(rf2*rf2')^-1;
t2=toc

else

tic
paa2=(rf2'*rf2)^-1*rf2';
t2=toc


end

drawnow;

tic
[u,s,v]=qsvd(rf2,1e-2);
sinv = qpinv(s);
paa1 =(v)*(sinv)*(u');
t1=toc

recon1=(paa1'*rf2(100,:)');
recon2=(paa2'*rf2(100,:)');
v1=recon1(100)
v2=recon2(100)
e1=sum(abs(recon1([1:99 101:end])))
e2=sum(abs(recon2([1:99 101:end])))
s1=sum((recon1([1:99 101:end])))
s2=sum((recon2([1:99 101:end])))
std1=std((recon1([1:99 101:end])))
std2=std((recon2([1:99 101:end])))


save([testname '.mat'],'t1','t2','v1','v2','e1','e2','s1','s2','std1','std2');
% 1600 comparison
% 
% ans =
% 
%     0.9456
% 
% 
% ans =
% 
%     1.0000
% 
% 
% ans =
% 
%     7.7695
% 
% 
% ans =
% 
%    1.2667e-12
% 
% 
% ans =
% 
%     0.0484
% 
% 
% ans =
% 
%    1.7279e-14
% 
% 
% ans =
% 
%     0.0063
% 
% 
% ans =
% 
%    1.0192e-15


%3200 comparison
% ans =
% 
%     0.9193
% 
% 
% ans =
% 
%     1.0000
% 
% 
% ans =
% 
%    12.9167
% 
% 
% ans =
% 
%    3.0692e-11
% 
% 
% ans =
% 
%     0.0880
% 
% 
% ans =
% 
%   -9.3670e-13
% 
% 
% ans =
% 
%     0.0052
% 
% 
% ans =
% 
%    1.2861e-14


% 9600

% v1 =
% 
%     0.7844
% 
% 
% v2 =
% 
%     1.0000
% 
% 
% e1 =
% 
%    33.6307
% 
% 
% e2 =
% 
%    1.0063e-08
% 
% 
% s1 =
% 
%     0.2111
% 
% 
% s2 =
% 
%   -6.3625e-11
% 
% 
% std1 =
% 
%     0.0045
% 
% 
% std2 =
% 
%    1.3676e-12