function w_near = calculate_synaptic_change_3(durationTime, preFR,postFR)
dt = 1e-3;
[PreSpikes,~] = poissonSpikeGen(preFR,durationTime,1,dt);
[PostSpikes,~] = poissonSpikeGen(postFR,durationTime,1,dt);

preSpikesTime = find(PreSpikes)*dt;
postSpikesTime = find(PostSpikes)*dt;


clear timeDiffs w_changes
timeDiffs = repmat(postSpikesTime,length(preSpikesTime),1) - repmat(preSpikesTime',1,length(postSpikesTime));
w_near = 0;
for i = 1:length(preSpikesTime)
    t = timeDiffs(i,:);
    t_near = [max(t(t<0)) min(t(t>=0))];
    w_near = w_near + sum(stdp_curve2(t_near));
end


end