function shiftedMat = shiftbyidx(inputMat,shiftIdx)
% shiftbyidx shifts each column of the input matrix by the number of 
% positions indicated in the corresponding element of shiftIdx
% 
% needs
%   inputMat - 2D/3D matrix whose columns will be shifted
%   shiftIdx - vector (row or column doesn't matter) whose length must
%       match the number of columns in inputMat
%
% gives
%   shiftedMat - matrix of the same size as inputMat with shifted columns
%
% based on an improvement of an idea by Andrei Boborov by Matt J:
% http://www.mathworks.com/matlabcentral/answers/79169-circshift-the-columns-of-an-array-with-different-shiftsize-withou-using-for-loop
%
% Christoph Daube, August 2015, for sweep
    

    [m,n,o] = size(inputMat);
    
    b = mod(bsxfun(@plus,(0:m-1).',-shiftIdx(:).' ),m)+1;
    b = bsxfun(@plus,b,(0:n-1)*m);
    b = bsxfun(@plus,b,permute((0:o-1)*(n*m),[3 1 2]));

    shiftedMat = inputMat(b);

end