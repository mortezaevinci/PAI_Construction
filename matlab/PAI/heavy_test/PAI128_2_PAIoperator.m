function PAIoperator=PAI128_2_PAIoperator(PAI128directory,PAIheader)
objectsize=PAIheader.xsize*PAIheader.ysize*PAIheader.zsize;

PAIoperator=zeros(objectsize,PAIheader.numoftra*PAIheader.numofpoints);


for i=1:objectsize
    
    blocktext=num2str(i-1,'%05d');
    
    [~,DAQsettings,~]=importPAI128([PAI128directory '\' blocktext '.pai128']);
    rf=DAQ128settings2RF(DAQsettings);
	rf=fixRF(rf,PAIheader);
    rf=reshape(rf',1,40*PAIheader.numofpoints);
    PAIoperator(i,:)=rf;

    disp([num2str(i) ' out of ' num2str(objectsize) ' done.']);
end