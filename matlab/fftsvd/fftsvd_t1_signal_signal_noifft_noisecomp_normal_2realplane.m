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
RF=fft(rf,[],1);    %***needs to be in correct dimnsion (applied to signal)

RF2=RF;%-real(repmat(noiseProfile,1,rfc));

smax=sum(abs(RF))/rfc/pi^2;
SMAX=repmat(smax,rfr,1);
%RF=RF./SMAX;

smax2=sum(abs(RF2))/rfc/pi^2;
SMAX2=repmat(smax2,rfr,1);
RF2=RF2./SMAX2;

mRF=RF;%imag(RF)+real(RF); 
mRF2=RF2;%imag(RF2)+real(RF2);
%RF=RF(1:end/2,1:end/2);
toc


%filter out unwanted elements from mRF
%mRF(1:25,:)=0;
%mRF(250:1750,:)=0;
%mRF(975:1000,:)=0;

% mRF(1:500)=0;
% mRF(1000:1900)=0;
% mRF2(1:500)=0;
% mRF2(1000:1900)=0;

timeprofile=max(mRF')./mean(abs(mRF'));
ind=find(timeprofile<5);
mRF(ind)=0;

timeprofile=max(mRF2')./mean(abs(mRF2'));
ind=find(timeprofile<5);
mRF2(ind)=0;


tic

noisyRF=fft(noisyrf,[],1); %***needs to be in correct dimnsion (applied to signal)
%for one signal: noisyRF=noisyRF-noiseProfile;

noisyRF2=noisyRF;%-repmat(noiseProfile,1,500);

mnoisyRF=noisyRF;%imag(noisyRF)+real(noisyRF);
mnoisyRF2=noisyRF2;%imag(noisyRF2)+real(noisyRF2);


toc

reg=0.05;

tic
[u,s,v]=svd(mRF,'econ');
mx=max(max(s));
s(s<mx*reg)=0;
mRFinv=v*pinv(s)*u';

%for spraseness
mxi=max(max(mRFinv));
mni=min(min(mRFinv));
mRFinv(mRFinv<mxi*reg & mRFinv>mni*reg)=0;
%mRFinv=mRFinv.*(SMAX');

[u,s,v]=svd(mRF2,'econ');
mx=max(max(s));
s(s<mx*reg)=0;
mRF2inv=v*pinv(s)*u';

%for spraseness
mxi=max(max(mRF2inv));
mni=min(min(mRF2inv));
mRF2inv(mRF2inv<mxi*reg & mRF2inv>mni*reg)=0;


[u,s,v]=svd(rf,'econ');
mx=max(max(s));
s(s<mx*reg)=0;
rfinv=v*pinv(s)*u';


O=mRFinv*mnoisyRF;
O=abs(O);


MO=mean(diag(O))
O=O/MO;

O2=mRF2inv*mnoisyRF2;
O2=abs(O2);
MO2=mean(diag(O2))
O2=O2/MO2;

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