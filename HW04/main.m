%% Loading data
% First : run bellow command to generate loaded data.
% run generate_data; 
clc;clear;close all;
load('generated_data.mat')
toF = fs/(2*pi); toN = 2/fs; toD = 180/pi;
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
    title({['The Most Common Domminant Frequency : ' num2str(hh(h)) 'Hz'],['With ' num2str(mean(most_dominant_freq)) 'Hz as its mean']});
    

%% PART II
filtered_noiseless_signals = zeros(numChann, numCleanTrial, lenSignal);
filtered_noiseless_complex = zeros(numChann, numCleanTrial, lenSignal);
for ch = 1:numChann
    for tr = 1:numCleanTrial
        fh = most_dominant_freq(ch);
        fw = min(fh/2,8);
        [b,a] =  butter(2,[fh-fw, fh+fw]*toN,'bandpass');
    %     [b,a] =  butter(5,0.5*2/fs,'high');
        x = filtfilt(b,a,noiseless_signals(ch,tr,:));
        filtered_noiseless_signals(ch,tr,:) = x;
        y = hilbert(x);
        filtered_noiseless_complex(ch,tr,:) = y;

    end
end
%%
figure('Color','w','ToolBar','none','MenuBar','none');
chose_ch = 3; chose_tr = 337;
plot(Time,squeeze(noiseless_signals(chose_ch,chose_tr,:))*1e3 ,...
    Time,squeeze(filtered_noiseless_signals(chose_ch,chose_tr,:))*1e3)
title(['Channel : ' num2str(chose_ch) '  ,  Trial : ' num2str(Intersect_Clean_Trials(chose_tr))]);
xlabel('Time'); ylabel('Amplitude(mv)');
% ylim([-1,1]*5);
xlim([min(Time),max(Time)]);
legend('before filtering', 'after filtering');

%%

%%
map_filtered_noiseless_phase = zeros(5,9,lenSignal);
pgd_vec = zeros(1,lenSignal);
grad_u = zeros(5,9,lenSignal);
grad_v = zeros(5,9,lenSignal);
grad_d = zeros(5*9,lenSignal);
for i = 1:lenSignal
    y = squeeze(filtered_noiseless_complex(:, chose_tr,i));
    y = angle(y(ChannelPosition(:,2:10)));
    [u,v] = gradient(y);
    grad_u(:,:,i) = u;
    grad_v(:,:,i) = v;
    d = complex(u(:), v(:));
    grad_d(:,i) = d;
    map_filtered_noiseless_phase(:,:,i) = y;
    pgd_vec(i) = 0.27+6*(norm(mean(d))/mean(norm(d)));
    
end
%%
% chose_x = 
% close all
videoFig = figure('Color','w','ToolBar','none','MenuBar','none', 'units','normalized','outerposition',[0 0 1 1]);
videoFileName = 'myVideoFile';
% if exist([videoFileName '.mp4'], 'file')==2
%   delete([videoFileName '.mp4']);
% end
myVideo = VideoWriter(videoFileName,'MPEG-4'); %open video file
myVideo.FrameRate = 20;  
cmap = gray(128);
try
open(myVideo)
for i = 1:lenSignal
    clf
%     y = squeeze(filtered_noiseless_complex(:, chose_tr,i));
%     y = y(ChannelPosition(:,2:10));
    subplot(2,4,[1 2]);
%     s = (angle(y)*toD);
    s = map_filtered_noiseless_phase(:,:,i);
    imagesc(cos(s));
%     imagesc(abs(map_filtered_noiseless_phase(:,:,i)));
    caxis([-1,1]); colormap(cmap) ;colorbar
%     phasemap(100); 
%     phasebar('location','se')
    xticks(1:9); yticks(1:5);
    xticklabels(cellstr(string(2:10)))
    title(['time : ' num2str(Time(i),'%.3f') ' (s)']);
    
    subplot(2,4,[3 4])
    plot(Time, pgd_vec);
    hold on
    plot(Time(i), pgd_vec(i), 'x','LineWidth', 3);
    ylim([0,1]);
    
    subplot(2,4,[5 6]);
%     [u,v] = gradient(s);
    u = grad_u(:,:,i);
    v = grad_v(:,:,i);
%     [x,y] = meshgrid(1:5,2:10);
    quiver(u,v);
    xlim([0,10]); ylim([0,6]);
    
    subplot(2,4,7)
    d = angle(grad_d(:,i));
    polarhistogram((d),16);

    subplot(2,4,8)
%     d = geomean(d/abs(d));
    m = complex(mean(cos(d)), mean(sin(d)));
    m = m / abs(m);
    quiver(real(m), imag(m));
    xlim([0,2]); ylim([0,2]);

    
    pause(1/fs) %Pause and grab frame
%     frame = getframe(gcf); %get frame
    frame = getframe(videoFig);
    writeVideo(myVideo, frame);
end
catch
close(myVideo);
end
close(myVideo); close(videoFig);

