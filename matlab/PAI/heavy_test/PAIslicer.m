function []=PAIslicer(matrix,xyzsize,filename)
%matrix is the pseudoinv matrix, loaded as a variable
%xyzsize is [xsize ysize zsize] compatible with the pseudoinv (object)
%filename is a filemane ( with directory) that will be concatenated with sliced names


pp=1:(xyzsize(1)*xyzsize(2)*xyzsize(3));

pp=reshape(pp,[xyzsize(1),xyzsize(2),xyzsize(3)]);

for dim=1:3
   for val=1:xyzsize(dim)
       
            switch dim
                case 1
                    ppsliced=pp(val,:,:);
                    dims=[xyzsize(2),xyzsize(3)];
                case 2
                    ppsliced=pp(:,val,:);
                    dims=[xyzsize(1),xyzsize(3)];
                case 3
                    ppsliced=pp(:,:,val);
                    dims=[xyzsize(1),xyzsize(2)];
            end
            ppsliced=reshape(ppsliced,[1 dims(1)*dims(2)]);
            matslice=matrix(ppsliced,:);
            
           
            save([filename '_dimension' num2str(dim) '_plane' num2str(val) '.mat'],'matslice');
            
   end
end