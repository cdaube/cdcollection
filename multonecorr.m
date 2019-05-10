function r = multonecorr(matrix,toRep)
% nCol(toRep) has to be 1
% nRow(toRep) has to be nRow(matrix)
% r will be of size 1 X nCol in matrix
%
% Christoph Daube, 2014, Toulouse
% christoph.daube@gmail.com

    A = matrix;
    B = repmat(toRep,1,size(matrix,2));
    az = bsxfun(@minus,A,mean(A));
    bz = bsxfun(@minus,B,mean(B));
    r = sum(az.*bz)./sqrt(sum(az.^2).*sum(bz.^2));
end
