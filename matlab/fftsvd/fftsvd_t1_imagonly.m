load 'test2.mat';

rf=rf';

rf=rf-mean(mean(rf));

noisyrf=rf+(rand(size(rf))-0.5)*1*max(max(rf));

tic
RF=imag(fft2(rf));
%RF=RF(1:end/2,1:end/2);
toc

noisyRF=imag(fft2(noisyrf));

[u,s,v]=svd(RF,'econ');
mx=max(max(s));
s(s<mx*.1)=0;
RFinv=v*pinv(s)*u';

[u,s,v]=svd(rf,'econ');
mx=max(max(s));
s(s<mx*.1)=0;
rfinv=v*pinv(s)*u';


O=ifft2(RFinv*noisyRF);
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