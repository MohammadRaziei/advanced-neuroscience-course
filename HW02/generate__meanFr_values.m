load('UnitsData.mat');

dt = 1e-4;
winTime = 60e-3;
lenWin = winTime/dt;
win = hamming(lenWin);
t = -1.2:dt:2;
% u = 1;
trialNum = 6;

for u = 1:length(Unit)
    u
    for c = 1:trialNum
        
        subplot(3,2,c)
        title(['condition ' num2str(c)])
        idx = Unit(u).Cnd(c).TrialIdx;
        mean_firing_rate = zeros(size(t));
        for i = idx
            spikeMat = zeros(size(t));
            trl = Unit(u).Trls{i,1};
            spikeMat(round(((trl+1.2+dt)/dt))) = 1;
            spikeMat(length(t)+1:end) = [];
            x = filtfilt(win,1,spikeMat) / dt;%* lenWin / wintime;
            mean_firing_rate = x + mean_firing_rate;
            
%             plot(x,'y')
%             title(['condition ' num2str(c)])
%             hold on
            
        end
%          meanFr
         mean_fr = mean_firing_rate/length(idx);
         meanFr(u,c,:) = mean_fr;
         values(u,c,:) = Unit(u).Cnd(c).Value;
         notValid(u,c,:) = (mean(mean_fr)/max(mean_fr) < 0.1);
    end
end

save('meanFr_values2.mat', 'meanFr', 'values', 'dt', 't', 'winTime','notValid')