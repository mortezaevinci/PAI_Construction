
load('\\fv\Optics_drive\mor\handheld40x40x6.mat');
rf2=rf2(1:1600,:);

if size(rf2,1)<size(rf2,2)

tic
paa2=rf2'*(rf2*rf2')^-1;
toc

else

tic
paa2=(rf2'*rf2)^-1*rf2';
toc


end

drawnow;

tic
[u,s,v]=qsvd(rf2,1e-2);
sinv = qpinv(s);
paa1 =(v)*(sinv)*(u');
toc

recon1=(paa1'*rf2(100,:)');
recon2=(paa2'*rf2(100,:)');
recon1(100)
recon2(100)
sum(abs(recon1([1:99 101:end])))
sum(abs(recon2([1:99 101:end])))
sum((recon1([1:99 101:end])))
sum((recon2([1:99 101:end])))
std((recon1([1:99 101:end])))
std((recon2([1:99 101:end])))


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
