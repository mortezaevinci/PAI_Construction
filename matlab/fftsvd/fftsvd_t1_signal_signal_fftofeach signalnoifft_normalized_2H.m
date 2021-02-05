load 'C:\temp\organized tests\sonixDAQ-based\scan1 2013-11-21\Hsmall_3of5_32sensors';
rf=H';

load 'C:\temp\organized tests\sonixDAQ-based\scan2 2013-11-21\Hsmall_3of5_32sensors';
noisyrf=H';




rf=rf-mean(mean(rf));
noisyrf=noisyrf-mean(mean(noisyrf));


[rfr,rfc]=size(rf);
%****GOOD MEASRES
%***real(), imag(), real+imag, imag-real


tic
for ss=1:32
    sind=(1+(ss-1)*1000):(ss*1000);
    
RF(sind,:)=fft(rf(sind,:),[],1);    %***needs to be in correct dimnsion (applied to signal)
end

smax=sum(abs(RF));
SMAX=repmat(smax,rfr,1);
%RF=RF./SMAX;

mRF=RF; 

%RF=RF(1:end/2,1:end/2);
toc


%filter out unwanted elements from mRF

for ss=1:32
    sind=(1+(ss-1)*1000):(ss*1000);
    
noisyRF(sind,:)=fft(noisyrf(sind,:),[],1);    %***needs to be in correct dimnsion (applied to signal)
end

%for one signal: noisyRF=noisyRF-noiseProfile;

mnoisyRF=noisyRF;%imag(noisyRF)+real(noisyRF);

reg=0.15;

tic
[u,s,v]=svd(mRF,'econ');
mx=max(max(s));
s(s<mx*reg)=0;
mRFinv=v*pinv(s)*u';
toc

%for spraseness
mxi=max(max(mRFinv));
mni=min(min(mRFinv));
mRFinv(mRFinv<mxi*reg & mRFinv>mni*reg)=0;
%mRFinv=mRFinv.*(SMAX');

tic
[u,s,v]=svd(rf,'econ');
mx=max(max(s));
s(s<mx*reg)=0;
rfinv=v*pinv(s)*u';
toc

mxi=max(max(rfinv));
mni=min(min(rfinv));
rfinv(rfinv<mxi*reg & rfinv>mni*reg)=0;


O=mRFinv*mnoisyRF;   %(SMAX)'.*
O=abs(O);

O=O.*(SMAX'*SMAX).^0.5;
O=O*1e-10;
O=O-min(min(O));

MO=mean(diag(O))
O=O/MO;

o=rfinv*noisyrf;
o=o-min(min(o));

Mo=mean(diag(o))
o=o/Mo;


figure;imagesc(O);
figure;imagesc(o);


I=eye(size(O));

E=sum(sum(abs(I-O)))
e=sum(sum(abs(I-o)))

dE=sum(abs(diag(I-O)))
de=sum(abs(diag(I-o)))