%Written by Morteza Heydari Araghi

%runs sureliteComm 2 times to make sure the command is executed.

function response=sureliteCommX2(serial,command,acceptedCommands)

if nargin<3
      sureliteComm(serial,command);
  response=sureliteComm(serial,command);
    
else
  sureliteComm(serial,command,acceptedCommands);
  response=sureliteComm(serial,command,acceptedCommands);
end
end
