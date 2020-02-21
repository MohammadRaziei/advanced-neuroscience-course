fr = 5;
tSim = 1;
nTrials = 1000;
dt = 0.001;
[spikeMat, tVec] = poissonSpikeGen(fr, tSim, nTrials, dt);

% plotRaster(spikeMat, tVec, 'Plot', 'b')

% figure;hist(sum(spikeMat,2))


% Pr = @(lt, k) l^k/factorial(k) exp(-lt);

% plot(Pr(1

% h = hist(sum(spikeMat,2));
% mean(h)


for i = 1:length(tVec)
new(i,:) = spikeMat(:,i);
end

x = diff(find(new));

hist(x)










