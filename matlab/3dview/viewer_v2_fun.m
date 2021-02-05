function viewer_v2_fun(trakstardata) %#codegen

 
 thresh=30;
 imgcount=size(trakstardata,1);
 
 sizei=500;
 sizej=500;
 sizek=500;
 
 grid=zeros(sizei,sizej,sizek);
 
 
 %find the reference transformation based on the first image
 %get one set of trakstar data
 [t_x,t_y,t_z,t_phi,t_theta,t_psai]=parsetkdata(trakstardata(1,:));
 
 %find ref transformation at origin
 Hc_refo=homogenous(t_x,t_y,t_z,t_phi,t_theta,t_psai);
 
  %base transformation
  Hc_base=homogenous(sizei/2,sizej/2,sizek/2,0,0,0);
  
  %update ref transformation from base
  Hc_ref=ref2ref(Hc_refo,Hc_base);
 
 for ii=1:imgcount
     
     
 I = imread('pout.tif');
 I=imresize(I,.5);
 
 %preprocess
 I=imadjust(I);
 
 [i,j]=find(I>thresh);
 %k will be just zero the same size of i
 %k=abs(ceil(randn(1)*20*ones(size(i),1)))+1;
 k=zeros(size(i));
 
 %get next set of trakstar data
 [t_x,t_y,t_z,t_phi,t_theta,t_psai]=parsetkdata(trakstardata(ii,:));
  
 %find transformation
 Hc_raw=homogenous(t_x,t_y,t_z,t_phi,t_theta,t_psai);

 
 %update transformation from reference
 [Hc]=ref2ref(Hc_ref,Hc_raw);
 
 %update i,j,k by transformation into 3d coordinates
 Xspace=ceil(image2space([i';j';k'],Hc));
 
 %cut the out of limit
 goodind=indexinlimit(Xspace,[sizei;sizej;sizek]);
 
 Xspace=Xspace(:,goodind);
 i=i(goodind);
 j=j(goodind);
 
 %update grid
 gindex=(Xspace(3,:)-1)*sizei*sizej+(Xspace(2,:)-1)*sizei+Xspace(1,:);
 grid(gindex)=I((j-1)*size(I,1)+i);

 end


 %create pointcloud
 [pcp]=find(grid);
 pck=1+pcp/sizej/sizei;
 h=mod(pcp,sizej*sizei);
 pcj=1+h/sizei;
 pci=mod(h,sizei);
 pcv=grid(pcp);
 

 %draw pointcloud
 figure
 set(gcf,'Renderer','OpenGL');
 colordef(gcf,'black')
 
     c=double(pcv)/255;
scatter3(pci,pcj,pck, 10, c, 'fill')
colormap('Gray');
axis([0 sizei 0 sizej 0 sizek]);
 

 

end