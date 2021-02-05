%Written by Morteza Heydari Araghi

%provides statistics for the acquisition from realDAQ++

%only allinfo or numTriggers is implemented in realDAQ++
function result=sonixDAQstat(stat,sonixDAQheader)

cmdline=['realdaq++ hpfBypass=' num2str(sonixDAQheader.hpfBypass) ' fixedTGC=' num2str(sonixDAQheader.fixedTGC) ' biasCurrent=' num2str(sonixDAQheader.biasCurrent) ' pgaGain=' num2str(sonixDAQheader.pgaGain) ' lnaGain=' num2str(sonixDAQheader.lnaGain) ' divisor=' num2str(sonixDAQheader.divisor) ' numSamples=' num2str(sonixDAQheader.numSamples) ' sum=' num2str(sonixDAQheader.sum) ' lineDuration=' num2str(sonixDAQheader.lineDuration) ' verbose=0 externalTrigger=' num2str(sonixDAQheader.externalTrigger) ' remote=' num2str(sonixDAQheader.remote) ' remotePath=' sonixDAQheader.remotePath ' tempPath=' sonixDAQheader.tempPath ' data=' sonixDAQheader.data ' stat=' stat];
cmdline=regexprep(cmdline,'\','\\\');
%cmdline=[sonixDAQheader.realDAQdir '\' cmdline];
[status,result]=system(cmdline);


end