clc

 load trakstardata_3;
 
 thresh=120;
 imgset=1:size(trakdata,1);
 
 sizei=500;
 sizej=500;
 sizek=500;
 
 imin=sizei/2;jmin=sizei/2;kmin=sizei/2;
 imax=sizei;jmax=sizej/2;kmax=sizek/2;
  
 grid=zeros(sizei,sizej,sizek);
 
 
 %find the reference transformation based on the first image
 %get one set of trakstar data
 [t_x,t_y,t_z,t_phi,t_theta,t_psai]=parsetkdata(trakdata(1,:));
 
 %find ref transformation at origin
 Hc_refo=homogenous(t_x,t_y,t_z,t_phi,t_theta,t_psai);
 
  %base transformation
  Hc_base=homogenous(sizei/3,sizej/3,sizek/3,0,0,0);
  
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
 [t_x,t_y,t_z,t_phi,t_theta,t_psai]=parsetkdata(trakdata(ii,:));
  
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
 grid=grid(imin:imax,jmin:jmax,kmin:kmax);
 sizei=imax-imin+1;
 sizej=jmax-jmin+1;
 sizek=kmax-kmin+1;
 
 tic;
 %create pointcloud
[pci,pcj,pck,pcv]=grid2pc(grid);
 
 t_createpc=toc
 
 tic;
 %draw pointcloud
 figure
 set(gcf,'Renderer','OpenGL');
 colordef(gcf,'black')
 
     c=double(pcv)/255;
scatter3(pci,pcj,pck, 10, c, 'filled')
%plot3(pci',pcj',pck');
colormap('Gray');
axis tight;

 daspect([1 1 1]);  
 
t_draw=toc
 
% 
% %slice
% figure
%  set(gcf,'Renderer','OpenGL');
%  
% [x,y,z] = meshgrid(1:sizei,1:sizej,1:sizek);
% 
% xslice = [20,50]; yslice = 20; zslice = [30];
% slice(x,y,z,grid,xslice,yslice,zslice)
% shading interp
% daspect([1 1 1]); 
% axis tight
% colormap gray
% camlight
% set([h(1),h(2)],'ambientstrength',.6)


