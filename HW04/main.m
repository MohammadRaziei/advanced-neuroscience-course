%% Loading data
% First : run bellow command to generate loaded data.
% run generate_data; 
clc;clear;close all;
load('generated_data.mat')
toF = fs/(2*pi);
%% a
i = 0; wins = 200; ncov = 195; fwins = 200;
% % pspectrum(y,fs,'spectrogram','Leakage',1,'OverlapPercent',0,'TimeResolution',0.1)
for ch = [2,7,12,20,26,32,40,48]
    if mod(i,4) == 0 
        disp('new figure');
        figure('Color','w'); 
        i = 0;
    end
    i = i + 1
    subplot(2,4,i)
    [s, w, t] = spectrogram(mean_raw_signals(ch,:), wins, ncov, fwins, fs, 'yaxis', 'Minthreshold', -10);
    imagesc(t,w,abs(s)); colorbar;
    title({['Channel = ' num2str(ch)],'' ,'Raw signal'}) 
    ylabel('Frequency'); xlabel('Time');
    subplot(2,4,i+4)
    [s, w, t] = spectrogram(mean_noiseless_signals(ch,:), wins, ncov, fwins, fs, 'yaxis', 'Minthreshold', -10);
    imagesc(t,w,abs(s)); colorbar;
    title('Without Noise');
    ylabel('Frequency'); xlabel('Time');

end
%% a 
figure('Color','w','ToolBar','none','MenuBar','none'); 

subplot(121)
[psd, w] = pwelch(mean_raw_signals',fs);
imagesc(1:numChann,w*fs/(2*pi),(psd)); colorbar;
title('Raw signal') 
ylabel('Frequency'); xlabel('Channel');

subplot(122)
[psd, w] = pwelch(mean_noiseless_signals',fs);
imagesc(1:numChann,w*toF,(psd)); colorbar;
title('Noiseless signal') 
ylabel('Frequency'); xlabel('Channel');

% % close all;
% % % figure;spectrogram(y,[re],fs,'yaxis');
% % % [s,f2,t] = spectrogram(y,fs,'yaxis');
% % % imagesc(t,f2,20*(abs(s)));
% % % figure;spectrogram(signal,fs,'yaxis');
% % 
% % [s, w, t] = spectrogram(signal, wins, ncov, fwins, fs, 'yaxis', 'Minthreshold', -10);
% % imagesc(t,w,abs(s)); colorbar

%% b
% valid_idx = floor(lenSig/25):floor(lenSig/2);
% freq_dominants = max_addr
[noiseless_psd, w] = pwelchTrial(noiseless_signals, fs);
%%
dominant_freq = zeros(numChann, numCleanTrial);
for ch = 1:numChann
    for tr = 1:numCleanTrial
        [~, idx] = max(noiseless_psd(ch, tr, :));
        dominant_freq(ch, tr) = w(idx)*toF;
    end
end
mean_dominant_freq = mean(dominant_freq, 2);
map_mean_dominant_freq = mean_dominant_freq(ChannelPosition(:,2:10));
%%
figure('Color','w','ToolBar','none','MenuBar','none'); 
subplot(2,3,[1,2,4,5]);
imagesc(map_mean_dominant_freq);
colorbar;
grid_on(0.5:9.5,0.5:9.5)
xticks(1:9); yticks(1:5);
xticklabels(cellstr(string(2:10)))
% cbh=colorbar('v');
% set(cbh,'YTick', 0:6, 'YTickLabel',{'NaN','0','30','60','90','120','150'})
subplot(2,3,3)
hist(mean_dominant_freq(:),100);
subplot(2,3,6)
hist(dominant_freq(:),100);

%% d
i = 0;
most_dominant_freq = zeros(1,numChann);
for ch = 1:numChann
    if mod(i,8) == 0
        figure('Color','w','ToolBar','none','MenuBar','none'); 
        i = 0;
    end
    i = i + 1;
    subplot(2,4,i);
        hist(dominant_freq(ch,:),100);
        [h,hh] = hist(dominant_freq(ch,:),100);
        [~,h] = max(h);
        most_dominant_freq(ch) = hh(h);
        title({['Channel : ' num2str(ch)], ['The Most Dominant Freq is ' num2str(hh(h))]});
        xlabel('Frequency')    
end
%%
figure('Color','w','ToolBar','none','MenuBar','none');
subplot(121)
    map_most_dominant_freq = most_dominant_freq(ChannelPosition(:,2:10));
    imagesc(map_most_dominant_freq);
    colorbar;
    grid_on(0.5:9.5,0.5:9.5)
    xticks(1:9); yticks(1:5);
    xticklabels(cellstr(string(2:10)))
subplot(122)
    hist(most_dominant_freq,50);
    [h,hh] = hist(most_dominant_freq,50);
    [~,h] = max(h);
    title(['The Most Common Domminant Frequency : ' num2str(hh(h))]);
    






