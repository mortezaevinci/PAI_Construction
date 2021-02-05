%Written by Morteza Heydari Araghi

function RF=fixRF(RF,PAIheader)
    if  size(RF,2)>PAIheader.numofpoints
       RF=RF(:,1:PAIheader.numofpoints);
    end
    
    switch PAIheader.inputType
    case {'PAI128','DAQ128'}
        RF=offsetRF(RF,-8000);
    end
    %do logbook stuff here

      %only for testing..., remove later on
        if size(RF,1)<PAIheader.numoftra
           RF((size(RF,1)+1):int32(PAIheader.numoftra),:)=zeros(int32(PAIheader.numoftra)-size(RF,1),size(RF,2));
            disp('WARNING: The RF size does not match PAI setup. The RF will be resized to fit, but this would give wrong results.');
        end
     
        if size(RF,1)>PAIheader.numoftra
           RF=RF(1:PAIheader.numoftra,:);
            disp('WARNING: The RF size does not match PAI setup. The RF will be resized to fit, but this would give wrong results.');
        end
end