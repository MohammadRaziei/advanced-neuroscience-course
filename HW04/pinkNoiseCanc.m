function [output, p] = pinkNoiseCanc(signal,fs)
plot_flag = false;
lenSig = length(signal);
signal = reshape(signal,lenSig,1);

f = fftshift(linspace(-fs/2,fs/2,lenSig)');
psd = fft(signal);

% valid_idx = floor(lenSig/25):floor(lenSig/2);
valid_idx = 2:floor(lenSig/2);
log_f = log(f(valid_idx));
log_psd = log(abs(psd(valid_idx)));

p = polyfit(log_f,log_psd,1);
if(plot_flag)
    log_psd_hat = polyval(p,log_f);
    figure;
    plot(log_f,log_psd,'--')
    hold on
    plot(log_f,log_psd_hat)
    hold off
end
ref = f.^(-p(1))/exp(p(2));

output = real(ifft(psd.*ref));
if(plot_flag)
    figure;
    pwelch(output)
end

end