function [] = plotRaster(spikeMat, tVec, Tit, col)
figure;
hold all;
for trialCount = 1:size(spikeMat,1)    
    spikePos = tVec(spikeMat(trialCount, :));    
    for spikeCount = 1:length(spikePos)        
        plot([spikePos(spikeCount) spikePos(spikeCount)], ...            
            [trialCount-0.4 trialCount+0.4], col);    
    end
end
ylim([0 size(spikeMat, 1)+1]);
xlabel('time (sec)');
ylabel('trial number');
title(Tit);
end