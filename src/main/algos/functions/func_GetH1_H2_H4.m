function [H1, H2, H4, isComplete] = func_GetH1_H2_H4(y, Fs, F0, variables, textgridfile)
    % Input:  y, Fs - from wavread
    %         F0 - vector of fundamental frequencies
    %         variables - global settings
    %         textgridfile - this is optional
    % Output: H1, H2, H4 vectors
    %         isComplete - flag to indicate if the process was allowed to
    %         finish
    % Notes:  Function is quite slow! Use textgrid segmentation to speed up the
    % process.
    %
    % Author: Yen-Liang Shue, Speech Processing and Auditory Perception Laboratory, UCLA
    % Copyright UCLA SPAPL 2009

    % Modified by KS 2013-08-05
    TAG = 'func_GetH1_H2_H4 : ';
    N_periods = variables.Nperiods;
    sampleshift = (Fs / 1000 * double(variables.frameshift));
    H1 = zeros(length(F0), 1) * NaN;
    H2 = zeros(length(F0), 1) * NaN;
    H4 = zeros(length(F0), 1) * NaN;
    isComplete = 0;
    if (nargin == 4) % don't use Textgrid
        printf('%s not using textgrids\n', TAG);
        for k=1:length(F0)
            ks = round(k * sampleshift);        
            if (ks <= 0 || ks > length(y))
                continue;
            endif
            F0_curr = F0(k);
            if (isnan(F0_curr) || F0_curr == 0)
                continue;
            endif
            N0_curr = 1 / F0_curr * Fs;     
            ystart = round(ks - N_periods/2*N0_curr);
            yend = round(ks + N_periods/2*N0_curr) - 1;
            if (ystart <= 0) 
                continue; 
            endif
            if (yend > length(y)) 
                continue; 
            endif
            yseg = y(ystart:yend)';
            % what are f0, dummpy for? FIXME?
            [h1, f0] = func_GetHarmonics(yseg, F0_curr, Fs);
            [h2, dummy] = func_GetHarmonics(yseg, 2*F0_curr, Fs); 
            [h4, dummy] = func_GetHarmonics(yseg, 4*F0_curr, Fs);
            H1(k) = h1;
            H2(k) = h2;
            H4(k) = h4;
        endfor
    else % otherwise, use TextGrid
        % get the labels to ignore from the settings
        ignorelabels = textscan(variables.TextgridIgnoreList, '%s', 'delimiter', ',');
        ignorelabels = ignorelabels{1};
        tbuffer = variables.tbuffer;
        [labels, start, stop] = func_readTextgrid(textgridfile);
        labels_tmp = [];
        start_tmp = [];
        stop_tmp = [];
        for k=1:length(variables.TextgridTierNumber)
            inx = variables.TextgridTierNumber(k);
            if (inx <= length(labels))
                %labels_tmp = [labels_tmp; labels{inx}];
                labels_tmp = [labels{inx}];
                start_tmp = [start_tmp; start{inx}];
                stop_tmp = [stop_tmp; stop{inx}];
            end
        end
        labels = labels_tmp;
        start = start_tmp;
        stop = stop_tmp; 
        for m=1:length(start)
            switch(labels{m})
                case ignorelabels
                    continue;  % skip anything that is within the ignore list
            endswitch
            kstart = round((start(m) * 1000 - tbuffer) / variables.frameshift);
            kstop = round((stop(m) * 1000 + tbuffer) / variables.frameshift);
            kstart(kstart <= 0) = 1;
            kstop(kstop > length(F0)) = length(F0);   
            ystart = round(kstart * sampleshift);
            ystop = round(kstop * sampleshift);
            ystart(ystart <= 0) = 1;
            ystop(ystop > length(y)) = length(y);
            F0seg = F0(kstart:kstop);
            ysegment = y(ystart:ystop);
            for k=1:length(F0seg)
                ks = round(k*sampleshift);
                if (ks <= 0 || ks > length(ysegment))
                    continue;
                endif
                F0_curr = F0seg(k);
                if (isnan(F0_curr) || F0_curr == 0)
                    continue;
                endif
                N0_curr = Fs/F0_curr;
                ysstart = round(ks - N_periods/2 * N0_curr);
                ysend = round(ks + N_periods/2 * N0_curr) - 1;
                if (ysstart <= 0) 
                    continue; 
                endif
                if (ysend > length(ysegment)) 
                    continue; 
                endif
                yseg = ysegment(ysstart:ysend)';
                [h1, f0] = func_GetHarmonics(yseg, F0_curr, Fs);
                [h2, dummy] = func_GetHarmonics(yseg, 2*F0_curr, Fs);
                [h4, dummy] = func_GetHarmonics(yseg, 4*F0_curr, Fs);
                inx = kstart + k - 1;
                if (inx <= length(H1))
                    H1(inx) = h1;
                    H2(inx) = h2;
                    H4(inx) = h4;
                endif
            endfor
        endfor
    endif
    isComplete = 1;
end %endfunction


% % this function is used from 1/8/09 onwards - optimization used
% %--------------------------------------------------------------------------
% function [h,fh]=func_GetHarmonics(data,f_est,Fs)
% see func_GetHarmonics.m

% This function was used up to 1/8/09
% %--------------------------------------------------------------------------
% function [h,f]=func_GetHarmonics_old(x,f_est,Fs,df_range)
% % find harmonic magnitudes in dB of time signal x
% % around a frequency estimate f_est
% % Fs, sampling rate
% % x,  input row vector (is truncated to the first 25ms)
% % df_range, optional, default +-5% of f_est

% df = 0.1;     % search around f_est in steps of df (in Hz)
% if nargin<4
%     df_range = round(f_est*0.1); % search range (in Hz)
% end
% f = f_est-df_range:df:f_est+df_range;
% f = f(:);     % make column vector

% %x = x(1:round(Fs*0.025));  % analyze 25ms
% %x = hamming(length(x)).*x;
% n = 0:length(x)-1;
% v = exp(-i*2*pi*f*n/Fs);
% h = 20*log10(abs(x' * v.' ));
% %figure; plot(f,h);
% [h,inx]=max(h);
% f=f(inx);
