function w_near = calculate_synaptic_change_2(durationTime, preFR,postFR)
dt = 1e-3;
[PreSpikes,~] = poissonSpikeGen(preFR,durationTime,1,dt);
[PostSpikes,~] = poissonSpikeGen(postFR,durationTime,1,dt);

preSpikesTime = find(PreSpikes)*dt;
postSpikesTime = find(PostSpikes)*dt;

% PreSpikesFr = length(preSpikesTime);
% PostSpikesFr = length(postSpikesTime);

% merageSpikesSize = PreSpikesFr+PostSpikesFr;
% merageSpikes = zeros(1, merageSpikesSize);
% timeDiffs = zeros(PreSpikesFr,PostSpikesFr);
clear timeDiffs w_changes
timeDiffs = repmat(postSpikesTime,length(preSpikesTime),1) - repmat(preSpikesTime',1,length(postSpikesTime));
w_near = 0;
for i = 1:length(preSpikesTime)
    t = timeDiffs(i,:);
    t_near = [max(t(t<0)) min(t(t>=0))];
    w_near = w_near + sum(stdp_curve(t_near));
end
% w_changes = stdp_curve(timeDiffs);







end