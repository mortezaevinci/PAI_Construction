%Written by Morteza Heydari Araghi

function output=PAIreconstruct(input,Hinv,PAIheader)

 %PARAMETERS


if strcmp(PAIheader.reconstructionType,'i1')
    
disp('WARNING: ''i1'' is obsolete. Use ''generic'' for PAIheader.reconstructionType.');

end

if strcmp(PAIheader.reconstructionType,'generic') || strcmp(PAIheader.reconstructionType,'i1')
    

    
    %PARAMETERS
    numoftra=PAIheader.numoftra;
    numofpoints=(numoftra)*PAIheader.numofpoints;
    pta=PAIheader.pta;
    
    RF=input;
    
     RF=abs(RF);
    RF(abs(RF)<PAIheader.thresholdCutoff)=0;
   
    
    %Pseudoinverse subset for one plane
    %  pseudoinv2=pseudoinv((243400:(243400+6240)),:);

        I2=sum(reshape(RF',[pta ((numofpoints)/pta)]))';
        object=(Hinv)*(I2);
        
        object(object<PAIheader.objectThreshold)=0;

        size(object)
        [PAIheader.xsize PAIheader.ysize PAIheader.zsize]
        output=reshape(object,[PAIheader.xsize PAIheader.ysize PAIheader.zsize]); % reshape to object space dimension
        %%% Plot image
        
    
end

if strcmp(PAIheader.reconstructionType,'test3d')
    
    RF=input;
    
    %PARAMETERS
    numofvoxels=1;
    numoftra=PAIheader.numoftra;
    numofpoints=(numoftra-1)*PAIheader.numofpoints;
    pta=PAIheader.pta;
    
    %RF(abs(RF)<threshcutoff)=0;
    %Pseudoinverse subset for one plane
    %  pseudoinv2=pseudoinv((243400:(243400+6240)),:);
    for h=0;
        
        for j=1:PAIheader.numofpoints:numofvoxels*PAIheader.numofpoints;
            NM1=RF(1:(numoftra-1),j+(h*PAIheader.numofpoints):j+(PAIheader.numofpoints-1)+(h*PAIheader.numofpoints));
            ab = NM1';
            
            I2=sum(reshape(ab,[pta ((numofpoints)/pta)]));
            %Rectify
            I2c= abs(I2);
        end
        
        object=(Hinv)*(I2c)';
        
        object(object<0)=0;
        output=reshape(object,[PAIheader.xsize PAIheader.ysize PAIheader.zsize]); % reshape to object space dimension
        %%% Plot image
        
    end
    
    
    
    
end


if strcmp(PAIheader.reconstructionType,'test6060')
    
    RF=input;
    
    %PARAMETERS
    numofvoxels=1;
    numofpoints=128000;
    numoftra=128;
    pta=1;
    usstart=4;
    usend=1000;
    threshcutoff=20;
    
    RF(abs(RF)<threshcutoff)=0;
    %Pseudoinverse subset for one plane
    %  pseudoinv2=pseudoinv((243400:(243400+6240)),:);
    for h=0;
        
        for j=1:1000:numofvoxels*1000;
            NM1=RF(1:128,j+(h*1000):j+999+(h*1000));
            ab = NM1';
            %NM2=reshape(ab,1,numofpoints);
            
            I2=(reshape(ab,[pta ((numofpoints)/pta)]));
            %Rectify
            I2c= abs(I2);
        end;
        
    
        object=(Hinv)*(I2c)';
        
        object(object<0)=0;

        output=reshape(object,[60 60]); % reshape to object space dimension
        %%% Plot image
        
    end
    %Saving pseudo
    %save ('pseudoinversesubset79x79.mat','pseudoinv2','-v7.3')
    
end

if strcmp(PAIheader.reconstructionType,'sampleCube')
    output=zeros(40,40,40);
    output(10:15,10:15,10:15)=50;

end


