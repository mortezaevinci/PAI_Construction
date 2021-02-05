load 'C:\temp\organized tests\sonixDAQ-based\scan1 2013-11-21\Hsmall_3of5_32sensors';
rf=H';




rf=rf-mean(mean(rf));


load 'C:\temp\organized tests\sonixDAQ-based\scan2 2013-11-21\Hsmall_3of5_32sensors';
noisyrf=H';
%noisyrf=rf+(rand(size(rf))-0.5)*.1*max(max(rf));


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

o{1}=frfinvf*noisyrf;
o{2}=rfinv*noisyrf;
o{3}=frfinv*noisyrf;
o{4}=rfinvf*noisyrf;




for ii=1:4
    o{ii}(o{ii}<0)=0;
    figure; imagesc(o{ii});
    
e=sum(sum(I-o{ii}))


ae=sum(sum(abs(I-o{ii})))


de=sum(diag(I-o{ii}))


ade=sum(abs(diag(I-o{ii})))

end

%conditions
e1=eig(frfinvf*frfinvf');
cond1=(max(e1)/min(e1))^0.5

e1=eig(rfinv*rfinv');
cond1=(max(e1)/min(e1))^0.5

e1=eig(rfinvf*rfinvf');
cond1=(max(e1)/min(e1))^0.5


I=eye(size(rf,2));



