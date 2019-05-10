function r = multcorr(A,B)
% correlates columns of matrix A with columns of matrix B
% r will be of size 1 X nCol
%
% Christoph Daube, 2014, Toulouse
% christoph.daube@gmail.com

    az = bsxfun(@minus,A,mean(A));
    bz = bsxfun(@minus,B,mean(B));
    r = sum(az.*bz)./sqrt(sum(az.^2).*sum(bz.^2));
end
