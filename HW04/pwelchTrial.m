function [p,w] = pwelchTrial(sig,fs)
    for i = 1:size(sig,1)
       [p0,w0] = pwelch(squeeze(sig(i,:,:))', fs);
       p(i,:,:) = p0';
%        w(i,:,:) = w0;
    end
    w = w0';
end