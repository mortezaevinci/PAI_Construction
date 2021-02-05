load 'test2.mat';
load 'noisescan.mat';



rf=rf';
rfn=rfn';

frfn=fft(rfn);
noiseProfile=(sum(frfn')')/500;



rf=rf-mean(mean(rf));

noisyrf=rf+(rand(size(rf))-0.5)*.02*max(max(rf));


%****GOOD MEASRES
%***real(), imag(), real+imag, imag-real


tic
RF=fft2(rf);    %***needs to be in correct dimnsion (applied to signal)

RF2=RF-repmat(noiseProfile,1,500);

smax=sum(abs(RF))*rfr;
SMAX=repmat(smax,rfr,1);
RF=RF./SMAX;

smax2=sum(abs(RF2))*rfr;
SMAX2=repmat(smax2,rfr,1);
RF2=RF2./SMAX;

mRF=RF;%imag(RF)+real(RF); 
mRF2=RF2;imag(RF2)+real(RF2);
%RF=RF(1:end/2,1:end/2);
toc


%filter out unwanted elements from mRF
%mRF(1:25,:)=0;
%mRF(250:1750,:)=0;
%mRF(975:1000,:)=0;
mRF(1:500)=0;
mRF(1000:1900)=0;
mRF2(1:500)=0;
mRF2(1000:1900)=0;

noisyRF=fft2(noisyrf); %***needs to be in correct dimnsion (applied to signal)
%for one signal: noisyRF=noisyRF-noiseProfile;

noisyRF2=noisyRF-repmat(noiseProfile,1,500);

mnoisyRF=imag(noisyRF)+real(noisyRF);
mnoisyRF2=imag(noisyRF2)+real(noisyRF2);

[u,s,v]=svd(mRF,'econ');
mx=max(max(s));
s(s<mx*.1)=0;
mRFinv=v*pinv(s)*u';

%for spraseness
mxi=max(max(mRFinv));
mni=min(min(mRFinv));
mRFinv(mRFinv>0 & mRFinv<mxi*.1)=0;
mRFinv(mRFinv<0 & mRFinv>mni*.1)=0;


[u,s,v]=svd(mRF2,'econ');
mx=max(max(s));
s(s<mx*.1)=0;
mRF2inv=v*pinv(s)*u';

%for spraseness
mxi=max(max(mRF2inv));
mni=min(min(mRF2inv));
mRF2inv(mRF2inv>0 & mRF2inv<mxi*.1)=0;
mRF2inv(mRF2inv<0 & mRF2inv>mni*.1)=0;


[u,s,v]=svd(rf,'econ');
mx=max(max(s));
s(s<mx*.1)=0;
rfinv=v*pinv(s)*u';


O=ifft2(mRFinv*(mnoisyRF));
O=abs(O);
O=O(rfc:-1:1,:);
O=circshift(O,1);
O=O/max(max(O));

O2=ifft2(mRF2inv*(mnoisyRF2));
O2=abs(O2);
O2=O2(rfc:-1:1,:);
O2=circshift(O2,1);
O2=O2/max(max(O2));

o=rfinv*noisyrf;
o=o-min(min(o));
o=o/max(max(o));

figure;imagesc(O);
figure;imagesc(O2);
figure;imagesc(o);


I=eye(size(O));

E=sum(sum(abs(I-O)))
E2=sum(sum(abs(I-O2)))
e=sum(sum(abs(I-o)))

dE=sum(abs(diag(I-O)))
dE2=sum(abs(diag(I-O2)))
dE=sum(abs(diag(I-o)))