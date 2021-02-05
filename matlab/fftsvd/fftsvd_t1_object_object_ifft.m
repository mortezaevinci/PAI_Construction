load 'test2.mat';

rf=rf';

rf=rf-mean(mean(rf));

noisyrf=rf+(rand(size(rf))-0.5)*.1*max(max(rf));


%****GOOD MEASRES
%***real(), imag(), real+imag, imag-real


tic
RF=fft(rf,[],2);    %***needs to be in correct dimnsion (applied to signal)
mRF=imag(RF)+real(RF);   
%RF=RF(1:end/2,1:end/2);
toc


%filter out unwanted elements from mRF
%mRF(1:25,:)=0;
%mRF(250:1750,:)=0;
%mRF(975:1000,:)=0;
mRF(1:500)=0;
mRF(1000:1900)=0;

noisyRF=fft(noisyrf,[],2); %***needs to be in correct dimnsion (applied to signal)
mnoisyRF=imag(noisyRF)+real(noisyRF);

[u,s,v]=svd(mRF,'econ');
mx=max(max(s));
s(s<mx*.1)=0;
mRFinv=v*pinv(s)*u';

[u,s,v]=svd(rf,'econ');
mx=max(max(s));
s(s<mx*.1)=0;
rfinv=v*pinv(s)*u';


O=ifft2(mRFinv*mnoisyRF);
O=abs(O);
O=O(500:-1:1,:);
O=circshift(O,1);
O=O/max(max(O));

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