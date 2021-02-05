load 'C:\temp\organized tests\pai128-based\handheld 40ch 40x40x40 1224pta4\sliced\matsliced_dimension2_plane10.mat';

rf=matslice;
rf=rf-mean(mean(rf));





load 'C:\temp\organized tests\pai128-based\handheld 40ch 40x40x40 1224pta4\sliced\matsliced_dimension2_plane11.mat';

noisyrf=matslice;
noisyrf=noisyrf-mean(mean(noisyrf));


rf=rf';
noisyrf=noisyrf';

noisyrf=noisyrf+(rand(size(noisyrf))-0.5)*.05*max(max(noisyrf));

[rfr,rfc]=size(rf);


%****GOOD MEASRES
%***real(), imag(), real+imag, imag-real


tic
RF=fft2(rf);    %***needs to be in correct dimnsion (applied to signal)

smax=sum(abs(RF))*rfr;
SMAX=repmat(smax,rfr,1);
RF=RF./SMAX;



mRF=imag(RF)+real(RF); 
%RF=RF(1:end/2,1:end/2);
toc


%filter out unwanted elements from mRF

%mRF(1:500)=0;
%mRF(1000:1900)=0;

%auotmatic unwanted element cancellation in mRF
timeprofile=max(mRF')./mean(abs(mRF'));

ind=find(timeprofile<5);

mRF(ind)=0;

noisyRF=fft2(noisyrf); %***needs to be in correct dimnsion (applied to signal)
%for one signal: noisyRF=noisyRF-noiseProfile;


mnoisyRF=imag(noisyRF)+real(noisyRF);


reg=0.05;


tic
[u,s,v]=svd(mRF,'econ');
mx=max(max(s));
s(s<mx*reg)=0;
mRFinv=v*pinv(s)*u';

%for spraseness
mxi=max(max(mRFinv));
mni=min(min(mRFinv));
mRFinv(mRFinv>0 & mRFinv<mxi*reg)=0;
mRFinv(mRFinv<0 & mRFinv>mni*reg)=0;
toc

tic
[u,s,v]=svd(rf,'econ');
mx=max(max(s));
s(s<mx*reg)=0;
rfinv=v*pinv(s)*u';
toc

O=ifft2(mRFinv*mnoisyRF);
O=abs(O);
O=O(rfc:-1:1,:);
O=circshift(O,1);

mo=mean(diag(O));

%O=O/mo;

o=rfinv*noisyrf;
o=o-min(min(o));
o=o/max(max(o));

figure;imagesc(O);
figure;imagesc(o);


I=eye(size(O));

E=sum(sum(abs(I-O)))
e=sum(sum(abs(I-o)))

dE=sum(abs(diag(I-O)))
dE=sum(abs(diag(I-o)))