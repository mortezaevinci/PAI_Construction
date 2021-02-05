function [xmin,xmax]=fixrange(curxmin,curxmax,newx)
xmin=curxmin;   
xmax=curxmax;

if newx>curxmax
       xmax=newx;
   end 
      
if newx<curxmin
    xmin=newx;
    
end

end