clc

 load trakstardata_real2;
 
 
 
 thresh=1;
 imgset=1:size(trakstardata,1);
 
 sizei=500;
 sizej=500;
 sizek=500;
 
 imin=sizei/2;jmin=sizei/2;kmin=sizei/2;
 imax=sizei;jmax=sizej/2;kmax=sizek/2;
 
 gridgap=2;
  
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
 
  tic;
  
  
  
 for ii=imgset
     
     
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
 
 %record minmax
 [imin,imax]=fixrange(imin,imax,max(Xspace(1,:)));
 [imin,imax]=fixrange(imin,imax,min(Xspace(1,:))); 
 [jmin,jmax]=fixrange(jmin,jmax,max(Xspace(2,:)));
 [jmin,jmax]=fixrange(jmin,jmax,min(Xspace(2,:)));
 [kmin,kmax]=fixrange(kmin,kmax,max(Xspace(3,:)));
 [kmin,kmax]=fixrange(kmin,kmax,min(Xspace(3,:)));

 end
 t_imgtogrid=toc
 
 
 %correct grid size
 
 
 grid=grid(imin:gridgap:imax,jmin:gridgap:jmax,kmin:gridgap:kmax);
 sizei=size(grid,1);
 sizej=size(grid,2);
 sizek=size(grid,3);
 
 

%slice
figure
 set(gcf,'Renderer','OpenGL');
 
[x,y,z] = meshgrid(1:sizej,1:sizei,1:sizek);

xslice = [50]; yslice = [50 120]; zslice = [100];
slice(x,y,z,grid,xslice,yslice,zslice)
shading interp
daspect([1 1 1]); 
axis tight
colormap gray
camlight


