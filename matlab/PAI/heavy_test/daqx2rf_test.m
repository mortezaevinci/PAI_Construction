daqd='C:\temp';
daqxd='C:\temp\DAQxfiles\block00000.daqx';


loadsonixdata;
tic
rf2=DAQx2RF(daqxd);
toc
diff=rf2-RF;

