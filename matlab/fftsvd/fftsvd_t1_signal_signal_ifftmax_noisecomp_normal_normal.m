load 'test2.mat';
load 'noisescan.mat';



rf=rf';
rfn=rfn';

frfn=fft(rfn);
noiseProfile=(sum(frfn')')/500;



rf=rf-mean(mean(rf));

noisyrf=rf+(rand(size(rf))-0.5)*.03*max(max(rf));

[rfr,rfc]=size(rf);
%****GOOD MEASRES
%***real(), imag(), real+imag, imag-real


tic
RF=fft(rf);    %***needs to be in correct dimnsion (applied to signal)

RF2=RF-real(repmat(noiseProfile,1,rfc));

smax=sum(abs(RF))/rfc/pi^2;
SMAX=repmat(smax,rfr,1);
%RF=RF./SMAX;

smax2=sum(abs(RF2))/rfc/pi^2;
SMAX2=repmat(smax2,rfr,1);
%RF2=RF2./SMAX2;

mRF=RF;%imag(RF)+real(RF); 
mRF2=RF2;%imag(RF2)+real(RF2);
%RF=RF(1:end/2,1:end/2);
toc


%filter out unwanted elements from mRF
%mRF(1:25,:)=0;
%mRF(250:1750,:)=0;
%mRF(975:1000,:)=0;


noisyRF=fft(noisyrf,[],1); %***needs to be in correct dimnsion (applied to signal)
%for one signal: noisyRF=noisyRF-noiseProfile;

noisyRF2=noisyRF-repmat(noiseProfile,1,500);

mnoisyRF=noisyRF;%imag(noisyRF)+real(noisyRF);
mnoisyRF2=noisyRF2;%imag(noisyRF2)+real(noisyRF2);


[u,s,v]=svd(rf,'econ');
mx=max(max(s));
s(s<mx*.1)=0;
rfinv=v*pinv(s)*u';


O=(mRF'*mnoisyRF);
O=abs(O);

MO=mean(diag(O))
O=O/MO;

h=fspecial('gaussian',3,1);
O=imfilter(O,h);


o=rfinv*noisyrf;
o=o-min(min(o));
o=o/max(max(o));

figure;imagesc(O);


hold on
[~,cind]=max(O,[],2);
for ii=1:size(O,1);
    plot(cind(ii),ii,'r.');
end
hold off


figure;imagesc(o);


I=eye(size(O));

E=sum(sum(abs(I-O)))
e=sum(sum(abs(I-o)))

dE=sum(abs(diag(I-O)))
dE=sum(abs(diag(I-o)))