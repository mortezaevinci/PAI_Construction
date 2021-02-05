%Written by Morteza Heydari Araghi

function RF=DAQ2RF(filetouse,PAIheader,sonixDAQheader)



        switch PAIheader.inputType
            case {'DAQs','nDAQs'}
                if nargin<3
                    sonixDAQheader.headersize=3;
                end
                
                disp('WARNING: This section is incomplete. DAQsRF.');
                
                RF=DAQs2RF(filetouse,sonixDAQheader.numSamples,sonixDAQheader.headersize,PAIheader.numoftra);
            case 'DAQx'
                RF=DAQx2RF(filetouse);
            case 'DAQ128'
                %DAQsettings=importDAQ128(filetouse);
                [~,DAQsettings,~]=importPAI128(filetouse);
                RF=DAQ128settings2RF(DAQsettings);

        end



end