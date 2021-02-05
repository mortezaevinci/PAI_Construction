%modified by Morteza Heydari Araghi

function PAIoperator=sonixRF2PAIoperator(RF,PAIheader)

numofvoxels=PAIheader.xsize*PAIheader.ysize*PAIheader.zsize;

        PAIoperator = zeros(PAIheader.numofpoints,numofvoxels,'single'); 

        % load sonixdata (all voxels per channel)
for i= 0:PAIheader.numoftra-1
   
    NM2=reshape(RF(1,:),PAIheader.numofpoints,PAIheader.avg,numofvoxels);
    
    %Averaging
    NM3 = mean(NM2,2);
    NM5 = squeeze(NM3);
    
    NM5(NM5<PAIheader.threshcutoff & NM5>-PAIheader.threshcutoff)=0;
    
    if PAIheader.rectify
        NM5=abs(NM5);
    end
       
    %Assemble Matrix
    PAIoperator(i*(PAIheader.numofpoints)+1:(i+1)*(PAIheader.numofpoints),:) = NM5'; 
end

end