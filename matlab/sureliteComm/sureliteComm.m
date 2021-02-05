%Written by Morteza Heydari Araghi

%sends serial commands, and receives responds 

%order of commnads: ST 1 (or ST 0 is off), SH 1 (0 is off), PD 001, QS 420
%order for shutting off is reverse


function response=sureliteComm(serial,command,acceptedCommands)


    %function init
    if nargin<3
       acceptedCommands.SE='SE';
       acceptedCommands.SC='SC';
       
    end
    
    
    returncount=0;
    response='';

    
    %send command
   fprintf(serial,'%s\r',command);
    
    %response back
    if (strcmp(command,acceptedCommands.SE)) ||(strcmp(command,acceptedCommands.SC))
        disp('Warning: SE or SC command initiated. this part is not implemented.');
        
        
    else
        while(serial.BytesToOutput)
            
        end
        
    end
        
 
end