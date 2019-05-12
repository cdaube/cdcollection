function [hl,hr] = shadederror(x,plotData,varargin)
% plots the mean of plotData over units of observation as a function of
% conditions together with a shaded region indicating the +- standard error
% needs: 
% x - vector containing the x spacing (conditions)
% plotData - as many rows as conditions in x, as many columns as you have
%   data points, entries in the 3rd dimension will be plotted as separate
%   lines
% distinguishable_colors.m by Timothy E. Holy (function that generates
%   maximally distinguishable colours)
%
% returns:
% hl - handle to individual lines of central tendencies
% hr - handle to individual shaded regions
%
% optional inputs ['name',var]:
% Color - matrix indicating colour of lines; columns are RGB, rows refer to
%   separate lines if plotData has a third dimension
%   default is black/grey
% fillAlpha - opacity of shaded region
%   default is .05
% meanmeasure - measure used for central tendency
%   default is median
% errormeasure - measure used for error
%   options are: SEM, var, std, ci95, ci99, range, (percentile) bootstrap
%   default is bootstrap
% nBoot - number of samples for bootstrap
%   default is 10000
% prcboot - percentile to be plotted of bootstrap distribution
%    default is 95
% lineWidth - thickness of line for central tendency
%   default is 1 
% lineStyle - Style of line for central tendency
%   default is solid
% yyAxis - indicates if left or right y axis should be used (handy if two
%   data of 2 different units is to be plotted in the same plot
%   default is left
% aiFlag - if set to 1, no facealpha property will be manipulated which
%   increases compatibility to adobe illustrator
%
% Christoph Daube, started in Oldenburg in 2014 (for evaluation of tACs
% data), continued in aout 2014, Toulouse (for EEG prestimulus phase data), 
% continued in 2015 in Leipzig for MSc thesis, continued during PhD in
% Glasgow 2016 -- 2019

    % fetch optional arguments
    fixedArgs = 2;
    if nargin >= fixedArgs+1
        for ii = fixedArgs+1:2:nargin
            switch varargin{ii-fixedArgs}
                case 'Color'
                    fillColor = varargin{ii-(fixedArgs-1)};
                case 'fillAlpha'
                    fillAlpha = varargin{ii-(fixedArgs-1)};
                case 'meanmeasure'
                    meanMeas = varargin{ii-(fixedArgs-1)};
                case 'errormeasure'
                    errMeas = varargin{ii-(fixedArgs-1)};
                case 'nBoot'
                    nBoot = varargin{ii-(fixedArgs-1)};
                case 'prcBoot'
                    prcBoot = varargin{ii-(fixedArgs-1)};
                case 'lineWidth'
                    lineWidth = varargin{ii-(fixedArgs-1)};
                case 'LineStyle'
                    lineStyle = varargin{ii-(fixedArgs-1)};
                case 'yyaxis'
                    yyAxisInd = varargin{ii-(fixedArgs-1)};
                case 'ai'
                    aiFlag = varargin{ii-(fixedArgs-1)};
            end
        end
    end
    
    % set defaults to unspecified optional arguments
    if ~exist('fillColor','var') && size(plotData,3)>1; fillColor = distinguishable_colors(size(plotData,3)); 
    elseif ~exist('fillColor','var') && size(plotData,3)==1; fillColor = [0 0 0]; end
    if size(fillColor,1) < size(plotData,3); fillColor = repmat(fillColor,[size(plotData,3) 1]); end
    if ~exist('aiFlag','var'); aiFlag = false; end
    if ~exist('meanMeas','var'); meanMeas = 'median'; end    
    if ~exist('errMeas','var'); errMeas = 'bootstrap'; end
    if ~exist('nBoot','var'); nBoot = 10000; end
    if ~exist('prcBoot','var'); prcBoot = 95; end
    if ~exist('lineWidth','var'); lineWidth = 1; end
    if ~exist('yyAxisInd','var'); yyAxisInd = []; end
    if ~exist('lineStyle','var'); lineStyle = '-'; end
    if ~exist('fillAlpha','var'); fillAlpha = .05; end

    if size(x,1) > size(x,2); x = x'; end
    
    plotData = permute(plotData,[2 1 3]);
    
    hl = gobjects(size(plotData,3),1);
    hr = gobjects(size(plotData,3),1);
    for ii = 1:size(plotData,3)

        thsData = plotData(:,:,ii);
        
        switch logical(true)
            case strcmpi(meanMeas,'mean')
                dataM = nanmean(thsData);
            case strcmpi(meanMeas,'median')
                dataM = nanmedian(thsData);
        end

        switch logical(true)
            case strcmpi(errMeas,'SEM')
                dataErrP = dataM+nanstd(thsData)./sqrt(sum(~isnan(thsData)));
                dataErrN = dataM-nanstd(thsData)./sqrt(sum(~isnan(thsData)));
            case strcmpi(errMeas,'var')
                dataErrP = dataM+nanvar(thsData);
                dataErrN = dataM-nanvar(thsData);
            case strcmpi(errMeas,'std')
                dataErrP = dataM+nanstd(thsData);
                dataErrN = dataM-nanstd(thsData);
            case strcmpi(errMeas,'ci95')
                dataErrP = dataM+(nanstd(thsData)./sqrt(sum(~isnan(thsData)))).*norminv(.975);
                dataErrN = dataM-(nanstd(thsData)./sqrt(sum(~isnan(thsData)))).*norminv(.975);
            case strcmpi(errMeas,'ci99')
                dataErrP = dataM+(nanstd(thsData)./sqrt(sum(~isnan(thsData)))).*norminv(.995);
                dataErrN = dataM-(nanstd(thsData)./sqrt(sum(~isnan(thsData)))).*norminv(.995);
            case strcmpi(errMeas,'range')
                dataErrP = max(thsData);
                dataErrN = min(thsData);
            case strcmpi(errMeas,'bootstrap')
                thsSample = datasample(thsData,size(thsData,1)*nBoot,1);
                switch logical(true)
                    case strcmpi(meanMeas,'mean')
                        thsMean = squeeze(mean(reshape(thsSample,[size(thsData,1) nBoot size(thsData,2)])));
                    case strcmpi(meanMeas,'median')
                        thsMean = squeeze(median(reshape(thsSample,[size(thsData,1) nBoot size(thsData,2)])));
                end
                dataErrP = prctile(thsMean,100-(100-prcBoot)/2,1);
                dataErrN = prctile(thsMean,(100-prcBoot)/2,1);
        end

        y1 = dataErrN;
        y2 = dataErrP;
        
        X = [x,fliplr(x)];
        Y = [y1,fliplr(y2)];

        if ~isempty(yyAxisInd)
            yyaxis(yyAxisInd)
        end
            
        hr(ii) = fill(X,Y,fillColor(ii,:));
        set(get(get(hr(ii),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        if ~aiFlag
            set(hr(ii),'facealpha',fillAlpha)
            set(hr(ii),'EdgeColor','none');
        end

        hold on
        hl(ii) = plot(x,dataM,'Color',fillColor(ii,:),'LineWidth',lineWidth,'lineStyle',lineStyle,'Marker','None');
    end

    hold off

end