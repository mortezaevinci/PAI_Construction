
%points   linearly independent factors (rows or columns)    qsvd
%1600       1.9s                                            45s
%3200       7.04s                                            244s    
%9600       79.8s                                            2630 s
%(almost worst case for linearly independent is square matrix since A*A' is the biggest possible)
%9600 is almost close to square here (9600 x 12240)

P.twindow=0;
P.xsize=40; P.ysize=40; P.zsize=1;
P.opt='original';
P.regularize=0.1;
P.etol=1e-3;
P.numofpoints=1224;
P.numofvoxels=1600;
P.pta=4;

for ii=[1600 3600 9600];


testname=num2str(ii);

load('\\fv\Optics_drive\mor\pinvtests2\handheld40x40x6.mat');
rf2=rf2(1:ii,:)-8000;


tic
paa1 =rollingsvd(rf2,P);
t1=toc

recon1=(paa1*rf2(100,:)');

v1=recon1(100)

e1=sum(abs(recon1([1:99 101:end])))

s1=sum((recon1([1:99 101:end])))

std1=std((recon1([1:99 101:end])))



save([testname '.mat'],'t1','v1','e1','s1','std1');

end

% Elapsed time is 188.179053 seconds.
% 
% t1 =
% 
%   188.2087
% 
% 
% v1 =
% 
%     0.0766
% 
% 
% e1 =
% 
%     9.1025
% 
% 
% s1 =
% 
%     0.9225
% 
% 
% std1 =
% 
%     0.0044
% 
% Elapsed time is 1176.618310 seconds.
% 
% t1 =
% 
%    1.1767e+03
% 
% 
% v1 =
% 
%     0.0182
% 
% 
% e1 =
% 
%     7.5488
% 
% 
% s1 =
% 
%     0.9804
% 
% 
% std1 =
% 
%     0.0014




%1e-2
% Elapsed time is 0.408074 seconds.
% 
% t1 =
% 
%     0.4492
% 
% 
% v1 =
% 
%   6.2256e-04
% 
% 
% e1 =
% 
%     0.9974
% 
% 
% s1 =
% 
%     0.9974
% 
% 
% std1 =
% 
%   1.8544e-06
% 
% Elapsed time is 0.881309 seconds.
% 
% t1 =
% 
%     0.8885
% 
% 
% v1 =
% 
%   2.7642e-04
% 
% 
% e1 =
% 
%     0.9973
% 
% 
% s1 =
% 
%     0.9973
% 
% 
% std1 =
% 
%   7.9510e-07
% 
% Elapsed time is 2.398545 seconds.
% 
% t1 =
% 
%     2.4136
% 
% 
% v1 =
% 
%   1.0363e-04
% 
% 
% e1 =
% 
%     0.9973
% 
% 
% s1 =
% 
%     0.9973
% 
% 
% std1 =
% 
%   3.1242e-07
% 
