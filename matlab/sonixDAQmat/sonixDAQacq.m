%Written by Morteza Heydari Araghi

function err=sonixDAQacq(sonixDAQheader)

cmdline=['realdaq++ hpfBypass=' num2str(sonixDAQheader.hpfBypass) ' fixedTGC=' num2str(sonixDAQheader.fixedTGC) ' biasCurrent=' num2str(sonixDAQheader.biasCurrent) ' pgaGain=' num2str(sonixDAQheader.pgaGain) ' lnaGain=' num2str(sonixDAQheader.lnaGain) ' divisor=' num2str(sonixDAQheader.divisor) ' numSamples=' num2str(sonixDAQheader.numSamples) ' sum=' num2str(sonixDAQheader.sum) ' lineDuration=' num2str(sonixDAQheader.lineDuration) ' verbose=' num2str(sonixDAQheader.verbose) ' externalTrigger=' num2str(sonixDAQheader.externalTrigger) ' nAcq=' num2str(sonixDAQheader.nAcq) ' memMode=' num2str(sonixDAQheader.memMode) ' remote=' num2str(sonixDAQheader.remote) ' remotePath=' sonixDAQheader.remotePath ' tempPath=' sonixDAQheader.tempPath ' data=' sonixDAQheader.data ' acquire=' num2str(sonixDAQheader.activeDAQ) ' &'];
cmdline=regexprep(cmdline,'\','\\\');
%cmdline=[sonixDAQheader.realDAQdir '\' cmdline];
system(cmdline);


end