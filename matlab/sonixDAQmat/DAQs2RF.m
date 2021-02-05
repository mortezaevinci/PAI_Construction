%Written by Morteza Heydari Araghi


function RF=DAQs2RF(DAQdirectory,samplesize,headersize,numOfFiles)

if nargin<2

    samplesize=inf;

end

if nargin<3
    headersize=3;
end

if nargin<4
    numOfFiles=128;
end


if nargin>4
    disp('Error: Wrong number of input arguments.');
    return;
end



RF=zeros(numOfFiles,samplesize);


seeker=headersize*4;
size=samplesize;

    
    for i=0:(numOfFiles-1)
        %[S,ERRMSG]=sprintf('CH%03d.daq',i);
        DAQfile=[DAQdirectory '\CH' num2str(i,'%03d') '.daq'];
         RF(i+1,:)=DAQ2RFline(DAQfile,seeker,size);
       
    end
    

end