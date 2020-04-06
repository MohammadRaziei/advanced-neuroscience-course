function [newChan,WholeSlopes] = PinkNoiseCanc2(chan,Time,StopFreq)
% cancelling pink noise
%% initial values
NumChans = length(chan);
Freqs = linspace(-1,1,length(Time));
StopIdx = find(Freqs>StopFreq);
StopIdx = StopIdx(1);
LinFreqs = Freqs(ceil(length(Time)/2)+1:StopIdx);
WholeSlopes = zeros(NumChans,1); % in dB
WholeZeroCross = zeros(NumChans,1); % in dB

%% find slope of pink noise line for each channel
for iChan=1:NumChans
    SignalMat = chan(iChan).lfp;
    NumTrials = size(SignalMat,2);
    WholeFFT = fftshift(fft(SignalMat));
    LinearLogAbs = WholeFFT(ceil(length(Time)/2)+1:StopIdx,:);
    LinearLogAbs = 20*log10(abs(LinearLogAbs));
    slopee = 0;
    zcross = 0;
    for iTri=1:NumTrials
        b = regress(LinearLogAbs(:,iTri),[LinFreqs' ones(length(LinFreqs),1)]);
        slopee = slopee+b(1);
        zcross = zcross+b(2);
    end
    WholeSlopes(iChan) = slopee/NumTrials;
    WholeZeroCross(iChan) = zcross/NumTrials;
end
%% filtfilt based on slopes
%{
newChan = struct;
for iChan=1:NumChans
    clc;disp(iChan);
    d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',...
        0.01,StopFreq,StopFreq+0.001,1,-(StopFreq-0.1)*WholeSlopes(iChan)/4,1,-0.5*WholeSlopes(iChan));
    Bandpass = design(d,'butter','SystemObject',true);
    [zz,pp,kk] = zpk(Bandpass);
    zz(zz==1) = 0.9;
    [bb,aa] = zp2tf(zz,pp,kk);
    
    SignalMat = chan(iChan).lfp;
    NumTrials = size(SignalMat,2);
    for iTri=1:NumTrials
        newChan(iChan).lfp(:,iTri) = filtfilt(bb,aa,SignalMat(:,iTri));
    end
end
%}
newChan = struct;
for iChan=1:NumChans
    clc;disp(iChan);
    
    SignalMat = chan(iChan).lfp;
    NumTrials = size(SignalMat,2);
    WholeFFT = fftshift(fft(SignalMat));
    
    FilterGains = 10.^((WholeSlopes(iChan)*abs(Freqs)+WholeZeroCross(iChan))/20);
    %FilterGains(abs(Freqs)>StopFreq) = 10^(WholeZeroCross(iChan)/20);
    
    for iTri=1:NumTrials
        newChan(iChan).lfp(:,iTri) = real(ifft(ifftshift(WholeFFT(:,iTri)./FilterGains')));
    end
end
end







