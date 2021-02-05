load 'test2.mat';

rf=rf';

rf=rf-mean(mean(rf));

noisyrf=rf+(rand(size(rf))-0.5)*.1*max(max(rf));


s1=rf(:,1);

d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',.02,.05,.1,.13,40,1,40);
Hd = design(d,'equiripple');

fmat=H2mat(Hd.Numerator,numel(s1));

frf=(fmat*rf);

[u,s,v]=svd(rf,'econ');
mx=max(max(s));
s(s<mx*.01)=0;
rfinv=v*pinv(s)*u';


[u,s,v]=svd(frf,'econ');
s(s<mx*.01)=0;
frfinv=v*pinv(s)*u';

rfinvf=rfinv*fmat;

frfinvf=frfinv*fmat;

figure;imagesc(frfinvf*noisyrf);
figure;imagesc(rfinv*noisyrf);
figure;imagesc(frfinv*noisyrf);
figure;imagesc(rfinvf*noisyrf);

%conditions
e1=eig(frfinvf*frfinvf');
cond1=(max(e1)/min(e1))^0.5

e1=eig(rfinv*rfinv');
cond1=(max(e1)/min(e1))^0.5

e1=eig(rfinvf*rfinvf');
cond1=(max(e1)/min(e1))^0.5







I=eye(size(rf,2));

e1=sum(sum(I-frfinvf*noisyrf))
e2=sum(sum(I-rfinv*noisyrf))
e3=sum(sum(I-rfinvf*noisyrf))

ae1=sum(sum(abs(I-frfinvf*noisyrf)))
ae2=sum(sum(abs(I-rfinv*noisyrf)))
ae3=sum(sum(abs(I-rfinvf*noisyrf)))

de1=sum(diag(I-frfinvf*noisyrf))
de2=sum(diag(I-rfinv*noisyrf))
de3=sum(diag(I-rfinvf*noisyrf))

de1=sum(abs(diag(I-frfinvf*noisyrf)))
de2=sum(abs(diag(I-rfinv*noisyrf)))
de3=sum(abs(diag(I-rfinvf*noisyrf)))