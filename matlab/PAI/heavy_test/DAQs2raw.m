
function RF=DAQs2RF(DAQdirectory,samplesize,iteration,headersize)

if nargin==1
    headersize=3;
    samplesize=inf;
    iteration=0;
end

if nargin==2
    headersize=3;
    iteration=0;
end

if nargin==3
    headersize=3;
end

if nargin>4
    disp('Error: Wrong number of input arguments.');
    return;
end

% 128 channels by 2000 points, change the number of points if changed in
% the DAQ Demo software

fid = fopen([DAQdirectory '\CH000.daq'], 'r');
header = fread(fid,headersize,'int32');
samplesize=min(samplesize,header(2)*header(3));

A= (fread(fid, [1, samplesize], 'int16'));
fclose(fid);
R = 128;
[N, C] =size(A);
RF=zeros(R,C);



for i=0:127
    %[S,ERRMSG]=sprintf('CH%03d.daq',i);
    
    fid = fopen([DAQdirectory '\CH' num2str(i,'%03d') '.daq'], 'r');
    %header = fread(fid,headersize,'int32');
    fseek(fid,headersize*4+iteration*samplesize*2,'cof');
    A= (fread(fid, [1, samplesize], 'int16'));
    RF(i+1,:)=A;
    fclose(fid);
    
    if samplesize>10000
        disp(['Reading file # ' num2str(i)]);
    end
end

end