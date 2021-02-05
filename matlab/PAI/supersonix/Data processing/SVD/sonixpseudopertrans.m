function [pseudoinvq] = sonixpseudopertrans(P)
% Calculates pseudoinv of IOraw on a per transducer basis (i.e. treat system as parallel instead of series)
%   -use when not enough memory
%   -filter according to sens per trans
%   Inputs: file locations for loading IO/usv or saving usv/pseudoinv (if empty, does not load/save)  
%       threshperc = values below given percent of max are zeroed
% 

v2struct(P)

etol = P.etol;
regularize = P.regularize;

% For fewer time indices
if twindow > 0
    numpoints = length(twindow(1):twindow(2));
else
    numpoints = ceil(numofpoints/pta);
end

% Generate USV if doesn't exist
if exist(file.usvfile, 'file') == 0
    % Preallocate
    sv = zeros(numpoints,numoftra,'single');
    uv = zeros(numpoints,numpoints,numoftra,'single');
    vv = zeros(numofvoxels,numpoints,numoftra,'single');
    buffer = matfile(file.IOfile);

    % Per transducer
    tic
    parfor i = 1:numoftra/2
        % Load IO
        IO = buffer.IOraw(:,1+(i-1)*numpoints:i*numpoints);
        
        % QSVD
        [u,s,v] = qsvd(double(abs(IO))',etol); %rectify                       
        
        [m,~] = size(s);                    
        t1 = padarray(diag(s),[numpoints-m 0],'post');
        t2 = padarray(u,[0 numpoints-m],'post');
        t3 = padarray(v,[0 numpoints-m],'post');
        
        % Store USV                
        sv(:,i) = t1;
        uv(:,:,i) = t2;
        vv(:,:,i) = t3;                 
    end
    parfor i = numoftra/2+1:numoftra
        % Load IO
        IO = buffer.IOraw(:,1+(i-1)*numpoints:i*numpoints);

        % QSVD
        [u,s,v] = qsvd(double(abs(IO))',etol); %rectify                       
        
        [m,~] = size(s);                    
        t1 = padarray(diag(s),[numpoints-m 0],'post');
        t2 = padarray(u,[0 numpoints-m],'post');
        t3 = padarray(v,[0 numpoints-m],'post');
        
        % Store USV                
        sv(:,i) = t1;
        uv(:,:,i) = t2;
        vv(:,:,i) = t3;                 
    end    
    toc
    
    % Save USV
    save(file.usvfile,'uv','vv','sv','-v7.3')
end

% Compute pseudoinverse
% Preallocate
buffer1 = matfile(file.usvfile);    
pseudoinvq = zeros(xsize*ysize*planes,numpoints,numoftra,'single');

tic
parfor i = 1:numoftra/2
    % Load S
    sv = nonzeros(buffer1.sv(:,i));

    % Regularize singular values
    x = sv(1,1); 
    thresh = regularize*x;
    sv(sv<thresh) = 0;    
    
    % Place sv along diagonal of matrix        
    sz = length(sv);
    s = zeros(sz,sz);
    s(logical(eye(sz))) = sv;        
    
    % Load UV
    v = (squeeze(buffer1.vv(:,1:sz,i)));
    u = (squeeze(buffer1.uv(:,1:sz,i)));       

    %%% TODO: Filter singular vectors (threshold/smooth) specifically u

    % Pseudoinverse of singular values
    sinv = zeros(sz,sz);
    sinv(logical(eye(nnz(s)))) = 1./(diag(s(1:nnz(s),1:nnz(s))));
    sinv = (sinv');   
    
    pq = v*sinv*u';    

    % Threshold
%     pq((abs(pq/max(abs(pq)))<(threshperc/100)))=0;

    % Pseudoinverse
    pseudoinvq(:,:,i) = pq;
end
parfor i = numoftra/2+1:numoftra
    % Load S
    sv = nonzeros(buffer1.sv(:,i));

    % Regularize singular values
    x = sv(1,1); 
    thresh = regularize*x;
    sv(sv<thresh) = 0;    
    
    % Place sv along diagonal of matrix        
    sz = length(sv);
    s = zeros(sz,sz);
    s(logical(eye(sz))) = sv;        
    
    % Load UV
    v = (squeeze(buffer1.vv(:,1:sz,i)));
    u = (squeeze(buffer1.uv(:,1:sz,i)));       

    %%% TODO: Filter singular vectors (threshold/smooth) specifically u

    % Pseudoinverse of singular values
    sinv = zeros(sz,sz);
    sinv(logical(eye(nnz(s)))) = 1./(diag(s(1:nnz(s),1:nnz(s))));
    sinv = (sinv');   
    
    pq = v*sinv*u';    

    % Threshold
%     pq((abs(pq/max(abs(pq)))<(threshperc/100)))=0;

    % Pseudoinverse
    pseudoinvq(:,:,i) = pq;
end
toc

% Save pseudoinv 
save(pseudofile,'pseudoinvq','-v7.3')