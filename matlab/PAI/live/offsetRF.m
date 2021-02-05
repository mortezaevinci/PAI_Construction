function RF=offsetRF(RF,offset)
if nargin<2

RF=RF-mean(mean(RF));
else
   RF=RF+offset; 
end
end