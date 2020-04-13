clc;
dt = 1e-4;
winTime = 60e-3;
lenWin = round(winTime/dt);
win = hamming(lenWin);
t = -1.2:dt:2;
% u = 1;
trialNum = 6;

for u = [1]%,50,154,250,350,450]
    u
    figure;
    for c = 1:trialNum
        
        subplot(3,2,c)
        title(['condition ' num2str(c)])
        idx = single(Unit(u).Cnd(c).TrialIdx);
        mean_firing_rate = zeros(size(t));
        for i = idx
            spikeMat = zeros(size(t));
            trl = Unit(u).Trls{i,1};
            spikeMat(round(((trl+1.2+dt)/dt))) = 1;
            spikeMat(length(t)+1:end) = [];
            x = filtfilt(win,1,spikeMat) / dt;
            mean_firing_rate = x + mean_firing_rate;
            plot(x,'--','color',0.8*ones(1,3))
            title(['condition ' num2str(c)])
            hold on
            grid on;            
        end
         plot(mean_firing_rate/length(idx),'r')
    end
end