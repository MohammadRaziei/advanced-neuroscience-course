%% Loading Data
load('Data/ArrayData.mat')
load('Data/CleanTrials.mat')
fs = 200;%Hz
numChann = length(chan);
[lenSignal, numTrial] = size(chan(1).lfp);
numCleanTrial =  length(Intersect_Clean_Trials);

%% pink noise removal
raw_signals = zeros(numChann,numCleanTrial,lenSignal);
noiseless_signals = zeros(numChann,numCleanTrial,lenSignal);
noise_coff = zeros(numChann,numCleanTrial,2);

for ch = 1:numChann
    for tr = 1:numCleanTrial
        y = chan(ch).lfp(:,Intersect_Clean_Trials(tr));
        raw_signals(ch,tr,:) = y;
        [psd,w] = pwelch(y);
        f = w * fs/(2*pi);
        [y, p] = pinkNoiseCanc(y, fs);
        noiseless_signals(ch,tr,:) = y;
        noise_coff(ch,tr,:) = p;
    end
    ch/numChann * 100    
end

mean_raw_signals = squeeze(mean(raw_signals,2));
mean_noiseless_signals = squeeze(mean(noiseless_signals,2));

save('generated_data.mat',...
    'ChannelPosition', 'Intersect_Clean_Trials', 'Time' ,...
    'raw_signals','noiseless_signals','mean_raw_signals','mean_noiseless_signals','noise_coff',...
    'fs', 'numChann', 'numTrial', 'lenSignal', 'numCleanTrial');