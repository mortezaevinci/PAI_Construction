%Written by Morteza Heydari Araghi

function serialout=sureliteCommInit(header)
disp('Initializing surelite...');   
%close port if already open
   out1 = instrfind('Port',header.serialport);
   if ~isempty(out1)
   fclose(out1);
   end
   
         %serial init
    serialout=serial(header.serialport,'baudrate',header.serialbaud,'terminator',10);
    
    %open serial
    fopen(serialout);
   
end