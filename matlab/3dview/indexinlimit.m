function goodindex=indexinlimit(X,xyzlimits)
badX=X<1;
badX=badX|(X>repmat(xyzlimits,1,size(X,2)));

badX_1d=badX(1,:)|badX(2,:)|badX(3,:);

goodindex=find(badX_1d==0);
end