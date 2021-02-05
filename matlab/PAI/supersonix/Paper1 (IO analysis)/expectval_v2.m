function [EX,stndv,snr] = expectval_v2(CT,P,down,cf,thresh_range)

% Initialize
fieldNames = {'fieldNames', 'xsize','ysize','planes', 'numofvoxels'};
v2struct(P,fieldNames)

% Preallocate
EX = zeros(length(thresh_range),length(down));
stndv = zeros(length(thresh_range),length(down));
snr = zeros(length(thresh_range),length(down));

CT= abs(CT);    

if cf > 0
    % Correction using MT
    CT = bsxfun(@rdivide,CT,cf);
end 

% Normalize to diagonal
nrm = diag(CT);
CT= bsxfun(@rdivide,CT,nrm');    

for i = 1:3    
    % Downsample
    dsample = down(i);
    
    if planes > 1
        [X,Y,Z] = meshgrid(1:xsize/dsample,1:xsize/dsample,1:planes/dsample);
    else
        [X,Y,Z] = meshgrid(1:xsize/dsample,1:xsize/dsample,1:planes);
    end

    x0 = reshape(X,[],1); 
    y0 = reshape(Y,[],1); 
    z0 = reshape(Z,[],1);

    dim = [x0,y0,z0];   
    
    if dsample > 1 && planes > 1
        vox = reshape(CT,xsize,ysize,planes,xsize,ysize,planes);
        vox = vox(1:xsize/dsample,1:xsize/dsample,1:planes/dsample,1:xsize/dsample,1:xsize/dsample,1:planes/dsample);
        vox = reshape(vox,numofvoxels/dsample^3,[]);        
    elseif dsample == 1                           
        vox = reshape(CT,numofvoxels,[]);
    end       
    
    counter1 = 1;
    for thold = thresh_range 
        % Threshold
        vox(vox<thold) = 0;                  

        % "Accuracy" (Expected value/first moment)
        xdim = sum(bsxfun(@times,vox,x0))./sum(vox,1); 
        ydim = sum(bsxfun(@times,vox,y0))./sum(vox,1); 
        zdim = sum(bsxfun(@times,vox,z0))./sum(vox,1);

        pos = [xdim' ydim' zdim'];

        % Calculation
        matrix = pos - dim;
        Acc = squeeze(sqrt(sum(matrix.^2,2))); 
        Acc = mean(Acc);
        EX(counter1,i) = Acc;        

        % "Precision" (central moment)
        dx = (x0-xdim'); dy = (y0-ydim'); dz = (z0-zdim');
        varx = sum(bsxfun(@times,vox,dx))./sum(vox,1); 
        vary = sum(bsxfun(@times,vox,dy))./sum(vox,1); 
        varz = sum(bsxfun(@times,vox,dz))./sum(vox,1); 
        stnd = [varx' vary' varz'];
        
        % Calculation
        Prec = squeeze(sqrt(sum(stnd.^2,2)));
        Prec = mean(Prec);
        stndv(counter1,i) = Prec;
        
        counter1 = counter1 +1;
    end    
    
    clear vox
end

% ======================================
%         % SNR     
%         SNR = vox;
%         SNR(logical(eye(length(vox)))) = [];
%         SNR = reshape(SNR,length(vox)-1,[]);                   
%         SNR = std(SNR);
%         SNR = diag(vox)./SNR'; 
%         snr(1,i) = mean(SNR);

        
%         % SNR
%         SNR = reshape(CT,1,[]);
%         SNR(1:numofvoxels+1:end) = [];
%         SNR = reshape(SNR,numofvoxels-1,[]);                   
%         SNR = std(SNR);
%         SNR = diag(reshape(CT,numofvoxels,[]))./SNR'; 
%         snr(1,i) = mean(SNR); 
%         clear SNR  