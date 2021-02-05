%Written by Morteza Heydari Araghi

function [err,result]=sonixDAQinit(sonixDAQheader,mode);

if nargin<2
    mode='';
end
%loadlibrary('jc_sonix');
%calllib('jc_sonix','main','');

%init
disp('initializing sonixDAQ...');
cmdline=['realdaq++.exe fw=' sonixDAQheader.daq_fw ' verbose=' num2str(sonixDAQheader.verbose) ' init=' num2str(sonixDAQheader.activeDAQ) ' ' mode];
cmdline=regexprep(cmdline,'\','\\\');
%cmdline=['cmd /c "' sonixDAQheader.realDAQdir '\' cmdline '"']
[status,result]=system(cmdline);

disp(result);

if isempty(strfind(result,'Error'))
    err=0;
else
    err=1;
end
    
end