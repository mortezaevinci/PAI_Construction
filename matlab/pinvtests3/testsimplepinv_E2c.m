
load('\\fv\Optics_drive\Ivan\E2candpseudoinmay840x40x40.mat');

if size(E2c,1)<size(E2c,2)

tic
paa2=E2c'*(E2c*E2c')^-1;
toc
clear paa2;

else

tic
paa2=(E2c'*E2c)^-1*E2c';
toc
clear paa2;


end

drawnow;

tic
qsvd(E2c,1e-4);
toc