function w_all = calculate_synaptic_change_1(durationTime, preFR,postFR)
dt = 1e-3;
[PreSpikes,~] = poissonSpikeGen(preFR,durationTime,1,dt);
[PostSpikes,~] = poissonSpikeGen(postFR,durationTime,1,dt);

preSpikesTime = find(PreSpikes)*dt;
postSpikesTime = find(PostSpikes)*dt;

PreSpikesFr = length(preSpikesTime);
PostSpikesFr = length(postSpikesTime);

% merageSpikesSize = PreSpikesFr+PostSpikesFr;
% merageSpikes = zeros(1, merageSpikesSize);
% timeDiffs = zeros(PreSpikesFr,PostSpikesFr);
clear timeDiffs w_changes
timeDiffs = repmat(postSpikesTime,length(preSpikesTime),1) - repmat(preSpikesTime',1,length(postSpikesTime));
w_changes = stdp_curve(timeDiffs);
w_all = sum(sum(w_changes,1));


