function PAIoperator=RF2PAIoperator(RF,PAIheader)

numofvoxels=PAIheader.xsize*PAIheader.ysize*PAIheader.zsize;

        PAIoperator = zeros(numofvoxels,PAIheader.numofpoints*PAIheader.numoftra,'single'); 

        % load sonixdata (all voxels per channel)
for i= 1:PAIheader.numoftra
   i
    transdata=RF(i,:);
    transdata=reshape(transdata',PAIheader.numofpoints,[])';
   
    %Assemble Matrix
    PAIoperator(:,(i-1)*PAIheader.numofpoints+1:(i)*PAIheader.numofpoints) = transdata; 
end

end




% ***FULL VERSION BUT NOT WORKING
% function PAIoperator=RF2PAIoperator(RF,PAIheader)
% 
% numofvoxels=PAIheader.xsize*PAIheader.ysize*PAIheader.zsize;
% 
%         PAIoperator = zeros(numofvoxels,PAIheader.numofpoints*PAIheader.numoftra,'single'); 
% 
%         % load sonixdata (all voxels per channel)
% for i= 0:PAIheader.numoftra-1
%    i
%     NM2=reshape(RF(i+1,:),PAIheader.numofpoints,PAIheader.avg,numofvoxels);
%     
%     %Averaging
%     NM3 = mean(NM2,2);
%     NM5 = squeeze(NM3);
%     
%     NM5(NM5<PAIheader.threshcutoff & NM5>-PAIheader.threshcutoff)=0;
%     
%     if PAIheader.rectify
%         NM5=abs(NM5);
%     end
%        size(PAIoperator)
%     %Assemble Matrix
%     PAIoperator(i*(PAIheader.numofpoints)+1:(i+1)*(PAIheader.numofpoints),:) = NM5'; 
% end
% 
% end