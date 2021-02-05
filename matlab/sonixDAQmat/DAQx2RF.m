%Written by Morteza Heydari Araghi

%converts DAQx files to RF files
function RF=DAQx2RF(DAQxfile)


f = fopen(DAQxfile, 'r');
header = fread(f,9,'int32');
sumTriggers = header(2);
numTriggers = header(3);
numChannels = header(4);
numPoints   = header(5);

if (sumTriggers == 1)
reshaped = fread(f, [numPoints, numChannels], 'int32');
RF = reshape(reshaped,numChannels, numPoints)/numTriggers;
else
reshaped = fread(f, [numPoints*numTriggers, numChannels], 'int32');
RF = reshape(reshaped,numChannels, numPoints*numTriggers);
end

fclose(f);



end