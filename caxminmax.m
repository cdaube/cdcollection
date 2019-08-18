function caxminmax
% changes the range of plotted values in an imagesc plot to abs(min max) of all values
% combine this with fMap = flipud(cbrewer('div','RdBu',256)) as colourmap for nicest results!
%
% Christoph Daube, 2019, christoph.daube@gmail.com

    thsAxes = gca;
    thsLim = thsAxes.CLim;
    thsExt = max(abs(thsLim));
    set(thsAxes,'CLim',[-max(thsExt) max(thsExt)])
