%Written by Morteza Heydari Araghi

%simplifies commands for serial communication with laser
%possible commands: on, off

function output=sureliteCommSimple(serial,simpleCommand,header)

  if nargin<3
      header.QS='';
      header.PD='';
  end

   if strcmp(simpleCommand,'on')
        %turning on
               disp('turning laser on...');

sureliteCommX2(serial,['QS ' header.QS]);
pause(header.pauseval);
sureliteCommX2(serial,'ST 1');
pause(header.pauseval);
sureliteCommX2(serial,'SH 1');
pause(header.pauseval);
sureliteCommX2(serial,['QS ' header.QS]);
pause(header.pauseval);
sureliteCommX2(serial,['PD ' header.PD]);
pause(header.pauseval);

   end
   
    if strcmp(simpleCommand,'off')
      disp('turning laser off...')
     sureliteCommX2(serial,'PD 000');
    pause(header.pauseval);
    sureliteCommX2(serial,'SH 0');
    pause(header.pauseval);
    sureliteCommX2(serial,'ST 0');
    pause(header.pauseval);
    end
end