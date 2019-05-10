function [periodo,f] = fftrtr(sig,sr,varargin)
%fftrtr(sig,sr,[draw fBound]) gives what you actually want from an fft
% needs
%   sig - double, 1XN, signal to be ffted
%   sr - double, 1X1, sample rate of signal
%
% optional inputs
%   draw - logical, indicating that periodogram should be plotted 
%          default is black
%   fBound - upper boundary of frequency to be included in plot
%   aBound - upper boundary of amplitude to be included in plot
%   myCol - colour triplet
%
% gives
%   periodogram - double, single sided amplitude spectrum
%   f - corresponding frequency vector
%
% Christoph Daube, June 2015, for DeCo

    if nargin >= 3
        for ii = 3:2:nargin
            switch varargin{ii-2}
                case 'myCol'
                    myCol = varargin{ii-1};
                case 'draw'
                    draw = varargin{ii-1};
                case 'fBound'
                    fBound = varargin{ii-1};
                case 'aBound'
                    aBound = varargin{ii-1};
            end
        end
    end

    L = numel(sig); % length of signal
    
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(sig,NFFT)/L;
    f = sr/2*linspace(0,1,NFFT/2+1);
    
    periodo = 2*abs(Y(1:NFFT/2+1));
    
    if ~exist('myCol','var'); myCol = [0 0 0]; end
    if ~exist('aBound','var'); aBound = max(periodo); end
    if ~exist('fBound','var'); fBound = max(f); end
    if ~exist('draw','var'); draw = false; end
    
    if draw
        plot(f,periodo,'Color',myCol)
            xlim([0 fBound])
            ylim([0 aBound])
        xlabel('Frequency [Hz]')
    end

end

