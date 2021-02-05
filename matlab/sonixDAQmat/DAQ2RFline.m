%Written by Morteza Heydari Araghi

function RFline=DAQ2RFline(DAQfile,seeker,size)

    fid = fopen(DAQfile, 'r');
    %header = fread(fid,headersize,'int32');
    fseek(fid,seeker,'cof');
    RFline= (fread(fid, [1, size], 'int16'));
        fclose(fid);
    
    
    
end