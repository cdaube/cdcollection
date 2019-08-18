function caxminmax
    thsAxes = gca;
    thsLim = thsAxes.CLim;
    thsExt = max(abs(thsLim));
    set(thsAxes,'CLim',[-max(thsExt) max(thsExt)])