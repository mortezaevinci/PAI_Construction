%Written by Morteza Heydari Araghi

function result=sonixDAQstop(sonixDAQheader);


cmdline=['realdaq++ stop=' num2str(sonixDAQheader.activeDAQ)];
%cmdline=[sonixDAQheader.realDAQdir '\' cmdline];
[status,result]=system(cmdline,'-echo');
   
    
end